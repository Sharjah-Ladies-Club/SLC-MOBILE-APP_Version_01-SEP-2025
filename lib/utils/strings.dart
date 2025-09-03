import 'package:flutter/material.dart';

class Strings {
  //label declaration
  //login
  static const String textFieldMobileLabel = 'Mobile Number';
  static const String textFieldPasswordLabel = 'Password';

  //Register
  static const String textFieldEmailLabel = 'Email';
  static const String textFieldFNameLabel = 'First Name';
  static const String textFieldLNameLabel = 'Last Name';

  static const String textFieldGenderLabel = 'Gender';
  static const String textFieldDOBLabel = 'Date of Birth';
  static const String textFieldDOBLabelArb = 'تاريخ الولادة';
  static const String txtNationality = "Nationality";

  //boolean declaration
  static String countryCodeForMobile;
  static const String countryCodeForNonMobileField = null;

  //display text
  static const String txtWelcomeBck = 'Welcome back!';

  //register page declaration
//  base info one
  static const String txtSigntoConti = 'Sign in to continue';
  static const String txtEntMobileWeSend =
      'Enter your Mobile Number we will send you';
  static const String txtConti = 'Continue';
  static const String txtAlreadyHavAcc = 'Already have account?';
  static const String txtSignIn = 'Sign In';
  static const String txtMTSpace = ' ';
  static const String txtMT = '';
  static const String notification = "notification";
  static const String txtOTPToVerify = 'OTP to verify Later';

//  base info two
  static const String txtSlt = "Select";
  static const String txtSltDate = "Select Date";
  static const String maskEngValidationStr =
      'AAAAAAAAAAAAAAAAAAAAAAAAA'; //25 character allowed for eng with + and space and numbers
  static const String maskEngCommentValidationStr =
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';
  static const String maskArbCommentValidationStr =
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

  static const String maskEngGiftValidationStr =
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

  static const String maskArbValidationStr =
      '#########################'; //25 character allowed for arab with + and space and numbers
  static const String maskEngFLNameValidationStr =
      'NNNNNNNNNNNNNNN'; //15 character allowed english + space
  static const String maskEngCouponValidationStr =
      'MMMMMMMMMM'; //15 character allowed english + space

  static const String maskArabFLNameValidationStr =
      'LLLLLLLLLLLLLLL'; //15 character allowed arab + space
  static const String maskEngEmailValidationStr =
      '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@'; //40 character allowed
  static const String maskPasswordValidationStr =
      '0000'; // allowed only digit number
  static const String maskMobileValidationStr = '0000000000';
  static const String maskEmiratesIdValidationStr = '000-0000-0000000-0';
  static const String maskDOBStr = '00-00-0000';
  static const String maskTipsStr = '000.00';
  static const String maskAmountStr = '00000.00';
  static const String txtDDMale = 'Male';
  static const String txtDDFemale = 'Female';
  static const String txtSltGender = 'Select Gender';
  static const String txtSltNationality = 'Select Nationality';
  static const List<DropdownMenuItem> genderIems = [];
  static const List<DropdownMenuItem> nationalityIems = [];

//dob
  static const String txtDone = 'Done';
  static const String txtCancel = 'Cancel';

  // OTP page declaration
  static String thisText = '';
  static const String maskText = '*';

  static const String snackBarPassword = 'please enter the maximum character 4';
  static const String resendPin = "Resend Pin";
  static const String copyPasteText = "Paste clipboard stuff into the pinbox?";
  static const String txtYes = "Yes";
  static const String txtNo = "No";
  static const String OTPTxtWithNumber = "Enter 6 digit number that send to";

  //  login page declaration
  static const String txtDontHavAcc = "Don't have an account?";
  static const String txtRegHere = 'Register Here';
  static const String txtChangepass = 'Change Password ?';
  static const String txtLoginBtn = 'Login ->';
  static const String txtContiBtn = 'Continue ->';
  static const String txtRegBtn = 'Register ->';

  //font family string
  static const String txtFontFamily = 'Poppins';

  //terms page
  static const String termsDialog = 'Please accept agree terms and conditions';
  static const String agree = 'Agree';
  static const String disAgree = 'DisAgree';
  static const String news = 'NewsPaper';
  static const String media = 'Friends';
  static const String others = 'Others';
  static const String hear = 'How did you hear about us?';
  static const String terms = 'I agree terms and conditions';
  static const String info =
      "Send me information about products, \n services, deals or recommendations by email \n Optional";
  static const String txtWelcome = 'Welcome';

  static const String txtRegtoConti = 'Register to continue';

  //Profile
  static const String txtProfile = ' Profile ';
  static const String txtProfileSave = 'Profile saved';
  static String txtDDInitialValue = 'Male';

  // Events page event description
  static String txtRegister = 'Register';
  static String eventName = "Sharjah Ladies Run 2019";
  static String eventPlace = "Al Qulayaa Building";
  static String aboutEvent = "About the Event";
  static String eventRegistrationFees = "Registration Fees";
  static String startTimeEvent = "8.00 - 10:00 AM";
  static String startDayEvent = "8 March 2019";
  static String textEvent = "Event";

  // Event Review Page
  static String rateText = "Please Rate the Overall event";
  static String askParticipation =
      '''Do you want to participate in this Event for the next time''';
  static String submitText = "Submit";
  static String commentsText = "Do you have any Comments?";
  static String startReviewTimeEvent = "8.00 - 10:00 AM";
  static String startReviewDayEvent = "8 March 2019";
  static String reviewText = "Review";

  //survey page
  // static String txtHwExprienc = 'How was your experience ?';
  static String txtHvComment = 'Do you have any comments ?';

  // static String txtSurveySaved = 'Survey Saved';

  //language change string keys
  static String genderLabel = "genderLabel";

  //more page
  static const String txtLanguage = 'Language';
  static const String txtLogout = 'Logout';

  //Language Keys
  static const String txtArabic = 'Arabic';
  static const String txtEnglish = 'English';

  // notification
  static const String txtClearAll = 'Clear all';
  static const String viewMoreText = 'View More';

  //profile page state initial build
  static const String ProfileInitialState = 'initialBuild';
  static const String ProfileCallState = 'callBackState';

  static const String retryEngStr = "Try again";
  static const String retryArbStr = "حاول مجددا";

  static const String chknetEngStr = "Please check your network connection";
  static const String chknetArbStr = "يرجى التحقق من اتصال الشبكة";
}
