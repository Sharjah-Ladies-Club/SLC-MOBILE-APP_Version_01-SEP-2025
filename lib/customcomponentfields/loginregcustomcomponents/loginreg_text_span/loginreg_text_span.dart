import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/login/login_page.dart';
import 'package:slc/view/registration/page_one/base_info_one.dart';

// ignore: must_be_immutable
class LoginRegTextSpan extends StatelessWidget {
  UserRepository userRepository = UserRepository();
  String btnTitle;

  LoginRegTextSpan(this.btnTitle);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: btnTitle == "Login"
            ? EdgeInsets.only(bottom: 30.0)
            : EdgeInsets.only(bottom: 20.0),
        child: GestureDetector(
          onTap: () {
            SPUtil.remove(Constants.REG_USER_EMAIL);
            SPUtil.remove(Constants.REG_USER_MOBILE);
            btnTitle == "Login"
                ? Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        Constants.isChangePassword = false;
                        return BaseInfoOne();
                      },
                    ),
                  )
                : customAlertDialog(
                    context,
                    tr("discard_message"),
                    tr("yes"),
                    tr("no"),
                    tr("otp"),
                    tr("confirm"),
                    () => {
                          Get.offAll(LoginPage(
                            userRepository: userRepository,
                          ))
                        });
          },
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: Styles.packageExpandTextSiz,
                fontFamily: tr('currFontFamily'),
              ),
              children: <TextSpan>[
                TextSpan(
                  text: btnTitle == "Login"
                      ? tr('doNotHaveAc')
                      : tr('alreadyHavAcc'),
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: ColorData.primaryTextColor.withOpacity(1.0),
                  ),
                ),
                TextSpan(
                  text: "  ",
                  style: TextStyle(),
                ),
                TextSpan(
                  /*registerHere*/
                  text:
                      // "registerHere",
                      btnTitle == "Login" ? tr('registerHere') : tr('signIn'),
                  style: new TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(1.0),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
