import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hear_mate_app/features/headphones_search/models/headphones_model.dart';
import 'package:hear_mate_app/shared/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseRepository {
  late final SupabaseClient _client;

  DatabaseRepository() {
    _client = SupabaseClient(
      dotenv.get('SUPABASE_URL'),
      dotenv.get('SUPABASE_ANON_KEY'),
    );
  }

  Future<void> insertOrUpdateHeadphone({
    required String name,
    required double hz125Correction,
    required double hz250Correction,
    required double hz500Correction,
    required double hz1000Correction,
    required double hz2000Correction,
    required double hz4000Correction,
    required double hz8000Correction,
    required HeadphonesModel referenceHeadphone,
  }) async {
    try {
      // 3. Insert new headphone with grade 0
      final newHeadphone = HeadphonesModel.create(
        name: name.toUpperCase(),
        hz125Correction: hz125Correction,
        hz250Correction: hz250Correction,
        hz500Correction: hz500Correction,
        hz1000Correction: hz1000Correction,
        hz2000Correction: hz2000Correction,
        hz4000Correction: hz4000Correction,
        hz8000Correction: hz8000Correction,
      );

      Map<String, dynamic> newHeadphoneData = await newHeadphone.toInsertMap(
        referenceHeadphone,
      );
      final insertedList =
          await _client.from('allRecords').insert(newHeadphoneData).select();

      if (insertedList.isEmpty) {
        HMLogger.print('Failed to insert headphone: No rows returned');
      }
    } catch (e) {
      throw Exception('Failed to insert or update headphone "$name": $e');
    }
  }

  Future<HeadphonesModel?> searchHeadphone({required String name}) async {
    try {
      final response =
          await _client
              .from('headphones')
              .select()
              .ilike('name', name)
              .limit(1)
              .maybeSingle();

      if (response != null) {
        return HeadphonesModel.fromMap(response);
      }

      // No headphone found
      return null;
    } catch (e) {
      HMLogger.print('Error searching for headphone "$name": $e');
      return null;
    }
  }
}
