import 'dart:typed_data';
import 'package:equatable/equatable.dart';

abstract class ActaEvent extends Equatable {
  const ActaEvent();

  @override
  List<Object?> get props => [];
}

class SelectImageFromCamera extends ActaEvent {
  const SelectImageFromCamera();
}

class SelectImageFromGallery extends ActaEvent {
  const SelectImageFromGallery();
}

class ImageSelected extends ActaEvent {
  final Uint8List imageBytes;
  final String fileName;

  const ImageSelected({
    required this.imageBytes,
    required this.fileName,
  });

  @override
  List<Object> get props => [imageBytes, fileName];
}

class CheckImageQuality extends ActaEvent {
  final Uint8List imageBytes;

  const CheckImageQuality(this.imageBytes);

  @override
  List<Object> get props => [imageBytes];
}

class UploadActaImage extends ActaEvent {
  const UploadActaImage();
}

class ResetActa extends ActaEvent {
  const ResetActa();
}
