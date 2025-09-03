// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/fitness/fitness_enquiry.dart';
import 'package:slc/view/fitness/fitnessbuy/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/fitness/personaltraining.dart';
import 'package:slc/utils/constant.dart';

class FitnessBuyPage extends StatelessWidget {
  int facilityId;
  String retailItemSetId;
  int tableNo;
  String colorCode;
  int pageToNavigate = 0;
  int moduleId = 0;
  List<FacilityItems> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  FitnessBuyPage(
      {this.facilityId,
      this.retailItemSetId,
      this.facilityItems,
      this.itemCounts,
      this.tableNo,
      this.colorCode,
      this.pageToNavigate,
      this.moduleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FitnessBuyBloc>(
              create: (context) => FitnessBuyBloc(fitnessBuyBloc: null)
                ..add(GetItemDetailsEvent(
                    facilityId: facilityId, retailItemSetId: retailItemSetId))
                ..add(GetPaymentTerms(facilityId: facilityId))),
        ],
        child: FitnessBuyPageHomePage(
            facilityId: facilityId,
            retailItemSetId: retailItemSetId,
            facilityItems: facilityItems,
            itemCounts: itemCounts,
            colorCode: colorCode,
            pageToNavigate: pageToNavigate,
            moduleId: moduleId),
      ),
    );
  }
}

class FitnessBuyPageHomePage extends StatefulWidget {
  int facilityId;
  String retailItemSetId;
  int enquiryDetailId = 0;
  int tableNo;
  String colorCode;
  int pageToNavigate;
  int moduleId = 0;
  bool showItemCategory = false;
  List<FacilityItems> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  List<FacilityDetailItem> retailOrderCategoryItems = [];

  FacilityDetailItem selectedRetailOrderItems = new FacilityDetailItem();
  FitnessBuyPageHomePage(
      {this.facilityId,
      this.retailItemSetId,
      this.facilityItems,
      this.itemCounts,
      this.tableNo,
      this.colorCode,
      this.pageToNavigate,
      this.moduleId});
  @override
  _FitnessBuyPage createState() {
    return _FitnessBuyPage(
        itemCounts: itemCounts,
        colorCode: colorCode,
        pageToNavigate: pageToNavigate,
        moduleId: moduleId);
  }
}

class _FitnessBuyPage extends State<FitnessBuyPageHomePage> {
  static final borderColor = Colors.grey[200];
  final DateTime now = DateTime.now();
  var serverTestPath = URLUtils().getImageResultUrl();
  Utils util = new Utils();
  double total = 0;
  int totalItems = 0;
  int pageToNavigate = 0;
  String colorCode;
  int moduleId = 0;
  PaymentTerms paymentTerms = new PaymentTerms();
  //List<FacilityItems> facilityItems = new List<FacilityItems>();
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  DateTime get date => DateTime.now();
  _FitnessBuyPage(
      {this.itemCounts, this.colorCode, this.pageToNavigate, this.moduleId});
  @override
  Widget build(BuildContext context) {
    return BlocListener<FitnessBuyBloc, FitnessBuyState>(
      listener: (context, state) async {
        if (state is LoadFitnessItemList) {
          if (itemCounts == null)
            itemCounts = new HashMap<int, FacilityBeachRequest>();
          if (widget.facilityItems.length == 0) {
            setState(() {
              widget.retailOrderCategoryItems = state.fitnessItems;
              widget.selectedRetailOrderItems =
                  widget.retailOrderCategoryItems[0];
              // widget.facilityItems =
              //     widget.selectedRetailOrderItems.facilityItems;
              for (int j = 0; j < widget.retailOrderCategoryItems.length; j++) {
                List<FacilityItems> facilityItemList =
                    widget.retailOrderCategoryItems[j].facilityItems;
                widget.facilityItems.addAll(facilityItemList);
              }
              if (widget.retailOrderCategoryItems != null) {
                //widget.facilityId = state.fitnessItems[0].facilityId;
                widget.colorCode = "A81B8D";
              }
            });
          }
        } else if (state is InvalidQRCode) {
          Navigator.pop(context, true);
          util.customGetSnackBarWithOutActionButton("Invalid QR Code ",
              "Incorrect QR Code.Please try again.", context);
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FacilityDetailsPage(facilityId: Constants.FacilityLafeel)),
          );*/
        } else if (state is ShopClosed) {
          Navigator.pop(context, true);
          util.customGetSnackBarWithOutActionButton(
              tr("shopclosed"), tr("shopmaintenance"), context);
          /*Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FacilityDetailsPage(facilityId: Constants.FacilityLafeel)),
          );*/
        } else if (state is GetPaymentTermsResult) {
          paymentTerms = state.paymentTerms;
          setState(() {});
        } else if (state is FitnessBuyEnquirySaveState) {
          if (state.error == "Success") {
            int enquiryDetailId = jsonDecode(state.message)['response'];
            widget.enquiryDetailId = enquiryDetailId;
            FacilityDetailResponse facilityDetailResponse =
                new FacilityDetailResponse();
            Meta m2 = await (new FacilityDetailRepository())
                .getFacilityDetails(widget.facilityId);
            if (m2.statusCode == 200) {
              facilityDetailResponse = FacilityDetailResponse.fromJson(
                  jsonDecode(m2.statusMsg)['response']);

              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FitnessEnquiry(
                    facilityItem: state.facilityItem,
                    facilityDetail: facilityDetailResponse,
                    enquiryDetailId: enquiryDetailId,
                    screenType: Constants.Work_Flow_UploadDocuments, //2
                    moduleId: moduleId,
                  ),
                ),
              );
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF0F8FF),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          title: Text(
            widget.selectedRetailOrderItems.facilityItemGroup == null
                ? tr("membership_dtl")
                : widget.showItemCategory
                    ? widget.selectedRetailOrderItems.facilityItemGroup
                    : tr("package_details"),
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              //if (widget.showItemCategory) {
              Navigator.pop(context);
              if (widget.pageToNavigate == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FacilityDetailsPage(facilityId: widget.facilityId)),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalTrainingPage(
                            screenType: 1,
                            colorCode: widget.colorCode,
                          )),
                );
              }
              // } else {
              //   setState(() {
              //     widget.showItemCategory = true;
              //   });
              // }
            },
          ),
          actions: <Widget>[],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/fitness_bg.png"),
                      fit: BoxFit.cover)),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: (total == 0)
                          ? MediaQuery.of(context).size.height * 0.887
                          : MediaQuery.of(context).size.height * 0.80,
                      width: MediaQuery.of(context).size.width,
                      // margin: EdgeInsets.only(
                      //     top: MediaQuery.of(context).size.height * 0.40),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Visibility(
                            //     visible: widget.showItemCategory,
                            //     child: getItemCategoryList(
                            //         widget.facilityId, widget.retailItemSetId)),
                            Visibility(
                                visible: !widget.showItemCategory,
                                child: getItemList(
                                    widget.facilityId, widget.retailItemSetId)),
                          ])),
                  // SizedBox(height: 20),
                  // total != 0
                  Visibility(
                      visible: (total != 0) ? true : false,
                      child: Container(
                          margin: EdgeInsets.only(
                              left: 10,
                              right: 10,
                              bottom: 10,
                              top: MediaQuery.of(context).size.height * 0.80),
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ButtonTheme(
                            child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorData.toColor(widget.colorCode)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )))),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              // color: ColorData.toColor(widget.colorCode),
                              child: Align(
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(left: 10, top: 15)
                                            : EdgeInsets.only(
                                                right: 10, top: 15),
                                        child: Text(
                                          totalItems.toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                top: 10,
                                                bottom: 10)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.10,
                                                top: 10,
                                                bottom: 10),
                                        child: VerticalDivider(
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                top: 15)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.13,
                                                top: 15),
                                        child: Text(
                                          "AED ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                                top: 15)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.22,
                                                top: 15),
                                        child: Text(
                                          total.toStringAsFixed(2),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.55,
                                                top: 16)
                                            : EdgeInsets.only(
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.50,
                                                top: 16),
                                        child: Text(
                                          tr("viewCart"),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                      Padding(
                                          padding: Localizations
                                                          .localeOf(context)
                                                      .languageCode ==
                                                  "en"
                                              ? EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  top: 14)
                                              : EdgeInsets.only(
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  top: 14),
                                          child: Icon(
                                            Icons.shopping_basket,
                                            color: Colors.white,
                                            size: 20,
                                          )),
                                    ],
                                  )),
                              onPressed: () async {
                                List<FacilityItems> selectedFacilityItems = [];
                                for (int j = 0;
                                    j < widget.retailOrderCategoryItems.length;
                                    j++) {
                                  List<FacilityItems> facilityItemList = widget
                                      .retailOrderCategoryItems[j]
                                      .facilityItems;
                                  for (int i = 0;
                                      i < facilityItemList.length;
                                      i++) {
                                    int itemCount = itemCounts[
                                                facilityItemList[i]
                                                    .facilityItemId] ==
                                            null
                                        ? 0
                                        : itemCounts[facilityItemList[i]
                                                .facilityItemId]
                                            .quantity;
                                    if (itemCount > 0) {
                                      selectedFacilityItems
                                          .add(facilityItemList[i]);
                                      totalItems++;
                                    }
                                  }
                                }
                                Meta m = await FacilityDetailRepository()
                                    .getDiscountList(widget.facilityId, total,
                                        itemId: selectedFacilityItems != null
                                            ? selectedFacilityItems[0]
                                                .facilityItemId
                                            : 0);
                                List<BillDiscounts> billDiscounts = [];
                                // new List<BillDiscounts>();
                                if (m.statusCode == 200) {
                                  billDiscounts =
                                      jsonDecode(m.statusMsg)['response']
                                          .forEach((f) => billDiscounts.add(
                                              new BillDiscounts.fromJson(f)));
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
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //       builder: (context) =>
                                //           new FitnessBuyPaymentPage(
                                //         facilityItems: selectedFacilityItems,
                                //         total: total,
                                //         itemCounts: itemCounts,
                                //         retailItemSetId: widget.retailItemSetId,
                                //         facilityId: widget.facilityId,
                                //         tableNo: widget
                                //             .selectedRetailOrderItems.tableNo,
                                //         colorCode: widget.colorCode,
                                //         billDiscounts: billDiscounts,
                                //         giftVouchers: vouchers,
                                //         paymentTerms: paymentTerms,
                                //       ),
                                //     ));
                              },
                            ),
                          )))
                ],
              )),
        ),
      ),
    );
  }

  Widget getItemCategoryList(int facilityId, String retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.retailOrderCategoryItems == null
                ? 0
                : widget.retailOrderCategoryItems.length,
            itemBuilder: (context, j) {
              return Visibility(
                  visible: widget.retailOrderCategoryItems[j].facilityItems !=
                              null &&
                          widget.retailOrderCategoryItems[j].facilityItems
                                  .length >
                              0
                      ? true
                      : false,
                  child: Container(
                    margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                    child: Stack(
                      children: [
                        SizedBox(height: 5),
                        InkWell(
                          child: Container(
                            height: MediaQuery.of(context).size.height * .05,
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: borderColor),
                              color: Colors.transparent,
                            ),
                            child: Stack(
                              children: <Widget>[
                                Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.10,
                                    padding: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? EdgeInsets.only(
                                            top: 10.0,
                                            left: MediaQuery.of(context).size.width *
                                                0.26,
                                            bottom: 10.0)
                                        : EdgeInsets.only(
                                            top: 10.0,
                                            right:
                                                MediaQuery.of(context).size.width *
                                                    0.26,
                                            bottom: 10.0),
                                    child: Text(
                                        widget.retailOrderCategoryItems[j]
                                            .facilityItemGroup,
                                        style: TextStyle(
                                            color: ColorData.toColor(widget.colorCode)))),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              widget.showItemCategory = false;
                              widget.selectedRetailOrderItems =
                                  widget.retailOrderCategoryItems[j];
                              widget.facilityItems =
                                  widget.selectedRetailOrderItems.facilityItems;
                            });
                          },
                        ),
                      ],
                    ),
                  ));
            }));
  }

  Widget getItemList(int facilityId, String retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.facilityItems.length,
            itemBuilder: (context, j) {
              return Container(
                  margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                  child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Stack(
                        children: [
                          SizedBox(height: 5),
                          Container(
                            height: itemCounts[widget
                                            .facilityItems[j].facilityItemId] ==
                                        null ||
                                    itemCounts[widget.facilityItems[j]
                                                .facilityItemId]
                                            .quantity ==
                                        null ||
                                    itemCounts[widget.facilityItems[j]
                                                .facilityItemId]
                                            .quantity ==
                                        0
                                ? MediaQuery.of(context).size.height * .17
                                : MediaQuery.of(context).size.height * .25,
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                              border: Border.all(color: borderColor),
                              color: Colors.transparent,
                            ),
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 10.0,
                                          left: 10.0,
                                          // left: MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //     0.26,
                                          bottom: 10.0)
                                      : EdgeInsets.only(
                                          top: 10.0,
                                          right: 10.0,
                                          // right: MediaQuery.of(context)
                                          //         .size
                                          //         .width *
                                          //     0.26,
                                          bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Flexible(
                                          child: Text(
                                        widget.facilityItems[j]
                                                    .facilityItemName !=
                                                null
                                            ? widget.facilityItems[j]
                                                .facilityItemName
                                            : "Not Found",
                                        style: TextStyle(
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      )),
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.08,
                                  padding: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 30.0, left: 10.0, bottom: 10.0)
                                      : EdgeInsets.only(
                                          top: 30.0, right: 10.0, bottom: 10.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: SingleChildScrollView(
                                              child: getHtml(widget
                                                  .facilityItems[j]
                                                  .description))),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(top: 80, left: 10.0)
                                      : EdgeInsets.only(top: 80, right: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'AED ' +
                                            widget.facilityItems[j].price
                                                .toStringAsFixed(2) +
                                            '  ',
                                        style: TextStyle(
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                      Visibility(
                                          visible: widget.facilityItems[j]
                                                  .isPromotional
                                              ? true
                                              : false,
                                          child: Text(tr("discountable"),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      Styles.reviewTextSize,
                                                  //fontStyle: FontStyle.italic,
                                                  backgroundColor:
                                                      ColorData.toColor(
                                                          widget.colorCode))))

                                      //Image.asset(
                                      //    'assets/images/discount.png'))
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 70,
                                          bottom: 5,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.68,
                                        )
                                      : EdgeInsets.only(
                                          top: 70,
                                          bottom: 5,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.68,
                                        ),
                                  height:
                                      MediaQuery.of(context).size.height * .05,
                                  width:
                                      MediaQuery.of(context).size.width / 3.8,
                                  // decoration: BoxDecoration(
                                  //   border: Border.all(color: borderColor),
                                  //   color: Colors.white,
                                  //   borderRadius: BorderRadius.circular(16),
                                  // ),
                                  child: new ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            ColorData.toColor(widget.colorCode),
                                        side: BorderSide(
                                            width: 1.0,
                                            color: Colors.transparent)),
                                    onPressed: () async {
                                      EnquiryDetailResponse request =
                                          getEnquiry(widget.facilityItems[j]);
                                      BlocProvider.of<FitnessBuyBloc>(context)
                                          .add(FitnessBuyEnquirySaveEvent(
                                              enquiryDetailResponse: request,
                                              facilityItem:
                                                  widget.facilityItems[j]));
                                    },
                                    icon: Icon(Icons.add_shopping_cart),
                                    label: new Text(tr('buy'),
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: ColorData.whiteColor),
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      )));
            }));
  }

  void getTotal() {
    double totalAmt = 0;
    totalItems = 0;
    List<int> selectedItem = []; // new List<int>();
    for (int j = 0; j < widget.retailOrderCategoryItems.length; j++) {
      List<FacilityItems> facilityItems =
          widget.retailOrderCategoryItems[j].facilityItems;
      for (int i = 0; i < facilityItems.length; i++) {
        if (selectedItem.indexOf(facilityItems[i].facilityItemId) == -1) {
          int itemCount = itemCounts[facilityItems[i].facilityItemId] == null
              ? 0
              : itemCounts[facilityItems[i].facilityItemId].quantity;
          if (itemCount > 0) {
            selectedItem.add(facilityItems[i].facilityItemId);
            totalItems++;
          }
          totalAmt = totalAmt + (facilityItems[i].price * itemCount);
        }
      }
    }
    total = totalAmt;
  }

  Widget getHtml(String description) {
    return Html(
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
            fontSize: FontSize(Styles.newTextSize),
            fontWeight: FontWeight.normal,
            color: ColorData.cardTimeAndDateColor,
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
        },
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
        data: (description != null
            ? '<html><body>' + description + '</body></html>'
            : tr('noDataFound')));
  }

  EnquiryDetailResponse getEnquiry(FacilityItems item) {
    EnquiryDetailResponse request = new EnquiryDetailResponse();
    request.facilityId = widget.facilityId;
    request.facilityItemId = item.facilityItemId;
    request.erpCustomerId = SPUtil.getInt(Constants.USER_CUSTOMERID);
    request.firstName = SPUtil.getString(Constants.USER_FIRSTNAME);
    request.lastName = SPUtil.getString(Constants.USER_LASTNAME);
    request.enquiryStatusId = 1;
    request.supportDocuments = [];
    request.totalClass = 0;
    request.balanceClass = 0;
    request.consumedClass = 0;
    request.contacts = [];
    final String formatted = DateFormat('dd-MM-yyyy', 'en_US').format(now);
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
    request.genderId = 1;
    request.comments = "";
    request.isActive = true;
    request.enquiryTypeId = 1;
    request.countryId = 115;
    request.facilityItemName = item.facilityItemName;
    request.faclitiyItemDescription = item.description;
    request.price = item.price;
    request.vatPercentage = 0;
    request.facilityImageName = "";
    request.facilityImageUrl = "";
    request.enquiryDetailId = 0;
    request.rate = item.rate;
    return request;
  }
}
