import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../domain/entities/acta_entity.dart';

abstract class ActaState extends Equatable {
  const ActaState();

  @override
  List<Object?> get props => [];
}

class ActaInitial extends ActaState {
  const ActaInitial();
}

class ActaImagePicked extends ActaState {
  final Uint8List imageBytes;
  final String fileName;
  final double? laplacianVariance;
  final bool isSharp;

  const ActaImagePicked({
    required this.imageBytes,
    required this.fileName,
    this.laplacianVariance,
    this.isSharp = false,
  });

  @override
  List<Object?> get props => [imageBytes, fileName, laplacianVariance, isSharp];
}

class ActaImageBlurry extends ActaState {
  final Uint8List imageBytes;
  final String fileName;
  final double laplacianVariance;

  const ActaImageBlurry({
    required this.imageBytes,
    required this.fileName,
    required this.laplacianVariance,
  });

  @override
  List<Object> get props => [imageBytes, fileName, laplacianVariance];
}

class ActaUploading extends ActaState {
  final Uint8List imageBytes;
  final String fileName;

  const ActaUploading({
    required this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [imageBytes, fileName];
}

class ActaUploadSuccess extends ActaState {
  final ActaEntity acta;

  const ActaUploadSuccess(this.acta);

  @override
  List<Object> get props => [acta];
}

class ActaError extends ActaState {
  final String message;

  const ActaError(this.message);

  @override
  List<Object> get props => [message];
}
