import 'dart:convert';
import 'dart:math';
import 'dart:ui' as prefix;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_gender_select_component.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code_picker.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/custom_dob_component.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_footer/loginreg_footer.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginreg_submitbtn/loginreg_submitbtn.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginregappbar/login_reg_appbar.dart';
import 'package:slc/db/databas_helper.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/reg_user_info.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/fonts.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/pin_code_text_field.dart';
import 'package:slc/view/registration/page_two/bloc/base_info_two_event.dart';
import 'package:slc/view/registration/page_two/bloc/base_info_two_state.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/registeration_terms_and_conditions.dart';

import 'bloc/base_info_two_bloc.dart';

class BaseInfoTwo extends StatelessWidget {
  final String otpResponse;

  BaseInfoTwo(this.otpResponse);

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
                    Navigator.of(context).pop(),
                  })) ??
          false;
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: BlocProvider(
        create: (context) {
          return BaseInfoTwoBloc(null);
        },
        child: PageTwo(otpResponse),
      ),
    );
  }
}

class PageTwo extends StatefulWidget {
  final String otpResponse;

  PageTwo(this.otpResponse);

  @override
  _PageTwo createState() => _PageTwo();
}

class _PageTwo extends State<PageTwo> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Utils util = new Utils();
  MaskedTextController _fNameController =
      MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController _lNameController =
      MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  TextEditingController _passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  GlobalKey<FormBuilderState> basicinfotwoformkey =
      GlobalKey<FormBuilderState>();

  String selectedDOB;
  String todayDate = SlcDateUtils().getTodayDateDefaultFormat();
  var userDetails;

  List<NationalityResponse> nationDDList = [];
  List<GenderResponse> genderDDList = [];
  double genderElevationPoint = 0.0;

  ProgressBarHandler _handler;
  GenderResponse selectedGender = GenderResponse();
  NationalityResponse selectedNationality = NationalityResponse();
  Key key;
  int number = Random().nextInt(1000000000);

  void initState() {
    super.initState();
    setState(() {
      Constants.INIT_DATETIME = DateTime.parse(
          SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
      userDetails = jsonDecode(widget.otpResponse)["response"];

      _fNameController.updateText(
          userDetails == null || userDetails["firstName"] == null
              ? ""
              : userDetails["firstName"]);
      _lNameController.updateText(
          userDetails == null || userDetails["lastName"] == null
              ? ""
              : userDetails["lastName"]);

      if (userDetails == null ||
          userDetails["dateOfBirth"] == null ||
          userDetails["dateOfBirth"] == "") {
        selectedDOB = null;
      } else {
        Constants.INIT_DATETIME = DateTime.parse(userDetails["dateOfBirth"]);
        selectedDOB = DateTimeUtils().dateToServerToDateFormat(
            userDetails["dateOfBirth"],
            DateTimeUtils.ServerFormat,
            DateTimeUtils.DD_MM_YYYY_Format);
      }

      BlocProvider.of<BaseInfoTwoBloc>(context).add(
        OnLanguagechangeInRegTwo(context: context),
      );
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
    return BlocListener<BaseInfoTwoBloc, BaseInfoTwoState>(
      listener: (BuildContext context, state) async {
        if (state is OnSuccess) {
        } else if (state is OnFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is LanguageSwitched) {
          if (userDetails["genderId"] != null) await getGenderDB();
        }
      },
      child: BlocBuilder<BaseInfoTwoBloc, BaseInfoTwoState>(
        builder: (BuildContext context, state) {
          return Stack(children: <Widget>[mainUI(), progressBar]);
        },
      ),
    );
  }

  Widget mainUI() {
    return GestureDetector(
      child: Scaffold(
        appBar: PreferredSize(
          child: Column(
            children: <Widget>[
              LoginRegAppBar(
                pageTitle: "BaseInfoTwo",
                headerTitle: tr('welcome'),
                subTitle: tr('registerToContinue'),
                assetImagePath: 'assets/images/Register_1.png',
                onLanguageChange: (val) {
                  BlocProvider.of<BaseInfoTwoBloc>(context).add(
                    OnLanguagechangeInRegTwo(context: context),
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
                child: Column(
              children: <Widget>[
                getFormFields(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: LoginRegSubmitButton("continue", () {
                    if (validateForm()) {
                      registerBtnClicked();
                    }
                  }),
                ),
                LoginRegFooter('register', "tc"),
              ],
            ));
          },
        ),
      ),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
    );
  }

  getFormFields() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: LoginPageFieldWhite(
                _fNameController,
                tr("firstNameLabel"),
                Strings.countryCodeForNonMobileField,
                CommonIcons.woman,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
                isWhite: true),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: LoginPageFieldWhite(
                _lNameController,
                tr("lastNameLabel"),
                Strings.countryCodeForNonMobileField,
                CommonIcons.woman,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
                isWhite: true),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: CustomGenderComponent(
                isEditBtnEnabled: Strings.ProfileCallState,
                genderController: genderController,
                selectedFunction: (GenderResponse val) => {
                      selectedGender.genderId = val.genderId,
                      selectedGender.genderName = val.genderName,
                      genderController.text = val.genderName,
                    }),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: CustomDOBComponent(
              isEditBtnEnabled: Strings.ProfileCallState,
              selectedFunction: (val) => {
                selectedDOB = val,
              },
              dobController: dobController,
              isAddPeople: false,
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
            child: NationalityCodePicker(
                isEditBtnEnabled: Strings.ProfileCallState,
                nationalityController: nationalityController,
                onChanged: (nationality) => {
                      selectedNationality.nationalityId =
                          nationality.nationalityId,
                      selectedNationality.nationalityName =
                          nationality.nationalityName,
                    },
                initialSelection: "",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                searchStyle: TextStyle(
                  color: ColorData.primaryTextColor,
                  fontFamily: tr("currFontFamily"),
                ),
                textStyle: TextStyle(
                  color: ColorData.primaryTextColor,
                  fontFamily: tr("currFontFamily"),
                ),
                alignLeft: false),
          ),
          PinCodeTextField(
            textDirection: Localizations.localeOf(context).languageCode == "en"
                ? prefix.TextDirection.ltr
                : prefix.TextDirection.rtl,
            autofocus: false,
            controller: _passwordController,
            hideCharacter: true,
            highlight: true,
            defaultBorderColor: ColorData.eventHomePageDeSelectedCircularFill,
            maxLength: 4,
            pinBoxWidth: 55.0,
            pinBoxHeight: 50.0,
            maskCharacter: Strings.maskText,
            onDone: (text) {
              print("DONE $text");
              print("DONE CONTROLLER ${_passwordController.text}");
            },
            wrapAlignment: WrapAlignment.spaceAround,
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
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
          )
        ],
      ),
    );
  }

  bool validateForm() {
    if (_fNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('fNameErrorMessage'), context);
      return false;
    } else if (_lNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('lNameErrorMessage'), context);
      return false;
    } else if (selectedGender.genderId == null ||
        selectedGender.genderId == 0 ||
        genderController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('genderErrorMessage'), context);
      return false;
    } else if (selectedDOB == null || selectedDOB.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('dobErrorMessage'), context);
      return false;
    } else if (nationalityController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('nationalityErrorMessage'), context);
      return false;
    } else if (_passwordController.text.isEmpty) {
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

  void registerBtnClicked() {
    UserInfo userInfo = UserInfo();
    userInfo.firstName = _fNameController.text.toString();
    userInfo.lastName = _lNameController.text.toString();
    userInfo.genderId = selectedGender.genderId;
    userInfo.userId = userDetails["userId"];
    userInfo.dateOfBirth = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(
            selectedDOB.toString(), DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    userInfo.nationalityId = selectedNationality.nationalityId;
    userInfo.password = _passwordController.text.toString();

    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => RegistrationTermsAndCondition(userInfo)));
  }

  Future<Widget> getGenderDDList(List<GenderResponse> list) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width,
              height: list.length * 35.0,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int i) {
                  return new InkWell(
                    onTap: () {
                      onSelection1(list[i]);
                    },
                    child: Text(
                      list[i].genderName,
                      style: Styles.failureUIStyle,
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  onSelection1(val) {
    print(val);
  }

  Future getGenderDB() async {
    var db = new DatabaseHelper();

    var genderDetailsList = await db.getContentByCID(TableDetails.CID_GENDER);
    if (Localizations.localeOf(context).languageCode == "en") {
      var engContent =
          jsonDecode(jsonDecode(genderDetailsList.englishContent)["statusMsg"])[
              "response"];
      for (var i = 0; i < engContent.length; i++) {
        // .forEach((f) => {
        var f = engContent[i];
        if (genderController.text.isEmpty) {
          if (f["genderId"] == userDetails["genderId"]) {
            selectedGender.genderId = f["genderId"];
            selectedGender.genderName = f["genderName"];
            genderController.text = selectedGender.genderName;
            break;
          }
        } else if (genderController.text.isNotEmpty) {
          if (f["genderId"] == selectedGender.genderId) {
            selectedGender.genderId = f["genderId"];
            selectedGender.genderName = f["genderName"];
            genderController.text = selectedGender.genderName;
            break;
          }
        }
      }
      //  genderResponse.add(new GenderResponse.fromJson(f))
      // });

    } else if (Localizations.localeOf(context).languageCode == "ar") {
      var arbContent = jsonDecode(
          jsonDecode(genderDetailsList.arabicContent)["statusMsg"])["response"];

      for (var i = 0; i < arbContent.length; i++) {
        // .forEach((f) => {
        var f = arbContent[i];
        if (genderController.text.isEmpty) {
          if (f["genderId"] == userDetails["genderId"]) {
            selectedGender.genderId = f["genderId"];
            selectedGender.genderName = f["genderName"];
            genderController.text = selectedGender.genderName;
            break;
          }
        } else if (genderController.text.isNotEmpty) {
          if (f["genderId"] == selectedGender.genderId) {
            selectedGender.genderId = f["genderId"];
            selectedGender.genderName = f["genderName"];
            genderController.text = selectedGender.genderName;
            break;
          }
        }
      }
    }
    if (userDetails["nationalityId"] != null) await getNationalityDB();
    // return genderResponse;
    setState(() {});
  }

  Future getNationalityDB() async {
    var db = new DatabaseHelper();
    var nationalityDetailsList =
        await db.getContentByCID(TableDetails.CID_NATIONALITY);
    if (Localizations.localeOf(context).languageCode == "en") {
      var engContentNat = jsonDecode(jsonDecode(
          nationalityDetailsList.englishContent)["statusMsg"])["response"];

      for (var i = 0; i < engContentNat.length; i++) {
        // .forEach((f) => {
        var f = engContentNat[i];
        if (nationalityController.text.isEmpty) {
          if (f["nationalityId"] == userDetails["nationalityId"]) {
            selectedNationality.nationalityId = f["nationalityId"];
            selectedNationality.nationalityName = f["nationalityName"];
            nationalityController.text = selectedNationality.nationalityName;
            break;
          }
        } else if (nationalityController.text.isNotEmpty) {
          if (f["nationalityId"] == selectedNationality.nationalityId) {
            selectedNationality.nationalityId = f["nationalityId"];
            selectedNationality.nationalityName = f["nationalityName"];
            nationalityController.text = selectedNationality.nationalityName;
            break;
          }
        }
      }
    } else if (Localizations.localeOf(context).languageCode == "ar") {
      var arbContentNat = jsonDecode(jsonDecode(
          nationalityDetailsList.arabicContent)["statusMsg"])["response"];

      for (var i = 0; i < arbContentNat.length; i++) {
        // .forEach((f) => {
        var f = arbContentNat[i];
        if (nationalityController.text.isEmpty) {
          if (f["nationalityId"] == userDetails["nationalityId"]) {
            selectedNationality.nationalityId = f["nationalityId"];
            selectedNationality.nationalityName = f["nationalityName"];
            nationalityController.text = selectedNationality.nationalityName;
            break;
          }
        } else if (nationalityController.text.isNotEmpty) {
          if (f["nationalityId"] == selectedNationality.nationalityId) {
            selectedNationality.nationalityId = f["nationalityId"];
            selectedNationality.nationalityName = f["nationalityName"];
            nationalityController.text = selectedNationality.nationalityName;
            break;
          }
        }
      }
    }
    // return nationalityResponse;
  }
}
