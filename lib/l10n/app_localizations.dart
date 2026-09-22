import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @enterYourCredentialsManageYourBookings.
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to manage your bookings.'**
  String get enterYourCredentialsManageYourBookings;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @doNotHaveAnAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get doNotHaveAnAccount;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @anOtpHasBeenSentToYourEmail.
  ///
  /// In en, this message translates to:
  /// **'An otp has been sent to your email'**
  String get anOtpHasBeenSentToYourEmail;

  /// No description provided for @forgotPasswordd.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgotPasswordd;

  /// No description provided for @enterTheEmailAddressAssociatedWithAccountWeSendYouRecoveryCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the email address associated with account and we\'ll send you a recovery code.'**
  String get enterTheEmailAddressAssociatedWithAccountWeSendYouRecoveryCode;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// No description provided for @emailVerifiedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Email verified Successfully'**
  String get emailVerifiedSuccessfully;

  /// No description provided for @otpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otpVerification;

  /// No description provided for @enterTheDigitCodeSentToYouAt.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to you at:'**
  String get enterTheDigitCodeSentToYouAt;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @iDidNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'I didn\'t receive a code '**
  String get iDidNotReceiveCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @didNotReceiveTheCodeCheckYourSpamFolderOrTryResendingIt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? Check your spam folder or try resending it.'**
  String get didNotReceiveTheCodeCheckYourSpamFolderOrTryResendingIt;

  /// No description provided for @verifyContinue.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyContinue;

  /// No description provided for @pleaseConfirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password.'**
  String get pleaseConfirmYourPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get passwordsDoNotMatch;

  /// No description provided for @passwordChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passwordChangedSuccessfully;

  /// No description provided for @setNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPassword;

  /// No description provided for @setNewPasswordToSecureYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Set new password to secure your account.'**
  String get setNewPasswordToSecureYourAccount;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirmNewPassword;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @createYourAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get createYourAccount;

  /// No description provided for @fillInYourDetailsToStartPlaying.
  ///
  /// In en, this message translates to:
  /// **'Fill in your details to start playing.'**
  String get fillInYourDetailsToStartPlaying;

  /// No description provided for @profilePhoto.
  ///
  /// In en, this message translates to:
  /// **'Profile Photo'**
  String get profilePhoto;

  /// No description provided for @jpgOrPNGMaxMB.
  ///
  /// In en, this message translates to:
  /// **'JPG or PNG, max 5MB'**
  String get jpgOrPNGMaxMB;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @enterYourName.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @ddMmYyyy.
  ///
  /// In en, this message translates to:
  /// **'dd/mm/yyyy'**
  String get ddMmYyyy;

  /// No description provided for @dateOfBirthIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Date of birth is required'**
  String get dateOfBirthIsRequired;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @continuee.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continuee;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @step.
  ///
  /// In en, this message translates to:
  /// **'Step'**
  String get step;

  /// No description provided for @locationPermissionIsRequiredToUseThis.
  ///
  /// In en, this message translates to:
  /// **'Location permission is required to use this.'**
  String get locationPermissionIsRequiredToUseThis;

  /// No description provided for @pleaseEnableLocationServices.
  ///
  /// In en, this message translates to:
  /// **'Please enable location services.'**
  String get pleaseEnableLocationServices;

  /// No description provided for @couldNotDetermineYourCityPleaseSearchManually.
  ///
  /// In en, this message translates to:
  /// **'Could not determine your city. Please search manually.'**
  String get couldNotDetermineYourCityPleaseSearchManually;

  /// No description provided for @somethingWentWrongGettingYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong getting your location.'**
  String get somethingWentWrongGettingYourLocation;

  /// No description provided for @aboutYou.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get aboutYou;

  /// No description provided for @thisHelpsYouFindCourtsAndPlayersNearYou.
  ///
  /// In en, this message translates to:
  /// **'This helps you find courts and players near you.'**
  String get thisHelpsYouFindCourtsAndPlayersNearYou;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @useMyLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my location'**
  String get useMyLocation;

  /// No description provided for @cityArea.
  ///
  /// In en, this message translates to:
  /// **'City/area'**
  String get cityArea;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @masculine.
  ///
  /// In en, this message translates to:
  /// **'Masculine'**
  String get masculine;

  /// No description provided for @feminine.
  ///
  /// In en, this message translates to:
  /// **'Feminine'**
  String get feminine;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @dominantHand.
  ///
  /// In en, this message translates to:
  /// **'Dominant Hand'**
  String get dominantHand;

  /// No description provided for @left.
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// No description provided for @right.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get right;

  /// No description provided for @whatGamesDoYouPlay.
  ///
  /// In en, this message translates to:
  /// **'What games do you play?'**
  String get whatGamesDoYouPlay;

  /// No description provided for @selectOneOrMoreYouCanAddOthersLater.
  ///
  /// In en, this message translates to:
  /// **'Select one or more. You can add others later.'**
  String get selectOneOrMoreYouCanAddOthersLater;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// No description provided for @sport.
  ///
  /// In en, this message translates to:
  /// **'sport'**
  String get sport;

  /// No description provided for @defineYourLevel.
  ///
  /// In en, this message translates to:
  /// **'Define your level.'**
  String get defineYourLevel;

  /// No description provided for @selectCategoryForEachSport.
  ///
  /// In en, this message translates to:
  /// **'Select your category for each sport. You can change it later.'**
  String get selectCategoryForEachSport;

  /// No description provided for @youCanChangeThisLater.
  ///
  /// In en, this message translates to:
  /// **'You can change this later'**
  String get youCanChangeThisLater;

  /// No description provided for @selectYourCategory.
  ///
  /// In en, this message translates to:
  /// **'Select your category'**
  String get selectYourCategory;

  /// No description provided for @preferredSide.
  ///
  /// In en, this message translates to:
  /// **'Preferred Side'**
  String get preferredSide;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @categoryOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get categoryOpen;

  /// No description provided for @categoryOpenDescription.
  ///
  /// In en, this message translates to:
  /// **'For advanced/competitive players'**
  String get categoryOpenDescription;

  /// No description provided for @category1.
  ///
  /// In en, this message translates to:
  /// **'Category 1'**
  String get category1;

  /// No description provided for @category1Description.
  ///
  /// In en, this message translates to:
  /// **'Beginner level players'**
  String get category1Description;

  /// No description provided for @category2.
  ///
  /// In en, this message translates to:
  /// **'Category 2'**
  String get category2;

  /// No description provided for @category2Description.
  ///
  /// In en, this message translates to:
  /// **'Intermediate level players'**
  String get category2Description;

  /// No description provided for @category3.
  ///
  /// In en, this message translates to:
  /// **'Category 3'**
  String get category3;

  /// No description provided for @category3Description.
  ///
  /// In en, this message translates to:
  /// **'Advanced level players'**
  String get category3Description;

  /// No description provided for @everythingReady.
  ///
  /// In en, this message translates to:
  /// **'Everything\'s ready, {firstName}!'**
  String everythingReady(Object firstName);

  /// No description provided for @timeToFindCourtsPlayersMatches.
  ///
  /// In en, this message translates to:
  /// **'Time to find courts, players, and matches near you.'**
  String get timeToFindCourtsPlayersMatches;

  /// No description provided for @profileSummary.
  ///
  /// In en, this message translates to:
  /// **'Profile Summary'**
  String get profileSummary;

  /// No description provided for @findSportsCourtsNearMe.
  ///
  /// In en, this message translates to:
  /// **'Find sports courts near me'**
  String get findSportsCourtsNearMe;

  /// No description provided for @classes.
  ///
  /// In en, this message translates to:
  /// **'Classes'**
  String get classes;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches'**
  String get matches;

  /// No description provided for @courts.
  ///
  /// In en, this message translates to:
  /// **'Courts'**
  String get courts;

  /// No description provided for @agenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agenda;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get chooseLanguage;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @myChats.
  ///
  /// In en, this message translates to:
  /// **'My Chats'**
  String get myChats;

  /// No description provided for @signInToViewYourChatsAndConversations.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your chats & conversations'**
  String get signInToViewYourChatsAndConversations;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No chats found'**
  String get noChatsFound;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @classroom.
  ///
  /// In en, this message translates to:
  /// **'Classroom'**
  String get classroom;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get you;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'players'**
  String get players;

  /// No description provided for @playersInChat.
  ///
  /// In en, this message translates to:
  /// **'{count} players in chat'**
  String playersInChat(int count);

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeYourMessage;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// No description provided for @classDetails.
  ///
  /// In en, this message translates to:
  /// **'Class Details'**
  String get classDetails;

  /// No description provided for @registrationUntil.
  ///
  /// In en, this message translates to:
  /// **'Registration until {date}'**
  String registrationUntil(String date);

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @classFull.
  ///
  /// In en, this message translates to:
  /// **'Class Full'**
  String get classFull;

  /// No description provided for @confirmLesson.
  ///
  /// In en, this message translates to:
  /// **'Confirm Lesson'**
  String get confirmLesson;

  /// No description provided for @registrationClosed.
  ///
  /// In en, this message translates to:
  /// **'Registration Closed'**
  String get registrationClosed;

  /// No description provided for @classBooked.
  ///
  /// In en, this message translates to:
  /// **'Class Booked'**
  String get classBooked;

  /// No description provided for @classConfirmedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your class is confirmed. We look forward to seeing you!'**
  String get classConfirmedMessage;

  /// No description provided for @categoryWithLevel.
  ///
  /// In en, this message translates to:
  /// **'Category {level}'**
  String categoryWithLevel(String level);

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @availableClasses.
  ///
  /// In en, this message translates to:
  /// **'Available Classes'**
  String get availableClasses;

  /// No description provided for @noClassesFound.
  ///
  /// In en, this message translates to:
  /// **'No classes found.'**
  String get noClassesFound;

  /// No description provided for @searchByName.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchByName;

  /// No description provided for @todayWithDate.
  ///
  /// In en, this message translates to:
  /// **'Today, {date}'**
  String todayWithDate(String date);

  /// No description provided for @tomorrowWithDate.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow, {date}'**
  String tomorrowWithDate(String date);

  /// No description provided for @signInToBookThisClass.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book this class'**
  String get signInToBookThisClass;

  /// No description provided for @loginToReserveYourSpot.
  ///
  /// In en, this message translates to:
  /// **'Please log in or create an account to reserve your spot.'**
  String get loginToReserveYourSpot;

  /// No description provided for @signInToJoinThismatch.
  ///
  /// In en, this message translates to:
  /// **'Sign in to join this match'**
  String get signInToJoinThismatch;

  /// No description provided for @signInToJoinOpenMatch.
  ///
  /// In en, this message translates to:
  /// **'Please log in or create an account to join open matches.'**
  String get signInToJoinOpenMatch;

  /// No description provided for @paymentForLesson.
  ///
  /// In en, this message translates to:
  /// **'Payment For Lesson'**
  String get paymentForLesson;

  /// No description provided for @afterPaymentCoachApproval.
  ///
  /// In en, this message translates to:
  /// **'After payment, your request will be sent to the Coach for approval.'**
  String get afterPaymentCoachApproval;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT METHOD'**
  String get paymentMethod;

  /// No description provided for @insufficientPortfolioBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient portfolio balance'**
  String get insufficientPortfolioBalance;

  /// No description provided for @agreeToTermsOfUse.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms of use.'**
  String get agreeToTermsOfUse;

  /// No description provided for @filters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filters;

  /// No description provided for @timeOfDay.
  ///
  /// In en, this message translates to:
  /// **'Time of Day'**
  String get timeOfDay;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @morningTime.
  ///
  /// In en, this message translates to:
  /// **'6 AM - 12 PM'**
  String get morningTime;

  /// No description provided for @afternoonTime.
  ///
  /// In en, this message translates to:
  /// **'12 PM - 6 PM'**
  String get afternoonTime;

  /// No description provided for @nightTime.
  ///
  /// In en, this message translates to:
  /// **'6 PM - 12 AM'**
  String get nightTime;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @allLevels.
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get allLevels;

  /// No description provided for @selectLevels.
  ///
  /// In en, this message translates to:
  /// **'Select Levels'**
  String get selectLevels;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @levelOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get levelOpen;

  /// No description provided for @levelBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelCategoryNumber.
  ///
  /// In en, this message translates to:
  /// **'Category {number}'**
  String levelCategoryNumber(String number);

  /// No description provided for @levelCategoryLetter.
  ///
  /// In en, this message translates to:
  /// **'Category {letter}'**
  String levelCategoryLetter(String letter);

  /// No description provided for @genderMen.
  ///
  /// In en, this message translates to:
  /// **'Men'**
  String get genderMen;

  /// No description provided for @genderWomen.
  ///
  /// In en, this message translates to:
  /// **'Women'**
  String get genderWomen;

  /// No description provided for @genderMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get genderMixed;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search..'**
  String get search;

  /// No description provided for @distance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get distance;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @showResults.
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get showResults;

  /// No description provided for @padel.
  ///
  /// In en, this message translates to:
  /// **'Padel'**
  String get padel;

  /// No description provided for @tennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get tennis;

  /// No description provided for @beachTennis.
  ///
  /// In en, this message translates to:
  /// **'Beach Tennis'**
  String get beachTennis;

  /// No description provided for @pickleball.
  ///
  /// In en, this message translates to:
  /// **'Pickleball'**
  String get pickleball;

  /// No description provided for @signInToBookThisCourt.
  ///
  /// In en, this message translates to:
  /// **'Sign in to book this court'**
  String get signInToBookThisCourt;

  /// No description provided for @pleaseLogInCreateAccountToReserveYourSpot.
  ///
  /// In en, this message translates to:
  /// **'Please log in or create an account to reserve your spot.'**
  String get pleaseLogInCreateAccountToReserveYourSpot;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signup;

  /// No description provided for @findCourtsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find courts near you.'**
  String get findCourtsNearYou;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noCourtsMatchSearchFilters.
  ///
  /// In en, this message translates to:
  /// **'No courts match your search/filters.'**
  String get noCourtsMatchSearchFilters;

  /// No description provided for @resetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get resetFilters;

  /// No description provided for @availableTimeSlots.
  ///
  /// In en, this message translates to:
  /// **'Available Time Slots'**
  String get availableTimeSlots;

  /// No description provided for @noSportsInformationAvailable.
  ///
  /// In en, this message translates to:
  /// **'No sports information available for this club.'**
  String get noSportsInformationAvailable;

  /// No description provided for @noCourtsOfferThisSport.
  ///
  /// In en, this message translates to:
  /// **'No courts offer this sport yet.'**
  String get noCourtsOfferThisSport;

  /// No description provided for @noSlotsPublishedForDate.
  ///
  /// In en, this message translates to:
  /// **'No slots published for this date.'**
  String get noSlotsPublishedForDate;

  /// No description provided for @clubDetails.
  ///
  /// In en, this message translates to:
  /// **'Club Details'**
  String get clubDetails;

  /// No description provided for @distanceKm.
  ///
  /// In en, this message translates to:
  /// **'< {distance} km'**
  String distanceKm(String distance);

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @full.
  ///
  /// In en, this message translates to:
  /// **'Full'**
  String get full;

  /// No description provided for @slotsLeft.
  ///
  /// In en, this message translates to:
  /// **'Slots Left'**
  String get slotsLeft;

  /// No description provided for @invitePlayers.
  ///
  /// In en, this message translates to:
  /// **'Invite Players'**
  String get invitePlayers;

  /// No description provided for @cancelInvite.
  ///
  /// In en, this message translates to:
  /// **'CANCEL INVITE'**
  String get cancelInvite;

  /// No description provided for @invite.
  ///
  /// In en, this message translates to:
  /// **'INVITE'**
  String get invite;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @yourCourtIsReserved.
  ///
  /// In en, this message translates to:
  /// **'Your court is reserved. Get ready for\nan amazing match.'**
  String get yourCourtIsReserved;

  /// No description provided for @bookingSummary.
  ///
  /// In en, this message translates to:
  /// **'Booking Summary'**
  String get bookingSummary;

  /// No description provided for @courtDetails.
  ///
  /// In en, this message translates to:
  /// **'COURT DETAILS'**
  String get courtDetails;

  /// No description provided for @court.
  ///
  /// In en, this message translates to:
  /// **'COURT'**
  String get court;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'TIME'**
  String get time;

  /// No description provided for @bookingType.
  ///
  /// In en, this message translates to:
  /// **'BOOKING TYPE'**
  String get bookingType;

  /// No description provided for @reserveIndividual.
  ///
  /// In en, this message translates to:
  /// **'Reserve Individual'**
  String get reserveIndividual;

  /// No description provided for @createAMatch.
  ///
  /// In en, this message translates to:
  /// **'Create a Match'**
  String get createAMatch;

  /// No description provided for @bookCourtWithoutMatch.
  ///
  /// In en, this message translates to:
  /// **'Book the court without creating a match in the app.'**
  String get bookCourtWithoutMatch;

  /// No description provided for @createGameForPlayers.
  ///
  /// In en, this message translates to:
  /// **'Create a game where other players can join.'**
  String get createGameForPlayers;

  /// No description provided for @book.
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get book;

  /// No description provided for @configureMatch.
  ///
  /// In en, this message translates to:
  /// **'Configure Match'**
  String get configureMatch;

  /// No description provided for @matchType.
  ///
  /// In en, this message translates to:
  /// **'MATCH TYPE'**
  String get matchType;

  /// No description provided for @invitePlayersSection.
  ///
  /// In en, this message translates to:
  /// **'INVITE PLAYERS'**
  String get invitePlayersSection;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get payment;

  /// No description provided for @searchPlayers.
  ///
  /// In en, this message translates to:
  /// **'Search players...'**
  String get searchPlayers;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @privateMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Only invited players can join.'**
  String get privateMatchDescription;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @openMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Other players can join the match.'**
  String get openMatchDescription;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @double.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get double;

  /// No description provided for @payAllReceiveLater.
  ///
  /// In en, this message translates to:
  /// **'Pay everything now and receive later'**
  String get payAllReceiveLater;

  /// No description provided for @payOnlyMyPart.
  ///
  /// In en, this message translates to:
  /// **'Pay only my part'**
  String get payOnlyMyPart;

  /// No description provided for @payAllNoSplit.
  ///
  /// In en, this message translates to:
  /// **'Pay everything now without splitting later'**
  String get payAllNoSplit;

  /// No description provided for @payAllReceiveLaterDescription.
  ///
  /// In en, this message translates to:
  /// **'Court is already booked now, and you receive other players parts automatically after the match.'**
  String get payAllReceiveLaterDescription;

  /// No description provided for @payOnlyMyPartDescription.
  ///
  /// In en, this message translates to:
  /// **'Court is not booked yet. It will only be booked when everyone joins. Risk loosing booking'**
  String get payOnlyMyPartDescription;

  /// No description provided for @payALlNoSplitDescription.
  ///
  /// In en, this message translates to:
  /// **'Invited players can join without paying anything.'**
  String get payALlNoSplitDescription;

  /// No description provided for @bookingDateAndTime.
  ///
  /// In en, this message translates to:
  /// **'{date} | {time}'**
  String bookingDateAndTime(String date, String time);

  /// No description provided for @doubleFormat.
  ///
  /// In en, this message translates to:
  /// **'Double'**
  String get doubleFormat;

  /// No description provided for @portfolio.
  ///
  /// In en, this message translates to:
  /// **'Portfolio'**
  String get portfolio;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @priceDetails.
  ///
  /// In en, this message translates to:
  /// **'PRICE DETAILS'**
  String get priceDetails;

  /// No description provided for @courtFee.
  ///
  /// In en, this message translates to:
  /// **'Court Fee'**
  String get courtFee;

  /// No description provided for @serviceFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get serviceFee;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @portfolioPayment.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Payment'**
  String get portfolioPayment;

  /// No description provided for @cardPayment.
  ///
  /// In en, this message translates to:
  /// **'Card Payment'**
  String get cardPayment;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change Location'**
  String get changeLocation;

  /// No description provided for @searchLocation.
  ///
  /// In en, this message translates to:
  /// **'Search location'**
  String get searchLocation;

  /// No description provided for @noLocationsFound.
  ///
  /// In en, this message translates to:
  /// **'No locations found'**
  String get noLocationsFound;

  /// No description provided for @currentLocation.
  ///
  /// In en, this message translates to:
  /// **'Current location'**
  String get currentLocation;

  /// No description provided for @searchCity.
  ///
  /// In en, this message translates to:
  /// **'Search city'**
  String get searchCity;

  /// No description provided for @withinDistance.
  ///
  /// In en, this message translates to:
  /// **'Within {distance} km'**
  String withinDistance(Object distance);

  /// No description provided for @anyDistance.
  ///
  /// In en, this message translates to:
  /// **'Any distance'**
  String get anyDistance;

  /// No description provided for @noAvailableSlotsForDay.
  ///
  /// In en, this message translates to:
  /// **'No available slots for this day'**
  String get noAvailableSlotsForDay;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @noCourtsWithLocationToShowHereYet.
  ///
  /// In en, this message translates to:
  /// **'No courts with a location to show here yet'**
  String get noCourtsWithLocationToShowHereYet;

  /// No description provided for @searchCourts.
  ///
  /// In en, this message translates to:
  /// **'Search Courts'**
  String get searchCourts;

  /// No description provided for @searchCourtsHint.
  ///
  /// In en, this message translates to:
  /// **'Search courts'**
  String get searchCourtsHint;

  /// No description provided for @noCourtsFound.
  ///
  /// In en, this message translates to:
  /// **'No courts found'**
  String get noCourtsFound;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @space.
  ///
  /// In en, this message translates to:
  /// **'space'**
  String get space;

  /// No description provided for @openMatches.
  ///
  /// In en, this message translates to:
  /// **'Open Matches'**
  String get openMatches;

  /// No description provided for @signInToViewJoinOpenMatches.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view & join open matches'**
  String get signInToViewJoinOpenMatches;

  /// No description provided for @noMatchesFound.
  ///
  /// In en, this message translates to:
  /// **'No matches found.'**
  String get noMatchesFound;

  /// No description provided for @gameFilters.
  ///
  /// In en, this message translates to:
  /// **'Game Filters'**
  String get gameFilters;

  /// No description provided for @allFormats.
  ///
  /// In en, this message translates to:
  /// **'All formats'**
  String get allFormats;

  /// No description provided for @singles.
  ///
  /// In en, this message translates to:
  /// **'Singles'**
  String get singles;

  /// No description provided for @doubles.
  ///
  /// In en, this message translates to:
  /// **'Doubles'**
  String get doubles;

  /// No description provided for @maxDistance.
  ///
  /// In en, this message translates to:
  /// **'Max Distance'**
  String get maxDistance;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @courtConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Court Confirmed'**
  String get courtConfirmed;

  /// No description provided for @pendingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Pending Confirmed'**
  String get pendingConfirmed;

  /// No description provided for @seatsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{{count} Seat} other{{count} Seats}}'**
  String seatsCount(int count);

  /// No description provided for @joinMatch.
  ///
  /// In en, this message translates to:
  /// **'Join Match'**
  String get joinMatch;

  /// No description provided for @sportMatchForPlayers.
  ///
  /// In en, this message translates to:
  /// **'{sport} match for players. Come play!'**
  String sportMatchForPlayers(String sport);

  /// No description provided for @sendMessageToAdmin.
  ///
  /// In en, this message translates to:
  /// **'Send message to admin'**
  String get sendMessageToAdmin;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @matchFee.
  ///
  /// In en, this message translates to:
  /// **'Match Fee'**
  String get matchFee;

  /// No description provided for @requestSent.
  ///
  /// In en, this message translates to:
  /// **'Request Sent'**
  String get requestSent;

  /// No description provided for @requestSentToOwner.
  ///
  /// In en, this message translates to:
  /// **'Your request was sent to the match owner. We\'ll notify you once it\'s approved.'**
  String get requestSentToOwner;

  /// No description provided for @moneyBackIfNotAccepted.
  ///
  /// In en, this message translates to:
  /// **'If you\'re not accepted, you will receive your money back automatically'**
  String get moneyBackIfNotAccepted;

  /// No description provided for @viewMatchesAnytimeIn.
  ///
  /// In en, this message translates to:
  /// **'View your pending, accepted, and past matches anytime in'**
  String get viewMatchesAnytimeIn;

  /// No description provided for @createMatch.
  ///
  /// In en, this message translates to:
  /// **'Create Match'**
  String get createMatch;

  /// No description provided for @wantToCreateMatch.
  ///
  /// In en, this message translates to:
  /// **'Want to create match?'**
  String get wantToCreateMatch;

  /// No description provided for @selectCourtToCreateMatch.
  ///
  /// In en, this message translates to:
  /// **'To create a match, first select an available court.'**
  String get selectCourtToCreateMatch;

  /// No description provided for @selectCourt.
  ///
  /// In en, this message translates to:
  /// **'Select Court'**
  String get selectCourt;

  /// No description provided for @playerDetails.
  ///
  /// In en, this message translates to:
  /// **'Player Details'**
  String get playerDetails;

  /// No description provided for @noPlayerDataFound.
  ///
  /// In en, this message translates to:
  /// **'No player data found'**
  String get noPlayerDataFound;

  /// No description provided for @aboutPlayer.
  ///
  /// In en, this message translates to:
  /// **'About Player'**
  String get aboutPlayer;

  /// No description provided for @gameInformation.
  ///
  /// In en, this message translates to:
  /// **'Game Information'**
  String get gameInformation;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @victories.
  ///
  /// In en, this message translates to:
  /// **'Victories'**
  String get victories;

  /// No description provided for @defeats.
  ///
  /// In en, this message translates to:
  /// **'Defeats'**
  String get defeats;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'Hours'**
  String get hours;

  /// No description provided for @feedBack.
  ///
  /// In en, this message translates to:
  /// **'Feed Back'**
  String get feedBack;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @myReservations.
  ///
  /// In en, this message translates to:
  /// **'My Reservations'**
  String get myReservations;

  /// No description provided for @signInToViewReservations.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view your reservations, games and lessons'**
  String get signInToViewReservations;

  /// No description provided for @myReservationsGamesAndLessons.
  ///
  /// In en, this message translates to:
  /// **'My Reservations,\nGames and Lessons'**
  String get myReservationsGamesAndLessons;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @nothingHereYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get nothingHereYet;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelRequest;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Rebook'**
  String get rebook;

  /// No description provided for @leaveThisMatch.
  ///
  /// In en, this message translates to:
  /// **'Leave this match'**
  String get leaveThisMatch;

  /// No description provided for @groupChat.
  ///
  /// In en, this message translates to:
  /// **'Group Chat'**
  String get groupChat;

  /// No description provided for @chatWithPlayers.
  ///
  /// In en, this message translates to:
  /// **'Chat with players'**
  String get chatWithPlayers;

  /// No description provided for @matchDetails.
  ///
  /// In en, this message translates to:
  /// **'Match Details'**
  String get matchDetails;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @invited.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get invited;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @invitedBy.
  ///
  /// In en, this message translates to:
  /// **'Invited by {name}'**
  String invitedBy(String name);

  /// No description provided for @editDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Details'**
  String get editDetails;

  /// No description provided for @deleteMatch.
  ///
  /// In en, this message translates to:
  /// **'Delete Match'**
  String get deleteMatch;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @signInToViewAndManageProfile.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view and manage your profile'**
  String get signInToViewAndManageProfile;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @manageYourAccountDetails.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details'**
  String get manageYourAccountDetails;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterYourLocation.
  ///
  /// In en, this message translates to:
  /// **'Enter your location'**
  String get enterYourLocation;

  /// No description provided for @emailCantChange.
  ///
  /// In en, this message translates to:
  /// **'Email (Can\'t Change)'**
  String get emailCantChange;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountWarning.
  ///
  /// In en, this message translates to:
  /// **'This will delete your account and you will need to create your account again.'**
  String get deleteAccountWarning;

  /// No description provided for @iUnderstandDeleteAccount.
  ///
  /// In en, this message translates to:
  /// **'I understand, delete account'**
  String get iUnderstandDeleteAccount;

  /// No description provided for @pleaseTellUsWhyYoureLeaving.
  ///
  /// In en, this message translates to:
  /// **'Please tell us why you\'re leaving'**
  String get pleaseTellUsWhyYoureLeaving;

  /// No description provided for @accountDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted Successfully'**
  String get accountDeletedSuccessfully;

  /// No description provided for @noUserIdFound.
  ///
  /// In en, this message translates to:
  /// **'No User Id found'**
  String get noUserIdFound;

  /// No description provided for @deleteReasonNoLongerNeed.
  ///
  /// In en, this message translates to:
  /// **'I no longer need the app.'**
  String get deleteReasonNoLongerNeed;

  /// No description provided for @deleteReasonCreateNew.
  ///
  /// In en, this message translates to:
  /// **'I want to delete this account and create a new one.'**
  String get deleteReasonCreateNew;

  /// No description provided for @deleteReasonTrouble.
  ///
  /// In en, this message translates to:
  /// **'Trouble using the app.'**
  String get deleteReasonTrouble;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @findBestCourtsNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find the best courts\n near you.'**
  String get findBestCourtsNearYou;

  /// No description provided for @discoverPremiumCourts.
  ///
  /// In en, this message translates to:
  /// **'Discover premium basketball, tennis, and pickleball courts in your area with ease.'**
  String get discoverPremiumCourts;

  /// No description provided for @joinOpenMatchesMeetPlayers.
  ///
  /// In en, this message translates to:
  /// **'Join open matches and\n meet new players'**
  String get joinOpenMatchesMeetPlayers;

  /// No description provided for @findLocalGames.
  ///
  /// In en, this message translates to:
  /// **'Find local games, level up your skills, and expand your sports circle effortlessly.'**
  String get findLocalGames;

  /// No description provided for @bookCourtsPlayMatches.
  ///
  /// In en, this message translates to:
  /// **'Book Courts & Play\n Matches'**
  String get bookCourtsPlayMatches;

  /// No description provided for @bookInstantly.
  ///
  /// In en, this message translates to:
  /// **'Book instantly and hit the court with your favorite partners.'**
  String get bookInstantly;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @expireDate.
  ///
  /// In en, this message translates to:
  /// **'Expire Date'**
  String get expireDate;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @cardholderName.
  ///
  /// In en, this message translates to:
  /// **'Cardholder name'**
  String get cardholderName;

  /// No description provided for @cardNumber.
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get cardNumber;

  /// No description provided for @mmYy.
  ///
  /// In en, this message translates to:
  /// **'MM/YY'**
  String get mmYy;

  /// No description provided for @cvv.
  ///
  /// In en, this message translates to:
  /// **'CVV'**
  String get cvv;

  /// No description provided for @secureEncryptedPayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Encrypted Payment'**
  String get secureEncryptedPayment;

  /// No description provided for @convenienceFee.
  ///
  /// In en, this message translates to:
  /// **'Convenience fee'**
  String get convenienceFee;

  /// No description provided for @playersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} players'**
  String playersCount(int count);

  /// No description provided for @slotsLeftCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Slots Left'**
  String slotsLeftCount(int count);

  /// No description provided for @portfolioBalance.
  ///
  /// In en, this message translates to:
  /// **'Portfolio Balance'**
  String get portfolioBalance;

  /// No description provided for @balanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Balance: {amount}'**
  String balanceAmount(String amount);

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// No description provided for @creditDebitCard.
  ///
  /// In en, this message translates to:
  /// **'Credit / Debit Card'**
  String get creditDebitCard;

  /// No description provided for @enterCardholderName.
  ///
  /// In en, this message translates to:
  /// **'Enter the cardholder name'**
  String get enterCardholderName;

  /// No description provided for @enterValidName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid name'**
  String get enterValidName;

  /// No description provided for @enterYourCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your card number'**
  String get enterYourCardNumber;

  /// No description provided for @enterValidCardNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid card number'**
  String get enterValidCardNumber;

  /// No description provided for @enterExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry date'**
  String get enterExpiryDate;

  /// No description provided for @enterExpiryAsMmYy.
  ///
  /// In en, this message translates to:
  /// **'Enter expiry as MM/YY'**
  String get enterExpiryAsMmYy;

  /// No description provided for @enterValidExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid expiry date'**
  String get enterValidExpiryDate;

  /// No description provided for @enterValidExpiryMonth.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid expiry month'**
  String get enterValidExpiryMonth;

  /// No description provided for @cardHasExpired.
  ///
  /// In en, this message translates to:
  /// **'Card has expired'**
  String get cardHasExpired;

  /// No description provided for @enterCvv.
  ///
  /// In en, this message translates to:
  /// **'Enter CVV'**
  String get enterCvv;

  /// No description provided for @enterValidCvv.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid CVV'**
  String get enterValidCvv;

  /// No description provided for @pleaseEnterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// No description provided for @pleaseEnterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// No description provided for @passwordCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordCannotBeEmpty;

  /// No description provided for @passwordMinEightCharacters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinEightCharacters;

  /// No description provided for @passwordMustContainLowercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get passwordMustContainLowercase;

  /// No description provided for @passwordMustContainUppercase.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get passwordMustContainUppercase;

  /// No description provided for @passwordMustContainNumber.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get passwordMustContainNumber;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter name'**
  String get pleaseEnterName;

  /// No description provided for @fullNameMinFiveCharacters.
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 5 characters'**
  String get fullNameMinFiveCharacters;

  /// No description provided for @fullNameMaxFortyCharacters.
  ///
  /// In en, this message translates to:
  /// **'Full name must be less than 40 characters'**
  String get fullNameMaxFortyCharacters;

  /// No description provided for @cannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cannot be empty'**
  String get cannotBeEmpty;

  /// No description provided for @enterAValidNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get enterAValidNumber;

  /// No description provided for @addressCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Address can\'t be empty'**
  String get addressCannotBeEmpty;

  /// No description provided for @addressMinTenCharacters.
  ///
  /// In en, this message translates to:
  /// **'Address must be at least 10 characters'**
  String get addressMinTenCharacters;

  /// No description provided for @collegeNameCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'College name can not be empty'**
  String get collegeNameCannotBeEmpty;

  /// No description provided for @pleaseEnterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL (e.g., https://example.com)'**
  String get pleaseEnterValidUrl;

  /// No description provided for @pleaseEnterBreedName.
  ///
  /// In en, this message translates to:
  /// **'Please enter breed name'**
  String get pleaseEnterBreedName;

  /// No description provided for @todayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayLabel;

  /// No description provided for @yesterdayLabel.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayLabel;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String daysAgo(int count);

  /// No description provided for @weeksAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 week ago} other{{count} weeks ago}}'**
  String weeksAgo(int count);

  /// No description provided for @monthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 month ago} other{{count} months ago}}'**
  String monthsAgo(int count);

  /// No description provided for @yearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 year ago} other{{count} years ago}}'**
  String yearsAgo(int count);

  /// No description provided for @formattedDistanceKm.
  ///
  /// In en, this message translates to:
  /// **'{distance} km'**
  String formattedDistanceKm(String distance);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
