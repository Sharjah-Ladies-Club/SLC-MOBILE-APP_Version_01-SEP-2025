import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpage_fields_to_onepage/loginpagerender_login.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer_login.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn_login.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/imgutils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/dashboard/dashboard.dart';
import 'package:slc/view/otp/otp_verification.dart';
import 'package:slc/view/registration/page_one/base_info_one.dart';
import 'package:get/get.dart';

import 'bloc/bloc.dart';

class LoginForm extends StatefulWidget {
  LoginForm();

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  RegExp regExp = new RegExp(
    Constants.UAE_MOBILE_PATTERN,
    caseSensitive: false,
    multiLine: false,
  );
  Utils util = Utils();
  ProgressBarHandler _handler;
  TextEditingController _mobilenoController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int _selectedCountryId = Constants.UAECountryId;

  _LoginFormState();

  @override
  void initState() {
    //this is to reset the event chiose chip selection
    Constants.eventsCurrentSelectedChoiseChip = 0;
    //this is to reset the notification preferences
//    Constants.isNotFromNotificationFamily = true;
//    Constants.isFromNotificationFamily = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OnSuccess) {
          print(
              'user id  2-----> ${SPUtil.getInt(Constants.USERID, defValue: 0)}');
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => Dashboard(
                        selectedIndex: 0,
                      )));
        } else if (state is OnSuccessRegister) {
          if (state.userId != null) {
            _selectedCountryId == Constants.UAECountryId
                ? util.customGetSnackBarWithOutActionButton(
                    tr('success_caps'), tr('uae_otp'), context)
                : util.customGetSnackBarWithOutActionButton(
                    tr('success_caps'), tr('non_uae_otp'), context);
            Get.to(() => OtpVerification(
                  SPUtil.getString(Constants.USER_MOBILE),
                  state.userId,
                  SPUtil.getString(Constants.USER_COUNTRYDIALCODE),
                  SPUtil.getString(Constants.USER_EMAIL),
                  isCorporate: true,
                ));
            // Get.to(BaseInfoTwo(""));
          }
        } else if (state is OnSuccessWithResetPassword) {
          BlocProvider.of<LoginBloc>(context).add(
            PageOneContinueButtonPressed(
                mobileNumber: SPUtil.getString(Constants.USER_MOBILE),
                email: SPUtil.getString(Constants.USER_EMAIL),
                countryId: SPUtil.getInt(Constants.USER_COUNTRYID),
                countrycode: SPUtil.getString(Constants.USER_COUNTRYDIALCODE),
                pagePath: "registerFlow"),
          );
        } else if (state is OnFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Stack(children: <Widget>[mainUI(context), progressBar]);
        },
      ),
    );
  }

  bool _validateLogin() {
    // _mobilenoController.text = '9940671896';
    // _selectedCountryId = 165;
    // _passwordController.text = '1234';
    if (_mobilenoController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("mobileNoErrorMessage"), context);
      return false;
    } else if (_mobilenoController.text.length !=
            Constants.UAEMobileNumberLength &&
        _selectedCountryId == Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("invalidMobileNumber"), context);
      return false;
    } else if ((_mobilenoController.text.length <
                Constants.OtherMinMobileNumberLength ||
            _mobilenoController.text.length >
                Constants.OtherMaxMobileNumberLength) &&
        _selectedCountryId != Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("invalidMobileNumber"), context);
      return false;
    } else if (_selectedCountryId == Constants.UAECountryId &&
        !regExp.hasMatch(_mobilenoController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("invalidMobileNumber"), context);
      return false;
    } else if (_passwordController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("passwordErrorMessage"), context);
      return false;
    } else if (_passwordController.text.length < 4) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("passwordInvlidLength"), context);
      return false;
    }

    return true;
  }

  Widget mainUI(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: "Login",
                headerTitle: tr('welcomeBack'),
                subTitle: tr('SignInToContinue'),
                assetImagePath: 'assets/images/UnionFace.png',
                onLanguageChange: (val) {
                  BlocProvider.of<LoginBloc>(context).add(
                    OnLanguagechange(context: context),
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
                      LoginPageImage("login"),
                      LoginPageRender(_mobilenoController, _passwordController,
                          (countryId) {
                        setState(() {
                          _selectedCountryId = countryId;
                        });
                      }),

                      // Flexible(
                      // fit: FlexFit.tight,
                      //  child:
                      Padding(
                          padding: EdgeInsets.only(top: 14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                margin: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(left: 20.0)
                                    : EdgeInsets.only(right: 20.0),
                                child: GestureDetector(
                                  onTap: () {
                                    _onRegisterChangePasswordPressed();
                                  },
                                  child: PackageListHead.customTextView(context,
                                      1.0, tr('changePassword'), true, null),
                                ),
                              ),
                              LoginRegSubmitButton("login", () {
                                if (_validateLogin()) {
                                  loginBtnPres();
                                }
                              }),
                            ],
                          )),
                      // ),

                      LoginRegFooter(
                        'Login',
                        'Home',
                      ),
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

  loginBtnPres() async {
    if (await GMUtils().isInternetConnected()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginButtonPressed(
          username: _mobilenoController.text.toString(),
          password: _passwordController.text.toString(),
          countryId: _selectedCountryId,
          applicationId: Platform.isAndroid ? Constants.Android : Constants.iOS,
        ),
      );
    } else {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("txt_no_network_connection"), context);
    }
  }

  _onRegisterChangePasswordPressed() {
    Constants.isChangePassword = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BaseInfoOne();
        },
      ),
    );
  }
}
