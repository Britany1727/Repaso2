import 'package:appwrite/appwrite.dart';
import 'package:injectable/injectable.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  });

  Future<void> sendPasswordResetEmail({
    required String email,
  });

  Future<void> signOut();

  Future<UserModel?> getCurrentUser();

  Future<void> updateUserPrefs(Map<String, dynamic> prefs);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Account _account;

  AuthRemoteDataSourceImpl(this._account);

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      final user = await _account.get();
      return UserModel.fromAppwriteUser(user);
    } on AppwriteException catch (e) {
      throw Exception(e.message ?? 'Error al iniciar sesión');
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: displayName ?? '',
      );

      // Iniciar sesión después del registro
      await _account.createEmailSession(
        email: email,
        password: password,
      );

      final user = await _account.get();
      return UserModel.fromAppwriteUser(user);
    } on AppwriteException catch (e) {
      throw Exception(e.message ?? 'Error al registrarse');
    } catch (e) {
      throw Exception('Error al registrarse: $e');
    }
  }

  @override
  Future<void> sendPasswordResetEmail({
    required String email,
  }) async {
    try {
      await _account.createRecovery(
        email: email,
        url: 'loginpro://reset-password',
      );
    } on AppwriteException catch (e) {
      throw Exception(e.message ?? 'Error al enviar email de recuperación');
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } on AppwriteException catch (e) {
      throw Exception(e.message ?? 'Error al cerrar sesión');
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = await _account.get();
      return UserModel.fromAppwriteUser(user);
    } on AppwriteException {
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> updateUserPrefs(Map<String, dynamic> prefs) async {
    try {
      await _account.updatePrefs(prefs: prefs);
    } on AppwriteException catch (e) {
      throw Exception(e.message ?? 'Error al actualizar preferencias');
    }
  }
}
