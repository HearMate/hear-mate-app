import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseRepository {
  final SupabaseClient _client;

  DatabaseRepository()
    : _client = SupabaseClient(
        dotenv.get('SUPABASE_URL'),
        dotenv.get('SUPABASE_ANON_KEY'),
      );

  Future<void> insertOrUpdateHeadphone({
    required String name,
    required double hz125Correction,
    required double hz250Correction,
    required double hz500Correction,
    required double hz1000Correction,
    required double hz2000Correction,
    required double hz4000Correction,
    required double hz8000Correction,
  }) async {
    // 1. Check if headphone with the exact same name exists
    final existingList = await _client
        .from('headphones')
        .select()
        .eq('name', name);

    if (existingList.isNotEmpty) {
      final existing = existingList.first;

      // 2. Average corrections and increment grade
      final updatedData = {
        'grade': (existing['grade'] as int) + 1,
        'hz_125_correction':
            ((existing['hz_125_correction'] as num).toDouble() +
                hz125Correction) /
            2,
        'hz_250_correction':
            ((existing['hz_250_correction'] as num).toDouble() +
                hz250Correction) /
            2,
        'hz_500_correction':
            ((existing['hz_500_correction'] as num).toDouble() +
                hz500Correction) /
            2,
        'hz_1000_correction':
            ((existing['hz_1000_correction'] as num).toDouble() +
                hz1000Correction) /
            2,
        'hz_2000_correction':
            ((existing['hz_2000_correction'] as num).toDouble() +
                hz2000Correction) /
            2,
        'hz_4000_correction':
            ((existing['hz_4000_correction'] as num).toDouble() +
                hz4000Correction) /
            2,
        'hz_8000_correction':
            ((existing['hz_8000_correction'] as num).toDouble() +
                hz8000Correction) /
            2,
      };

      await _client
          .from('headphones')
          .update(updatedData)
          .eq('id', existing['id'])
          .select();
    } else {
      // 3. Insert new headphone with grade 0
      await _client.from('headphones').insert({
        'name': name,
        'grade': 0,
        'hz_125_correction': hz125Correction,
        'hz_250_correction': hz250Correction,
        'hz_500_correction': hz500Correction,
        'hz_1000_correction': hz1000Correction,
        'hz_2000_correction': hz2000Correction,
        'hz_4000_correction': hz4000Correction,
        'hz_8000_correction': hz8000Correction,
      }).select();
    }
  }
}
