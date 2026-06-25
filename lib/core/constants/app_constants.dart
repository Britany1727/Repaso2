import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // Appwrite Configuration (loaded from .env)
  static String get appwriteEndpoint => dotenv.env['APPWRITE_ENDPOINT'] ?? '';
  static String get appwriteProjectId => dotenv.env['APPWRITE_PROJECT_ID'] ?? '';

  // Buckets
  static const String actasBucketId = 'actas_escrutinio';

  // Deep Link Configuration
  static const String appScheme = 'loginpro';

  // Error Messages
  static const String networkError = 'Sin conexión a internet';
  static const String serverError = 'Error del servidor';
  static const String authError = 'Error de autenticación';
  static const String unknownError = 'Error desconocido';
}
