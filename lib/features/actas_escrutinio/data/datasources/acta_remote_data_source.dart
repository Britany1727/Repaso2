import 'dart:typed_data';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const _bucketName = 'actas_escrutinio';

abstract class ActaRemoteDataSource {
  Future<String> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
  });

  Future<String> getPublicUrl(String path);
}

@LazySingleton(as: ActaRemoteDataSource)
class ActaRemoteDataSourceImpl implements ActaRemoteDataSource {
  final SupabaseClient _supabase;

  ActaRemoteDataSourceImpl(this._supabase);

  @override
  Future<String> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
  }) async {
    final path = 'users/$userId/actas/$fileName';

    await _supabase.storage.from(_bucketName).uploadBinary(
          path,
          imageBytes,
          fileOptions: const FileOptions(
            contentType: 'image/jpeg',
            upsert: true,
          ),
        );

    return path;
  }

  @override
  Future<String> getPublicUrl(String path) async {
    return _supabase.storage.from(_bucketName).getPublicUrl(path);
  }
}
