import 'package:get_it/get_it.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_services.dart';
import 'package:quadraclub_app/presentation/home/data/courts_repository.dart';
import 'package:quadraclub_app/presentation/home/data/courts_services.dart';

final GetIt locator = GetIt.instance;

void initServices() {
  ///
  /// Register provider
  ///

  // locator.registerSingleton<NotificationService>(NotificationService());
  locator.registerSingleton<StorageService>(StorageService());
  locator.registerSingleton<AuthServices>(AuthServices());
  locator.registerSingleton<AuthProvider>(AuthProvider());
  locator.registerSingleton<CourtsServices>(CourtsServices());
  locator.registerSingleton<CourtsRepository>(CourtsRepository());

  ///
  /// Example how to register if something is required
  ///
  // locator.registerSingleton<AuthenticationRepository>(
  //     AuthenticationRepository(authenticationProvider: locator.get<AuthenticationProvider>(), tokenProvider: locator.get<TokenProvider>()));
}
