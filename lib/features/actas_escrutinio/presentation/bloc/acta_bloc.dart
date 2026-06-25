import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/usecases/upload_acta.dart';
import '../../domain/usecases/validate_image_quality.dart';
import 'acta_event.dart';
import 'acta_state.dart';

@injectable
class ActaBloc extends Bloc<ActaEvent, ActaState> {
  final ValidateImageQuality validateImageQuality;
  final UploadActa uploadActa;
  final ImagePicker _picker;
  final SupabaseClient _supabase;

  ActaBloc({
    required this.validateImageQuality,
    required this.uploadActa,
    required SupabaseClient supabaseClient,
  })  : _picker = ImagePicker(),
        _supabase = supabaseClient,
        super(const ActaInitial()) {
    on<SelectImageFromCamera>(_onSelectFromCamera);
    on<SelectImageFromGallery>(_onSelectFromGallery);
    on<ImageSelected>(_onImageSelected);
    on<CheckImageQuality>(_onCheckImageQuality);
    on<UploadActaImage>(_onUploadActa);
    on<ResetActa>(_onReset);
  }

  Future<void> _onSelectFromCamera(
    SelectImageFromCamera event,
    Emitter<ActaState> emit,
  ) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (file == null) return;
      await _processPickedFile(file, emit);
    } catch (e) {
      emit(ActaError('Error al tomar foto: $e'));
    }
  }

  Future<void> _onSelectFromGallery(
    SelectImageFromGallery event,
    Emitter<ActaState> emit,
  ) async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file == null) return;
      await _processPickedFile(file, emit);
    } catch (e) {
      emit(ActaError('Error al seleccionar imagen: $e'));
    }
  }

  Future<void> _processPickedFile(XFile file, Emitter<ActaState> emit) async {
    try {
      final bytes = await file.readAsBytes();
      final fileName = file.name;
      add(ImageSelected(imageBytes: bytes, fileName: fileName));
    } catch (e) {
      emit(ActaError('Error al leer la imagen: $e'));
    }
  }

  void _onImageSelected(
    ImageSelected event,
    Emitter<ActaState> emit,
  ) {
    emit(ActaImagePicked(
      imageBytes: event.imageBytes,
      fileName: event.fileName,
    ));
  }

  Future<void> _onCheckImageQuality(
    CheckImageQuality event,
    Emitter<ActaState> emit,
  ) async {
    final result = await validateImageQuality(
      ValidateImageQualityParams(imageBytes: event.imageBytes),
    );

    result.fold(
      (failure) => emit(ActaError(failure.message)),
      (variance) {
        final currentState = state;
        final fileName = currentState is ActaImagePicked
            ? currentState.fileName
            : 'acta_${DateTime.now().millisecondsSinceEpoch}.jpg';

        if (variance < 100.0) {
          emit(ActaImageBlurry(
            imageBytes: event.imageBytes,
            fileName: fileName,
            laplacianVariance: variance,
          ));
        } else {
          emit(ActaImagePicked(
            imageBytes: event.imageBytes,
            fileName: fileName,
            laplacianVariance: variance,
            isSharp: true,
          ));
        }
      },
    );
  }

  Future<void> _onUploadActa(
    UploadActaImage event,
    Emitter<ActaState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ActaImagePicked || !currentState.isSharp) return;

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      emit(const ActaError('Debes iniciar sesión para subir actas'));
      return;
    }

    emit(ActaUploading(
      imageBytes: currentState.imageBytes,
      fileName: currentState.fileName,
    ));

    final result = await uploadActa(
      UploadActaParams(
        imageBytes: currentState.imageBytes,
        fileName: currentState.fileName,
        userId: userId,
        laplacianVariance: currentState.laplacianVariance ?? 0,
      ),
    );

    result.fold(
      (failure) => emit(ActaError(failure.message)),
      (acta) => emit(ActaUploadSuccess(acta)),
    );
  }

  void _onReset(ResetActa event, Emitter<ActaState> emit) {
    emit(const ActaInitial());
  }
}
