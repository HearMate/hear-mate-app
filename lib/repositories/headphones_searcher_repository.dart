import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/ebay_item.dart';
import 'package:hear_mate_app/modules/headphones_calibration/models/headphones_search_result.dart';
import 'package:hear_mate_app/utils/logger.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HeadphonesSearcherRepository {
  static const String _tokenUrl =
      'https://api.ebay.com/identity/v1/oauth2/token';
  static const String _searchUrl =
      'https://api.ebay.com/buy/browse/v1/item_summary/search';
  static const String _headphonesCategory = '112529';

  // For local storage.
  static const String _tokenKey = 'ebay_access_token';
  static const String _tokenExpiryKey = 'ebay_token_expiry';

  String? _cachedToken;
  DateTime? _tokenExpiry;

  static const Set<String> _ignoreWords = {
    'wireless',
    'bluetooth',
    'headphones',
    'refurbed',
    'black',
    'noise',
    'cancelling',
    'canceling',
    'over-ear',
    'industry',
    'leading',
    'stereo',
    'working',
    'battery',
    'pads',
    'ear',
    'gray',
    'grey',
    'plus',
    'and',
    'over',
    'the',
    'genuine',
    'new',
    'charging',
    'case',
    'right',
    'left',
    'replacement',
    'or',
    'usb-c',
    'side',
    'only',
    'best',
    'over-the-ear',
    'without',
    'anc',
    'no',
    'good',
    'oem',
    'for',
    'headphone',
    'hi-res',
    'new/sealed',
    'on',
  };

  Future<HeadphonesSearchResult> searchHeadphones({
    required String keyword,
    int limit = 5,
    bool newConditionOnly = true,
  }) async {
    try {
      // Get valid access token (from cache or new request)
      String accessToken = await _getValidAccessToken();

      // First attempt to search
      List<EbayItem>? items;
      try {
        items = await _searchItems(
          accessToken: accessToken,
          keyword: keyword,
          limit: limit,
          newConditionOnly: newConditionOnly,
        );
      } catch (e) {
        // If search fails due to authentication, re-authenticate and retry
        if (e.toString().contains('401') ||
            e.toString().contains('403') ||
            e.toString().contains('Authentication') ||
            e.toString().contains('Unauthorized')) {
          HMLogger.print(
            'Authentication failed, refreshing token and retrying...',
          );

          // Clear current token and get a new one
          await clearTokenCache();
          accessToken = await _refreshAccessToken();

          // Retry the search with new token
          items = await _searchItems(
            accessToken: accessToken,
            keyword: keyword,
            limit: limit,
            newConditionOnly: newConditionOnly,
          );
        } else {
          rethrow;
        }
      }

      // Extract model name from titles
      final extractedModel = _extractHeadphoneModel(
        items.map((item) => item.title).toList(),
      );

      return HeadphonesSearchResult(
        items: items,
        extractedModel: extractedModel,
      );
    } catch (e) {
      throw Exception('Failed to search headphones: $e');
    }
  }

  Future<String> _getValidAccessToken() async {
    // Check if we have a cached token that's still valid
    if (_cachedToken != null && _tokenExpiry != null) {
      if (DateTime.now().isBefore(
        _tokenExpiry!.subtract(const Duration(minutes: 5)),
      )) {
        return _cachedToken!;
      }
    }

    // Check local storage for saved token
    await _loadTokenFromStorage();
    if (_cachedToken != null && _tokenExpiry != null) {
      if (DateTime.now().isBefore(
        _tokenExpiry!.subtract(const Duration(minutes: 5)),
      )) {
        return _cachedToken!;
      }
    }

    // Get new token and save it
    return await _refreshAccessToken();
  }

  Future<void> _loadTokenFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_tokenKey);

      final expiryTimestamp = prefs.getInt(_tokenExpiryKey);
      if (expiryTimestamp != null) {
        _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryTimestamp);
      }
    } catch (e) {
      // If loading fails, we'll just get a new token
      _cachedToken = null;
      _tokenExpiry = null;
    }
  }

  Future<void> _saveTokenToStorage(String token, DateTime expiry) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      await prefs.setInt(_tokenExpiryKey, expiry.millisecondsSinceEpoch);
    } catch (e) {
      // If saving fails, we can still use the in-memory cache
      HMLogger.print('Warning: Failed to save token to storage: $e');
    }
  }

  Future<String> _refreshAccessToken() async {
    final String clientId = dotenv.get("EBAY_CLIENT_ID");
    final String clientSecret = dotenv.get("EBAY_CLIENT_SECRET");

    final credentials = base64Encode(utf8.encode('$clientId:$clientSecret'));

    final response = await http.post(
      Uri.parse(_tokenUrl),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'client_credentials',
        'scope': 'https://api.ebay.com/oauth/api_scope',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get access token: ${response.body}');
    }

    final data = json.decode(response.body);
    final token = data['access_token'] as String;
    final expiresIn = data['expires_in'] as int; // seconds

    final expiry = DateTime.now().add(Duration(seconds: expiresIn));

    _cachedToken = token;
    _tokenExpiry = expiry;

    await _saveTokenToStorage(token, expiry);

    return token;
  }

  Future<List<EbayItem>> _searchItems({
    required String accessToken,
    required String keyword,
    required int limit,
    required bool newConditionOnly,
  }) async {
    const NEW_ITEM_CONDITION = '1000';

    final queryParams = {
      'q': keyword,
      'limit': limit.toString(),
      'category_ids': _headphonesCategory,
      if (newConditionOnly) 'LH_ItemCondition': NEW_ITEM_CONDITION,
    };

    final uri = Uri.parse(_searchUrl).replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    HMLogger.print('Search API Status: ${response.statusCode}');

    if (response.statusCode != 200) {
      throw Exception(
        'API request failed with status ${response.statusCode}: ${response.body}',
      );
    }

    final data = json.decode(response.body);
    final itemSummaries = data['itemSummaries'] as List<dynamic>? ?? [];

    return itemSummaries
        .map((item) => EbayItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // This is completely heuristic function. We should improve it.
  String _extractHeadphoneModel(List<String> titles) {
    HMLogger.print(titles.toString());
    if (titles.isEmpty) return '';

    final tokenLists = <List<String>>[];

    final modelPattern = RegExp(
      r'[A-Za-z]+[0-9A-Za-z/-]*|[0-9]+',
      caseSensitive: false,
    );

    for (final title in titles) {
      // Remove price-like patterns
      var cleanTitle = title.replaceAll(
        RegExp(r'[\d,.]+\s*usd', caseSensitive: false),
        '',
      );

      // Extract tokens
      final matches = modelPattern.allMatches(cleanTitle);
      final tokens = matches.map((m) => m.group(0)!).toList();

      // Filter out ignored words
      final filteredTokens =
          tokens.where((t) => !_ignoreWords.contains(t.toLowerCase())).toList();

      tokenLists.add(filteredTokens);
    }

    // Count frequency across all titles
    final tokenCount = <String, int>{};
    for (final tokens in tokenLists) {
      for (final token in tokens) {
        tokenCount[token] = (tokenCount[token] ?? 0) + 1;
      }
    }

    // Keep tokens that appear at least once (you can adjust threshold if needed)
    final commonTokens =
        tokenCount.entries.where((e) => e.value >= 1).map((e) => e.key).toSet();

    // Preserve order from first title
    final firstTokens = tokenLists.isNotEmpty ? tokenLists[0] : <String>[];
    final modelTokens =
        firstTokens.where((t) => commonTokens.contains(t)).toList();

    final modelName = modelTokens.join(' ').toUpperCase();
    HMLogger.print("Model name: $modelName");
    return modelName;
  }

  /// Normalize a token by removing non-alphanumeric characters (except hyphens)
  String _normalizeToken(String token) {
    return token.replaceAll(RegExp(r'[^a-zA-Z0-9-]'), '').toLowerCase();
  }

  Future<void> clearTokenCache() async {
    _cachedToken = null;
    _tokenExpiry = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_tokenExpiryKey);
    } catch (e) {
      print('Warning: Failed to clear token from storage: $e');
    }
  }
}

/// Custom exception for authentication failures
class AuthenticationException implements Exception {
  final String message;

  AuthenticationException(this.message);

  @override
  String toString() => 'AuthenticationException: $message';
}
