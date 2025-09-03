import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/common_switch_button.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/dimension.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/profile/profile_new.dart';

// ignore: must_be_immutable
class LoginRegAppBar extends StatelessWidget {
  String pageTitle;
  String assetImagePath;
  String headerTitle;
  String subTitle;
  Function onLanguageChange;
  UserRepository userRepository = UserRepository();

  LoginRegAppBar(
      {this.pageTitle,
      this.assetImagePath,
      this.headerTitle,
      this.subTitle,
      this.onLanguageChange});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(this.assetImagePath),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                pageTitle == "Login" || pageTitle == "BaseInfoOne"
                    ? Container()
                    : Container(
                        margin: Constants.iSEditClickedInProfile &&
                                Localizations.localeOf(context).languageCode ==
                                    "ar"
                            ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0)
                            : EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0),
                        child: IconButton(
                            icon: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                            ),
                            onPressed: () => {
                                  _backBtnNavigation(context),
                                }),
                      ),
                Container(
                  margin: Localizations.localeOf(context).languageCode == "ar"
                      ? Constants.iSEditClickedInProfile
                          ? EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0)
                          : EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0)
                      : EdgeInsets.fromLTRB(10.0, 60.0, 10.0, 0),
                  child: Text(
                    !Constants.iSEditClickedInProfile
                        ? this.headerTitle
                        : "OTP",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimension.fontSizeTwenty,
                      fontFamily: tr('currFontFamilyMedium'),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: pageTitle == "Login" || pageTitle == "BaseInfoOne"
                  ? EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0)
                  : Localizations.localeOf(context).languageCode == "ar"
                      ? EdgeInsets.fromLTRB(60.0, 0.0, 60.0, 0.0)
                      : EdgeInsets.fromLTRB(60.0, 0.0, 30.0, 0.0),
              child: Text(
                !Constants.iSEditClickedInProfile ? this.subTitle : "",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: tr('currFontFamily'),
                ),
              ),
            ),
            Visibility(
              visible: !Constants.iSEditClickedInProfile,
              child: Container(
                margin: EdgeInsets.only(
                    top: Localizations.localeOf(context).languageCode == "en"
                        ? 75.0
                        : 60.0),
                child: CustomSwitchField(subTitle, (onLngSwitchVal) {
                  onLanguageChange(onLngSwitchVal);
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _backBtnNavigation(context) {
    // if (pageTitle == "Login") {
    //   customAlertDialog(
    //       context,
    //       tr("discard_message"),
    //       tr("yes"),
    //       tr("no"),
    //       "Login",
    //       tr("confirm"),
    //       () => {
    //             // Navigator.of(context).pop(),
    //             // Navigator.of(context).pop(),
    //             exit(0),
    //           });
    // }
    // else if (pageTitle == "BaseInfoOne") {
    //   customAlertDialog(context, "Do you want to exit ?", "Yes", "No", "Login", "Confirm", () {
    //     Navigator.of(context).pop();
    // });
    // Navigator.of(context).pop();
    // Navigator.pushReplacement(
    //     context,
    //     new MaterialPageRoute(
    //         builder: (context) => LoginPage(
    //               userRepository: userRepository,
    //             )));
    // }
    //  else
    if (pageTitle == "OTP") {
      customAlertDialog(
          context,
          tr("txt_contact_us_error"),
          tr("yes"),
          tr("no"),
          tr("otp"),
          tr("confirm"),
          () => {
                // Get.offAll(BaseInfoOne(), (route) => false)
                Navigator.of(context).pop(),
                // Navigator.of(context).pop(),
              });
    } else if (pageTitle == "ChangePassword") {
      customAlertDialog(
          context,
          tr("txt_contact_us_error"),
          tr("yes"),
          tr("no"),
          tr("otp"),
          tr("confirm"),
          () => {
                // Get.offAll(BaseInfoOne(), (route) => false)
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
              });
    } else if (pageTitle == "BaseInfoTwo") {
      customAlertDialog(
          context,
          tr("discard_message"),
          tr("yes"),
          tr("no"),
          tr("otp"),
          tr("confirm"),
          () => {
                Navigator.of(context).pop(),
                Navigator.of(context).pop(),
              });
    } else if (pageTitle == "TC") {
      customAlertDialog(
          context,
          tr("discard_message"),
          tr("yes"),
          tr("no"),
          tr("otp"),
          tr("confirm"),
          () => {
                Navigator.of(context).pop(),
              });
    } else if (pageTitle == "ProfileOTP") {
      customAlertDialog(
          context,
          tr("discard_message"),
          tr("yes"),
          tr("no"),
          // "OTP",
          tr("otp"),
          tr("confirm"),
          () => {
                Navigator.of(context).pop(),
                Navigator.pushReplacement(
                    context,
                    new MaterialPageRoute(
                        builder: (context) =>
                            ProfileNew(Strings.ProfileInitialState))),
              });
    }
  }
}
