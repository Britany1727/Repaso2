import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/acta_repository.dart';

@injectable
class ValidateImageQuality implements UseCase<double, ValidateImageQualityParams> {
  final ActaRepository repository;

  ValidateImageQuality(this.repository);

  @override
  Future<Either<Failure, double>> call(ValidateImageQualityParams params) async {
    return await repository.validateImageQuality(params.imageBytes);
  }
}

class ValidateImageQualityParams {
  final Uint8List imageBytes;

  ValidateImageQualityParams({required this.imageBytes});
}
