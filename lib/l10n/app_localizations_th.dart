// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'SarcoCare';

  @override
  String get save => 'บันทึก';

  @override
  String get next => 'ถัดไป';

  @override
  String get search => 'ค้นหา';

  @override
  String get splashTagline => 'แอปที่ดูแลสุขภาพกล้ามเนื้อ\nของผู้สูงอายุ';

  @override
  String get getStarted => 'เริ่มต้นใช้งาน';

  @override
  String get loginWelcome => 'ยินดีต้อนรับ';

  @override
  String get loginIntoPrefix => 'เข้าสู่ระบบ ';

  @override
  String get rolePatient => 'ผู้ป่วย';

  @override
  String get roleCaretaker => 'ผู้ดูแล';

  @override
  String get phoneNumber => 'เบอร์โทรศัพท์';

  @override
  String get phoneNumberHint => 'กรอกเบอร์โทรศัพท์';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get passwordHint => 'กรอกรหัสผ่าน';

  @override
  String get logIn => 'เข้าสู่ระบบ';

  @override
  String get noAccountQuestion => 'ยังไม่มีบัญชี? ';

  @override
  String get signUp => 'สมัครสมาชิก';

  @override
  String get signupTitle => 'สร้างบัญชี';

  @override
  String get signupJoinPrefix => 'เข้าร่วมกับ ';

  @override
  String get fullName => 'ชื่อ-นามสกุล';

  @override
  String get fullNameHint => 'กรอกชื่อของคุณ';

  @override
  String get createPasswordHint => 'ตั้งรหัสผ่าน';

  @override
  String get confirmPassword => 'ยืนยันรหัสผ่าน';

  @override
  String get confirmPasswordHint => 'กรอกรหัสผ่านอีกครั้ง';

  @override
  String get createAccount => 'สร้างบัญชี';

  @override
  String get haveAccountQuestion => 'มีบัญชีอยู่แล้ว? ';

  @override
  String get navHome => 'หน้าแรก';

  @override
  String get navExercise => 'ออกกำลังกาย';

  @override
  String get navHealth => 'สุขภาพ';

  @override
  String get navKnowledge => 'ความรู้';

  @override
  String get navProfile => 'โปรไฟล์';

  @override
  String get welcomeBack => 'ยินดีต้อนรับกลับ,';

  @override
  String homeGreetingName(String name) {
    return '$name! 👋';
  }

  @override
  String get userFirstName => 'สมชาย';

  @override
  String caretakerWantsToBe(String name) {
    return '$name ต้องการเป็นผู้ดูแลของคุณ';
  }

  @override
  String get tapToReview => 'แตะเพื่อตรวจสอบ';

  @override
  String caretakerNowYours(String name) {
    return '$name เป็นผู้ดูแลของคุณแล้ว';
  }

  @override
  String get requestDeclined => 'ปฏิเสธคำขอแล้ว';

  @override
  String get dailyGoals => 'เป้าหมายประจำวัน';

  @override
  String get goalProtein => 'กินโปรตีนให้เพียงพอ';

  @override
  String get goalExercise => 'ออกกำลังกาย 15 นาที';

  @override
  String get goalWater => 'ดื่มน้ำ 6–8 แก้ว';

  @override
  String get whatWouldYouLikeToDo => 'คุณอยากทำอะไร?';

  @override
  String get featureMealMenus => 'เมนูอาหาร';

  @override
  String get featureExercisePlan => 'แผนออกกำลังกาย';

  @override
  String get featureSarcfAssessment => 'แบบประเมิน SARC-F';

  @override
  String get featureHealthTracking => 'ติดตามสุขภาพ';

  @override
  String get userFullNameTitled => 'คุณสมชาย ใจดี';

  @override
  String get userFullName => 'สมชาย ใจดี';

  @override
  String profileAge(int age) {
    return 'อายุ: $age';
  }

  @override
  String get entryPersonalInfo => 'ข้อมูลส่วนตัว';

  @override
  String get entryUsageSummary => 'สรุปการใช้งาน';

  @override
  String get entryCaretaker => 'ผู้ดูแล';

  @override
  String get entrySetupApp => 'ตั้งค่าแอป';

  @override
  String get logOut => 'ออกจากระบบ';

  @override
  String get setupLanguage => 'ภาษา';

  @override
  String get setupDeviceSetup => 'ตั้งค่าอุปกรณ์';

  @override
  String get setupLargeText => 'ตัวอักษรใหญ่';

  @override
  String get setupSound => 'เสียง';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageThai => 'ไทย';

  @override
  String get selectLanguage => 'เลือกภาษา';

  @override
  String get fieldAge => 'อายุ';

  @override
  String get fieldGender => 'เพศ';

  @override
  String get fieldEmail => 'อีเมล';

  @override
  String get genderMale => 'ชาย';

  @override
  String get profileUpdated => 'อัปเดตโปรไฟล์แล้ว';

  @override
  String get tabDaily => 'รายวัน';

  @override
  String get tabWeekly => 'รายสัปดาห์';

  @override
  String get tabMonthly => 'รายเดือน';

  @override
  String get seriesDailyAverage => 'ค่าเฉลี่ยรายวัน';

  @override
  String get seriesWeeklyAverage => 'ค่าเฉลี่ยรายสัปดาห์';

  @override
  String get seriesMonthlyAverage => 'ค่าเฉลี่ยรายเดือน';

  @override
  String get activityScore => 'คะแนนกิจกรรม';

  @override
  String get dayInitialMon => 'จ';

  @override
  String get dayInitialTue => 'อ';

  @override
  String get dayInitialWed => 'พ';

  @override
  String get dayInitialThu => 'พฤ';

  @override
  String get dayInitialFri => 'ศ';

  @override
  String get dayInitialSat => 'ส';

  @override
  String get dayInitialSun => 'อา';

  @override
  String get monthJan => 'ม.ค.';

  @override
  String get monthFeb => 'ก.พ.';

  @override
  String get monthMar => 'มี.ค.';

  @override
  String get monthApr => 'เม.ย.';

  @override
  String get monthMay => 'พ.ค.';

  @override
  String get monthJun => 'มิ.ย.';

  @override
  String weekLabel(int number) {
    return 'สัปดาห์ $number';
  }

  @override
  String get metricWeight => 'น้ำหนัก';

  @override
  String get metricHeight => 'ส่วนสูง';

  @override
  String get metricBmi => 'ดัชนีมวลกาย';

  @override
  String get metricCalf => 'เส้นรอบวงน่อง';

  @override
  String get metricHandgrip => 'แรงบีบมือ';

  @override
  String get badgeNormal => 'ปกติ';

  @override
  String get addData => 'เพิ่มข้อมูล';

  @override
  String get dateToday => 'วันนี้';

  @override
  String enterValueHint(String label) {
    return 'กรอก$label';
  }

  @override
  String get healthDataSaved => 'บันทึกข้อมูลสุขภาพแล้ว';

  @override
  String get setReminders => 'ตั้งการแจ้งเตือน';

  @override
  String get turnRemindersOnOff => 'เปิดหรือปิดการแจ้งเตือน';

  @override
  String get mealBreakfast => 'มื้อเช้า';

  @override
  String get mealLunch => 'มื้อกลางวัน';

  @override
  String get mealDinner => 'มื้อเย็น';

  @override
  String get mealSnack => 'ของว่าง';

  @override
  String get reminderWater => 'ดื่มน้ำ';

  @override
  String get reminderMedication => 'ยา';

  @override
  String get reminderSleep => 'นอนหลับ';

  @override
  String get reminderEvery2Hours => 'ทุก 2 ชั่วโมง';

  @override
  String get catAll => 'ทั้งหมด';

  @override
  String get catFood => 'อาหาร';

  @override
  String get catPrevention => 'การป้องกัน';

  @override
  String get artOverviewTitle => 'ภาพรวม';

  @override
  String get artOverviewSummary => 'แนะนำสุขภาพกล้ามเนื้อโดยสังเขป';

  @override
  String get artWhatIsTitle => 'ภาวะมวลกล้ามเนื้อน้อยคืออะไร?';

  @override
  String get artWhatIsSummary => 'ทำความเข้าใจการสูญเสียกล้ามเนื้อตามวัย';

  @override
  String get artCausesTitle => 'สาเหตุและปัจจัยเสี่ยง';

  @override
  String get artCausesSummary => 'อะไรเพิ่มความเสี่ยงของคุณ';

  @override
  String get artExerciseGuideTitle => 'คู่มือออกกำลังกาย';

  @override
  String get artExerciseGuideSummary => 'ท่าที่ปลอดภัยเพื่อความแข็งแรง';

  @override
  String get artNutritionTitle => 'โภชนาการ';

  @override
  String get artNutritionSummary => 'กินอย่างดีเพื่อกล้ามเนื้อ';

  @override
  String get artPreventionTitle => 'การป้องกัน';

  @override
  String get artPreventionSummary => 'นิสัยประจำวันที่ปกป้องคุณ';

  @override
  String get articleAppbar => 'บทความ';

  @override
  String get chipReadTime => 'อ่าน 3 นาที';

  @override
  String get articleParagraph1 =>
      'ภาวะมวลกล้ามเนื้อน้อย (Sarcopenia) คือการสูญเสียมวล ความแข็งแรง และการทำงานของกล้ามเนื้ออย่างค่อยเป็นค่อยไป ซึ่งมักมากับวัยที่เพิ่มขึ้น อาจทำให้กิจวัตรประจำวัน เช่น การลุกยืน การขึ้นบันได การถือของ ยากขึ้นเมื่อเวลาผ่านไป';

  @override
  String get articleParagraph2 =>
      'ข่าวดีคือ ภาวะนี้สามารถชะลอและแม้แต่ทำให้ดีขึ้นได้ การออกกำลังกายเสริมความแข็งแรงอย่างสม่ำเสมอและการกินโปรตีนให้เพียงพอ เป็นสองสิ่งที่ได้ผลที่สุดที่คุณทำได้ในทุกวัย';

  @override
  String get articleParagraph3 =>
      'นิสัยเล็ก ๆ ที่ทำสม่ำเสมอสำคัญที่สุด การเดินสั้น ๆ ทุกวัน การออกกำลังกายท่านั่งไม่กี่ท่า และแหล่งโปรตีนในทุกมื้อ ล้วนรวมกันเป็นกล้ามเนื้อที่แข็งแรงและสุขภาพดีขึ้น';

  @override
  String get mealsTitle => 'มื้ออาหาร';

  @override
  String get sectionSuggestedToday => 'มื้ออาหารแนะนำสำหรับวันนี้';

  @override
  String get sectionThisWeekPlan => 'แผนสัปดาห์นี้';

  @override
  String get viewRecipes => 'ดูสูตรอาหาร';

  @override
  String get mealEggsToast => 'ไข่ลวกกับขนมปังปิ้ง';

  @override
  String get mealChickenSalad => 'สลัดไก่ย่าง';

  @override
  String get mealSalmonVeg => 'แซลมอนกับผัก';

  @override
  String get mealYogurtNuts => 'กรีกโยเกิร์ตกับถั่ว';

  @override
  String get mealOatmeal => 'ข้าวโอ๊ตกับเบอร์รี';

  @override
  String get mealTuna => 'แซนด์วิชทูน่า';

  @override
  String get mealTofu => 'เต้าหู้ผัด';

  @override
  String get mealBeefBroccoli => 'เนื้อผัดบรอกโคลี';

  @override
  String get mealLentil => 'ซุปถั่วเลนทิล';

  @override
  String get mealChickenRice => 'ข้าวหน้าไก่';

  @override
  String get mealEggRice => 'ข้าวผัดไข่';

  @override
  String proteinGrams(int grams) {
    return 'โปรตีน $grams ก.';
  }

  @override
  String get dayAbbrevMon => 'จ.';

  @override
  String get dayAbbrevTue => 'อ.';

  @override
  String get dayAbbrevWed => 'พ.';

  @override
  String get dayAbbrevThu => 'พฤ.';

  @override
  String get dayAbbrevFri => 'ศ.';

  @override
  String get dayAbbrevSat => 'ส.';

  @override
  String get dayAbbrevSun => 'อา.';

  @override
  String get searchRecipesTitle => 'ค้นหาสูตรอาหาร';

  @override
  String get searchRecipesHint => 'ค้นหาสูตรอาหาร';

  @override
  String noRecipesMatch(String query) {
    return 'ไม่พบสูตรที่ตรงกับ \"$query\"';
  }

  @override
  String get nutrLabelProtein => 'โปรตีน';

  @override
  String get nutrLabelEnergy => 'พลังงาน';

  @override
  String get nutrLabelFat => 'ไขมัน';

  @override
  String get sectionIngredients => 'ส่วนผสม';

  @override
  String get sectionMethod => 'วิธีทำ';

  @override
  String get ingredient1 => 'ไข่สด 2 ฟอง';

  @override
  String get ingredient2 => 'ขนมปังโฮลเกรน 2 แผ่น';

  @override
  String get ingredient3 => 'น้ำมันมะกอก 1 ช้อนชา';

  @override
  String get ingredient4 => 'เกลือและพริกไทยเล็กน้อย';

  @override
  String get method1 => 'ต้มน้ำในหม้อเล็กให้เดือดอ่อน ๆ';

  @override
  String get method2 => 'ใส่ไข่ลงไปแล้วต้ม 6–7 นาที';

  @override
  String get method3 => 'แช่น้ำเย็นแล้วปอกเปลือก';

  @override
  String get method4 => 'เสิร์ฟกับขนมปังปิ้ง ราดน้ำมันเล็กน้อยและปรุงรส';

  @override
  String get completeMealAndLog => 'ทำเสร็จและบันทึกมื้อ';

  @override
  String get mealLoggedToday => 'บันทึกมื้ออาหารของวันนี้แล้ว';

  @override
  String get planTypeBasicStrength => 'ฝึกความแข็งแรงพื้นฐาน';

  @override
  String exerciseTypeLabel(String type) {
    return 'ประเภท: $type';
  }

  @override
  String get tabExercises => 'ท่าออกกำลังกาย';

  @override
  String get exSeatedLegLift => 'ยกขาท่านั่ง';

  @override
  String get exArmCurls => 'งอแขนยกน้ำหนัก';

  @override
  String get exChairSquats => 'สควอทกับเก้าอี้';

  @override
  String get exStandingBalance => 'ทรงตัวท่ายืน';

  @override
  String durationMinutes(int count) {
    return '$count นาที';
  }

  @override
  String durationHoursMinutes(int hours, int minutes) {
    return '$hours ชม. $minutes น.';
  }

  @override
  String get sectionInstructions => 'คำแนะนำ';

  @override
  String get instruction1 => 'ทำ 10–15 ครั้งต่อเซ็ต';

  @override
  String get instruction2 => '2–3 เซ็ต พักสั้น ๆ ระหว่างเซ็ต';

  @override
  String get instruction3 => 'นั่งหลังตรง เคลื่อนไหวช้า ๆ อย่างมั่นคง';

  @override
  String get instruction4 => 'ทำตามวิดีโอทีละขั้นตอน';

  @override
  String get startExercise => 'เริ่มออกกำลังกาย';

  @override
  String get complete => 'เสร็จสิ้น';

  @override
  String get exerciseCompletedLogged => 'ออกกำลังกายเสร็จและบันทึกแล้ว';

  @override
  String get myPlanTitle => 'แผนของฉัน';

  @override
  String get tabToday => 'วันนี้';

  @override
  String get tabThisWeek => 'สัปดาห์นี้';

  @override
  String get tabThisMonth => 'เดือนนี้';

  @override
  String get todaysProgress => 'ความคืบหน้าวันนี้';

  @override
  String exercisesDone(int done, int total) {
    return 'ทำแล้ว $done จาก $total ท่า';
  }

  @override
  String get beginExercise => 'เริ่มออกกำลังกาย';

  @override
  String sarcfProgress(int current, int total) {
    return 'SARC-F ($current/$total)';
  }

  @override
  String get assessmentQuestion1 =>
      'คุณมีความลำบากเพียงใดในการยกและถือของหนัก 5 กิโลกรัม?';

  @override
  String get assessmentQuestion2 => 'คุณมีความลำบากเพียงใดในการเดินข้ามห้อง?';

  @override
  String get assessmentQuestion3 =>
      'คุณมีความลำบากเพียงใดในการลุกจากเก้าอี้หรือเตียง?';

  @override
  String get assessmentQuestion4 =>
      'คุณมีความลำบากเพียงใดในการขึ้นบันได 10 ขั้น?';

  @override
  String get assessmentQuestion5 =>
      'คุณมีความลำบากเพียงใดจากการหกล้มในปีที่ผ่านมา?';

  @override
  String get optNoProblem => 'ไม่มีปัญหา';

  @override
  String get optMinorProblem => 'มีปัญหาเล็กน้อย';

  @override
  String get optModerateProblem => 'มีปัญหาปานกลาง';

  @override
  String get optSevereProblem => 'มีปัญหามาก';

  @override
  String questionNumber(int number) {
    return 'คำถามที่ $number';
  }

  @override
  String get seeResults => 'ดูผลลัพธ์';

  @override
  String get assessmentResults => 'ผลการประเมิน';

  @override
  String get riskLow => 'ความเสี่ยงต่ำ';

  @override
  String get riskModerate => 'ความเสี่ยงปานกลาง';

  @override
  String get riskHigh => 'ความเสี่ยงสูง';

  @override
  String scoreLabel(int score) {
    return 'คะแนน: $score';
  }

  @override
  String get recommendations => 'คำแนะนำ';

  @override
  String get recLow1 => 'ทำกิจกรรมสม่ำเสมอและรับประทานอาหารให้สมดุลต่อไป';

  @override
  String get recLow2 => 'รักษาปริมาณโปรตีนในทุกมื้อ';

  @override
  String get recLow3 => 'ประเมินซ้ำในอีกไม่กี่เดือนเพื่อติดตามการเปลี่ยนแปลง';

  @override
  String get recModerate1 =>
      'เพิ่มการออกกำลังกายเสริมความแข็งแรง 2–3 ครั้งต่อสัปดาห์';

  @override
  String get recModerate2 => 'เพิ่มอาหารที่มีโปรตีนสูงตลอดวัน';

  @override
  String get recModerate3 => 'ปรึกษาผลกับผู้ดูแลหรือแพทย์ของคุณ';

  @override
  String get recHigh1 => 'ปรึกษาบุคลากรทางการแพทย์โดยเร็ว';

  @override
  String get recHigh2 =>
      'เริ่มโปรแกรมเสริมความแข็งแรงแรงกระแทกต่ำโดยมีผู้แนะนำ';

  @override
  String get recHigh3 =>
      'จัดให้มีผู้ช่วยเหลืออยู่ใกล้เพื่อลดความเสี่ยงการหกล้ม';

  @override
  String get retakeAssessment => 'ทำแบบประเมินอีกครั้ง';

  @override
  String get linkedCaretaker => 'ผู้ดูแลที่เชื่อมโยง';

  @override
  String get caretakerFullName => 'มาลี ใจดี';

  @override
  String get caretakerFirstName => 'มาลี';

  @override
  String get relationshipDaughter => 'ลูกสาว';

  @override
  String get addCaretaker => 'เพิ่มผู้ดูแล';

  @override
  String get inviteSent => 'ส่งคำเชิญถึงผู้ดูแลแล้ว';

  @override
  String get caretakerRequest => 'คำขอเป็นผู้ดูแล';

  @override
  String get ifApproveThey => 'หากคุณอนุมัติ พวกเขาจะสามารถ:';

  @override
  String get access1 => 'ดูข้อมูลสุขภาพและค่าการวัดของคุณ';

  @override
  String get access2 => 'ช่วยบันทึกมื้ออาหาร การออกกำลังกาย และจำนวนก้าว';

  @override
  String get access3 => 'อัปเดตข้อมูลส่วนตัวของคุณ';

  @override
  String get approve => 'อนุมัติ';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get myPatients => 'ผู้ป่วยของฉัน';

  @override
  String helloCaretaker(String name) {
    return 'สวัสดี $name 👋';
  }

  @override
  String caringForPatients(int count) {
    return 'คุณกำลังดูแลผู้ป่วย $count คน';
  }

  @override
  String careForName(String name) {
    return 'การดูแล$name';
  }

  @override
  String get careTileHealthData => 'ข้อมูลสุขภาพ';

  @override
  String get careTileMeals => 'มื้ออาหาร';

  @override
  String get careTileSarcf => 'SARC-F';

  @override
  String get addPatient => 'เพิ่มผู้ป่วย';

  @override
  String get switchPatient => 'เปลี่ยนผู้ป่วย';

  @override
  String get switchLabel => 'เปลี่ยน';

  @override
  String ageRiskSubtitle(int age, String risk) {
    return 'อายุ $age · ความเสี่ยง$risk';
  }

  @override
  String get riskShortLow => 'ต่ำ';

  @override
  String get riskShortModerate => 'ปานกลาง';

  @override
  String get riskShortHigh => 'สูง';

  @override
  String get patientWanida => 'วนิดา สุขสวัสดิ์';

  @override
  String get patientPrasert => 'ประเสริฐ ชัยโย';

  @override
  String get findByPhoneDesc =>
      'ค้นหาผู้ป่วยด้วยเบอร์โทรศัพท์ พวกเขาจะได้รับคำขอให้อนุมัติคุณเป็นผู้ดูแล';

  @override
  String get requestSentWaiting => 'ส่งคำขอแล้ว · รอการอนุมัติ';

  @override
  String get pendingApproval => 'รอการอนุมัติ';

  @override
  String get sendRequest => 'ส่งคำขอ';

  @override
  String ageLabel(int age) {
    return 'อายุ $age';
  }

  @override
  String comingSoon(String title) {
    return '$title\nเร็ว ๆ นี้';
  }
}
