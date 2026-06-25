import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';

abstract class ActaRemoteDataSource {
  Future<String> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
  });
}

@LazySingleton(as: ActaRemoteDataSource)
class ActaRemoteDataSourceImpl implements ActaRemoteDataSource {
  final Storage _storage;

  ActaRemoteDataSourceImpl(this._storage);

  @override
  Future<String> uploadImage({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
  }) async {
    final file = await _storage.createFile(
      bucketId: AppConstants.actasBucketId,
      fileId: ID.unique(),
      file: InputFile.fromBytes(
        bytes: imageBytes,
        filename: '$userId/actas/$fileName',
      ),
    );

    return file.$id;
  }
}
