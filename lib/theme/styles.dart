import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/fonts.dart';

class Styles {
  static double _textSizLarge = 25.0;
  static double _textSizSmall = 16.0;
  static double _textSizDefault = 16.0;
  static double textSizTwenty = 20.0;
  static double textSizRegular = 15.0;
  static double textSiz = 12.0;
  static double reviewTextSize = 11.0;
  static double packageExpandTextSiz = 12.0;
  static double loginBtnFontSize = 13.0;
  static double packageHeadOpacityLevel = 0.5;
  static double packageSubOpacityLevel = 1.0;
  static double textSizeSmall = 14.0;
  static double textSizesizteen = 16.0;
  static double textSizeSeventeen = 17.0;
  static double discountTextSize = 10.0;
  static double newTextSize = 9.0;
  static double specialText = 7.0;
  static double specialText10 = 8.0;
  static String fontMulti = 'Muli';
  static final navBarStyle = TextStyle(fontFamily: fontMulti);

  static final headerLarge = TextStyle(
      fontSize: _textSizLarge,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerLargeWithPurple = TextStyle(
      fontSize: _textSizLarge,
      color: ColorData.fitnessFacilityColor,
      fontFamily: fontMulti);
  static final headerMedium = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerMediumWithWhite = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.whiteColor,
      fontFamily: fontMulti);
  static final headerMediumWithPurple = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.fitnessFacilityColor,
      fontFamily: fontMulti);
  static final headerMediumWithBlue = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.blueColor,
      fontFamily: fontMulti);
  static final headerSmall = TextStyle(
      fontSize: _textSizSmall,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);
  static final headerLargeWithColor = TextStyle(
      fontSize: FontSizeData.fontLargeSize,
      color: ColorData.blueColor,
      fontFamily: fontMulti);

  static final profileheaderMedium = TextStyle(
      fontSize: _textSizDefault,
      color: ColorData.primaryTextColor,
      fontFamily: fontMulti);

  static final profileheaderMediumWhite = TextStyle(
      fontSize: textSizRegular,
      color: ColorData.whiteColor,
      fontFamily: fontMulti);

  static final profiletextDefault = TextStyle(
      fontSize: packageExpandTextSiz, color: ColorData.primaryTextColor);

  static final textDefault =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);
  static final textDefaultRegular =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);

  static final textDefaultWithBold = TextStyle(
      fontSize: _textSizDefault,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.w800);

  static final textRegular =
      TextStyle(fontSize: textSizRegular, color: ColorData.primaryTextColor);

  static final textDefaultWithPurple = TextStyle(
      fontSize: _textSizDefault, color: ColorData.fitnessFacilityColor);

  static final textDefaultWithBlue =
      TextStyle(fontSize: _textSizDefault, color: ColorData.profileMember);

  static final textDefaultWithWhite =
      TextStyle(fontSize: _textSizDefault, color: ColorData.whiteColor);

  static final textDefaultWhiteWithBold = TextStyle(
      fontSize: _textSizDefault,
      color: ColorData.whiteColor,
      fontWeight: FontWeight.w800);

  static final textDefaultWithColor = TextStyle(
      fontSize: _textSizDefault,
      color: Color(0xffBBD400),
      fontWeight: FontWeight.w800);

  static final textDefaultPurpleWithBold = TextStyle(
      fontSize: textSizRegular,
      color: ColorData.fitnessFacilityColor,
      fontWeight: FontWeight.w800);
  static final textLargePurpleWithBold = TextStyle(
      fontSize: _textSizLarge,
      color: ColorData.fitnessFacilityColor,
      fontWeight: FontWeight.w800);

  static final textSmall = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.w700);

  static final textSmallWithPurple = TextStyle(
      fontSize: textSiz,
      color: ColorData.fitnessFacilityColor,
      fontWeight: FontWeight.w700);

  static final textSmallWithoutBold = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.w500);

  static final textSmallWithWhite = TextStyle(
      fontSize: textSiz,
      color: ColorData.whiteColor,
      fontWeight: FontWeight.w500);
  static final textSmallReg = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor.withOpacity(0.8),
      fontWeight: FontWeight.w500);

  static final textSmallPackage = TextStyle(
      fontSize: reviewTextSize,
      color: ColorData.primaryTextColor.withOpacity(0.8),
      fontWeight: FontWeight.w500);
  static final textDefaultWithWhiteColor =
      TextStyle(fontSize: _textSizDefault, color: ColorData.whiteColor);

  static final textSmallPurple = TextStyle(
      fontSize: reviewTextSize,
      color: ColorData.fitnessFacilityColor,
      fontWeight: FontWeight.w500);

  static final textDefaultWithGreyColor =
      TextStyle(fontSize: _textSizDefault, color: ColorData.primaryTextColor);

  static final textFacilityHeader = TextStyle(
      fontSize: textSizTwenty,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.bold);

  static final textFacilityName = TextStyle(
    fontSize: textSiz,
    color: ColorData.primaryTextColor,
  );
  static final textFacilityNameSelected = TextStyle(
      fontSize: textSiz,
      color: ColorData.primaryTextColor,
      fontWeight: FontWeight.bold);

  static final textSmallSize = TextStyle(
    fontSize: textSizeSmall,
    color: ColorData.primaryTextColor,
  );

  static final failureUIStyle = TextStyle(
    fontSize: textSizeSmall,
    color: ColorData.primaryTextColor,
  );
  static final ttCellStyle = TextStyle(
    fontSize: reviewTextSize,
    color: ColorData.primaryTextColor,
  );
  static final ttCellWVStyle = TextStyle(
    fontSize: reviewTextSize,
    color: ColorData.fitnessFacilityColor,
  );
  static final textTrainerHead = TextStyle(
      fontSize: textSizeSmall,
      color: ColorData.fitnessFacilityColor,
      fontWeight: FontWeight.w700);
}

class PackageListHead {
  static packageHeadSubTextStyle(context, opacity, txt) {
    return Text(txt,
        style: TextStyle(
            color: ColorData.blueColor,
            fontSize: Styles.packageExpandTextSiz,
            fontFamily: tr('currFontFamily'),
            fontWeight: opacity == 1.0 ? FontWeight.w500 : null));
  }

  static customTextView(context, opacity, txt, isblue, weight) {
    return Text(txt,
        style: TextStyle(
          color: isblue
              ? Theme.of(context).primaryColor
              : ColorData.primaryTextColor,
//                .withOpacity(opacity)
          fontSize: Styles.packageExpandTextSiz,
//          fontWeight: weight,
          fontFamily: tr("currFontFamilyEnglishOnly"),
        ));
  }

  static customRadioTabTextView(context, txt, weight, isSelected) {
    return Text(txt,
        style: TextStyle(
            color: isSelected ? Colors.white : ColorData.primaryTextColor,
            fontSize: Styles.packageExpandTextSiz,
            fontWeight: weight,
            fontFamily: tr('currFontFamily')));
  }

  static packageExpandTextStyle(context, opacity, txt, isblue) {
    return Expanded(
      child: Text(txt,
          style: TextStyle(
              color: isblue
                  ? Theme.of(context).primaryColor.withOpacity(opacity)
                  : ColorData.primaryTextColor.withOpacity(opacity),
              fontSize: Styles.packageExpandTextSiz,
//              fontWeight: opacity == 1.0 ? FontWeight.w500 : null,
              fontFamily: tr('currFontFamily'))),
    );
  }

  static packageExpandProfileTextStyle(
    context,
    txt,
  ) {
    return Text(txt,
        style: TextStyle(
            color: ColorData.primaryTextColor,
            fontSize: Styles.loginBtnFontSize,
            fontFamily: tr('currFontFamily')));
  }

  static homePageTitleFontTextStyle(context, txt) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: tr('currFontFamily'),
          fontSize: Styles.textSizTwenty,
          color: ColorData.whiteColor,
          fontWeight: FontWeight.bold),
    );
  }

  static homePageTitle(context, txt) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: tr('currFontFamily'),
          fontSize: Styles.textSizeSeventeen,
          color: ColorData.activeIconColor,
          fontWeight: FontWeight.bold),
    );
  }

  static facilityDetailsPageTitle(context, txt) {
    return Text(
      txt,
      style: TextStyle(
          fontFamily: tr('currFontFamily'),
          fontSize: Styles.textSizTwenty,
          color: ColorData.activeIconColor,
          fontWeight: FontWeight.bold),
    );
  }

  static facilityExpandTileTextStyle(context, opacity, txt, color, isBlue) {
    return Text(txt,
        style: TextStyle(
            color: isBlue ? color : ColorData.primaryTextColor,
            fontSize: Styles.packageExpandTextSiz,
            fontWeight: opacity == 1.0 ? FontWeight.w500 : null,
            fontFamily: tr('currFontFamily')));
  }

  static snackBarTextStyle(context, txt) {
    return Text(tr(txt),
        style: TextStyle(
            color: Colors.white,
            fontSize: Styles.loginBtnFontSize,
            //  fontWeight: opacity == 1.0 ? FontWeight.w500 : null,
            fontFamily: tr('currFontFamily')));
  }

  static textFieldStyles(context, isBlue) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr('currFontFamily'),
      color:
          isBlue ? Theme.of(context).primaryColor : ColorData.primaryTextColor,
    );
  }

  static textFieldStylesSurvey(context, isBlue) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr('currFontFamilyEnglishOnly'),
      color:
          isBlue ? Theme.of(context).primaryColor : ColorData.primaryTextColor,
    );
  }

  static textFieldStyleWithoutArab(context, isBlue) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr("currFontFamilyEnglishOnly"),
      color:
          isBlue ? Theme.of(context).primaryColor : ColorData.primaryTextColor,
    );
  }

  static textFieldStyleWithoutArabWithColor(context, color) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr("currFontFamilyEnglishOnly"),
      color: color,
    );
  }

  static textWithStyleMediumFont({context, contentTitle, color, fontSize}) {
    return Text(contentTitle,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: tr('currFontFamily'),
          color: ColorData.primaryTextColor,
        ));
  }

  static textFieldStylesForNumbers(context, isBlue) {
    return TextStyle(
        fontSize: Styles.loginBtnFontSize,
        fontFamily: tr("currFontFamilyEnglishOnly"),
        color: isBlue
            ? Theme.of(context).primaryColor
            : ColorData.primaryTextColor,
        fontWeight: FontWeight.w200);
  }

  static textFieldIsBlue(context, txt, isBlue) {
    return Text(
      tr(txt),
      style: TextStyle(
        fontSize: Styles.loginBtnFontSize,
        fontFamily: tr('currFontFamily'),
        color: isBlue
            ? Theme.of(context).primaryColor
            : ColorData.primaryTextColor,
      ),
    );
  }

  static textFieldCountryCodeStyles(context) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr("currFontFamilyEnglishOnly"),
      //fontWeight: opacity == 1.0 ? FontWeight.w500 : null,

      color: ColorData.primaryTextColor,
    );
  }

  static surveyDropDownTextStyle(context, opacity) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr("currFontFamilyMedium"),
      fontWeight: opacity == 1.0 ? FontWeight.w300 : null,
      color: ColorData.primaryTextColor,
    );
  }

  static morePageTextStyle(context, txt) {
    return Text(
      tr(txt),
      style: TextStyle(
        fontSize: Styles.packageExpandTextSiz,
        fontFamily: tr('currFontFamilyRegular'),
        color: ColorData.primaryTextColor,
//          fontWeight: FontWeight.w500
      ),
    );
  }

  static facilityItemsListText(context, txt) {
    return Text(txt,
        style: TextStyle(
          fontSize: Styles.textSiz,
          color: ColorData.primaryTextColor,
          fontWeight: FontWeight.bold,
          fontFamily: tr('currFontFamily'),
        ));
  }

  static genderNationalityPicker(context, txt) {
    return Text(txt,
        style: TextStyle(
          fontSize: Styles.textSiz,
          color: ColorData.primaryTextColor,
          // fontWeight: FontWeight.bold,
          fontFamily: tr('currFontFamily'),
        ));
  }

  static facilityItemsSelectedListText(context, txt) {
    return Text(txt,
        style: TextStyle(
          fontSize: Styles.textSiz,
          color: Color(0xFF3EB5E3),
          fontWeight: FontWeight.bold,
          fontFamily: tr('currFontFamily'),
        ));
  }

  static reviewDateStyle(context, txt) {
    return Text(txt,
        style: TextStyle(
          fontSize: Styles.reviewTextSize,
          color: ColorData.primaryTextColor,
          // fontWeight: FontWeight.bold,
          fontFamily: tr('currFontFamilyEnglishOnly'),
        ));
  }
}

class EventDetailPageStyle {
  //event details page styles
  static eventDetailPageTextStyleWithoutAr(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      color: ColorData.primaryTextColor,
      fontFamily: tr('currFontFamilyEnglishOnly'),
    );
  }

  static eventDetailPageTextStyleWithOpa(context) {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: Styles.discountTextSize,
      color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
      fontFamily: tr('currFontFamily'),
    );
  }

  static eventDetailPageTextStyleWithAr(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      color: ColorData.primaryTextColor,
      fontFamily: tr('currFontFamily'),
    );
  }

  static eventDetailPageTextStyleWithNewAr(context) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontWeight: FontWeight.bold,
      color: ColorData.blueColor,
      fontFamily: tr('currFontFamily'),
    );
  }

  static eventOriginalStyleWithAr(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      color: Colors.grey,
      fontFamily: tr('currFontFamily'),
    );
  }

  static acceptProceed(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      fontWeight: FontWeight.bold,
      color: ColorData.primaryTextColor,
      fontFamily: tr('currFontFamily'),
    );
  }

//heading
  static eventDetailPageHeadingTextStyle(context) {
    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: Styles.textSizTwenty,
        fontFamily: tr('currFontFamily'));
  }

  //sub heading
  static eventDetailPageSubHeadingTextStyle(context) {
    return TextStyle(
        color: ColorData.primaryTextColor,
        fontSize: Styles.textSizeSmall,
        fontFamily: tr('currFontFamily'));
  }
}

class EventPeopleListPageStyle {
  //event PeopleList page styles

  static eventPeopleListPageTextStyleWithoutAr(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      color: ColorData.primaryTextColor,
      fontFamily: tr('currFontFamilyEnglishOnly'),
    );
  }

  static eventPeopleListPageTextStyleWithAr(context, {bool isBlue = false}) {
    return TextStyle(
      fontSize: Styles.textSiz,
      color:
          isBlue ? Theme.of(context).primaryColor : ColorData.primaryTextColor,
      fontFamily: tr('currFontFamily'),
    );
  }

//heading
  static eventPeopleListPageHeadingTextStyle(context) {
    return TextStyle(
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.bold,
        fontSize: Styles.textSizTwenty,
        fontFamily: tr('currFontFamily'));
  }

  //sub heading
  static eventPeopleListPageSubHeadingTextStyle(context,
      {bool isBlue = false}) {
    return TextStyle(
        color: isBlue
            ? Theme.of(context).primaryColor
            : ColorData.primaryTextColor,
        fontSize: Styles.textSizeSmall,
        fontFamily: tr('currFontFamily'));
  }

  //total in aed price
  static eventPeopleListPageSubHeadingTextStyleWithoutAr(context) {
    return TextStyle(
        color: ColorData.primaryTextColor,
        fontSize: Styles.textSizeSmall,
        fontFamily: tr('currFontFamilyEnglishOnly'));
  }

  //button
  static eventPeopleListPageBtnTextStyleWithAr(context) {
    return TextStyle(
      fontSize: Styles.textSizeSmall,
      color: ColorData.whiteColor,
      fontFamily: tr('currFontFamily'),
    );
  }
}

class NotificationListPageStyle {
  /*Notification list page*/

  static notificationListClearAllTextStyle(context) {
    return TextStyle(
      fontSize: Styles.textSizeSmall,
      fontFamily: tr("currFontFamily"),
      color: ColorData.primaryTextColor,
    );
  }

  static notificationListNoDataFoundTextStyle(context) {
    return TextStyle(
      fontSize: Styles.textSiz,
      fontFamily: tr("currFontFamily"),
      color: ColorData.primaryTextColor,
    );
  }

  static notificationListTitleTextStyle(context) {
    return TextStyle(
      fontSize: Styles._textSizDefault,
      fontFamily: tr('currFontFamilyEnglishOnly'),
      fontWeight: FontWeight.bold,
      color: Theme.of(context).primaryColor,
    );
  }

  static notificationListShortDescriptionTextStyle(context) {
    return TextStyle(
      color: ColorData.primaryTextColor,
      fontSize: Styles.textSizeSmall,
      fontFamily: tr('currFontFamilyEnglishOnly'),
    );
  }

  static notificationListTimeTextStyle(context) {
    return TextStyle(
      color: ColorData.notificationTimeTextColor,
      fontSize: Styles.textSiz,
      fontFamily: tr('currFontFamilyEnglishOnly'),
    );
  }

/*Notification list page*/
}

class NotificationDetailPageStyle {
  /*Notification detail page*/

  static notificationDetailNotificationTitleTextStyle(context) {
    return TextStyle(
      color: ColorData.primaryTextColor,
      fontSize: Styles.textSizeSmall,
      fontFamily: tr('currFontFamilyEnglishOnly'),
    );
  }

  static notificationDetailViewMoreBtnTextStyle(context) {
    return TextStyle(
        fontFamily: tr('currFontFamily'), fontSize: Styles.textSizeSmall);
  }

/*Notification detail page*/
}

class MorePageStyle {
  morePageAboutUsTextStyle(context) {
    return TextStyle(
      height: 2,
      fontSize: Styles.reviewTextSize,
      fontFamily: tr('currFontFamilyRegular'),
      color: ColorData.primaryTextColor,
    );
  }

  morePageTextStyle(context, txt) {
    return Text(
      tr(txt),
      style: TextStyle(
        fontSize: Styles.packageExpandTextSiz,
        fontFamily: tr('currFontFamilyRegular'),
        color: ColorData.primaryTextColor,
//          fontWeight: FontWeight.w500
      ),
    );
  }

  //more page phone no.s alone
  morePageTextStyleForNumbers(context, txt) {
    return Text(
      tr(txt),
      textDirection: prefix.TextDirection.ltr,
      style: TextStyle(
        fontSize: Styles.packageExpandTextSiz,
        fontFamily: tr('currFontFamilyEnglishOnly'),
        color: ColorData.primaryTextColor,
//          fontWeight: FontWeight.w500
      ),
    );
  }

  //more page email no.s alone
  morePageTextStyleForEmailNumbers(context, txt) {
    return Text(
      tr(txt),
      style: TextStyle(
        fontSize: Styles.packageExpandTextSiz,
        fontFamily: tr('currFontFamilyEnglishOnly'),
        color: ColorData.primaryTextColor,
//          fontWeight: FontWeight.w500
      ),
    );
  }

/*more page*/
}

class distance {
  static distancepage(context, {bool isBlue = false}) {
    return TextStyle(
        color: ColorData.primaryTextColor,
        fontSize: Styles.textSiz,
        fontFamily: tr('currFontFamily'));
  }

  static textFieldStyles(context, isBlue) {
    return TextStyle(
      fontSize: Styles.loginBtnFontSize,
      fontFamily: tr('currFontFamily'),
      color:
          isBlue ? Theme.of(context).primaryColor : ColorData.primaryTextColor,
    );
  }
}
