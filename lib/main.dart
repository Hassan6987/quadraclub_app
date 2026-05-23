import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quadraclub_app/app_exports.dart';
import 'package:quadraclub_app/presentation/authentication/bloc/auth_bloc.dart';
import 'package:quadraclub_app/presentation/authentication/ui/welcome_screen.dart';
import 'package:quadraclub_app/presentation/home/bloc/home_bloc.dart';
import 'package:quadraclub_app/presentation/onboarding/onboarding_screens.dart';
import 'package:quadraclub_app/presentation/team_roster/bloc/team_roster_bloc.dart';
import 'package:quadraclub_app/presentation/teams/bloc/teams_bloc.dart';
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
        // BlocProvider(create: (context) => HomeBloc()),
        // BlocProvider(create: (context) => TeamRosterBloc()),
        // BlocProvider(create: (context) => TeamsBloc()),
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
              return const CustomBottomNavBar();
            }
            if (state.status == AuthStateStatus.failure ||
                state.status == AuthStateStatus.unAuthenticated) {
              return const WelcomeScreen();
            }
            return const SplashScreen();
          },
        ),
      ),
    );
  }
}
