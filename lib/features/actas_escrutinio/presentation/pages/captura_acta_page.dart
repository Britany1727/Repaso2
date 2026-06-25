import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/acta_bloc.dart';
import '../bloc/acta_event.dart';
import '../bloc/acta_state.dart';
import '../widgets/image_preview_widget.dart';
import '../widgets/quality_indicator_widget.dart';

class CapturaActaPage extends StatelessWidget {
  const CapturaActaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capturar Acta'),
        centerTitle: true,
        backgroundColor: const Color(0xFF003893),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocConsumer<ActaBloc, ActaState>(
        listener: (context, state) {
          if (state is ActaError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: const Color(0xFFEF3340),
              ),
            );
          } else if (state is ActaUploadSuccess) {
            _showSuccessDialog(context);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is ActaInitial) _buildInitialState(context),
                  if (state is ActaImagePicked) _buildPickedState(context, state),
                  if (state is ActaImageBlurry) _buildBlurryState(context, state),
                  if (state is ActaUploading) _buildUploadingState(context, state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInitialState(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF003893).withValues(alpha: 0.08),
            ),
            child: Icon(
              Icons.document_scanner_rounded,
              size: 60,
              color: const Color(0xFF003893).withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Capturar Acta de Escrutinio',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003893),
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Toma una foto nítida del acta para su procesamiento.\nLa imagen debe ser clara y bien iluminada.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          _buildActionButton(
            context,
            icon: Icons.camera_alt_rounded,
            label: 'Tomar foto',
            color: const Color(0xFF003893),
            onPressed: () =>
                context.read<ActaBloc>().add(const SelectImageFromCamera()),
          ),
          const SizedBox(height: 16),
          _buildActionButton(
            context,
            icon: Icons.photo_library_rounded,
            label: 'Seleccionar de galería',
            color: const Color(0xFF003893).withValues(alpha: 0.8),
            onPressed: () =>
                context.read<ActaBloc>().add(const SelectImageFromGallery()),
            outlined: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPickedState(BuildContext context, ActaImagePicked state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ImagePreviewWidget(
              imageBytes: state.imageBytes,
              onRetake: () =>
                  context.read<ActaBloc>().add(const SelectImageFromCamera()),
            ),
          ),
          const SizedBox(height: 16),
          QualityIndicatorWidget(
            variance: state.laplacianVariance ?? 0,
            isBlurry: !state.isSharp,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: state.isSharp
              ? () => context.read<ActaBloc>().add(const UploadActaImage())
              : () => context.read<ActaBloc>().add(
                        CheckImageQuality(state.imageBytes),
                      ),
              icon: Icon(state.isSharp ? Icons.cloud_upload_rounded : Icons.photo_size_select_large_rounded),
              label: Text(state.isSharp ? 'Subir acta' : 'Validar calidad'),
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isSharp
                    ? const Color(0xFF003893)
                    : const Color(0xFFFFD100),
                foregroundColor: state.isSharp ? Colors.white : const Color(0xFF1A1A2E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurryState(BuildContext context, ActaImageBlurry state) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: ImagePreviewWidget(
              imageBytes: state.imageBytes,
              onRetake: () =>
                  context.read<ActaBloc>().add(const SelectImageFromCamera()),
            ),
          ),
          const SizedBox(height: 16),
          QualityIndicatorWidget(
            variance: state.laplacianVariance,
            isBlurry: true,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFEF3340).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFEF3340).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFEF3340)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'La imagen es demasiado borrosa. Toma una nueva foto con mejor iluminación y enfoque.',
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFFEF3340).withValues(alpha: 0.9),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () =>
                  context.read<ActaBloc>().add(const SelectImageFromCamera()),
              icon: const Icon(Icons.camera_alt_rounded),
              label: const Text('Tomar nueva foto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003893),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadingState(BuildContext context, ActaUploading state) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003893)),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Subiendo acta...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF003893),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Estamos procesando y almacenando tu acta de escrutinio',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    bool outlined = false,
  }) {
    if (outlined) {
      return SizedBox(
        height: 54,
        child: OutlinedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon),
          label: Text(label),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 54,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00B894).withValues(alpha: 0.1),
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 50,
                color: Color(0xFF00B894),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Acta subida exitosamente',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003893),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'El acta de escrutinio ha sido almacenada en el sistema.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF636E72)),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.read<ActaBloc>().add(const ResetActa());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003893),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Capturar otra acta'),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Volver al inicio',
                style: TextStyle(color: Color(0xFF003893)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
