import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpage_fields_to_onepage/loginpagerender.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/imgutils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/dashboard/dashboard.dart';

import 'bloc/bloc.dart';

class LoginForm extends StatefulWidget {
  // final FirebaseAnalytics analytics;
  // final FirebaseAnalyticsObserver observer;

  LoginForm(// this.analytics, this.observer
      );

  @override
  State<LoginForm> createState() => _LoginFormState(
      // analytics, observer
      );
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

  _LoginFormState(// this.analytics, this.observer
      );

  @override
  Widget build(BuildContext context) {
    // var data = EasyLocalizationProvider.of(context).data;

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OnSuccess) {
          Navigator.pushReplacement(
              context,
              new MaterialPageRoute(
                  builder: (context) => Dashboard(
                        selectedIndex: 0,
                      )));
        } else if (state is OnFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'),
              (state.error),
              context); // snakBarMsg(state.error, ColorData.colorRed, context);
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        // ignore: missing_return
        builder: (context, state) {
          return Stack(children: <Widget>[mainUI(context), progressBar]);
//          return mainUI(state);
          // if (state is InitialLoginState) {
          //   mainUI();
          // }
        },
      ),
    );
  }

  _validateLogin() {
    // RegExp exp = new RegExp(r"^(?:\\+971|00971|0)?(?:50|51|52|55|56|54|58)\\d{7}\$");

    // Iterable<RegExpMatch> matches = exp.allMatches(_mobilenoController.text);

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
        resizeToAvoidBottomInset: false,
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
              // CustomSwitchField((onLngSwitchVal) {
              //   onLangchange(context);
              // }),
            ],
          ),
          preferredSize: Size.fromHeight(210.0),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              //            shrinkWrap: true,
              //            itemCount: 1,
              //            itemBuilder: (context, index) {
              child:
                  //              return
                  ConstrainedBox(
                constraints: constraints.copyWith(
                  minHeight: constraints.maxHeight,
                  maxHeight: double.infinity,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      //  Column(
                      //   children: <Widget>[
                      LoginPageImage("login"),
                      LoginPageRender(_mobilenoController, _passwordController,
                          (countryId) {
                        // loginBtnPres(countryId);
                        setState(() {
                          _selectedCountryId = countryId;
                        });
                      }),
                      //   ],
                      // ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: LoginRegSubmitButton("login", () {
                            if (_validateLogin()) {
                              loginBtnPres();
                            }
                          }),
                        ),
                      ),
                      // Flexible(
                      //  fit: FlexFit.loose,
                      //                       child: Align(alignment: Alignment.bottomCenter,

                      //    child: Loginreg_Text_Span('Login','Home', ()=>{
                      //           //this.callBackOnTap(),
                      //         }),
                      //    ),
                      // ),
                      LoginRegFooter(
                        'Login',
                        'Home',
                      ),
                    ],
                  ),
                ),
              ),
              //              ;
              //    }
            );
          },
        ),
      ),
      onTap: () {
        //HideKeyboard
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
      // widget.loginJson =  {'username':  mob,
      //   'password': pass,
      //   'dialCode': countryId,
      //   'applicationId': Constants.Android};
      // print(countryId.toString() + mob.toString() + pass.toString());
    } else {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("txt_no_network_connection"), context);
    }
  }
}

// hideKeyBoard(context) {
//   FocusScope.of(context).requestFocus(new FocusNode());
// }

// snakBarMsg(msg, color, context) {
//   Scaffold.of(context).showSnackBar(
//     SnackBar(
//       backgroundColor: color,
//       content: Text(msg),
//     ),
//   );
// }

// }
