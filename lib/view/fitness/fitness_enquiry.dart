// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:circle_checkbox/redev_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_question_select_component.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/custom_dropdown_input.dart';
import 'package:slc/model/enquiry_questioners.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/model/enquiry_answers.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:http/http.dart' as http;
import 'package:slc/view/enquiry/enquiry_payment.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/fitness/bloc/fitness_bloc.dart';
import 'package:slc/view/fitness/bloc/fitness_event.dart';
import 'package:slc/view/fitness/bloc/fitness_state.dart';
import 'package:slc/view/fitness/fitnessbuy/fitnessbuy_payment.dart';
import 'package:slc/view/fitness/gymentry.dart';
import 'package:slc/view/fitness/personaltraining.dart';
import 'package:signature/signature.dart' as sign;
import 'package:http_parser/http_parser.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';

class FitnessEnquiry extends StatelessWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;

  int enquiryDetailId = 0;
  int screenType = 0;
  int moduleId = 0;
  List<TermsCondition> termsList = [];
  UserProfileInfo userProfileInfo = new UserProfileInfo();

  FitnessEnquiry(
      {this.facilityItem,
      this.facilityDetail,
      this.enquiryDetailId,
      this.screenType,
      this.moduleId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessBloc>(
      create: (context) => FitnessBloc(null)
        ..add(new FitnessEnquiryTermsData(
            facilityId: this.facilityDetail.facilityId,
            facilityItemId: this.facilityItem.facilityItemId,
            enquiryDetailId: enquiryDetailId))
        ..add(GetPaymentTerms(facilityId: this.facilityDetail.facilityId)),
      child: FitnessEnquiryPage(
          facilityItem: this.facilityItem,
          facilityDetail: this.facilityDetail,
          // genderList: this.genderList,
          // nationalityList: this.nationalityList,
          enquiryDetailId: this.enquiryDetailId,
          screenType: this.screenType,
          moduleId: this.moduleId),
    );
  }
}

class FitnessEnquiryPage extends StatefulWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  List<GenderResponse> genderList = [];
  List<NationalityResponse> nationalityList = [];
  int enquiryDetailId = 0;
  int screenType = 0;
  int moduleId = 0;
  List<TermsCondition> termsList = [];
  List<TermsCondition> importantTerms = [];
  EnquiryDetailResponse enquiryDetail = new EnquiryDetailResponse();
  List<MemberQuestionGroup> memberQuestions = [];
  List<Trainers> trainers = [];
  List<FamilyMember> familyMembers = [];
  String selectedDate = "";
  int showDetail = 0;
  bool checkAll = false;
  UserProfileInfo userProfileInfo = new UserProfileInfo();
  bool showContract = false;
  Map<int, MaskedTextController> textControllers;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  FitnessEnquiryPage(
      {Key key,
      this.facilityItem,
      this.facilityDetail,
      // this.genderList,
      // this.nationalityList,
      this.enquiryDetailId,
      this.screenType,
      this.moduleId})
      : super(key: key);
  @override
  _FitnessEnquiryState createState() => _FitnessEnquiryState();
}

class _FitnessEnquiryState extends State<FitnessEnquiryPage> {
  bool isLoaded = false;
  // int moduleId = 0;
  static final borderColor = Colors.grey[200];
  GenderResponse selectedGenderValue = GenderResponse();
  NationalityResponse selectedNationalityValue = NationalityResponse();
  MaskedTextController _fNameController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController _lNameController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController _commentController =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  TextEditingController nationalityController = new TextEditingController();
  TextEditingController genderController = new TextEditingController();
  TextEditingController _customDobController = new TextEditingController();
  // TextEditingController _customFromController = new TextEditingController();
  // TextEditingController _customToController = new TextEditingController();

  MaskedTextController _fEmiratesIdController =
      new MaskedTextController(mask: Strings.maskEmiratesIdValidationStr);
  MaskedTextController _addressController =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  TextEditingController _customStartTimeController =
      new TextEditingController();
  final GlobalKey<FormBuilderState> basicInfoTwoFormKey =
      GlobalKey<FormBuilderState>();
  List<GenderResponse> genderList = [];
  List<CustomDropDownInput> genderCustomDropDownInputList = [];
  List<NationalityResponse> nationalityList = [];
  List<CustomDropDownInput> nationalityCustomDropDownInputList = [];
  var serverReceiverPath = URLUtils().getImageUploadUrl();
  var serverTestPath = URLUtils().getImageResultUrl();
  List<TimeTable> currentSlots = [];
  PaymentTerms paymentTerms = new PaymentTerms();
  // MaskedTextController _contactNameController =
  //     new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  // MaskedTextController _contactRelation =
  //     new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  // MaskedTextController _contactMobile =
  //     new MaskedTextController(mask: Strings.maskMobileValidationStr);
  // TextEditingController _contactEmail = new TextEditingController();
  File file;
  String newFileName = "";
  // CalendarController _controller = new CalendarController();
  // List<DropdownMenuItem<Trainers>> _facultyDropdownList = [];
  Trainers _faculty = new Trainers();
  Map<int, MaskedTextController> _textControllers =
      new Map<int, MaskedTextController>();
  // MaskedTextController _textTrainerControllers =
  //     new MaskedTextController(mask: Strings.maskEngValidationStr);
  Map<int, MemberQuestionsResponse> _questionDropdownAnswer =
      new Map<int, MemberQuestionsResponse>();
  Map<int, bool> _questionsChecked = new Map<int, bool>();
  bool valuefirst = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white,
  );
  // MaskedTextController _textFamilyMemberControllers =
  //     new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _textLanguageControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  // MaskedTextController _textRelationControllers =
  //     new MaskedTextController(mask: Strings.maskEngValidationStr);

  FamilyMember _member = new FamilyMember();
  // EnquiryLanguage _enquiryLanguage = new EnquiryLanguage();
  // EnquiryRelation _enquiryRelation = new EnquiryRelation();
  bool saveInProgress = false;
  ProgressBarHandler _handler;
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();

  bool isCheckall = false;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    Constants.INIT_DATETIME = DateTime.parse(
        SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is FitnessShowProgressBar) {
            _handler.show();
          } else if (state is FitnessHideProgressBar) {
            _handler.dismiss();
          } else if (state is FitnessGetPaymentTermsResult) {
            paymentTerms = state.paymentTerms;
          } else if (state is FitnessEnquiryShowImageState) {
            debugPrint("File not found");
            if (state.file != null) {
              _textControllers = widget.textControllers;
              debugPrint("File  found");
              file = state.file;
              newFileName = state.file.path?.split("/")?.last;
              await uploadImage(state.file.path, null);
            } else {
              debugPrint("File not found");
            }
          } else if (state is FitnessEnquiryShowImageCameraState) {
            if (state.file != null) {
              _textControllers = widget.textControllers;
              file = state.file;
              newFileName = state.file.path?.split("/")?.last;
              debugPrint(newFileName);
              await uploadImage(null, state.file);
            } else {
              debugPrint("File not found");
            }
          } else if (state is FitnessEnquirySaveState) {
            saveInProgress = false;
            if (state.error == "Success") {
              if ((widget.facilityDetail.facilityId == 3 ||
                      widget.facilityDetail.facilityId == 2 ||
                      widget.facilityDetail.facilityId == 1) &&
                  widget.screenType == Constants.Screen_Add_Enquiry) {
                int enquiryDetailId = jsonDecode(state.message)['response'];
                widget.enquiryDetailId = enquiryDetailId;
                BlocProvider.of<FitnessBloc>(context).add(
                    FitnessEnquiryTermsData(
                        facilityId: widget.facilityDetail.facilityId,
                        facilityItemId: widget.facilityItem.facilityItemId,
                        enquiryDetailId: enquiryDetailId));
                widget.screenType = Constants.Screen_Questioner;
              } else {
                if (widget.facilityDetail.facilityId == 3 &&
                    widget.screenType == Constants.Screen_Questioner) {
                  if (state.proceedToPay) {
                    widget.enquiryDetail.enquiryStatusId =
                        Constants.Work_Flow_Payment;
                    print(
                        "Iam here-------------------------------------------------" +
                            widget.facilityItem.facilityItemId.toString());
                    Meta m = await FacilityDetailRepository().getDiscountList(
                        widget.facilityDetail.facilityId, getTotal(),
                        itemId: widget.facilityItem.facilityItemId);
                    List<BillDiscounts> billDiscounts = [];
                    if (m.statusCode == 200) {
                      jsonDecode(m.statusMsg)['response'].forEach((f) =>
                          billDiscounts.add(new BillDiscounts.fromJson(f)));
                    }
                    if (billDiscounts == null) {
                      billDiscounts = [];
                    }
                    List<GiftVocuher> vouchers = [];
                    var v = new GiftVocuher();
                    v.giftCardText = "Select Voucher";
                    v.balanceAmount = 0;
                    v.giftVoucherId = 0;
                    vouchers.add(v);
                    Meta m1 =
                        await FacilityDetailRepository().getGiftVouchers();
                    if (m1.statusCode == 200) {
                      jsonDecode(m1.statusMsg)['response'].forEach(
                          (f) => vouchers.add(new GiftVocuher.fromJson(f)));
                    }
                    // Disable collage
                    if (vouchers == null) {
                      vouchers = [];
                    }
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EnquiryPayment(
                                enquiryDetail: widget.enquiryDetail,
                                facilityItem: widget.facilityItem,
                                facilityDetail: widget.facilityDetail,
                                billDiscounts: billDiscounts,
                                giftVouchers: vouchers,
                                paymentTerms: paymentTerms,
                              )),
                    );
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacilityDetailsPage(
                              facilityId: widget.facilityDetail.facilityId)),
                    );
                    customGetSnackBarWithOutActionButton(
                        tr("enquiry"), state.message, context);
                  }
                } else {
                  if ((widget.facilityDetail.facilityId ==
                              Constants.FacilitySpa ||
                          widget.facilityDetail.facilityId ==
                              Constants.FacilityBeauty) &&
                      widget.screenType == Constants.Screen_Add_Enquiry) {
                    showDialog<Widget>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext pcontext) {
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
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Center(
                                    child: Text(
                                      tr("enquiry"),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr("currFontFamily"),
                                        fontWeight: FontWeight.w500,
                                        fontSize: Styles.textSizeSmall,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Center(
                                    child: Text(
                                      tr('enquiry_submission'),
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor,
                                          fontSize: Styles.textSiz,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: tr("currFontFamily")),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(ColorData.colorBlue),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                              Radius.circular(5.0),
                                            )))),
                                        // shape: RoundedRectangleBorder(
                                        //     borderRadius: BorderRadius
                                        //         .all(Radius
                                        //         .circular(
                                        //         5.0))),
                                        // color: ColorData
                                        //     .colorBlue,
                                        child: new Text(
                                          "Ok",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Styles.textSizeSmall,
                                              fontFamily: tr("currFontFamily")),
                                        ),
                                        onPressed: () async {
                                          Navigator.of(pcontext).pop();
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FacilityDetailsPage(
                                                        facilityId: widget
                                                            .facilityDetail
                                                            .facilityId)),
                                          );
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
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacilityDetailsPage(
                              facilityId: widget.facilityDetail.facilityId)),
                    );
                    customGetSnackBarWithOutActionButton(
                        tr("enquiry"), tr("submitted_for_review"), context);
                  }
                }
              }
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          } else if (state is FitnessEnquiryEditState) {
            if (state.error == "Success") {
              List<FacilityItems> selectedFacilityItems = [];
              selectedFacilityItems.add(widget.facilityItem);
              // double totalItems = 1;
              double total = widget.facilityItem.price;
              Meta m = await FacilityDetailRepository().getDiscountList(
                  widget.facilityDetail.facilityId, total,
                  itemId: widget.facilityItem.facilityItemId);
              List<BillDiscounts> billDiscounts = [];
              // new List<BillDiscounts>();
              if (m.statusCode == 200) {
                jsonDecode(m.statusMsg)['response'].forEach(
                    (f) => billDiscounts.add(new BillDiscounts.fromJson(f)));
              }
              if (billDiscounts == null) {
                // billDiscounts = new List<BillDiscounts>();
                billDiscounts = [];
              }
              List<GiftVocuher> vouchers = [];
              var v = new GiftVocuher();
              v.giftCardText = "Select Voucher";
              v.balanceAmount = 0;
              v.giftVoucherId = 0;
              vouchers.add(v);
              Meta m1 = await FacilityDetailRepository().getGiftVouchers();
              if (m1.statusCode == 200) {
                jsonDecode(m1.statusMsg)['response']
                    .forEach((f) => vouchers.add(new GiftVocuher.fromJson(f)));
              }
              // Disable collage
              if (vouchers == null) {
                vouchers = [];
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new FitnessBuyPaymentPage(
                        facilityItems: selectedFacilityItems,
                        total: total,
                        enquiryDetailId: widget.enquiryDetailId,
                        itemCounts: itemCounts,
                        retailItemSetId: "",
                        facilityId: widget.facilityDetail.facilityId,
                        tableNo: 0,
                        colorCode: widget.facilityDetail.facilityId == 1
                            ? "A81B8D"
                            : widget.facilityDetail.facilityId == 2
                                ? "A81B8D"
                                : "A81B8D", //widget.facilityDetail.colorCode,
                        billDiscounts: billDiscounts,
                        giftVouchers: vouchers,
                        paymentTerms: paymentTerms,
                        moduleId: widget.facilityDetail.facilityId == 1
                            ? 14
                            : widget.facilityDetail.facilityId == 2
                                ? 13
                                : widget.facilityDetail.facilityId == 3
                                    ? 11
                                    : 0,
                        screenCode: widget.moduleId),
                  ));
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          } else if (state is FitnessEnquiryCancelState) {
            if (state.error == "Success") {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityDetailsPage(
                        facilityId: widget.facilityDetail.facilityId)),
              );
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), tr("cancel_success"), context);
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          } else if (state is FitnessEnquiryTermsState) {
            if (state.termsList != null) {
              setState(() {
                widget.termsList = state.termsList;
                widget.importantTerms = widget.termsList
                    .where((element) => element.isImportant)
                    .toList();
                widget.enquiryDetail = state.enquiryDetail;
                widget.memberQuestions = state.memberQuestions;
                widget.userProfileInfo = state.userProfileInfo;
                widget.trainers = state.trainers;
                widget.familyMembers = state.familyMembers;
                // if (widget.facilityDetail.facilityId !=
                //         Constants.FacilityMembership &&
                //     widget.enquiryDetail.enquiryStatusId ==
                //         Constants.Work_Flow_AcceptTerms) {
                widget.showContract = false;
                // }
              });
            } else if (state.trainers != null) {
              setState(() {
                widget.enquiryDetail = state.enquiryDetail;
                widget.userProfileInfo = state.userProfileInfo;
                widget.trainers = state.trainers;
              });
            }
            if (widget.trainers != null && widget.trainers.length > 0) {
              BlocProvider.of<FitnessBloc>(context).add(
                  FitnessEnquiryTimeTableData(
                      enquiryDetailId: widget.enquiryDetail.enquiryDetailId,
                      trainerId: widget.trainers[0].trainersID,
                      fromDate: widget.selectedDate,
                      facilityItemId: 0));
              setState(() {
                _faculty = widget.trainers[0];
                // debugPrint("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
              });
            }
          } else if (state is FitnessEnquiryTimeTableState) {
            if (state.enquiryDetailResponse != null &&
                state.enquiryDetailResponse.enquiryDetailId != null &&
                state.enquiryDetailResponse.enquiryDetailId != 0) {
              setState(() {
                widget.enquiryDetail = state.enquiryDetailResponse;
              });
            }
            if (state.timeTables != null) {
              setState(() {
                currentSlots = state.timeTables;
                isLoaded = true;
                // debugPrint("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
              });
            } else {
              setState(() {
                currentSlots.clear();
              });
            }
          } else if (state is FitnessEnquiryReloadState) {
            if (state.enquiryDetailResponse != null) {
              setState(() {
                widget.enquiryDetail = state.enquiryDetailResponse;
              });
            }
          } else if (state is FitnessEnquiryQuestionSaveState) {
            debugPrint("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
            if (state.error == "Success") {
              String result = await uploadSignature();
              if (result != "Ok") {
                customGetSnackBarWithOutActionButton(
                    "Signature", "Signature Required", context);
                return;
              }
              debugPrint("comig inside question save");
              BlocProvider.of<FitnessBloc>(context).add(FitnessEnquiryEditEvent(
                  enquiryDetailId: widget.enquiryDetailId,
                  enquiryStatusId: Constants.Work_Flow_Payment,
                  isActive: true,
                  enquiryProcessId: 0));
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorData.backgroundColor,
            appBar: AppBar(
              shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30))),
              automaticallyImplyLeading: true,
              title: Text(
                  widget.moduleId == 4
                      ? tr("package_details")
                      : tr("membership_dtl"),
                  style: TextStyle(color: Colors.blue[200])),
              centerTitle: true,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                color: Colors.blue[200],
                onPressed: () {
                  Navigator.pop(context);
                  if (widget.moduleId == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FacilityDetailsPage(
                              facilityId: widget.facilityDetail.facilityId)),
                    );
                  } else if (widget.moduleId == 4) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonalTrainingPage(
                                screenType: 1, colorCode: "A81B8D")));
                  } else if (widget.moduleId == 1) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymEntryPage(
                                screenType: 1, colorCode: "A81B8D")));
                  } else if (widget.moduleId == 2) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GymEntryPage(
                                screenType: 2, colorCode: "A81B8D")));
                  }
                },
              ),
              backgroundColor: Colors.white,
            ),
            body:
                // BlocBuilder<FitnessBloc, FitnessState>(builder: (context, state) {
                Stack(
              children: [
                SizedBox(
                  height: screenHeight,
                  child: Image.asset(
                    "assets/images/fitness_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: screenHeight * 0.770,
                        width: screenWidth,
                        child: SingleChildScrollView(
                            child: Container(
                                margin: EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    // width: 1,
                                    color: Colors.grey[200],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.transparent,
                                ),
                                child: Column(children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .16,
                                    width:
                                        MediaQuery.of(context).size.width * .98,
                                    child: getItemList(),
                                  ),
                                  ExpansionTile(
                                      title: SizedBox(
                                        child: Text(
                                          tr('questionnaire') + " *",
                                          style: Styles.textSmallWithPurple,
                                        ),
                                      ),
                                      children: [getQuestions(context)]),
                                  ExpansionTile(
                                      title: SizedBox(
                                        child: Text(
                                            tr('upload_your_documents') + " *",
                                            style: Styles.textSmallWithPurple),
                                      ),
                                      children: [
                                        getUpload(context, 0),
                                        widget.enquiryDetail.supportDocuments !=
                                                null
                                            ? getSupportDocuments(0)
                                            : Text(""),
                                        getUpload(context, 1),
                                        widget.enquiryDetail.supportDocuments !=
                                                null
                                            ? getSupportDocuments(1)
                                            : Text(""),
                                        // Container(
                                        //     height: MediaQuery.of(context)
                                        //             .size
                                        //             .height *
                                        //         .20,
                                        //     width: MediaQuery.of(context)
                                        //             .size
                                        //             .width *
                                        //         .96,
                                        //     margin: EdgeInsets.only(
                                        //         left: 2, right: 2),
                                        //     color: Colors.transparent,
                                        //     child: SingleChildScrollView(
                                        //         child: Container(
                                        //       margin: EdgeInsets.only(top: 8.0),
                                        //       child: widget.enquiryDetail
                                        //                   .supportDocuments !=
                                        //               null
                                        //           ? getSupportDocuments()
                                        //           : Text(""),
                                        //     ))),
                                      ]),
                                  ExpansionTile(
                                      title: SizedBox(
                                        child: Text(tr("accept_others") + " *",
                                            style: Styles.textSmallWithPurple),
                                      ),
                                      children: [getTerms(context)]),
                                  ExpansionTile(
                                      title: SizedBox(
                                        child: Text(tr('sign_here') + " *",
                                            style: Styles.textSmallWithPurple),
                                      ),
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.4))),
                                            child: sign.Signature(
                                              controller: _signatureController,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.98,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              backgroundColor: Colors.white,
                                            ))
                                      ]),
                                ]))),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 8),
                        color: Colors.transparent,
                        height: screenHeight * 0.08,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton.icon(
                              // <-- OutlinedButton
                              onPressed: () async {
                                MemberAnswerRequest request =
                                    getQuestionSaveDetails();
                                if (widget.facilityDetail.facilityId ==
                                    Constants.FacilityFitness) {
                                  for (int mq = 0;
                                      mq < request.memberAnswersDto.length;
                                      mq++) {
                                    if (request.memberAnswersDto[mq].answers ==
                                        "") {
                                      customGetSnackBarWithOutActionButton(
                                          tr("enquiry"),
                                          tr("enquiry_answer_questions"),
                                          context);
                                      return;
                                    }
                                  }
                                }

                                if (widget.enquiryDetail.supportDocuments ==
                                        null ||
                                    widget.enquiryDetail.supportDocuments
                                            .length ==
                                        0) {
                                  customAlertPositive(
                                      context,
                                      tr('passport_or_emirates_id'),
                                      tr('close'),
                                      tr('upload_your_documents'),
                                      () => {});
                                  return;
                                }

                                for (int i = 0;
                                    i <= widget.termsList.length - 1;
                                    i++) {
                                  if (!isCheckall) {
                                    customGetSnackBarWithOutActionButton(
                                        tr("enquiry"),
                                        tr("read_and_accept_all_terms"),
                                        context);
                                    return;
                                  }
                                }

                                BlocProvider.of<FitnessBloc>(context).add(
                                    FitnessEnquiryQuestionSaveEvent(
                                        memberAnswerRequest: request));
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: ColorData.fitnessFacilityColor,
                                // side: BorderSide(
                                //     width: 1.0, color: ColorData.fitnessFacilityColor),
                              ),
                              icon: Icon(
                                Icons.add_shopping_cart_rounded,
                                size: 20.0,
                                color: ColorData.whiteColor,
                              ),
                              label: Text(tr('confirm'),
                                  style: TextStyle(
                                    fontSize: Styles.loginBtnFontSize,
                                    color: ColorData.whiteColor,
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ]),
                progressBar
              ],
            ),
            // }
            // ),
          ),
        ));
  }

  EnquiryDetailResponse getEnquiry() {
    EnquiryDetailResponse request = new EnquiryDetailResponse();
    request.facilityId = widget.facilityDetail.facilityId;
    request.facilityItemId = widget.facilityItem.facilityItemId;
    if (_member != null && _member.customerId != null) {
      request.erpCustomerId = _member.customerId;
    } else {
      request.erpCustomerId = 0;
    }
    request.firstName = _fNameController.text.toString();
    request.lastName = _lNameController.text.toString();
    request.enquiryStatusId = 1;
    request.supportDocuments = [];
    request.totalClass = 0;
    request.balanceClass = 0;
    request.consumedClass = 0;
    if (widget.enquiryDetail.contacts != null) {
      request.contacts = widget.enquiryDetail.contacts;
    } else {
      request.contacts = [];
    }
    if (widget.facilityDetail.facilityId == 10 ||
        widget.facilityDetail.facilityId == 11 ||
        widget.facilityDetail.facilityId == 1 ||
        widget.facilityDetail.facilityId == 2 ||
        widget.facilityDetail.facilityId == 3) {
      final String formatted =
          DateFormat('dd-MM-yyyy', 'en_US').format(DateTime.now());
      request.DOB = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(SPUtil.getString(Constants.USER_DOB),
              DateTimeUtils.DD_MM_YYYY_Format),
          DateTimeUtils.dobFormat);
      request.enquiryDate = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(
              formatted.toString(), DateTimeUtils.DD_MM_YYYY_Format),
          DateTimeUtils.dobFormat);
      request.nationalityId = 69;
      request.preferedTime = "";
      request.languages = "";
      request.emiratesID = "";
      request.address = "";
    } else {
      request.DOB = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(_customDobController.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format),
          DateTimeUtils.dobFormat);
      request.enquiryDate = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(_customDobController.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format),
          DateTimeUtils.dobFormat);
      request.nationalityId = selectedNationalityValue.nationalityId;
      request.genderId = selectedGenderValue.genderId;
      request.enquiryDate = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(_customDobController.text.toString(),
              DateTimeUtils.DD_MM_YYYY_Format),
          DateTimeUtils.dobFormat);
      request.preferedTime = _customStartTimeController.text.toString();
      // request.languages = _flanguageController.text.toString();
      request.languages = _textLanguageControllers.text.toString();
      request.emiratesID = _fEmiratesIdController.text.toString();
      request.address = _addressController.text.toString();
    }
    request.genderId = 1;
    request.comments = _commentController.text.toString();
    request.isActive = true;
    request.enquiryTypeId = 1;
    request.countryId = 115;
    request.facilityItemName = widget.facilityItem.facilityItemName;
    request.faclitiyItemDescription = widget.facilityItem.description;
    request.price = widget.facilityItem.price;
    request.vatPercentage = 0;
    request.facilityImageName = "";
    request.facilityImageUrl = "";
    request.enquiryDetailId = 0;
    request.rate = widget.facilityItem.rate;
    return request;
  }

  Widget getItemList() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    List<int> selectedItem = [];
    return SizedBox(
        height: 100,
        width: screenWidth,
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: 1,
            itemBuilder: (context, j) {
              bool showItem = false;
              // selectedItem.add(widget.facilityItems[j].facilityItemId);
              showItem = true;
              return Visibility(
                  visible: showItem,
                  child: Container(
                      margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                      color: Colors.transparent,
                      child: Stack(
                        children: [
                          SizedBox(height: 5),
                          Container(
                            height: MediaQuery.of(context).size.height * .15,
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: borderColor),
                              color: Colors.white,
                            ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                    height: MediaQuery.of(context).size.height *
                                        .17,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8),
                                      ),
                                      child: Image.asset(
                                          'assets/images/3_logo.png',
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.33,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.99,
                                          fit: BoxFit.fill),
                                    )),
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 10.0,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          bottom: 10.0)
                                      : EdgeInsets.only(
                                          top: 10.0,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        widget.facilityItem.facilityItemName,
                                        style: TextStyle(
                                            color:
                                                ColorData.fitnessFacilityColor,
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.10,
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 30.0,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          bottom: 10.0)
                                      : EdgeInsets.only(
                                          top: 30.0,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26,
                                          bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: getHtml(widget
                                                  .facilityItem.description))),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 77,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26)
                                      : EdgeInsets.only(
                                          top: 77,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26),
                                  child: Row(
                                    children: [
                                      Text(
                                        'AED ' +
                                            widget.facilityItem.price
                                                .toStringAsFixed(2) +
                                            '  ',
                                        style: TextStyle(
                                            color:
                                                ColorData.fitnessFacilityColor,
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                      Visibility(
                                          visible:
                                              widget.facilityItem.isDiscountable
                                                  ? true
                                                  : false,
                                          child: Text(tr("discountable"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      Styles.reviewTextSize,
                                                  // fontStyle:
                                                  //     FontStyle.italic,
                                                  backgroundColor: ColorData
                                                      .fitnessFacilityColor)))

                                      //Image.asset(
                                      //    'assets/images/discount.png'))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )));
            }));
  }

  Widget getUpload(BuildContext buildContext, int fileoType) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(left: 8, top: 4, right: 8, bottom: 4),
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 20, top: 4, right: 8, bottom: 4),
        leading: IconButton(
            iconSize: 40,
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey,
            ),
            onPressed: () {
              widget.textControllers = _textControllers;
              if (widget.enquiryDetail.supportDocuments != null &&
                  widget.enquiryDetail.supportDocuments.length <= 2) {
                customAlertPositive(
                    context,
                    fileoType == 0
                        ? tr("passport_or_emirates_id")
                        : tr("medical_document"),
                    tr('close'),
                    tr('documents'),
                    () => {displayModalBottomSheet(context)});
                return;
              } else {
                customAlertPositive(
                    context,
                    tr("Can't able to upload more than two documents"),
                    tr('close'),
                    tr('documents'),
                    () => {});
              }
              // displayModalBottomSheet(
              //     context);
            } //=> getImageFromGallery(),
            ),
        title: Text(
          fileoType == 0
              ? tr('upload_passport_emirates_id')
              : tr('upload_medical_documents'),
          style: TextStyle(
              color: ColorData.primaryTextColor,
              fontSize: Styles.textSiz,
              fontFamily: tr("currFontFamilyEnglishOnly")),
        ),
      ),
    );
  }

  Widget getTerms(BuildContext buildContext) {
    return SingleChildScrollView(
        child: Container(
            // decoration:
            //     BoxDecoration(border: Border.all(width: 1, color: Colors.grey[400])),
            margin: EdgeInsets.only(top: 8.0),
            child: widget.termsList.length == 0
                ? Text("No Terms Defined")
                : Column(
                    children: [
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor: Colors.grey[400]),
                            child: Checkbox(
                                checkColor: Colors.greenAccent,
                                activeColor: Colors.blue,
                                value: isCheckall,
                                onChanged: (bool value) {
                                  debugPrint("===========");
                                  for (int i = 0;
                                      i <= widget.termsList.length - 1;
                                      i++) {
                                    widget.termsList[i].checked = value;
                                    setState(() {
                                      isCheckall = value;
                                    });
                                    setTermsChecked();
                                  }
                                }),
                          ),
                          Text(tr("accept_all"),
                              style: TextStyle(
                                  color: ColorData.primaryTextColor
                                      .withOpacity(1.0),
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily')))
                        ],
                      ),
                      Row(children: [getTermsAndConditions(true)])
                    ],
                  )));
    // ])));
  }

  Widget getHtml(String description) {
    return Wrap(
      children: [
        Html(
          style: {
            "body": Style(
              padding: EdgeInsets.all(0),
              margin: Margins.all(0),
            ),
            "p": Style(
              padding: EdgeInsets.all(0),
              margin: Margins.all(0),
            ),
            "span": Style(
              padding: EdgeInsets.all(0),
              margin: Margins.all(0),
              fontSize: FontSize(Styles.newTextSize),
              fontWeight: FontWeight.normal,
              color: ColorData.cardTimeAndDateColor,
              fontFamily: tr('currFontFamilyEnglishOnly'),
            ),
            "h6": Style(
              padding: EdgeInsets.all(0),
              margin: Margins.all(0),
            ),
          },
          // customFont: tr('currFontFamilyEnglishOnly'),
          // anchorColor: ColorData.primaryTextColor,
          data: description != null
              ? '<html><body>' + description + '</body></html>'
              : tr('noDataFound'),
        )
      ],
    );
  }

  Future<String> uploadImage(filename, file) async {
    debugPrint("I am here Upload");

    var request = new http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            widget.facilityDetail.facilityId.toString() +
            "&eventparticipantid=" +
            widget.enquiryDetailId.toString() +
            "&FileName=" +
            newFileName +
            "&uploadtype=2"));
    // debugPrint(" ddddddd-1 ");
    if (filename != null) {
      request.files.add(await http.MultipartFile.fromPath('picture', filename,
          contentType: new MediaType('image', 'jpeg')));
      // FacilityDetailRepository fm = new FacilityDetailRepository();
      // fm.uploadFitnessEnquiryImage(
      //     null,
      //     serverReceiverPath +
      //         "?id=1&eventid=" +
      //         widget.facilityDetail.facilityId.toString() +
      //         "&eventparticipantid=" +
      //         widget.enquiryDetailId.toString() +
      //         "&FileName=" +
      //         newFileName +
      //         "&uploadtype=2",
      //     filename);
    } else {
      // request.files.add(await http.MultipartFile.fromPath('picture', file.path,
      //     contentType: new MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromBytes(
          'file', await file.readAsBytes(),
          contentType: MediaType('image', 'jpeg'), filename: newFileName));

      // FacilityDetailRepository fm = new FacilityDetailRepository();
      // fm.uploadFitnessEnquiryImage(
      //     null,
      //     serverReceiverPath +
      //         "?id=1&eventid=" +
      //         widget.facilityDetail.facilityId.toString() +
      //         "&eventparticipantid=" +
      //         widget.enquiryDetailId.toString() +
      //         "&FileName=" +
      //         newFileName +
      //         "&uploadtype=2",
      //     file.path);
    }
    // var res = "";
    // request.send().then((response) {
    //   if (response.statusCode == 200) {
    //     res = response != null ? response.reasonPhrase : " Notototoototo";
    //     customGetSnackBarWithOutActionButton(
    //         tr("document_upload"), tr('file_uploaded_successfully'), context);
    //   } else {
    //     customGetSnackBarWithOutActionButton(
    //         tr("document_upload"), "Not Uploaded", context);
    //   }
    // });
    // log(request.toString());
    var res = await request.send();
    // debugPrint(" ddddddd " + res.toString());
    customGetSnackBarWithOutActionButton(
        tr("document_upload"), tr('file_uploaded_successfully'), context);
    BlocProvider.of<FitnessBloc>(context).add(FitnessEnquiryReloadEvent(
        facilityId: widget.facilityDetail.facilityId,
        facilityItemId: widget.facilityItem.facilityItemId,
        enquiryDetailId: widget.enquiryDetail.enquiryDetailId));

    return res.reasonPhrase;
    // return "";
  }

  Future<String> uploadSignature() async {
    debugPrint("I am here Upload");
    if (_signatureController.isEmpty) {
      return "Signature required";
    }
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            widget.facilityDetail.facilityId.toString() +
            "&eventparticipantid=" +
            widget.enquiryDetailId.toString() +
            "&FileName=" +
            "signature.png" +
            "&uploadtype=2"));
    final Uint8List data = await _signatureController.toPngBytes();
    request.files.add(await http.MultipartFile.fromBytes('picture', data,
        filename: "signature.png"));
    var res = await request.send();
    return "Ok";
  }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        trailing: new Icon(Icons.photo_library,
                            color: ColorData.colorBlue),
                        title: new Text('Photo Library'),
                        onTap: () {
                          BlocProvider.of<FitnessBloc>(context)
                              .add(FitnessEnquiryShowImageEvent());
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      trailing: new Icon(Icons.photo_camera,
                          color: ColorData.colorBlue),
                      title: new Text('Take Photo '),
                      onTap: () {
                        BlocProvider.of<FitnessBloc>(context)
                            .add(FitnessEnquiryShowImageCameraEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Widget getSupportDocuments(int fileotype) {
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: Localizations.localeOf(context).languageCode == "en"
            ? EdgeInsets.only(top: 4, left: 10)
            : EdgeInsets.only(top: 4, right: 10),
        title: Text(
            (widget.enquiryDetail.supportDocuments == null ||
                    widget.enquiryDetail.supportDocuments.length <= fileotype)
                ? ""
                : widget
                    .enquiryDetail.supportDocuments[fileotype].documentFileName,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: Styles.packageExpandTextSiz,
              fontFamily: tr('currFontFamily'),
              color: ColorData.primaryTextColor,
            )),
        trailing: Visibility(
            visible: (widget.enquiryDetail.supportDocuments == null ||
                    widget.enquiryDetail.supportDocuments.length <= fileotype)
                ? false
                : true,
            child: Container(
                width: MediaQuery.of(context).size.width * 0.10,
                child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  padding: EdgeInsets.zero,
                  iconSize: 24,
                  color: Colors.blue[200],
                  onPressed: () async {
                    Meta m = await (new FacilityDetailRepository())
                        .deleteUploadedDocument(
                            widget.facilityDetail.facilityId,
                            widget.enquiryDetail.supportDocuments[fileotype]
                                .supportDocumentId
                                .toString());
                    if (m.statusCode == 200) {
                      BlocProvider.of<FitnessBloc>(context).add(
                          FitnessEnquiryReloadEvent(
                              facilityId: widget.facilityDetail.facilityId,
                              facilityItemId:
                                  widget.facilityItem.facilityItemId,
                              enquiryDetailId:
                                  widget.enquiryDetail.enquiryDetailId));
                    } else {
                      customGetSnackBarWithOutActionButton(
                          tr("enquiry"), tr('delete_unsuccessful'), context);
                    }
                  },
                ))),
      ),
    );
  }

  Widget getTermsAndConditions(showImportant) {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey(
                "Terms_" + showImportant.toString() + "_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.termsList.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Visibility(
                  visible: widget.termsList[j].isImportant == showImportant,
                  child: Container(
                    width: showImportant
                        ? MediaQuery.of(context).size.width * 0.90
                        : double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 5, left: 0),
                            child: Column(children: [
                              StatefulBuilder(
                                  builder: (BuildContext context,
                                          StateSetter setState) =>
                                      GestureDetector(
                                        child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    Colors.grey[400]),
                                            child: CheckboxListTile(
                                              title: Text(
                                                  widget.termsList[j].termsName,
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                              checkColor: Colors.greenAccent,
                                              activeColor: Colors.blue,
                                              value: this.valuefirst ||
                                                  widget.termsList[j].checked,
                                              onChanged: (bool value) {
                                                setState(() {
                                                  widget.termsList[j].checked =
                                                      value;
                                                  setTermsChecked();
                                                });
                                              },
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading, //  <-- leading Checkbox
                                            )),
                                      ))
                            ])),
                      ],
                    ),
                  ));
            }));
  }

  Widget getQuestions(BuildContext buildContext) {
    return SingleChildScrollView(
        child: Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.white)),
      child: widget.memberQuestions.length == 0
          ? Text("")
          : Row(children: [getQuestion()]),
    ));
    // ])));
  }

  Widget getQuestion() {
    return SizedBox(
        height: screenHeight * 0.25,
        width: screenWidth * 0.98,
        child: ListView.builder(
            key: PageStorageKey("Questions_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.memberQuestions.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return getQuestionFields(widget.memberQuestions[j], j);
            }));
  }

  Widget getQuestionFields(MemberQuestionGroup questionGroup, int j) {
    if (questionGroup.memberQuestions.length > 0 &&
        questionGroup.memberQuestions[0].questionDisplayType == 1) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                padding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
                width: screenWidth * 0.96,
                // decoration: BoxDecoration(color: Colors.white),
                child: Text(questionGroup.questionGroup,
                    style: TextStyle(
                        fontSize: Styles.newTextSize,
                        color: Theme.of(context).primaryColor,
                        fontFamily: tr('currFontFamily')))),
            // Row(children: [
            //   Expanded(
            //       child: )
            // ]),
            ListView.builder(
                key: PageStorageKey(j.toString() + "_PageStorageKey"),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: questionGroup.memberQuestions.length,
                itemBuilder: (context, i) {
                  //return //Container(child: Text(enquiryDetailResponse[j].firstName));
                  _questionsChecked[questionGroup
                      .memberQuestions[i].memberQuestionId] = false;
                  if (questionGroup.memberQuestions[i].questionAnswer != null) {
                    if (questionGroup.memberQuestions[i].questionAnswer ==
                        "true") {
                      _questionsChecked[questionGroup
                          .memberQuestions[i].memberQuestionId] = true;
                    }
                  }
                  return Column(
                      // height: MediaQuery.of(context).size.height * 0.06,
                      children: [
                        StatefulBuilder(
                            builder: (BuildContext context,
                                    StateSetter setState) =>
                                GestureDetector(
                                  child: Container(
                                    padding: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? EdgeInsets.only(
                                            left: 10,
                                            right: 7,
                                          )
                                        : EdgeInsets.only(right: 10, left: 5),
                                    child: ListTile(
                                      isThreeLine: false,
                                      dense: true,
                                      leading: CircleCheckbox(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          key: PageStorageKey<int>(i),
                                          value: _questionsChecked[questionGroup
                                              .memberQuestions[i]
                                              .memberQuestionId],
                                          onChanged: (bool value) {
                                            setState(() {
                                              _questionsChecked[questionGroup
                                                  .memberQuestions[i]
                                                  .memberQuestionId] = value;
                                            });
                                          }),
                                      title: Container(
                                          color: Colors.white,
                                          child: PackageListHead
                                              .textWithStyleMediumFont(
                                                  context: context,
                                                  contentTitle: questionGroup
                                                      .memberQuestions[i]
                                                      .questionName,
                                                  color: ColorData
                                                      .primaryTextColor,
                                                  fontSize:
                                                      Styles.textSizeSmall)),
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      _questionsChecked[questionGroup
                                              .memberQuestions[i]
                                              .memberQuestionId] =
                                          !_questionsChecked[questionGroup
                                              .memberQuestions[i]
                                              .memberQuestionId];
                                    });
                                  },
                                ))
                      ]);
                })
          ]);
    } else if (questionGroup.memberQuestions.length > 0 &&
        questionGroup.memberQuestions[0].questionDisplayType == 2) {
      _textControllers[questionGroup.memberQuestions[0].memberQuestionId] =
          new MaskedTextController(mask: Strings.maskEngValidationStr);
      if (questionGroup.memberQuestions[0].questionAnswer != null) {
        _textControllers[questionGroup.memberQuestions[0].memberQuestionId]
            .text = questionGroup.memberQuestions[0].questionAnswer;
      }
      return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: FormBuilder(
                    child: Column(children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                    child: LoginPageFieldWhite(
                        _textControllers[
                            questionGroup.memberQuestions[0].memberQuestionId],
                        questionGroup.questionGroup,
                        Strings.countryCodeForNonMobileField,
                        CommonIcons.woman,
                        TextInputTypeFile.textInputTypeName,
                        TextInputAction.done,
                        () => {},
                        () => {}),
                  )
                ])))
          ]);
    } else {
      List<MemberQuestionsResponse> questionResponse = [];
      List<String> result =
          questionGroup.memberQuestions[0].questionOptions.split(':');
      for (int a = 0; a < result.length; a++) {
        MemberQuestionsResponse m = new MemberQuestionsResponse();
        m.questionName = result[a];
        m.memberQuestionId = a + 1;
        questionResponse.add(m);
      }
      if (_textControllers[questionGroup.memberQuestions[0].memberQuestionId] ==
          null) {
        _textControllers[questionGroup.memberQuestions[0].memberQuestionId] =
            new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
        if (questionGroup.memberQuestions[0].questionAnswer != null) {
          _textControllers[questionGroup.memberQuestions[0].memberQuestionId]
              .text = questionGroup.memberQuestions[0].questionAnswer;
        }
      }
      return widget.facilityDetail.facilityId == Constants.FacilityFitness
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                      padding: EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 10, bottom: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(color: ColorData.whiteColor),
                      child: PackageListHead.textWithStyleMediumFont(
                          context: context,
                          contentTitle:
                              questionGroup.memberQuestions[0].questionName,
                          color: ColorData.primaryTextColor,
                          fontSize: Styles.packageExpandTextSiz)),
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: FormBuilder(
                          child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                          child: CustomQuestionComponent(
                              showPrefixIcon: false,
                              selectedFunction: _onChangeQuestionOptionDropdown,
                              questionController: _textControllers[questionGroup
                                  .memberQuestions[0].memberQuestionId],
                              isEditBtnEnabled: Strings.ProfileCallState,
                              questionResponse: questionResponse,
                              label: tr("question_select_option")),
                        )
                      ])))
                ])
          : Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                      width: double.infinity,
                      decoration: BoxDecoration(color: Colors.white),
                      child: FormBuilder(
                          child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                          child: CustomQuestionComponent(
                              showPrefixIcon: true,
                              selectedFunction: _onChangeQuestionOptionDropdown,
                              questionController: _textControllers[questionGroup
                                  .memberQuestions[0].memberQuestionId],
                              isEditBtnEnabled: Strings.ProfileCallState,
                              questionResponse: questionResponse,
                              label: questionGroup.questionGroup),
                        )
                      ])))
                ]);
    }
  }

  MemberAnswerRequest getQuestionSaveDetails() {
    MemberAnswerRequest answerRequest = new MemberAnswerRequest();
    answerRequest.enquiryDetailsId = widget.enquiryDetailId;
    answerRequest.userId = SPUtil.getInt(Constants.USERID);
    List<MemberAnswer> answers = [];
    for (int i = 0; i < widget.memberQuestions.length; i++) {
      MemberQuestionGroup grp = widget.memberQuestions[i];
      for (int j = 0; j < grp.memberQuestions.length; j++) {
        MemberAnswer answer = new MemberAnswer();
        MemberQuestionsResponse qr = grp.memberQuestions[j];
        if (qr.questionDisplayType == 1) {
          answer.memberQuestionsId = qr.memberQuestionId;
          answer.answers = _questionsChecked[qr.memberQuestionId].toString();
        } else {
          answer.memberQuestionsId = qr.memberQuestionId;
          answer.answers = _textControllers[qr.memberQuestionId] != null
              ? _textControllers[qr.memberQuestionId].text.toString()
              : "";
        }
        answers.add(answer);
      }
    }
    answerRequest.memberAnswersDto = answers;
    return answerRequest;
  }

  customGetSnackBarWithOutActionButton(titlemsg, contentmsg, context) {
    return Get.snackbar(
      titlemsg,
      contentmsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }

  _onChangeQuestionOptionDropdown(
      MemberQuestionsResponse question, int questionId) {
    _questionDropdownAnswer[questionId] = question;
    // debugPrint(questionId.toString());
    // setState(() {
    // });
  }

  setTermsChecked() {
    for (int i = 0; i < widget.termsList.length; i++) {
      if (!widget.termsList[i].isImportant && !widget.termsList[i].checked) {
        setState(() {
          this.valuefirst = false;
        });
        return;
      }
    }
    setState(() {
      this.valuefirst = true;
    });
  }

  double getTotal() {
    double total = 0;
    if (widget.facilityDetail.facilityId == Constants.FacilityMembership) {
      if (widget.userProfileInfo.price != null) {
        total = widget.userProfileInfo.price;
        for (int i = 0;
            i < widget.userProfileInfo.associatedProfileList.length;
            i++) {
          total = total + widget.userProfileInfo.associatedProfileList[i].price;
        }
      }
    } else {
      total = widget.enquiryDetail.price;
    }
    return total;
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> dropdownMenuItemList;
  final ValueChanged<T> onChanged;
  final T value;
  final bool isEnabled;
  CustomDropdown({
    Key key,
    @required this.dropdownMenuItemList,
    @required this.onChanged,
    @required this.value,
    this.isEnabled = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Container(
        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            color: isEnabled ? Colors.white : Colors.blue[400]),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isExpanded: true,
            itemHeight: 50.0,
            style: TextStyle(
                fontSize: 15.0,
                color: isEnabled ? Colors.black : Colors.blue[400]),
            items: dropdownMenuItemList,
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}

class Category {
  final String categoryName;
  Category({
    this.categoryName,
  });
}
