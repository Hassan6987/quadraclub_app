import 'package:quadraclub_app/presentation/authentication/ui/forget_password.dart';
import 'package:quadraclub_app/presentation/authentication/ui/sign_up_screen.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/delete_account.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/edit_profile.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/my_profile.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/privacy_policy.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/terms_screen.dart';

import '/app_exports.dart';

class AppGenerateRoute {
  static Route<dynamic>? generateRoute(RouteSettings setting) {
    switch (setting.name) {
      case RouteName.signIn:
        return _navigateScreen(const SignInScreen());
      case RouteName.signUp:
        return _navigateScreen(const SignupScreen());
      case RouteName.forgetPassword:
        return _navigateScreen(const ForgetPassword());
      case RouteName.homeScreen:
        return _navigateScreen(const HomeScreen());
      case RouteName.termsConditionScreen:
        return _navigateScreen(const TermsScreen());
      case RouteName.privacyPolicyScreen:
        return _navigateScreen(const PrivacyPolicy());
      case RouteName.myProfileScreen:
        return _navigateScreen(MyProfile());
      case RouteName.editProfileScreen:
        return _navigateScreen(EditProfile());
      case RouteName.deleteAccountScreen:
        return _navigateScreen(const DeleteAccount());
      case RouteName.confirmDeleteAccountScreen:
        return _navigateScreen(const ConfirmDeleteAccount());
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
  static const homeScreen = "/homeScreen";
  static const dotRegulationScreen = "/dotRegulationScreen";
  static const myProfileScreen = "/myProfileScreen";
  static const editProfileScreen = "/editProfileScreen";
  static const privacyPolicyScreen = "/privacyPolicyScreen";
  static const termsConditionScreen = "/termsConditionScreen";
  static const deleteAccountScreen = "/deleteAccountScreen";
  static const confirmDeleteAccountScreen = "/confirmDeleteAccountScreen";
}
