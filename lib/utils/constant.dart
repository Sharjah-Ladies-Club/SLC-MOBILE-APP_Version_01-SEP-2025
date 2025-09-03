import 'dart:io';

import 'package:slc/customcomponentfields/customdatepicker/flutter_cupertino_date_picker.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';

class Constants {
  // static const String BaseUrlDev = "http://192.168.1.5/SLCApi/";
  static const String BaseUrlDev = "https://webapp.slc.ae:8001/";
  static const String BaseUrlTest = "https://webapp.slc.ae:8001/";
  static const String BaseUrlRelease = "https://webapp.slc.ae/";
  static const String ChatBotBaseUrlDev =
      "https://slcbf.impigertech.com/webchat?app_id=632bec15c3779cfc03a8a9ce";
  static const String ChatBotBaseUrlQA =
      "https://slcbf.impigertech.com/webchat?app_id=63c179855ca8430ff6bd65f1";
  static const String ChatBotBaseUrlUAT =
      "https://slcbf.impigertech.com/webchat?app_id=63c0e05a7ccd9e380cdc9a93";
  static const String VRSourceUrl = "https://webapp.slc.ae/tour/index.html";
  static const String MORE_LOCATION = "https://goo.gl/maps/iQzy4gnx8AQaXkxj8";
  static const String MORE_FACEBOOK = "https://www.facebook.com/shjladiesclub";
  static const String MORE_TWITTER = "https://twitter.com/ShjLadiesClub";
  static const String MORE_INSTAGRAM =
      "https://www.instagram.com/shjladiesclub/";
  static const String GOOGLE_MAP_LOCATION_URL =
      "https://www.google.com/maps/dir/?api=1";
  static const String MORE_SITE = "http://www.slc.ae/";

  static const String KEY_TOKEN_1 = "KEY_TOKEN_1";

  static const String SecretKey = "secret_key";
  static const String VectorKey = "vector_key";
  static const String AppKey = "app_key";
  static const String AuthToken = "auth_token";
  static const String VersionCode = "app_version";
  static const String AndroidVersionCode = "slc_android_app_version";
  static const String IOSVersionCode = "slc_ios_app_version";
  static const String ForceUpdate = "force_update";
  static const String SaveDate = "save_date";
  static const String EventRegistrationCount = "event_registration_count";

  static const String IsProfileOfflineSupport = "profile_offline_support";

  /*Home*/
  static const String HOME = "Home";
  static const String EVENTS = "Event";
  static const String SURVEY = "Survey";
  static const String MORE = "More";

  static const String REGISTER = "register";
  static const String CHANGE_PASSWORD = "change_password";

  //Language
  static const String DEFAULT_LANGUAGE = "default_language";
  static const int LANGUAGE_NOTSEL = 0;
  static const int LANGUAGE_ENGLISH = 1;
  static const int LANGUAGE_ARABIC = 2;
  static const String CURRENT_LANGUAGE = 'current_language';
  static const String COUNTRY_CODE_JSON = 'country_code_json';

  static const String MENU_TYPE_OVERVIEW = 'overview';
  static const String MENU_TYPE_CONTACTUS = 'contactus';
  static const String MENU_TYPE_GALLERY = 'gallery';
  static const String MENU_TYPE_SERVICES = 'services';
  static const String MENU_TYPE_PACKAGE = 'package';
  static const String MENU_TYPE_MENU = 'Menu';
  static const String MENU_TYPE_HALL = 'Hall';
  static const String MENU_TYPE_REVIEWS = 'Reviews';
  static const String MENU_TYPE_FITNESS = 'Fitness';
  static const String MENU_TYPE_PROFILE = 'Profile';
  static const String IS_MENU_TAB_FULL = 'menu_count';

// DOB

  // static DateTime now = DateTime.now();
  // static String formattedDate = DateFormat('yyyy-MM-dd').format(now);
  // ignore: non_constant_identifier_names
  static String MIN_DATETIME = '1950-01-01';

  // ignore: non_constant_identifier_names
  static String CURRENT_DATETIME =
      SlcDateUtils().getTodayDateWithCurrentRestrictionUIShowEventFormat();
  static String MAX_DATETIME =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();
  static String EVENTMAX_DATETIME =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowEventFormat();
  static String FUTURE_DATETIME =
      SlcDateUtils().getTodayDateWithFutureRestrictionUIShowFormat();
  static DateTime INIT_DATETIME_EVENT =
      DateTime.parse(SlcDateUtils().getTodayDateWithFutureEventShowFormat());
  static int ageRestriction = 8;
  static int eventageRestriction = 5;

  // ignore: non_constant_identifier_names
  static DateTime INIT_DATETIME = DateTime.parse(
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
  static DateTime INIT_EVENTDATETIME = DateTime.parse(
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowEventFormat());

  // static String INIT_DATETIME = DateUtils().getTodayDateUIShowFormat();
  static const String dobFormat = 'dd-MM-yyyy';
  static const DateTimePickerLocale dobLocale = DateTimePickerLocale.en_us;

  // ApplicationId
  static const int Android = 1;

  static const int iOS = 2;

  // static const int  Web =3 ;

  //emailId
  static const String USER_FIRSTNAME = "user_firstname";
  static const String USER_LASTNAME = "user_lastname";
  static const String USER_EMAIL = "spemail";
  static const String USER_MOBILE = "user_mobile";
  static const String USER_DOB = "user_dob";
  static const String USER_TYPE = "user_type";
  static const String USER_TYPEID = "user_type_id";
  static const String USER_NATIONALITYID = "user_nationality";
  static const String USER_COUNTRYDIALCODE = "user_country_dialcode";
  static const String USER_COUNTRYID = "user_country_id";
  static const String USER_GENDERID = "user_gender";
  static const String USER_EMPLOYEETYPE = "user_employeetype";
  static const String USER_EMPLOYEEID = "user_employeeid";
  static const String USER_CUSTOMERID = "user_customerid";
  static const String USER_CLUBMEMBERSHIPID = "user_clubmembershipid";
  static const String USER_FITNESSMEMBERSHIPID = "user_fitnessmembershipid";
  static const String USER_CORPORATEID = "user_corporateid";
  static const String USER_CORPORATECATID = "user_corporatecatid";

  static const String REG_USER_EMAIL = "reg_email";
  static const String REG_USER_MOBILE = "reg_mobile";

  //userid
  static const String USERID = "spuserid";

  static const String INTERNET_SPEED = 'internet_speed';
  static const int NET_SPEED_HIGH = 1;
  static const int NET_SPEED_LOW = 2;
  static const String FACILITY_SELECTED_INDEX = 'selected index';

  //islogin
  // static const String ISLOGIN = "islogin";
  // static const int isLoginSuccess = 1;
  // static const int isLoginfailure = 0;

  //  UAE_MOBILE_PATTERN
  static const String UAE_MOBILE_PATTERN =
      '^(?:\\+971|00971|0)?(?:50|51|52|55|56|54|58)\\d{7}\$';

  static const String IS_CAROUSEL_RETRY = 'is_carousel_retry';
  static const String IS_FACILITY_GROUP_RETRY = 'is_facility_group_retry';
  static const String IS_FACILITY_RETRY = 'is_facility_retry';
  static const String IS_FACILITY_DETAILS_RETRY = 'is_facility_details_retry';
  static const String IS_FACILITY_DETAILS_CATEGORY_RETRY =
      'is_facility_details_category_retry';

  static const String IS_NOTIFICATION_LIST_RETRY = 'is_notification_list_retry';

  static const String FCM_TOKEN = 'fcm_token';
  static const String FEEDBACK_TYPE_SURVEY = 'survey';
  static const String FEEDBACK_TYPE_EVENT = 'event';

  //
  static const String IS_NEW_NOTIFY_AVAIL = "is_notification_available";

  //otp resend timer count
  static const int RESEND_TIME = 30;
  static const String STATUSBAR_HEIGHT = 'statusbar_height';
  static const String REFRESH_HOMEPAGE = 'update_homepage';
  static const String REFRESH_FACILITYDETAILS = 'update_facility_details';

  //login to changepassword flow
  //login to register flow
  static bool isChangePassword = false;

  static bool iSEditClickedInProfile = false;
  static bool iSPageFromProfile = false;

  /*Question type*/
  static const int QUESTION_TYPE_DYNAMIC_ANSWER = 1;
  static const int QUESTION_TYPE_STATIC_ANSWER = 2;
  static const int QUESTION_TYPE_RADIO_BUTTON = 1;
  static const int QUESTION_TYPE_CHECKBOX = 2;

  //otp type is
  static const int ResendOTP = 1;
  static const int ChangePassword = 2;
  static const int MyProfileUpdate = 3;

  //UAE (+971) country code's country ID (for validation)
  static const int UAECountryId = 115;

  //UAE mobile no. lenght
  static const int UAEMobileNumberLength = 9;

  //other countr mobile number length
  static const int OtherMinMobileNumberLength = 5;
  static const int OtherMaxMobileNumberLength = 10;

  /*Survey page reload handler*/
  static const String IS_FACILITY_LIST_RELOADED = "IS_FACILITY_LIST_RELOADED";

  //profile bridgeUserTypeId to show the associate profile

  static const int BRIDGE_GUEST_TYPE_ID = 3;
  static const int BRIDGE_CUSTOMER_TYPE_ID = 1;
  static const int BRIDGE_MEMBER_TYPE_ID = 2;

  //ispage from profile
  static const bool isPageFromNotificationList = true;

  // silent notification types
  static const String NOTIFICATION_KEY = 'key';
  static const String NOTIFICATION_TOKEN_EXPIRED = 'TOKEN EXPIRED';
  static const String NOTIFICATION_INVALID_USER = '1';
  static const String NOTIFICATION_EVENT = '2';
  static const String NOTIFICATION_FACILITY = '3';
  static const String NOTIFICATION_CAROUSEL = '4';

  static const String LANGUAGE_CHANGE_REFRESH_HOME = 'update_home';
  static const String LANGUAGE_CHANGE_REFRESH_EVENT = 'update_event';
  static const String LANGUAGE_CHANGE_REFRESH_SURVEY = 'update_survey';
  static const String KEYBOARD_HIDE_SURVEY = 'keyboard_hide_survey';
  static const String KEYBOARD_HIDE_REVIEW = 'keyboard_hide_review';

  static const String PREVENT_MULTIPLE_DIALOG = "prevent_multiple_dialog";
  static const String SELECTED_FACILITY_ID = "selected_facility_id";
  static const String IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT =
      "is_silent_notification_called_for_event";
  static bool isViewMore = false;
  static bool isNotFromNotificationFamily = false;
  static int isFromNotificationFamily = 0;
  static bool isLogoutDoneToClearPreference = false;

  static int eventsCurrentSelectedChoiseChip = 0;

  //971 UAE country code
  static const String UAE_COUNTRY_CODE = "+971";
  static const String UAE_COUNTRY_CODE_REVERSE_PLUS = "971+";

  static const String CHECK_APP_UPDATE = "CHECK_APP_UPDATE";

  // ignore: non_constant_identifier_names
  static int USERID_CHECK = 0;

  static String whatsAppReplaceTxt = "[NAME]";

  static const int CarouselNoNavigation = 1;
  static const int CarouselInsideNavigation = 2;
  static const int CarouselOutsideNavigation = 3;

  static const String CarouselNavigationTitle = "Carousel Navigation";
  static const int FacilitySpa = 1;
  static const int FacilityBeauty = 2;
  static const int FacilityFitness = 3;
  static const int FacilityLafeel = 4;
  static const int FacilitySkateCafe = 5;
  static const int FacilityKunooz = 6;
  static const int FacilityCollageCafe = 7;
  static const int FacilityCollage = 8;
  static const int FacilityPreschoolCenter = 9;
  static const int FacilityIceRink = 10;
  static const int FacilityOlympicPool = 11;
  static const int FacilityLeisure = 12;
  static const int FacilityBeach = 13;
  static const int FacilityMembership = 14;

  static const int Work_Flow_New = 1;
  static const int Work_Flow_UploadDocuments = 2;
  static const int Work_Flow_AnswerQuestions = 3;
  static const int Work_Flow_AcceptTerms = 4;
  static const int Work_Flow_Signature = 5;
  static const int Work_Flow_Payment = 6;
  static const int Work_Flow_Schedules = 7;
  static const int Work_Flow_Completed = 8;

  static const int Screen_Add_Enquiry = 0;
  static const int Screen_Upload_Document = 1;
  static const int Screen_Accept_Terms = 2;
  static const int Screen_Schedule = 3;
  static const int Screen_Questioner = 4;
  static const int Screen_Signature = 5;
  static const int Screen_Contract = 6;
  static const int Screen_MenuList = 7;

  static String whatsAppURL(String phone, String msg) {
    msg = msg.replaceFirst(
        Constants.whatsAppReplaceTxt,
        SPUtil.getString(Constants.USER_FIRSTNAME) +
            " " +
            SPUtil.getString(Constants.USER_LASTNAME));
    if (Platform.isIOS) {
      return "https://wa.me/$phone/?text=${Uri.parse(msg)}";
    } else {
      return "whatsapp://send?phone=$phone&text=${Uri.encodeFull(msg)}";
      // return "https://wa.me/$phone/?text=${Uri.encodeFull(msg)}";
    }
  }
}
