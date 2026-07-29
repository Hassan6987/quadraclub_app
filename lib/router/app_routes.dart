import 'package:quadraclub_app/presentation/authentication/ui/signup/about_you_screen.dart';
import 'package:quadraclub_app/presentation/authentication/ui/forget_password.dart';
import 'package:quadraclub_app/presentation/authentication/ui/sign_up_screen.dart';
import 'package:quadraclub_app/presentation/chats/ui/my_chats_screen.dart';
import 'package:quadraclub_app/presentation/classes/ui/class_details_screen.dart';
import 'package:quadraclub_app/presentation/home/ui/widgets/notification_screen.dart';
import 'package:quadraclub_app/presentation/matches/data/match_model.dart';
import 'package:quadraclub_app/presentation/matches/ui/booking_summary_screen.dart';
import 'package:quadraclub_app/presentation/notifications/ui/notification_screen.dart';
import 'package:quadraclub_app/presentation/profile/ui/my_account.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/delete_account.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/edit_profile.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/my_profile.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/privacy_policy.dart';
import 'package:quadraclub_app/presentation/profile/ui/screens/terms_screen.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/confirmation.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/step1_create_account.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/step2_otp_verification.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/step3_about_you.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/step4_select_sports.dart';
import 'package:quadraclub_app/presentation/profile_creation/ui/step5_define_level.dart';

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
        case RouteName.profileCreation:
        return _navigateScreen(const Step1CreateAccount()); 
        case RouteName.otpVerification:
          final String email=setting.arguments as String;
        return _navigateScreen( Step2OtpVerification(email: email));
        case RouteName.aboutYou:
        return _navigateScreen(Step3AboutYou());
        case RouteName.gamePreferences:
        return _navigateScreen(const Step4SelectSports());
        case RouteName.defineLevel:
        return _navigateScreen(const Step5DefineLevel());
        case RouteName.confirmation:

        return _navigateScreen(const ConfirmationScreen());
        case RouteName.customBottomNavbar:
        return _navigateScreen(CustomBottomNavBar());
      case RouteName.myAccount:
        return _navigateScreen(const MyAccount());
        case RouteName.notifications:
        return _navigateScreen(const NotificationsScreen());
        case RouteName.myChats:
        return _navigateScreen(const MyChatsScreen());
        case RouteName.classDetails:
          final ClassModel classModel = setting.arguments as ClassModel;
        return _navigateScreen( ClassDetailsScreen(classModel: classModel));
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
      case RouteName.bookingSummaryScreen:
        final MatchModel matchModel = setting.arguments as MatchModel;
        return _navigateScreen(BookingSummaryScreen(match: matchModel));
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
  static const myChats="/myChats";
  static const customBottomNavbar="/customBottomNavbar";
  static const myAccount = "/myAccount";
  static const notifications = "/notifications";
  static const classDetails = "/classDetails";
  static const homeScreen = "/homeScreen";
  static const dotRegulationScreen = "/dotRegulationScreen";
  static const myProfileScreen = "/myProfileScreen";
  static const editProfileScreen = "/editProfileScreen";
  static const privacyPolicyScreen = "/privacyPolicyScreen";
  static const termsConditionScreen = "/termsConditionScreen";
  static const deleteAccountScreen = "/deleteAccountScreen";
  static const confirmDeleteAccountScreen = "/confirmDeleteAccountScreen";
  static const bookingSummaryScreen = "/bookingSummaryScreen";
}
