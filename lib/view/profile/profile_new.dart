import 'dart:convert';
import 'dart:io';
import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/expansiontile/expan_collapse_profile.dart';
import 'package:slc/customcomponentfields/profile_custom_noneditable_component.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/repo/generic_repo.dart';
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/enquiry/enquiry_payment.dart';
import 'package:slc/view/enquiry/new_enquiry.dart';
import 'package:slc/view/otp/profile_otp_verification.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_success_dialog.dart';

import '../retail_cart/web_page.dart';
import 'bloc/bloc.dart';

// ignore: must_be_immutable
class ProfileNew extends StatelessWidget {
  String pageState;

  ProfileNew(this.pageState);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) {
          return ProfileBloc(null);
        },
        child: _ProfileNew(this.pageState),
      ),
    );
  }
}

// ignore: must_be_immutable
class _ProfileNew extends StatefulWidget {
  String pageState;

  _ProfileNew(this.pageState);

  @override
  _ProfileNewState createState() => _ProfileNewState();
}

class _ProfileNewState extends State<_ProfileNew> {
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

  TextEditingController _membershipTypeNameController =
      new TextEditingController();

  TextEditingController bridgeUserType = TextEditingController();

  TextEditingController memberContractNumberCtrl = TextEditingController();

  TextEditingController memberNumberCtrl = TextEditingController();

  TextEditingController memberStartDateCtrl = TextEditingController();

  TextEditingController memberEndDateCtrl = TextEditingController();

  TextEditingController memberCatgoryCtrl = TextEditingController();
  TextEditingController memberRaidCtrl = TextEditingController();
  TextEditingController memberCatgoryIdCtrl = TextEditingController();

  GlobalKey<FormBuilderState> _profileFormKey = GlobalKey<FormBuilderState>();

  String _ddInitialValue = Strings.txtDDInitialValue;
  IconData editToSave = Icons.save;
  IconData saveToEdit = Icons.edit;
  GlobalKey<ScaffoldState> _profileScaffoldKey = new GlobalKey<ScaffoldState>();
  String nationalityId;

  Utils util = Utils();

  GenderResponse selectedGender;
  NationalityResponse selectedNationalityResponse;
  UserProfileInfo userProfileInfo = UserProfileInfo();
  List<GenderResponse> genderList = [];
  List<NationalityResponse> nationalityList = [];
  DialogHandler _handlerDialog;
  bool saveInProgress = false;
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
    memberCatgoryCtrl.dispose();
    memberCatgoryIdCtrl.dispose();
    memberRaidCtrl.dispose();
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
        } else if (state is ShowNewProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is OnProfileSuccess) {
          _handlerDialog.show();
        } else if (state is OnProfileFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is OnSuccessOTPResend) {
          userProfileInfo.dialCode == Constants.UAE_COUNTRY_CODE
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
            _membershipTypeNameController.text =
                userProfileInfo.membershipTypeName;
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
            memberRaidCtrl.text = userProfileInfo.customerId != null
                ? userProfileInfo.customerId.toString()
                : "";
            memberCatgoryCtrl.text =
                // userProfileInfo.bridgeUserCategoryId != null
                //     ? tr("staff")
                //     : "-";
                userProfileInfo.isStaff != null && userProfileInfo.isStaff != 0
                    ? tr("staff")
                    : "-";
            memberCatgoryIdCtrl.text =
                userProfileInfo.bridgeUserCategoryType != null
                    ? userProfileInfo.bridgeUserCategoryType.toString()
                    : 0;
            if (userProfileInfo != null) {
              //if (userProfileInfo.membershipExpire == true) {
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
          //}

          return Stack(children: <Widget>[
            mainUI(context),
            progressBar,
          ]);
        },
      ),
    );
  }

  Widget mainUI(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        key: _profileScaffoldKey,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: Stack(
            children: [
              CustomAppBar(
                title: tr("profile"),
                titleImage: userProfileInfo.profileImage,
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
              Padding(
                  padding: EdgeInsets.only(top: 80),
                  child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      height: 30,
                      child: Text("",
                          style: TextStyle(
                              backgroundColor: Colors.white, fontSize: 10)))),
              Padding(
                  padding: EdgeInsets.only(top: 60),
                  child: Container(
                      color: Color.fromRGBO(242, 238, 235, 1.0),
                      width: MediaQuery.of(context).size.width,
                      height: 20,
                      child: Text("",
                          style: TextStyle(
                              backgroundColor: Colors.red, fontSize: 10)))),
              Align(
                  alignment: Alignment.center,
                  child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Material(
                        color: Colors.white,
//                      elevation: 1.0,
                        shape: CircleBorder(),
                        child: Container(
                          decoration: new BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 3.0, color: Colors.white10),
                          ),
                          padding: EdgeInsets.all(3.0),
                          // need to change image
                          child: Container(
                            child: userProfileInfo.profileImage != null &&
                                    userProfileInfo.profileImage != ""
                                ? CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage: NetworkImage(
                                        userProfileInfo.profileImage),
                                    backgroundColor: Colors.transparent,
                                  )
                                : CircleAvatar(
                                    child: Icon(
                                      AccountIcon.account_type,
                                      color: const Color(0xFF3EB5E3),
                                      size: 70,
                                    ),
                                    radius: 40.0,
                                    backgroundColor: Colors.white,
                                  ),
                          ),
                        ),
                      ))),
            ],
          ),
        ),
        body: Container(
            padding: EdgeInsets.zero,
            // decoration: BoxDecoration(color: Colors.blue),
            decoration: BoxDecoration(
                // color: Colors.blue,
                // border: Border.all(color: Colors.red, width: 2.0),
                image: DecorationImage(
                    image: userProfileInfo.profileCategory != null
                        ? AssetImage(
                            "assets/images/" + userProfileInfo.profileCategory)
                        : AssetImage("assets/images/bronze.png"),
                    fit: BoxFit.cover)),
            child: getProfile(context)),
        bottomNavigationBar: Visibility(
          visible: userProfileInfo.bridgeUserType == 'Member' ? true : false,
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.06,
            color: Colors.transparent,
            padding: EdgeInsets.only(top: 6, bottom: 6),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RetailCartWebviewPage(
                      title: tr("customer_survey"),
                      url: 'https://ds.sharjah.ae/survey?spid=48',
                    ),
                  ),
                );
              },
              icon: SvgPicture.asset(
                'assets/images/smiley.svg',
                height: 26,
                width: 26,
                color: Colors.white,
              ),
              label: Text(tr("customer_survey")),
              style: ElevatedButton.styleFrom(
                  backgroundColor: ColorData.profileSurveyColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)))),
            ),
          ),
        ),
      ),
    );
  }

  Widget associateProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
          visible: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
            child: new Text(tr("associat_profile"),
                style: TextStyle(
                  fontSize: Styles.loginBtnFontSize,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: tr('currFontFamily'),
                )),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: CustomExpandTileProfile(
            // profileList: profilelist,items: items,subitems: subitems,
            userInfo: userProfileInfo,
          ),
        ),
      ],
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
    } else if (_fNameController.text.length < 2) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("fNameErrorMessage"), context);
      return false;
    } else if (_lNameController.text.length < 2) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("lNameErrorMessage"), context);
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
                    Radius.circular(4.0),
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

  Widget getProfile(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.transparent,
                    // padding: EdgeInsets.only(
                    //     top: 0.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: Material(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.circular(10.0)),
                      // elevation: 5.0,
                      color: Colors.transparent,
                      child: Column(
                        children: <Widget>[
                          // SizedBox(
                          //   height: 60.0,
                          // ),
                          Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.06),
                              // width: MediaQuery.of(context).size.width * 0.45,
                              child: Directionality(
                                  textDirection: prefix.TextDirection.ltr,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          bridgeUserType.text = userProfileInfo
                                                      .bridgeUserType !=
                                                  null
                                              ? userProfileInfo.bridgeUserType
                                              : "",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            fontSize: Styles.loginBtnFontSize,
                                            fontFamily: tr('currFontFamily'),
                                            color: userProfileInfo
                                                        .bridgeUserTypeId ==
                                                    null
                                                ? ColorData.whiteColor
                                                : userProfileInfo
                                                            .bridgeUserTypeId ==
                                                        Constants
                                                            .BRIDGE_MEMBER_TYPE_ID
                                                    ? ColorData.profileMember
                                                    : userProfileInfo
                                                                .bridgeUserTypeId ==
                                                            Constants
                                                                .BRIDGE_CUSTOMER_TYPE_ID
                                                        ? ColorData
                                                            .profileCustomer
                                                        : userProfileInfo
                                                                    .bridgeUserTypeId ==
                                                                Constants
                                                                    .BRIDGE_GUEST_TYPE_ID
                                                            ? ColorData
                                                                .profileGuest
                                                            : ColorData
                                                                .profileGuest,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          _fNameController.text +
                                              " " +
                                              _lNameController.text,
                                          style: TextStyle(
                                            fontSize: Styles.loginBtnFontSize,
                                            fontFamily: tr('currFontFamily'),
                                            color: ColorData.primaryTextColor,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(_emailController.text,
                                            style:
                                                PackageListHead.textFieldStyles(
                                                    context, false)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(_mobileController.text,
                                            textDirection:
                                                prefix.TextDirection.ltr,
                                            style: PackageListHead
                                                .textFieldCountryCodeStyles(
                                                    context)),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          nationalityController.text,
                                          style:
                                              PackageListHead.textFieldStyles(
                                                  context, false),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          memberRaidCtrl.text,
                                          style:
                                              PackageListHead.textFieldStyles(
                                                  context, false),
                                        ),
                                      ]))),
                          SizedBox(
                            height: 16.0,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                  left: BorderSide(
                                      color: ColorData.profileBoxColor,
                                      width: 1.0),
                                  right: BorderSide(
                                      color: ColorData.profileBoxColor,
                                      width: 1.0),
                                  top: BorderSide(
                                      color: ColorData.profileBoxColor,
                                      width: 1.0),
                                  bottom: BorderSide(
                                      color: ColorData.profileBoxColor,
                                      width: userProfileInfo.bridgeUserTypeId ==
                                              null
                                          ? 0.0
                                          : userProfileInfo.bridgeUserTypeId ==
                                                  Constants
                                                      .BRIDGE_MEMBER_TYPE_ID
                                              ? 0
                                              : 1.0)),
                            ),
                            margin: EdgeInsets.only(
                                right: 10.0,
                                left: 10.0,
                                bottom: userProfileInfo.bridgeUserTypeId == null
                                    ? 0.0
                                    : userProfileInfo.bridgeUserTypeId !=
                                            Constants.BRIDGE_MEMBER_TYPE_ID
                                        ? 10.0
                                        : 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child:
                                        ProfileCustomNonEditableTextFieldComponent(
                                      isPageFromProfileNonEditable: true,
                                      customLabelString: tr("dobLabelProfile"),
                                      mobileCtrl: _customDobcontroller,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  color: Colors.black12,
                                  height: 55,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(left: 5.0),
                                    child:
                                        ProfileCustomNonEditableTextFieldComponent(
                                      isPageFromProfileNonEditable: true,
                                      customLabelString:
                                          tr("genderLabelString"),
                                      mobileCtrl: genderController,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: userProfileInfo.membershipTypeName !=
                                        null &&
                                    userProfileInfo.membershipTypeName != '' &&
                                    userProfileInfo.bridgeUserTypeId ==
                                        Constants.BRIDGE_MEMBER_TYPE_ID
                                ? true
                                : false,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        right: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        top: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        bottom: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0)),
                                  ),
                                  margin: EdgeInsets.only(
                                      right: 10.0, left: 10.0, bottom: 0.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("membershiptypename"),
                                            mobileCtrl:
                                                _membershipTypeNameController,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Visibility(
                            visible:
                                userProfileInfo.bridgeUserCategoryId != null &&
                                        (userProfileInfo.bridgeUserCategoryId !=
                                                0 ||
                                            userProfileInfo.isStaff == 1)
                                    ? true
                                    : false,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        right: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        top: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0)),
                                  ),
                                  margin:
                                      EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("member_category"),
                                            mobileCtrl: memberCatgoryCtrl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: Colors.black12,
                                        height: 55,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("staff_member_id"),
                                            mobileCtrl: memberCatgoryIdCtrl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     border: Border(
                                //         left: BorderSide(
                                //             color: ColorData.profileBoxColor,
                                //             width: 1.0),
                                //         right: BorderSide(
                                //             color: ColorData.profileBoxColor,
                                //             width: 1.0),
                                //         bottom: BorderSide(
                                //             color: ColorData.profileBoxColor,
                                //             width: 1.0),
                                //         top: BorderSide(
                                //             color: ColorData.profileBoxColor,
                                //             width: 1.0)),
                                //   ),
                                //   margin: EdgeInsets.only(
                                //       right: 10.0, left: 10.0, bottom: 10.0),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: <Widget>[
                                //       Expanded(
                                //         child: Container(
                                //           margin: EdgeInsets.only(left: 5.0),
                                //           child:
                                //               ProfileCustomNonEditableTextFieldComponent(
                                //             isPageFromProfileNonEditable: true,
                                //             customLabelString:
                                //                 tr("membership_startdate"),
                                //             mobileCtrl: memberStartDateCtrl,
                                //           ),
                                //         ),
                                //       ),
                                //       Container(
                                //         width: 1,
                                //         color: Colors.black12,
                                //         height: 55,
                                //       ),
                                //       Expanded(
                                //         child: Container(
                                //           margin: EdgeInsets.only(left: 5.0),
                                //           child:
                                //               ProfileCustomNonEditableTextFieldComponent(
                                //             isPageFromProfileNonEditable: true,
                                //             customLabelString:
                                //                 tr("membership_enddate"),
                                //             mobileCtrl: memberEndDateCtrl,
                                //             colorCode: userProfileInfo
                                //                             .membershipExpire !=
                                //                         null &&
                                //                     userProfileInfo
                                //                         .membershipExpire
                                //                 ? "#FF5733"
                                //                 : "",
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: (userProfileInfo.bridgeUserTypeId ==
                                        null ||
                                    userProfileInfo.bridgeUserTypeId ==
                                        Constants.BRIDGE_GUEST_TYPE_ID ||
                                    (userProfileInfo.bridgeUserTypeId ==
                                            Constants.BRIDGE_CUSTOMER_TYPE_ID &&
                                        !userProfileInfo.membershipExpire))
                                ? false
                                // : userProfileInfo.bridgeUserTypeId ==
                                //     Constants.BRIDGE_MEMBER_TYPE_ID,
                                : true,
                            child: Column(
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        right: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        top: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0)),
                                  ),
                                  margin:
                                      EdgeInsets.only(right: 10.0, left: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("membership_number"),
                                            mobileCtrl: memberNumberCtrl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: Colors.black12,
                                        height: 55,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("labelContractNumber"),
                                            mobileCtrl:
                                                memberContractNumberCtrl,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                        left: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        right: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        bottom: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0),
                                        top: BorderSide(
                                            color: ColorData.profileBoxColor,
                                            width: 1.0)),
                                  ),
                                  margin: EdgeInsets.only(
                                      right: 10.0, left: 10.0, bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("membership_startdate"),
                                            mobileCtrl: memberStartDateCtrl,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 1,
                                        color: Colors.black12,
                                        height: 55,
                                      ),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 5.0),
                                          child:
                                              ProfileCustomNonEditableTextFieldComponent(
                                            isPageFromProfileNonEditable: true,
                                            customLabelString:
                                                tr("membership_enddate"),
                                            mobileCtrl: memberEndDateCtrl,
                                            colorCode: userProfileInfo
                                                            .membershipExpire !=
                                                        null &&
                                                    userProfileInfo
                                                        .membershipExpire
                                                ? "#FF5733"
                                                : "",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Visibility(
            visible: userProfileInfo.membershipExpire == null
                ? false
                : userProfileInfo.membershipExpire,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    margin: EdgeInsets.only(
                      top: 3.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: ColorData.profileBoxColor),
                          bottom: BorderSide(color: ColorData.profileBoxColor)),
                    ),
                    child: Center(
                        child: ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorData.accentColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          )))),
                      // color: ColorData.accentColor,
                      onPressed: () async {
                        if (userProfileInfo.enquiryDetail != null &&
                            (userProfileInfo.enquiryDetail.enquiryStatusId ==
                                    Constants.Work_Flow_New ||
                                userProfileInfo.enquiryDetail.enquiryStatusId ==
                                    Constants.Work_Flow_Completed)) return;
                        if (userProfileInfo.enquiryDetail != null &&
                            userProfileInfo.enquiryDetail.enquiryProcessId == 1)
                          return;

                        if (userProfileInfo.enquiryDetail == null) {
                          if (saveInProgress) return;
                          saveInProgress = true;
                          EnquiryDetailResponse request = getEnquiry();
                          Meta m = await (new FacilityDetailRepository())
                              .saveEnquiryDetails(request, false);
                          if (m.statusCode == 200) {
                            Navigator.of(context).pop();
                            int enquiryDetailId =
                                jsonDecode(m.statusMsg)['response'];
                            util.customGetSnackBarWithOutActionButton(
                                tr("enquiry"),
                                "Membership Renewal Request Submitted Successfully",
                                context);
                          } else {
                            util.customGetSnackBarWithOutActionButton(
                                "Membership Renewal", m.statusMsg, context);
                          }
                          saveInProgress = false;
                        } else {
                          FacilityDetailResponse facilityDetailResponse =
                              new FacilityDetailResponse();
                          Meta m2 = await (new FacilityDetailRepository())
                              .getFacilityDetails(
                                  userProfileInfo.enquiryDetail.facilityId);
                          if (m2.statusCode == 200) {
                            facilityDetailResponse =
                                FacilityDetailResponse.fromJson(
                                    jsonDecode(m2.statusMsg)['response']);

                            if (userProfileInfo.enquiryDetail.enquiryStatusId !=
                                Constants.Work_Flow_Payment) {
                              List<Meta> metaList = await Future.wait([
                                GeneralRepo().getNationalityList(),
                                GeneralRepo().getGenderList()
                              ]);
                              List<NationalityResponse> nationalityList = [];

                              List<GenderResponse> genderList = [];
                              if (metaList[0].statusCode == 200 &&
                                  metaList[1].statusCode == 200) {
                                jsonDecode(metaList[0].statusMsg)["response"]
                                    .forEach((f) => nationalityList.add(
                                        new NationalityResponse.fromJson(f)));

                                jsonDecode(metaList[1].statusMsg)["response"]
                                    .forEach((f) => genderList
                                        .add(new GenderResponse.fromJson(f)));
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NewEnquiry(
                                    facilityItem: userProfileInfo
                                        .enquiryDetail.facilityItem,
                                    facilityDetail: facilityDetailResponse,
                                    enquiryDetailId: userProfileInfo
                                        .enquiryDetail.enquiryDetailId,
                                    screenType: userProfileInfo.enquiryDetail
                                                .enquiryStatusId ==
                                            Constants
                                                .Work_Flow_UploadDocuments //2
                                        ? Constants.Screen_Upload_Document
                                        : userProfileInfo.enquiryDetail
                                                    .enquiryStatusId ==
                                                Constants.Work_Flow_Schedules
                                            ? Constants.Screen_Schedule
                                            : userProfileInfo.enquiryDetail
                                                        .enquiryStatusId ==
                                                    Constants
                                                        .Work_Flow_AnswerQuestions
                                                ? Constants
                                                    .Screen_Questioner //3
                                                : userProfileInfo.enquiryDetail
                                                            .enquiryStatusId ==
                                                        Constants
                                                            .Work_Flow_Signature
                                                    ? Constants.Screen_Signature
                                                    : Constants
                                                        .Screen_Accept_Terms, //2
                                  ),
                                ),
                              );
                            } else {
                              Meta pm =
                                  await ProfileRepo().getEnquiryProfileDetail();
                              UserProfileInfo userEnquiryProfileInfo =
                                  new UserProfileInfo.fromJson(
                                      jsonDecode(pm.statusMsg)["response"]);
                              double total = 0;
                              if (userEnquiryProfileInfo.price != null) {
                                total = userEnquiryProfileInfo.price;
                                for (int i = 0;
                                    i <
                                        userEnquiryProfileInfo
                                            .associatedProfileList.length;
                                    i++) {
                                  total = total +
                                      userEnquiryProfileInfo
                                          .associatedProfileList[i].price;
                                }
                              }
                              Meta m = await FacilityDetailRepository()
                                  .getDiscountList(
                                      facilityDetailResponse.facilityId, total);
                              List<BillDiscounts> billDiscounts = [];
                              if (m.statusCode == 200) {
                                billDiscounts =
                                    jsonDecode(m.statusMsg)['response'].forEach(
                                        (f) => billDiscounts.add(
                                            new BillDiscounts.fromJson(f)));
                              }
                              if (billDiscounts == null) {
                                billDiscounts = [];
                              }
                              Meta m1 = await FacilityDetailRepository()
                                  .getPaymentTerms(
                                facilityDetailResponse.facilityId,
                              );
                              PaymentTerms paymentTerms = new PaymentTerms();
                              if (m1.statusCode == 200) {
                                paymentTerms = new PaymentTerms.fromJson(
                                    jsonDecode(m1.statusMsg)["response"]);
                              }

                              if (paymentTerms == null) {
                                paymentTerms = new PaymentTerms();
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnquiryPayment(
                                          enquiryDetail:
                                              userProfileInfo.enquiryDetail,
                                          facilityItem: userProfileInfo
                                              .enquiryDetail.facilityItem,
                                          facilityDetail:
                                              facilityDetailResponse,
                                          userProfileInfo:
                                              userEnquiryProfileInfo,
                                          billDiscounts: billDiscounts,
                                          paymentTerms: paymentTerms,
                                        )),
                              );
                            }
                          }
                        }
                      },
                      child: Text(
                        userProfileInfo.enquiryDetail == null
                            ? tr("renew_your_membership")
                            : userProfileInfo.enquiryDetail.enquiryStatusId ==
                                    Constants.Work_Flow_New
                                ? tr("renew_pending")
                                : userProfileInfo.enquiryDetail.enquiryStatusId ==
                                        Constants.Work_Flow_UploadDocuments
                                    ? userProfileInfo.enquiryDetail.enquiryProcessId ==
                                            0
                                        ? tr('upload_your_documents')
                                        : tr("upload_proces")
                                    : userProfileInfo.enquiryDetail.enquiryStatusId ==
                                            Constants.Work_Flow_AcceptTerms
                                        //3
                                        ? userProfileInfo.enquiryDetail
                                                    .enquiryProcessId ==
                                                0
                                            ? tr("accept")
                                            : tr("accept_process")
                                        : userProfileInfo.enquiryDetail
                                                    .enquiryStatusId ==
                                                Constants.Work_Flow_Payment
                                            //4
                                            ? userProfileInfo.enquiryDetail
                                                        .enquiryProcessId ==
                                                    0
                                                ? tr("proceed_to_pay")
                                                : tr("payment_process")
                                            : userProfileInfo.enquiryDetail
                                                        .enquiryStatusId ==
                                                    Constants
                                                        .Work_Flow_AnswerQuestions
                                                ? userProfileInfo.enquiryDetail
                                                            .enquiryProcessId ==
                                                        0
                                                    ? tr("questions")
                                                    : tr("questions_process")
                                                : userProfileInfo.enquiryDetail
                                                            .enquiryStatusId ==
                                                        Constants
                                                            .Work_Flow_Signature
                                                    ? userProfileInfo
                                                                .enquiryDetail
                                                                .enquiryProcessId ==
                                                            0
                                                        ? tr("Signature")
                                                        : tr(
                                                            "signature_process")
                                                    : userProfileInfo.membershipExpire &&
                                                            userProfileInfo
                                                                    .enquiryDetail
                                                                    .enquiryStatusId ==
                                                                Constants.Work_Flow_Completed
                                                        ? tr("under_process")
                                                        : "",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ))),
              ],
            )),
        Visibility(
            visible: userProfileInfo.bridgeUserTypeId == null
                ? false
                : true
                    ? userProfileInfo.associatedProfileList != null
                        ? userProfileInfo.associatedProfileList.length > 0
                            ? true
                            : false
                        : false
                    : false,
            child: Column(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    margin: EdgeInsets.only(
                      top: 3.0,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: ColorData.profileBoxColor),
                          bottom: BorderSide(color: ColorData.profileBoxColor)),
                    ),
                    child: Center(
                        child: new Text(
                      tr('labelSubContractDetail'),
                      style: PackageListHead.textFieldStyleWithoutArab(
                          context, false),
                    ))),
                Container(
                    margin: EdgeInsets.only(top: 5.0),
                    child: associateProfile()),
              ],
            )),
      ],
    );
  }

  EnquiryDetailResponse getEnquiry() {
    EnquiryDetailResponse request = new EnquiryDetailResponse();
    request.facilityId = Constants.FacilityMembership;
    request.facilityItemId = userProfileInfo.facilityItemId;
    request.firstName = userProfileInfo.firstName;
    request.lastName = userProfileInfo.lastName;
    request.enquiryStatusId = Constants.Work_Flow_New;
    request.supportDocuments = [];
    request.contacts = [];
    request.enquiryProcessId = 0;
    request.totalClass = 0;
    request.balanceClass = 0;
    request.consumedClass = 0;
    request.DOB = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(
            userProfileInfo.dateOfBirth, DateTimeUtils.ServerFormat),
        DateTimeUtils.dobFormat);
    request.enquiryDate = DateTimeUtils()
        .dateToStringFormat(DateTime.now(), DateTimeUtils.dobFormat);
    request.nationalityId = userProfileInfo.nationalityId;
    request.genderId = userProfileInfo.genderId;
    request.preferedTime = "";
    request.languages = "";
    request.emiratesID = "";
    request.address = "";
    request.comments = "Membership Renewal";
    request.isActive = true;
    request.enquiryTypeId = 1;
    request.countryId = 115;
    request.facilityItemName = "";
    request.faclitiyItemDescription = "";
    request.price = 0;
    request.vatPercentage = 0;
    request.facilityImageName = "";
    request.facilityImageUrl = "";
    request.enquiryDetailId = 0;
    request.rate = 0;
    return request;
  }
}
