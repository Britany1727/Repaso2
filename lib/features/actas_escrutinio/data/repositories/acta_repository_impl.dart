import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/image_quality_validator.dart';
import '../../domain/entities/acta_entity.dart';
import '../../domain/repositories/acta_repository.dart';
import '../datasources/acta_remote_data_source.dart';

@LazySingleton(as: ActaRepository)
class ActaRepositoryImpl implements ActaRepository {
  final ActaRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ActaRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, double>> validateImageQuality(
    Uint8List imageBytes,
  ) async {
    try {
      final variance = ImageQualityValidator.computeLaplacianVariance(imageBytes);
      return Right(variance);
    } catch (e) {
      return Left(ServerFailure('Error al procesar la imagen: $e'));
    }
  }

  @override
  Future<Either<Failure, ActaEntity>> uploadActa({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
    required double laplacianVariance,
  }) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure('Sin conexión a internet'));
    }

    try {
      final fileId = await remoteDataSource.uploadImage(
        imageBytes: imageBytes,
        fileName: fileName,
        userId: userId,
      );

      final publicUrl =
          '${AppConstants.appwriteEndpoint}/storage/buckets/${AppConstants.actasBucketId}/files/$fileId/view?project=${AppConstants.appwriteProjectId}';

      final acta = ActaEntity(
        id: fileId,
        userId: userId,
        imageUrl: publicUrl,
        status: 'uploaded',
        laplacianVariance: laplacianVariance,
        createdAt: DateTime.now(),
      );

      return Right(acta);
    } catch (e) {
      return Left(ServerFailure('Error al subir el acta: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> extractActaData(
    Uint8List imageBytes,
  ) async {
    try {
      final variance = ImageQualityValidator.computeLaplacianVariance(imageBytes);
      if (variance < ImageQualityValidator.laplacianThreshold) {
        return const Left(ServerFailure(
          'La imagen es borrosa. No se puede extraer datos.',
        ));
      }

      final mockData = <String, dynamic>{
        'nitidez': variance,
        'estado': 'pendiente_ocr',
        'mensaje': 'OCR no implementado - placeholder listo para integración',
        'campos_esperados': [
          'numero_acta',
          'junta_receptora',
          'votos_validos',
          'votos_nulos',
          'votos_blancos',
        ],
      };

      return Right(mockData);
    } catch (e) {
      return Left(ServerFailure('Error al extraer datos: $e'));
    }
  }
}
