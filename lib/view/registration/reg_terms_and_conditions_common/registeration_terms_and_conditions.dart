import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefields.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/hear_about_us_detail.dart';
import 'package:slc/model/reg_user_info.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/iconsfile.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/login/login_page.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/bloc/reg_terms_and_conditions_bloc.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/bloc/reg_terms_and_conditions_event.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_code.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_aboutus_picker/custom_aboutus_code_picker.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_success_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/reg_terms_and_conditions_state.dart';

class RegistrationTermsAndCondition extends StatelessWidget {
  final UserInfo userInfo;

  RegistrationTermsAndCondition(this.userInfo);

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      return (await customAlertDialog(
              context,
              tr("discard_message"),
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
      child: BlocProvider<RegisterTermsAndConditionsBloc>(
        create: (context) {
          return RegisterTermsAndConditionsBloc(null);
        },
        child: RegistrationTnc(this.userInfo),
      ),
      // ),
    );
  }
}

class RegistrationTnc extends StatefulWidget {
  final String title = "TC";
  final UserInfo userInfo;

  RegistrationTnc(this.userInfo);

  @override
  _RegistrationTncState createState() => _RegistrationTncState();
}

bool isLoading;

class _RegistrationTncState extends State<RegistrationTnc> {
  List<HearAboutUsDetail> hearAboutUsList = [];
  HearAboutResponse selectedValue;
  bool isSwitched = false;
  DateTime datePickerDateFrom;

  DateTime date;
  bool _isNotificationChecked = false;
  bool _isNotificationCheckedAr = false;
  bool isTermsChecked = false;
  ProgressBarHandler _handler;
  DialogHandler _handlerDialog;
  Utils util = Utils();
  bool isPhoneNoWidgetEnabled = false;
  bool isSuccessListenerEnabled = false;
  TextEditingController _mobileNoController;
  String countryCodeForMobile = "+971";
  int selectedCountryId = Constants.UAECountryId;
  TextEditingController hearAboutUsController = TextEditingController();
  Key key;
  int number = Random().nextInt(1000000000);

  @override
  void initState() {
    super.initState();
    BlocProvider.of<RegisterTermsAndConditionsBloc>(context).add(
      FetchHearAboutUsListEvent(),
    );
    isLoading = true;
    _mobileNoController = TextEditingController();
  }

  @override
  void dispose() {
    _mobileNoController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    key = PageStorageKey(number.toString());
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
      content: tr("reg_success_message"),
      title: tr("reg_success_title"),
      positiveCallBack: () {
        SPUtil.remove(Constants.REG_USER_EMAIL);
        SPUtil.remove(Constants.REG_USER_MOBILE);
        Get.offAll(LoginPage(userRepository: UserRepository()));
      },
    );

    return BlocListener<RegisterTermsAndConditionsBloc,
        RegisterTermsAndConditionsState>(
      listener: (context, state) {
        if (state is ShowRegisterTermsAndConditionsProgressBarState) {
          _handler.show();
        } else if (state is HideRegisterTermsAndConditionsProgressBarState) {
          _handler.dismiss();
        } else if (state is RegisterTermsAndConditionsOnSuccess) {
          _handlerDialog.show();
        }
      },
      child: BlocBuilder<RegisterTermsAndConditionsBloc,
          RegisterTermsAndConditionsState>(
        builder: (BuildContext context, state) {
          if (state is RegisterTermsAndConditionsOnFailure) {
            return failureUI(state.error);
          } else if (state is HearAboutUsListSuccessListener) {
            this.hearAboutUsList = state.hearAboutUsList;
          }

          return Stack(children: <Widget>[
            getTermsAndConditions(this.hearAboutUsList, context),
            progressBar,
            dialogHolder
          ]);
        },
      ),
    );
  }

  Widget getTermsAndConditions(
      List<HearAboutUsDetail> hearAboutList, BuildContext context) {
    return GestureDetector(
      // key: registerationtnc,
      child: Scaffold(
        // resizeToAvoidBottomPadding: false,
        // key: key,
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: widget.title,
                headerTitle: tr('welcome'),
                subTitle: tr('registerToContinue'),
                assetImagePath: 'assets/images/Register_2.png',
                onLanguageChange: (val) {
                  BlocProvider.of<RegisterTermsAndConditionsBloc>(context).add(
                    FetchHearAboutUsListLanguageEvent(context: context),
                  );
                },
              ),
            ],
          ),
          preferredSize: Size.fromHeight(208.0),
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
                  child: FormBuilder(
                    child: new Column(
                      children: <Widget>[
                        Container(
                          //  key: key,
                          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                          child: NationalityCodePicker(
                              isEditBtnEnabled: Strings.ProfileCallState,
                              nationalityController: hearAboutUsController,
                              onChanged: (hearAboutUs) => {
                                    setState(() {
                                      this.isPhoneNoWidgetEnabled =
                                          hearAboutUs.isMobileNumberRequired;
                                      if (this.isPhoneNoWidgetEnabled) {
                                        _mobileNoController =
                                            TextEditingController();
                                      }
                                      selectedValue = hearAboutUs;
                                    }),
                                  },
                              initialSelection: "",
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              searchStyle:
                                  PackageListHead.textFieldStyleWithoutArab(
                                      context, false),
                              textStyle: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamily"),
                              ),
                              alignLeft: false),
                        ),
                        (mounted)
                            ? Visibility(
                                key: PageStorageKey<int>(3),
                                visible: isPhoneNoWidgetEnabled,
                                child: Container(
                                  padding:
                                      EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                                  child: LoginPageFields(
                                      this._mobileNoController,
                                      tr('mobileNumber'),
                                      countryCodeForMobile,
                                      IconsFile.leadIconForMobile,
                                      TextInputTypeFile.textInputTypeMobile,
                                      TextInputAction.done,
                                      (_selectedCountry) => {
                                            selectedCountryId =
                                                _selectedCountry.countryId
                                          },
                                      () => {}),
                                ),
                              )
                            : Container(),
                        termsAndCondition(),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: LoginRegSubmitButton("regBtn", () {
                              if (_validateLogin(context)) {
                                registrationButtonPress(context);
                              }
                            }),
                          ),
                        ),
                        LoginRegFooter(widget.title, "Home"),
                      ],
                    ),
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

  Widget termsAndCondition() {
    return Expanded(
      flex: 3,
      child: Column(
        children: <Widget>[
          GestureDetector(
            child: Container(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(
                      left: 10,
                      right: 7,
                    )
                  : EdgeInsets.only(right: 10, left: 5),
              child: ListTile(
                leading: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    key: PageStorageKey<int>(1),
                    value: _isNotificationChecked,
                    onChanged: (bool value) {
                      setState(() {
                        _isNotificationChecked = value;
                        if (value) {
                          _isNotificationCheckedAr = false;
                        }
                      });
                    }),
                title: Container(
                    child: PackageListHead.textWithStyleMediumFont(
                        context: context,
                        contentTitle:
                            tr("txt_terms_and_condition_notification"),
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSizeSmall)),
              ),
            ),
            onTap: () {
              setState(() {
                _isNotificationChecked = !_isNotificationChecked;
              });
            },
          ),
          GestureDetector(
            child: Container(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(
                      left: 10,
                      right: 7,
                    )
                  : EdgeInsets.only(right: 10, left: 5),
              child: ListTile(
                leading: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    key: PageStorageKey<int>(3),
                    value: _isNotificationCheckedAr,
                    onChanged: (bool value) {
                      setState(() {
                        _isNotificationCheckedAr = value;
                        if (value) {
                          _isNotificationChecked = false;
                        }
                      });
                    }),
                title: Container(
                    child: PackageListHead.textWithStyleMediumFont(
                        context: context,
                        contentTitle:
                            tr("txt_terms_and_condition_notification_ar"),
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSizeSmall)),
              ),
            ),
            onTap: () {
              setState(() {
                _isNotificationCheckedAr = !_isNotificationCheckedAr;
              });
            },
          ),
          GestureDetector(
            child: Container(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 10, right: 7)
                  : EdgeInsets.only(right: 10, left: 5),
              child: ListTile(
                leading: Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    key: PageStorageKey<int>(2),
                    value: isTermsChecked,
                    onChanged: (bool value) {
                      displayDialog();
                    }),
                title: Container(
                    child: PackageListHead.textWithStyleMediumFont(
                        context: context,
                        contentTitle: tr("txt_terms_and_condition_agree"),
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSizeSmall)),
              ),
            ),
            onTap: () {
              displayDialog();
            },
          ),
        ],
      ),
    );
  }

  _validateLogin(BuildContext context) {
    RegExp regExp = new RegExp(
      Constants.UAE_MOBILE_PATTERN,
      caseSensitive: false,
      multiLine: false,
    );

    if (isPhoneNoWidgetEnabled && _mobileNoController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('mobileNoErrorMessage'), context);
      return false;
    } else if (isPhoneNoWidgetEnabled &&
        _mobileNoController.text.length != Constants.UAEMobileNumberLength &&
        selectedCountryId == Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if ((isPhoneNoWidgetEnabled &&
                _mobileNoController.text.length <
                    Constants.OtherMinMobileNumberLength ||
            _mobileNoController.text.length >
                Constants.OtherMaxMobileNumberLength) &&
        selectedCountryId != Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (isPhoneNoWidgetEnabled &&
        selectedCountryId == Constants.UAECountryId &&
        !regExp.hasMatch(_mobileNoController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (!isTermsChecked) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('error_terms_and_condition'), context);
      return false;
    }
    return true;
  }

  success() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  registrationButtonPress(BuildContext context) {
    widget.userInfo.isDoNotDisturb = _isNotificationChecked;
    widget.userInfo.isDoNotDisturbAr = _isNotificationCheckedAr;
    if (selectedValue == null) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('error_hearabout'), context);
      return false;
    }
    if (selectedValue != null) {
      if (isPhoneNoWidgetEnabled) {
        widget.userInfo.marketingSourceId = selectedValue.marketingSourceId;
        widget.userInfo.referredByMobileNumber =
            _mobileNoController.text.toString();
      } else {
        widget.userInfo.marketingSourceId = selectedValue.marketingSourceId;
        widget.userInfo.referredByMobileNumber = "";
      }
    } else {
      widget.userInfo.marketingSourceId = 0;
      widget.userInfo.referredByMobileNumber = "";
    }

    BlocProvider.of<RegisterTermsAndConditionsBloc>(context).add(
      RegistrationSaveEvent(userInfo: widget.userInfo),
    );
  }

  Widget failureUI(String error) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image(
              image: AssetImage(ImageData.error_img),
            ),
            const SizedBox(height: 30),
            Text(
              error,
              style: Styles.failureUIStyle,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ColorData.accentColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  )))),
              // color: ColorData.accentColor,
              onPressed: () {
                BlocProvider.of<RegisterTermsAndConditionsBloc>(context).add(
                  FetchHearAboutUsListEvent(),
                );
              },
              child: Text(
                tr("retry"),
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> displayDialog() async {
    double dialogHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.height / 4);
    ProgressBarHandler _handler1;
    var progressBar1 = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler1 = handler;
        handler.show();
        return;
      },
    );

    return showDialog<Widget>(
      context: context,
//      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Stack(
          children: <Widget>[
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: dialogHeight - 40.0,
                    child: Center(
                      child: WebView(
                        initialUrl: URLUtils().getTermsAndConditionURL(),
                        javascriptMode: JavascriptMode.unrestricted,
                        onPageFinished: (val) => {
                          _handler1.dismiss(),
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: 43.0,
                          child: new ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorData.grey300),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                )))),
                            // shape: new RoundedRectangleBorder(
                            //     borderRadius: new BorderRadius.circular(5.0),
                            //     side: BorderSide(color: ColorData.grey300)),
                            // color: ColorData.grey300,
//                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0,),
                            child: new Text(
                              tr("disAgree"),
                              style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamily"),
                              ),
                            ),
                            onPressed: () {
                              isTermsChecked = false;
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 3.5,
                          height: 43.0,
                          child: new ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorData.accentColor),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                )))),
                            // color: ColorData.accentColor,
                            // shape: new RoundedRectangleBorder(
                            //     borderRadius: new BorderRadius.circular(5.0),
                            //     side: BorderSide(color: ColorData.accentColor)),
//                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                            child: new Text(
                              tr("agree"),
                              style: TextStyle(
                                  color: ColorData.whiteColor,
                                  fontFamily: tr("currFontFamily")),
                            ),
                            onPressed: () {
                              isTermsChecked = true;
                              setState(() {});
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            progressBar1
          ],
        );
      },
    );
  }

//  displayDialog(BuildContext context) async {
//    double dialogWidth = MediaQuery.of(context).size.width -
//        (MediaQuery.of(context).size.width / 5);
//    double dialogHeight = MediaQuery.of(context).size.height -
//        (MediaQuery.of(context).size.height / 4);
//
//    double btnWidth = dialogWidth * (40 / 100);
//    double betweenWidth = dialogWidth * (5 / 100);
//
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            content: Container(
////              width: MediaQuery.of(context).size.width,
//              height: dialogHeight,
//              child: WebView(
//                initialUrl: URLUtils().getTermsAndConditionURL(),
//                javascriptMode: JavascriptMode.unrestricted,
//              ),
//            ),
//            actions: <Widget>[
//              Container(
//                alignment: Alignment.center,
//                margin: EdgeInsets.only(bottom: 15.0),
//                child: Row(
//                  mainAxisSize: MainAxisSize.max,
//
//                  children: <Widget>[
//                    Container(
//                      width: btnWidth,
//                      child: new RaisedButton(
//                        shape: new RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(8.0),
//                            side: BorderSide(color: ColorData.grey300)),
//                        color: ColorData.grey300,
//                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                        child: new Text(
//                          tr("disAgree"),
//                          style: TextStyle(
//                            color: ColorData.primaryTextColor,
//                            fontFamily:
//                                .tr("currFontFamily"),
//                          ),
//                        ),
//                        onPressed: () {
//                          isTermsChecked = false;
//                          setState(() {});
//                          Navigator.of(context).pop();
//                        },
//                      ),
//                    ),
//                    SizedBox(
//                      width: betweenWidth,
//                    ),
//                    Container(
//                      width: btnWidth,
//                      child: new RaisedButton(
//                        color: ColorData.accentColor,
//                        shape: new RoundedRectangleBorder(
//                            borderRadius: new BorderRadius.circular(8.0),
//                            side: BorderSide(color: ColorData.accentColor)),
//                        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
//                        child: new Text(
//                          tr("agree"),
//                          style: TextStyle(
//                              color: ColorData.whiteColor,
//                              fontFamily:
//                                  .tr("currFontFamily")),
//                        ),
//                        onPressed: () {
//                          isTermsChecked = true;
//                          setState(() {});
//                          Navigator.of(context).pop();
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              )
//            ],
//          );
//        });
//  }
}
