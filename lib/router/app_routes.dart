import 'package:quadraclub_app/presentation/authentication/ui/forget_password.dart';
import 'package:quadraclub_app/presentation/authentication/ui/sign_up_screen.dart';
import 'package:quadraclub_app/presentation/chats/ui/my_chats_screen.dart';
import 'package:quadraclub_app/presentation/home/data/booking/booking_models.dart';
import 'package:quadraclub_app/presentation/notifications/ui/notification_screen.dart';
import 'package:quadraclub_app/presentation/profile/ui/my_account.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/delete_account.dart';

import '/app_exports.dart';

class AppGenerateRoute {
  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteName.signIn:
        return _navigateScreen(const SignInScreen());
      case RouteName.signUp:
        return _navigateScreen(const CreateAccountScreen());
      case RouteName.forgetPassword:
        return _navigateScreen(const ForgetPassword());
      case RouteName.customBottomNavbar:
        final args = setting.arguments as Map<String, dynamic>? ?? const {};
        return _navigateScreen(
          CustomBottomNavBar(
            index: args["index"] as int? ?? 2,
            bookingIntent:
                args["bookingIntent"] as BookingType? ?? BookingType.individual,
            agendaTabIndex: args["agendaTabIndex"] as int? ?? 0,
          ),
        );
      case RouteName.myAccount:
        return _navigateScreen(const MyAccount());
      case RouteName.notifications:
        return _navigateScreen(const NotificationsScreen());
      case RouteName.myChats:
        return _navigateScreen(const MyChatsScreen());
      case RouteName.deleteAccountScreen:
        return _navigateScreen(const DeleteAccount());
      case RouteName.confirmDeleteAccountScreen:
        return _navigateScreen(const ConfirmDeleteAccount());
      // case RouteName.bookingSummaryScreen:
      //   final MatchModel matchModel = setting.arguments as MatchModel;
      //   return _navigateScreen(BookingSummaryScreen(match: matchModel));
      default:
        return _navigateScreen(const SplashScreen());
    }
  }

  static PageRouteBuilder _navigateScreen(Widget screen) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return customLeftSlideTransition(animation, child);
      },
    );
  }

  static Widget customLeftSlideTransition(
    Animation<double> animation,
    Widget child,
  ) {
    Tween<Offset> tween = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    );
    return SlideTransition(position: tween.animate(animation), child: child);
  }
}

class RouteName {
  static const splash = "/splash";
  static const signIn = "/signIn";
  static const signUp = "/signUp";
  static const forgetPassword = "/forgetPassword";
  static const verifyEmail = "/verifyEmail";
  static const resetPassword = "/resetPassword";
  static const profileCreation = "/profileCreation";
  static const otpVerification = "/otpVerification";
  static const aboutYou = "/aboutYou";
  static const gamePreferences = "/gamePreferences";
  static const defineLevel = "/defineLevel";
  static const confirmation = "/confirmation";
  static const myChats = "/myChats";
  static const customBottomNavbar = "/customBottomNavbar";
  static const myAccount = "/myAccount";
  static const notifications = "/notifications";
  static const homeScreen = "/homeScreen";
  static const dotRegulationScreen = "/dotRegulationScreen";
  static const myProfileScreen = "/myProfileScreen";
  static const deleteAccountScreen = "/deleteAccountScreen";
  static const confirmDeleteAccountScreen = "/confirmDeleteAccountScreen";
  // static const bookingSummaryScreen = "/bookingSummaryScreen";
}
