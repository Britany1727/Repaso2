import 'dart:typed_data';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/acta_repository.dart';

@injectable
class ExtractActaData implements UseCase<Map<String, dynamic>, ExtractActaDataParams> {
  final ActaRepository repository;

  ExtractActaData(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(
      ExtractActaDataParams params) async {
    return await repository.extractActaData(params.imageBytes);
  }
}

class ExtractActaDataParams {
  final Uint8List imageBytes;

  ExtractActaDataParams({required this.imageBytes});
}
