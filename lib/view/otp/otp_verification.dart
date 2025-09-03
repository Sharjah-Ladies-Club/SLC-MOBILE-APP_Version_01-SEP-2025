import 'dart:convert';
import 'dart:ui' as prefix;
import 'package:countdown/countdown.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/fonts.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/imgutils.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/bloc/bloc.dart';
import 'package:slc/view/otp/pin_code_text_field.dart';
import 'package:slc/view/registration/change_password/changepassword.dart';
import 'package:slc/view/registration/page_two/base_info_two.dart';

class OtpVerification extends StatelessWidget {
  final String mobileNumber;
  final int userId;
  final String dialcode;
  final String email;
  final bool isCorporate;

  OtpVerification(this.mobileNumber, this.userId, this.dialcode, this.email,
      {this.isCorporate = false});

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
                    Navigator.of(context).pop(),
                  })) ??
          false;
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      // child: Scaffold(
      child: BlocProvider(
        create: (context) {
          return OtpBloc(null);
        },
        child: _OtpVerification(
          mobileNumber,
          userId,
          dialcode,
          email,
          isCorporate: isCorporate,
        ),
      ),
      // ),
    );
  }
}

class _OtpVerification extends StatefulWidget {
  final String mobileNumber;
  final int userId;
  final String dialcode;
  final String email;
  final bool isCorporate;

  _OtpVerification(this.mobileNumber, this.userId, this.dialcode, this.email,
      {this.isCorporate});

  @override
  _OtpVerificationPage createState() => _OtpVerificationPage(dialcode);
}

class _OtpVerificationPage extends State<_OtpVerification> {
  final String dialcode;

  _OtpVerificationPage(this.dialcode);

  TextEditingController _otpController = TextEditingController(text: "");
  bool hasTimerStopped = false;

  Utils util = Utils();

  ProgressBarHandler _handler;

  String _setTime = '00:00';
  var sub;

  @override
  void initState() {
    super.initState();

    timerStarts();
  }

  timerStarts() {
    CountDown cd = CountDown(Duration(seconds: Constants.RESEND_TIME));
    sub = cd.stream.listen(null);

    sub.onData((Duration d) {
      setState(() {
        _setTime = d.inSeconds < 10
            ? "00:0" + d.inSeconds.toString()
            : "00:" + d.inSeconds.toString();
        if (hasTimerStopped) hasTimerStopped = false;
      });
      sub.onDone(() {
        setState(() {
          hasTimerStopped = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    return BlocListener<OtpBloc, OtpState>(
      listener: (BuildContext context, state) {
        if (state is OnSuccess) {
          if (state.responseType == "otpValidateResponse") {
            if (Constants.isChangePassword || widget.isCorporate) {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => ChangePassword(
                          jsonDecode(state.response)["response"]["userId"])));
            } else {
              Get.to(() => BaseInfoTwo(state.response));
              // UserInfo userInfo;

              // Get.to(RegistrationTermsAndCondition(userInfo));
            }
          } else if (state.responseType == "otpResendResponse") {
            setState(() {
              timerStarts();
              hasTimerStopped = false;
              _otpController.text = "";
            });

            util.customGetSnackBarWithOutActionButton(
                tr('success_caps'), "OTP Sent successfully", context);
          }
        } else if (state is OnFailure) {
          if (state.responseType == "otpValidateResponse") {
            util.customGetSnackBarWithOutActionButton(
                tr('error_caps'), (state.error), context);
          }
        } else if (state is ShowProgressBar) {
          _handler.show();
          // print("---> ShowProgressBar called");
        } else if (state is HideProgressBar) {
          // print("---> HideProgressBar called");
          _handler.dismiss();
        } else if (state is LanguageSwitchedSuccess) {
          // print('success===>language switched through bloc');
        } else if (state is LanguageSwitchedFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        }
      },
      child: BlocBuilder<OtpBloc, OtpState>(
        builder: (BuildContext context, state) {
          return Stack(children: <Widget>[mainUI(context), progressBar]);
        },
      ),
    );
  }

  dynamic onExit() {
    return customAlertDialog(
        context,
        "Do you want to discard ?",
        "Yes",
        "No",
        "OTP",
        "Confirm",
        () => {
              Navigator.of(context).pop(),
            });
  }

  Widget mainUI(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: "OTP",
                headerTitle: tr('welcome'),
                subTitle: Constants.isChangePassword == true
                    ? tr('changePasswordToCon')
                    : tr('registerToContinue'),
                assetImagePath: 'assets/images/Register_2.png',
                onLanguageChange: (val) {
                  BlocProvider.of<OtpBloc>(context).add(
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
                      LoginPageImage("register"),
                      pincodeBox(),
                      resendPinAndTimer(),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: LoginRegSubmitButton("continue", () {
                            if (_validateOTP()) {
                              continueBtnPres();
                            }
                          }),
                        ),
                      ),
                      LoginRegFooter("register", "BasicInfoTwo"),
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

  Widget resendPinAndTimer() {
    return Container(
      padding: EdgeInsets.only(right: 10),
      margin: EdgeInsets.only(
        left: 10.0,
        right: 10.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Visibility(
            visible: hasTimerStopped,
            child: GestureDetector(
                onTap: () {
                  // print("resend pin");
                  if (hasTimerStopped) {
                    resendOTP();
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: PackageListHead.customTextView(
                      context,
                      hasTimerStopped ? 1.0 : 0.5,
                      tr('resendOtp'),
                      hasTimerStopped,
                      FontWeight.w500),
                )),
          ),
          Visibility(
              visible: !hasTimerStopped,
              child: Text("$_setTime",
                  style: TextStyle(
                    color: ColorData.primaryTextColor,
                    fontSize: Styles.packageExpandTextSiz,
                    fontFamily: tr("currFontFamilyEnglishOnly"),
                  ))),
//              PackageListHead.customTextView(
//                  context, 1.0, "${_setTime}", false, FontWeight.bold)),
        ],
      ),
    );
  }

  Widget pincodeBox() {
    return PinCodeTextField(
      textDirection: Localizations.localeOf(context).languageCode == "en"
          ? prefix.TextDirection.ltr
          : prefix.TextDirection.rtl,
      autofocus: false,
      controller: _otpController,
//      pinBoxOuterPadding: EdgeInsets.symmetric(horizontal: 4.0),
      hideCharacter: true,
      highlight: true,
      defaultBorderColor: ColorData.eventHomePageDeSelectedCircularFill,
      maxLength: 6,
      pinBoxWidth: MediaQuery.of(context).size.width < 350.0
          ? (MediaQuery.of(context).size.width / 6) - 23.0
          : 40.0,
      pinBoxHeight: MediaQuery.of(context).size.width < 350.0
          ? ((MediaQuery.of(context).size.width / 6) - 23.0) + 10.0
          : 50.0,
      maskCharacter: Strings.maskText,
      onDone: (text) {
        print("DONE $text");
        print("DONE CONTROLLER ${_otpController.text}");
      },
      wrapAlignment: WrapAlignment.spaceAround,
      pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
      pinTextStyle: TextStyle(
        color: ColorData.primaryTextColor,
        fontSize: FontSizeData.fontSizeThirty,
        fontFamily: tr('currFontFamily'),
      ),
      pinTextAnimatedSwitcherTransition:
          ProvidedPinBoxTextAnimation.scalingTransition,
      pinTextAnimatedSwitcherDuration:
          Duration(milliseconds: Integer.milliseconds),
      highlightAnimationBeginColor: ColorData.primaryTextColor,
      highlightAnimationEndColor: ColorData.whiteColor,
      keyboardType: TextInputType.number,
      mobileNumber: passingDescriptionToMobileNo(),
      countrycode: passingDescriptionToCountryCode(),
    );
  }

  String passingDescriptionToMobileNo() {
    if (Constants.isChangePassword &&
        widget.dialcode == Constants.UAE_COUNTRY_CODE) {
      return widget.mobileNumber;
    } else if (Constants.isChangePassword &&
        widget.dialcode != Constants.UAE_COUNTRY_CODE) {
      return tr("registered_email");
    } else if (!Constants.isChangePassword &&
        widget.dialcode == Constants.UAE_COUNTRY_CODE) {
      return widget.mobileNumber;
    } else if (!Constants.isChangePassword &&
        widget.dialcode != Constants.UAE_COUNTRY_CODE) {
      return widget.email;
    }
    return widget.mobileNumber;
  }

  String passingDescriptionToCountryCode() {
    if (Constants.isChangePassword &&
        widget.dialcode == Constants.UAE_COUNTRY_CODE) {
      return widget.dialcode;
    } else if (Constants.isChangePassword &&
        widget.dialcode != Constants.UAE_COUNTRY_CODE) {
      return Strings.txtMT;
    } else if (!Constants.isChangePassword &&
        widget.dialcode == Constants.UAE_COUNTRY_CODE) {
      return widget.dialcode;
    } else if (!Constants.isChangePassword &&
        widget.dialcode != Constants.UAE_COUNTRY_CODE) {
      return Strings.txtMT;
    }
    return widget.dialcode;
  }

  _validateOTP() {
    if (_otpController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('oTPMTError'), context);
      return false;
    } else if (_otpController.text.length < 4) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('oTPInvalid'), context);
      return false;
    }
    return true;
  }

  continueBtnPres() {
    BlocProvider.of<OtpBloc>(context).add(
      OtpVerificationPressed(
          userId: widget.userId,
          otp: _otpController.text,
          isCorporate: widget.isCorporate),
    );
  }

  resendOTP() {
    BlocProvider.of<OtpBloc>(context).add(
      ResendOtpPressed(
          userId: widget.userId,
          otpTypeId: Constants.isChangePassword
              ? Constants.ChangePassword
              : Constants.ResendOTP),
    );
  }
}
