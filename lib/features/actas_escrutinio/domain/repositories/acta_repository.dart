import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/acta_entity.dart';

abstract class ActaRepository {
  Future<Either<Failure, double>> validateImageQuality(Uint8List imageBytes);

  Future<Either<Failure, ActaEntity>> uploadActa({
    required Uint8List imageBytes,
    required String fileName,
    required String userId,
    required double laplacianVariance,
  });

  Future<Either<Failure, Map<String, dynamic>>> extractActaData(
    Uint8List imageBytes,
  );
}
