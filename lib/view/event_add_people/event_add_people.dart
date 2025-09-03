import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_gender_select_component.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code_picker.dart';
import 'package:slc/common/custom_prodcat_select_component.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/custom_dob_component.dart';
import 'package:slc/customcomponentfields/custom_noneditable_component.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/custom_dropdown_input.dart';
import 'package:slc/model/event_participant.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/event_pricing_category.dart';
import 'package:slc/model/event_registration_request.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/iconsfile.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_add_people/bloc/bloc.dart';
import 'package:slc/view/event_people_list/event_people_list.dart';
import 'package:string_validator/string_validator.dart';

int selectedindex;

// ignore: must_be_immutable
class EventAddPeople extends StatelessWidget {
  int eventId;
  bool isAddMe;
  bool showAddPeople;
  List<EventPriceCategory> eventPricingCategoryList = [];
  final List<EventProdCategory> eventProducts;

  EventAddPeople(
      {this.eventPricingCategoryList,
      this.eventId,
      this.isAddMe,
      this.showAddPeople,
      this.eventProducts});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventAddPeopleBloc()..add(GetInitiallData()),
      child: AddPeople(
          eventId: eventId,
          eventPricingCategoryList: eventPricingCategoryList,
          isAddMe: isAddMe,
          showAddPeople: showAddPeople,
          eventProducts: eventProducts),
    );
  }
}

// ignore: must_be_immutable
class AddPeople extends StatefulWidget {
  int eventId;
  bool isAddMe;
  bool showAddPeople;
  List<EventPriceCategory> eventPricingCategoryList;
  final List<EventProdCategory> eventProducts;

  AddPeople(
      {this.eventId,
      this.eventPricingCategoryList,
      this.isAddMe,
      this.showAddPeople,
      this.eventProducts});

  @override
  State<StatefulWidget> createState() {
    return _AddPeople(eventPricingCategoryList);
  }
}

class _AddPeople extends State<AddPeople> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  Color iconColor;
  bool _isChecked = false;
  int selectedCountryId = Constants.UAECountryId;
  List<EventPriceCategory> eventPricingCategoryList = [];
  Utils util = new Utils();

  MaskedTextController _fNameController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController _lNameController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _mobileNoController = new TextEditingController();
  TextEditingController nationalityController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  TextEditingController _customDobController = new TextEditingController();
  TextEditingController _customProdCategoryController =
      new TextEditingController();

  IconData editToSave = Icons.save;
  IconData saveToEdit = Icons.edit;

  final GlobalKey<FormBuilderState> basicInfoTwoFormKey =
      GlobalKey<FormBuilderState>();

  List<GenderResponse> genderList = [];
  List<CustomDropDownInput> genderCustomDropDownInputList = [];
  List<NationalityResponse> nationalityList = [];
  List<CustomDropDownInput> nationalityCustomDropDownInputList = [];
  UserProfileInfo userProfileInfo = new UserProfileInfo();
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  GenderResponse selectedGenderValue = GenderResponse();
  NationalityResponse selectedNationalityValue = NationalityResponse();
  List<EventPricingCategory> pricingList = [];
  EventProdCategory selectedProductCategory = new EventProdCategory();
  RegExp regExp = new RegExp(
    Constants.UAE_MOBILE_PATTERN,
    caseSensitive: false,
    multiLine: false,
  );

  _AddPeople(this.eventPricingCategoryList);

  @override
  void initState() {
    Constants.INIT_DATETIME = DateTime.parse(
        SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
    super.initState();
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
    if (widget.isAddMe) {
      BlocProvider.of<EventAddPeopleBloc>(context).add(GetUserProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<EventAddPeopleBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<EventAddPeopleBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<EventAddPeopleBloc, EventAddPeopleState>(
      listener: (context, state) {
        if (state is ShowEventRegistrationProgressBar) {
          _handler.show();
        } else if (state is HideEventRegistrationProgressBar) {
          _handler.dismiss();
        } else if (state is OnFailureEventRegistration) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), state.error, context);
        } else if (state is OnInitialDataFailureEventRegistration) {
          _handler.dismiss();
          reTryUi(tr("retry"));
        } else if (state is LoadInitialData) {
          genderList.clear();
          genderList.addAll(state.genderList);
          nationalityList.clear();
          nationalityList.addAll(state.nationalityList);
        } else if (state is GetProfileState) {
          userProfileInfo = state.userProfileInfo;
          Constants.INIT_DATETIME = DateTime.parse(
              SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
          if (widget.isAddMe) {
            selectedCountryId = userProfileInfo.countryId != null
                ? userProfileInfo.countryId
                : Constants.UAECountryId;

            _fNameController.text = userProfileInfo.firstName != null
                ? userProfileInfo.firstName
                : "";
            _lNameController.text = userProfileInfo.lastName != null
                ? userProfileInfo.lastName
                : "";
            _emailController.text =
                userProfileInfo.email != null ? userProfileInfo.email : "";
            _mobileNoController.text = userProfileInfo.mobileNumber != null
                ? userProfileInfo.dialCode == null
                    ? "" + userProfileInfo.mobileNumber
                    : userProfileInfo.dialCode +
                        " " +
                        userProfileInfo.mobileNumber
                : "";

            if (userProfileInfo.dateOfBirth != null &&
                userProfileInfo.dateOfBirth.length > 0) {
              Constants.INIT_EVENTDATETIME =
                  DateTime.parse(userProfileInfo.dateOfBirth);
              _customDobController.text = DateTimeUtils()
                  .dateToServerToDateFormat(
                      userProfileInfo.dateOfBirth,
                      DateTimeUtils.ServerFormat,
                      DateTimeUtils.DD_MM_YYYY_Format);
            }

            selectedGenderValue = genderList.firstWhere((genderValue) =>
                genderValue.genderId == userProfileInfo.genderId);
            genderController.text = (selectedGenderValue.genderName);

            selectedNationalityValue = nationalityList.firstWhere(
                (nationalityValue) =>
                    nationalityValue.nationalityId ==
                    userProfileInfo.nationalityId);

            nationalityController.text =
                (selectedNationalityValue.nationalityName);
          }
        } else if (state is OnSuccessEventRegistration) {
          Get.off(() => (EventPeopleList(
                eventId: widget.eventId,
                eventPriceCategoryList: widget.eventPricingCategoryList,
                showAddPeople: widget.showAddPeople,
              )));
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
      child: Scaffold(
        body: BlocBuilder<EventAddPeopleBloc, EventAddPeopleState>(
          builder: (context, state) {
            return Container(
                child: Stack(children: <Widget>[mainUi(context), progressBar]));
          },
        ),
      ),
    );
  }

  _retryPage() {
    BlocProvider.of<EventAddPeopleBloc>(context).add(GetInitiallData());
  }

  Widget reTryUi(String error) {
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
              style: TextStyle(
                color: ColorData.primaryTextColor,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              // color: ColorData.accentColor,
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    ColorData.accentColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )))),
              onPressed: _retryPage,
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

  Widget mainUi(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Get.off(() => (EventPeopleList(
                eventId: widget.eventId,
                eventPriceCategoryList: widget.eventPricingCategoryList,
                showAddPeople: widget.showAddPeople,
              )));
          return Future.value(false);
        },
        child: Scaffold(
          bottomNavigationBar: Container(
            width: MediaQuery.of(context).size.width,
            height: 50.0,
            margin: EdgeInsets.only(
                top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
            child: new ElevatedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.add, size: 20),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      tr('add'),
                      style: TextStyle(fontSize: Styles.loginBtnFontSize),
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )))),
              // shape: new RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(8),
              // ),
              onPressed: () {
                if (validateForm(context)) {
                  EventRegistrationRequest request = EventRegistrationRequest();
                  if (widget.isAddMe) {
                    request.isAddMe = widget.isAddMe;
                    request.countryCodeId =
                        SPUtil.getInt(Constants.USER_COUNTRYID);
                  } else {
                    request.isAddMe = widget.isAddMe;
                    request.countryCodeId = selectedCountryId;
                  }
                  request.firstName = _fNameController.text.toString();
                  request.lastName = _lNameController.text.toString();
                  request.nationalityId =
                      selectedNationalityValue.nationalityId;
                  request.genderId = selectedGenderValue.genderId;
                  request.email =
                      _emailController.text.toLowerCase().toString();
                  request.dateOfBirth = DateTimeUtils().dateToStringFormat(
                      DateTimeUtils().stringToDate(
                          _customDobController.text.toString(),
                          DateTimeUtils.DD_MM_YYYY_Format),
                      DateTimeUtils.dobFormat);
                  request.mobileNumber = widget.isAddMe
                      ? userProfileInfo.mobileNumber
                      : _mobileNoController.text.toString();
                  request.userId = SPUtil.getInt(Constants.USERID);
                  request.eventId = widget.eventId;
                  if (pricingList.length > 0) {
                    request.eventPricingCategoryList = pricingList;
                  }
                  if (widget.eventProducts != null &&
                      widget.eventProducts.length > 0) {
                    request.eventPropItemId = selectedProductCategory.id;
                  } else {
                    request.eventPropItemId = 0;
                  }
                  errorDialog(context, request);
                }
              },
              // textColor: Colors.white,
              // color: Theme.of(context).primaryColor,
            ),
          ),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200.0),
            child: CustomAppBar(
              title: tr('addPeople'),
              eventId: widget.eventId,
              eventPricingCategoryList: widget.eventPricingCategoryList,
              showAddPeople: widget.showAddPeople,
            ),
          ),
          body: getFormFields(),
        ),
      ),
    );
  }

  getFormFields() {
    debugPrint(" add me " + widget.isAddMe.toString());
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: FormBuilder(
          enabled: !widget.isAddMe,
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
                    () => {}),
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
                    () => {}),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: LoginPageFieldWhite(
                    _emailController,
                    tr("emailLabel"),
                    Strings.countryCodeForNonMobileField,
                    CommonIcons.mail,
                    TextInputTypeFile.textInputTypeEmail,
                    TextInputAction.done,
                    () => {},
                    () => {}),
              ),
              Visibility(
                visible: !widget.isAddMe,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                  child: LoginPageFieldWhite(
                    _mobileNoController,
                    /*mobileNumber*/
                    tr('mobileNumber'),
                    widget.isAddMe ? userProfileInfo.dialCode : "+971",
                    IconsFile.leadIconForMobile,
                    TextInputTypeFile.textInputTypeMobile,
                    TextInputAction.done,
                    (_selectedCountry) =>
                        {selectedCountryId = _selectedCountry.countryId},
                    () => {},
                    isCountryCodeReadOnly: widget.isAddMe,
                  ),
                ),
              ),
              Visibility(
                visible: widget.isAddMe,
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: CustomNonEditableTextFieldComponent(
                    customLabelString: tr("mobileNumber"),
//                    PeopleList_customDobController.text,
                    mobileCtrl: _mobileNoController,
                    customLeadIcon: Icons.phone_android,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: CustomGenderComponent(
                  isEditBtnEnabled: widget.isAddMe
                      ? Strings.ProfileInitialState
                      : Strings.ProfileCallState,
                  genderController: genderController,
                  textStyle: TextStyle(color: ColorData.primaryTextColor),
                  selectedFunction: (GenderResponse val) =>
                      selectedGenderValue = val,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: CustomDOBComponent(
                  isEditBtnEnabled: widget.isAddMe
                      ? Strings.ProfileInitialState
                      : Strings.ProfileCallState,
                  selectedFunction: (val) => {
                    _customDobController.text = val,
                  },
                  dobController: _customDobController,
                  isAddPeople: true,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: NationalityCodePicker(
                    isEditBtnEnabled: widget.isAddMe
                        ? Strings.ProfileInitialState
                        : Strings.ProfileCallState,
                    nationalityController: nationalityController,
                    onChanged: (nationality) =>
                        {selectedNationalityValue = nationality},
                    initialSelection: selectedNationalityValue != null
                        ? selectedNationalityValue.nationalityName
                        : "",
                    textStyle: TextStyle(color: ColorData.primaryTextColor),
                    searchStyle: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamilyEnglishOnly"),
                    ),
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false),
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: eventPricingCategoryList.length,
                itemBuilder: (BuildContext context, int index) {
//                  String price =
//                      (eventPricingCategoryList[index].price.toString() != null)
//                          ? (int.parse(eventPricingCategoryList[index]
//                                          .price
//                                          .toString()
//                                          .split('.')[1]))
//                                      .toString() ==
//                                  '0'
//                              ? eventPricingCategoryList[index]
//                                  .price
//                                  .toString()
//                                  .split('.')[0]
//                              : eventPricingCategoryList[index].price.toString()
//                          : "";

                  String price =
                      (eventPricingCategoryList[index].price.toString() != null)
                          ? Utils().getAmount(
                              amount: eventPricingCategoryList[index].price)
                          : "";
                  return Padding(
                      padding: EdgeInsets.only(left: 20.0, right: 25.0),
                      child: ListTile(
                        // lead: false,
                        dense: true,
                        leading: Checkbox(
                            value: selectedindex == index ? _isChecked : false,
                            onChanged: (bool value) {
                              _isChecked = value;
                              selectedindex = index;
                              setState(() {
                                if (_isChecked) {
                                  pricingList.clear();
                                  EventPricingCategory p = EventPricingCategory(
                                      eventPricingCategoryId: widget
                                          .eventPricingCategoryList[
                                              selectedindex]
                                          .eventPriceCategoryId);
                                  pricingList.add(p);
                                } else {
                                  pricingList.clear();
                                }
                              });
                            }),
                        title: Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                (eventPricingCategoryList[index].name != null)
                                    ? eventPricingCategoryList[index].name
                                    : "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: ColorData.primaryTextColor,
                                    fontSize: 12.0,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                        ),
                        trailing: Text(
                            (eventPricingCategoryList[index].price.toString() !=
                                    null)
                                ? price
//                                    eventPricingCategoryList[index].price.toString()
                                : "",
                            style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontSize: 12.0,
                                fontFamily: tr('currFontFamilyEnglishOnly'))),
                      ));
                },
              ),
              Visibility(
                  visible: widget.eventProducts != null &&
                          widget.eventProducts.length > 0
                      ? true
                      : false,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: CustomProductCategoryComponent(
                        selectedFunction: _onChangeCategoryOptionDropdown,
                        productCategoryController:
                            _customProdCategoryController,
                        isEditBtnEnabled: Strings.ProfileCallState,
                        productCategoryResponse: widget.eventProducts == null
                            ? []
                            : widget.eventProducts,
                        label: tr('category')),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  bool validateForm(BuildContext context) {
    if (_fNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('fNameErrorMessage'), context);
      return false;
    } else if (_lNameController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('lNameErrorMessage'), context);
      return false;
    } else if (_emailController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('emailErrorMessage'), context);
      return false;
    } else if (!isEmail(_emailController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidEmailError'), context);
      return false;
    } else if (_mobileNoController.text.isEmpty && !widget.isAddMe) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('mobileNoErrorMessage'), context);
      return false;
    } else if (_mobileNoController.text.length !=
            Constants.UAEMobileNumberLength &&
        selectedCountryId == Constants.UAECountryId &&
        !widget.isAddMe) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (!widget.isAddMe &&
        (_mobileNoController.text.length <
                Constants.OtherMinMobileNumberLength ||
            _mobileNoController.text.length >
                Constants.OtherMaxMobileNumberLength) &&
        selectedCountryId != Constants.UAECountryId) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (!widget.isAddMe &&
        selectedCountryId == Constants.UAECountryId &&
        !regExp.hasMatch(_mobileNoController.text)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('invalidMobileNumber'), context);
      return false;
    } else if (genderController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('genderErrorMessage'), context);
      return false;
    } else if (_customDobController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('dobErrorMessage'), context);
      return false;
    } else if (nationalityController.text.isEmpty) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('nationalityErrorMessage'), context);
      return false;
    } else if (widget.eventPricingCategoryList != null &&
        widget.eventPricingCategoryList.length > 0 &&
        pricingList.length == 0) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('select_price_category_list'), context);
      return false;
    } else if (widget.eventProducts != null &&
        widget.eventProducts.length > 0 &&
        (selectedProductCategory == null ||
            selectedProductCategory.categoryName == null)) {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr('select_prop_item_category'), context);

      return false;
    }
    return true;
  }

  _onChangeCategoryOptionDropdown(EventProdCategory category) {
    setState(() {
      selectedProductCategory = category;
    });
  }

  errorDialog(BuildContext context1, EventRegistrationRequest request) {
    var text = new RichText(
      text: new TextSpan(
        style: new TextStyle(
            fontSize: 12.0,
//            color: ColorData.primaryTextColor,
            fontWeight: FontWeight.w400),
        children: <TextSpan>[
          new TextSpan(
              text: tr('PleaseConfirm'),
              style: TextStyle(
//                  fontSize: 12.0,
                  color: ColorData.primaryTextColor,
                  fontFamily: tr("currFontFamily"))),
          new TextSpan(
              text: " " + _emailController.text.toLowerCase() + " ",
              style: TextStyle(
//                  fontSize: 12.0,
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: tr("currFontFamilyEnglishOnly"))),
          new TextSpan(
              text: tr('mailConfirm'),
              style: TextStyle(
//                      fontSize: 12.0,
                  color: ColorData.primaryTextColor,
                  fontFamily: tr("currFontFamily"))),
        ],
      ),
    );

    return showDialog(
      context: context1,
      barrierDismissible: false,
      builder: (BuildContext context1) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Center(child: Image.asset('assets/images/emailConform.png')),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      tr('emailConfirmation'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: tr('currFontFamily'),
                        fontWeight: FontWeight.w500,
                        color: ColorData.primaryTextColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white54),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              )))),
                          // shape: RoundedRectangleBorder(
                          //     borderRadius:
                          //         BorderRadius.all(Radius.circular(5.0))),
                          // color: Colors.white54,
                          child: new Text(tr('cancel'),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr('currFontFamily'))),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                      ElevatedButton(
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(5.0))),
                        // color: ColorData.colorBlue,
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.colorBlue),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )))),
                        child: new Text(
                          tr('ok'),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.white,
                              fontFamily: tr('currFontFamily')),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<EventAddPeopleBloc>(context).add(
                              SaveEventRegistrationEvent(request: request));
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
