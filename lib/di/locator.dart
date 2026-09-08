import 'package:get_it/get_it.dart';
import 'package:quadraclub_app/data/storage_service.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_provider.dart';
import 'package:quadraclub_app/presentation/authentication/data/auth_services.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_repository.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_services.dart';
import 'package:quadraclub_app/presentation/chats/data/chat_socket_service.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_repo.dart';
import 'package:quadraclub_app/presentation/classes/data/classes_services.dart';
import 'package:quadraclub_app/presentation/home/data/courts_repository.dart';
import 'package:quadraclub_app/presentation/home/data/courts_services.dart';

final GetIt locator = GetIt.instance;

void initServices() {
  ///
  /// Register provider
  ///

  // locator.registerSingleton<NotificationService>(NotificationService());
  locator.registerSingleton<StorageService>(StorageService());
  locator.registerLazySingleton<ChatSocketService>(() => ChatSocketService());
  locator.registerSingleton<AuthServices>(AuthServices());
  locator.registerSingleton<AuthProvider>(AuthProvider());
  locator.registerSingleton<CourtsServices>(CourtsServices());
  locator.registerSingleton<CourtsRepository>(CourtsRepository());
  locator.registerSingleton<ClassesServices>(ClassesServices());
  locator.registerSingleton<ClassesRepo>(ClassesRepo());
  locator.registerLazySingleton<ChatServices>(() => ChatServices());
  locator.registerLazySingleton<ChatRepository>(() => ChatRepository());

  ///
  /// Example how to register if something is required
  ///
  // locator.registerSingleton<AuthenticationRepository>(
  //     AuthenticationRepository(authenticationProvider: locator.get<AuthenticationProvider>(), tokenProvider: locator.get<TokenProvider>()));
}
