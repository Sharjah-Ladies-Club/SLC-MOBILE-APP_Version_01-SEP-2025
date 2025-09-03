// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:barcode/barcode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/expansiontile/groovenexpan.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/transaction_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/utils/constant.dart';


bool isExpanded = false;

class Passes extends StatelessWidget {
  List<LoyaltyVoucherResponse> voucherRedemptionList =[];
  List<String> voucherRedemptionFacilities = [];
  List<LoyaltyVoucherResponse> displayVoucherRedemptionList =[];


  @override
  Widget build(BuildContext context) {

    return BlocProvider<FitnessBloc>(
        create: (context) => FitnessBloc(null)
          ..add(GetAppDescEvent(descId: 5))
          ..add(GetFitnessVouchersEvent(userId: SPUtil.getInt(Constants.USERID))),
     child: _Passes(
        voucherRedemptionList: this.voucherRedemptionList,
        voucherRedemptionFacilities: this.voucherRedemptionFacilities,
        displayVoucherRedemptionList: this.displayVoucherRedemptionList,
      ),
    );
  }
}

class _Passes extends StatefulWidget {
  List<LoyaltyVoucherResponse> voucherRedemptionList =[];
  List<String> voucherRedemptionFacilities = [];
  List<LoyaltyVoucherResponse> displayVoucherRedemptionList =[];
  _Passes(
      {this.voucherRedemptionList,
      this.voucherRedemptionFacilities,
      this.displayVoucherRedemptionList});
  int listIndex = 0;
  String colorCode = "#EEEEEE";
  @override
  _PassesState createState() => _PassesState(
        voucherRedemptionList: this.voucherRedemptionList,
        voucherRedemptionFacilities: this.voucherRedemptionFacilities,
        displayVoucherRedemptionList: this.displayVoucherRedemptionList,
      );
}

// class _PassesState extends StatefulWidget {
//   int haveFitnessMemberShip;
//   String colorCode;
//
//   PassesPage({
//     this.haveFitnessMemberShip = 0,
//     this.colorCode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider<FitnessBloc>(
//       create: (context) => FitnessBloc(null)
//         ..add(GetFitnessVouchersEvent(userId: SPUtil.getInt(Constants.USERID))),
//       child: Passes(haveFitnessMemberShip: haveFitnessMemberShip),
//     );
//   }
// }

class _PassesState extends State<_Passes> {
  int selectedIndex = -1;
  bool ismainExpanded = false;
  ProgressBarHandler _handler;
  int haveFitnessMemberShip;
  Key key;
  int number = Random().nextInt(3000000000);
  AutoScrollController scrlController;
  List<LoyaltyVoucherResponse> voucherRedemptionList =[];
  List<String> voucherRedemptionFacilities = [];
  List<LoyaltyVoucherResponse> displayVoucherRedemptionList =[];
  Utils util = Utils();
  bool otpSent=false;
  bool isVoucherRedemptionProgress=false;
  String giftVoucherOtp="";
  bool isMembershipVoucher=true;
  MaskedTextController _otpController =
  new MaskedTextController(mask: Strings.maskMobileValidationStr);
  MaskedTextController _shareMobileController =
  new MaskedTextController(mask: Strings.maskMobileValidationStr);
  // TextEditingController _otpamountController = new TextEditingController();
  //
  // TextEditingController _activeFacilityController =
  // new TextEditingController();
  String moduleDescription = "";

  _PassesState(
      {this.voucherRedemptionList,
      this.voucherRedemptionFacilities,
      this.displayVoucherRedemptionList});
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is ShowFitnessProgressBar) {
            _handler.show();
          } else if (state is HideFitnessProgressBar) {
            _handler.dismiss();
          } else if (state is GetFitnessVoucherState) {

            if (state.voucherRedemptionList != null) {
              setState(() {
                widget.voucherRedemptionList = state.voucherRedemptionList;
                widget.displayVoucherRedemptionList =
                    state.displayVoucherRedemptionList;
                widget.voucherRedemptionFacilities =
                    state.voucherRedemptionFacilities;
              });
            }
          } else if (state is GetAppDescState) {
              if (state.result != null) {
                moduleDescription =
                Localizations.localeOf(context).languageCode == "en"
                    ? state.result.descEn
                    : state.result.descAr;
              }
          }
        },
        child: SafeArea(
            child: Scaffold(
          backgroundColor: ColorData.backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: CustomAppBar(
              title: tr("fitness_title"),
            ),
          ),
          body: Column(
            children: [
              SizedBox(
                height: screenHeight * 0.3,
                child: Image.asset(
                  'assets/images/fitnessgymbg.png',
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
                  padding:
                      EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                  child: Text(tr("vouchers"),
                      style: TextStyle(
                          fontSize: Styles.textSizeSeventeen,
                          color: ColorData.fitnessFacilityColor,
                          fontWeight: FontWeight.bold))),
              Container(
                  height: screenWidth * 0.15,
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  color: ColorData.whiteColor,
                  padding:
                      EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                  child: SingleChildScrollView(child:Text(
                      moduleDescription!=null ?moduleDescription: tr("voucher_desc"),
                    style: TextStyle(
                        fontSize: Styles.packageExpandTextSiz,
                        color: ColorData.primaryTextColor),
                  ))),
              Container(
                  height: screenHeight * 0.40,
                  // color: Colors.red,
                  child:  getMembershipRedeemDetails()),
            ],
          ),
        )));
  }



  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: scrlController,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
  Widget getMembershipRedeemDetails() {
    return ListView.builder(
      controller: scrlController,
      key: key,
      scrollDirection: Axis.vertical,
      itemCount: widget.voucherRedemptionFacilities.length,
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
                    widget.displayVoucherRedemptionList = [];
                    for (var v in widget.voucherRedemptionList) {
                      if (v.voucherName ==
                          widget.voucherRedemptionFacilities[i]) {
                        widget.displayVoucherRedemptionList.add(v);
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
                      widget.voucherRedemptionFacilities[i].trim(),
                      ColorData.primaryTextColor,
                      isExpanded && selectedIndex == i),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: NestedScrollViewInnerScrollPositionKeyWidget(
                        Key(i.toString()),
                        ListView.builder(
                            key:
                                PageStorageKey(i.toString() + "pageStorageKey"),
                            scrollDirection: Axis.vertical,
                            itemCount: widget.displayVoucherRedemptionList ==
                                    null
                                ? 0
                                : widget.displayVoucherRedemptionList.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, j) {
                              return getVoucherDetail(
                                  widget.displayVoucherRedemptionList, j);
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
    );
  }
  //
  // Widget getVoucherDetail(
  //     List<LoyaltyVoucherResponse> voucherRedemptionList, j) {
  //   Barcode bc = Barcode.code39();
  //   final svg = bc.toSvg(
  //     voucherRedemptionList[j].qrCode,
  //     width: 200,
  //     height: 40,
  //     fontHeight: 16,
  //   );
  //   return Visibility(
  //       visible: voucherRedemptionList != null &&
  //               (!voucherRedemptionList[j].isRedeemed ||
  //                   voucherRedemptionList[j].showQrCode) &&
  //               (!voucherRedemptionList[j].isShared ||
  //                   voucherRedemptionList[j].userId !=
  //                       SPUtil.getInt(Constants.USERID))
  //           ? true
  //           : false,
  //       child: Container(
  //         child: Stack(
  //           children: <Widget>[
  //             //Expanded(
  //             // padding: EdgeInsets.only(top: 10, bottom: 2),
  //             // Localizations.localeOf(context).languageCode == "en"
  //             //     ? EdgeInsets.only(top: 2, left: 5)
  //             //     : EdgeInsets.only(top: 5, right: 5),
  //             Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: <Widget>[
  //                   Container(
  //                     height: MediaQuery.of(context).size.height * 0.19,
  //                     width: MediaQuery.of(context).size.width * 0.95,
  //                     child: Stack(
  //                       children: <Widget>[
  //                         Container(
  //                           height: MediaQuery.of(context).size.height * 0.18,
  //                           width: MediaQuery.of(context).size.width * 0.96,
  //                           child: Image.network(
  //                               voucherRedemptionList[j].voucherImageUrl,
  //                               fit: BoxFit.cover),
  //                         ),
  //                         Container(
  //                             alignment: Alignment.topRight,
  //                             margin: EdgeInsets.only(
  //                                 top: 8, right: 23, left: 67, bottom: 10),
  //                             child: Text(
  //                               voucherRedemptionList[j].validMonth,
  //                               style: TextStyle(
  //                                 color: ColorData.primaryColor,
  //                                 fontFamily: tr("currFontFamily"),
  //                                 fontWeight: FontWeight.w500,
  //                                 fontSize: Styles.packageExpandTextSiz,
  //                               ),
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 ]),
  //           ],
  //         ),
  //       ));
  // }
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
                                // margin: Localizations.localeOf(context)
                                //             .languageCode ==
                                //         "en"
                                //     ? EdgeInsets.only(left: 1, top: 1)
                                //     : EdgeInsets.only(right: 1, top: 1),
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
                                      && (!voucherRedemptionList[j].isShared || voucherRedemptionList[j].userId!=SPUtil.getInt(Constants.USERID))
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
                                            ((voucherRedemptionList[j].voucherType==6 && voucherRedemptionList[j].userId==SPUtil.getInt(Constants.USERID))?0.08:0.20),
                                        top: 85)
                                        : EdgeInsets.only(
                                        right: MediaQuery.of(context)
                                            .size
                                            .width *
                                            ((voucherRedemptionList[j].voucherType==6 && voucherRedemptionList[j].userId==SPUtil.getInt(Constants.USERID))?0.80:0.70),
                                        top: 85),
                                    child: TextButton(
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
                                                              //_handler.show();
                                                              Meta m =
                                                              await (new FacilityDetailRepository())
                                                                  .saveVoucherUse(
                                                                  voucherRedemptionList[
                                                                  j]
                                                                      .redemptionId);
                                                              if (m
                                                                  .statusCode ==
                                                                  200) {
                                                                //_handler.dismiss();
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
                                                                                      //  _handler.show();
                                                                                        Meta m =
                                                                                        await (new FacilityDetailRepository())
                                                                                            .checkVoucherOtp(
                                                                                            voucherRedemptionList[
                                                                                            j]
                                                                                                .redemptionId,_otpController.text.toString());
                                                                                        if (m
                                                                                            .statusCode ==
                                                                                            200) {
                                                                                        //  _handler.dismiss();
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
                                                                                         // _handler.dismiss();
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
                                                               // _handler.dismiss();
                                                                isVoucherRedemptionProgress=false;
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
                                  )),
                              Visibility(
                                  visible:
                                  voucherRedemptionList != null &&
                                      !voucherRedemptionList[j]
                                          .isRedeemed && voucherRedemptionList[j].isUseEnabled && voucherRedemptionList[j]
                                      .isSharable
                                      && voucherRedemptionList[j].voucherType==6 && !voucherRedemptionList[j].isShared
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
                                            ((!voucherRedemptionList[j].isUsabel)?0.08:0.30),
                                        top: 85)
                                        : EdgeInsets.only(
                                        right: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.50,
                                        top: 85),
                                    child: TextButton(
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
                                                        child: Container(
                                                            width: MediaQuery.of(context).size.width * 0.50,
                                                            height: MediaQuery.of(context).size.height * 0.080,
                                                            child: new TextFormField(
                                                                keyboardType: TextInputType.number,
                                                                controller: _shareMobileController,
                                                                textAlign: TextAlign.center,
                                                                decoration: new InputDecoration(
                                                                  contentPadding: EdgeInsets.all(5),
                                                                  // contentPadding: EdgeInsets.only(
                                                                  //     left: 10, top: 0, bottom: 0, right: 0),
                                                                  hintText: "Mobile No",
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
                                                               // _handler.show();
                                                                Meta m =
                                                                await (new FacilityDetailRepository())
                                                                    .shareVoucher(
                                                                    voucherRedemptionList[
                                                                    j]
                                                                        .redemptionId,_shareMobileController.text.toString());
                                                                if (m
                                                                    .statusCode ==
                                                                    200) {
                                                                //  _handler.dismiss();
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
                                                                } else {
                                                                //  _handler.dismiss();
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
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  )),
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
}
