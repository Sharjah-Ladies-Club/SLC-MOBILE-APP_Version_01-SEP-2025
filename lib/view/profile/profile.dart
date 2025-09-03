import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/custom_gender_select_component.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code_picker.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/custom_dob_component.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefields.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/profile_otp_verification.dart';
import 'package:slc/view/profile/profile_new.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_success_dialog.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  String pageState;

  Profile(this.pageState);

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
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) =>
                                ProfileNew(Strings.ProfileInitialState))),
                  })) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return ProfileBloc(null);
          },
          child: _Profile(this.pageState),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Profile extends StatefulWidget {
  String pageState;

  _Profile(this.pageState);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<_Profile> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  MaskedTextController _fNameController =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _lNameController =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _emailController =
      new MaskedTextController(mask: Strings.maskEngEmailValidationStr);

  MaskedTextController _mobileController =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController nationalityController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController genderController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);

  MaskedTextController _customDobcontroller =
      new MaskedTextController(mask: Strings.maskDOBStr);

  TextEditingController bridgeUserType = TextEditingController();

  TextEditingController memberContractNumberCtrl = TextEditingController();

  TextEditingController memberNumberCtrl = TextEditingController();

  TextEditingController memberStartDateCtrl = TextEditingController();

  TextEditingController memberEndDateCtrl = TextEditingController();

  GlobalKey<FormBuilderState> _profileFormKey = GlobalKey<FormBuilderState>();

  String _ddInitialValue = Strings.txtDDInitialValue;

  //String _customHintStr = Strings.txtSltNationality;
  IconData editToSave = Icons.save;
  IconData saveToEdit = Icons.edit;

  //bool _isEditBtnEnabled = false;
  //bool _isSaveBtnClicked = false;
  GlobalKey<ScaffoldState> _profileScaffoldKey = new GlobalKey<ScaffoldState>();
  String nationalityId;

  Utils util = Utils();

  GenderResponse selectedGender;
  NationalityResponse selectedNationalityResponse;
  UserProfileInfo userProfileInfo = UserProfileInfo();
  List<GenderResponse> genderList = [];
  List<NationalityResponse> nationalityList = [];
  DialogHandler _handlerDialog;

  @override
  void dispose() {
    super.dispose();
    _fNameController.dispose();
    _lNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    nationalityController.dispose();
    genderController.dispose();
    _customDobcontroller.dispose();

    bridgeUserType.dispose();

    memberContractNumberCtrl.dispose();

    memberNumberCtrl.dispose();

    memberStartDateCtrl.dispose();

    memberEndDateCtrl.dispose();
  }

  @override
  void initState() {
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
    if (SPUtil.getInt(Constants.CURRENT_LANGUAGE) ==
        Constants.LANGUAGE_ARABIC) {
      nationalityController.updateMask(Strings.maskArbValidationStr);
      genderController.updateMask(Strings.maskArbValidationStr);
    } else {
      nationalityController.updateMask(Strings.maskEngValidationStr);
      genderController.updateMask(Strings.maskEngValidationStr);
    }

    Constants.INIT_DATETIME = DateTime.parse(
        SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
    if (widget.pageState == Strings.ProfileInitialState) {
      Constants.iSEditClickedInProfile = false;
    } else if (widget.pageState == Strings.ProfileCallState) {
      Constants.iSEditClickedInProfile = true;
    }
    setState(() {});
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GeneralList());
  }

  ProgressBarHandler _handler;

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
      title: tr("txt_success"),
      content: tr("txt_success_profile"),
      positiveCallBack: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return ProfileNew(Strings.ProfileInitialState);
            },
          ),
        );
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<ProfileBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<ProfileBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (BuildContext context, state) {
        if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is OnProfileSuccess) {
          _handlerDialog.show();
        } else if (state is OnProfileFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is OnSuccessOTPResend) {
          // ignore: unrelated_type_equality_checks
          nationalityId == Constants.UAECountryId
              ? util.customGetSnackBarWithOutActionButton(
                  tr('success_caps'), tr('uae_otp'), context)
              : util.customGetSnackBarWithOutActionButton(
                  tr('success_caps'), tr('non_uae_otp'), context);

          Get.to(OtpVerification(
              userProfileInfo.mobileNumber,
              userProfileInfo.userId,
              userProfileInfo.dialCode,
              userProfileInfo.email));
        } else if (state is OnFailureOTPResend) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is ErrorDialogState &&
            !SPUtil.getBool(Constants.PREVENT_MULTIPLE_DIALOG)) {
          SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, true);
          SPUtil.remove(Constants.USERID);
          getCustomAlertPositive(
            context,
            positive: () {
              SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, false);

              exit(0);
            },
            title: state.title,
            content: state.content,
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (BuildContext context, state) {
          if (state is FailureState) {
            return failureUI(state.error, context);
          } else if (state is OnGeneralListSuccess) {
            this.nationalityList = state.nationalityList;
            this.genderList = state.genderList;
            this.userProfileInfo = state.userProfileInfo;

            _fNameController.updateText(userProfileInfo.firstName);
            _lNameController.updateText(userProfileInfo.lastName);
            _emailController.updateText(userProfileInfo.email);
            _mobileController.updateText(userProfileInfo.dialCode != null
                ? userProfileInfo.dialCode + " " + userProfileInfo.mobileNumber
                : "" + userProfileInfo.mobileNumber);

            if (userProfileInfo.dateOfBirth != null &&
                userProfileInfo.dateOfBirth.length > 0) {
              Constants.INIT_DATETIME =
                  DateTime.parse(userProfileInfo.dateOfBirth);

              _customDobcontroller.updateText(DateTimeUtils()
                  .dateToServerToDateFormat(
                      userProfileInfo.dateOfBirth,
                      DateTimeUtils.ServerFormat,
                      DateTimeUtils.DD_MM_YYYY_Format));
            }

            if (userProfileInfo.genderId != null) {
              selectedGender = genderList.firstWhere((genderValue) =>
                  genderValue.genderId == userProfileInfo.genderId);
              genderController.updateText(selectedGender.genderName);
            }

            if (userProfileInfo.nationalityId != null) {
              selectedNationalityResponse = nationalityList.firstWhere(
                  (nationalityValue) =>
                      nationalityValue.nationalityId ==
                      userProfileInfo.nationalityId);
              nationalityController
                  .updateText(selectedNationalityResponse.nationalityName);
            }

            bridgeUserType.text = userProfileInfo.bridgeUserType != null
                ? userProfileInfo.bridgeUserType
                : "";

            if (userProfileInfo != null) {
              if (userProfileInfo.bridgeUserTypeId == 2) {
                memberNumberCtrl.text = userProfileInfo.membershipNumber != null
                    ? userProfileInfo.membershipNumber
                    : "";

                memberContractNumberCtrl.text =
                    userProfileInfo.membershipContractNumber != null
                        ? userProfileInfo.membershipContractNumber
                        : "";

                memberStartDateCtrl.text =
                    userProfileInfo.membershipStartDate != null
                        ? DateTimeUtils().dateToServerToDateFormat(
                            // userDetails["dateOfBirth"],
                            userProfileInfo.membershipStartDate,
                            DateTimeUtils.ServerFormat,
                            DateTimeUtils.DD_MM_YYYY_Format)
                        : "";

                memberEndDateCtrl.text =

                    // userProfileInfo.membershipEndDate;
                    userProfileInfo.membershipEndDate != null
                        ? DateTimeUtils().dateToServerToDateFormat(
                            // userDetails["dateOfBirth"],
                            userProfileInfo.membershipEndDate,
                            DateTimeUtils.ServerFormat,
                            DateTimeUtils.DD_MM_YYYY_Format)
                        : "";
              }
            }
          }

          return Stack(
              children: <Widget>[mainUI(context), progressBar, dialogHolder]);
        },
      ),
    );
  }

  bool show = false;

  Widget mainUI(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _profileScaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: CustomAppBar(
            title: tr("profile"),
            actionClicked: (bool isEditClicked) {
              if (isEditClicked) {
                BlocProvider.of<ProfileBloc>(context).add(
                  ResendOtpPressed(
                      userId: userProfileInfo.userId,
                      otpTypeId: Constants.MyProfileUpdate),
                );
              } else {
                updateClickEvent(isEditClicked);
              }
            },
            customDobcontroller: _customDobcontroller.text,
            ddInitialValue: _ddInitialValue,
            emailController: _emailController.text,
            fNameController: _fNameController.text,
            lNameController: _lNameController.text,
            profileFormKey: _profileFormKey,
            titleType: false,
          ),
        ),
        body: KeyboardAvoider(
          autoScroll: true,
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            child: FormBuilder(
              key: _profileFormKey,
              enabled: !Constants.iSEditClickedInProfile ? true : false,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: LoginPageFields(
                        _fNameController,
                        tr("firstNameLabel"),
                        Strings.countryCodeForNonMobileField,
                        CommonIcons.woman,
                        TextInputTypeFile.textInputTypeName,
                        TextInputAction.done,
                        () => {},
                        () => {}),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: LoginPageFields(
                        _lNameController,
                        tr("lastNameLabel"),
                        Strings.countryCodeForNonMobileField,
                        CommonIcons.woman,
                        TextInputTypeFile.textInputTypeName,
                        TextInputAction.done,
                        () => {},
                        () => {}),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: CustomDOBComponent(
                      isEditBtnEnabled: widget.pageState,
                      selectedFunction: (val) => {
                        _customDobcontroller.text = val,
                      },
                      dobController: _customDobcontroller,
                      isAddPeople: false,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: NationalityCodePicker(
                        isEditBtnEnabled: widget.pageState,
                        nationalityController: nationalityController,
                        onChanged: (nationality) =>
                            {selectedNationalityResponse = nationality},
                        initialSelection: selectedNationalityResponse != null
                            ? selectedNationalityResponse.nationalityName
                            : "",
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
                  Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: CustomGenderComponent(
                      isEditBtnEnabled: widget.pageState,
                      genderController: genderController,
                      selectedFunction: (GenderResponse val) =>
                          selectedGender = val,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  updateClickEvent(isEditClicked) async {
    if (await GMUtils().isInternetConnected()) {
      if (!isEditClicked) {
        if (validate()) {
          UserProfileInfo userProfileInfoRequest = UserProfileInfo();
          userProfileInfoRequest.userId = userProfileInfo.userId;
          userProfileInfoRequest.firstName = _fNameController.text;
          userProfileInfoRequest.lastName = _lNameController.text;
          userProfileInfoRequest.email = userProfileInfo.email;
          userProfileInfoRequest.mobileNumber = userProfileInfo.mobileNumber;

          userProfileInfoRequest.nationalityId =
              selectedNationalityResponse.nationalityId;
          nationalityId = userProfileInfoRequest.nationalityId.toString();
          userProfileInfoRequest.genderId = selectedGender.genderId;
          userProfileInfoRequest.dateOfBirth = DateTimeUtils()
              .dateToStringFormat(
                  DateTimeUtils().stringToDate(
                      _customDobcontroller.text.toString(),
                      DateTimeUtils.DD_MM_YYYY_Format),
                  DateTimeUtils.dobFormat);

          print(userProfileInfoRequest.toString());
          BlocProvider.of<ProfileBloc>(context)
            ..add(
              ProfileSaveBtnPressed(profileDetails: userProfileInfoRequest),
            );
        }
      }
    } else {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("nonetwork"), context);
    }
  }

  validate() {
    if (_fNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("fNameErrorMessage"), context);
      return false;
    } else if (_lNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("lNameErrorMessage"), context);
      return false;
    } else if (_customDobcontroller.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("dobErrorMessage"), context);
      return false;
    } else if (selectedNationalityResponse == null) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("nationalityErrorMessage"), context);
      return false;
    } else if (selectedGender == null) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("genderErrorMessage"), context);
      return false;
    }
    return true;
  }

  Widget failureUI(String error, BuildContext context) {
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
                _fNameController = new MaskedTextController(
                    mask: Strings.maskEngValidationStr);
                _lNameController = new MaskedTextController(
                    mask: Strings.maskEngValidationStr);
                _emailController = new MaskedTextController(
                    mask: Strings.maskEngEmailValidationStr);
                _mobileController = new MaskedTextController(
                    mask: Strings.maskEngValidationStr);
                nationalityController = new MaskedTextController(
                    mask: Strings.maskEngFLNameValidationStr);
                genderController = new MaskedTextController(
                    mask: Strings.maskEngFLNameValidationStr);
                _customDobcontroller =
                    new MaskedTextController(mask: Strings.maskDOBStr);
                BlocProvider.of<ProfileBloc>(context).add(GeneralList());
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
}
