import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/agenda/bloc/agenda_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/chats/bloc/chats_bloc.dart';
import 'package:quadraclub_app/presentation/chats/message_bloc/chat_bloc.dart';
import 'package:quadraclub_app/presentation/classes/bloc/classes_bloc.dart';
import 'package:quadraclub_app/presentation/home/bloc/courts_bloc.dart';
import 'package:quadraclub_app/presentation/onboarding/onboarding_screens.dart';
import 'package:quadraclub_app/utils/components/safe_area_wrapper.dart';

import 'di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Forces the app to be edge-to-edge on supported Android versions
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      // Light icons for dark background
      statusBarBrightness: Brightness.dark,
      // For iOS
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  initServices();
  Bloc.observer = SimpleBlocObserver();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()..add(AuthStarted())),
        BlocProvider(create: (context) => CourtsBloc()..add(LoadCourts())),
        BlocProvider(create: (_) => ChatsBloc()..add(const LoadChats())),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => AgendaBloc()..add(GetAllAgenda())),
        BlocProvider(
          create: (context) => ClassesBloc()..add(FetchAllClasses()),
        ),
      ],
      child: MyApp(),
    ),
  );
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ResponsiveConfig().init(context);
    return SafeAreaWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'QuadraClub',
        theme: AppTheme.lightTheme,
        navigatorKey: navigatorKey,
        onGenerateRoute: AppGenerateRoute.generateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          buildWhen: (previous, current) {
            return previous.status == AuthStateStatus.initial ||
                previous.status == AuthStateStatus.authenticating;
          },
          builder: (context, state) {
            if (state.status == AuthStateStatus.onboarding) {
              return const OnboardingScreen();
            }
            if (state.status == AuthStateStatus.success) {
              return const CustomBottomNavBar(index: 2);
            }
            // Unauthenticated users land on home as a guest (can browse freely)
            if (state.status == AuthStateStatus.unAuthenticated) {
              return const CustomBottomNavBar(index: 2);
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}
