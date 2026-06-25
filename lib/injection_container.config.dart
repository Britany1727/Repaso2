// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:appwrite/appwrite.dart' as _i317;
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:login_pro/core/network/network_info.dart' as _i505;
import 'package:login_pro/features/actas_escrutinio/data/datasources/acta_remote_data_source.dart'
    as _i806;
import 'package:login_pro/features/actas_escrutinio/data/repositories/acta_repository_impl.dart'
    as _i38;
import 'package:login_pro/features/actas_escrutinio/domain/repositories/acta_repository.dart'
    as _i908;
import 'package:login_pro/features/actas_escrutinio/domain/usecases/extract_acta_data.dart'
    as _i186;
import 'package:login_pro/features/actas_escrutinio/domain/usecases/upload_acta.dart'
    as _i937;
import 'package:login_pro/features/actas_escrutinio/domain/usecases/validate_image_quality.dart'
    as _i232;
import 'package:login_pro/features/actas_escrutinio/presentation/bloc/acta_bloc.dart'
    as _i900;
import 'package:login_pro/features/auth/data/datasources/auth_remote_data_source.dart'
    as _i383;
import 'package:login_pro/features/auth/data/repositories/auth_repository_impl.dart'
    as _i12;
import 'package:login_pro/features/auth/domain/repositories/auth_repository.dart'
    as _i638;
import 'package:login_pro/features/auth/domain/usecases/get_current_user.dart'
    as _i496;
import 'package:login_pro/features/auth/domain/usecases/reset_password.dart'
    as _i1002;
import 'package:login_pro/features/auth/domain/usecases/sign_in.dart' as _i1051;
import 'package:login_pro/features/auth/domain/usecases/sign_out.dart' as _i427;
import 'package:login_pro/features/auth/domain/usecases/sign_up.dart' as _i369;
import 'package:login_pro/features/auth/presentation/bloc/auth_bloc.dart'
    as _i746;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i505.NetworkInfo>(
        () => _i505.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i806.ActaRemoteDataSource>(
        () => _i806.ActaRemoteDataSourceImpl(gh<_i317.Storage>()));
    gh.lazySingleton<_i908.ActaRepository>(() => _i38.ActaRepositoryImpl(
          remoteDataSource: gh<_i806.ActaRemoteDataSource>(),
          networkInfo: gh<_i505.NetworkInfo>(),
        ));
    gh.lazySingleton<_i383.AuthRemoteDataSource>(
        () => _i383.AuthRemoteDataSourceImpl(gh<_i317.Account>()));
    gh.factory<_i186.ExtractActaData>(
        () => _i186.ExtractActaData(gh<_i908.ActaRepository>()));
    gh.factory<_i937.UploadActa>(
        () => _i937.UploadActa(gh<_i908.ActaRepository>()));
    gh.factory<_i232.ValidateImageQuality>(
        () => _i232.ValidateImageQuality(gh<_i908.ActaRepository>()));
    gh.lazySingleton<_i638.AuthRepository>(() => _i12.AuthRepositoryImpl(
          remoteDataSource: gh<_i383.AuthRemoteDataSource>(),
          networkInfo: gh<_i505.NetworkInfo>(),
        ));
    gh.factory<_i900.ActaBloc>(() => _i900.ActaBloc(
          validateImageQuality: gh<_i232.ValidateImageQuality>(),
          uploadActa: gh<_i937.UploadActa>(),
          account: gh<_i317.Account>(),
        ));
    gh.factory<_i496.GetCurrentUser>(
        () => _i496.GetCurrentUser(gh<_i638.AuthRepository>()));
    gh.factory<_i1002.ResetPassword>(
        () => _i1002.ResetPassword(gh<_i638.AuthRepository>()));
    gh.factory<_i1051.SignIn>(() => _i1051.SignIn(gh<_i638.AuthRepository>()));
    gh.factory<_i427.SignOut>(() => _i427.SignOut(gh<_i638.AuthRepository>()));
    gh.factory<_i369.SignUp>(() => _i369.SignUp(gh<_i638.AuthRepository>()));
    gh.factory<_i746.AuthBloc>(() => _i746.AuthBloc(
          signIn: gh<_i1051.SignIn>(),
          signUp: gh<_i369.SignUp>(),
          resetPassword: gh<_i1002.ResetPassword>(),
          signOut: gh<_i427.SignOut>(),
          getCurrentUser: gh<_i496.GetCurrentUser>(),
        ));
    return this;
  }
}
