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
  }) async {
    try {
      // 1. Check if headphone with the exact same name exists
      final existingList = await _client
          .from('headphones')
          .select()
          .eq('name', name.toUpperCase())
          .limit(1);

      if (existingList.isNotEmpty) {
        // 2. Update existing headphone: average corrections and increment grade
        final existing = existingList.first;
        final existingModel = HeadphonesModel.fromMap(existing);

        // Automatically make it upper case.
        final updatedCorrections = HeadphonesModel.create(
          name: name.toUpperCase(),
          grade: existingModel.grade + 1,
          hz125Correction:
              (existingModel.hz125Correction + hz125Correction) / 2,
          hz250Correction:
              (existingModel.hz250Correction + hz250Correction) / 2,
          hz500Correction:
              (existingModel.hz500Correction + hz500Correction) / 2,
          hz1000Correction:
              (existingModel.hz1000Correction + hz1000Correction) / 2,
          hz2000Correction:
              (existingModel.hz2000Correction + hz2000Correction) / 2,
          hz4000Correction:
              (existingModel.hz4000Correction + hz4000Correction) / 2,
          hz8000Correction:
              (existingModel.hz8000Correction + hz8000Correction) / 2,
        );

        // Update the existing record
        final updatedList =
            await _client
                .from('headphones')
                .update(updatedCorrections.toInsertMap())
                .eq('id', existingModel.id)
                .select();

        if (updatedList.isEmpty) {
          HMLogger.print('Failed to update headphone: No rows affected');
        }
      } else {
        // 3. Insert new headphone with grade 0
        final newHeadphone = HeadphonesModel.create(
          name: name.toUpperCase(),
          grade: 1,
          hz125Correction: hz125Correction,
          hz250Correction: hz250Correction,
          hz500Correction: hz500Correction,
          hz1000Correction: hz1000Correction,
          hz2000Correction: hz2000Correction,
          hz4000Correction: hz4000Correction,
          hz8000Correction: hz8000Correction,
        );

        final insertedList =
            await _client
                .from('headphones')
                .insert(newHeadphone.toInsertMap())
                .select();

        if (insertedList.isEmpty) {
          HMLogger.print('Failed to insert headphone: No rows returned');
        }
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
