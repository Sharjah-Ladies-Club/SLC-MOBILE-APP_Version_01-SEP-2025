// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'package:slc/gmcore/model/Meta.dart';
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
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/Retail/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'Retail_Payment.dart';

class RetailPage extends StatelessWidget {
  int facilityId;
  String retailItemSetId;
  int tableNo;
  String colorCode;
  List<FacilityItem> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  RetailPage(
      {this.facilityId,
      this.retailItemSetId,
      this.facilityItems,
      this.itemCounts,
      this.tableNo,
      this.colorCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<RetailBloc>(
              create: (context) => RetailBloc(retailBloc: null)
                ..add(GetItemDetailsEvent(
                    facilityId: facilityId, retailItemSetId: retailItemSetId))
                ..add(GetPaymentTerms(facilityId: facilityId))),
        ],
        child: RetailHomePage(
          facilityId: facilityId,
          retailItemSetId: retailItemSetId,
          facilityItems: facilityItems,
          itemCounts: itemCounts,
          colorCode: colorCode,
        ),
      ),
    );
  }
}

class RetailHomePage extends StatefulWidget {
  int facilityId;
  String retailItemSetId;
  int tableNo;
  String colorCode;
  bool showItemCategory = true;
  List<FacilityItem> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  RetailOrderItemsCategory retailOrderCategoryItems =
      new RetailOrderItemsCategory();
  RetailOrderItems selectedRetailOrderItems = new RetailOrderItems();
  RetailHomePage(
      {this.facilityId,
      this.retailItemSetId,
      this.facilityItems,
      this.itemCounts,
      this.tableNo,
      this.colorCode});
  @override
  _RetailPage createState() {
    return _RetailPage(itemCounts: itemCounts);
  }
}

class _RetailPage extends State<RetailHomePage> {
  static final borderColor = Colors.grey[200];
  var serverTestPath = URLUtils().getImageResultUrl();
  Utils util = new Utils();
  double total = 0;
  int totalItems = 0;
  PaymentTerms paymentTerms = new PaymentTerms();
  //List<FacilityItems> facilityItems = new List<FacilityItems>();
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  DateTime get date => DateTime.now();
  _RetailPage({this.itemCounts});
  @override
  Widget build(BuildContext context) {
    debugPrint("coming inside retail page");
    return BlocListener<RetailBloc, RetailState>(
      listener: (context, state) {
        if (state is LoadRetailItemList) {
          if (itemCounts == null)
            itemCounts = new HashMap<int, FacilityBeachRequest>();
          if (widget.facilityItems.length == 0) {
            setState(() {
              widget.retailOrderCategoryItems = state.retailOrderCategoryItems;
              widget.selectedRetailOrderItems =
                  widget.retailOrderCategoryItems.retailCategoryItems[0];
              widget.facilityItems =
                  widget.selectedRetailOrderItems.facilityItems;
              if (widget.retailOrderCategoryItems != null) {
                widget.facilityId = widget.retailOrderCategoryItems.facilityId;
                widget.colorCode = widget.retailOrderCategoryItems.colorCode;
              }
              getTotal();
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
            widget.selectedRetailOrderItems.menuName == null
                ? tr("shoppingCart")
                : widget.showItemCategory
                    ? widget.selectedRetailOrderItems.facilityName
                    : widget.selectedRetailOrderItems.menuName,
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              if (widget.showItemCategory) {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FacilityDetailsPage(facilityId: widget.facilityId)),
                );
              } else {
                setState(() {
                  widget.showItemCategory = true;
                });
              }
            },
          ),
          actions: <Widget>[],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/beachorder.png"),
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
                            Visibility(
                                visible: widget.showItemCategory,
                                child: getItemCategoryList(
                                    widget.facilityId, widget.retailItemSetId)),
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
                                List<FacilityItem> selectedFacilityItems = [];
                                for (int j = 0;
                                    j <
                                        widget.retailOrderCategoryItems
                                            .retailCategoryItems.length;
                                    j++) {
                                  List<FacilityItem> facilityItemList = widget
                                      .retailOrderCategoryItems
                                      .retailCategoryItems[j]
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
                                    .getDiscountList(widget.facilityId, total);
                                List<BillDiscounts> billDiscounts = [];
                                // new List<BillDiscounts>();
                                if (m.statusCode == 200) {
                                  jsonDecode(m.statusMsg)['response'].forEach(
                                      (f) => billDiscounts
                                          .add(new BillDiscounts.fromJson(f)));
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          new RetailPaymentPage(
                                        facilityItems: selectedFacilityItems,
                                        total: total,
                                        itemCounts: itemCounts,
                                        retailItemSetId: widget.retailItemSetId,
                                        facilityId: widget.facilityId,
                                        tableNo: widget
                                            .selectedRetailOrderItems.tableNo,
                                        colorCode: widget.colorCode,
                                        billDiscounts: billDiscounts,
                                        giftVouchers: vouchers,
                                        paymentTerms: paymentTerms,
                                      ),
                                    ));
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
            itemCount: widget.retailOrderCategoryItems.retailCategoryItems ==
                    null
                ? 0
                : widget.retailOrderCategoryItems.retailCategoryItems.length,
            itemBuilder: (context, j) {
              return Visibility(
                  visible: widget.retailOrderCategoryItems
                                  .retailCategoryItems[j].facilityItems !=
                              null &&
                          widget.retailOrderCategoryItems.retailCategoryItems[j]
                                  .facilityItems.length >
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
                            height: MediaQuery.of(context).size.height * .17,
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
                                          bottomLeft: Radius.circular(8)),
                                      child: Image.network(
                                          serverTestPath +
                                              "UploadDocument/CategoryItemImage/" +
                                              // widget.retailOrderCategoryItems
                                              //     .retailCategoryItems[j].categoryId
                                              //     .toString() +
                                              // "/HQ/" +
                                              widget
                                                  .retailOrderCategoryItems
                                                  .retailCategoryItems[j]
                                                  .categoryImageUrl,
                                          fit: BoxFit.cover),
                                    )),
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
                                        widget.retailOrderCategoryItems
                                            .retailCategoryItems[j].menuName,
                                        style: TextStyle(
                                            color: ColorData.toColor(widget.colorCode)))),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
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
                                                  .retailOrderCategoryItems
                                                  .retailCategoryItems[j]
                                                  .description))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              widget.showItemCategory = false;
                              widget.selectedRetailOrderItems = widget
                                  .retailOrderCategoryItems
                                  .retailCategoryItems[j];
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
                                          bottomLeft: Radius.circular(8)),
                                      child: Image.network(
                                          serverTestPath +
                                              "UploadDocument/FacilityItem/" +
                                              widget.facilityItems[j].imageUrl,
                                          fit: BoxFit.cover),
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
                                                  .facilityItems[j]
                                                  .description))),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? EdgeInsets.only(
                                          top: 80,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26)
                                      : EdgeInsets.only(
                                          top: 80,
                                          right: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.26),
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
                                                  .isDiscountable
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
                                  decoration: BoxDecoration(
                                    border: Border.all(color: borderColor),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(right: 60)
                                            : EdgeInsets.only(left: 60),
                                        child: new IconButton(
                                          icon: new Icon(Icons.delete,
                                              size: 18, color: Colors.grey),
                                          onPressed: () => setState(() {
                                            if (itemCounts[widget
                                                    .facilityItems[j]
                                                    .facilityItemId] ==
                                                null) {
                                              itemCounts[widget.facilityItems[j]
                                                      .facilityItemId] =
                                                  new FacilityBeachRequest();
                                            }
                                            if (itemCounts[widget
                                                        .facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity >
                                                0) {
                                              itemCounts[widget.facilityItems[j]
                                                      .facilityItemId]
                                                  .quantity = itemCounts[widget
                                                          .facilityItems[j]
                                                          .facilityItemId]
                                                      .quantity -
                                                  1;
                                            }
                                            getTotal();
                                          }),
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    4)
                                            : EdgeInsets.only(
                                                right: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    4),
                                        child: VerticalDivider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    2.3,
                                                top: 9)
                                            : EdgeInsets.only(
                                                right: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    2.3,
                                                top: 9),
                                        child: new Text(
                                            itemCounts[widget.facilityItems[j]
                                                        .facilityItemId] ==
                                                    null
                                                ? "0"
                                                : itemCounts[widget
                                                        .facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity
                                                    .toString(),
                                            style:
                                                TextStyle(color: Colors.grey)),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    1.75)
                                            : EdgeInsets.only(
                                                right: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    1.75),
                                        child: VerticalDivider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    1.60)
                                            : EdgeInsets.only(
                                                right: (MediaQuery.of(context)
                                                            .size
                                                            .width /
                                                        3.8) /
                                                    1.60),
                                        child: new IconButton(
                                            icon: new Icon(Icons.add,
                                                color: Colors.grey, size: 18),
                                            onPressed: () => setState(() {
                                                  if (itemCounts[widget
                                                          .facilityItems[j]
                                                          .facilityItemId] ==
                                                      null) {
                                                    itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId] =
                                                        new FacilityBeachRequest();
                                                    itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .quantity = 0;
                                                  }

                                                  itemCounts[widget
                                                          .facilityItems[j]
                                                          .facilityItemId]
                                                      .quantity = itemCounts[widget
                                                              .facilityItems[j]
                                                              .facilityItemId]
                                                          .quantity +
                                                      1;
                                                  getTotal();
                                                })),
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                    visible: false,
                                    /*itemCounts[widget.facilityItems[j]
                                                .facilityItemId] ==
                                            null ||
                                        itemCounts[widget.facilityItems[j].facilityItemId]
                                                .quantity ==
                                            null ||
                                        itemCounts[widget.facilityItems[j]
                                                    .facilityItemId]
                                                .quantity ==
                                            0
                                    ? false
                                    : true,*/
                                    child: Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                top: 70.0, left: 8)
                                            : EdgeInsets.only(
                                                top: 70.0, right: 8),
                                        child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(tr("kitchen_notes"))))),
                                Visibility(
                                    visible: itemCounts[widget.facilityItems[j]
                                                    .facilityItemId] ==
                                                null ||
                                            itemCounts[widget.facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity ==
                                                null ||
                                            itemCounts[widget.facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity ==
                                                0
                                        ? false
                                        : true,
                                    child: Container(
                                      height: 40,
                                      margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .18,
                                          left: 8,
                                          right: 8),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.grey[400]),
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: TextField(
                                          onChanged: (value) {
                                            if (itemCounts[widget
                                                    .facilityItems[j]
                                                    .facilityItemId] ==
                                                null) {
                                              itemCounts[widget.facilityItems[j]
                                                      .facilityItemId] =
                                                  new FacilityBeachRequest();
                                            }
                                            itemCounts[widget.facilityItems[j]
                                                    .facilityItemId]
                                                .comments = value;
                                          },
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily: tr('currFontFamily')),
                                          maxLines: 2,
                                          cursorColor:
                                              ColorData.primaryTextColor,
                                          decoration: new InputDecoration(
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            hintText: "Kitchen Notes",
                                            hintStyle: TextStyle(
                                                color: ColorData
                                                    .primaryTextColor
                                                    .withOpacity(1.0),
                                                fontSize:
                                                    Styles.packageExpandTextSiz,
                                                fontFamily:
                                                    tr('currFontFamily')),
                                            contentPadding: EdgeInsets.only(
                                                left: 15,
                                                bottom: 11,
                                                top: 11,
                                                right: 15),
                                          )),
                                    ))
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
    for (int j = 0;
        j < widget.retailOrderCategoryItems.retailCategoryItems.length;
        j++) {
      List<FacilityItem> facilityItems =
          widget.retailOrderCategoryItems.retailCategoryItems[j].facilityItems;
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
}
