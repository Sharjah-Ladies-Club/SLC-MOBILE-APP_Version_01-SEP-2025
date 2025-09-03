// import 'dart:math';
// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui' as uiprefix;

import 'package:barcode/barcode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:share/share.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_active_facility_select_component.dart';
import 'package:slc/customcomponentfields/custom_dob_component.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/expansiontile/groovenexpan.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/Faculty.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/slot.dart';
import 'package:slc/model/transaction_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/dashboard/dashboard.dart';
import 'package:slc/view/enquiry/new_enquiry.dart';
import 'package:slc/view/mypage/bloc/bloc.dart';
import 'package:table_calendar/table_calendar.dart';

bool isExpanded = false;
class MyPage extends StatelessWidget {
  List<TransactionResponse> transactionList = [];
  List<LoyaltyVoucherResponse> loyaltyVoucherList =
      [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyPageBloc>(
      create: (context) => MyPageBloc(myPageBloc: null)..add(new MyPageTransactionLoadEvent()),
      child: _MyPage(
        transactionList: this.transactionList,
      ),
    );
  }
}

class _MyPage extends StatefulWidget {
  List<TransactionResponse> transactionList = [];
  _MyPage({this.transactionList});
  int listIndex=0;
  String colorCode="#EEEEEE";
  @override
  _MyPageState createState() =>
      _MyPageState(transactionList: this.transactionList);
}

const List<String> list = <String>['50', '52', '53', '54','55',"56","57","58"];

class _MyPageState extends State<_MyPage> {
  var value = 2;
  bool showVouchers = true;
  bool isMembershipVoucher=false;
  bool isSpaVoucher=false;
  bool isObbVoucher=false;
  bool isCorporateVoucher=false;

  bool isFitnessVoucher=false;
  bool isGiftCard=false;
  bool showMembershipVouchers=false;
  bool showCorporateVouchers=false;
  bool showSpaVouchers=false;
  bool showFitnessVoucher=false;

  bool showObbVouchers=false;
  bool showGiftCard=false;

  List<TransactionResponse> transactionList = [];
  List<LoyaltyVoucherResponse> voucherList = [];
  List<LoyaltyVoucherResponse> voucherRedemptionList =
      [];
  List<String> voucherRedemptionFacilities= [];
  List<LoyaltyVoucherResponse> displayVoucherRedemptionList =
  [];
  List<GiftVocuher> giftCardVouchers =[];
  List<GiftCardDetailsDTO> giftCardDetails=[];
  List<ActiveFacilityViewDto> activeFacilites =[];
  PointResponse points = new PointResponse();
  CalendarController _controller = new CalendarController();
  List<Slot> currentOldSlots = [];
  List<TimeTable> currentSlots = [];
  String selectedDate="";
  _MyPageState({this.transactionList});
  List<DropdownMenuItem<Faculty>> _facultyDropdownList =
      [];
  Faculty _faculty = new Faculty();
  ActiveFacilityViewDto selectedActiveFacility=new ActiveFacilityViewDto();
  TextEditingController _customFromController = new TextEditingController();
  TextEditingController _customToController = new TextEditingController();
  MaskedTextController _otpController =
  new MaskedTextController(mask: Strings.maskMobileValidationStr);
  MaskedTextController _shareMobileController =
  new MaskedTextController(mask: Strings.maskMobileValidationStr);
  TextEditingController _otpamountController = new TextEditingController();
  // MaskedTextController _otpamountController =
  // new MaskedTextController(mask: Strings.maskAmountStr);
  TextEditingController _activeFacilityController =
  new TextEditingController();

  bool isShareMobileFocus = false;

  bool otpSent=false;
  String giftVoucherOtp="";
  bool isVoucherRedemptionProgress=false;
  Utils util = Utils();
  GlobalKey globalKey = new GlobalKey();
  GlobalKey globalKeyQr = new GlobalKey();
  ProgressBarHandler _handler;

  //Expand collapse
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int selectedGiftCardIndex = -1;
  bool ismainExpanded = false;
  Key key;
  int number = Random().nextInt(2000000000);
  AutoScrollController scrlController;
  String dropdownValue = list.first;


  @override
  void initState() {
    // TODO: implement initState
    scrlController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    selectedIndex = widget.listIndex;
    isExpanded = true;
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
    return BlocListener<MyPageBloc, MyPageState>(
        listener: (context, state) async {
          if (state is ShowProgressBar) {
            _handler.show();
          } else if (state is HideProgressBar) {
            _handler.dismiss();
          }else if (state is MyPageTransactionLoadState) {
            if (state.transactionResponse != null) {
              setState(() {
                widget.transactionList = state.transactionResponse;
              });
            }

            List<LoyaltyVoucherResponse> tvoucherRedemptionList =
            [];
            Meta m1 =
            await (new FacilityDetailRepository())
                .getRedemptionList(0, 0,4);
            debugPrint("i am ttt");
            if (m1.statusCode == 200) {
              jsonDecode(m1.statusMsg)["response"]
                  .forEach((f) =>
                  tvoucherRedemptionList.add(
                      new LoyaltyVoucherResponse
                          .fromJson(f)));
            }
            if(tvoucherRedemptionList!=null && tvoucherRedemptionList.length>0){
              setState(() {
                showMembershipVouchers=true;
              });
            }
            debugPrint("i am ddddddddddddd");
            List<LoyaltyVoucherResponse> tcorporateRedemptionList =
            [];

            Meta m2 = await (new FacilityDetailRepository())
                .getRedemptionList(0, 0,8);
            if (m2.statusCode == 200) {
              jsonDecode(m2.statusMsg)["response"]
                  .forEach((f) =>
                  tcorporateRedemptionList.add(
                      new LoyaltyVoucherResponse
                          .fromJson(f)));
            }

            if(tcorporateRedemptionList!=null && tcorporateRedemptionList.length>0){
              setState(() {
                showCorporateVouchers=true;
              });
            }

            List<LoyaltyVoucherResponse> tfitnessRedemptionList =
            [];

            Meta mf = await (new FacilityDetailRepository())
                .getFitnessRedemptionList(0, 0,6);
            if (mf.statusCode == 200) {
              jsonDecode(mf.statusMsg)["response"]
                  .forEach((f) =>
                  tfitnessRedemptionList.add(
                      new LoyaltyVoucherResponse
                          .fromJson(f)));
            }

            if(tfitnessRedemptionList!=null && tfitnessRedemptionList.length>0){
              setState(() {
                showFitnessVoucher=true;
              });
            }

            List<LoyaltyVoucherResponse> tspaRedemptionList =
            [];
            Meta m3 = await (new FacilityDetailRepository())
                .getFitnessRedemptionList(0, 0,9);
            if (m3.statusCode == 200) {
              jsonDecode(m3.statusMsg)["response"]
                  .forEach((f) =>
                  tspaRedemptionList.add(
                      new LoyaltyVoucherResponse
                          .fromJson(f)));
            }

            if(tspaRedemptionList!=null && tspaRedemptionList.length>0){
              setState(() {
                showSpaVouchers=true;
              });
            }else{
              showSpaVouchers=false;

            }
            List<LoyaltyVoucherResponse> tobbRedemptionList =
            [];
            Meta m4 = await (new FacilityDetailRepository())
                .getFitnessRedemptionList(0, 0,10);
            if (m4.statusCode == 200) {
              jsonDecode(m4.statusMsg)["response"]
                  .forEach((f) =>
                  tobbRedemptionList.add(
                      new LoyaltyVoucherResponse
                          .fromJson(f)));
            }

            if(tobbRedemptionList!=null && tobbRedemptionList.length>0){
              setState(() {
                showObbVouchers=true;
              });
            }

            giftCardVouchers=[];
            Meta g1 = await FacilityDetailRepository()
                .getAllGiftVouchers();
            if (g1.statusCode == 200) {
              jsonDecode(g1.statusMsg)['response'].forEach(
                      (f) => giftCardVouchers
                      .add(new GiftVocuher.fromJson(f)));
            }

            if(giftCardVouchers!=null && giftCardVouchers.length>0){
              setState(() {
                showGiftCard=true;
              });
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr('mypage'),
              ),
            ),
            body:
                // SingleChildScrollView(
                //   child:
                Container(
              height: MediaQuery.of(context).size.height * 0.99,
              width: MediaQuery.of(context).size.width * 0.99,
              color: Color(0xFFF0F8FF),
              child: Stack(children:[Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: 8, left: 6, right: 6),
                    height: MediaQuery.of(context).size.height * 0.075,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 2, right: 2),
                          child: Row(
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: ButtonTheme(
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                          MaterialStateProperty.all<
                                              Color>(Colors.white),
                                          backgroundColor:
                                          MaterialStateProperty.all<
                                              Color>((value == 1)
                                              ? ColorData.activeIconColor
                                              : Colors.grey[200]),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? BorderRadius.only(
                                                          topLeft: Radius.circular(16),
                                                          bottomLeft: Radius.circular(16))
                                                      : BorderRadius.only(
                                                          topRight: Radius.circular(16),
                                                          bottomRight:
                                                              Radius.circular(16))))),
                                      // shape: RoundedRectangleBorder(
                                      //   borderRadius: Localizations.localeOf(
                                      //                   context)
                                      //               .languageCode ==
                                      //           "en"
                                      //       ? BorderRadius.only(
                                      //           topLeft: Radius.circular(16),
                                      //           bottomLeft: Radius.circular(16))
                                      //       : BorderRadius.only(
                                      //           topRight: Radius.circular(16),
                                      //           bottomRight:
                                      //               Radius.circular(16)),
                                      // ),
                                      onPressed: () async {
                                        _handler.show();
                                        points = new PointResponse();
                                        Meta m1 =
                                            await (new FacilityDetailRepository())
                                                .getPoints();
                                        if (m1.statusCode == 200) {
                                          points = new PointResponse.fromJson(
                                              jsonDecode(
                                                  m1.statusMsg)["response"]);
                                        }
                                        voucherList =
                                           [];
                                        Meta m =
                                            await (new FacilityDetailRepository())
                                                .getVoucherList(0, 0);
                                        if (m.statusCode == 200) {
                                          jsonDecode(m.statusMsg)["response"]
                                              .forEach((f) => voucherList.add(
                                                  new LoyaltyVoucherResponse
                                                      .fromJson(f)));
                                        }
                                        setState(() {
                                          value = 1;
                                          print(value);
                                        });
                                        _handler.dismiss();
                                      },
                                      // color: (value == 1)
                                      //     ? ColorData.activeIconColor
                                      //     : Colors.grey[200],
                                      child: Text(tr("rewards"),
                                          style: TextStyle(
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              color: (value == 1)
                                                  ? Colors.white
                                                  : Colors.black54)),
                                    ),
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>( (value == 2)
                                          ? ColorData.activeIconColor
                                          : Colors.grey[200]),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(0),
                                              )))),
                                  onPressed: () {
                                    BlocProvider.of<MyPageBloc>(context)
                                        .add(MyPageTransactionLoadEvent());
                                    setState(() {
                                      value = 2;
                                      print(value);
                                    });
                                  },
                                  // color: (value == 2)
                                  //     ? ColorData.activeIconColor
                                  //     : Colors.grey[200],
                                  child: Text(tr("transaction"),
                                      style: TextStyle(
                                          fontSize: Styles.packageExpandTextSiz,
                                          color: (value == 2)
                                              ? Colors.white
                                              : Colors.black54)),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.30,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(Colors.white),
                                      backgroundColor:
                                      MaterialStateProperty.all<Color>( (value == 3)
                                          ? ColorData.activeIconColor
                                          : Colors.grey[200]),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: Localizations.localeOf(
                                                              context)
                                                          .languageCode ==
                                                      "en"
                                                  ? BorderRadius.only(
                                                      topRight: Radius.circular(16),
                                                      bottomRight: Radius.circular(16))
                                                  : BorderRadius.only(
                                                      topLeft: Radius.circular(16),
                                                      bottomLeft: Radius.circular(16)),
                                          ))),
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: Localizations.localeOf(
                                  //                   context)
                                  //               .languageCode ==
                                  //           "en"
                                  //       ? BorderRadius.only(
                                  //           topRight: Radius.circular(16),
                                  //           bottomRight: Radius.circular(16))
                                  //       : BorderRadius.only(
                                  //           topLeft: Radius.circular(16),
                                  //           bottomLeft: Radius.circular(16)),
                                  // ),
                                  onPressed: () {
                                    setState(() {
                                      value = 3;
                                      print(value);
                                    });
                                  },
                                  // color: (value == 3)
                                  //     ? ColorData.activeIconColor
                                  //     : Colors.grey[200],
                                  child: Text(tr("booking"),
                                      style: TextStyle(
                                          fontSize: Styles.packageExpandTextSiz,
                                          color: (value == 3)
                                              ? Colors.white
                                              : Colors.black54)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: value == 1 ? true : false,
                      child: Column(children: [

                        Container(
                            margin: EdgeInsets.only(
                                top: 8, left: 8, right:8, bottom: 8),
                            child: Row(children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(showVouchers || (!showVouchers && !isCorporateVoucher && !isMembershipVoucher && !isGiftCard && !isFitnessVoucher&& !isSpaVoucher)
                                        ? ColorData.activeIconColor
                                        : Colors.grey[200]),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2.0),
                                            )))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(2)),
                                onPressed: () async {
                                  _handler.show();
                                  voucherList =
                                      [];
                                  Meta m =
                                      await (new FacilityDetailRepository())
                                          .getVoucherList(0, 0);
                                  if (m.statusCode == 200) {
                                    jsonDecode(m.statusMsg)["response"].forEach(
                                        (f) => voucherList.add(
                                            new LoyaltyVoucherResponse.fromJson(
                                                f)));
                                  }
                                  setState(() {
                                    showVouchers = true;
                                    isCorporateVoucher=false;
                                    isMembershipVoucher=false;
                                    isGiftCard=false;
                                    isObbVoucher=false;
                                    isSpaVoucher=false;
                                    isFitnessVoucher=false;
                                  });
                                  _handler.dismiss();
                                },
                                // color: showVouchers || (!showVouchers && !isMembershipVoucher && !isGiftCard)
                                //     ? ColorData.activeIconColor
                                //     : Colors.grey[200],
                                child: Text(tr("available_vouchers"),
                                    style: TextStyle(
                                        color: showVouchers || (!showVouchers && !isCorporateVoucher && !isMembershipVoucher && !isGiftCard && !isFitnessVoucher && !isSpaVoucher)
                                            ? Colors.white
                                            : ColorData.primaryTextColor,
                                        fontSize: 12)),
                              ),
                              Visibility(visible:showMembershipVouchers,child:
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                          !showVouchers &&  !isCorporateVoucher  && !isObbVoucher && !isSpaVoucher && isMembershipVoucher &&  !isFitnessVoucher
                                              ? ColorData.activeIconColor
                                              : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      voucherRedemptionList =
                                      [];
                                      Meta m =
                                      await (new FacilityDetailRepository())
                                          .getRedemptionList(0, 0,4);
                                      if (m.statusCode == 200) {
                                        jsonDecode(m.statusMsg)["response"]
                                            .forEach((f) =>
                                            voucherRedemptionList.add(
                                                new LoyaltyVoucherResponse
                                                    .fromJson(f)));
                                      }
                                      voucherRedemptionFacilities=[];
                                      displayVoucherRedemptionList=[];
                                      if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
                                        String firstFacility="";
                                        for(var v in voucherRedemptionList){
                                          if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
                                            voucherRedemptionFacilities.add(v.voucherName);
                                            if(firstFacility==""){
                                              firstFacility=v.voucherName;
                                            }
                                          }
                                          if(v.voucherName==firstFacility) {
                                            displayVoucherRedemptionList.add(
                                                v);
                                          }
                                        }
                                        // debugPrint("DDDDDDDDDDDDDDDDDD"+displayVoucherRedemptionList.length.toString());
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=true;
                                        isGiftCard=false;
                                        isObbVoucher=false;
                                        isSpaVoucher=false;
                                        isFitnessVoucher=false;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: !showVouchers && isMembershipVoucher
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(tr('membership_vouchers'),
                                        style: TextStyle(
                                            color: !showVouchers && !isObbVoucher && !isSpaVoucher &&  isMembershipVoucher && !isFitnessVoucher
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  ))),
                              Visibility(visible:showCorporateVouchers,child:
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            !showVouchers && !isMembershipVoucher && !isObbVoucher && !isSpaVoucher && isCorporateVoucher && !isFitnessVoucher
                                                ? ColorData.activeIconColor
                                                : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      voucherRedemptionList =
                                      [];
                                      Meta m =
                                      await (new FacilityDetailRepository())
                                          .getRedemptionList(0, 0,8);
                                      if (m.statusCode == 200) {
                                        jsonDecode(m.statusMsg)["response"]
                                            .forEach((f) =>
                                            voucherRedemptionList.add(
                                                new LoyaltyVoucherResponse
                                                    .fromJson(f)));
                                      }
                                      voucherRedemptionFacilities=[];
                                      displayVoucherRedemptionList=[];
                                      if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
                                        String firstFacility="";
                                        for(var v in voucherRedemptionList){
                                          if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
                                            voucherRedemptionFacilities.add(v.voucherName);
                                            if(firstFacility==""){
                                              firstFacility=v.voucherName;
                                            }
                                          }
                                          if(v.voucherName==firstFacility) {
                                            displayVoucherRedemptionList.add(
                                                v);
                                          }
                                        }
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=false;
                                        isCorporateVoucher=true;
                                        isObbVoucher=false;
                                        isSpaVoucher=false;
                                        isGiftCard=false;
                                        isFitnessVoucher=false;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: !showVouchers && isMembershipVoucher
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(SPUtil.getInt(Constants.USER_CORPORATEID)>1 ?tr('corporate_voucher'): tr('staff_voucher'),
                                        style: TextStyle(
                                            color: !showVouchers && !showMembershipVouchers && !isObbVoucher && !isSpaVoucher && isCorporateVoucher && !isFitnessVoucher
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  ))),
                              Visibility(visible:showFitnessVoucher,child:
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            !isSpaVoucher &&  !showVouchers &&  !isCorporateVoucher  && !isObbVoucher && !isMembershipVoucher && isFitnessVoucher
                                                ? ColorData.activeIconColor
                                                : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      voucherRedemptionList =
                                      [];
                                      Meta m =
                                      await (new FacilityDetailRepository())
                                          .getFitnessRedemptionList(0, 0,6);
                                      if (m.statusCode == 200) {
                                        jsonDecode(m.statusMsg)["response"]
                                            .forEach((f) =>
                                            voucherRedemptionList.add(
                                                new LoyaltyVoucherResponse
                                                    .fromJson(f)));
                                      }
                                      voucherRedemptionFacilities=[];
                                      displayVoucherRedemptionList=[];
                                      if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
                                        String firstFacility="";
                                        for(var v in voucherRedemptionList){
                                          if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
                                            voucherRedemptionFacilities.add(v.voucherName);
                                            if(firstFacility==""){
                                              firstFacility=v.voucherName;
                                            }
                                          }
                                          if(v.voucherName==firstFacility) {
                                            displayVoucherRedemptionList.add(
                                                v);
                                          }
                                        }
                                        // debugPrint("DDDDDDDDDDDDDDDDDD"+displayVoucherRedemptionList.length.toString());
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=false;
                                        isGiftCard=false;
                                        isObbVoucher=false;
                                        isSpaVoucher=false;
                                        isFitnessVoucher=true;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: !showVouchers && isMembershipVoucher
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(tr('fitness'),
                                        style: TextStyle(
                                            color: !showVouchers && !isObbVoucher && !isSpaVoucher &&  !isMembershipVoucher && isFitnessVoucher
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  ))),
                              Visibility(visible:showSpaVouchers,child:
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            isSpaVoucher &&  !showVouchers &&  !isCorporateVoucher  && !isObbVoucher && !isMembershipVoucher &&  !isFitnessVoucher
                                                ? ColorData.activeIconColor
                                                : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      voucherRedemptionList =
                                      [];
                                      Meta m =
                                      await (new FacilityDetailRepository())
                                          .getFitnessRedemptionList(0, 0,9);
                                      if (m.statusCode == 200) {
                                        jsonDecode(m.statusMsg)["response"]
                                            .forEach((f) =>
                                            voucherRedemptionList.add(
                                                new LoyaltyVoucherResponse
                                                    .fromJson(f)));
                                      }
                                      voucherRedemptionFacilities=[];
                                      displayVoucherRedemptionList=[];
                                      if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
                                        String firstFacility="";
                                        for(var v in voucherRedemptionList){
                                          if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
                                            voucherRedemptionFacilities.add(v.voucherName);
                                            if(firstFacility==""){
                                              firstFacility=v.voucherName;
                                            }
                                          }
                                          if(v.voucherName==firstFacility) {
                                            displayVoucherRedemptionList.add(
                                                v);
                                          }
                                        }
                                        // debugPrint("DDDDDDDDDDDDDDDDDD"+displayVoucherRedemptionList.length.toString());
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=false;
                                        isGiftCard=false;
                                        isObbVoucher=false;
                                        isSpaVoucher=true;
                                        isFitnessVoucher=false;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: !showVouchers && isMembershipVoucher
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(tr('SPA'),
                                        style: TextStyle(
                                            color: !showVouchers && !isObbVoucher && isSpaVoucher &&  !isMembershipVoucher &&  !isFitnessVoucher
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  ))),
                              Visibility(visible:showObbVouchers,child:
                              Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            isObbVoucher && !showVouchers &&  !isCorporateVoucher  &&  !isSpaVoucher && !isMembershipVoucher &&  !isFitnessVoucher
                                                ? ColorData.activeIconColor
                                                : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      voucherRedemptionList =
                                      [];
                                      Meta m =
                                      await (new FacilityDetailRepository())
                                          .getFitnessRedemptionList(0, 0,10);
                                      if (m.statusCode == 200) {
                                        jsonDecode(m.statusMsg)["response"]
                                            .forEach((f) =>
                                            voucherRedemptionList.add(
                                                new LoyaltyVoucherResponse
                                                    .fromJson(f)));
                                      }
                                      voucherRedemptionFacilities=[];
                                      displayVoucherRedemptionList=[];
                                      if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
                                        String firstFacility="";
                                        for(var v in voucherRedemptionList){
                                          if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
                                            voucherRedemptionFacilities.add(v.voucherName);
                                            if(firstFacility==""){
                                              firstFacility=v.voucherName;
                                            }
                                          }
                                          if(v.voucherName==firstFacility) {
                                            displayVoucherRedemptionList.add(
                                                v);
                                          }
                                        }
                                        // debugPrint("DDDDDDDDDDDDDDDDDD"+displayVoucherRedemptionList.length.toString());
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=false;
                                        isGiftCard=false;
                                        isObbVoucher=true;
                                        isSpaVoucher=false;
                                        isFitnessVoucher=false;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: !showVouchers && isMembershipVoucher
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(tr('OBB'),
                                        style: TextStyle(
                                            color: isObbVoucher && !showVouchers &&  !isSpaVoucher &&  !isMembershipVoucher &&  !isFitnessVoucher
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  ))),
                              Visibility(visible:showGiftCard,child:Padding(
                                  padding: EdgeInsets.only(left: 3),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                        MaterialStateProperty.all<Color>(Colors.white),
                                        backgroundColor: MaterialStateProperty.all<Color>(
                                            isGiftCard
                                                ? ColorData.activeIconColor
                                                : Colors.grey[200]),
                                        shape: MaterialStateProperty
                                            .all<RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0),
                                                )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.circular(2)),
                                    onPressed: () async {
                                      _handler.show();
                                      giftCardVouchers=[];
                                      Meta m1 = await FacilityDetailRepository()
                                          .getAllGiftVouchers();
                                      if (m1.statusCode == 200) {
                                        jsonDecode(m1.statusMsg)['response'].forEach(
                                                (f) => giftCardVouchers
                                                .add(new GiftVocuher.fromJson(f)));
                                      }
                                      setState(() {
                                        showVouchers = false;
                                        isMembershipVoucher=false;
                                        isCorporateVoucher=false;
                                        isGiftCard=true;
                                      });
                                      _handler.dismiss();
                                    },
                                    // color: isGiftCard
                                    //     ? ColorData.activeIconColor
                                    //     : Colors.grey[200],
                                    child: Text(tr('gift_card'),
                                        style: TextStyle(
                                            color: isGiftCard
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontSize: 12)),
                                  )))
                            ])),
                        Container(
                          child:Visibility(visible:showVouchers ,child: Container(
                            margin: EdgeInsets.only(left: 0, right: 0),
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: double.infinity,
                            color: Colors.white,
                            // decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     border: Border.all(color: Colors.grey[200])),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      points.points != null
                                          ? tr("myrewards") + '  ' +
                                          points.points.toString() +
                                          " Points"
                                          : tr("myrewards") +'  ' + " 0 Points",
                                      style: TextStyle(
                                          color: ColorData.activeIconColor,
                                          fontSize: Styles.textSizeSeventeen,
                                          fontFamily: tr('currFontFamily'))),
                                ),
                                Visibility(visible:points.redemptionMaintenaceFrom != null?true:false,
                                    child:Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                          points.redemptionMaintenaceFrom != null?
                                          points.redemptionMaintenaceFrom
                                              : "",
                                          style: TextStyle(
                                              color: ColorData.activeIconColor,
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily: tr('currFontFamily'))),
                                    )),
                              ],
                            ),
                          )),
                        )
                      ])),
                  (value == 1)
                      ? Container(
                      height: MediaQuery.of(context).size.height * 0.60,
                      width: MediaQuery.of(context).size.width * 0.99,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            showVouchers ?
                            Column(children:[
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(ColorData.activeIconColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2.0),
                                            )))),
                                // shape: RoundedRectangleBorder(
                                //     borderRadius: BorderRadius.circular(2)),
                                onPressed: () async {
                                  _handler.show();
                                  voucherRedemptionList =
                                  [];
                                  Meta m =
                                  await (new FacilityDetailRepository())
                                      .getRedemptionList(0, 0,0);
                                  if (m.statusCode == 200) {
                                    jsonDecode(m.statusMsg)["response"]
                                        .forEach((f) =>
                                        voucherRedemptionList.add(
                                            new LoyaltyVoucherResponse
                                                .fromJson(f)));
                                  }
                                  setState(() {
                                    showVouchers = false;
                                    isMembershipVoucher=false;
                                    isSpaVoucher=false;
                                    isObbVoucher=false;
                                    isGiftCard=false;
                                    isFitnessVoucher=false;
                                  });
                                  _handler.dismiss();
                                },
                                // color: ColorData.activeIconColor,
                                child: Text(tr('redeemed_vouchers'),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12)),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  height: MediaQuery.of(context).size.height * 0.45,
                                  width: MediaQuery.of(context).size.width * 0.99,child:getDetails())])
                                : isMembershipVoucher?getMembershipRedeemDetails() : isFitnessVoucher?getFitnessRedeemDetails(): isSpaVoucher?getSpaRedeemDetails() :isObbVoucher?getObbRedeemDetails() :isCorporateVoucher?getCorporateRedeemDetails(): isGiftCard?getGiftCardDetails():
                            Column(children:[
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                    MaterialStateProperty.all<Color>(Colors.white),
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(ColorData.activeIconColor),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2.0),
                                            )))),
                                onPressed: () async {
                                  _handler.show();
                                  voucherList =
                                  [];
                                  Meta m =
                                  await (new FacilityDetailRepository())
                                      .getVoucherList(0, 0);
                                  if (m.statusCode == 200) {
                                    jsonDecode(m.statusMsg)["response"].forEach(
                                            (f) => voucherList.add(
                                            new LoyaltyVoucherResponse.fromJson(
                                                f)));
                                  }
                                  setState(() {
                                    showVouchers = true;
                                  });
                                  _handler.dismiss();
                                },
                                // color: ColorData.activeIconColor,

                                child: Text(tr("back_to_vouchers"),
                                    style: TextStyle(
                                        color: Colors.white
                                        ,
                                        fontSize: 12)),
                              ),
                              SizedBox(height: 10,),
                              Container(
                                  height: MediaQuery.of(context).size.height * 0.45,
                                  width: MediaQuery.of(context).size.width * 0.99,child:getRedeemDetails())])
                          ]))
                      : (value == 2)
                          ? Container(
                              height: MediaQuery.of(context).size.height * 0.78,
                              width: MediaQuery.of(context).size.width * 0.99,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [getTransaction()]))
                          : Container(
                              height: MediaQuery.of(context).size.height * 0.78,
                              width: MediaQuery.of(context).size.width * 0.99,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [getCalendar()])),
                ],
              ),progressBar]),
            ),
          ),
        ));
    // );
  }

  Widget getDetails() {
    return GridView.count(
        primary: true,
        crossAxisCount: 2,
        crossAxisSpacing: 1,
        mainAxisSpacing: 1,
        childAspectRatio:(2 / 1),
        children: List.generate(
            voucherList == null ? 0 : voucherList.length, (j) {
          return Container(
            height: MediaQuery.of(context).size.height*0.20,
            child: Stack(
              children: <Widget>[
                Padding(
                    padding:
                    Localizations.localeOf(context).languageCode == "en"
                        ? EdgeInsets.only(top: 0, left: 5)
                        : EdgeInsets.only(top: 0, right: 5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.96,
                            margin: Localizations.localeOf(context)
                                .languageCode ==
                                "en"
                                ? EdgeInsets.only(left: 2)
                                : EdgeInsets.only(right: 2),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  height:MediaQuery.of(context).size.height*0.11,
                                  width:MediaQuery.of(context).size.width*0.475,
                                  margin: Localizations.localeOf(context)
                                      .languageCode ==
                                      "en"
                                      ? EdgeInsets.only(left: 1, top: 1)
                                      : EdgeInsets.only(right: 1, top: 1),
                                  child: Image.network(
                                      voucherList[j].voucherImageUrl,
                                      fit: BoxFit.fill),
                                ),
                                Visibility(
                                    visible: voucherList != null &&
                                        points.points != null &&
                                        voucherList[j].isRedeemEnabled &&
                                        voucherList[j].pointsRequired <=
                                            points.points
                                        ? true
                                        : false,
                                    child: Padding(
                                      padding: Localizations
                                          .localeOf(context)
                                          .languageCode ==
                                          "en"
                                          ? EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.07,
                                          top: 62)
                                          : EdgeInsets.only(
                                          right: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.07,
                                          top: 62),
                                      child:new SizedBox(
                                          width: 50.0,
                                          height: 20.0,
                                          child: OutlinedButton(
                                            child: Text("Redeem",
                                                style: TextStyle(fontSize: 8)),
                                            style: ButtonStyle(
                                                padding: MaterialStateProperty.all<EdgeInsets>(
                                                    EdgeInsets.zero),
                                                foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    ColorData.toColor(voucherList[j]
                                                        .colorCode)),
                                                shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            0),
                                                        side: BorderSide(
                                                            color: ColorData.toColor(voucherList[j].colorCode))))
                                            ),
                                            onPressed: () async {
                                              if (voucherList[j]
                                                  .pointsRequired >
                                                  points.points) {
                                                util.customGetSnackBarWithOutActionButton(
                                                    tr("Redemption"),
                                                    "Do not have sufficient points to redeem this voucher",
                                                    context);
                                                return;
                                              }
                                              _handler.show();
                                              Meta m =
                                              await (new FacilityDetailRepository())
                                                  .saveVoucherRedemption(
                                                  voucherList[j]
                                                      .loyaltyVoucherId,
                                                  voucherList[j]
                                                      .pointsRequired,
                                                  voucherList[j]
                                                      .pointsRequired);
                                              if (m.statusCode == 200) {
                                                points = new PointResponse();
                                                Meta m1 =
                                                await (new FacilityDetailRepository())
                                                    .getPoints();
                                                if (m1.statusCode == 200) {
                                                  setState(() {
                                                    points = new PointResponse.fromJson(
                                                        jsonDecode(
                                                            m1.statusMsg)["response"]);
                                                  });
                                                }
                                                voucherList =[];

                                                Meta m =
                                                await (new FacilityDetailRepository())
                                                    .getVoucherList(0, 0);
                                                if (m.statusCode == 200) {
                                                  setState(() {
                                                    jsonDecode(m.statusMsg)["response"]
                                                        .forEach((f) => voucherList.add(
                                                        new LoyaltyVoucherResponse
                                                            .fromJson(f)));
                                                  });
                                                }
                                                _handler.dismiss();
                                                util.customGetSnackBarWithOutActionButton(
                                                    tr("Redemption"),
                                                    "Redeemed Successfully",
                                                    context);
                                              } else {
                                                _handler.dismiss();
                                                util.customGetSnackBarWithOutActionButton(
                                                    tr("Redemption"),
                                                    m.statusMsg,
                                                    context);
                                              }

                                            },
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ])),
              ],
            ),
          );
        }));
  }

  displaySvg(String rawSvg,width,height) async {
    final DrawableRoot svgRoot = await svg.fromSvgString(rawSvg, rawSvg);
    return await svgRoot.toPicture().toImage(width, height);
  }
  Widget getRedeemDetails() {
    return ListView.builder(
        key: PageStorageKey("Redeem_PageStorageKey"),
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: voucherRedemptionList == null
            ? 0
            : voucherRedemptionList.length,
        itemBuilder: (context, j) {
          return getVoucherDetail(voucherRedemptionList, j);
        });
  }
  Widget getGiftCardDetails() {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("GiftCard_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: giftCardVouchers == null
                ? 0
                : giftCardVouchers.length,
            itemBuilder: (context, j) {
              return ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: 100, minWidth: double.infinity),
                      child: Directionality(
                      textDirection: uiprefix.TextDirection.ltr,
                      child:   Card(
                          elevation: 5,
                          color: ColorData.whiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(children:[
                          Container(
                          height: MediaQuery.of(context).size.height * 0.26,
                          child:
                          Stack(
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 10, bottom: 2),
                                    // Localizations.localeOf(context).languageCode == "en"
                                    //     ? EdgeInsets.only(top: 2, left: 5)
                                    //     : EdgeInsets.only(top: 5, right: 5),
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            height:
                                            MediaQuery.of(context).size.height * 0.24,
                                            width:
                                            MediaQuery.of(context).size.width * 0.95,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  // margin: Localizations.localeOf(context)
                                                  //             .languageCode ==
                                                  //         "en"
                                                  //     ? EdgeInsets.only(left: 1, top: 1)
                                                  //     : EdgeInsets.only(right: 1, top: 1),
                                                  height:
                                                  MediaQuery.of(context).size.height *
                                                      0.4 - 70,
                                                  width:
                                                  MediaQuery.of(context).size.width ,
                                                  child: Image.network(
                                                      giftCardVouchers[j].imageUrl,
                                                      fit: BoxFit.fill),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ])),
                 Padding(
                                    padding: EdgeInsets.only(
                                      left: 38,
                                      top: 120,
                                    ),
                                    // Localizations.localeOf(context).languageCode == "en"
                                    //     ? EdgeInsets.only(top: 2, left: 5)
                                    //     : EdgeInsets.only(top: 5, right: 5),
                                    child: Text(giftCardVouchers[j].giftCardText, style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.textSizeSmall,
                                        fontFamily: tr('currFontFamily')))),
                                Padding(
                                    padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width * 0.82,
                                      top: MediaQuery.of(context).size.height * 0.11,
                                    ),
                                    // Localizations.localeOf(context).languageCode == "en"
                                    //     ? EdgeInsets.only(top: 2, left: 5)
                                    //     : EdgeInsets.only(top: 5, right: 5),
                                    child: Text(
                                        giftCardVouchers[j].balanceAmount.toStringAsFixed(2)
                                , style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.reviewTextSize,
                                    fontFamily: tr('currFontFamily')))),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.820,
                                    top: MediaQuery.of(context).size.height * 0.154,
                                  ),
                                  // Localizations.localeOf(context).languageCode == "en"
                                  //     ? EdgeInsets.only(top: 2, left: 5)
                                  //     : EdgeInsets.only(top: 5, right: 5),
                                  child: Text(
                                          giftCardVouchers[j].giftCardNo.toString(),
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor
                                              .withOpacity(1.0),
                                          fontSize: Styles.reviewTextSize,
                                          fontFamily: tr('currFontFamily'))),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.458 ,
                                    top: MediaQuery.of(context).size.height * 0.200,
                                    right:15
                                  ),
                                  // Localizations.localeOf(context).languageCode == "en"
                                  //     ? EdgeInsets.only(top: 2, left: 5)
                                  //     : EdgeInsets.only(top: 5, right: 5),
                                  child: Align(alignment:Alignment.centerLeft,child:Text(

                                          giftCardVouchers[j].giftCardExpiry
                                          ,
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor
                                              .withOpacity(1.0),
                                          fontSize: Styles.discountTextSize,
                                          fontFamily: tr('currFontFamily'))),
                                ))
                                ,])),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  height: MediaQuery.of(context).size.height * 0.05,
                  child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                       Visibility(visible: (giftCardVouchers[j].balanceAmount>=1 && giftCardVouchers[j].useButton==true)?true:false  ,child: ElevatedButton(
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
              child: Text(tr("use"),
                                      style: TextStyle(color: ColorData
                                          .primaryTextColor,
//                                color: Colors.black45,
                                          fontSize: Styles
                                              .textSizeSmall,
                                          fontFamily: tr(
                                              "currFontFamily"))),
                                  onPressed: () async {
                                    otpSent=false;
                                    activeFacilites=[];
                                    selectedActiveFacility=new ActiveFacilityViewDto();
                                    _otpamountController.text="";
                                    _activeFacilityController.text="";
                                    Meta mf =
                                    await (new FacilityDetailRepository())
                                        .getActiveFacility();
                                    if (mf
                                        .statusCode ==
                                        200) {
                                      jsonDecode(mf.statusMsg)['response'].forEach(
                                              (f) => activeFacilites
                                              .add(new ActiveFacilityViewDto.fromJson(f)));
                                    }
                                    isVoucherRedemptionProgress=false;
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
                                                      tr('voucher_redemption'),
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
                                                    child: Container(
                                                        width: MediaQuery.of(context).size.width * 0.50,
                                                        height: MediaQuery.of(context).size.height * 0.080,
                                                        child: new TextFormField(
                                                            keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),
                                                            controller: _otpamountController,
                                                            textAlign: TextAlign.center,
                                                            decoration: new InputDecoration(
                                                              contentPadding: EdgeInsets.all(5),
                                                              // contentPadding: EdgeInsets.only(
                                                              //     left: 10, top: 0, bottom: 0, right: 0),
                                                              hintText: tr("redeem_amount"),
                                                              border: new OutlineInputBorder(
                                                                  borderSide: new BorderSide(
                                                                      color: Colors.black12)),
                                                              // focusedBorder: OutlineInputBorder(
                                                              //     borderSide: new BorderSide(
                                                              //         color: Colors.grey[200]))),
                                                            ),
                                                            style: TextStyle(
                                                                fontSize: Styles.packageExpandTextSiz,
                                                                fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                color: ColorData.primaryTextColor,
                                                                fontWeight: FontWeight.w200))),
                                                  ),
                                                ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10.0),
                                                    child: Center(
                                                        child: Container(
                                                          width: MediaQuery.of(context).size.width * 0.50,
                                                          height: MediaQuery.of(context).size.height * 0.080,
                                                          child: CustomActiveFacilityComponent(
                                                              selectedFunction: _onChangeOptionDropdown,
                                                              facilityController: _activeFacilityController,
                                                              isEditBtnEnabled: Strings.ProfileCallState,
                                                              facilityResponse:
                                                              activeFacilites,
                                                              label: tr('facility')),
                                                        ))),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Center(
                                                    child: Text(
                                                      tr('redemption_confirm'),
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
                                                          child: new Text(
                                                              !otpSent?tr("no"):tr("cancel"),
                                                              style: TextStyle(
                                                                  color: ColorData.primaryTextColor,
                                                                  fontSize: Styles.textSizeSmall,
                                                                  fontFamily: tr("currFontFamily"))),
                                                          onPressed: () async{
                                                            Navigator.of(
                                                                pcontext)
                                                                .pop();
                                                            // _handler.dismiss();
                                                          }),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                                Colors.white),
                                                            backgroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                                ColorData.colorBlue),
                                                            shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(5.0),
                                                                    )))),
                                                        child: new Text(
                                                          !otpSent?tr("yes"):tr("confirm"),
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
                                                          if(isVoucherRedemptionProgress) return;
                                                          giftVoucherOtp="";
                                                          double enteredAmt =0;
                                                          if(_otpamountController.text.toString()=="" || _otpamountController.text.toString()=="0" || _otpamountController.text.toString()=="0.00"){
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("Redemption"),
                                                                tr("enter_redemption_amount"),
                                                                context);
                                                            return;
                                                          }
                                                          enteredAmt = double.parse(_otpamountController.text);
                                                          if (enteredAmt < 100.00 &&  giftCardVouchers[j].balanceAmount>100){
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("Redemption"),
                                                                tr("amount_should_be_hundred_or_greater"),
                                                                context);
                                                            return;
                                                          }
                                                          if(enteredAmt>giftCardVouchers[j].balanceAmount){
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("Redemption"),
                                                                tr("amount_should_be_not_be_greater_than_balance_amount"),
                                                                context);
                                                            return;
                                                          }

                                                          if(selectedActiveFacility==null || selectedActiveFacility.facilityId==0){
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("Redemption"),
                                                                tr("select_facility"),
                                                                context);
                                                            return;
                                                          }
                                                          isVoucherRedemptionProgress=true;
                                                          _handler.show();
                                                          Meta m =
                                                          await (new FacilityDetailRepository())
                                                              .saveGiftCardUse(
                                                              giftCardVouchers[
                                                              j]
                                                                  .giftVoucherId,_otpamountController.text,selectedActiveFacility.facilityId);
                                                          if (m
                                                              .statusCode ==
                                                              200) {
                                                            isVoucherRedemptionProgress=false;
                                                            _handler.dismiss();
                                                            Navigator
                                                                .of(
                                                                pcontext)
                                                                .pop();

                                                            giftVoucherOtp=jsonDecode(m.statusMsg)["response"]["otpValue"].toString();
                                                            _otpController.text="";
                                        showDialog<Widget>(
                                                              context: context,
                                                              barrierDismissible:
                                                              false, // user must tap button!
                                                              builder: (BuildContext ppcontext) {
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
                                                                              tr("enter_your_otp"),
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
                                                                            child: Container(
                                                                                width: MediaQuery.of(context).size.width * 0.50,
                                                                                height: MediaQuery.of(context).size.height * 0.080,
                                                                                child: new TextFormField(
                                                                                    keyboardType: TextInputType.number,
                                                                                    controller: _otpController,
                                                                                    textAlign: TextAlign.center,
                                                                                    decoration: new InputDecoration(
                                                                                      contentPadding: EdgeInsets.all(5),
                                                                                      // contentPadding: EdgeInsets.only(
                                                                                      //     left: 10, top: 0, bottom: 0, right: 0),
                                                                                      hintText: "OTP",
                                                                                      border: new OutlineInputBorder(
                                                                                          borderSide: new BorderSide(
                                                                                              color: Colors.black12)),
                                                                                      // focusedBorder: OutlineInputBorder(
                                                                                      //     borderSide: new BorderSide(
                                                                                      //         color: Colors.grey[200]))),
                                                                                    ),
                                                                                    style: TextStyle(
                                                                                        fontSize: Styles.packageExpandTextSiz,
                                                                                        fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                                        color: ColorData.primaryTextColor,
                                                                                        fontWeight: FontWeight.w200))),
                                                                          ),
                                                                        ),
                                                                        // Padding(
                                                                        //   padding: EdgeInsets.only(
                                                                        //       top: 10.0),
                                                                        //   child: Center(
                                                                        //     child: Text(
                                                                        //       tr('gift_card_redemption_confirm'),
                                                                        //       style: TextStyle(
                                                                        //           color: ColorData
                                                                        //               .primaryTextColor,
                                                                        //           fontSize: Styles
                                                                        //               .textSiz,
                                                                        //           fontWeight:
                                                                        //           FontWeight
                                                                        //               .w400,
                                                                        //           fontFamily: tr(
                                                                        //               "currFontFamily")),
                                                                        //     ),
                                                                        //   ),
                                                                        // ),
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
                                                                                  child: new Text(
                                                                                      tr("cancel"),
                                                                                      style: TextStyle(
                                                                                          color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                                                                          fontSize: Styles.textSizeSmall,
                                                                                          fontFamily: tr("currFontFamily"))),
                                                                                  onPressed: () {
                                                                                    Navigator.of(
                                                                                        ppcontext)
                                                                                        .pop();
                                                                                  }),
                                                                              ElevatedButton(
                                                                                  style: ButtonStyle(
                                                                                      foregroundColor:
                                                                                      MaterialStateProperty.all<Color>(
                                                                                          Colors.white),
                                                                                      backgroundColor:
                                                                                      MaterialStateProperty.all<Color>(
                                                                                          ColorData.colorBlue),
                                                                                      shape: MaterialStateProperty.all<
                                                                                          RoundedRectangleBorder>(
                                                                                          RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.all(
                                                                                                Radius.circular(5.0),
                                                                                              )))),
                                                                                  child: new Text(
                                                                                    tr("confirm"),
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
                                                                                       if( isVoucherRedemptionProgress) return;

                                                                                    _handler.show();
                                                                                    if(_otpController.text.toString()==""){
                                                                                      util.customGetSnackBarWithOutActionButton(
                                                                                          tr("Redemption"),
                                                                                          tr("enter_valid_otp"),
                                                                                          context);
                                                                                      return;
                                                                                    }
                                                                                    if(_otpController.text.toString()!=giftVoucherOtp){
                                                                                      util.customGetSnackBarWithOutActionButton(
                                                                                          tr("Redemption"),
                                                                                          tr("oTPInvalid"),
                                                                                          context);
                                                                                      return;
                                                                                    }
                                                                                       isVoucherRedemptionProgress=true;
                                                                                    Meta m =
                                                                                    await (new FacilityDetailRepository())
                                                                                        .checkGiftCardOtp(
                                                                                        giftCardVouchers[
                                                                                        j]
                                                                                            .giftVoucherId,_otpController.text.toString(),_otpamountController.text.toString(),selectedActiveFacility.facilityId);
                                                                                    if (m
                                                                                        .statusCode ==
                                                                                        200) {
                                                                                      isVoucherRedemptionProgress=false;
                                                                                      _handler.dismiss();
                                                                                      Navigator
                                                                                          .of(
                                                                                          ppcontext)
                                                                                          .pop();
                                                                                      util
                                                                                          .customGetSnackBarWithOutActionButton(
                                                                                          tr("Redemption"),
                                                                                          tr("otp_verified_successfully"),
                                                                                          context);
                                                                                      giftCardVouchers=[];
                                                                                      Meta m1 = await FacilityDetailRepository()
                                                                                          .getAllGiftVouchers();
                                                                                      if (m1.statusCode == 200) {
                                                                                        jsonDecode(m1.statusMsg)['response'].forEach(
                                                                                                (f) => giftCardVouchers
                                                                                                .add(new GiftVocuher.fromJson(f)));
                                                                                      }
                                                                                      setState(() {

                                                                                      });
                                                                                    } else {
                                                                                      isVoucherRedemptionProgress=false;
                                                                                      _handler.dismiss();
                                                                                      util
                                                                                          .customGetSnackBarWithOutActionButton(
                                                                                          tr(
                                                                                              "Redemption"),
                                                                                          m
                                                                                              .statusMsg,
                                                                                          context);
                                                                                    }
                                                                                  }

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
                                                            util
                                                                .customGetSnackBarWithOutActionButton(
                                                                tr("Redemption"),
                                                                tr("redemption_otp_sent_successfully"),
                                                                context);
                                                          } else {
                                                            isVoucherRedemptionProgress=false;
                                                            _handler.dismiss();
                                                            util
                                                                .customGetSnackBarWithOutActionButton(
                                                                tr(
                                                                    "Redemption"),
                                                                m
                                                                    .statusMsg,
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
                                )),
                        SizedBox(width:20),
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(
                                  ColorData.colorBlue),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      )))),
                    child: Text(tr("details"),
                        style: TextStyle(color: ColorData
                            .whiteColor,
//                                color: Colors.black45,
                            fontSize: Styles
                                .textSizeSmall,
                            fontFamily: tr(
                                "currFontFamily"))),
                    onPressed: () async {
                      if(selectedGiftCardIndex==j){
                        selectedGiftCardIndex=-1;
                        setState(() {

                        });
                        return;
                      }
                      selectedGiftCardIndex=-1;
                      giftCardDetails=[];
                      Meta mf =
                      await (new FacilityDetailRepository())
                          .getGiftVoucherDetail(giftCardVouchers[j].giftVoucherId);
                      if (mf
                          .statusCode ==
                          200) {
                        jsonDecode(mf.statusMsg)['response'].forEach(
                                (f) => giftCardDetails
                                .add(new GiftCardDetailsDTO.fromJson(f)));
                      }
                      selectedGiftCardIndex=j;
                      setState(() {

                      });
                    },
                  )]),
                              ),
                       Visibility(visible:selectedGiftCardIndex==j,child:Row(children:[Expanded(child:ListView.builder(
                      key: PageStorageKey("GiftCard_PageStorageKey"),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: giftCardDetails == null
                          ? 0
                          : giftCardDetails.length,
                      itemBuilder: (context, ind) {
                        return  Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          padding:EdgeInsets.only(top:5,bottom:5,left:10,right:10),
                          width: double.infinity,
                          decoration: new BoxDecoration(
                            border: Border.all(color:Colors.grey[200]),
                            color: ColorData.whiteColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children:[
                                    Text(
                                        DateTimeUtils().dateToServerToDateFormat(giftCardDetails[ind].orderDate,DateTimeUtils.ServerFormatTwo,DateTimeUtils.DD_MMM_YYYY_Format),
                                        style: TextStyle(color: Colors.black54)),
                                    Text(giftCardDetails[ind].orderNo.toString(),
                                        style: TextStyle(color: Colors.black54)),
                              ]),
                              SizedBox(height:10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        giftCardDetails[ind].facilityName.toString(),
                                        style: TextStyle(color: Colors.black54)),
                                    Text(giftCardDetails[ind].reddemAmount.toStringAsFixed(2),
                                        style: TextStyle(color: Colors.black54)),
                                  ],
                                ),
                            ],
                          ),
                        );}))
                  ]))],
                            ),
                          )));
            }));
  }
  Widget getVoucherDetail(List<LoyaltyVoucherResponse> voucherRedemptionList,j){
    Barcode bc=Barcode.code39();
    final svg = bc.toSvg(
      voucherRedemptionList[j].qrCode,
      width: 200,
      height: 40,
      fontHeight: 16,
    );
    return Visibility(
        visible:
        voucherRedemptionList != null &&
            (!voucherRedemptionList[j]
                .isRedeemed || voucherRedemptionList[j].showQrCode)
            && (!voucherRedemptionList[j].isShared || voucherRedemptionList[j].userId!=SPUtil.getInt(Constants.USERID))
            ? true
            : false,
        child:Container(
          child: Stack(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 10,bottom: 2),
                  // Localizations.localeOf(context).languageCode == "en"
                  //     ? EdgeInsets.only(top: 2, left: 5)
                  //     : EdgeInsets.only(top: 5, right: 5),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height:
                          MediaQuery.of(context).size.height * 0.19,
                          width: MediaQuery.of(context).size.width * 0.95,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.18,
                                width: MediaQuery.of(context).size.width *
                                    0.96,
                                child: Image.network(
                                    voucherRedemptionList[j].voucherImageUrl,
                                    fit: BoxFit.cover),
                              ),
                              Visibility(

                                  visible:
                                  voucherRedemptionList != null &&
                                      !voucherRedemptionList[j]
                                          .isRedeemed && voucherRedemptionList[j].isUseEnabled && voucherRedemptionList[j].isUsabel
                                      || ( voucherRedemptionList[j].isShared==true && voucherRedemptionList[j].userId!=SPUtil.getInt(Constants.USERID))
                                      ? true
                                      : false,
                                  child: Padding(
                                    padding: Localizations
                                        .localeOf(context)
                                        .languageCode ==
                                        "en"
                                        ? EdgeInsets.only(
                                        left: MediaQuery.of(context)
                                            .size
                                            .width *
                                            ((voucherRedemptionList[j].voucherType==4 && voucherRedemptionList[j].userId==SPUtil.getInt(Constants.USERID))?0.08:0.20),
                                        top: 85)
                                        : EdgeInsets.only(
                                        right: MediaQuery.of(context)
                                            .size
                                            .width *
                                            ((voucherRedemptionList[j].voucherType==4 && voucherRedemptionList[j].userId==SPUtil.getInt(Constants.USERID))?0.80:0.70),
                                        top: 85),
                                    child: Row(
                                      children: [
                                        TextButton(
                                          child: Text(tr("use"),
                                              style: TextStyle(fontSize: 12)),
                                          style: ButtonStyle(
                                              padding:
                                              MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.all(8)),
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorData
                                                      .primaryTextColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8.0),
                                                      side: BorderSide(color: ColorData.toColor(voucherRedemptionList[j].colorCode))))),
                                          onPressed: () async {
                                            if (voucherRedemptionList[j]
                                                .isRedeemed) {
                                              util.customGetSnackBarWithOutActionButton(
                                                  tr("Redemption"),
                                                  "Voucher already used",
                                                  context);
                                              return;
                                            }
                                            otpSent=false;
                                            isVoucherRedemptionProgress=false;
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
                                                              tr('voucher_redemption'),
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
                                                              tr('redemption_confirm'),
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
                                                                  child: new Text(
                                                                      !otpSent?tr("no"):tr("cancel"),
                                                                      style: TextStyle(
                                                                          color: ColorData.primaryTextColor,
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
                                                                    MaterialStateProperty.all<Color>(
                                                                        Colors.white),
                                                                    backgroundColor:
                                                                    MaterialStateProperty.all<Color>(
                                                                        ColorData.colorBlue),
                                                                    shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(5.0),
                                                                            )))),
                                                                child: new Text(
                                                                  !otpSent?tr("yes"):tr("confirm"),
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
                                                                  if(isVoucherRedemptionProgress) return;
                                                                  isVoucherRedemptionProgress=true;
                                                                  _handler.show();
                                                                  Meta m =
                                                                  await (new FacilityDetailRepository())
                                                                      .saveVoucherUse(
                                                                      voucherRedemptionList[
                                                                      j]
                                                                          .redemptionId);
                                                                  if (m
                                                                      .statusCode ==
                                                                      200) {
                                                                    _handler.dismiss();
                                                                    Navigator
                                                                        .of(
                                                                        pcontext)
                                                                        .pop();
                                                                    _otpController.text="";
                                                                    isVoucherRedemptionProgress=false;
                                                                    showDialog<Widget>(
                                                                      context: context,
                                                                      barrierDismissible:
                                                                      false, // user must tap button!
                                                                      builder: (BuildContext ppcontext) {
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
                                                                                      tr("enter_your_otp"),
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
                                                                                    child: Container(
                                                                                        width: MediaQuery.of(context).size.width * 0.50,
                                                                                        height: MediaQuery.of(context).size.height * 0.080,
                                                                                        child: new TextFormField(
                                                                                            keyboardType: TextInputType.number,
                                                                                            controller: _otpController,
                                                                                            textAlign: TextAlign.center,
                                                                                            decoration: new InputDecoration(
                                                                                              contentPadding: EdgeInsets.all(5),
                                                                                              // contentPadding: EdgeInsets.only(
                                                                                              //     left: 10, top: 0, bottom: 0, right: 0),
                                                                                              hintText: "OTP",
                                                                                              border: new OutlineInputBorder(
                                                                                                  borderSide: new BorderSide(
                                                                                                      color: Colors.black12)),
                                                                                              // focusedBorder: OutlineInputBorder(
                                                                                              //     borderSide: new BorderSide(
                                                                                              //         color: Colors.grey[200]))),
                                                                                            ),
                                                                                            style: TextStyle(
                                                                                                fontSize: Styles.packageExpandTextSiz,
                                                                                                fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                                                color: ColorData.primaryTextColor,
                                                                                                fontWeight: FontWeight.w200))),
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
                                                                                          child: new Text(
                                                                                              tr("cancel"),
                                                                                              style: TextStyle(
                                                                                                  color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                                                                                  fontSize: Styles.textSizeSmall,
                                                                                                  fontFamily: tr("currFontFamily"))),
                                                                                          onPressed: () {
                                                                                            Navigator.of(
                                                                                                ppcontext)
                                                                                                .pop();
                                                                                          }),
                                                                                      ElevatedButton(
                                                                                          style: ButtonStyle(
                                                                                              foregroundColor:
                                                                                              MaterialStateProperty.all<Color>(
                                                                                                  Colors.white),
                                                                                              backgroundColor:
                                                                                              MaterialStateProperty.all<Color>(
                                                                                                  ColorData.colorBlue),
                                                                                              shape: MaterialStateProperty.all<
                                                                                                  RoundedRectangleBorder>(
                                                                                                  RoundedRectangleBorder(
                                                                                                      borderRadius: BorderRadius.all(
                                                                                                        Radius.circular(5.0),
                                                                                                      )))),
                                                                                          child: new Text(
                                                                                            tr("confirm"),
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
                                                                                            _handler.show();
                                                                                            Meta m =
                                                                                            await (new FacilityDetailRepository())
                                                                                                .checkVoucherOtp(
                                                                                                voucherRedemptionList[
                                                                                                j]
                                                                                                    .redemptionId,_otpController.text.toString());
                                                                                            if (m
                                                                                                .statusCode ==
                                                                                                200) {
                                                                                              _handler.dismiss();
                                                                                              Navigator
                                                                                                  .of(
                                                                                                  ppcontext)
                                                                                                  .pop();
                                                                                              setState(() {
                                                                                                voucherRedemptionList[
                                                                                                j].isRedeemed=true;
                                                                                                voucherRedemptionList[
                                                                                                j].showQrCode=true;
                                                                                              });
                                                                                              util
                                                                                                  .customGetSnackBarWithOutActionButton(
                                                                                                  tr(
                                                                                                      "Redemption"),
                                                                                                  tr("otp_verified_successfully"),
                                                                                                  context);
                                                                                            } else {
                                                                                              _handler.dismiss();
                                                                                              util
                                                                                                  .customGetSnackBarWithOutActionButton(
                                                                                                  tr(
                                                                                                      "Redemption"),
                                                                                                  m
                                                                                                      .statusMsg,
                                                                                                  context);
                                                                                            }
                                                                                          }

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
                                                                    util
                                                                        .customGetSnackBarWithOutActionButton(
                                                                        tr(
                                                                            "Redemption"),
                                                                        tr("redemption_otp_sent_successfully"),
                                                                        context);
                                                                  } else {
                                                                    isVoucherRedemptionProgress=false;
                                                                    _handler.dismiss();
                                                                    util
                                                                        .customGetSnackBarWithOutActionButton(
                                                                        tr(
                                                                            "Redemption"),
                                                                        m
                                                                            .statusMsg,
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
                                        ),
                                        Visibility(
                                          visible: (voucherRedemptionList[j].voucherType==8 && voucherRedemptionList[j].isShared==true && voucherRedemptionList[j].sharedStaffId != null && voucherRedemptionList[j].sharedStaffId.isNotEmpty)
                                              ? true : false,
                                          child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(tr('emp_id') +": ${voucherRedemptionList[j].sharedStaffId}",
                                              style: TextStyle(
                                                fontFamily: tr(
                                                    "currFontFamily"),
                                                fontSize: Styles
                                                    .reviewTextSize,),),
                                          ),)
                                      ],
                                    ),
                                  )),
                              Visibility(
                                  visible:
                                  voucherRedemptionList != null &&
                                      !voucherRedemptionList[j]
                                          .isRedeemed &&  voucherRedemptionList[j]
                                      .isSharable
                                      && (voucherRedemptionList[j].voucherType==4 ||  voucherRedemptionList[j].voucherType==8 ||  voucherRedemptionList[j].voucherType==9 || voucherRedemptionList[j].voucherType==10 )  && !voucherRedemptionList[j].isShared
                                      ? true
                                      : false,
                                  child: Padding(
                                    padding: Localizations
                                        .localeOf(context)
                                        .languageCode ==
                                        "en"
                                        ? EdgeInsets.only(
                                        left: MediaQuery.of(context)
                                            .size
                                            .width *
                                            ((!voucherRedemptionList[j].isUsabel)?0.08:0.40),
                                        top: 85)
                                        : EdgeInsets.only(
                                        right: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.50,
                                        top: 85),
                                    child: Row(
                                      children: [
                                        TextButton(
                                          child: Text(tr("share"),
                                              style: TextStyle(fontSize: 12)),
                                          style: ButtonStyle(
                                              padding:
                                              MaterialStateProperty.all<EdgeInsets>(
                                                  EdgeInsets.all(8)),
                                              foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  ColorData
                                                      .primaryTextColor),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(8.0),
                                                      side: BorderSide(color: ColorData.toColor(voucherRedemptionList[j].colorCode))))),
                                          onPressed: () async {
                                            if (voucherRedemptionList[j]
                                                .isRedeemed) {
                                              util.customGetSnackBarWithOutActionButton(
                                                  tr("Redemption"),
                                                  "Voucher already used",
                                                  context);
                                              return;
                                            }
                                            _shareMobileController.clear();
                                            setState(() {
                                              isShareMobileFocus = false;
                                            });
                                            showDialog<Widget>(
                                              context: context,
                                              barrierDismissible:
                                              false, // user must tap button!
                                              builder: (BuildContext ppcontext) {
                                                return StatefulBuilder(
                                                  builder: (BuildContext context,
                                                      StateSetter setState) =>AlertDialog(
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
                                                              child: Text (
                                                                tr("enter_mobileno"),
                                                                textAlign:
                                                                TextAlign.center,
                                                                style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontFamily: tr(
                                                                      "currFontFamily"),
                                                                  fontWeight:
                                                                  FontWeight.w200,
                                                                  fontSize: Styles
                                                                      .textSizeSmall,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 10.0),
                                                            child: SizedBox(
                                                                width: MediaQuery.of(context).size.width * 0.6,
                                                                height: MediaQuery.of(context).size.height * 0.06,
                                                                child:Row(
                                                                  children:[
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width * 0.1,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                            border: Border.all(color: Colors.black12,width:1.5)),
                                                                        alignment: Alignment.center,
                                                                        child:Text("971",
                                                                            style: TextStyle(
                                                                                fontSize: Styles.packageExpandTextSiz,
                                                                                fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                                color: ColorData.primaryTextColor,
                                                                                fontWeight: FontWeight.w200))),
                                                                    Padding(
                                                                      padding:EdgeInsets.only(left:4),
                                                                      child: Container(
                                                                        padding: EdgeInsets.only(left:8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                            border: Border.all(color: Colors.black12,width:1.5)
                                                                        ),
                                                                        child: DropdownButton<String>(
                                                                          value: dropdownValue,
                                                                          icon: const Icon(Icons.keyboard_arrow_down_outlined,color: Colors.grey),
                                                                          elevation: 16,
                                                                          style: TextStyle(
                                                                              fontSize: Styles.packageExpandTextSiz,
                                                                              fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                              color: ColorData.primaryTextColor,
                                                                              fontWeight: FontWeight.w200),
                                                                          underline: Container(
                                                                            color: Colors.transparent,
                                                                          ),
                                                                          onChanged: (String value) {
                                                                            setState(() {
                                                                              dropdownValue = value;
                                                                            });
                                                                          },
                                                                          menuMaxHeight: MediaQuery.of(context).size.height * 0.2,
                                                                          items: list.map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Text(value),
                                                                            );
                                                                          }).toList(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context).size.width * 0.34,
                                                                      margin:EdgeInsets.only(left:8),
                                                                      padding: EdgeInsets.only(left:8),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(4)),
                                                                          border: Border.all(color: isShareMobileFocus ?ColorData.eventHomePageSelectedCircularBorder : Colors.black12,width:1.5)),
                                                                      child: new TextFormField(
                                                                          keyboardType: TextInputType.number,
                                                                          controller: _shareMobileController,
                                                                          textAlign: TextAlign.left,
                                                                          maxLines: 1,
                                                                          maxLength: 7,
                                                                          onTap: (){
                                                                            setState(() {
                                                                              isShareMobileFocus = true;
                                                                            });
                                                                          },
                                                                          decoration: new InputDecoration(
                                                                            contentPadding: EdgeInsets.all(0),
                                                                            // contentPadding: EdgeInsets.only(
                                                                            //     left: 10, top: 0, bottom: 0, right: 0),
                                                                            hintText: "XXXXXXX",
                                                                            counterText: "",
                                                                            enabledBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.transparent),
                                                                            ),
                                                                            border: new OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.transparent),
                                                                              // borderSide: new BorderSide(
                                                                              //     color: Colors.transparent),
                                                                            ),
                                                                            focusedBorder: OutlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.transparent),),
                                                                          ),
                                                                          style: TextStyle(
                                                                              fontSize: Styles.packageExpandTextSiz,
                                                                              fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                              color: ColorData.primaryTextColor,
                                                                              fontWeight: FontWeight.w200)),),
                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: EdgeInsets.only(
                                                                top: 10.0),
                                                            child: Center(
                                                              child: Text(
                                                                tr("enter_mobileno_text"),
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
                                                                tr("no_international_sharing"),
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
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: <Widget>[
                                                                ElevatedButton(
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
                                                                    child: new Text(
                                                                        tr("cancel"),
                                                                        style: TextStyle(
                                                                            color: ColorData.primaryTextColor,
                                                                            fontSize: Styles.textSizeSmall,
                                                                            fontFamily: tr("currFontFamily"))),
                                                                    onPressed: () {
                                                                      Navigator.of(
                                                                          ppcontext)
                                                                          .pop();
                                                                    }),
                                                                ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        foregroundColor:
                                                                        MaterialStateProperty.all<Color>(
                                                                            Colors.white),
                                                                        backgroundColor:
                                                                        MaterialStateProperty.all<Color>(
                                                                            ColorData.colorBlue),
                                                                        shape: MaterialStateProperty.all<
                                                                            RoundedRectangleBorder>(
                                                                            RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(5.0),
                                                                                )))),
                                                                    child: new Text(
                                                                      tr("confirm"),
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
                                                                      if(_shareMobileController.text.isEmpty || _shareMobileController.text.length != 7){
                                                                        util
                                                                            .customGetSnackBarWithOutActionButton(
                                                                            tr(
                                                                                tr("share")),
                                                                            tr('seven_digit_mobile_no'),
                                                                            context);
                                                                        return;
                                                                      }
                                                                      _handler.show();
                                                                      String sharedMobileNo = "$dropdownValue${_shareMobileController.text}";
                                                                      Meta m =
                                                                      await (new FacilityDetailRepository())
                                                                          .shareVoucher(
                                                                          voucherRedemptionList[
                                                                          j]
                                                                              .redemptionId,sharedMobileNo);
                                                                      if (m
                                                                          .statusCode ==
                                                                          200) {
                                                                        _handler.dismiss();
                                                                        Navigator
                                                                            .of(
                                                                            ppcontext)
                                                                            .pop();
                                                                        voucherRedemptionList[
                                                                        j].isShared=true;
                                                                        util
                                                                            .customGetSnackBarWithOutActionButton(
                                                                            tr(
                                                                                tr("share")),
                                                                            "Voucher Shared Successfully",
                                                                            context);

                                                                        if(SPUtil.getInt(Constants.USER_CORPORATEID)==1 && isCorporateVoucher){
                                                                          // do recall
                                                                          doRecall();
                                                                        }
                                                                        _handler.dismiss();
                                                                      } else {
                                                                        _handler.dismiss();
                                                                        util
                                                                            .customGetSnackBarWithOutActionButton(
                                                                            tr(
                                                                                tr("share")),
                                                                            m
                                                                                .statusMsg,
                                                                            context);
                                                                      }
                                                                    }

                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),);
                                              },
                                            );
                                          },
                                        ),
                                        Visibility(
                                          visible: (voucherRedemptionList[j].voucherType==8 && voucherRedemptionList[j].isShared==true && voucherRedemptionList[j].sharedStaffId != null && voucherRedemptionList[j].sharedStaffId.isNotEmpty)
                                              ? true : false,
                                          child: Padding(
                                            padding: EdgeInsets.only(left:10),
                                            child: Text(tr('emp_id') +": ${voucherRedemptionList[j].sharedStaffId}",
                                              style: TextStyle(
                                                fontFamily: tr(
                                                    "currFontFamily"),
                                                fontSize: Styles
                                                    .reviewTextSize,),),
                                          ),)
                                      ],
                                    )
                                  )),
                              // Visibility(
                              //     visible:
                              //     voucherRedemptionList != null &&
                              //         !voucherRedemptionList[j]
                              //             .isRedeemed &&  voucherRedemptionList[j]
                              //         .isSharable
                              //         && (voucherRedemptionList[j].voucherType==4 ||  voucherRedemptionList[j].voucherType==8 ||  voucherRedemptionList[j].voucherType==9 || voucherRedemptionList[j].voucherType==10 )  && !voucherRedemptionList[j].isShared
                              //         ? true
                              //         : false,
                              //     child: Padding(
                              //       padding: Localizations
                              //           .localeOf(context)
                              //           .languageCode ==
                              //           "en"
                              //           ? EdgeInsets.only(
                              //           left: MediaQuery.of(context)
                              //               .size
                              //               .width *
                              //               ((!voucherRedemptionList[j].isUsabel)?0.81:0.08),
                              //           top: 104)
                              //           : EdgeInsets.only(
                              //           right: MediaQuery.of(context)
                              //               .size
                              //               .width *
                              //               0.20,
                              //           top: 110),
                              //       child: Text(voucherRedemptionList[j].validMonth.substring(3,11),style: TextStyle(
                              //         fontFamily: tr(
                              //             "currFontFamily"),
                              //         fontSize: Styles
                              //             .reviewTextSize,
                              //       )),
                              //     )),
                              // Visibility(
                              //     visible:
                              //     voucherRedemptionList != null &&
                              //         !voucherRedemptionList[j]
                              //             .isRedeemed &&  voucherRedemptionList[j]
                              //         .isSharable
                              //         && (voucherRedemptionList[j].voucherType==4 ||  voucherRedemptionList[j].voucherType==8 ||  voucherRedemptionList[j].voucherType==9 || voucherRedemptionList[j].voucherType==10 )  && !voucherRedemptionList[j].isShared
                              //         ? true
                              //         : false,
                              //     child:   Padding(padding: Localizations
                              //         .localeOf(context)
                              //         .languageCode ==
                              //         "en"
                              //         ? EdgeInsets.only( left: MediaQuery.of(context)
                              //         .size
                              //         .width *
                              //         ((!voucherRedemptionList[j].isUsabel)?0.64:0.08),
                              //         top: MediaQuery.of(context).size.height * 0.136) : EdgeInsets.only(
                              //         right: MediaQuery.of(context)
                              //             .size
                              //             .width *
                              //             0.20,
                              //         top: 110),child: Text(voucherRedemptionList[j].validMonth.split("-")[1] + " " + voucherRedemptionList[j].validMonth.split("-")[2],style: TextStyle(
                              //       fontFamily: tr(
                              //           "currFontFamily"),
                              //       fontSize: Styles
                              //           .reviewTextSize,
                              //         fontWeight: FontWeight.bold
                              //     )),),),
                              Visibility(
                                visible:
                                voucherRedemptionList != null &&
                                     voucherRedemptionList[j].voucherType==8 && voucherRedemptionList[j].sharedStaffId!="0" ,
                                child:   Padding(padding: Localizations
                                    .localeOf(context)
                                    .languageCode ==
                                    "en"
                                    ? EdgeInsets.only( left: MediaQuery.of(context)
                                    .size
                                    .width *
                                    ((!voucherRedemptionList[j].isUsabel)?0.64:0.08),
                                    top: MediaQuery.of(context).size.height * 0.136) : EdgeInsets.only(
                                    right: MediaQuery.of(context)
                                        .size
                                        .width *
                                        0.20,
                                    top: 110),child: Text(voucherRedemptionList[j].validMonth.split("-")[1] + " " + voucherRedemptionList[j].validMonth.split("-")[2],style: TextStyle(
                                  fontFamily: tr(
                                      "currFontFamily"),
                                  fontSize: Styles
                                      .packageExpandTextSiz,
                                  // fontWeight: FontWeight.bold
                                )),),),
                              Visibility(
                                  visible:
                                  voucherRedemptionList != null &&
                                      (voucherRedemptionList[j]
                                          .isRedeemed && voucherRedemptionList[j]
                                          .showQrCode )
                                      ? true
                                      : false,
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      margin: EdgeInsets.only(
                                          top: 50, left: 5),
                                      child: Column(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(color:Colors.white),
                                            height: 60,
                                            width: 400,
                                            child: SvgPicture.string(svg),
                                          ),
                                        ],
                                      ))),
                              Visibility(
                                  visible: isMembershipVoucher &&
                                      voucherRedemptionList != null &&
                                      (!voucherRedemptionList[j]
                                          .isRedeemed && !voucherRedemptionList[j]
                                          .showQrCode )
                                      ? true
                                      : false,
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      margin: EdgeInsets.only(
                                          top: 8,right:23,left:67,bottom:10),
                                      child:Text(voucherRedemptionList[j].validMonth, style: TextStyle(
                                        color: ColorData
                                            .primaryColor,
                                        fontFamily: tr(
                                            "currFontFamily"),
                                        fontWeight:
                                        FontWeight.w500,
                                        fontSize: Styles
                                            .packageExpandTextSiz,
                                      ),))),
                              Visibility(
                                  visible:
                                  // isMembershipVoucher &&
                                  //     voucherRedemptionList != null &&
                                  //     (!voucherRedemptionList[j]
                                  //         .isRedeemed && !voucherRedemptionList[j]
                                  //         .showQrCode )
                                  //     ? true
                                  //     :
                                  false,
                                  child: Container(
                                      alignment: Alignment.bottomCenter,
                                      margin: Localizations.localeOf(context).languageCode == "en"?EdgeInsets.only(
                                          top: 8,bottom:10,
                                          left:MediaQuery.of(context).size.width*0.10,right:0):EdgeInsets.only(
                                          top: 8,bottom:10,
                                          right:MediaQuery.of(context).size.width*0.50,left:0),
                                      child:Text(voucherRedemptionList[j].validDays, style: TextStyle(
                                        color: ColorData
                                            .primaryColor,
                                        fontFamily: tr(
                                            "currFontFamily"),
                                        fontSize: Styles
                                            .textSizeSeventeen,
                                      ),)))
                            ],
                          ),
                        ),
                      ])),
            ],
          ),
        ));
  }
  Widget getMembershipRedeemDetails() {
    return Expanded(
        child:ListView.builder(
      controller: scrlController,
      key: key,
      scrollDirection: Axis.vertical,
      itemCount: voucherRedemptionFacilities.length,
      physics: ClampingScrollPhysics(),
      itemBuilder: (context, i) {
        return _wrapScrollTag(
          index: i,
          child: Column(
            children: <Widget>[
              Card(
                color: Colors.white,
                elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                child: GroovinExpansionTile(
                  initiallyExpanded: i == widget.listIndex ? true : false,
                  key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                  btnIndex: i,
                  selectedIndex: selectedIndex,
                  onTap: (isExpanded, btnIndex) {
                    displayVoucherRedemptionList=[];
                    for(var v in voucherRedemptionList){
                      if(v.voucherName==voucherRedemptionFacilities[i]) {
                          displayVoucherRedemptionList.add(
                              v);
                        }

                    }
                    updateSelectedIndex(btnIndex);
                  },
                  onExpansionChanged: (val) {
                    setState(() {
                      isExpanded = val;
                    });
                  },
                  defaultTrailingIconColor: isExpanded && selectedIndex == i
                      ? ColorData.primaryTextColor
                      : Colors.grey,
                  title: PackageListHead.facilityExpandTileTextStyle(
                      context,
                      1.0,
                      voucherRedemptionFacilities[i].trim(),
                      ColorData.primaryTextColor,
                      isExpanded && selectedIndex == i),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top:5,left:5,right:5),
                      child: NestedScrollViewInnerScrollPositionKeyWidget(
                        Key(i.toString()),
                        ListView.builder(
                            key: PageStorageKey(
                                i.toString() + "pageStorageKey"),
                            scrollDirection: Axis.vertical,
                            itemCount: displayVoucherRedemptionList==null?0:displayVoucherRedemptionList.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, j) {

                              return getVoucherDetail(displayVoucherRedemptionList, j);
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget getSpaRedeemDetails() {
    return Expanded(
        child:ListView.builder(
          controller: scrlController,
          key: key,
          scrollDirection: Axis.vertical,
          itemCount: voucherRedemptionFacilities.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return _wrapScrollTag(
              index: i,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                    child: GroovinExpansionTile(
                      initiallyExpanded: i == widget.listIndex ? true : false,
                      key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                      btnIndex: i,
                      selectedIndex: selectedIndex,
                      onTap: (isExpanded, btnIndex) {
                        displayVoucherRedemptionList=[];
                        for(var v in voucherRedemptionList){
                          if(v.voucherName==voucherRedemptionFacilities[i]) {
                            displayVoucherRedemptionList.add(
                                v);
                          }

                        }
                        updateSelectedIndex(btnIndex);
                      },
                      onExpansionChanged: (val) {
                        setState(() {
                          isExpanded = val;
                        });
                      },
                      defaultTrailingIconColor: isExpanded && selectedIndex == i
                          ? ColorData.primaryTextColor
                          : Colors.grey,
                      title: PackageListHead.facilityExpandTileTextStyle(
                          context,
                          1.0,
                          voucherRedemptionFacilities[i].trim(),
                          ColorData.primaryTextColor,
                          isExpanded && selectedIndex == i),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top:5,left:5,right:5),
                          child: NestedScrollViewInnerScrollPositionKeyWidget(
                            Key(i.toString()),
                            ListView.builder(
                                key: PageStorageKey(
                                    i.toString() + "pageStorageKey"),
                                scrollDirection: Axis.vertical,
                                itemCount: displayVoucherRedemptionList==null?0:displayVoucherRedemptionList.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, j) {

                                  return getVoucherDetail(displayVoucherRedemptionList, j);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  Widget getObbRedeemDetails() {
    return Expanded(
        child:ListView.builder(
          controller: scrlController,
          key: key,
          scrollDirection: Axis.vertical,
          itemCount: voucherRedemptionFacilities.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return _wrapScrollTag(
              index: i,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                    child: GroovinExpansionTile(
                      initiallyExpanded: i == widget.listIndex ? true : false,
                      key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                      btnIndex: i,
                      selectedIndex: selectedIndex,
                      onTap: (isExpanded, btnIndex) {
                        displayVoucherRedemptionList=[];
                        for(var v in voucherRedemptionList){
                          if(v.voucherName==voucherRedemptionFacilities[i]) {
                            displayVoucherRedemptionList.add(
                                v);
                          }

                        }
                        updateSelectedIndex(btnIndex);
                      },
                      onExpansionChanged: (val) {
                        setState(() {
                          isExpanded = val;
                        });
                      },
                      defaultTrailingIconColor: isExpanded && selectedIndex == i
                          ? ColorData.primaryTextColor
                          : Colors.grey,
                      title: PackageListHead.facilityExpandTileTextStyle(
                          context,
                          1.0,
                          voucherRedemptionFacilities[i].trim(),
                          ColorData.primaryTextColor,
                          isExpanded && selectedIndex == i),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top:5,left:5,right:5),
                          child: NestedScrollViewInnerScrollPositionKeyWidget(
                            Key(i.toString()),
                            ListView.builder(
                                key: PageStorageKey(
                                    i.toString() + "pageStorageKey"),
                                scrollDirection: Axis.vertical,
                                itemCount: displayVoucherRedemptionList==null?0:displayVoucherRedemptionList.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, j) {

                                  return getVoucherDetail(displayVoucherRedemptionList, j);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  Widget getFitnessRedeemDetails() {
    return Expanded(
        child:ListView.builder(
          controller: scrlController,
          key: key,
          scrollDirection: Axis.vertical,
          itemCount: voucherRedemptionFacilities.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return _wrapScrollTag(
              index: i,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                    child: GroovinExpansionTile(
                      initiallyExpanded: i == widget.listIndex ? true : false,
                      key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                      btnIndex: i,
                      selectedIndex: selectedIndex,
                      onTap: (isExpanded, btnIndex) {
                        displayVoucherRedemptionList=[];
                        for(var v in voucherRedemptionList){
                          if(v.voucherName==voucherRedemptionFacilities[i]) {
                            displayVoucherRedemptionList.add(
                                v);
                          }

                        }
                        updateSelectedIndex(btnIndex);
                      },
                      onExpansionChanged: (val) {
                        setState(() {
                          isExpanded = val;
                        });
                      },
                      defaultTrailingIconColor: isExpanded && selectedIndex == i
                          ? ColorData.primaryTextColor
                          : Colors.grey,
                      title: PackageListHead.facilityExpandTileTextStyle(
                          context,
                          1.0,
                          voucherRedemptionFacilities[i].trim(),
                          ColorData.primaryTextColor,
                          isExpanded && selectedIndex == i),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top:5,left:5,right:5),
                          child: NestedScrollViewInnerScrollPositionKeyWidget(
                            Key(i.toString()),
                            ListView.builder(
                                key: PageStorageKey(
                                    i.toString() + "pageStorageKey"),
                                scrollDirection: Axis.vertical,
                                itemCount: displayVoucherRedemptionList==null?0:displayVoucherRedemptionList.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, j) {

                                  return getVoucherDetail(displayVoucherRedemptionList, j);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  Widget getCorporateRedeemDetails() {
    return Expanded(
        child:ListView.builder(
          controller: scrlController,
          key: key,
          scrollDirection: Axis.vertical,
          itemCount: voucherRedemptionFacilities.length,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return _wrapScrollTag(
              index: i,
              child: Column(
                children: <Widget>[
                  Card(
                    color: Colors.white,
                    elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                    child: GroovinExpansionTile(
                      initiallyExpanded: i == widget.listIndex ? true : false,
                      key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                      btnIndex: i,
                      selectedIndex: selectedIndex,
                      onTap: (isExpanded, btnIndex) {
                        displayVoucherRedemptionList=[];
                        for(var v in voucherRedemptionList){
                          if(v.voucherName==voucherRedemptionFacilities[i]) {
                            displayVoucherRedemptionList.add(
                                v);
                          }

                        }
                        updateSelectedIndex(btnIndex);
                      },
                      onExpansionChanged: (val) {
                        setState(() {
                          isExpanded = val;
                        });
                      },
                      defaultTrailingIconColor: isExpanded && selectedIndex == i
                          ? ColorData.primaryTextColor
                          : Colors.grey,
                      title: PackageListHead.facilityExpandTileTextStyle(
                          context,
                          1.0,
                          voucherRedemptionFacilities[i].trim(),
                          ColorData.primaryTextColor,
                          isExpanded && selectedIndex == i),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top:5,left:5,right:5),
                          child: NestedScrollViewInnerScrollPositionKeyWidget(
                            Key(i.toString()),
                            ListView.builder(
                                key: PageStorageKey(
                                    i.toString() + "pageStorageKey"),
                                scrollDirection: Axis.vertical,
                                itemCount: displayVoucherRedemptionList==null?0:displayVoucherRedemptionList.length,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, j) {

                                  return getVoucherDetail(displayVoucherRedemptionList, j);
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
  Widget getTransaction() {
    if (widget.transactionList == null)
      widget.transactionList = [];
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("Transactions_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.transactionList == null
                ? 0
                : widget.transactionList.length,
            itemBuilder: (context, j) {
              return Container(
                child: Stack(
                  children: <Widget>[
                    Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(top: 5, left: 5)
                                : EdgeInsets.only(top: 5, right: 5),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(left: 20, top: 10)
                                    : EdgeInsets.only(right: 20, top: 10),
                                child: Text(
                                  widget.transactionList[j].orderDate
                                      .substring(0, 11),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: MediaQuery.of(context).size.width * 0.96,
                                margin: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(left: 2)
                                    : EdgeInsets.only(right: 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: Colors.grey[200])),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(left: 8, top: 8)
                                          : EdgeInsets.only(right: 8, top: 8),
                                      // height:
                                      //     MediaQuery.of(context).size.height *
                                      //         0.14,
                                      // width: MediaQuery.of(context).size.width *
                                      //     0.22,
                                      height: 90,
                                      width: 90,
                                      child: Image.asset(
                                                widget.transactionList[j]
                                                        .facilityId ==
                                                    Constants
                                                        .FacilityOlympicPool ||
                                                widget.transactionList[j]
                                                        .facilityId ==
                                                    Constants.FacilityLeisure
                                            ? "assets/images/10_11_12_logo.png"
                                            : "assets/images/" +
                                                widget.transactionList[j]
                                                    .facilityId
                                                    .toString() +
                                                "_logo.png",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Visibility(visible:widget.transactionList[j]
                                        .grossAmount==0?false:true,child:Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                right: 8,
                                                top: 35,
                                              )
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.85,
                                                left: 8,
                                                top: 35,
                                              ),
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward_ios),
                                          color: Colors.grey[300],
                                          onPressed: () async {
                                            _handler.show();
                                            List<TransactionDetailResponse>
                                                transactionDetailResponse =
                                                [];
                                            Meta m =
                                                await (new FacilityDetailRepository())
                                                    .getTransactionDetailList(
                                                        widget
                                                            .transactionList[j]
                                                            .orderId);
                                            if (m.statusCode == 200) {
                                              jsonDecode(
                                                      m.statusMsg)["response"]
                                                  .forEach((f) =>
                                                      transactionDetailResponse.add(
                                                          new TransactionDetailResponse
                                                              .fromJson(f)));
                                            }
                                            _handler.dismiss();
                                            showAlertDialog(
                                                context,
                                                widget.transactionList[j],
                                                transactionDetailResponse);
                                          },
                                        ))),
                                    Padding(
                                      padding: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 20)
                                          : EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 20),
                                      child: Text(
                                          'AED ' +
                                              widget.transactionList[j]
                                                  .payableAmount
                                                  .toStringAsFixed(2),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                    ),
                                    Padding(
                                      padding: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 50)
                                          : EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 50),
                                      child: Text(
                                          (widget.transactionList[j].grossAmount==0?'Enquiry ID: ':'Txn ID: ') +
                                              widget.transactionList[j].orderNo,
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                    ),
                                    Padding(
                                      padding: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 73)
                                          : EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              top: 73),
                                      child: Text(

              widget.transactionList[j].grossAmount==0?tr("party_hall"):widget.transactionList[j].orderStatus=='Success'?widget.transactionList[j].facilityName:'Void'
                                              .trim(),
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              color: ColorData.toColor(widget
                                                  .transactionList[j]
                                                  .colorCode),
                                              fontSize: Styles.textSizeSmall,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 100),
                                      child: Divider(color: Colors.grey[400]),
                                    ),
                                    Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: 15, right: 10, top: 110)
                                            : EdgeInsets.only(
                                                left: 10, right: 15, top: 110),
                                        child: Align(
                                          alignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.centerLeft
                                                  : Alignment.centerRight,
                                          child: /*Text(tr("feedback"),
                                              style: TextStyle(
                                                  color: ColorData
                                                      .primaryTextColor
                                                      .withOpacity(1.0),
                                                  fontSize:
                                                      Styles.textSizeSmall,
                                                  fontFamily:
                                                      tr('currFontFamily'))),*/
                                          ElevatedButton(
                                              style: ButtonStyle(
                                                  foregroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      Colors.white),
                                                  backgroundColor:
                                                  MaterialStateProperty.all<Color>(
                                                      ColorData.whiteColor),
                                                  shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.all(
                                                            Radius.circular(5.0),
                                                          )))),
                                              // shape: RoundedRectangleBorder(
                                              //     borderRadius:
                                              //     BorderRadius.all(
                                              //         Radius.circular(
                                              //             0.0))),
                                              // color:
                                              // ColorData.whiteColor,
                                              child: new Text(tr("survey"),
                                                  style:  TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize:
                                                      Styles.textSizeSmall,
                                                      fontFamily:
                                                      tr('currFontFamily'))),
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop();
                                                Navigator.push(context,MaterialPageRoute(
                                                  builder: (context) =>
                                                  Dashboard(selectedIndex: 2,facilityId:widget
                                                      .transactionList[j].facilityId ,)
                                                ) );
                                              }),
                                        )),
                                    Padding(
                                      padding: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              right: 10,
                                              top: 110,
                                              bottom: 5)
                                          : EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              left: 10,
                                              top: 110,
                                              bottom: 5),
                                      child: VerticalDivider(
                                          color: Colors.grey[400]),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      padding: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              top: 120,
                                              bottom: 5)
                                          : EdgeInsets.only(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.3,
                                              top: 120,
                                              bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              width: 47,
                                              decoration: ShapeDecoration(
                                                color: widget.transactionList[j]
                                                            .points ==
                                                        1
                                                    ? Colors.grey[400]
                                                    : Colors.redAccent,
                                                shape: CircleBorder(),
                                              ),
                                              child: Center(
                                                  child: IconButton(
                                                padding: EdgeInsets.all(0.0),
                                                icon: Icon(
                                                  Icons.sentiment_dissatisfied,
                                                  color: ColorData.whiteColor,
                                                  size: 45,
                                                ),
                                                onPressed: () async {
                                                  if (widget.transactionList[j]
                                                          .points ==
                                                      0) {
                                                    _handler.show();
                                                    Meta m = await FacilityDetailRepository()
                                                        .postTransactionFeedback(
                                                            widget
                                                                .transactionList[
                                                                    j]
                                                                .orderId,
                                                            1);
                                                    if (m.statusCode == 200) {
                                                      setState(() {
                                                        if (widget
                                                                .transactionList[
                                                                    j]
                                                                .points ==
                                                            1)
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 0;
                                                        else
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 1;
                                                      });
                                                    }
                                                    _handler.dismiss();
                                                  }
                                                },
                                              ))),
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              width: 47,
                                              decoration: ShapeDecoration(
                                                color: widget.transactionList[j]
                                                            .points ==
                                                        2
                                                    ? Colors.grey[400]
                                                    : Colors.orangeAccent,
                                                shape: CircleBorder(),
                                              ),
                                              child: Center(
                                                  child: IconButton(
                                                padding: EdgeInsets.all(0.0),
                                                icon: Icon(
                                                  Icons.sentiment_neutral,
                                                  color: ColorData.whiteColor,
                                                  size: 45,
                                                ),
                                                onPressed: () async {
                                                  if (widget.transactionList[j]
                                                          .points ==
                                                      0) {
                                                    _handler.show();
                                                    Meta m = await FacilityDetailRepository()
                                                        .postTransactionFeedback(
                                                            widget
                                                                .transactionList[
                                                                    j]
                                                                .orderId,
                                                            2);
                                                    if (m.statusCode == 200) {
                                                      setState(() {
                                                        if (widget
                                                                .transactionList[
                                                                    j]
                                                                .points ==
                                                            2)
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 0;
                                                        else
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 2;
                                                      });
                                                    }
                                                    _handler.dismiss();
                                                  }
                                                },
                                              ))),
                                          Container(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              width: 47,
                                              decoration: ShapeDecoration(
                                                color: widget.transactionList[j]
                                                            .points ==
                                                        3
                                                    ? Colors.grey[400]
                                                    : Colors.green,
                                                shape: CircleBorder(),
                                              ),
                                              child: Center(
                                                  child: IconButton(
                                                padding: EdgeInsets.all(0.0),
                                                icon: Icon(
                                                  Icons.sentiment_satisfied,
                                                  color: ColorData.whiteColor,
                                                  size: 45,
                                                ),
                                                onPressed: () async {
                                                  if (widget.transactionList[j]
                                                          .points ==
                                                      0) {
                                                    _handler.show();
                                                    Meta m = await FacilityDetailRepository()
                                                        .postTransactionFeedback(
                                                            widget
                                                                .transactionList[
                                                                    j]
                                                                .orderId,
                                                            3);
                                                    if (m.statusCode == 200) {
                                                      setState(() {
                                                        if (widget
                                                                .transactionList[
                                                                    j]
                                                                .points ==
                                                            3)
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 0;
                                                        else
                                                          widget
                                                              .transactionList[
                                                                  j]
                                                              .points = 3;
                                                      });
                                                    }
                                                    _handler.dismiss();
                                                  }
                                                },
                                              ))),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ])),
                  ],
                ),
              );
            }));
  }

  Widget getTransactionDetail(List<TransactionDetailResponse> detail,
      TransactionResponse transactionResponse) {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("TransactionDetail_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: detail == null ? 0 : detail.length,
            itemBuilder: (context, j) {
              String qty = (Localizations.localeOf(context).languageCode == "en"
                  ? (detail[j].quantity > 1
                      ? detail[j].quantity.toString() +
                          " (Nos) X " +
                          detail[j].price.toStringAsFixed(2)
                      : detail[j].quantity.toString() +
                          " (No) X " +
                          detail[j].price.toStringAsFixed(2))
                  : (detail[j].quantity > 1
                      ? detail[j].quantity.toString() +
                          " (Nos)  " +
                          detail[j].price.toStringAsFixed(2) +
                          " X"
                      : detail[j].quantity.toString() +
                          " (No)  " +
                          detail[j].price.toStringAsFixed(2) +
                          " X"));
              return Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1),
                      ),
                      margin: EdgeInsets.only(top: 8),
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.width * 0.94,
                      child: Card(
                        // elevation: 1,
                        child: Stack(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 5, left: 8),
                              child: Text(detail[j].facilityItemName,
                                  // style: TextStyle(
                                  //     fontSize: Styles.packageExpandTextSiz,
                                  //     fontFamily: tr('currFontFamily'))
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.packageExpandTextSiz,
                                      fontFamily: tr('currFontFamily'))),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.94,
                              margin:
                                  EdgeInsets.only(top: 25, left: 8, right: 8),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.57,
                                        child: Align(
                                            alignment:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? Alignment.centerLeft
                                                    : Alignment.centerRight,
                                            child: Text(qty,
                                                style: TextStyle(
                                                    color: ColorData.toColor(
                                                            transactionResponse
                                                                .colorCode)
                                                        .withOpacity(1.0),
                                                    fontSize: Styles.textSiz,
                                                    fontFamily:
                                                        tr('currFontFamily')))),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "AED",
                                                style: TextStyle(
                                                    color: ColorData.toColor(
                                                            transactionResponse
                                                                .colorCode)
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
                                    crossAxisAlignment:
                                        Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.15,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                detail[j]
                                                    .totalAmount
                                                    .toStringAsFixed(2),
                                                style: TextStyle(
                                                    color: ColorData.toColor(
                                                            transactionResponse
                                                                .colorCode)
                                                        .withOpacity(1.0),
                                                    fontSize: Styles.textSiz,
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
                            // Container(
                            //   margin: EdgeInsets.only(top: 25, left: 8),
                            //   child: Text(
                            //       detail[j].quantity.toString() +
                            //           (detail[j].quantity > 1
                            //               ? " (Nos) X "
                            //               : " (No) X ") +
                            //           detail[j].price.toStringAsFixed(2) +
                            //           "",
                            //       style: TextStyle(
                            //           fontSize: Styles.textSiz,
                            //           color: Theme.of(context).primaryColor,
                            //           fontFamily: tr('currFontFamily'))),
                            // ),
                            // Container(
                            //   alignment: Alignment.centerRight,
                            //   width: MediaQuery.of(context).size.width * 0.30,
                            //   margin: EdgeInsets.only(
                            //     top: 25,
                            //   ),
                            //   child: Text(
                            //       "AED " +
                            //           detail[j].totalAmount.toStringAsFixed(2),
                            //       style: TextStyle(
                            //           fontSize: Styles.textSiz,
                            //           color: Theme.of(context).primaryColor,
                            //           fontFamily: tr('currFontFamily'))),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  showAlertDialog(BuildContext context, TransactionResponse transactionResponse,
      List<TransactionDetailResponse> transactionDetailResponse) {
    // show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              insetPadding: EdgeInsets.only(left: 8, right: 8),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: transactionResponse.showQRCode
                    ? MediaQuery.of(context).size.height * 0.77
                    : MediaQuery.of(context).size.height * 0.87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                        margin:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 8, top: 10)
                                : EdgeInsets.only(right: 8, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.14,
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: Image.asset(

                                        transactionResponse.facilityId ==
                                            Constants.FacilityOlympicPool ||
                                        transactionResponse.facilityId ==
                                            Constants.FacilityLeisure
                                    ? "assets/images/10_11_12_logo.png"
                                    : "assets/images/" +
                                        transactionResponse.facilityId
                                            .toString() +
                                        "_logo.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.70,
                              height: MediaQuery.of(context).size.height * 0.14,
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.grey[400])),
                              padding: EdgeInsets.all(0.0),
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.all(0.0),
                                      ),
                                      // padding: EdgeInsets.all(0.0),
                                      child: Text(tr("close"),
                                          style: TextStyle(
                                              color: ColorData.toColor(
                                                      transactionResponse
                                                          .colorCode)
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.textSizeSeventeen,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                    )
                                  ]),
                            ),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Divider(
                          color: Colors.grey[400],
                        )),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(left: 10)
                                    : EdgeInsets.only(right: 10),
                            child: Text(transactionResponse.orderDate,
                                style: TextStyle(
                                    color: ColorData.toColor(
                                            transactionResponse.colorCode)
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Spacer(flex: 1),
                          Padding(
                            padding:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(right: 10, bottom: 3)
                                    : EdgeInsets.only(left: 10, bottom: 3),
                            child: Text(
                                tr("invoiceNo") + transactionResponse.invoiceNo,
                                style: TextStyle(
                                    color: ColorData.toColor(
                                            transactionResponse.colorCode)
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(left: 10)
                                    : EdgeInsets.only(right: 10),
                            child: Text("",
                                style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                          Spacer(flex: 1),
                          Padding(
                            padding:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? EdgeInsets.only(right: 10)
                                    : EdgeInsets.only(left: 10),
                            child: Text(
                                tr("orderNo") + transactionResponse.orderNo,
                                style: TextStyle(
                                    color: ColorData.primaryTextColor,
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                          ),
                        ],
                      ),
                    ),
                    !transactionResponse.showQRCode
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.30,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getTransactionDetail(
                                      transactionDetailResponse,
                                      transactionResponse)
                                ]))
                        : Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                Container(
                                    height: 150,
                                    width: 150,
                                    child: RepaintBoundary(
                                        key: globalKey,
                                        child: QrImage(
                                          data: transactionResponse.orderNo,
                                          version: QrVersions.auto,
                                          size: 200.0,
                                          backgroundColor: Colors.white,
                                          foregroundColor:
                                              ColorData.primaryTextColor,
                                        ))),
                              ],
                            )),
                    // Container(
                    //   margin: EdgeInsets.all(10),
                    //   height: MediaQuery.of(context).size.height / 10,
                    //   width: double.infinity,
                    //   decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey[400]),
                    //       borderRadius: BorderRadius.circular(8)),
                    //   child: Row(
                    //     children: [
                    //       Container(
                    //         margin:
                    //             Localizations.localeOf(context).languageCode == "en"
                    //                 ? EdgeInsets.only(left: 10, top: 2)
                    //                 : EdgeInsets.only(right: 10, top: 2),
                    //         child: Text('Total Amount',
                    //             style: TextStyle(
                    //                 color:
                    //                     ColorData.primaryTextColor.withOpacity(1.0),
                    //                 fontSize: Styles.packageExpandTextSiz,
                    //                 fontFamily: tr('currFontFamily'))),
                    //       ),
                    //       Padding(
                    //         padding: Localizations.localeOf(context).languageCode ==
                    //                 "en"
                    //             ? EdgeInsets.only(left: 25, top: 10, bottom: 10)
                    //             : EdgeInsets.only(right: 25, top: 10, bottom: 10),
                    //         child: VerticalDivider(color: Colors.grey[400]),
                    //       ),
                    //       Padding(
                    //         padding: Localizations.localeOf(context).languageCode ==
                    //                 "en"
                    //             ? EdgeInsets.only(left: 40, top: 10, bottom: 10)
                    //             : EdgeInsets.only(right: 40, top: 10, bottom: 10),
                    //         child: Text(
                    //           'AED ' +
                    //               transactionResponse.payableAmount
                    //                   .toStringAsFixed(2),
                    //           style: TextStyle(
                    //               color:
                    //                   ColorData.primaryTextColor.withOpacity(1.0),
                    //               fontSize: Styles.packageExpandTextSiz,
                    //               fontFamily: tr('currFontFamily')),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? EdgeInsets.only(right: 20)
                                  : EdgeInsets.only(left: 20),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                    tr("original_Amount"),
                                                    style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor
                                                            .withOpacity(1.0),
                                                        fontSize: Styles
                                                            .loginBtnFontSize,
                                                        fontFamily: tr(
                                                            'currFontFamily'))))),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                      crossAxisAlignment:
                                          Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Row(
                                              mainAxisAlignment:
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " " +
                                                      double.parse(
                                                          (transactionResponse
                                                                      .grossAmount +((transactionResponse.facilityId==Constants.FacilityLafeel
                                                              || transactionResponse.facilityId==Constants.FacilityCollageCafe
                                                              || transactionResponse.facilityId==Constants.FacilitySkateCafe)?transactionResponse.vatAmount:0))
                                                              .toStringAsFixed(
                                                                  2)??0).toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
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
                              Visibility(
                                  visible: transactionResponse
                                                  .deliveryCharges !=
                                              null &&
                                          transactionResponse.deliveryCharges >
                                              0
                                      ? true
                                      : false,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.30,
                                                child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text(
                                                        tr("delivery_charges"),
                                                        style: TextStyle(
                                                            color: ColorData
                                                                .primaryTextColor
                                                                .withOpacity(
                                                                    1.0),
                                                            fontSize: Styles
                                                                .loginBtnFontSize,
                                                            fontFamily: tr(
                                                                'currFontFamily'))))),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
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
                                                          fontSize:
                                                              Styles.textSiz,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Row(
                                                  mainAxisAlignment: Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .languageCode ==
                                                          "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      " " +
                                                          (double.parse(
                                                              (transactionResponse
                                                                          .deliveryCharges -
                                                                      transactionResponse
                                                                          .deliveryVat)
                                                                  .toStringAsFixed(
                                                                      2), (e) {
                                                            return 0;
                                                          })).toStringAsFixed(
                                                              2),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              Visibility(
                                  visible: transactionResponse.facilityId!=Constants.FacilityLafeel
                                  && transactionResponse.facilityId!=Constants.FacilityCollageCafe
                                      && transactionResponse.facilityId!=Constants.FacilitySkateCafe
                                      ? true
                                      : false,
                                  child: Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.30,
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(tr("Vat_amount"),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily')))),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Row(
                                              mainAxisAlignment:
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " " +
                                                      double.parse(
                                                          transactionResponse
                                                              .vatAmount
                                                              .toStringAsFixed(
                                                                  2), (e) {
                                                        return 0;
                                                      }).toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily:
                                                          tr('currFontFamily')),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              Visibility(
                                  visible: transactionResponse.offerAmount !=
                                              null &&
                                          transactionResponse.offerAmount > 0
                                      ? true
                                      : false,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.35,
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Text(
                                                      tr("Discount_amount"),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')))),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
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
                                                          fontSize:
                                                              Styles.textSiz,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.15,
                                                child: Row(
                                                  mainAxisAlignment: Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .languageCode ==
                                                          "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      " " +
                                                          (transactionResponse
                                                                      .offerAmount ==
                                                                  null
                                                              ? "0.00"
                                                              : (double.parse(
                                                                  transactionResponse
                                                                      .offerAmount
                                                                      .toStringAsFixed(
                                                                          2),
                                                                  (e) {
                                                                  return 0;
                                                                }).toStringAsFixed(
                                                                  2))),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              Visibility(
                                  visible: transactionResponse.giftCardAmount !=
                                      null &&
                                      transactionResponse.giftCardAmount > 0
                                      ? true
                                      : false,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.35,
                                              child: Align(
                                                  alignment:
                                                  Alignment.centerRight,
                                                  child: Text(
                                                      tr("giftvoucher_redeem_amount"),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')))),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                                          fontSize:
                                                          Styles.textSiz,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.15,
                                                child: Row(
                                                  mainAxisAlignment: Localizations
                                                      .localeOf(
                                                      context)
                                                      .languageCode ==
                                                      "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      " " +
                                                          (transactionResponse
                                                              .giftCardAmount ==
                                                              null
                                                              ? "0.00"
                                                              : (double.parse(
                                                              transactionResponse
                                                                  .giftCardAmount
                                                                  .toStringAsFixed(
                                                                  2),
                                                                  (e) {
                                                                return 0;
                                                              }).toStringAsFixed(
                                                              2))),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                margin: EdgeInsets.only(top: 8),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Container(
                                          width: Localizations.localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.525
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.60,
                                          child: Divider(
                                            thickness: 1,
                                          )),
                                    ]),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.75,
                                margin: EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.30,
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(tr("final_Amount"),
                                                    style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor
                                                            .withOpacity(1.0),
                                                        fontSize: Styles
                                                            .loginBtnFontSize,
                                                        fontFamily: tr(
                                                            'currFontFamily'))))),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: Row(
                                              mainAxisAlignment:
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  " " +
                                                      double.parse(
                                                          transactionResponse
                                                              .payableAmount
                                                              .toStringAsFixed(
                                                                  2), (e) {
                                                        return 0;
                                                      }).toStringAsFixed(2),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
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
                              Visibility(
                                  visible: transactionResponse.facilityId==Constants.FacilityLafeel
                                      || transactionResponse.facilityId==Constants.FacilityCollageCafe
                                      || transactionResponse.facilityId==Constants.FacilitySkateCafe
                                      ? true
                                      : false,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.75,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  0.30,
                                              child: Align(
                                                  alignment: Alignment.centerRight,
                                                  child: Text(tr("Vat_amount"),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily: tr(
                                                              'currFontFamily')))),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
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
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.15,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  Localizations.localeOf(
                                                      context)
                                                      .languageCode ==
                                                      "en"
                                                      ? MainAxisAlignment.end
                                                      : MainAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      " " +
                                                          double.parse(
                                                              transactionResponse
                                                                  .vatAmount
                                                                  .toStringAsFixed(
                                                                  2), (e) {
                                                            return 0;
                                                          }).toStringAsFixed(2),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor
                                                              .withOpacity(1.0),
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          fontFamily:
                                                          tr('currFontFamily')),
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            // if (rateTxtOnTap != null) rateTxtOnTap();
                          },
                          highlightColor: Color(0x00000000),
                          splashColor: Color(0x00000000),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(top: 8, right: 20)
                                    : EdgeInsets.only(top: 8, left: 20),
                                child: Text(
                                  tr("rate_Txt"),
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.lightBlue),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: transactionResponse.tipsAmount != null &&
                                    transactionResponse.tipsAmount > 0
                                ? true
                                : false,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.90,
                              margin: EdgeInsets.only(top: 20),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.80,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                                tr("tipsAmountText") +
                                                    " : AED " +
                                                    (transactionResponse
                                                                .tipsAmount ==
                                                            null
                                                        ? "0.00"
                                                        : (double.parse(
                                                            transactionResponse
                                                                .tipsAmount
                                                                .toStringAsFixed(
                                                                    2), (e) {
                                                            return 0;
                                                          }).toStringAsFixed(
                                                            2))),
                                                style:
                                                    TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor
                                                            .withOpacity(1.0),
                                                        fontSize: Styles
                                                            .loginBtnFontSize,
                                                        fontFamily: tr(
                                                            'currFontFamily')))),
                                      ),
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: [
                                  //     Container(
                                  //         width: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //             0.15,
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               MainAxisAlignment.end,
                                  //           children: [
                                  //             Text(
                                  //               "AED",
                                  //               style: TextStyle(
                                  //                   color: ColorData
                                  //                       .primaryTextColor
                                  //                       .withOpacity(1.0),
                                  //                   fontSize: Styles.textSiz,
                                  //                   fontFamily:
                                  //                       tr('currFontFamily')),
                                  //             ),
                                  //           ],
                                  //         )),
                                  //   ],
                                  // ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.end,
                                  //   children: [
                                  //     Container(
                                  //         width: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //             0.15,
                                  //         child: Row(
                                  //           mainAxisAlignment:
                                  //               Localizations.localeOf(context)
                                  //                           .languageCode ==
                                  //                       "en"
                                  //                   ? MainAxisAlignment.end
                                  //                   : MainAxisAlignment.start,
                                  //           children: [
                                  //             Text(
                                  //               " " +
                                  //                   (transactionResponse
                                  //                               .tipsAmount ==
                                  //                           null
                                  //                       ? "0.00"
                                  //                       : (double.parse(
                                  //                           transactionResponse
                                  //                               .tipsAmount
                                  //                               .toStringAsFixed(
                                  //                                   2), (e) {
                                  //                           return 0;
                                  //                         }).toStringAsFixed(
                                  //                           2))),
                                  //               style: TextStyle(
                                  //                   color: ColorData
                                  //                       .primaryTextColor
                                  //                       .withOpacity(1.0),
                                  //                   fontSize:
                                  //                       Styles.loginBtnFontSize,
                                  //                   fontFamily:
                                  //                       tr('currFontFamily')),
                                  //             ),
                                  //           ],
                                  //         )),
                                  //   ],
                                  // ),
                                ],
                              ),
                            )),
                      ],
                    ),
                    !transactionResponse.showQRCode
                        ? Text("")
                        : Container(
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _captureAndSharePng();
                                  },
                                  child: Icon(
                                    Icons.share,
                                    color: Theme.of(context).primaryColor,
                                    size: 30,
                                  ),
                                ),

//                       GestureDetector(
//                         onTap: () {
//                           // goToWhatsApp(Constants.whatsAppURL(
//                           //     tr('more_phone_number').replaceAll('+', ''),
//                           //     tr('whatsAppStaticMorePageMsg') +
//                           //         " " +
//                           //         Constants.whatsAppReplaceTxt +
//                           //         "."));
//                           _captureAndSharePng();
//                         },
//                         child: Container(
//                           decoration: BoxDecoration(
// //                                      color: Color.fromRGBO(14, 150, 119, 1),
//                               color: ColorData.successSnakBr,
//                               shape: BoxShape.circle),
//                           child: Padding(
//                             padding: EdgeInsets.all(9.0),
//                             child: Icon(WhatsAppIcon.whatsapp,
//                                 size: 22, color: Colors.white),
//                           ),
//                         ),
//                       ),
                              ],
                            ),
                          )
                  ],
                ),
              ));
        });
  }

  Widget getCalendar() {
    return Expanded(
        //   // child: Container(
        //   //     height: MediaQuery.of(context).size.height * 0.60,
        //   //     margin: EdgeInsets.only(top: 0.0),
        //   child: SingleChildScrollView(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 0, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              TableCalendar(
                initialCalendarFormat: CalendarFormat.week,
                calendarStyle: CalendarStyle(
                    todayColor: Theme.of(context).primaryColor,
                    selectedColor: Colors.grey[400],
                    weekendStyle: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0)),
                    weekdayStyle: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0)),
                    outsideWeekendStyle: TextStyle(color: Colors.grey),
                    todayStyle: TextStyle(
                        fontSize: Styles.packageExpandTextSiz,
                        fontFamily: tr('currFontFamily'),
                        color: Colors.white)),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle().copyWith(
                      color: ColorData.primaryTextColor.withOpacity(1.0)),
                  weekdayStyle: TextStyle().copyWith(
                      color: ColorData.primaryTextColor.withOpacity(1.0)),
                ),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      // margin: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 6, right: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.black54),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 6, right: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
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
            margin: EdgeInsets.only(left: 8, right: 8, top: 14),
            height: MediaQuery.of(context).size.height * 0.55,
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey[400]),
                color: Colors.white),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [getBookingSlots()])),
      ],
    ));
    // );
    // ));
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
                height: MediaQuery.of(context).size.height * 0.17,
                width: MediaQuery.of(context).size.width * 0.94,
                margin: EdgeInsets.only(top: 5),
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(
                  children: [
                    Container(
                        margin: EdgeInsets.only(top: 15, left: 10),
                        height: 60,
                        width: 60,
                        child: Image.asset(
                          currentSlots[j].facilityId ==
                                      Constants.FacilityLeisure ||
                                  currentSlots[j].facilityId ==
                                      Constants.FacilityOlympicPool || currentSlots[j].facilityId ==
                              Constants.FacilityIceRink
                              ? "assets/images/10_11_12_logo.png"
                              : "assets/images/" +
                                  currentSlots[j].facilityId.toString() +
                                  "_logo.png",
                          fit: BoxFit.cover,
                        )),
                    Container(
                      margin: const EdgeInsets.only(top: 20, left: 85),
                      child: Row(
                        children: [
                          Text(currentSlots[j].appFromTime +
                              '-' +
                              currentSlots[j].appToTime,
                              style: TextStyle(
                                  color: ColorData.toColor(
                                      currentSlots[j].colorCode),
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 40, left: 85),
                      child: Row(
                        children: [
                          Text(currentSlots[j].firstName.toString(),
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 60, left: 85),
                      child: Row(
                        children: [
                          Text(currentSlots[j].className,
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 80, left: 85),
                      child: Row(
                        children: [
                          Text(tr('reservation_id')+": "+currentSlots[j].reservationId.toString(),
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 100, left: 85),
                      child: Row(
                        children: [
                          Text(tr('trainer')+": "+currentSlots[j].trainer,
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 2,
                          left: MediaQuery.of(context).size.width * 0.62),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              (currentSlots[j].isBookable==0)

                                  ? IconButton(
                                      icon: Icon(Icons.remove_circle),
                                      color: ColorData.toColor(
                                          currentSlots[j].colorCode),
                                      iconSize: 25,
                                      onPressed: () {
                                        if (!(currentSlots[j].isBookable==2)) {
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
                                                            tr('bookings'),
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
                                                                    backgroundColor:
                                                                    MaterialStateProperty.all<Color>(ColorData.grey300),
                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                        RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius.all(
                                                                              Radius.circular(2.0),
                                                                            )))),
                                                                // color:
                                                                // ColorData.grey300,
                                                                child: new Text(tr("no"),
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
                                                                  backgroundColor:
                                                                  MaterialStateProperty.all<Color>(ColorData.colorBlue),
                                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                            Radius.circular(2.0),
                                                                          )))),
                                                              child: new Text(
                                                                tr("yes"),
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
                                                                _handler.show();
                                                                Meta m = await (new FacilityDetailRepository()).saveBooking(
                                                                    0,
                                                                    currentSlots[j]
                                                                        .reservationId,
                                                                    currentSlots[j]
                                                                        .reservationTemplateId,
                                                                    true
                                                                        ,
                                                                    currentSlots[j]
                                                                        .bookingId);
                                                                if (m.statusCode ==
                                                                    200) {
                                                                  _handler.dismiss();
                                                                  util.customGetSnackBarWithOutActionButton(
                                                                      tr("booking"),
                                                                      tr('schedule_cancel_success'),
                                                                      context);
                                                                  TimeTableList timeTableList = new TimeTableList();
                                                                  Meta m2 = await FacilityDetailRepository().getEnquiryAllTimeTableList(
                                                                      selectedDate);
                                                                  timeTableList =
                                                                      TimeTableList.fromJson(jsonDecode(m2.statusMsg)['response']);
                                                                  setState(() {
                                                                    currentSlots=timeTableList.timeTables;
                                                                  });
                                                                } else {
                                                                  _handler.dismiss();
                                                                  util.customGetSnackBarWithOutActionButton(
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
                                        }
                                      },
                                    )
                                  :(currentSlots[j].isBookable==1)?IconButton(
              icon: Icon(Icons.add),
              color: ColorData.toColor(
              currentSlots[j].colorCode),
              iconSize: 25,
              onPressed: ()async {
                Meta m =
                await (new FacilityDetailRepository())
                    .saveBooking(
                    currentSlots[j]
                        .enquiryDetailId,
                    currentSlots[j].reservationId,
                    currentSlots[j]
                        .reservationTemplateId,
                   false,
                    0);
                if (m.statusCode == 200) {
                  util.customGetSnackBarWithOutActionButton(
                      tr("booking"),
                      tr("schedule_success"),
                      context);
                  TimeTableList timeTableList = new TimeTableList();
                  Meta m2 = await FacilityDetailRepository().getEnquiryAllTimeTableList(
                      selectedDate);
                  timeTableList =
                      TimeTableList.fromJson(jsonDecode(m2.statusMsg)['response']);
                  setState(() {
                    currentSlots=timeTableList.timeTables;
                  });
                } else {
                  util.customGetSnackBarWithOutActionButton(
                      tr("enquiry"), m.statusMsg, context);
                }
              }):IconButton(
                                icon: Icon(Icons.done),
                                color: ColorData.toColor(
                                    currentSlots[j].colorCode),
                                iconSize: 25,
                                onPressed: () {
                                  /*if (!(currentSlots[j].isBookable==2)) {
                                    Faculty f = new Faculty();
                                    f.facultyName = "Siva";
                                    f.facultyId = 1;
                                    _faculty = f;
                                    DropdownMenuItem<Faculty> m1 =
                                    new DropdownMenuItem(
                                      child: Text('Siva'),
                                      value: f,
                                    );
                                    f = new Faculty();
                                    f.facultyName = "Suman";
                                    f.facultyId = 1;
                                    DropdownMenuItem<Faculty> m2 =
                                    new DropdownMenuItem(
                                      child: Text('Suman'),
                                      value: f,
                                    );
                                    f = new Faculty();
                                    f.facultyName = "Raja";
                                    f.facultyId = 1;
                                    DropdownMenuItem<Faculty> m3 =
                                    new DropdownMenuItem(
                                      child: Text('Raja'),
                                      value: f,
                                    );
                                    _facultyDropdownList.clear();
                                    _facultyDropdownList.add(m1);
                                    _facultyDropdownList.add(m2);
                                    _facultyDropdownList.add(m3);
                                    displayCourseScheduleModalBottomSheet(
                                        context);
                                  }*/
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 1),
                                child: Text(
                                    (currentSlots[j].isBookable==0)
                                        ? tr('remove'):(currentSlots[j].isBookable==1)?tr('book')
                                        : tr('completed'),
                                    style: TextStyle(
                                        color: ColorData.toColor(
                                            currentSlots[j].colorCode),
                                        fontSize: Styles.packageExpandTextSiz,
                                        fontFamily: tr('currFontFamily'))),
                              )
                            ],
                          ),
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

  void _onCalendarCreated(DateTime day, DateTime day1, CalendarFormat format) async {
    selectedDate = _controller.selectedDay.toString().substring(0, 10);
    TimeTableList timeTableList = new TimeTableList();
    Meta m2 = await FacilityDetailRepository().getEnquiryAllTimeTableList(
        selectedDate);
    timeTableList =
        TimeTableList.fromJson(jsonDecode(m2.statusMsg)['response']);
    setState(() {
      currentSlots=timeTableList.timeTables;
    });

  }

  void _onDaySelected(DateTime day, List events, List holidays)async {
    print('CALLBACK: _onDaySelected');
    currentSlots.clear();
    selectedDate = day.toString().substring(0, 10);
    TimeTableList timeTableList = new TimeTableList();
      Meta m2 = await FacilityDetailRepository().getEnquiryAllTimeTableList(
          selectedDate);
      timeTableList =
          TimeTableList.fromJson(jsonDecode(m2.statusMsg)['response']);
    setState(() {
      currentSlots=timeTableList.timeTables;
    });

  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: uiprefix.ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      List<String> paths = [];
      paths.add('${tempDir.path}/image.png');
      Share.shareFiles(paths, subject: "Your Beach Pass");
      //await Share.file(_dataString, '$_dataString.png', pngBytes, 'image/png');
    } catch (e) {
      print(e.toString());
    }
  }

  void displayCourseScheduleModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Color(0xFF737373),
            child: Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.98,
                  height: MediaQuery.of(context).size.height * 0.55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16)),
                      border: Border.all(color: Colors.grey[400]),
                      color: Colors.red),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, top: 10, right: 15),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.30,
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
                              height: MediaQuery.of(context).size.height * 20,
                              child: FormBuilder(
                                  child: Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 10, left: 10, right: 10),
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: CustomDropdown(
                                    dropdownMenuItemList: _facultyDropdownList,
                                    onChanged: _onChangeCategoryDropdown,
                                    value: _faculty,
                                    isEnabled: true,
                                  ),
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
                        margin: EdgeInsets.only(
                            top: 240,
                            left: MediaQuery.of(context).size.width * 0.25),
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.49,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                              backgroundColor:
                              MaterialStateProperty.all<Color>(ColorData.activeIconColor),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8.0),
                                      )))),
                          onPressed: () {
                            currentSlots.clear();
                            Navigator.of(context).pop();
                          },
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

  _onChangeCategoryDropdown(Faculty faculty) {
    setState(() {
      _faculty = faculty;
    });
  }
  _onChangeOptionDropdown(ActiveFacilityViewDto facility) {
    selectedActiveFacility = facility;
    setState(() {});
  }

  void  doRecall() async{
    voucherRedemptionList =
    [];
    Meta m =
    await (new FacilityDetailRepository())
        .getRedemptionList(0, 0,8);
    if (m.statusCode == 200) {
      jsonDecode(m.statusMsg)["response"]
          .forEach((f) =>
          voucherRedemptionList.add(
              new LoyaltyVoucherResponse
                  .fromJson(f)));
    }
    voucherRedemptionFacilities=[];
    displayVoucherRedemptionList=[];
    if(voucherRedemptionList!=null && voucherRedemptionList.length>0){
      String firstFacility="";
      for(var v in voucherRedemptionList){
        if(voucherRedemptionFacilities.indexOf(v.voucherName)==-1){
          voucherRedemptionFacilities.add(v.voucherName);
          if(firstFacility==""){
            firstFacility=v.voucherName;
          }
        }
        if(v.voucherName==firstFacility) {
          displayVoucherRedemptionList.add(
              v);
        }
      }
    }
    setState(() {
      isCorporateVoucher=true;
      isObbVoucher=false;
      isSpaVoucher=false;
    });
  }

  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }

  updateHeadSelectedIndex(btnHeadIndex) {
    setState(() {
      selectedHeadIndex = btnHeadIndex;
      ismainExpanded = false;
    });
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
    key: ValueKey(index),
    controller: scrlController,
    index: index,
    child: child,
    highlightColor: Colors.black.withOpacity(0.1),
  );
}
