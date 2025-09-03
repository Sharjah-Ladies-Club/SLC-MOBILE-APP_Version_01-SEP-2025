// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as uiprefix;

// import 'package:circle_checkbox/redev_checkbox.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_question_select_component.dart';
import 'package:slc/common/custom_trainer_select_component.dart';
import 'package:slc/common/custom_member_select_component.dart';
import 'package:slc/common/custom_language_select_component.dart';
import 'package:slc/common/custom_relation_select_component.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code_picker.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';

import 'package:slc/customcomponentfields/custom_dob_component.dart';
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
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:http/http.dart' as http;
import 'package:slc/view/enquiry/bloc/bloc.dart';
import 'package:slc/view/enquiry/enquiry_payment.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:signature/signature.dart' as sign;


class NewEnquiry extends StatelessWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  List<GenderResponse> genderList = [];
  List<NationalityResponse> nationalityList =[];
  int enquiryDetailId = 0;
  int screenType = 0;
  List<TermsCondition> termsList = [];
  UserProfileInfo userProfileInfo = new UserProfileInfo();

  NewEnquiry({
    this.facilityItem,
    this.facilityDetail,
    this.genderList,
    this.nationalityList,
    this.enquiryDetailId,
    this.screenType,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EnquiryBloc>(
      create: (context) => EnquiryBloc()
        ..add(new EnquiryTermsData(
            facilityId: this.facilityDetail.facilityId,
            facilityItemId: this.facilityItem.facilityItemId,
            enquiryDetailId: enquiryDetailId))..add(GetPaymentTerms(facilityId: this.facilityDetail.facilityId)),

      child: NewEnquiryPage(
        facilityItem: this.facilityItem,
        facilityDetail: this.facilityDetail,
        genderList: this.genderList,
        nationalityList: this.nationalityList,
        enquiryDetailId: this.enquiryDetailId,
        screenType: this.screenType,
      ),
    );
  }
}

class NewEnquiryPage extends StatefulWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  List<GenderResponse> genderList = [];
  List<NationalityResponse> nationalityList =[];
  int enquiryDetailId = 0;
  int screenType = 0;
  List<TermsCondition> termsList =  [];
  List<TermsCondition> importantTerms = [];
  EnquiryDetailResponse enquiryDetail = new EnquiryDetailResponse();
  List<MemberQuestionGroup> memberQuestions = [];
  List<Trainers> trainers =[];
  List<FamilyMember> familyMembers = [];
  String selectedDate = "";
  int showDetail = 0;
  bool checkAll = false;
  UserProfileInfo userProfileInfo = new UserProfileInfo();
  bool showContract = false;
  NewEnquiryPage(
      {Key key,
      this.facilityItem,
      this.facilityDetail,
      this.genderList,
      this.nationalityList,
      this.enquiryDetailId,
      this.screenType})
      : super(key: key);
  @override
  _NewEnquiryState createState() => _NewEnquiryState();
}

class _NewEnquiryState extends State<NewEnquiryPage> {
  bool isLoaded = false;
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
  TextEditingController _customFromController = new TextEditingController();
  TextEditingController _customToController = new TextEditingController();
  // MaskedTextController _flanguageController =
  //     new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
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
  List<CustomDropDownInput> nationalityCustomDropDownInputList =[];
  var serverReceiverPath = URLUtils().getImageUploadUrl();
  var serverTestPath = URLUtils().getImageResultUrl();
  List<TimeTable> currentSlots =[];
  PaymentTerms paymentTerms = new PaymentTerms();
  MaskedTextController _contactNameController =
      new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  // MaskedTextController _contactRelation =
  //     new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
  MaskedTextController _contactMobile =
      new MaskedTextController(mask: Strings.maskMobileValidationStr);
  TextEditingController _contactEmail =
      new TextEditingController();
  File file;
  String newFileName = "";
  CalendarController _controller = new CalendarController();
  List<DropdownMenuItem<Trainers>> _facultyDropdownList =
      [];
  Trainers _faculty = new Trainers();
  Map<int, MaskedTextController> _textControllers =
      new Map<int, MaskedTextController>();
  MaskedTextController _textTrainerControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  Map<int, MemberQuestionsResponse> _questionDropdownAnswer =
      new Map<int, MemberQuestionsResponse>();
  Map<int, bool> _questionsChecked = new Map<int, bool>();
  bool valuefirst = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white,
  );
  MaskedTextController _textFamilyMemberControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _textLanguageControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);
  MaskedTextController _textRelationControllers =
      new MaskedTextController(mask: Strings.maskEngValidationStr);

  FamilyMember _member = new FamilyMember();
  EnquiryLanguage _enquiryLanguage = new EnquiryLanguage();
  EnquiryRelation _enquiryRelation = new EnquiryRelation();
  bool saveInProgress = false;
  ProgressBarHandler _handler;

  @override
  void initState() {
    Constants.INIT_DATETIME = DateTime.parse(
        SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat());
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
    return BlocListener<EnquiryBloc, EnquiryState>(
        listener: (context, state) async {
          if(state is ShowProgressBar) {
            _handler.show();
          }
          else if(state is HideProgressBar) {
            _handler.dismiss();
          }
          else if (state is GetPaymentTermsResult){
            paymentTerms = state.paymentTerms;
            debugPrint("Terms................................."+ paymentTerms.toString());
          }
          else if (state is EnquiryNewShowImageState) {
            debugPrint("File not found");
            if (state.file != null) {
              debugPrint("File  found");
              file = state.file;
              newFileName = state.file.path?.split("/")?.last;
              await uploadImage(state.file.path);
            } else {
              debugPrint("File not found");
            }
          }
          else if (state is EnquiryShowImageCameraState) {
            if (state.file != null) {
              file = state.file;
              newFileName = state.file.path?.split("/")?.last;
              debugPrint(newFileName);
              await uploadImage(state.file.path);
            } else {
              debugPrint("File not found");
            }
          }
          else if (state is EnquirySaveState) {
            saveInProgress = false;
            if (state.error == "Success") {
              if (widget.facilityDetail.facilityId == 3 &&
                  widget.screenType == Constants.Screen_Add_Enquiry) {
                int enquiryDetailId = jsonDecode(state.message)['response'];
                widget.enquiryDetailId = enquiryDetailId;
                  BlocProvider.of<EnquiryBloc>(context).add(EnquiryTermsData(
                    facilityId: widget.facilityDetail.facilityId,
                    facilityItemId: widget.facilityItem.facilityItemId,
                    enquiryDetailId: enquiryDetailId));
                widget.screenType = Constants.Screen_Questioner;
              } else {
                if (widget.facilityDetail.facilityId == 3 &&
                    widget.screenType == Constants.Screen_Questioner) {
                  if(state.proceedToPay){
                    widget.enquiryDetail.enquiryStatusId =
                        Constants.Work_Flow_Payment;
                    Meta m = await FacilityDetailRepository().getDiscountList(
                        widget.facilityDetail.facilityId, getTotal());
                    List<BillDiscounts> billDiscounts =[];
                    if (m.statusCode == 200) {

                      jsonDecode(m.statusMsg)['response'].forEach((f) =>
                          billDiscounts.add(new BillDiscounts.fromJson(f)));
                    }
                    if (billDiscounts == null) {
                      billDiscounts = [];
                    }
                    List<GiftVocuher> vouchers =[];
                    var v = new GiftVocuher();
                    v.giftCardText = "Select Voucher";
                    v.balanceAmount = 0;
                    v.giftVoucherId = 0;
                    vouchers.add(v);
                    Meta m1 = await FacilityDetailRepository()
                        .getGiftVouchers();
                    if (m1.statusCode == 200) {
                      jsonDecode(m1.statusMsg)['response'].forEach(
                              (f) => vouchers
                              .add(new GiftVocuher.fromJson(f)));
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

                  }else{
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
                  if ((widget.facilityDetail.facilityId == Constants.FacilitySpa
                      || widget.facilityDetail.facilityId == Constants.FacilityBeauty) &&
                      widget.screenType == Constants.Screen_Add_Enquiry) {
                    showDialog<Widget>(
                      context: context,
                      barrierDismissible:
                      false, // user must tap button!
                      builder: (BuildContext pcontext) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(14)),
                          ),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              mainAxisSize:
                              MainAxisSize.min,
                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .stretch,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0),
                                  child: Center(
                                    child: Text(
                                      tr("enquiry"),
                                      textAlign:
                                      TextAlign.center,
                                      style: TextStyle(
                                        color: ColorData
                                            .primaryTextColor,
                                        fontFamily: tr(
                                            "currFontFamily"),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: Styles
                                            .textSizeSmall,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0),
                                  child: Center(
                                    child: Text(
                                      tr('enquiry_submission'),
                                      style: TextStyle(
                                          color: ColorData
                                              .primaryTextColor,
                                          fontSize: Styles
                                              .textSiz,
                                          fontWeight:
                                          FontWeight
                                              .w400,
                                          fontFamily: tr(
                                              "currFontFamily")),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceEvenly,
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                            MaterialStateProperty.all<Color>(Colors.white),
                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                ColorData.colorBlue),
                                            shape:
                                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.all(
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
                                              color: Colors
                                                  .white,
                                              fontSize: Styles
                                                  .textSizeSmall,
                                              fontFamily: tr(
                                                  "currFontFamily")),
                                        ),
                                        onPressed:
                                            () async {
                                          Navigator.of(
                                              pcontext)
                                              .pop();
                                          Navigator.pop(context);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FacilityDetailsPage(
                                                        facilityId: widget.facilityDetail
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
                  }else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              FacilityDetailsPage(
                                  facilityId: widget.facilityDetail
                                      .facilityId)),
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
          }
          else if (state is EnquiryEditState) {
            if (state.error == "Success") {
              if (widget.facilityDetail.facilityId ==
                      Constants.FacilityMembership &&
                  state.workFlow == Constants.Work_Flow_Signature) {
                if (widget.screenType != Constants.Screen_Signature) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  /*Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FacilityDetailsPage(
                            facilityId: widget.facilityDetail.facilityId)),
                  );*/
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewEnquiry(
                          facilityItem: widget.enquiryDetail.facilityItem,
                          facilityDetail: widget.facilityDetail,
                          enquiryDetailId: widget.enquiryDetail.enquiryDetailId,
                          screenType: Constants.Work_Flow_Signature),
                    ),
                  );
                  customGetSnackBarWithOutActionButton(
                      tr("enquiry"), tr('terms_accepted'), context);
                }
              } else if (widget.facilityDetail.facilityId ==
                      Constants.FacilityMembership &&
                  state.workFlow == Constants.Work_Flow_Payment) {
                Meta pm = await ProfileRepo().getEnquiryProfileDetail();
                UserProfileInfo userEnquiryProfileInfo =
                    new UserProfileInfo.fromJson(
                        jsonDecode(pm.statusMsg)["response"]);
                double total = 0;
                if (userEnquiryProfileInfo.price != null) {
                  total = userEnquiryProfileInfo.price;
                  for (int i = 0;
                      i < userEnquiryProfileInfo.associatedProfileList.length;
                      i++) {
                    total = total +
                        userEnquiryProfileInfo.associatedProfileList[i].price;
                  }
                }
                Meta m = await FacilityDetailRepository()
                    .getDiscountList(widget.facilityDetail.facilityId, total,itemId:widget.enquiryDetail.facilityItem.facilityItemId);
                List<BillDiscounts> billDiscounts = [];
                if (m.statusCode == 200) {

                      jsonDecode(m.statusMsg)['response'].forEach((f) =>
                          billDiscounts.add(new BillDiscounts.fromJson(f)));
                }
                if (billDiscounts == null) {
                  billDiscounts =[];
                }
                List<GiftVocuher> vouchers =[];
                var v = new GiftVocuher();
                v.giftCardText = "Select Voucher";
                v.balanceAmount = 0;
                v.giftVoucherId = 0;
                vouchers.add(v);
                Meta m1 = await FacilityDetailRepository()
                    .getGiftVouchers();
                if (m1.statusCode == 200) {
                  jsonDecode(m1.statusMsg)['response'].forEach(
                          (f) => vouchers
                          .add(new GiftVocuher.fromJson(f)));
                }
                // Disable collage
                if (vouchers == null) {
                  vouchers =[];
                }
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EnquiryPayment(
                            enquiryDetail: widget.enquiryDetail,
                            facilityItem: widget.enquiryDetail.facilityItem,
                            facilityDetail: widget.facilityDetail,
                            userProfileInfo: userEnquiryProfileInfo,
                            billDiscounts: billDiscounts,
                        giftVouchers: vouchers,
                        paymentTerms :paymentTerms
                          )),
                );
              } else if (
                  // widget.facilityDetail.facilityId ==
                  //         Constants.FacilityMembership &&
                  state.workFlow == Constants.Work_Flow_UploadDocuments) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacilityDetailsPage(
                          facilityId: widget.facilityDetail.facilityId)),
                );
                customGetSnackBarWithOutActionButton(tr('document_upload'),
                    tr('file_uploaded_successfully'), context);
              } else {
                widget.enquiryDetail.enquiryStatusId =
                    Constants.Work_Flow_Payment;
                Meta m = await FacilityDetailRepository().getDiscountList(
                    widget.facilityDetail.facilityId, getTotal());
                List<BillDiscounts> billDiscounts =[];
                if (m.statusCode == 200) {

                      jsonDecode(m.statusMsg)['response'].forEach((f) =>
                          billDiscounts.add(new BillDiscounts.fromJson(f)));
                }
                if (billDiscounts == null) {
                  billDiscounts =[];
                }
                List<GiftVocuher> vouchers =[];
                var v = new GiftVocuher();
                v.giftCardText = "Select Voucher";
                v.balanceAmount = 0;
                v.giftVoucherId = 0;
                vouchers.add(v);
                Meta m1 = await FacilityDetailRepository()
                    .getGiftVouchers();
                if (m1.statusCode == 200) {
                  jsonDecode(m1.statusMsg)['response'].forEach(
                          (f) => vouchers
                          .add(new GiftVocuher.fromJson(f)));
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
                            userProfileInfo: widget.userProfileInfo,
                            billDiscounts: billDiscounts,
                        giftVouchers: vouchers,
                        paymentTerms: paymentTerms,
                          )),
                );
                customGetSnackBarWithOutActionButton(
                    tr("enquiry"), tr('terms_accepted'), context);
              }
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          }
          else if (state is EnquiryCancelState) {
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
          }
          else if (state is EnquiryTermsState) {
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
                if (widget.facilityDetail.facilityId !=
                        Constants.FacilityMembership &&
                    widget.enquiryDetail.enquiryStatusId ==
                        Constants.Work_Flow_AcceptTerms) {
                  widget.showContract = false;
                }
              });
            } else if (state.trainers != null) {
              setState(() {
                widget.enquiryDetail = state.enquiryDetail;
                widget.userProfileInfo = state.userProfileInfo;
                widget.trainers = state.trainers;
              });
            }
            if (widget.trainers != null && widget.trainers.length > 0) {
              BlocProvider.of<EnquiryBloc>(context).add(EnquiryTimeTableData(
                  enquiryDetailId: widget.enquiryDetail.enquiryDetailId,
                  trainerId: widget.trainers[0].trainersID,
                  fromDate: widget.selectedDate,
                  facilityItemId: 0));
              setState(() {
                _faculty = widget.trainers[0];
                debugPrint("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ");
              });

            }
          }
          else if (state is EnquiryTimeTableState) {
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
                debugPrint("IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII");
              });
            } else {
              setState(() {
                currentSlots.clear();
              });
            }
          }
          else if (state is EnquiryReloadState) {
            if (state.enquiryDetailResponse != null) {
              setState(() {
                widget.enquiryDetail = state.enquiryDetailResponse;
              });
            }
          }
          else if (state is EnquiryQuestionSaveState) {
            if (state.error == "Success") {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), tr("question_submit_review"), context);
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FacilityDetailsPage(
                            facilityId: widget.facilityDetail.facilityId)),
              );
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("enquiry"), state.error, context);
            }
          }
        },
        child: Scaffold(
          backgroundColor: ColorData.backgroundColor,
          appBar: AppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            automaticallyImplyLeading: true,
            title: Text(
                widget.facilityDetail.facilityId == Constants.FacilityMembership
                    ? tr("membership_renewal")
                    : widget.facilityDetail.facilityId ==
                            Constants.FacilityCollage
                        ? tr("course_details")
                        : tr("customer_details"),
                style: TextStyle(color: Colors.blue[200])),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blue[200],
              onPressed: () {
                _handler.show();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacilityDetailsPage(
                          facilityId: widget.facilityDetail.facilityId)),
                );
                _handler.dismiss();
              },
            ),
            backgroundColor: Colors.white,
          ),
          body:
              BlocBuilder<EnquiryBloc, EnquiryState>(builder: (context, state) {
            return Stack(children:[SingleChildScrollView(
                child:Container(
                    // color: Colors.white,
                    margin: EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        // width: 1,
                        color: Colors.grey[200],
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 8, right: 8),
                          height: widget.facilityDetail.facilityId ==
                                  Constants.FacilityMembership
                              ? MediaQuery.of(context).size.height * 0.274
                              : MediaQuery.of(context).size.height * 0.205,
                          width: MediaQuery.of(context).size.width * 0.96,
                          decoration: BoxDecoration(
                            border: Border.all(
                              // width: 1,
                              color: Colors.grey[200],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: widget.screenType == Constants.Screen_Signature
                              ? Column(children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      decoration:
                                          BoxDecoration(color: Colors.white),
                                      child: Stack(children: [
                                        Padding(
                                            padding: EdgeInsets.only(
                                                top: 10, left: 20, right: 20),
                                            child: Text(tr('sign_here'),
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor,
                                                    fontSize:
                                                        Styles.textSizeSmall,
                                                    fontWeight: FontWeight.w500,
                                                    fontFamily:
                                                        tr('currFontFamily')))),
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: sign.Signature(
                                              controller: _signatureController,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.98,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.60,
                                              backgroundColor:
                                                  Colors.transparent,
                                            ))
                                      ]),
                                    ),
                                  ),
                                ])
                              : Column(
                                  children: <Widget>[
                                    widget.facilityDetail.facilityId ==
                                            Constants.FacilityMembership
                                        ? Directionality(
                                            textDirection:
                                                uiprefix.TextDirection.ltr,
                                            child: Container(
                                                // margin: EdgeInsets.only(left: 1),
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.27,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.98,
                                                /*decoration: BoxDecoration(
                                              border: Border.all(
                                                // width: 1,
                                                color: Colors.grey[200],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),*/
                                                child: Material(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0)),
                                                  //elevation: 5.0,
                                                  color: Colors.white,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Container(
                                                        alignment:
                                                            Alignment.topCenter,

                                                        child: Image.asset(
                                                            'assets/images/MembershipCard.png',
                                                            height: MediaQuery
                                                                        .of(
                                                                            context)
                                                                    .size
                                                                    .height *
                                                                0.35,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.93,
                                                            fit: BoxFit.fill),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                            left: 10),
                                                        child: Row(children: [
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.85,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                              child: Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .topRight,
                                                                  child: Text(
                                                                    tr('tentative'),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                    style: TextStyle(
                                                                        color: ColorData
                                                                            .primaryTextColor,
                                                                        fontSize:
                                                                            Styles
                                                                                .textSizeSmall,
                                                                        fontFamily:
                                                                            tr('currFontFamily')),
                                                                  ))),
                                                        ]),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.02,
                                                            left: 10),
                                                        child: Row(children: [
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.65,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                              child: Text(
                                                              tr('customer_id') + ': ' +
                                                                    (widget.userProfileInfo.customerId ==
                                                                                null
                                                                            ? ""
                                                                            : widget.userProfileInfo.customerId)
                                                                        .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .loginBtnFontSize,
                                                                    fontFamily:
                                                                        tr('currFontFamilyEnglishOnly')),
                                                              )),
                                                        ]),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.05,
                                                            left: 10),
                                                        child: Row(children: [
                                                          Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.60,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.03,
                                                              child: Text(
                                                                'Name : ' +
                                                                    (widget.userProfileInfo.firstName ==
                                                                            null
                                                                        ? ""
                                                                        : widget.userProfileInfo.firstName +
                                                                            ' ' +
                                                                            widget.userProfileInfo.lastName),
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .loginBtnFontSize,
                                                                    fontFamily:
                                                                        tr('currFontFamily')),
                                                              )),
                                                        ]),
                                                      ),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: EdgeInsets.only(
                                                            top: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.10,
                                                            left: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.25),
                                                        child: Column(
                                                            children: [
                                                              Row(children: [
                                                                Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.68,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.03,
                                                                    child: Text(
                                                                      'Membership ID : ' +
                                                                          (widget.userProfileInfo.membershipNumber == null
                                                                              ? ""
                                                                              : widget.userProfileInfo.membershipNumber),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: ColorData
                                                                              .primaryTextColor,
                                                                          fontSize: Styles
                                                                              .loginBtnFontSize,
                                                                          fontFamily:
                                                                              tr('currFontFamily')),
                                                                    )),
                                                              ]),
                                                              Row(children: [
                                                                Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.68,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.03,
                                                                    color: Colors
                                                                        .white,
                                                                    child: Text(
                                                                      'Type: ' +
                                                                          (widget.userProfileInfo.facilityItemName == null
                                                                              ? ""
                                                                              : widget.userProfileInfo.facilityItemName),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: ColorData
                                                                              .primaryTextColor,
                                                                          fontSize: Styles
                                                                              .loginBtnFontSize,
                                                                          fontFamily:
                                                                              tr('currFontFamily')),
                                                                    )),
                                                              ]),
                                                              Row(children: [
                                                                Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.68,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.03,
                                                                    child: Text(
                                                                      tr('valid_from') +
                                                                          ' : ' +
                                                                          (widget.userProfileInfo.membershipStartDate == null
                                                                              ? ""
                                                                              : DateTimeUtils().dateToStringFormat(DateTimeUtils().stringToDate(widget.userProfileInfo.membershipStartDate.substring(0, 10), DateTimeUtils.YYYY_MM_DD_Format), DateTimeUtils.DD_MM_YYYY_Format)),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: ColorData
                                                                              .primaryTextColor,
                                                                          fontSize: Styles
                                                                              .loginBtnFontSize,
                                                                          fontFamily:
                                                                              tr('currFontFamily')),
                                                                    )),
                                                              ]),
                                                              Row(children: [
                                                                Container(
                                                                    width: MediaQuery.of(context)
                                                                            .size
                                                                            .width *
                                                                        0.68,
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.03,
                                                                    child: Text(
                                                                      tr('valid_until') +': ' +
                                                                          (widget.userProfileInfo.membershipEndDate == null
                                                                              ? ""
                                                                              : DateTimeUtils().dateToStringFormat(DateTimeUtils().stringToDate(widget.userProfileInfo.membershipEndDate.substring(0, 10), DateTimeUtils.YYYY_MM_DD_Format), DateTimeUtils.DD_MM_YYYY_Format)),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          color: ColorData
                                                                              .primaryTextColor,
                                                                          fontSize: Styles
                                                                              .loginBtnFontSize,
                                                                          fontFamily:
                                                                              tr('currFontFamily')),
                                                                    )),
                                                              ])
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                )))
                                        : Container(
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                    margin: EdgeInsets.only(
                                                        top: 10, left: 5),
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.18,
                                                    width: MediaQuery.of(context).size.width *
                                                        0.30,
                                                    color: Colors.white,
                                                    child: Image.asset(
                                                        widget.facilityDetail.facilityId == Constants.FacilityLeisure ||
                                                                widget.facilityDetail.facilityId ==
                                                                    Constants
                                                                        .FacilityOlympicPool
                                                            ? 'assets/images/10_11_12_logo.png'
                                                            : 'assets/images/' +
                                                                widget.facilityDetail.facilityId.toString() +
                                                                '_logo.png',
                                                        height: MediaQuery.of(context).size.height * 0.18,
                                                        width: MediaQuery.of(context).size.width * 0.18,
                                                        fit: BoxFit.fill)),
                                                Container(
                                                  margin: Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? EdgeInsets.only(
                                                          top: 10,
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35)
                                                      : EdgeInsets.only(
                                                          top: 10,
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.16,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.60,
                                                  child: Text(
                                                    widget.facilityItem
                                                        .facilityItemName,
                                                    style: TextStyle(
                                                        fontSize: Styles
                                                            .textSizRegular,
                                                        fontFamily: tr(
                                                            'currFontFamily')),
                                                  ),
                                                ),
                                                Container(
                                                  margin: Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? EdgeInsets.only(
                                                          top: 50,
                                                          left: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35)
                                                      : EdgeInsets.only(
                                                          top: 50,
                                                          right: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.35),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.10,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.60,
                                                  child: SingleChildScrollView(
                                                      child: Row(children: [
                                                    getHtml(widget.facilityItem
                                                        .description)
                                                  ])),
                                                ),
                                                widget.enquiryDetail != null &&
                                                        widget.enquiryDetail
                                                                .firstName !=
                                                            null
                                                    ? Container(
                                                        margin: Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? EdgeInsets.only(
                                                                top: 120,
                                                                left: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35)
                                                            : EdgeInsets.only(
                                                                top: 100,
                                                                right: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.35),
                                                        child: Text(
                                                          widget.enquiryDetail
                                                              .firstName,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                          ),
                                  ],
                                ),
                        ),
                        widget.screenType == Constants.Screen_Signature
                            ? Text("")
                            : Container(

                                margin: EdgeInsets.only(left: 8, right: 8),
                                height: widget.facilityDetail.facilityId ==
                                        Constants.FacilityMembership
                                    ? MediaQuery.of(context).size.height * 0.50
                                    : widget.screenType ==
                                            Constants.Screen_Schedule
                                        ? MediaQuery.of(context).size.height *
                                            0.75
                                        : MediaQuery.of(context).size.height *
                                            0.58,
                                width: MediaQuery.of(context).size.width * 0.96,
                                color: Colors.transparent,
                                child: Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 10,
                                          left: 10,
                                          right: 10,
                                          bottom: 10),
                                      child: widget.screenType ==
                                              Constants.Screen_Add_Enquiry // 0
                                          ? Row(children: [
                                              ElevatedButton(
                                                style: ButtonStyle(
                                                    foregroundColor:
                                                    MaterialStateProperty.all<Color>(Colors.white),
                                                    backgroundColor: MaterialStateProperty.all<Color>(
                                                      widget.showDetail == 0
                                                          ? ColorData.toColor(widget
                                                          .facilityDetail
                                                          .colorCode)
                                                          : Colors.grey[200]),
                                                    shape:
                                                    MaterialStateProperty.all<RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.all(
                                                              Radius.circular(2.0),
                                                            )))),
                                                // shape: RoundedRectangleBorder(
                                                //     borderRadius:
                                                //         BorderRadius.circular(
                                                //             2)),
                                                onPressed: () async {
                                                  setState(() {
                                                    widget.showDetail = 0;
                                                  });
                                                },
                                                // color: widget.showDetail == 0
                                                //     ? ColorData.toColor(widget
                                                //         .facilityDetail
                                                //         .colorCode)
                                                //     : Colors.grey[200],
                                                child: Text(
                                                    widget.facilityDetail
                                                                .facilityId ==
                                                            Constants
                                                                .FacilityCollage
                                                        ? tr("basic_details")
                                                        : tr(
                                                            "customer_details"),
                                                    style: TextStyle(
                                                        color: widget
                                                                    .showDetail ==
                                                                0
                                                            ? Colors.white
                                                            : ColorData
                                                                .primaryTextColor,
                                                        fontSize: 12)),
                                              ),
                                              !(widget.facilityDetail
                                                              .facilityId ==
                                                          10 ||
                                                      widget.facilityDetail
                                                              .facilityId ==
                                                          11 ||
                                                      widget.facilityDetail
                                                              .facilityId ==
                                                          1 ||
                                                      widget.facilityDetail
                                                              .facilityId ==
                                                          2 ||
                                                      widget.facilityDetail
                                                              .facilityId ==
                                                          3)
                                                  //||
                                                  //                                                       widget.facilityDetail
                                                  //                                                               .facilityId ==
                                                  //                                                           3
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 5),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                            MaterialStateProperty.all<Color>(Colors.white),
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                              widget
                                                                  .showDetail ==
                                                                  1
                                                                  ? ColorData.toColor(
                                                                  widget
                                                                      .facilityDetail
                                                                      .colorCode)
                                                                  : Colors.grey[200]),
                                                            shape: MaterialStateProperty
                                                                .all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(2.0),
                                                                    )))),
                                                        onPressed: () async {
                                                          setState(() {
                                                            widget.showDetail =
                                                                1;
                                                          });
                                                        },
                                                        // color: widget
                                                        //             .showDetail ==
                                                        //         1
                                                        //     ? ColorData.toColor(
                                                        //         widget
                                                        //             .facilityDetail
                                                        //             .colorCode)
                                                        //     : Colors.grey[200],
                                                        child: Text(
                                                            tr(
                                                                'contact_details'),
                                                            style: TextStyle(
                                                                color: widget
                                                                            .showDetail ==
                                                                        1
                                                                    ? Colors
                                                                        .white
                                                                    : ColorData
                                                                        .primaryTextColor,
                                                                fontSize: 12)),
                                                      ))
                                                  : Text("")
                                            ])
                                          : Align(
                                              alignment: Localizations.localeOf(
                                                              context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.bottomLeft
                                                  : Alignment.bottomRight,
                                              child: Text(
                                                  widget.screenType ==
                                                          Constants
                                                              .Screen_Add_Enquiry // 0
                                                      ? tr(
                                                          'terms_provide_following_details')
                                                      : widget.screenType ==
                                                              Constants
                                                                  .Screen_Upload_Document //1
                                                          ? tr(
                                                              'terms_uploaded_documents')
                                                          : widget.screenType ==
                                                                  Constants
                                                                      .Screen_Accept_Terms //2
                                                              ? (widget
                                                                      .showContract
                                                                  ? tr(
                                                                      'terms_contract_details')
                                                                  : tr(
                                                                      'terms_condition'))
                                                              : widget.screenType ==
                                                                      Constants
                                                                          .Screen_Questioner
                                                                  ? tr(
                                                                      'personal_health')
                                                                  : '',
                                                  style: (TextStyle(
                                                      color: Colors.blue[300],
                                                      fontWeight:
                                                          FontWeight.w400)))),
                                    ),
                                    Container(
                                        height: widget.screenType !=
                                                Constants.Screen_Upload_Document
                                            ? widget.facilityDetail.facilityId ==
                                                    Constants.FacilityMembership
                                                ? MediaQuery.of(context).size.height *
                                                    0.40
                                                : widget.screenType ==
                                                        Constants
                                                            .Screen_Schedule
                                                    ? MediaQuery.of(context).size.height *
                                                        0.60
                                                    : MediaQuery.of(context).size.height *
                                                        0.45
                                            : 90,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.98,
                                        // margin: EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // width: 1,
                                              color: Colors.grey[200],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.white),
                                        child: widget.screenType ==
                                                Constants.Screen_Upload_Document
                                            ? getUpload(context)
                                            : widget.screenType ==
                                                    Constants.Screen_Questioner
                                                ? getQuestions(context)
                                                : widget.screenType ==
                                                        Constants
                                                            .Screen_Accept_Terms
                                                    ? (widget.showContract
                                                        ? getMembershipContract()
                                                        : getTerms(context))
                                                    : widget.screenType ==
                                                            Constants.Screen_Schedule
                                                        ? (isLoaded == false)? Center(
                                            child: CircularProgressIndicator(strokeWidth: 4,color: Colors.blue[200],)): Column(children: [
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.02,
                                                              child: Text(
                                                                tr('total_class') +
                                                                    " " +
                                                                    widget
                                                                        .enquiryDetail
                                                                        .totalClass
                                                                        .toString() +
                                                                    " " +
                                                                    tr(
                                                                        'balance_class') +
                                                                    " " +
                                                                    widget
                                                                        .enquiryDetail
                                                                        .balanceClass
                                                                        .toString(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontFamily: tr(
                                                                      "currFontFamily"),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontSize: Styles
                                                                      .textSizeSmall,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      top: 5,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.10,
                                                              child:
                                                                  FormBuilder(
                                                                      child: Column(
                                                                          children: <
                                                                              Widget>[
                                                                    Container(
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              1.0,
                                                                              0,
                                                                              1.0,
                                                                              0),
                                                                      child: CustomTrainerComponent(
                                                                          selectedFunction:
                                                                              _onChangeTrainerDropdown,
                                                                          trainerController:
                                                                              _textTrainerControllers,
                                                                          isEditBtnEnabled: Strings
                                                                              .ProfileCallState,
                                                                          trainerResponse: widget
                                                                              .trainers,
                                                                          label:
                                                                              tr('select_trainer')),
                                                                    ),
                                                                  ])),
                                                            ),


                                                            getCalendar(),

                                                          ])
                                                        : (widget.facilityDetail.facilityId == 10 || widget.facilityDetail.facilityId == 11 || widget.facilityDetail.facilityId == 1 || widget.facilityDetail.facilityId == 2 || widget.facilityDetail.facilityId == 3)
                                                            // widget.facilityDetail.facilityId == 3
                                                            ? getSportsFields()
                                                            : SingleChildScrollView(
                                                                child: Column(children: [
                                                                Visibility(
                                                                  child:
                                                                      getFormFields(),
                                                                  visible:
                                                                      widget.showDetail ==
                                                                              0
                                                                          ? true
                                                                          : false,
                                                                ),
                                                                Visibility(
                                                                  child:
                                                                      getContactFields(),
                                                                  visible:
                                                                      widget.showDetail ==
                                                                              1
                                                                          ? true
                                                                          : false,
                                                                )
                                                              ]))),
                                    widget.screenType ==
                                            Constants.Screen_Upload_Document
                                        ? Container(
                                            // margin: EdgeInsets.only(top: 100, left: 20),
                                            child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .39,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .94,
                                                child: SingleChildScrollView(
                                                    child: Container(
                                                  margin:
                                                      EdgeInsets.only(top: 8.0),
                                                  child: widget.enquiryDetail
                                                              .supportDocuments !=
                                                          null
                                                      ? Row(children: [
                                                          getSupportDocuments()
                                                        ])
                                                      : Text("Not Available"),
                                                ))))
                                        : Text(""),
                                  ],
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.only(left: 8, right: 8),
                          height: MediaQuery.of(context).size.height * 0.08,
                          width: MediaQuery.of(context).size.width * 0.90,
                          color: Colors.transparent,
                          child: Row(children: [
                            widget.screenType != Constants.Screen_Schedule
                                ? Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.38,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              ColorData.grey300),
                                          shape: MaterialStateProperty
                                              .all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  )))),
                                      onPressed: () async {
                                        showDialog<Widget>(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button!
                                          builder: (BuildContext pcontext) {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                              content: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Center(
                                                        child: Text(
                                                          tr("enquiry"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: ColorData
                                                                .primaryTextColor,
                                                            fontFamily: tr(
                                                                "currFontFamily"),
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: Styles
                                                                .textSizeSmall,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Center(
                                                        child: Text(
                                                          tr('cancel_confirm'),
                                                          style: TextStyle(
                                                              color: ColorData
                                                                  .primaryTextColor,
                                                              fontSize: Styles
                                                                  .textSiz,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontFamily: tr(
                                                                  "currFontFamily")),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          ElevatedButton(
                                                              style: ButtonStyle(
                                                                  foregroundColor:
                                                                  MaterialStateProperty.all<Color>(Colors.white),
                                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                                      ColorData.grey300),
                                                                  shape: MaterialStateProperty
                                                                      .all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(5.0),
                                                                          )))),
                                                              // color: ColorData
                                                              //     .grey300,
                                                              child: new Text(
                                                                  "No",
                                                                  style: TextStyle(
                                                                      color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                                                      fontSize: Styles.textSizeSmall,
                                                                      fontFamily: tr("currFontFamily"))),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        pcontext)
                                                                    .pop();
                                                              }),
                                                          ElevatedButton(
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
                                                            // color: ColorData
                                                            //     .colorBlue,
                                                            child: new Text(
                                                              "Yes",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: Styles
                                                                      .textSizeSmall,
                                                                  fontFamily: tr(
                                                                      "currFontFamily")),
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.of(
                                                                      pcontext)
                                                                  .pop();
                                                              if (widget.enquiryDetail == null ||
                                                                  widget.enquiryDetail
                                                                          .enquiryDetailId ==
                                                                      null ||
                                                                  widget.enquiryDetail
                                                                          .enquiryDetailId ==
                                                                      0) {
                                                                Navigator.pop(
                                                                    context);

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => FacilityDetailsPage(
                                                                            facilityId: widget
                                                                                .facilityDetail
                                                                                .facilityId)));
                                                                return;
                                                              }
                                                              widget.enquiryDetail
                                                                      .isActive =
                                                                  false;
                                                              widget
                                                                  .enquiryDetail
                                                                  .vatPercentage = widget
                                                                          .enquiryDetail
                                                                          .vatPercentage ==
                                                                      null
                                                                  ? 0
                                                                  : widget
                                                                      .enquiryDetail
                                                                      .vatPercentage;
                                                              Meta m = await (new FacilityDetailRepository())
                                                                  .saveEnquiryDetails(
                                                                      widget
                                                                          .enquiryDetail,
                                                                      true);
                                                              if (m.statusCode ==
                                                                  200) {
                                                                Navigator.pop(
                                                                    context);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) => FacilityDetailsPage(
                                                                          facilityId: widget
                                                                              .facilityDetail
                                                                              .facilityId)),
                                                                );
                                                                customGetSnackBarWithOutActionButton(
                                                                    tr("enquiry"),
                                                                    tr('cancel_success'),
                                                                    context);
                                                              } else {
                                                                customGetSnackBarWithOutActionButton(
                                                                    tr("enquiry"),
                                                                    m.statusMsg,
                                                                    context);
                                                              }
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
                                      },
                                      // color: Colors.grey[300],
                                      child: Text(widget.enquiryDetail == null ||
                                          widget.enquiryDetail
                                              .enquiryDetailId ==
                                              null ||
                                          widget.enquiryDetail
                                              .enquiryDetailId ==
                                              0?tr('cancel'):tr('cancel_enquiry'),
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12)),
                                    ))
                                : Text(""),
                            (widget.screenType ==
                                            Constants.Screen_Accept_Terms &&
                                        (!this.valuefirst &&
                                            !widget.showContract)) ||
                                    widget.screenType ==
                                        Constants.Screen_Schedule
                                ? Text("")
                                : Container(
                                    margin: widget.screenType !=
                                            Constants.Screen_Schedule
                                        ? Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(left: 40)
                                            : EdgeInsets.only(right: 40)
                                        : Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.25),
                                    width:
                                        MediaQuery.of(context).size.width * 0.40,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<Color>(Colors.white),
                                          backgroundColor: MaterialStateProperty.all<Color>(
                                              ColorData.toColor(
                                                  widget.facilityDetail.colorCode)),
                                          shape: MaterialStateProperty
                                              .all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0),
                                                  )))),
                                      onPressed: () async {
                                        _handler.show();
                                        debugPrint("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
                                        if (saveInProgress) return;
                                        if (widget.screenType ==
                                            Constants.Screen_Upload_Document) {
                                          if (widget.enquiryDetail
                                                      .supportDocuments ==
                                                  null ||
                                              widget
                                                      .enquiryDetail
                                                      .supportDocuments
                                                      .length ==
                                                  0) {
                                            customGetSnackBarWithOutActionButton(
                                                tr('document_upload'),
                                                tr('upload_your_documents'),
                                                context);
                                            return;
                                          }
                                          BlocProvider.of<EnquiryBloc>(context)
                                              .add(EnquiryEditEvent(
                                                  enquiryDetailId: widget
                                                      .enquiryDetail
                                                      .enquiryDetailId,
                                                  enquiryStatusId: Constants
                                                      .Work_Flow_UploadDocuments,
                                                  isActive: true,
                                                  enquiryProcessId: 1));
                                          /*Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FacilityDetailsPage(
                                                      facilityId: widget
                                                          .facilityDetail
                                                          .facilityId)),
                                        );*/
                                        } else if (widget.screenType ==
                                            Constants.Screen_Accept_Terms) {
                                          // setState(() {
                                          //   widget.checkAll = true;
                                          // });
                                          if (widget.showContract) {
                                            setState(() {
                                              widget.showContract = false;
                                            });
                                          } else if (widget.importantTerms !=
                                                  null &&
                                              widget.importantTerms.length >
                                                  0) {
                                            showTermsAlertDialog(context);
                                          } else {
                                            if (widget.facilityDetail
                                                    .facilityId ==
                                                Constants.FacilityMembership) {
                                              BlocProvider.of<EnquiryBloc>(
                                                      context)
                                                  .add(EnquiryEditEvent(
                                                      enquiryDetailId:
                                                          widget.enquiryDetail
                                                              .enquiryDetailId,
                                                      enquiryStatusId: Constants
                                                          .Work_Flow_Signature,
                                                      isActive: true,
                                                      enquiryProcessId: 0));
                                            } else {
                                              BlocProvider.of<EnquiryBloc>(
                                                      context)
                                                  .add(EnquiryEditEvent(
                                                      enquiryDetailId: widget
                                                          .enquiryDetail
                                                          .enquiryDetailId,
                                                      enquiryStatusId: Constants
                                                          .Work_Flow_Payment,
                                                      isActive: true,
                                                      enquiryProcessId: 0));
                                            }
                                          }
                                        } else if (widget.screenType ==
                                            Constants.Screen_Schedule) {

                                          Meta m =
                                              await FacilityDetailRepository()
                                                  .getEnquiryTrainersList(
                                                      widget.enquiryDetailId,
                                                      "",
                                                      "");
                                          TrainersList trainers =
                                              new TrainersList();
                                          trainers = TrainersList.fromJson(
                                              jsonDecode(
                                                  m.statusMsg)['response']);
                                          _facultyDropdownList.clear();
                                          Trainers t = new Trainers();
                                          DropdownMenuItem<Trainers> m1;
                                          for (int i = 0;
                                              i < trainers.trainers.length;
                                              i++) {
                                            t = new Trainers();
                                            if (i == 0) {
                                              _faculty = t;
                                            }
                                            t.trainersID =
                                                trainers.trainers[i].trainersID;
                                            t.trainer =
                                                trainers.trainers[i].trainer;
                                            t.className =
                                                trainers.trainers[i].className;
                                            m1 = null;
                                            m1 = new DropdownMenuItem<Trainers>(
                                              child: Text(t.trainer),
                                              value: t,
                                            );
                                            _facultyDropdownList.add(m1);
                                          }

                                          displayCourseScheduleModalBottomSheet(
                                              context, trainers.trainers);
                                        } else if (widget.screenType ==
                                            Constants.Screen_Add_Enquiry) {
                                          if (widget.showDetail == 0 &&
                                              !(widget.facilityDetail
                                                          .facilityId ==
                                                      10 ||
                                                  widget.facilityDetail.facilityId ==
                                                      11 ||
                                                  widget.facilityDetail.facilityId ==
                                                      1 ||
                                                  widget.facilityDetail
                                                          .facilityId ==
                                                      2 ||
                                                  widget.facilityDetail
                                                          .facilityId ==
                                                      3)) {
                                            //||widget.facilityDetail.facilityId ==3
                                            if (!validateEnquiryForm(
                                                context, false)) return;
                                            setState(() {
                                              widget.showDetail = 1;
                                            });

                                          } else {
                                            if (!validateEnquiryForm(
                                                context, true)) return;
                                            debugPrint("comig inside save");
                                            saveInProgress = true;
                                            EnquiryDetailResponse request =
                                                getEnquiry();
                                            BlocProvider.of<EnquiryBloc>(
                                                    context)
                                                .add(EnquirySaveEvent(
                                                    enquiryDetailResponse:
                                                        request));
                                          }
                                        } else if (widget.screenType ==
                                            Constants.Screen_Questioner) {
                                          debugPrint(
                                              "comig inside question save");
                                          MemberAnswerRequest request =
                                              getQuestionSaveDetails();
                                          if(widget.facilityDetail.facilityId==Constants.FacilityFitness){
                                            for(int mq=0;mq<request.memberAnswersDto.length;mq++){
                                              if(request.memberAnswersDto[mq].answers==""){
                                                customGetSnackBarWithOutActionButton(
                                                    tr("enquiry"),
                                                    tr("enquiry_answer_questions"),
                                                    context);
                                                return;
                                              }
                                            }
                                          }
                                          BlocProvider.of<EnquiryBloc>(context)
                                              .add(EnquiryQuestionSaveEvent(
                                                  memberAnswerRequest:
                                                      request));
                                        } else if (widget.screenType ==
                                            Constants.Screen_Signature) {
                                          String result =
                                              await uploadSignature();
                                          if (result != "Ok") {
                                            customGetSnackBarWithOutActionButton(
                                                "Signature",
                                                "Signature Required",
                                                context);
                                            return;
                                          }
                                          debugPrint(
                                              "comig inside question save");
                                          BlocProvider.of<EnquiryBloc>(context)
                                              .add(EnquiryEditEvent(
                                                  enquiryDetailId: widget
                                                      .enquiryDetail
                                                      .enquiryDetailId,
                                                  enquiryStatusId: Constants
                                                      .Work_Flow_Payment,
                                                  isActive: true,
                                                  enquiryProcessId: 0));
                                        }
                                        _handler.dismiss();
                                      },
                                      // color: ColorData.toColor(
                                      //     widget.facilityDetail.colorCode),
                                      child: Text(
                                          widget.screenType ==
                                                  Constants.Screen_Accept_Terms
                                              ? tr('terms_accept')
                                              : widget.screenType ==
                                                      Constants.Screen_Schedule
                                                  ? 'Search Slot'
                                                  : tr('submit'),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  Styles.loginBtnFontSize)),
                                    )),
                          ]),
                        ),
                      ],
                    )
                )),
              progressBar]);
          }),
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
      request.contacts =  [];
    }
    if (widget.facilityDetail.facilityId == 10 ||
        widget.facilityDetail.facilityId == 11 ||
        widget.facilityDetail.facilityId == 1 ||
        widget.facilityDetail.facilityId == 2 ||
        widget.facilityDetail.facilityId == 3) {
      //||
      //         widget.facilityDetail.facilityId == 3
      final String formatted = DateFormat('dd-MM-yyyy','en_US').format(DateTime.now());
      request.DOB = DateTimeUtils().dateToStringFormat(
          DateTimeUtils().stringToDate(
              formatted.toString(), DateTimeUtils.DD_MM_YYYY_Format),
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

  Widget getUpload(BuildContext buildContext) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
            right: 0.0,
          ),
          child: Card(
              color: Colors.white,
              elevation: 0.0,
              child: Center(
                child: Container(
                  child: Column(
                    children: [
                      Container(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Container(
                              height: 65,
                              width: MediaQuery.of(context).size.width * 0.92,
                              child: Column(children: [
                                Row(children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.22,
                                      child: Padding(
                                        padding:
                                            EdgeInsets.only(left: 20, top: 8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            //Center Row contents horizontally,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            //Center Row contents vertically,
                                            children: <Widget>[
                                              Column(
                                                children: <Widget>[
                                                  IconButton(
                                                      iconSize: 40,
                                                      //tooltip: "Upload your files here",
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.grey,
                                                      ),
                                                      onPressed: () {
                                                        displayModalBottomSheet(
                                                            context);
                                                      } //=> getImageFromGallery(),
                                                      ),
                                                ],
                                              ),
                                            ]),
                                      )),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.70,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: Column(
                                        children: [
                                          Text(tr("upload_your_documents"),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor,
                                                  fontSize: Styles.textSiz,
                                                  fontFamily: tr(
                                                      "currFontFamilyEnglishOnly"))),
                                          Text(
                                            tr("supported_formats"),
                                            style: TextStyle(
                                                color:
                                                    ColorData.primaryTextColor,
                                                fontSize: Styles.textSiz,
                                                fontFamily: tr(
                                                    "currFontFamilyEnglishOnly")),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ])
                              ]),
                            ),
                          ]))
                    ],
                  ),
                ),
              )),
        ),
      ],
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
          : Row(children: [getTermsAndConditions(false)]),
    ));
    // ])));
  }

  Widget getTermsDlg(BuildContext buildContext) {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width * 0.96,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 8.0),
      child: widget.termsList.length == 0
          ? Text("No Terms Defined")
          : Row(children: [getTermsAndConditions(true)]),
    ));
    // ])));
  }

  getSportsFields() {
    if(widget.facilityDetail.facilityId==Constants.FacilityFitness && widget.familyMembers!=null &&widget.familyMembers.length==1){
      _textFamilyMemberControllers.text=widget.familyMembers[0].memberName;
      _fNameController.text = widget.familyMembers[0].memberName;
      _member = widget.familyMembers[0];
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        color: Colors.white,
        child: FormBuilder(
          child: Column(
            children: <Widget>[
              Visibility(visible:widget.facilityDetail.facilityId!=Constants.FacilityFitness?true:false,child:Container(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: CustomFamilyMemberComponent(
                    selectedFunction: _onChangeFamilyMemberDropdown,
                    memberController: _textFamilyMemberControllers,
                    isEditBtnEnabled: Strings.ProfileCallState,
                    memberResponse: widget.familyMembers,
                    label: tr('select_member')),
              )),
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
                  readOnly: _member.customerId == 0 ? false : true,
                ),
              ),

              Container(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: LoginPageFieldWhite(
                  _commentController,
                  tr("coments"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.review,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {},
                  maxLines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getFormFields() {
    return /*SingleChildScrollView(
      child: */
        Container(
      margin: EdgeInsets.only(top: 5.0),
      child: FormBuilder(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: CustomFamilyMemberComponent(
                  selectedFunction: _onChangeFamilyMemberDropdown,
                  memberController: _textFamilyMemberControllers,
                  isEditBtnEnabled: Strings.ProfileCallState,
                  memberResponse: widget.familyMembers,
                  label: tr('select_member')),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _fNameController,
                  widget.facilityDetail.facilityId == Constants.FacilityCollage
                      ? tr("student_name")
                      : tr("customer_name"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.woman,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {},
              readOnly: false,),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: NationalityCodePicker(
                  padding: EdgeInsets.zero,
                  isEditBtnEnabled: Strings.ProfileCallState,
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
                  alignLeft: true)
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: CustomDOBComponent(
                  isEditBtnEnabled: Strings.ProfileCallState,
                  selectedFunction: (val) => {
                        _customDobController.text = val,
                      },
                  dobController: _customDobController,
                  isAddPeople: true),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _fEmiratesIdController,
                  tr("emirates_id"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.woman,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {}),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                child:
                    /*LoginPageFields(
                  _flanguageController,
                  tr("language"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.woman,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {})*/
                    CustomLanguageComponent(
                        selectedFunction: _onChangeLanguageDropdown,
                        languageController: _textLanguageControllers,
                        isEditBtnEnabled: Strings.ProfileCallState,
                        languageResponse: [
                          new EnquiryLanguage(languageName: "Arabic"),
                          new EnquiryLanguage(languageName: "English")
                        ],
                        label: tr('select_language'))),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _addressController,
                  tr("address"),
                  Strings.commentsText,
                  CommonIcons.woman,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {},
                  maxLines: 2),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: CustomDOBComponent(
                isEditBtnEnabled: Strings.ProfileCallState,
                selectedFunction: (val) => {
                  _customStartTimeController.text = val,
                },
                dobController: _customStartTimeController,
                isAddPeople: false,
                isFutureDate: true,
                captionText: tr('preferred_time'),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                _commentController,
                tr("coments"),
                Strings.countryCodeForNonMobileField,
                CommonIcons.review,
                TextInputTypeFile.textInputTypeName,
                TextInputAction.done,
                () => {},
                () => {},
                maxLines: 2,
              ),
            )
          ],
        ),
      ),
    );
    //);
  }

  Widget getContactFields() {
    if (widget.enquiryDetail.contacts == null) {
      widget.enquiryDetail.contacts = [];
    }
    return Column(children: [
      ListView.builder(
          key: PageStorageKey("Contacts_PageStorageKey"),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: widget.enquiryDetail.contacts.length,
          itemBuilder: (context, j) {
            //return //Container(child: Text(enquiryDetailResponse[j].firstName));
            return Container(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.width * 0.98,
              // decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    height: MediaQuery.of(context).size.height * 0.50,
                    width: double.infinity,
                    child: Card(
                      // elevation: 1,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 5, left: 8),
                            child: Text(tr("contact_name"),
                                style: TextStyle(
                                    fontSize: Styles.textSiz,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25, left: 8),
                            child: Text(
                                widget.enquiryDetail.contacts[j].contactName,
                                style: TextStyle(
                                    fontSize: Styles.textSizRegular,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 55, left: 8),
                            child: Text(tr("contact_relation"),
                                style: TextStyle(
                                    fontSize: Styles.textSiz,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 75, left: 8),
                            child: Text(
                                widget.enquiryDetail.contacts[j].relation,
                                style: TextStyle(
                                    fontSize: Styles.textSizRegular,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 55,
                                left: MediaQuery.of(context).size.width * 0.50),
                            child: Text(tr("mobileNumber"),
                                style: TextStyle(
                                    fontSize: Styles.textSiz,
                                    color: Theme.of(context).primaryColor,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 75,
                                left: MediaQuery.of(context).size.width * 0.50),
                            child: Text(
                                widget.enquiryDetail.contacts[j].mobileNo,
                                style: TextStyle(
                                    fontSize: Styles.textSizRegular,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //     padding: EdgeInsets.only(top: 10),
                  //     child: Divider(color: Colors.grey[900])),
                ],
              ),
            );
          }),
      Align(
          alignment: Alignment.centerRight,
          child: Container(
              padding: const EdgeInsets.all(0.0),
              width: 37,
              decoration: ShapeDecoration(
                color: Colors.orangeAccent,
                shape: CircleBorder(),
              ),
              child: Center(
                  child: IconButton(
                padding: EdgeInsets.all(0.0),
                icon: Icon(
                  Icons.add,
                  color: ColorData.whiteColor,
                  size: 35,
                ),
                onPressed: () {
                  displayModalContactBottomSheet(context);
                },
              )))),
    ]);
  }

  void displayModalContactBottomSheet(context) {
    showDialog(
        context: context,
        builder: (BuildContext bc) {
          return SimpleDialog(
              contentPadding: EdgeInsets.all(0),
              title: Text(tr("contact_details"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w600,
                      fontFamily: tr('currFontFamilyEnglishOnly'))),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0)),
              children: [getBottomSheetContactFields()]);
        });
  }

  getBottomSheetContactFields() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, right: 4, left: 4),
      height: MediaQuery.of(context).size.height * 0.50,
      width: MediaQuery.of(context).size.width * 0.99,
      child: FormBuilder(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _contactNameController,
                  tr("contact_name"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.woman,
                  TextInputTypeFile.textInputTypeName,
                  TextInputAction.done,
                  () => {},
                  () => {}),
            ),
            Container(
                padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                // child: LoginPageFields(
                //     _contactRelation,
                //     tr("contact_relation"),
                //     Strings.countryCodeForNonMobileField,
                //     CommonIcons.woman,
                //     TextInputTypeFile.textInputTypeName,
                //     TextInputAction.done,
                //     () => {},
                //     () => {}),
                child: CustomRelationComponent(
                    selectedFunction: _onChangeRelationDropdown,
                    relationController: _textRelationControllers,
                    isEditBtnEnabled: Strings.ProfileCallState,
                    relationResponse: [
                      new EnquiryRelation(relationName: "Father"),
                      new EnquiryRelation(relationName: "Mother"),
                      new EnquiryRelation(relationName: "Husband"),
                      new EnquiryRelation(relationName: "Son"),
                      new EnquiryRelation(relationName: "Daughter"),
                      new EnquiryRelation(relationName: "Brother"),
                      new EnquiryRelation(relationName: "Sister"),
                      new EnquiryRelation(relationName: "Friend"),
                      new EnquiryRelation(relationName: "Other"),
                    ],
                    label: tr('contact_relation'))),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _contactMobile,
                  tr("mobileNumber"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.phone,
                  TextInputTypeFile.textInputTypeMobile,
                  TextInputAction.done,
                  () => {},
                  () => {}),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
              child: LoginPageFieldWhite(
                  _contactEmail,
                  tr("contact_email"),
                  Strings.countryCodeForNonMobileField,
                  CommonIcons.mail,
                  TextInputTypeFile.textInputTypeEmail,
                  TextInputAction.done,
                  () => {},
                  () => {},
                  maxLines: 1),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: ButtonTheme(
                  minWidth: 120,
                  child:ElevatedButton(
                    style: ButtonStyle(
                        foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            ColorData.toColor(widget.facilityDetail.colorCode)),
                        shape: MaterialStateProperty
                            .all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4.0),
                                )))),
                    onPressed: () {
                      if (!validateContactForm(context)) return;
                      if (widget.enquiryDetail.contacts == null) {
                        widget.enquiryDetail.contacts =[];

                      }
                      EnquiryContacts e = new EnquiryContacts();
                      e.contactId = 0;
                      e.contactName = _contactNameController.text.toString();
                      e.relation = _textRelationControllers.text.toString();
                      e.mobileNo = _contactMobile.text.toString();
                      e.emailId = _contactEmail.text.toString();
                      setState(() {
                        widget.enquiryDetail.contacts.add(e);
                        _contactNameController.text = "";
                        //_contactRelation.text = "";
                        _textRelationControllers.text = "";
                        _contactMobile.text = "";
                        _contactEmail.text = "";
                      });
                      Navigator.of(context).pop();
                    },
                    // color: ColorData.toColor(widget.facilityDetail.colorCode),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(4.0),
                    // ),
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget getCalendar() {
    return SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.only(top: 0.0),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[200]),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      TableCalendar(
                        initialCalendarFormat: CalendarFormat.week,
                        calendarStyle: CalendarStyle(
                            todayColor: Colors.blue,
                            selectedColor: Theme.of(context).primaryColor,
                            weekendStyle: TextStyle(color: Colors.black),
                            weekdayStyle: TextStyle(color: Colors.black),
                            outsideWeekendStyle: TextStyle(color: Colors.grey),
                            todayStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22.0,
                                color: Colors.white)),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle:
                              TextStyle().copyWith(color: Colors.black),
                          weekdayStyle:
                              TextStyle().copyWith(color: Colors.black),
                        ),
                        headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonVisible: false,
                        ),
                        startingDayOfWeek: StartingDayOfWeek.sunday,
                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) =>
                              Container(
                                  // margin: const EdgeInsets.all(5.0),
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 6, right: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(8.0)),
                                  child: Text(
                                    date.day.toString(),
                                    style: TextStyle(color: Colors.white),
                                  )),
                          todayDayBuilder: (context, date, events) => Container(
                              margin: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 6, right: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                date.day.toString(),
                                style: TextStyle(color: Colors.white),
                              )),
                        ),
                        calendarController: _controller,
                        onDaySelected: _onDaySelected,
                        onCalendarCreated: _onCalendarCreated,
                      )
                    ],
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 0, right: 0, top: 0),
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(2.0),
                    //   border: Border.all(color: Colors.grey[300]),
                    // ),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [getBookingSlots()])),
              ],
            )));
  }

  void _onCalendarCreated(DateTime day, DateTime day1, CalendarFormat format) {
    widget.selectedDate = _controller.selectedDay.toString().substring(0, 10);
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    widget.selectedDate = day.toString().substring(0, 10);
    BlocProvider.of<EnquiryBloc>(context).add(EnquiryTimeTableData(
        enquiryDetailId: widget.enquiryDetail.enquiryDetailId,
        trainerId: _faculty.trainersID,
        fromDate: widget.selectedDate,
        facilityItemId: 0));
  }

  Widget getHtml(String description) {
    return Expanded(
        child: Html(
          style: {
            "body":Style(
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
      data: description != null ? '<html><body>'+description+'</body></html>' : tr('noDataFound'),
    ));
  }

  Widget imageUI(String url, bool isLogo) {
    return CachedNetworkImage(
      imageUrl: url != null ? url : Icons.warning,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
//            fit: isLogo ? BoxFit.none : BoxFit.cover,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Future<String> uploadImage(filename) async {
    debugPrint("I am here Upload");
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            widget.facilityDetail.facilityId.toString() +
            "&eventparticipantid=" +
            widget.enquiryDetailId.toString() +
            "&FileName=" +
            newFileName +
            "&uploadtype=2"));
    debugPrint(" ddddddd-1 ");
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    debugPrint(" ddddddd " + res.toString());
    customGetSnackBarWithOutActionButton(
        tr("document_upload"), tr('file_uploaded_successfully'), context);
    BlocProvider.of<EnquiryBloc>(context).add(EnquiryReloadEvent(
        facilityId: widget.facilityDetail.facilityId,
        facilityItemId: widget.facilityItem.facilityItemId,
        enquiryDetailId: widget.enquiryDetail.enquiryDetailId));

    return res.reasonPhrase;
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
                          BlocProvider.of<EnquiryBloc>(context)
                              .add(EnquiryShowImageEvent());
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      trailing: new Icon(Icons.photo_camera,
                          color: ColorData.colorBlue),
                      title: new Text('Take Photo '),
                      onTap: () {
                        BlocProvider.of<EnquiryBloc>(context)
                            .add(EnquiryShowImageCameraEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  Widget getSupportDocuments() {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("Documents_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.enquiryDetail.supportDocuments.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 8, right: 8),
                      child: Row(children: [
                        Container(
                            width: MediaQuery.of(context).size.width * 0.78,
                            child: Text(
                                widget.enquiryDetail.supportDocuments[j]
                                    .documentFileName,
                                // overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'),
                                  color: ColorData.primaryTextColor,
                                ))),
                        Container(
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
                                        widget.enquiryDetail.supportDocuments[j]
                                            .supportDocumentId
                                            .toString());
                                if (m.statusCode == 200) {
                                  BlocProvider.of<EnquiryBloc>(context).add(
                                      EnquiryReloadEvent(
                                          facilityId:
                                              widget.facilityDetail.facilityId,
                                          facilityItemId: widget
                                              .facilityItem.facilityItemId,
                                          enquiryDetailId: widget
                                              .enquiryDetail.enquiryDetailId));
                                } else {
                                  customGetSnackBarWithOutActionButton(
                                      tr("enquiry"),
                                      tr('delete_unsuccessful'),
                                      context);
                                }
                              },
                            ))
                      ]),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Divider(color: Colors.grey[400])),
                  ],
                ),
              );
            }));
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
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[200])),
      child: widget.memberQuestions.length == 0
          ? Text("")
          : Row(children: [getQuestion()]),
    ));
    // ])));
  }

  Widget getQuestion() {
    return Expanded(
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
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Text(questionGroup.questionGroup,
                    style: TextStyle(
                        fontSize: Styles.newTextSize,
                        color: Theme.of(context).primaryColor,
                        fontFamily: tr('currFontFamily')))),
            Row(children: [
              Expanded(
                  child: ListView.builder(
                      key: PageStorageKey(j.toString() + "_PageStorageKey"),
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: questionGroup.memberQuestions.length,
                      itemBuilder: (context, i) {
                        //return //Container(child: Text(enquiryDetailResponse[j].firstName));
                        _questionsChecked[questionGroup
                            .memberQuestions[i].memberQuestionId] = false;
                        if (questionGroup.memberQuestions[i].questionAnswer !=
                            null) {
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
                                          padding:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? EdgeInsets.only(
                                                      left: 10,
                                                      right: 7,
                                                    )
                                                  : EdgeInsets.only(
                                                      right: 10, left: 5),
                                          child: ListTile(
                                            isThreeLine: false,
                                            dense: true,
                                            leading: Checkbox(
                                                activeColor: Theme.of(context)
                                                    .primaryColor,
                                                key: PageStorageKey<int>(i),
                                                value: _questionsChecked[
                                                    questionGroup
                                                        .memberQuestions[i]
                                                        .memberQuestionId],
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    _questionsChecked[questionGroup
                                                            .memberQuestions[i]
                                                            .memberQuestionId] =
                                                        value;
                                                  });
                                                }),
                                            title: Container(
                                                child: PackageListHead
                                                    .textWithStyleMediumFont(
                                                        context: context,
                                                        contentTitle:
                                                            questionGroup
                                                                .memberQuestions[
                                                                    i]
                                                                .questionName,
                                                        color: ColorData
                                                            .primaryTextColor,
                                                        fontSize: Styles
                                                            .textSizeSmall)),
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
                      }))
            ])
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
      List<MemberQuestionsResponse> questionResponse =[];

      List<String> result =
          questionGroup.memberQuestions[0].questionOptions.split(':');
      for (int a = 0; a < result.length; a++) {
        MemberQuestionsResponse m = new MemberQuestionsResponse();
        m.questionName = result[a];
        m.memberQuestionId = a + 1;
        questionResponse.add(m);
      }
      _textControllers[questionGroup.memberQuestions[0].memberQuestionId] =
          new MaskedTextController(mask: Strings.maskEngFLNameValidationStr);
      if (questionGroup.memberQuestions[0].questionAnswer != null) {
        _textControllers[questionGroup.memberQuestions[0].memberQuestionId]
            .text = questionGroup.memberQuestions[0].questionAnswer;
      }
      return widget.facilityDetail.facilityId == Constants.FacilityFitness
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  Container(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0,top:10,bottom: 10),
                      width: double.infinity,
                      decoration:
                          BoxDecoration(color: ColorData.loginBackgroundColor),
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
          answer.answers =
              _textControllers[qr.memberQuestionId].text.toString();
        }
        answers.add(answer);
      }
    }
    answerRequest.memberAnswersDto = answers;
    return answerRequest;
  }

  Widget getBookingSlots() {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("Slot_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: currentSlots.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 25),
                      child: Row(
                        children: [
                          Text(
                              currentSlots[j].appFromTime +
                                  '-' +
                                  currentSlots[j].appToTime,
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40, left: 25),
                      child: Row(
                        children: [
                          Text(currentSlots[j].className.toString(),
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60, left: 25),
                      child: Row(
                        children: [
                          Text(
                              currentSlots[j].avaialbleSeats.toString() +
                                  ' seats available',
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 25),
                      child: Row(
                        children: [
                          Text(currentSlots[j].trainer.toString(),
                              style: TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 25,
                          left: MediaQuery.of(context).size.width * 0.67),
                      width: double.infinity,
                      child: Column(
                        children: [
                          ButtonTheme(
                            minWidth: 100,
                            height: 30,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                  MaterialStateProperty.all<Color>(Colors.white),
                                  backgroundColor: MaterialStateProperty.all<Color>(
                                    currentSlots[j].isBookable == 1
                                        ? Colors.orange[300]
                                        : Colors.grey[200]),
                                  shape: MaterialStateProperty
                                      .all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(4.0),
                                          )))),
                              onPressed: () async {
                                if (currentSlots[j].isBookable == 2) {
                                  return;
                                }
                                if (currentSlots[j].isBookable != 1) {
                                  showDialog<Widget>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext pcontext) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(14)),
                                        ),
                                        content: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Center(
                                                  child: Text(
                                                    tr("booking"),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor,
                                                      fontFamily:
                                                          tr("currFontFamily"),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize:
                                                          Styles.textSizeSmall,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Center(
                                                  child: Text(
                                                    tr('schedule_cancel_confirm'),
                                                    style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor,
                                                        fontSize:
                                                            Styles.textSiz,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: tr(
                                                            "currFontFamily")),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(top: 10.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                            MaterialStateProperty.all<Color>(Colors.white),
                                                            backgroundColor: MaterialStateProperty.all<Color>(
                                                                ColorData.grey300),
                                                            shape: MaterialStateProperty
                                                                .all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(5.0),
                                                                    )))),
                                                        // color:
                                                        //     ColorData.grey300,
                                                        child: new Text("No",
                                                            style: TextStyle(
                                                                color: ColorData
                                                                    .primaryTextColor,
//                                color: Colors.black45,
                                                                fontSize: Styles
                                                                    .textSizeSmall,
                                                                fontFamily: tr(
                                                                    "currFontFamily"))),
                                                        onPressed: () {
                                                          Navigator.of(pcontext)
                                                              .pop();
                                                        }),
                                                    ElevatedButton(
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
                                                      // color:
                                                      //     ColorData.colorBlue,
                                                      child: new Text(
                                                        "Yes",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: Styles
                                                                .textSizeSmall,
                                                            fontFamily: tr(
                                                                "currFontFamily")),
                                                      ),
                                                      onPressed: () async {
                                                        Navigator.of(pcontext)
                                                            .pop();
                                                        Meta m = await (new FacilityDetailRepository()).saveBooking(
                                                            widget.enquiryDetail
                                                                .enquiryDetailId,
                                                            currentSlots[j]
                                                                .reservationId,
                                                            currentSlots[j]
                                                                .reservationTemplateId,
                                                            currentSlots[j]
                                                                        .isBookable ==
                                                                    1
                                                                ? false
                                                                : true,
                                                            currentSlots[j]
                                                                .bookingId);
                                                        if (m.statusCode ==
                                                            200) {
                                                          customGetSnackBarWithOutActionButton(
                                                              tr("booking"),
                                                              tr('schedule_cancel_success'),
                                                              context);
                                                          BlocProvider.of<EnquiryBloc>(context).add(EnquiryTimeTableData(
                                                              enquiryDetailId: widget
                                                                  .enquiryDetail
                                                                  .enquiryDetailId,
                                                              trainerId: _faculty
                                                                  .trainersID,
                                                              fromDate: widget
                                                                  .selectedDate,
                                                              facilityItemId: widget
                                                                  .enquiryDetail
                                                                  .facilityItemId));
                                                        } else {
                                                          customGetSnackBarWithOutActionButton(
                                                              tr("enquiry"),
                                                              m.statusMsg,
                                                              context);
                                                        }
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
                                  if (widget.enquiryDetail.balanceClass == 0 ||
                                      currentSlots[j].avaialbleSeats <= 0) {
                                    customGetSnackBarWithOutActionButton(
                                        tr("booking"),
                                        tr("classes_booked"),
                                        context);
                                    return;
                                  }
                                  if(widget.facilityDetail.facilityId==Constants.FacilityFitness) {
                                    showDialog<Widget>(
                                      context: context,
                                      barrierDismissible:
                                      false, // user must tap button!
                                      builder: (BuildContext pcontext) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                          ),
                                          content: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 10.0),
                                                  child: Center(
                                                    child: Text(
                                                      tr("booking"),
                                                      textAlign: TextAlign
                                                          .center,
                                                      style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor,
                                                        fontFamily:
                                                        tr("currFontFamily"),
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        fontSize:
                                                        Styles.textSizeSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 10.0),
                                                  child: Center(
                                                    child: Text(
                                                      tr('booking_cancel_msg'),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor,
                                                          fontSize:
                                                          Styles.textSiz,
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          fontFamily: tr(
                                                              "currFontFamily")),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      ElevatedButton(
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
                                                        // color:
                                                        // ColorData.colorBlue,
                                                        child: new Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontSize: Styles
                                                                  .textSizeSmall,
                                                              fontFamily: tr(
                                                                  "currFontFamily")),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(pcontext)
                                                              .pop();
                                                          Meta m =
                                                          await (new FacilityDetailRepository())
                                                              .saveBooking(
                                                              widget
                                                                  .enquiryDetail
                                                                  .enquiryDetailId,
                                                              currentSlots[j]
                                                                  .reservationId,
                                                              currentSlots[j]
                                                                  .reservationTemplateId,
                                                              // currentSlots[j].bookingId != 0
                                                              //     ? true
                                                              //     : false,
                                                              currentSlots[j]
                                                                  .isBookable ==
                                                                  1
                                                                  ? false
                                                                  : true,
                                                              currentSlots[j]
                                                                  .bookingId);
                                                          if (m.statusCode ==
                                                              200) {
                                                            customGetSnackBarWithOutActionButton(
                                                                tr("booking"),
                                                                tr("schedule_success"),
                                                                context);
                                                            BlocProvider.of<
                                                                EnquiryBloc>(
                                                                context).add(
                                                                EnquiryTimeTableData(
                                                                    enquiryDetailId: widget
                                                                        .enquiryDetail
                                                                        .enquiryDetailId,
                                                                    trainerId: _faculty
                                                                        .trainersID,
                                                                    fromDate: widget
                                                                        .selectedDate,
                                                                    facilityItemId: widget
                                                                        .enquiryDetail
                                                                        .facilityItemId));
                                                          } else {
                                                            customGetSnackBarWithOutActionButton(
                                                                tr("enquiry"),
                                                                m.statusMsg,
                                                                context);
                                                          }
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
                                  }else{
                                    Meta m =
                                    await (new FacilityDetailRepository())
                                        .saveBooking(
                                        widget.enquiryDetail
                                            .enquiryDetailId,
                                        currentSlots[j].reservationId,
                                        currentSlots[j]
                                            .reservationTemplateId,
                                        // currentSlots[j].bookingId != 0
                                        //     ? true
                                        //     : false,
                                        currentSlots[j].isBookable == 1
                                            ? false
                                            : true,
                                        currentSlots[j].bookingId);
                                    if (m.statusCode == 200) {
                                      customGetSnackBarWithOutActionButton(
                                          tr("booking"),
                                          tr("schedule_success"),
                                          context);
                                      BlocProvider.of<EnquiryBloc>(context).add(
                                          EnquiryTimeTableData(
                                              enquiryDetailId: widget
                                                  .enquiryDetail.enquiryDetailId,
                                              trainerId: _faculty.trainersID,
                                              fromDate: widget.selectedDate,
                                              facilityItemId: widget
                                                  .enquiryDetail.facilityItemId));
                                    } else {
                                      customGetSnackBarWithOutActionButton(
                                          tr("enquiry"), m.statusMsg, context);
                                    }
                                  }
                                }
                              },
                              // color: currentSlots[j].isBookable == 1
                              //     ? Colors.orange[300]
                              //     : Colors.grey[200],
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8.0),
                              // ),
                              child: Text(
                                  currentSlots[j].isBookable == 1
                                      ? tr("book")
                                      : currentSlots[j].isBookable == 0
                                          ? tr("remove")
                                          : tr('completed'),
                                  style: TextStyle(
                                      color: currentSlots[j].isBookable == 1
                                          ? Colors.white
                                          : ColorData.primaryTextColor)),
                            ),
                          ),
                          Text(currentSlots[j].booking_Status.toString(),
                              style: TextStyle(color: Colors.black54))
                          // Container(
                          //   child: getCustomContainer(),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }));
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

  _onChangeTrainerDropdown(Trainers trainer) {
    debugPrint(trainer.trainer);
    setState(() {
      _faculty = trainer;
    });
    if (widget.trainers != null && widget.trainers.length > 0) {
      BlocProvider.of<EnquiryBloc>(context).add(EnquiryTimeTableData(
          enquiryDetailId: widget.enquiryDetail.enquiryDetailId,
          trainerId: _faculty.trainersID,
          fromDate: widget.selectedDate,
          facilityItemId: 0));
    }
  }

  _onChangeLanguageDropdown(EnquiryLanguage language) {
    setState(() {
      _enquiryLanguage = language;
    });
  }

  _onChangeRelationDropdown(EnquiryRelation relation) {
    setState(() {
      _enquiryRelation = relation;
    });
  }

  _onChangeQuestionOptionDropdown(MemberQuestionsResponse question, int questionId) {
    _questionDropdownAnswer[questionId] = question;
    // debugPrint(questionId.toString());
    // setState(() {
    // });
  }

  _onChangeFamilyMemberDropdown(FamilyMember member) {
    setState(() {
      _member = member;
      if (_member.customerId == 0) {
        _fNameController.text = "";
      } else {
        _fNameController.text = _member.memberName;
      }
    });
  }

  void displayCourseScheduleModalBottomSheet(context, List<Trainers> trainers) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.40,
                          width: double.infinity,
                          child: Container(
                            margin: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(top: 10, left: 10, right: 10),
                              height: MediaQuery.of(context).size.height * 35,
                              child: FormBuilder(
                                  child: Column(children: <Widget>[
                                // Container(
                                //   margin: EdgeInsets.only(
                                //       top: 10, left: 10, right: 10),
                                //   height:
                                //       MediaQuery.of(context).size.height * 0.05,
                                //   child: CustomDropdown(
                                //     dropdownMenuItemList: _facultyDropdownList,
                                //     onChanged: _onChangeCategoryDropdown,
                                //     value: _faculty,
                                //     isEnabled: true,
                                //   ),
                                // ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                  child: CustomTrainerComponent(
                                      selectedFunction:
                                          _onChangeTrainerDropdown,
                                      trainerController:
                                          _textTrainerControllers,
                                      isEditBtnEnabled:
                                          Strings.ProfileCallState,
                                      trainerResponse: trainers,
                                      label: tr('select_trainer')),
                                ),
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: CustomDOBComponent(
                                      isEditBtnEnabled:
                                          Strings.ProfileCallState,
                                      selectedFunction: (val) => {
                                        _customFromController.text = val,
                                      },
                                      dobController: _customFromController,
                                      isAddPeople: true,
                                      captionText: tr('fromdate'),
                                    )),
                                Container(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                    child: CustomDOBComponent(
                                      isEditBtnEnabled:
                                          Strings.ProfileCallState,
                                      selectedFunction: (val) => {
                                        _customToController.text = val,
                                      },
                                      dobController: _customToController,
                                      isAddPeople: true,
                                      captionText: tr('todate'),
                                    ))
                              ])),
                            ),
                          ),
                        ),
                      ),
                      // Container(
                      //   margin: EdgeInsets.only(left: 190, top: 180),
                      //   child: Text('To',
                      //       style: TextStyle(color: Colors.grey, fontSize: 20)),
                      // ),

                      Container(
                        margin: EdgeInsets.only(top: 260, left: 50),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: 250,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  ColorData.colorBlue),
                              shape: MaterialStateProperty
                                  .all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      )))),
                          // color: Colors.blue[300],
                          onPressed: () {},
                          child: Text('Search',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  bool validateEnquiryForm(BuildContext context, bool validateContact) {
    if (widget.facilityDetail.facilityId == 10 ||
        widget.facilityDetail.facilityId == 11 ||
        widget.facilityDetail.facilityId == 1 ||
        widget.facilityDetail.facilityId == 2 ||
        widget.facilityDetail.facilityId == 3) {
      // ;
      if (_fNameController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("enter_student_name"), context);
        return false;
      } else if (_commentController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("enter_commets"), context);
        return false;
      }
    } else {
      if (_fNameController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("enter_student_name"), context);
        return false;
      } else if (nationalityController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("nationalityLabel"), context);
        return false;
      } else if (_customDobController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("dobLabel"), context);
        return false;
      } else if (_fEmiratesIdController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("emirates_id"), context);
        return false;
      } else if (_textLanguageControllers.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("select_language"), context);
        return false;
      } else if (_addressController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("address"), context);
        return false;
      } else if (_customStartTimeController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("enter_preferred_time"), context);
        return false;
      } else if (_commentController.text.isEmpty) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("enter_commets"), context);
        return false;
      } else if (validateContact && widget.enquiryDetail.contacts == null ||
          widget.enquiryDetail.contacts.length == 0) {
        customGetSnackBarWithOutActionButton(
            tr('error_caps'), tr("contact_details"), context);
        return false;
      }
    }
    return true;
  }

  bool validateContactForm(BuildContext context) {
    RegExp emailValid = RegExp(
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (_contactNameController.text.isEmpty) {
      customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("contact_name"), context);
      return false;
    } else if (_textRelationControllers.text.isEmpty) {
      customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("enter_contact_relation"), context);
      return false;
    } else if (_contactEmail.text.isEmpty) {
      customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("enter_email"), context);
      return false;
    } else if (!emailValid.hasMatch(_contactEmail.text.toString())) {
      customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("invalidEmailError"), context);
      return false;
    } else if (_contactMobile.text.isEmpty) {
      customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("enter_mobilenumber"), context);
      return false;
    }
    return true;
  }

  showTermsAlertDialog(BuildContext pcontext) {
    // show the dialog
    showDialog(
        context: pcontext,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.77,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 25),
                      child: Row(
                        children: [
                          Text(tr("accept_terms_proceed"),
                              style: TextStyle(
                                  color: Colors.blue[300],
                                  fontSize: Styles.textSizRegular,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: getTermsDlg(context),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                                foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    ColorData.toColor(
                                        widget.facilityDetail.colorCode)),
                                shape: MaterialStateProperty
                                    .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2.0),
                                        )))),
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(2)),
                            onPressed: () async {
                              /*setState(() {
                                this.valuefirst = true;
                              });*/
                              Navigator.of(
                                  pcontext)
                                  .pop();
                              if (widget.facilityDetail.facilityId ==
                                  Constants.FacilityMembership) {
                                BlocProvider.of<EnquiryBloc>(pcontext).add(
                                    EnquiryEditEvent(
                                        enquiryDetailId: widget
                                            .enquiryDetail.enquiryDetailId,
                                        enquiryStatusId:
                                            Constants.Work_Flow_Signature,
                                        isActive: true,
                                        enquiryProcessId: 0));
                              } else {
                                BlocProvider.of<EnquiryBloc>(pcontext).add(
                                    EnquiryEditEvent(
                                        enquiryDetailId: widget
                                            .enquiryDetail.enquiryDetailId,
                                        enquiryStatusId:
                                            Constants.Work_Flow_Payment,
                                        isActive: true,
                                        enquiryProcessId: 0));
                              }
                            },
                            // color: ColorData.toColor(
                            //     widget.facilityDetail.colorCode),
                            child: Text(tr("submitenquiry"),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
        });
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

  Widget getMembershipContract() {
    double total = 0;
    double taxableAmt = 0;
    double taxAmt = 0;
    if (widget.userProfileInfo.price != null) {
      total = widget.userProfileInfo.price;
      if (widget.userProfileInfo.vatPercentage == null) {
        taxableAmt = (widget.userProfileInfo.price);
      } else {
        taxableAmt = (widget.userProfileInfo.price) /
            (1 + (widget.userProfileInfo.vatPercentage / 100.00));
      }
      for (int i = 0;
          i < widget.userProfileInfo.associatedProfileList.length;
          i++) {
        total = total + widget.userProfileInfo.associatedProfileList[i].price;
        if (widget.userProfileInfo.associatedProfileList[i].vatPercentage ==
            null) {
          taxableAmt = taxableAmt +
              (widget.userProfileInfo.associatedProfileList[i].price);
        } else {
          taxableAmt = taxableAmt +
              (widget.userProfileInfo.associatedProfileList[i].price) /
                  (1 +
                      (widget.userProfileInfo.associatedProfileList[i]
                              .vatPercentage /
                          100.00));
        }
      }
      taxAmt = total - taxableAmt;
    }
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Visibility(
                visible: false,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: Localizations.localeOf(context).languageCode == "en"
                      ? EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.25)
                      : EdgeInsets.only(
                          right: MediaQuery.of(context).size.width * 0.25),
                  child: Column(children: [
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'Nationality : ' +
                                (widget.userProfileInfo.membershipNationality ==
                                        null
                                    ? ""
                                    : widget
                                        .userProfileInfo.membershipNationality),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontSize: Styles.loginBtnFontSize,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ]),
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'City: ' +
                                (widget.userProfileInfo.city == null
                                    ? ""
                                    : widget.userProfileInfo.city),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontSize: Styles.loginBtnFontSize,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ]),
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'Date of Birth : ' +
                                (widget.userProfileInfo.dateOfBirth == null
                                    ? ""
                                    : DateTimeUtils().dateToStringFormat(
                                        DateTimeUtils().stringToDate(
                                            widget.userProfileInfo.dateOfBirth
                                                .substring(0, 10),
                                            DateTimeUtils.YYYY_MM_DD_Format),
                                        DateTimeUtils.DD_MM_YYYY_Format)),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ]),
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'Email : ' +
                                (widget.userProfileInfo.email == null
                                    ? ""
                                    : widget.userProfileInfo.email),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ]),
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'Emergency Contact : ' +
                                (widget.userProfileInfo.emergencyContactName ==
                                        null
                                    ? ""
                                    : widget
                                        .userProfileInfo.emergencyContactName),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ]),
                    Row(children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.68,
                          height: MediaQuery.of(context).size.height * 0.03,
                          child: Text(
                            'Emergency Contact No : ' +
                                (widget.userProfileInfo.emergencyContactNo ==
                                        null
                                    ? ""
                                    : widget
                                        .userProfileInfo.emergencyContactNo),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          )),
                    ])
                  ]),
                )),
            Container(
                margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                child: Stack(
                  children: [
                    SizedBox(height: 5),
                    Container(
                      height: MediaQuery.of(context).size.height * .12,
                      width: MediaQuery.of(context).size.width * .98,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey[200]),
                        color: Colors.white,
                      ),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        top: 10.0, left: 10.0, bottom: 10.0)
                                    : EdgeInsets.only(
                                        top: 10.0, right: 10.0, bottom: 10.0),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Text(
                                  widget.userProfileInfo.facilityItemName ==
                                          null
                                      ? ""
                                      : widget.userProfileInfo.facilityItemName,
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.packageExpandTextSiz,
                                      fontFamily: tr('currFontFamily')),
                                )),
                              ],
                            ),
                          ),
                          Container(
                            margin:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? const EdgeInsets.only(top: 40, left: 10)
                                    : const EdgeInsets.only(top: 40, right: 10),
                            child: Row(
                              children: [
                                Text(
                                    'AED ' +
                                        (widget.userProfileInfo.price == null
                                            ? ""
                                            : widget.userProfileInfo.price
                                                .toStringAsFixed(2)),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.packageExpandTextSiz,
                                        fontFamily: tr('currFontFamily'))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                )),
            Row(children: [
              getMembershipItemList(widget.facilityDetail.facilityId, 0),
            ]),
            Container(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      margin:
                          Localizations.localeOf(context).languageCode == "en"
                              ? EdgeInsets.only(right: 20)
                              : EdgeInsets.only(left: 20),
                      child: Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.89,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(tr("original_Amount"),
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor
                                                        .withOpacity(1.0),
                                                    fontSize:
                                                        Styles.loginBtnFontSize,
                                                    fontFamily: tr(
                                                        'currFontFamily'))))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "AED",
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize: Styles.textSiz,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              " " +
                                                  double.tryParse(
                                                      taxableAmt
                                                          .toStringAsFixed(2)??0).toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize:
                                                      Styles.loginBtnFontSize,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.89,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.30,
                                      child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(tr("Vat_amount"),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize:
                                                      Styles.loginBtnFontSize,
                                                  fontFamily:
                                                      tr('currFontFamily')))),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "AED",
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize: Styles.textSiz,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              " " +
                                                  double.tryParse(
                                                      taxAmt.toStringAsFixed(2)??0).toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize:
                                                      Styles.loginBtnFontSize,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.89,
                            margin: EdgeInsets.only(top: 8),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      width: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? MediaQuery.of(context).size.width *
                                              0.525
                                          : MediaQuery.of(context).size.width *
                                              0.60,
                                      child: Divider(
                                        thickness: 1,
                                      )),
                                ]),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.89,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(tr("final_Amount"),
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor
                                                        .withOpacity(1.0),
                                                    fontSize:
                                                        Styles.loginBtnFontSize,
                                                    fontFamily: tr(
                                                        'currFontFamily'))))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              "AED",
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize: Styles.textSiz,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              " " +
                                                  double.tryParse(
                                                      total.toStringAsFixed(2)??0).toStringAsFixed(2),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize:
                                                      Styles.loginBtnFontSize,
                                                  fontFamily:
                                                      tr('currFontFamily')),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // InkWell(
                    //   onTap: () {
                    //     // if (rateTxtOnTap != null) rateTxtOnTap();
                    //   },
                    //   highlightColor: Color(0x00000000),
                    //   splashColor: Color(0x00000000),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.end,
                    //     children: [
                    //       Container(
                    //         margin:
                    //             Localizations.localeOf(context).languageCode == "en"
                    //                 ? EdgeInsets.only(top: 8, right: 20)
                    //                 : EdgeInsets.only(top: 8, left: 20),
                    //         child: Text(
                    //           tr("rate_Txt"),
                    //           style:
                    //               TextStyle(fontSize: 12, color: Colors.lightBlue),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  Widget getMembershipItemList(int facilityId, int facilityItemGroupId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 0, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.userProfileInfo.associatedProfileList != null
                    ? widget.userProfileInfo.associatedProfileList.length
                    : 0,
                itemBuilder: (context, j) {
                  return
                      //    ? Text("")
                      //  :
                      Visibility(
                          visible: true,
                          child: Container(
                              margin:
                                  EdgeInsets.only(top: 5, left: 8, right: 8),
                              child: Stack(
                                children: [
                                  SizedBox(height: 5),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .12,
                                    width:
                                        MediaQuery.of(context).size.width * .98,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                      border:
                                          Border.all(color: Colors.grey[200]),
                                      color: Colors.white,
                                    ),
                                    child: Stack(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10.0,
                                                      bottom: 10.0)
                                                  : EdgeInsets.only(
                                                      top: 10.0,
                                                      right: 10.0,
                                                      bottom: 10.0),
                                          child: Row(
                                            children: [
                                              Flexible(
                                                  child: Text(
                                                widget
                                                    .userProfileInfo
                                                    .associatedProfileList[j]
                                                    .facilityItemName,
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor
                                                        .withOpacity(1.0),
                                                    fontSize: Styles
                                                        .packageExpandTextSiz,
                                                    fontFamily:
                                                        tr('currFontFamily')),
                                              )),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? const EdgeInsets.only(
                                                      top: 40,
                                                      left: 10,
                                                      right: 10)
                                                  : const EdgeInsets.only(
                                                      top: 40,
                                                      right: 10,
                                                      left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Start Date ' +
                                                      DateTimeUtils().dateToStringFormat(
                                                          DateTimeUtils().stringToDate(
                                                              widget
                                                                  .userProfileInfo
                                                                  .associatedProfileList[
                                                                      j]
                                                                  .subContractStartDate
                                                                  .substring(
                                                                      0, 10),
                                                              DateTimeUtils
                                                                  .YYYY_MM_DD_Format),
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                              Text(
                                                  'End Date ' +
                                                      DateTimeUtils().dateToStringFormat(
                                                          DateTimeUtils().stringToDate(
                                                              widget
                                                                  .userProfileInfo
                                                                  .associatedProfileList[
                                                                      j]
                                                                  .subContractEndDate
                                                                  .substring(
                                                                      0, 10),
                                                              DateTimeUtils
                                                                  .YYYY_MM_DD_Format),
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? const EdgeInsets.only(
                                                      top: 60, left: 10)
                                                  : const EdgeInsets.only(
                                                      top: 60, right: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'AED ' +
                                                      widget
                                                          .userProfileInfo
                                                          .associatedProfileList[
                                                              j]
                                                          .price
                                                          .toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )));
                })));
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
