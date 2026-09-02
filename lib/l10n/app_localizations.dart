import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'SarcoCare'**
  String get appTitle;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @splashTagline.
  ///
  /// In en, this message translates to:
  /// **'App that cares for muscle\nhealth in the elderly'**
  String get splashTagline;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @loginWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get loginWelcome;

  /// No description provided for @loginIntoPrefix.
  ///
  /// In en, this message translates to:
  /// **'Log into '**
  String get loginIntoPrefix;

  /// No description provided for @rolePatient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get rolePatient;

  /// No description provided for @roleCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Caretaker'**
  String get roleCaretaker;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumber;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get phoneNumberHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter password'**
  String get passwordHint;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @noAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccountQuestion;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signupTitle;

  /// No description provided for @signupJoinPrefix.
  ///
  /// In en, this message translates to:
  /// **'Join '**
  String get signupJoinPrefix;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get fullNameHint;

  /// No description provided for @createPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Create a password'**
  String get createPasswordHint;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter password'**
  String get confirmPasswordHint;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @haveAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccountQuestion;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get navExercise;

  /// No description provided for @navHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get navHealth;

  /// No description provided for @navKnowledge.
  ///
  /// In en, this message translates to:
  /// **'Knowledge'**
  String get navKnowledge;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @homeGreetingName.
  ///
  /// In en, this message translates to:
  /// **'{name}! 👋'**
  String homeGreetingName(String name);

  /// No description provided for @userFirstName.
  ///
  /// In en, this message translates to:
  /// **'Somchai'**
  String get userFirstName;

  /// No description provided for @caretakerWantsToBe.
  ///
  /// In en, this message translates to:
  /// **'{name} wants to be your caretaker'**
  String caretakerWantsToBe(String name);

  /// No description provided for @tapToReview.
  ///
  /// In en, this message translates to:
  /// **'Tap to review'**
  String get tapToReview;

  /// No description provided for @caretakerNowYours.
  ///
  /// In en, this message translates to:
  /// **'{name} is now your caretaker'**
  String caretakerNowYours(String name);

  /// No description provided for @requestDeclined.
  ///
  /// In en, this message translates to:
  /// **'Request declined'**
  String get requestDeclined;

  /// No description provided for @dailyGoals.
  ///
  /// In en, this message translates to:
  /// **'Daily Goals'**
  String get dailyGoals;

  /// No description provided for @goalProtein.
  ///
  /// In en, this message translates to:
  /// **'Eat enough protein'**
  String get goalProtein;

  /// No description provided for @goalExercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise 15 minutes'**
  String get goalExercise;

  /// No description provided for @goalWater.
  ///
  /// In en, this message translates to:
  /// **'Drink 6–8 glasses of water'**
  String get goalWater;

  /// No description provided for @whatWouldYouLikeToDo.
  ///
  /// In en, this message translates to:
  /// **'What would you like to do?'**
  String get whatWouldYouLikeToDo;

  /// No description provided for @featureMealMenus.
  ///
  /// In en, this message translates to:
  /// **'Meal Menus'**
  String get featureMealMenus;

  /// No description provided for @featureExercisePlan.
  ///
  /// In en, this message translates to:
  /// **'Exercise Plan'**
  String get featureExercisePlan;

  /// No description provided for @featureSarcfAssessment.
  ///
  /// In en, this message translates to:
  /// **'SARC-F Assessment'**
  String get featureSarcfAssessment;

  /// No description provided for @featureHealthTracking.
  ///
  /// In en, this message translates to:
  /// **'Health Tracking'**
  String get featureHealthTracking;

  /// No description provided for @userFullNameTitled.
  ///
  /// In en, this message translates to:
  /// **'Mr. Somchai Jai-Dee'**
  String get userFullNameTitled;

  /// No description provided for @userFullName.
  ///
  /// In en, this message translates to:
  /// **'Somchai Jai-Dee'**
  String get userFullName;

  /// No description provided for @profileAge.
  ///
  /// In en, this message translates to:
  /// **'Age: {age}'**
  String profileAge(int age);

  /// No description provided for @entryPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Info'**
  String get entryPersonalInfo;

  /// No description provided for @entryUsageSummary.
  ///
  /// In en, this message translates to:
  /// **'Usage Summary'**
  String get entryUsageSummary;

  /// No description provided for @entryCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Caretaker'**
  String get entryCaretaker;

  /// No description provided for @entrySetupApp.
  ///
  /// In en, this message translates to:
  /// **'Setup App'**
  String get entrySetupApp;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @setupLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get setupLanguage;

  /// No description provided for @setupDeviceSetup.
  ///
  /// In en, this message translates to:
  /// **'Device Setup'**
  String get setupDeviceSetup;

  /// No description provided for @setupLargeText.
  ///
  /// In en, this message translates to:
  /// **'Large Text'**
  String get setupLargeText;

  /// No description provided for @setupSound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get setupSound;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageThai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get languageThai;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select language'**
  String get selectLanguage;

  /// No description provided for @fieldAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get fieldAge;

  /// No description provided for @fieldGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get fieldGender;

  /// No description provided for @fieldEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get fieldEmail;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @tabDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get tabDaily;

  /// No description provided for @tabWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get tabWeekly;

  /// No description provided for @tabMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get tabMonthly;

  /// No description provided for @seriesDailyAverage.
  ///
  /// In en, this message translates to:
  /// **'Daily average'**
  String get seriesDailyAverage;

  /// No description provided for @seriesWeeklyAverage.
  ///
  /// In en, this message translates to:
  /// **'Weekly average'**
  String get seriesWeeklyAverage;

  /// No description provided for @seriesMonthlyAverage.
  ///
  /// In en, this message translates to:
  /// **'Monthly average'**
  String get seriesMonthlyAverage;

  /// No description provided for @activityScore.
  ///
  /// In en, this message translates to:
  /// **'Activity score'**
  String get activityScore;

  /// No description provided for @dayInitialMon.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get dayInitialMon;

  /// No description provided for @dayInitialTue.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayInitialTue;

  /// No description provided for @dayInitialWed.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get dayInitialWed;

  /// No description provided for @dayInitialThu.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get dayInitialThu;

  /// No description provided for @dayInitialFri.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get dayInitialFri;

  /// No description provided for @dayInitialSat.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayInitialSat;

  /// No description provided for @dayInitialSun.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get dayInitialSun;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @weekLabel.
  ///
  /// In en, this message translates to:
  /// **'W{number}'**
  String weekLabel(int number);

  /// No description provided for @metricWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get metricWeight;

  /// No description provided for @metricHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get metricHeight;

  /// No description provided for @metricBmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get metricBmi;

  /// No description provided for @metricCalf.
  ///
  /// In en, this message translates to:
  /// **'Calf Circumference'**
  String get metricCalf;

  /// No description provided for @metricHandgrip.
  ///
  /// In en, this message translates to:
  /// **'Handgrip'**
  String get metricHandgrip;

  /// No description provided for @badgeNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get badgeNormal;

  /// No description provided for @addData.
  ///
  /// In en, this message translates to:
  /// **'Add Data'**
  String get addData;

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @enterValueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter {label}'**
  String enterValueHint(String label);

  /// No description provided for @healthDataSaved.
  ///
  /// In en, this message translates to:
  /// **'Health data saved'**
  String get healthDataSaved;

  /// No description provided for @setReminders.
  ///
  /// In en, this message translates to:
  /// **'Set Reminders'**
  String get setReminders;

  /// No description provided for @turnRemindersOnOff.
  ///
  /// In en, this message translates to:
  /// **'Turn reminders on or off'**
  String get turnRemindersOnOff;

  /// No description provided for @mealBreakfast.
  ///
  /// In en, this message translates to:
  /// **'Breakfast'**
  String get mealBreakfast;

  /// No description provided for @mealLunch.
  ///
  /// In en, this message translates to:
  /// **'Lunch'**
  String get mealLunch;

  /// No description provided for @mealDinner.
  ///
  /// In en, this message translates to:
  /// **'Dinner'**
  String get mealDinner;

  /// No description provided for @mealSnack.
  ///
  /// In en, this message translates to:
  /// **'Snack'**
  String get mealSnack;

  /// No description provided for @reminderWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get reminderWater;

  /// No description provided for @reminderMedication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get reminderMedication;

  /// No description provided for @reminderSleep.
  ///
  /// In en, this message translates to:
  /// **'Sleep'**
  String get reminderSleep;

  /// No description provided for @reminderEvery2Hours.
  ///
  /// In en, this message translates to:
  /// **'Every 2 hours'**
  String get reminderEvery2Hours;

  /// No description provided for @catAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catAll;

  /// No description provided for @catFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get catFood;

  /// No description provided for @catPrevention.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get catPrevention;

  /// No description provided for @artOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get artOverviewTitle;

  /// No description provided for @artOverviewSummary.
  ///
  /// In en, this message translates to:
  /// **'A quick introduction to muscle health'**
  String get artOverviewSummary;

  /// No description provided for @artWhatIsTitle.
  ///
  /// In en, this message translates to:
  /// **'What is Sarcopenia?'**
  String get artWhatIsTitle;

  /// No description provided for @artWhatIsSummary.
  ///
  /// In en, this message translates to:
  /// **'Understanding age-related muscle loss'**
  String get artWhatIsSummary;

  /// No description provided for @artCausesTitle.
  ///
  /// In en, this message translates to:
  /// **'Causes and Risk Factors'**
  String get artCausesTitle;

  /// No description provided for @artCausesSummary.
  ///
  /// In en, this message translates to:
  /// **'What raises your risk'**
  String get artCausesSummary;

  /// No description provided for @artExerciseGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Guide'**
  String get artExerciseGuideTitle;

  /// No description provided for @artExerciseGuideSummary.
  ///
  /// In en, this message translates to:
  /// **'Safe movements to stay strong'**
  String get artExerciseGuideSummary;

  /// No description provided for @artNutritionTitle.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get artNutritionTitle;

  /// No description provided for @artNutritionSummary.
  ///
  /// In en, this message translates to:
  /// **'Eating well for your muscles'**
  String get artNutritionSummary;

  /// No description provided for @artPreventionTitle.
  ///
  /// In en, this message translates to:
  /// **'Prevention'**
  String get artPreventionTitle;

  /// No description provided for @artPreventionSummary.
  ///
  /// In en, this message translates to:
  /// **'Daily habits that protect you'**
  String get artPreventionSummary;

  /// No description provided for @articleAppbar.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get articleAppbar;

  /// No description provided for @chipReadTime.
  ///
  /// In en, this message translates to:
  /// **'3 min read'**
  String get chipReadTime;

  /// No description provided for @articleParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Sarcopenia is the gradual loss of muscle mass, strength and function that often comes with ageing. It can make everyday tasks — standing up, climbing stairs, carrying shopping — feel harder over time.'**
  String get articleParagraph1;

  /// No description provided for @articleParagraph2.
  ///
  /// In en, this message translates to:
  /// **'The good news is that it can be slowed and even improved. Regular strength activity and eating enough protein are two of the most effective steps you can take at any age.'**
  String get articleParagraph2;

  /// No description provided for @articleParagraph3.
  ///
  /// In en, this message translates to:
  /// **'Small, consistent habits matter most. A short daily walk, a few seated exercises, and a protein source at each meal all add up to stronger, healthier muscles.'**
  String get articleParagraph3;

  /// No description provided for @mealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get mealsTitle;

  /// No description provided for @sectionSuggestedToday.
  ///
  /// In en, this message translates to:
  /// **'Suggested Meals for Today'**
  String get sectionSuggestedToday;

  /// No description provided for @sectionThisWeekPlan.
  ///
  /// In en, this message translates to:
  /// **'This Week\'s Plan'**
  String get sectionThisWeekPlan;

  /// No description provided for @viewRecipes.
  ///
  /// In en, this message translates to:
  /// **'View Recipes'**
  String get viewRecipes;

  /// No description provided for @mealEggsToast.
  ///
  /// In en, this message translates to:
  /// **'Soft-boiled Eggs & Toast'**
  String get mealEggsToast;

  /// No description provided for @mealChickenSalad.
  ///
  /// In en, this message translates to:
  /// **'Grilled Chicken Salad'**
  String get mealChickenSalad;

  /// No description provided for @mealSalmonVeg.
  ///
  /// In en, this message translates to:
  /// **'Salmon with Vegetables'**
  String get mealSalmonVeg;

  /// No description provided for @mealYogurtNuts.
  ///
  /// In en, this message translates to:
  /// **'Greek Yogurt & Nuts'**
  String get mealYogurtNuts;

  /// No description provided for @mealOatmeal.
  ///
  /// In en, this message translates to:
  /// **'Oatmeal & Berries'**
  String get mealOatmeal;

  /// No description provided for @mealTuna.
  ///
  /// In en, this message translates to:
  /// **'Tuna Sandwich'**
  String get mealTuna;

  /// No description provided for @mealTofu.
  ///
  /// In en, this message translates to:
  /// **'Tofu Stir-fry'**
  String get mealTofu;

  /// No description provided for @mealBeefBroccoli.
  ///
  /// In en, this message translates to:
  /// **'Beef & Broccoli'**
  String get mealBeefBroccoli;

  /// No description provided for @mealLentil.
  ///
  /// In en, this message translates to:
  /// **'Lentil Soup'**
  String get mealLentil;

  /// No description provided for @mealChickenRice.
  ///
  /// In en, this message translates to:
  /// **'Chicken & Rice'**
  String get mealChickenRice;

  /// No description provided for @mealEggRice.
  ///
  /// In en, this message translates to:
  /// **'Egg Fried Rice'**
  String get mealEggRice;

  /// No description provided for @proteinGrams.
  ///
  /// In en, this message translates to:
  /// **'Protein {grams}g'**
  String proteinGrams(int grams);

  /// No description provided for @dayAbbrevMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get dayAbbrevMon;

  /// No description provided for @dayAbbrevTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get dayAbbrevTue;

  /// No description provided for @dayAbbrevWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get dayAbbrevWed;

  /// No description provided for @dayAbbrevThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get dayAbbrevThu;

  /// No description provided for @dayAbbrevFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get dayAbbrevFri;

  /// No description provided for @dayAbbrevSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get dayAbbrevSat;

  /// No description provided for @dayAbbrevSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get dayAbbrevSun;

  /// No description provided for @searchRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Search Recipes'**
  String get searchRecipesTitle;

  /// No description provided for @searchRecipesHint.
  ///
  /// In en, this message translates to:
  /// **'Search recipes'**
  String get searchRecipesHint;

  /// No description provided for @noRecipesMatch.
  ///
  /// In en, this message translates to:
  /// **'No recipes match \"{query}\"'**
  String noRecipesMatch(String query);

  /// No description provided for @nutrLabelProtein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get nutrLabelProtein;

  /// No description provided for @nutrLabelEnergy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get nutrLabelEnergy;

  /// No description provided for @nutrLabelFat.
  ///
  /// In en, this message translates to:
  /// **'Fat'**
  String get nutrLabelFat;

  /// No description provided for @sectionIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get sectionIngredients;

  /// No description provided for @sectionMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get sectionMethod;

  /// No description provided for @ingredient1.
  ///
  /// In en, this message translates to:
  /// **'2 fresh eggs'**
  String get ingredient1;

  /// No description provided for @ingredient2.
  ///
  /// In en, this message translates to:
  /// **'2 slices wholegrain toast'**
  String get ingredient2;

  /// No description provided for @ingredient3.
  ///
  /// In en, this message translates to:
  /// **'1 tsp olive oil'**
  String get ingredient3;

  /// No description provided for @ingredient4.
  ///
  /// In en, this message translates to:
  /// **'A pinch of salt and pepper'**
  String get ingredient4;

  /// No description provided for @method1.
  ///
  /// In en, this message translates to:
  /// **'Bring a small pot of water to a gentle boil.'**
  String get method1;

  /// No description provided for @method2.
  ///
  /// In en, this message translates to:
  /// **'Lower the eggs in and cook for 6–7 minutes.'**
  String get method2;

  /// No description provided for @method3.
  ///
  /// In en, this message translates to:
  /// **'Cool under running water, then peel.'**
  String get method3;

  /// No description provided for @method4.
  ///
  /// In en, this message translates to:
  /// **'Serve with toast, a drizzle of oil and seasoning.'**
  String get method4;

  /// No description provided for @completeMealAndLog.
  ///
  /// In en, this message translates to:
  /// **'Complete Meal and Log'**
  String get completeMealAndLog;

  /// No description provided for @mealLoggedToday.
  ///
  /// In en, this message translates to:
  /// **'Meal logged for today'**
  String get mealLoggedToday;

  /// No description provided for @planTypeBasicStrength.
  ///
  /// In en, this message translates to:
  /// **'Basic Strength Training'**
  String get planTypeBasicStrength;

  /// No description provided for @exerciseTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String exerciseTypeLabel(String type);

  /// No description provided for @tabExercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get tabExercises;

  /// No description provided for @exSeatedLegLift.
  ///
  /// In en, this message translates to:
  /// **'Seated Leg Lift'**
  String get exSeatedLegLift;

  /// No description provided for @exArmCurls.
  ///
  /// In en, this message translates to:
  /// **'Arm Curls'**
  String get exArmCurls;

  /// No description provided for @exChairSquats.
  ///
  /// In en, this message translates to:
  /// **'Chair Squats'**
  String get exChairSquats;

  /// No description provided for @exStandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Standing Balance'**
  String get exStandingBalance;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String durationMinutes(int count);

  /// No description provided for @durationHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutes(int hours, int minutes);

  /// No description provided for @sectionInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get sectionInstructions;

  /// No description provided for @instruction1.
  ///
  /// In en, this message translates to:
  /// **'Perform 10–15 reps per set'**
  String get instruction1;

  /// No description provided for @instruction2.
  ///
  /// In en, this message translates to:
  /// **'2–3 sets with short rests'**
  String get instruction2;

  /// No description provided for @instruction3.
  ///
  /// In en, this message translates to:
  /// **'Sit tall and move slowly and steadily'**
  String get instruction3;

  /// No description provided for @instruction4.
  ///
  /// In en, this message translates to:
  /// **'Follow the clear step-by-step video'**
  String get instruction4;

  /// No description provided for @startExercise.
  ///
  /// In en, this message translates to:
  /// **'Start Exercise'**
  String get startExercise;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @exerciseCompletedLogged.
  ///
  /// In en, this message translates to:
  /// **'Exercise completed and logged'**
  String get exerciseCompletedLogged;

  /// No description provided for @myPlanTitle.
  ///
  /// In en, this message translates to:
  /// **'My Plan'**
  String get myPlanTitle;

  /// No description provided for @tabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get tabToday;

  /// No description provided for @tabThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get tabThisWeek;

  /// No description provided for @tabThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get tabThisMonth;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s progress'**
  String get todaysProgress;

  /// No description provided for @exercisesDone.
  ///
  /// In en, this message translates to:
  /// **'{done} of {total} exercises done'**
  String exercisesDone(int done, int total);

  /// No description provided for @beginExercise.
  ///
  /// In en, this message translates to:
  /// **'Begin Exercise'**
  String get beginExercise;

  /// No description provided for @sarcfProgress.
  ///
  /// In en, this message translates to:
  /// **'SARC-F ({current}/{total})'**
  String sarcfProgress(int current, int total);

  /// No description provided for @assessmentQuestion1.
  ///
  /// In en, this message translates to:
  /// **'How much difficulty do you have lifting and carrying 5 kg?'**
  String get assessmentQuestion1;

  /// No description provided for @assessmentQuestion2.
  ///
  /// In en, this message translates to:
  /// **'How much difficulty do you have walking across a room?'**
  String get assessmentQuestion2;

  /// No description provided for @assessmentQuestion3.
  ///
  /// In en, this message translates to:
  /// **'How much difficulty do you have moving from a chair or bed?'**
  String get assessmentQuestion3;

  /// No description provided for @assessmentQuestion4.
  ///
  /// In en, this message translates to:
  /// **'How much difficulty do you have climbing a flight of 10 stairs?'**
  String get assessmentQuestion4;

  /// No description provided for @assessmentQuestion5.
  ///
  /// In en, this message translates to:
  /// **'How much difficulty do you have due to falls in the past year?'**
  String get assessmentQuestion5;

  /// No description provided for @optNoProblem.
  ///
  /// In en, this message translates to:
  /// **'No problem'**
  String get optNoProblem;

  /// No description provided for @optMinorProblem.
  ///
  /// In en, this message translates to:
  /// **'Minor problem'**
  String get optMinorProblem;

  /// No description provided for @optModerateProblem.
  ///
  /// In en, this message translates to:
  /// **'Moderate problem'**
  String get optModerateProblem;

  /// No description provided for @optSevereProblem.
  ///
  /// In en, this message translates to:
  /// **'Severe problem'**
  String get optSevereProblem;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionNumber(int number);

  /// No description provided for @seeResults.
  ///
  /// In en, this message translates to:
  /// **'See Results'**
  String get seeResults;

  /// No description provided for @assessmentResults.
  ///
  /// In en, this message translates to:
  /// **'Assessment Results'**
  String get assessmentResults;

  /// No description provided for @riskLow.
  ///
  /// In en, this message translates to:
  /// **'Low Risk'**
  String get riskLow;

  /// No description provided for @riskModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate Risk'**
  String get riskModerate;

  /// No description provided for @riskHigh.
  ///
  /// In en, this message translates to:
  /// **'High Risk'**
  String get riskHigh;

  /// No description provided for @scoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Score: {score}'**
  String scoreLabel(int score);

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @recLow1.
  ///
  /// In en, this message translates to:
  /// **'Keep up your regular activity and balanced meals.'**
  String get recLow1;

  /// No description provided for @recLow2.
  ///
  /// In en, this message translates to:
  /// **'Maintain protein intake at each meal.'**
  String get recLow2;

  /// No description provided for @recLow3.
  ///
  /// In en, this message translates to:
  /// **'Reassess in a few months to track changes.'**
  String get recLow3;

  /// No description provided for @recModerate1.
  ///
  /// In en, this message translates to:
  /// **'Add strength exercises 2–3 times per week.'**
  String get recModerate1;

  /// No description provided for @recModerate2.
  ///
  /// In en, this message translates to:
  /// **'Increase protein-rich foods across the day.'**
  String get recModerate2;

  /// No description provided for @recModerate3.
  ///
  /// In en, this message translates to:
  /// **'Discuss the result with your caretaker or doctor.'**
  String get recModerate3;

  /// No description provided for @recHigh1.
  ///
  /// In en, this message translates to:
  /// **'Consult a healthcare professional soon.'**
  String get recHigh1;

  /// No description provided for @recHigh2.
  ///
  /// In en, this message translates to:
  /// **'Begin a guided, low-impact strength program.'**
  String get recHigh2;

  /// No description provided for @recHigh3.
  ///
  /// In en, this message translates to:
  /// **'Ensure support is nearby to reduce fall risk.'**
  String get recHigh3;

  /// No description provided for @retakeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Retake Assessment'**
  String get retakeAssessment;

  /// No description provided for @linkedCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Linked caretaker'**
  String get linkedCaretaker;

  /// No description provided for @caretakerFullName.
  ///
  /// In en, this message translates to:
  /// **'Malee Jai-Dee'**
  String get caretakerFullName;

  /// No description provided for @caretakerFirstName.
  ///
  /// In en, this message translates to:
  /// **'Malee'**
  String get caretakerFirstName;

  /// No description provided for @relationshipDaughter.
  ///
  /// In en, this message translates to:
  /// **'Daughter'**
  String get relationshipDaughter;

  /// No description provided for @addCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Add Caretaker'**
  String get addCaretaker;

  /// No description provided for @inviteSent.
  ///
  /// In en, this message translates to:
  /// **'Invite sent to caretaker'**
  String get inviteSent;

  /// No description provided for @caretakerRequest.
  ///
  /// In en, this message translates to:
  /// **'Caretaker Request'**
  String get caretakerRequest;

  /// No description provided for @ifApproveThey.
  ///
  /// In en, this message translates to:
  /// **'If you approve, they will be able to:'**
  String get ifApproveThey;

  /// No description provided for @access1.
  ///
  /// In en, this message translates to:
  /// **'View your health data and measurements'**
  String get access1;

  /// No description provided for @access2.
  ///
  /// In en, this message translates to:
  /// **'Help log meals, exercises and steps'**
  String get access2;

  /// No description provided for @access3.
  ///
  /// In en, this message translates to:
  /// **'Update your personal information'**
  String get access3;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get myPatients;

  /// No description provided for @helloCaretaker.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name} 👋'**
  String helloCaretaker(String name);

  /// No description provided for @caringForPatients.
  ///
  /// In en, this message translates to:
  /// **'You are caring for {count} patients'**
  String caringForPatients(int count);

  /// No description provided for @careForName.
  ///
  /// In en, this message translates to:
  /// **'Care for {name}'**
  String careForName(String name);

  /// No description provided for @careTileHealthData.
  ///
  /// In en, this message translates to:
  /// **'Health Data'**
  String get careTileHealthData;

  /// No description provided for @careTileMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get careTileMeals;

  /// No description provided for @careTileSarcf.
  ///
  /// In en, this message translates to:
  /// **'SARC-F'**
  String get careTileSarcf;

  /// No description provided for @addPatient.
  ///
  /// In en, this message translates to:
  /// **'Add Patient'**
  String get addPatient;

  /// No description provided for @switchPatient.
  ///
  /// In en, this message translates to:
  /// **'Switch patient'**
  String get switchPatient;

  /// No description provided for @switchLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get switchLabel;

  /// No description provided for @ageRiskSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Age {age} · {risk} risk'**
  String ageRiskSubtitle(int age, String risk);

  /// No description provided for @riskShortLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get riskShortLow;

  /// No description provided for @riskShortModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get riskShortModerate;

  /// No description provided for @riskShortHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get riskShortHigh;

  /// No description provided for @patientWanida.
  ///
  /// In en, this message translates to:
  /// **'Wanida Suksawat'**
  String get patientWanida;

  /// No description provided for @patientPrasert.
  ///
  /// In en, this message translates to:
  /// **'Prasert Chaiyo'**
  String get patientPrasert;

  /// No description provided for @findByPhoneDesc.
  ///
  /// In en, this message translates to:
  /// **'Find a patient by their phone number. They will get a request to approve you as their caretaker.'**
  String get findByPhoneDesc;

  /// No description provided for @requestSentWaiting.
  ///
  /// In en, this message translates to:
  /// **'Request sent · waiting for approval'**
  String get requestSentWaiting;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending approval'**
  String get pendingApproval;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send Request'**
  String get sendRequest;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age {age}'**
  String ageLabel(int age);

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{title}\ncoming soon'**
  String comingSoon(String title);
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
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
