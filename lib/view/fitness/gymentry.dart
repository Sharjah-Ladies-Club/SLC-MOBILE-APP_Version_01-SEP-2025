// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/qrPage.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/view/fitness/membership_page.dart';
import '../../customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'fitnessbuy/fitnessbuy_payment.dart';

class GymEntryPage extends StatelessWidget {
  int screenType;
  List<FacilityMembership> facilityMembers;
  MembershipClassAvailDto classAvailability;
  int haveFitnessMemberShip;
  String colorCode;
  int gateCode;

  GymEntryPage(
      {this.screenType = 1,
      this.facilityMembers,
      this.haveFitnessMemberShip,
      this.colorCode,
      this.classAvailability,
      this.gateCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessBloc>(
      create: (context) => FitnessBloc(null)
        ..add(GetMembershipDetails(facilityId: 3))
        ..add(GetAppDescEvent(descId: screenType == 1 ? 1 : 3))
        ..add(CheckQRCodeEvent(
            scanqrCode: "", locationId: gateCode, checkInStatus: 1))
        ..add(GetPaymentTerms(facilityId: 3)),
      child: GymEntry(
        screenType: screenType,
        haveFitnessMemberShip: haveFitnessMemberShip,
        classAvailability: classAvailability,
        gateCode: gateCode,
        colorCode: colorCode,
      ),
    );
  }
}

class GymEntry extends StatefulWidget {
  int screenType;
  int haveFitnessMemberShip;
  List<FacilityMembership> facilityMembers;
  MembershipClassAvailDto classAvailability;
  String colorCode;
  List<FacilityItems> facilityItem = [];
  FacilityDetailResponse facilityDetail;
  int enquiryDetailId = 0;
  int checkedin = 0;
  int gateCode = 0;
  int sunaAccess = 0;
  int gateAccess = 0;
  GymEntry(
      {this.screenType = 1,
      this.facilityMembers,
      this.haveFitnessMemberShip,
      this.colorCode,
      this.classAvailability,
      this.gateCode});

  @override
  State<GymEntry> createState() => _GymEntryState();
}

class _GymEntryState extends State<GymEntry> with TickerProviderStateMixin {
  TabController tabController;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  DateTime date = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  int haveFitnessMemberShip;
  int sunaAccess = 0;
  int gateAccess = 0;
  String chkInTime = '';
  String chkOutTime = '';
  ProgressBarHandler _handler;
  bool isMember = false;
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  PaymentTerms paymentTerms = new PaymentTerms();
  String cameraScanResult = "";
  String moduleDescription = "";

  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    //debugPrint("Membership Count" + widget.facilityMembers.length.toString());
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
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    widget.facilityDetail = new FacilityDetailResponse(
        facilityId: 3, facilityName: "Fitness", colorCode: 'A81B8D');

    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is FitnessShowProgressBar) {
            _handler.show();
          } else if (state is FitnessHideProgressBar) {
            _handler.dismiss();
          } else if (state is GetMembershipState) {
            if (state.classAvailablity != null) {
              widget.classAvailability = state.classAvailablity;
              setState(() {
                sunaAccess = widget.classAvailability.steamSauna;
                gateAccess = widget.classAvailability.gym;
                haveFitnessMemberShip =
                    widget.classAvailability.haveFitnessMemberShip;
              });
            }
            if (state.facilityMembership != null &&
                SPUtil.getInt(Constants.USER_CUSTOMERID) == 0) {
              widget.facilityMembers = state.facilityMembership;
              widget.classAvailability = state.classAvailablity;
              if (widget.facilityMembers != null &&
                  widget.facilityMembers.length > 0) {
                SPUtil.putInt(Constants.USER_CUSTOMERID,
                    widget.facilityMembers[0].customerId);
                setState(() {
                  haveFitnessMemberShip =
                      widget.classAvailability.haveFitnessMemberShip;
                  sunaAccess = widget.classAvailability.steamSauna;
                  gateAccess = widget.classAvailability.gym;
                });
              }
            }
          } else if (state is CheckQRCodeState) {
            widget.checkedin = state.result.isCheckedIn;
            debugPrint("ISChecked In Status" + widget.checkedin.toString());
            if (widget.checkedin == -1) {
              debugPrint("ISChecked In Status" + widget.checkedin.toString());
              customGetSnackBarWithOutActionButton(
                  "Check In", "Invalid QR Code", context);
            }
            debugPrint("======Time ${state.result.checkInDate}");
            setState(() {
              chkInTime = state.result.checkInDate == null
                  ? ''
                  : state.result.checkInDate;
              chkOutTime = state.result.checkInDate == null
                  ? ''
                  : state.result.checkOutDate;
            });
          } else if (state is SaveCheckInOutState) {
            widget.checkedin = state.result.isCheckedIn;
            debugPrint("ISChecked In StatusSave" + widget.checkedin.toString());
            if (widget.checkedin == -1) {
              debugPrint("ISChecked In Status" + widget.checkedin.toString());
              customGetSnackBarWithOutActionButton(
                  "Check In", "Invalid QR Code", context);
            } else {
              //set date from the result
              debugPrint("======Time ${state.result.checkInDate}");
              setState(() {
                chkInTime = state.result.checkInDate == null
                    ? ''
                    : state.result.checkInDate;
                chkOutTime = state.result.checkOutDate == null
                    ? ''
                    : state.result.checkOutDate;
              });
              if (chkInTime != '' && chkOutTime == '') {
                customGetSnackBarWithOutActionButton(
                    "Check In", "Thanks for checkin", context);
              } else if (chkInTime != '' && chkOutTime != '') {
                customGetSnackBarWithOutActionButton(
                    "Check Out", "Thanks for checkout", context);
              }
            }
          } else if (state is GetFitnessItemState) {
            widget.facilityItem = state.fitnessItem;
          } else if (state is FitnessGetPaymentTermsResult) {
            paymentTerms = state.paymentTerms;
          } else if (state is GetAppDescState) {
            if (state.result != null) {
              debugPrint(state.result.descEn);
              moduleDescription =
                  Localizations.localeOf(context).languageCode == "en"
                      ? state.result.descEn
                      : state.result.descAr;
              setState(() {});
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
              // backgroundColor: ColorData.backgroundColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: CustomAppBar(
                  title: tr("fitness_title"),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/fitness_bg.png"),
                        fit: BoxFit.cover)),
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.3,
                      child: Image.asset(
                        widget.screenType == 1
                            ? 'assets/images/fitnessgymbg.png'
                            : 'assets/images/setambg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: ColorData.fitnessFacilityColor,
                    ),
                    Container(
                        height: screenWidth * 0.10,
                        width: double.infinity,
                        color: ColorData.fitnessBgColor,
                        padding: EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 8),
                        child: Text(
                            widget.screenType == 1
                                ? tr("fitness_gym")
                                : tr("steam_sauna"),
                            style: TextStyle(
                                fontSize: Styles.textSizeSeventeen,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold))),
                    Container(
                        height: screenWidth * 0.20,
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        color: ColorData.whiteColor,
                        padding: EdgeInsets.only(
                            top: 8, left: 8, right: 8, bottom: 8),
                        child: SingleChildScrollView(
                            child: Text(
                          moduleDescription != null ? moduleDescription : "",
                          style: TextStyle(
                              fontSize: Styles.packageExpandTextSiz,
                              color: ColorData.primaryTextColor),
                        ))),
                    Container(
                      height: 2,
                      width: double.infinity,
                      color: ColorData.fitnessBgColor,
                    ),
                    (haveFitnessMemberShip == 0 ||
                            (widget.screenType == 1 && gateAccess == 0) ||
                            (widget.screenType != 1 && sunaAccess == 0))
                        ? Container(
                            height: screenWidth * 0.10,
                            width: double.infinity,
                            color: ColorData.fitnessBgColor,
                            padding: EdgeInsets.only(
                                top: 8, left: 8, right: 8, bottom: 8),
                            child: Text(
                                widget.screenType == 1
                                    ? tr("gym_entrance")
                                    : tr("steam_sauna_entrance"),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSeventeen,
                                    color: ColorData.fitnessFacilityColor,
                                    fontWeight: FontWeight.bold)))
                        : SizedBox(),
                    (haveFitnessMemberShip != 0 &&
                                gateAccess == 1 &&
                                widget.screenType == 1) ||
                            (haveFitnessMemberShip != 0 &&
                                widget.screenType != 1 &&
                                sunaAccess == 1)
                        ? Container(
                            height: screenHeight * 0.085,
                            width: double.infinity,
                            color: ColorData.whiteColor,
                            padding: EdgeInsets.only(
                                bottom: 4, left: 4, right: 4, top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/schedule.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 24),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat('dd-MMM-yyyy').format(
                                                DateTime(
                                                    _selectedDate.year,
                                                    _selectedDate.month,
                                                    _selectedDate.day)),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize:
                                                    Styles.loginBtnFontSize,
                                                color: ColorData
                                                    .fitnessFacilityColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            DateFormat("EEEE")
                                                .format(DateTime(date.year,
                                                    date.month, date.day))
                                                .toUpperCase(),
                                            // : DateFormat("EEEE")
                                            //         .format(DateTime(date.year,
                                            //             date.month, date.day))
                                            //         .toUpperCase() +
                                            //     formatTimeOfDay(),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                                fontSize: Styles.textSizTwenty,
                                                color: ColorData
                                                    .fitnessFacilityColor,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Visibility(
                                      visible:
                                          widget.checkedin == 20 ? true : false,
                                      child: Padding(
                                          padding: EdgeInsets.only(right: 6),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.checkedin != 20
                                                    ? tr('check_out')
                                                    : tr('checked_in_at'),
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.loginBtnFontSize,
                                                    color: ColorData
                                                        .primaryTextColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                widget.checkedin != 20
                                                    ? chkOutTime
                                                    : chkInTime,
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.textSizTwenty,
                                                    color: ColorData
                                                        .fitnessFacilityColor,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          )),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        var ctx = context;
                                        customAlertDialog(
                                            context,
                                            widget.checkedin == 20
                                                ? tr(
                                                    'you_are_about_to_checkout')
                                                : tr(
                                                    'you_are_about_to_checkin'),
                                            tr('yes'),
                                            tr('no'),
                                            tr('confirm'),
                                            widget.checkedin == 20
                                                ? tr('check-out')
                                                : tr('check-in'),
                                            () => {
                                                  Navigator.pop(context),
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            QrPage(
                                                              colorCode: null,
                                                              sourcePage:
                                                                  "FITNESS",
                                                              handlerCallback:
                                                                  (String
                                                                      scanData) async {
                                                                cameraScanResult =
                                                                    scanData;
                                                                BlocProvider.of<FitnessBloc>(ctx).add(SaveCheckInOutEvent(
                                                                    scanqrCode:
                                                                        cameraScanResult,
                                                                    checkInStatus:
                                                                        0,
                                                                    locationId:
                                                                        widget
                                                                            .gateCode));
                                                              },
                                                            )),
                                                  ),
                                                });
                                      },
                                      child: Container(
                                        height: screenHeight * 0.04,
                                        padding: EdgeInsets.all(4),
                                        // left: 4, right: 4),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: ColorData
                                                    .fitnessFacilityColor),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4))),
                                        alignment: Alignment.center,
                                        // width: 60,
                                        child: Text(
                                          widget.checkedin == 20
                                              ? tr('check_out')
                                              : tr('check-in'),
                                          style: TextStyle(
                                            fontSize: Styles.reviewTextSize,
                                            color:
                                                ColorData.fitnessFacilityColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : SizedBox(),
                    ((widget.screenType == 1 && gateAccess == 0) ||
                            (widget.screenType != 1 && sunaAccess == 0))
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (widget.screenType == 1) {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              FitnessMembershipPage(
                                                memID: 0,
                                                memName: "",
                                                abcID: SPUtil.getInt(
                                                    Constants.USER_CUSTOMERID),
                                                validity: DateTimeUtils()
                                                    .dateToStringFormat(
                                                        DateTime.now(),
                                                        DateTimeUtils
                                                            .ServerFormat),
                                                facilityId: widget
                                                    .facilityDetail.facilityId,
                                                colorCode: "A81B8D",
                                                moduleId: widget.screenType,
                                              )),
                                    );
                                  } else {
                                    Meta f1 = await FacilityDetailRepository()
                                        .getFitnessItem(33648);

                                    List<FacilityItems> fitem = [];
                                    List<BillDiscounts> billDiscounts = [];

                                    if (f1.statusCode == 200) {
                                      widget.facilityItem.clear();
                                      fitem = jsonDecode(
                                              f1.statusMsg)['response']
                                          .forEach((f) => widget.facilityItem
                                              .add(new FacilityItems.fromJson(
                                                  f)));
                                    }

                                    // double totalItems = 1;
                                    double total =
                                        widget.facilityItem != null &&
                                                widget.facilityItem.length > 0
                                            ? widget.facilityItem[0].price
                                            : 0;

                                    Meta m = await FacilityDetailRepository()
                                        .getDiscountList(
                                            widget.facilityDetail.facilityId,
                                            total,
                                            itemId: 33648);

                                    if (m.statusCode == 200) {
                                      jsonDecode(m.statusMsg)['response']
                                          .forEach((f) => billDiscounts.add(
                                              new BillDiscounts.fromJson(f)));
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
                                    Meta m1 = await FacilityDetailRepository()
                                        .getGiftVouchers();
                                    if (m1.statusCode == 200) {
                                      jsonDecode(m1.statusMsg)['response']
                                          .forEach((f) => vouchers.add(
                                              new GiftVocuher.fromJson(f)));
                                    }
                                    // Disable collage
                                    if (vouchers == null) {
                                      vouchers = [];
                                    }

                                    Navigator.pop(context);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              new FitnessBuyPaymentPage(
                                                  facilityItems:
                                                      widget.facilityItem,
                                                  enquiryDetailId: 0,
                                                  total: total,
                                                  itemCounts: itemCounts,
                                                  retailItemSetId: "",
                                                  facilityId: widget
                                                      .facilityDetail
                                                      .facilityId,
                                                  tableNo: 0,
                                                  colorCode: "A81B8D",
                                                  billDiscounts: billDiscounts,
                                                  giftVouchers: vouchers,
                                                  paymentTerms: paymentTerms,
                                                  bookingId: 0,
                                                  moduleId:
                                                      widget.screenType == 1
                                                          ? 11
                                                          : 12,
                                                  screenCode:
                                                      widget.screenType),
                                        ));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      ColorData.fitnessFacilityColor,
                                  side: BorderSide(
                                      width: 1.0, color: Colors.transparent),
                                ),
                                child: Text(
                                    widget.screenType == 1
                                        ? tr('buy_membership')
                                        : tr("buy_session"),
                                    style: TextStyle(
                                      fontSize: Styles.loginBtnFontSize,
                                      color: ColorData.whiteColor,
                                    )),
                              ),
                            ],
                          )
                        : Container(
                            height: 2,
                            width: double.infinity,
                            color: ColorData.fitnessBgColor,
                          )
                  ],
                ),
              )
              // bottomNavigationBar: Container(
              //   padding: EdgeInsets.only(bottom: 8),
              //   color: ColorData.whiteColor,
              //   height: screenHeight * 0.08,
              //   child: ,
              // ),
              ),
        ));
  }

  String formatTimeOfDay() {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, now.hour, now.minute);
    final format = DateFormat.jm(); //"6:00 AM"
    return format.format(dt);
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
}
