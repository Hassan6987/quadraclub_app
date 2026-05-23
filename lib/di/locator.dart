import 'package:get_it/get_it.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';

final GetIt locator = GetIt.instance;

void initServices() {
  ///
  /// Register provider
  ///

  // locator.registerSingleton<AuthenticationProvider>(AuthenticationProvider());
  // locator.registerSingleton<NotificationService>(NotificationService());
  locator.registerSingleton<StorageService>(StorageService());
  locator.registerSingleton<AuthProvider>(AuthProvider());

  ///
  /// Example how to register if something is required
  ///
  // locator.registerSingleton<AuthenticationRepository>(
  //     AuthenticationRepository(authenticationProvider: locator.get<AuthenticationProvider>(), tokenProvider: locator.get<TokenProvider>()));
}
