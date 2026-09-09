// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'SarcoCare';

  @override
  String get save => 'Save';

  @override
  String get next => 'Next';

  @override
  String get search => 'Search';

  @override
  String get splashTagline =>
      'App that cares for muscle\nhealth in the elderly';

  @override
  String get getStarted => 'Get Started';

  @override
  String get loginWelcome => 'Welcome';

  @override
  String get loginIntoPrefix => 'Log into ';

  @override
  String get rolePatient => 'Patient';

  @override
  String get roleCaretaker => 'Caretaker';

  @override
  String get phoneNumber => 'Phone number';

  @override
  String get phoneNumberHint => 'Enter phone number';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter password';

  @override
  String get logIn => 'Log In';

  @override
  String get noAccountQuestion => 'Don\'t have an account? ';

  @override
  String get signUp => 'Sign Up';

  @override
  String get signupTitle => 'Create account';

  @override
  String get signupJoinPrefix => 'Join ';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'Enter your name';

  @override
  String get createPasswordHint => 'Create a password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Re-enter password';

  @override
  String get createAccount => 'Create Account';

  @override
  String get haveAccountQuestion => 'Already have an account? ';

  @override
  String get navHome => 'Home';

  @override
  String get navExercise => 'Exercise';

  @override
  String get navHealth => 'Health';

  @override
  String get navKnowledge => 'Knowledge';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcomeBack => 'Welcome back,';

  @override
  String homeGreetingName(String name) {
    return '$name! 👋';
  }

  @override
  String get userFirstName => 'Somchai';

  @override
  String caretakerWantsToBe(String name) {
    return '$name wants to be your caretaker';
  }

  @override
  String get tapToReview => 'Tap to review';

  @override
  String caretakerNowYours(String name) {
    return '$name is now your caretaker';
  }

  @override
  String get requestDeclined => 'Request declined';

  @override
  String get dailyGoals => 'Daily Goals';

  @override
  String get goalProtein => 'Eat enough protein';

  @override
  String get goalExercise => 'Exercise 15 minutes';

  @override
  String get goalWater => 'Drink 6–8 glasses of water';

  @override
  String get whatWouldYouLikeToDo => 'What would you like to do?';

  @override
  String get featureMealMenus => 'Meal Menus';

  @override
  String get featureExercisePlan => 'Exercise Plan';

  @override
  String get featureSarcfAssessment => 'SARC-F Assessment';

  @override
  String get featureHealthTracking => 'Health Tracking';

  @override
  String get userFullNameTitled => 'Mr. Somchai Jai-Dee';

  @override
  String get userFullName => 'Somchai Jai-Dee';

  @override
  String profileAge(int age) {
    return 'Age: $age';
  }

  @override
  String get entryPersonalInfo => 'Personal Info';

  @override
  String get entryUsageSummary => 'Usage Summary';

  @override
  String get entryCaretaker => 'Caretaker';

  @override
  String get entrySetupApp => 'Setup App';

  @override
  String get logOut => 'Log Out';

  @override
  String get setupLanguage => 'Language';

  @override
  String get setupDeviceSetup => 'Device Setup';

  @override
  String get setupLargeText => 'Large Text';

  @override
  String get setupSound => 'Sound';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageThai => 'ไทย';

  @override
  String get selectLanguage => 'Select language';

  @override
  String get fieldAge => 'Age';

  @override
  String get fieldGender => 'Gender';

  @override
  String get fieldEmail => 'Email';

  @override
  String get genderMale => 'Male';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get tabDaily => 'Daily';

  @override
  String get tabWeekly => 'Weekly';

  @override
  String get tabMonthly => 'Monthly';

  @override
  String get seriesDailyAverage => 'Daily average';

  @override
  String get seriesWeeklyAverage => 'Weekly average';

  @override
  String get seriesMonthlyAverage => 'Monthly average';

  @override
  String get activityScore => 'Activity score';

  @override
  String get dayInitialMon => 'M';

  @override
  String get dayInitialTue => 'T';

  @override
  String get dayInitialWed => 'W';

  @override
  String get dayInitialThu => 'T';

  @override
  String get dayInitialFri => 'F';

  @override
  String get dayInitialSat => 'S';

  @override
  String get dayInitialSun => 'S';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String weekLabel(int number) {
    return 'W$number';
  }

  @override
  String get metricWeight => 'Weight';

  @override
  String get metricHeight => 'Height';

  @override
  String get metricBmi => 'BMI';

  @override
  String get metricCalf => 'Calf Circumference';

  @override
  String get metricHandgrip => 'Handgrip';

  @override
  String get badgeNormal => 'Normal';

  @override
  String get addData => 'Add Data';

  @override
  String get dateToday => 'Today';

  @override
  String enterValueHint(String label) {
    return 'Enter $label';
  }

  @override
  String get healthDataSaved => 'Health data saved';

  @override
  String get setReminders => 'Set Reminders';

  @override
  String get turnRemindersOnOff => 'Turn reminders on or off';

  @override
  String get mealBreakfast => 'Breakfast';

  @override
  String get mealLunch => 'Lunch';

  @override
  String get mealDinner => 'Dinner';

  @override
  String get mealSnack => 'Snack';

  @override
  String get reminderWater => 'Water';

  @override
  String get reminderMedication => 'Medication';

  @override
  String get reminderSleep => 'Sleep';

  @override
  String get reminderEvery2Hours => 'Every 2 hours';

  @override
  String get catAll => 'All';

  @override
  String get catFood => 'Food';

  @override
  String get catPrevention => 'Prevention';

  @override
  String get artOverviewTitle => 'Overview';

  @override
  String get artOverviewSummary => 'A quick introduction to muscle health';

  @override
  String get artWhatIsTitle => 'What is Sarcopenia?';

  @override
  String get artWhatIsSummary => 'Understanding age-related muscle loss';

  @override
  String get artCausesTitle => 'Causes and Risk Factors';

  @override
  String get artCausesSummary => 'What raises your risk';

  @override
  String get artExerciseGuideTitle => 'Exercise Guide';

  @override
  String get artExerciseGuideSummary => 'Safe movements to stay strong';

  @override
  String get artNutritionTitle => 'Nutrition';

  @override
  String get artNutritionSummary => 'Eating well for your muscles';

  @override
  String get artPreventionTitle => 'Prevention';

  @override
  String get artPreventionSummary => 'Daily habits that protect you';

  @override
  String get articleAppbar => 'Article';

  @override
  String get chipReadTime => '3 min read';

  @override
  String get articleParagraph1 =>
      'Sarcopenia is the gradual loss of muscle mass, strength and function that often comes with ageing. It can make everyday tasks — standing up, climbing stairs, carrying shopping — feel harder over time.';

  @override
  String get articleParagraph2 =>
      'The good news is that it can be slowed and even improved. Regular strength activity and eating enough protein are two of the most effective steps you can take at any age.';

  @override
  String get articleParagraph3 =>
      'Small, consistent habits matter most. A short daily walk, a few seated exercises, and a protein source at each meal all add up to stronger, healthier muscles.';

  @override
  String get mealsTitle => 'Meals';

  @override
  String get sectionSuggestedToday => 'Suggested Meals for Today';

  @override
  String get sectionThisWeekPlan => 'This Week\'s Plan';

  @override
  String get viewRecipes => 'View Recipes';

  @override
  String get mealEggsToast => 'Soft-boiled Eggs & Toast';

  @override
  String get mealChickenSalad => 'Grilled Chicken Salad';

  @override
  String get mealSalmonVeg => 'Salmon with Vegetables';

  @override
  String get mealYogurtNuts => 'Greek Yogurt & Nuts';

  @override
  String get mealOatmeal => 'Oatmeal & Berries';

  @override
  String get mealTuna => 'Tuna Sandwich';

  @override
  String get mealTofu => 'Tofu Stir-fry';

  @override
  String get mealBeefBroccoli => 'Beef & Broccoli';

  @override
  String get mealLentil => 'Lentil Soup';

  @override
  String get mealChickenRice => 'Chicken & Rice';

  @override
  String get mealEggRice => 'Egg Fried Rice';

  @override
  String proteinGrams(int grams) {
    return 'Protein ${grams}g';
  }

  @override
  String get dayAbbrevMon => 'Mon';

  @override
  String get dayAbbrevTue => 'Tue';

  @override
  String get dayAbbrevWed => 'Wed';

  @override
  String get dayAbbrevThu => 'Thu';

  @override
  String get dayAbbrevFri => 'Fri';

  @override
  String get dayAbbrevSat => 'Sat';

  @override
  String get dayAbbrevSun => 'Sun';

  @override
  String get searchRecipesTitle => 'Search Recipes';

  @override
  String get searchRecipesHint => 'Search recipes';

  @override
  String noRecipesMatch(String query) {
    return 'No recipes match \"$query\"';
  }

  @override
  String get nutrLabelProtein => 'Protein';

  @override
  String get nutrLabelEnergy => 'Energy';

  @override
  String get nutrLabelFat => 'Fat';

  @override
  String get sectionIngredients => 'Ingredients';

  @override
  String get sectionMethod => 'Method';

  @override
  String get ingredient1 => '2 fresh eggs';

  @override
  String get ingredient2 => '2 slices wholegrain toast';

  @override
  String get ingredient3 => '1 tsp olive oil';

  @override
  String get ingredient4 => 'A pinch of salt and pepper';

  @override
  String get method1 => 'Bring a small pot of water to a gentle boil.';

  @override
  String get method2 => 'Lower the eggs in and cook for 6–7 minutes.';

  @override
  String get method3 => 'Cool under running water, then peel.';

  @override
  String get method4 => 'Serve with toast, a drizzle of oil and seasoning.';

  @override
  String get completeMealAndLog => 'Complete Meal and Log';

  @override
  String get mealLoggedToday => 'Meal logged for today';

  @override
  String get planTypeBasicStrength => 'Basic Strength Training';

  @override
  String exerciseTypeLabel(String type) {
    return 'Type: $type';
  }

  @override
  String get tabExercises => 'Exercises';

  @override
  String get exSeatedLegLift => 'Seated Leg Lift';

  @override
  String get exArmCurls => 'Arm Curls';

  @override
  String get exChairSquats => 'Chair Squats';

  @override
  String get exStandingBalance => 'Standing Balance';

  @override
  String durationMinutes(int count) {
    return '$count min';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get sectionInstructions => 'Instructions';

  @override
  String get instruction1 => 'Perform 10–15 reps per set';

  @override
  String get instruction2 => '2–3 sets with short rests';

  @override
  String get instruction3 => 'Sit tall and move slowly and steadily';

  @override
  String get instruction4 => 'Follow the clear step-by-step video';

  @override
  String get startExercise => 'Start Exercise';

  @override
  String get complete => 'Complete';

  @override
  String get exerciseCompletedLogged => 'Exercise completed and logged';

  @override
  String get myPlanTitle => 'My Plan';

  @override
  String get tabToday => 'Today';

  @override
  String get tabThisWeek => 'This Week';

  @override
  String get tabThisMonth => 'This Month';

  @override
  String get todaysProgress => 'Today\'s progress';

  @override
  String exercisesDone(int done, int total) {
    return '$done of $total exercises done';
  }

  @override
  String get beginExercise => 'Begin Exercise';

  @override
  String sarcfProgress(int current, int total) {
    return 'SARC-F ($current/$total)';
  }

  @override
  String get assessmentQuestion1 =>
      'How much difficulty do you have lifting and carrying 5 kg?';

  @override
  String get assessmentQuestion2 =>
      'How much difficulty do you have walking across a room?';

  @override
  String get assessmentQuestion3 =>
      'How much difficulty do you have moving from a chair or bed?';

  @override
  String get assessmentQuestion4 =>
      'How much difficulty do you have climbing a flight of 10 stairs?';

  @override
  String get assessmentQuestion5 =>
      'How much difficulty do you have due to falls in the past year?';

  @override
  String get optNoProblem => 'No problem';

  @override
  String get optMinorProblem => 'Minor problem';

  @override
  String get optModerateProblem => 'Moderate problem';

  @override
  String get optSevereProblem => 'Severe problem';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String get seeResults => 'See Results';

  @override
  String get assessmentResults => 'Assessment Results';

  @override
  String get riskLow => 'Low Risk';

  @override
  String get riskModerate => 'Moderate Risk';

  @override
  String get riskHigh => 'High Risk';

  @override
  String scoreLabel(int score) {
    return 'Score: $score';
  }

  @override
  String get recommendations => 'Recommendations';

  @override
  String get recLow1 => 'Keep up your regular activity and balanced meals.';

  @override
  String get recLow2 => 'Maintain protein intake at each meal.';

  @override
  String get recLow3 => 'Reassess in a few months to track changes.';

  @override
  String get recModerate1 => 'Add strength exercises 2–3 times per week.';

  @override
  String get recModerate2 => 'Increase protein-rich foods across the day.';

  @override
  String get recModerate3 =>
      'Discuss the result with your caretaker or doctor.';

  @override
  String get recHigh1 => 'Consult a healthcare professional soon.';

  @override
  String get recHigh2 => 'Begin a guided, low-impact strength program.';

  @override
  String get recHigh3 => 'Ensure support is nearby to reduce fall risk.';

  @override
  String get retakeAssessment => 'Retake Assessment';

  @override
  String get linkedCaretaker => 'Linked caretaker';

  @override
  String get caretakerFullName => 'Malee Jai-Dee';

  @override
  String get caretakerFirstName => 'Malee';

  @override
  String get relationshipDaughter => 'Daughter';

  @override
  String get addCaretaker => 'Add Caretaker';

  @override
  String get inviteSent => 'Invite sent to caretaker';

  @override
  String get caretakerRequest => 'Caretaker Request';

  @override
  String get ifApproveThey => 'If you approve, they will be able to:';

  @override
  String get access1 => 'View your health data and measurements';

  @override
  String get access2 => 'Help log meals, exercises and steps';

  @override
  String get access3 => 'Update your personal information';

  @override
  String get approve => 'Approve';

  @override
  String get decline => 'Decline';

  @override
  String get myPatients => 'My Patients';

  @override
  String helloCaretaker(String name) {
    return 'Hello, $name 👋';
  }

  @override
  String caringForPatients(int count) {
    return 'You are caring for $count patients';
  }

  @override
  String careForName(String name) {
    return 'Care for $name';
  }

  @override
  String get careTileHealthData => 'Health Data';

  @override
  String get careTileMeals => 'Meals';

  @override
  String get careTileSarcf => 'SARC-F';

  @override
  String get addPatient => 'Add Patient';

  @override
  String get switchPatient => 'Switch patient';

  @override
  String get switchLabel => 'Switch';

  @override
  String ageRiskSubtitle(int age, String risk) {
    return 'Age $age · $risk risk';
  }

  @override
  String get riskShortLow => 'Low';

  @override
  String get riskShortModerate => 'Moderate';

  @override
  String get riskShortHigh => 'High';

  @override
  String get patientWanida => 'Wanida Suksawat';

  @override
  String get patientPrasert => 'Prasert Chaiyo';

  @override
  String get findByPhoneDesc =>
      'Find a patient by their phone number. They will get a request to approve you as their caretaker.';

  @override
  String get requestSentWaiting => 'Request sent · waiting for approval';

  @override
  String get pendingApproval => 'Pending approval';

  @override
  String get sendRequest => 'Send Request';

  @override
  String ageLabel(int age) {
    return 'Age $age';
  }

  @override
  String comingSoon(String title) {
    return '$title\ncoming soon';
  }

  @override
  String get chatTitle => 'Assistant';

  @override
  String get chatBubbleTooltip => 'Chat with the assistant';

  @override
  String get chatDisclaimer =>
      'AI assistant · general guidance, not medical advice';

  @override
  String get chatGreeting =>
      'Hi! I\'m your SarcoCare assistant. Ask me about exercises, meals or your health plan.';

  @override
  String get chatInputHint => 'Type a message…';

  @override
  String get chatSend => 'Send';

  @override
  String get chatComingSoonReply =>
      'Thanks for your message! I\'m not connected yet — once I am, I\'ll give you personalized guidance on muscle health, exercise and nutrition.';
}
