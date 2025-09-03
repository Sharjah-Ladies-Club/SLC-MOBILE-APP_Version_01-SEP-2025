import 'dart:convert';
import 'dart:ui' as prefix;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/theme/fonts.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/login/login_page.dart';
import 'package:slc/view/otp/pin_code_text_field.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_success_dialog.dart';

import 'bloc/bloc.dart';

class ChangePassword extends StatelessWidget {
  final int userId;

  ChangePassword(this.userId);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await customAlertDialog(
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
                  })) ??
          false;
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      // child: Scaffold(
      child: BlocProvider(
        create: (context) {
          return ChangePasswordBloc(null);
        },
        child: _ChangePassword(userId),
      ),
      // ),
    );
  }
}

class _ChangePassword extends StatefulWidget {
  final int userId;

  _ChangePassword(this.userId);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<_ChangePassword> {
  TextEditingController _passwordController = TextEditingController();
  Utils util = Utils();
  UserRepository userRepository = UserRepository();
  ProgressBarHandler _handler;
  DialogHandler _handlerDialog;

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    var dialogHolder = ModalRoundedDialog(
      handleCallback: (handler) {
        _handlerDialog = handler;
        return;
      },
      content: tr("pass_changed_success_msg"),
      title: tr("change_pass_alert_head"),
      positiveCallBack: () {
        SPUtil.remove(Constants.REG_USER_EMAIL);
        SPUtil.remove(Constants.REG_USER_MOBILE);
        Get.offAll(LoginPage(userRepository: UserRepository()));
      },
    );

    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
      listener: (BuildContext context, state) {
        if (state is OnSuccess) {
          if (jsonDecode(state.response)["response"]["userId"] != null) {
            _handlerDialog.show();
          }
        } else if (state is OnFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is LanguageSwitchedSuccess) {
        } else if (state is LanguageSwitchedFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        }
      },
      child: BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
        builder: (BuildContext context, state) {
          return Stack(children: <Widget>[mainUI(), progressBar, dialogHolder]);
        },
      ),
    );
  }

  Widget mainUI() {
    return GestureDetector(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: "ChangePassword",
                headerTitle: tr('welcome'),
                subTitle: Constants.isChangePassword == true
                    ? tr('changePasswordToCon')
                    : tr('registerToContinue'),
                assetImagePath: 'assets/images/UnionFace.png',
                onLanguageChange: (val) {
                  BlocProvider.of<ChangePasswordBloc>(context).add(
                    OnLanguagechangeInReg(context: context),
                  );
                },
              ),
            ],
          ),
          preferredSize: Size.fromHeight(210.0),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      PinCodeTextField(
                        textDirection:
                            Localizations.localeOf(context).languageCode == "en"
                                ? prefix.TextDirection.ltr
                                : prefix.TextDirection.rtl,
                        autofocus: false,
                        controller: _passwordController,
                        hideCharacter: true,
                        highlight: true,
                        defaultBorderColor:
                            ColorData.eventHomePageDeSelectedCircularFill,
                        maxLength: 4,
                        pinBoxWidth: 55.0,
                        pinBoxHeight: 50.0,
                        maskCharacter: Strings.maskText,
                        onDone: (text) {},
                        wrapAlignment: WrapAlignment.spaceAround,
                        pinBoxDecoration:
                            ProvidedPinBoxDecoration.defaultPinBoxDecoration,
                        pinTextStyle: TextStyle(
                          fontSize: FontSizeData.fontSizeThirty,
                          fontFamily: tr('currFontFamily'),
                        ),
                        pinTextAnimatedSwitcherTransition:
                            ProvidedPinBoxTextAnimation.scalingTransition,
                        pinTextAnimatedSwitcherDuration:
                            Duration(milliseconds: Integer.milliseconds),
                        highlightAnimationBeginColor: ColorData.blackColor,
                        highlightAnimationEndColor: ColorData.whiteColor,
                        keyboardType: TextInputType.number,
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: LoginRegSubmitButton(tr("confirm"), () {
                            if (_validatePassword()) {
                              onConfirmBtnPressed();
                            }
                          }),
                        ),
                      ),
                      LoginRegFooter("login", "login"),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  _validatePassword() {
    if (_passwordController.text == '') {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('passwordErrorMessage'), context);
      return false;
    } else if (_passwordController.text.length < 4) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('passwordInvlidLength'), context);
      return false;
    }
    return true;
  }

  onConfirmBtnPressed() {
    BlocProvider.of<ChangePasswordBloc>(context).add(
      ConfirmBtnPressed(
          userId: widget.userId, password: _passwordController.text),
    );
  }
}
