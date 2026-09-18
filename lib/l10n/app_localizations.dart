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
  /// **'6h - 12h'**
  String get morningTime;

  /// No description provided for @afternoonTime.
  ///
  /// In en, this message translates to:
  /// **'12h - 18h'**
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
  /// **'Pay all, receive later'**
  String get payAllReceiveLater;

  /// No description provided for @payOnlyMyPart.
  ///
  /// In en, this message translates to:
  /// **'Pay only my part'**
  String get payOnlyMyPart;

  /// No description provided for @payAllReceiveLaterDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay the full amount now and collect the other players\' share later.'**
  String get payAllReceiveLaterDescription;

  /// No description provided for @payOnlyMyPartDescription.
  ///
  /// In en, this message translates to:
  /// **'Pay only your share of the booking.'**
  String get payOnlyMyPartDescription;

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
