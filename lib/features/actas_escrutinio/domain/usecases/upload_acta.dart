import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/acta_entity.dart';
import '../repositories/acta_repository.dart';

@injectable
class UploadActa implements UseCase<ActaEntity, UploadActaParams> {
  final ActaRepository repository;

  UploadActa(this.repository);

  @override
  Future<Either<Failure, ActaEntity>> call(UploadActaParams params) async {
    return await repository.uploadActa(
      imageBytes: params.imageBytes,
      fileName: params.fileName,
      userId: params.userId,
      laplacianVariance: params.laplacianVariance,
    );
  }
}

class UploadActaParams {
  final Uint8List imageBytes;
  final String fileName;
  final String userId;
  final double laplacianVariance;

  UploadActaParams({
    required this.imageBytes,
    required this.fileName,
    required this.userId,
    required this.laplacianVariance,
  });
}
