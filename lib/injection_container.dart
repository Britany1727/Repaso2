import 'package:appwrite/appwrite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'core/constants/app_constants.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  final client = Client()
      .setEndpoint(AppConstants.appwriteEndpoint)
      .setProject(AppConstants.appwriteProjectId);

  // Register external dependencies
  getIt.registerLazySingleton<Client>(() => client);
  getIt.registerLazySingleton<Account>(() => Account(client));
  getIt.registerLazySingleton<Storage>(() => Storage(client));
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());

  // Initialize injectable
  getIt.init();
}
