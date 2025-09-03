// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_request.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/healthnbeauty/healthnbeauty.dart';
import 'package:slc/view/retail_cart/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import '../../model/payment_terms_response.dart';
import 'Retail_Cart_Payment.dart';

class RetailCartPage extends StatelessWidget {
  int facilityId;
  int retailItemSetId;
  int tableNo;
  String colorCode;
  List<FacilityItem> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  RetailCartPage(
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
          BlocProvider<RetailCartBloc>(
              create: (context) => RetailCartBloc(retailBloc: null)
                ..add(GetCartItemDetailsEvent(
                    facilityId: facilityId, retailItemSetId: retailItemSetId))
                ..add(GetPaymentTerms(facilityId: facilityId))),
        ],
        child: RetailCartHomePage(
            facilityId: facilityId,
            retailItemSetId: retailItemSetId,
            facilityItems: facilityItems,
            itemCounts: itemCounts,
            colorCode: colorCode),
      ),
    );
  }
}

class RetailCartHomePage extends StatefulWidget {
  int facilityId;
  int retailItemSetId;
  int tableNo;
  int showItem = 1;
  String colorCode = "";
  List<FacilityItem> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  RetailOrderItemsCategory retailOrderCategoryItems =
      new RetailOrderItemsCategory();
  RetailOrderItems selectedRetailOrderItems = new RetailOrderItems();
  int selectedItemIndex = -1;
  List<DeliveryAddress> deliveryAddresses = [];
  List<DeliveryCharges> deliveryCharges = [];
  RetailCartHomePage(
      {this.facilityId,
      this.retailItemSetId,
      this.facilityItems,
      this.itemCounts,
      this.tableNo,
      this.colorCode});
  @override
  _RetailCartPage createState() {
    return _RetailCartPage(itemCounts: itemCounts);
  }
}

class _RetailCartPage extends State<RetailCartHomePage> {
  static final borderColor = Colors.grey[200];
  var serverTestPath = URLUtils().getImageResultUrl();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Utils util = new Utils();
  double total = 0;
  int totalItems = 0;
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  DateTime get date => DateTime.now();
  PaymentTerms paymentTerms = new PaymentTerms();
  _RetailCartPage({this.itemCounts});
  @override
  Widget build(BuildContext context) {
    return BlocListener<RetailCartBloc, RetailCartState>(
      listener: (context, state) {
        if (state is LoadRetailCartItemList) {
          if (itemCounts == null) {
            itemCounts = new HashMap<int, FacilityBeachRequest>();
            if (_scaffoldKey.currentState.hasEndDrawer)
              _scaffoldKey.currentState.openEndDrawer();
          }
          if (widget.facilityItems.length == 0) {
            setState(() {
              widget.retailOrderCategoryItems = state.retailOrderCategoryItems;
              widget.selectedRetailOrderItems =
                  widget.retailOrderCategoryItems.retailCategoryItems[0];
              widget.facilityItems =
                  widget.selectedRetailOrderItems.facilityItems;
              if (widget.facilityItems.length > 0) {
                widget.facilityId = widget.facilityItems[0].facilityId;
              }
              widget.deliveryAddresses = state.deliveryAddresses;
              widget.deliveryCharges = state.deliveryCharges;
              getTotal();
            });
          }
        } else if (state is InvalidQRCode) {
          Navigator.pop(context, true);
          util.customGetSnackBarWithOutActionButton(
              "No Items ", "There are no items to shop", context);
        } else if (state is GetPaymentTermsResult) {
          paymentTerms = state.paymentTerms;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        endDrawer:
            getItemCategoryList(widget.facilityId, widget.retailItemSetId),
        backgroundColor: Color(0xFFF0F8FF),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: Colors.blue[200]),
          title: Text(
            widget.selectedRetailOrderItems.menuName == null
                ? tr("shoppingCart")
                : widget.showItem == 0
                    ? widget.selectedRetailOrderItems.facilityName
                    : widget.selectedRetailOrderItems.menuName,
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.remove_shopping_cart),
            color: Colors.blue[200],
            onPressed: () async {
              if (widget.showItem == 1) {
                FacilityRequest request = FacilityRequest(facilityGroupId: 1);
                Meta m1 =
                    await HomeRepository().getOnlineShopFacilityData(request);
                if (m1.statusCode == 200) {
                  List<FacilityResponse> facilityResponseList = [];

                  jsonDecode(m1.statusMsg)['response'].forEach((f) =>
                      facilityResponseList
                          .add(new FacilityResponse.fromJson(f)));

                  facilityResponseList.sort((a, b) =>
                      a.facilityDisplayOrder.compareTo(b.facilityDisplayOrder));
                  Navigator.pop(context);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        //return Profile(Strings.ProfileInitialState);
                        return Healthnbeauty(
                            facilityResponseList[0].facilityGroupName,
                            facilityResponseList,
                            true);
                      },
                    ),
                  );
                }
              } else {
                setState(() {
                  widget.showItem = 1;
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
                      // image: AssetImage("assets/images/beachorder.png" +
                      //     widget.facilityId.toString() +
                      //     "_bg.png"),
                      image: AssetImage("assets/images/beachorder.png"),
                      fit: BoxFit.cover)),
              child: Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: (total == 0)
                        ? MediaQuery.of(context).size.height * 0.887
                        : MediaQuery.of(context).size.height * 0.80,
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: widget.showItem == 0 ? true : false,
                              child: getItemCategoryList(
                                  widget.facilityId, widget.retailItemSetId)),
                          Visibility(
                              visible: widget.showItem == 1 ? true : false,
                              child: getItemList(
                                  widget.facilityId, widget.retailItemSetId)),
                          Visibility(
                              visible: widget.showItem == 2 ? true : false,
                              child: Container(child: getItemDetail())),
                        ]),
                  ),
                  // SizedBox(height: 20),
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
                                  backgroundColor: MaterialStateProperty.all(
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
                              // color: widget.colorCode == null
                              //     ? Colors.blue[200]
                              //     : ColorData.toColor(widget.colorCode),
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
                                          "AED" + '',
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
                                if (m.statusCode == 200) {
                                  jsonDecode(m.statusMsg)['response'].forEach(
                                      (f) => billDiscounts
                                          .add(new BillDiscounts.fromJson(f)));
                                }
                                // Disable collage
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
                                          new RetailCartPaymentPage(
                                        facilityItems: selectedFacilityItems,
                                        total: total,
                                        itemCounts: itemCounts,
                                        retailItemSetId: widget.retailItemSetId,
                                        facilityId: widget.facilityId,
                                        tableNo: widget
                                            .selectedRetailOrderItems.tableNo,
                                        colorCode: widget.colorCode,
                                        deliveryAddresses:
                                            widget.deliveryAddresses,
                                        deliveryCharges: widget.deliveryCharges,
                                        billDiscounts: billDiscounts,
                                        giftVouchers: vouchers,
                                        paymentTerms: paymentTerms,
                                      ),
                                    ));
                              },
                            ),
                          ))),
                ],
              )),
        ),
      ),
    );
  }

  Widget getItemCategoryList(int facilityId, int retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Drawer(
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/beachorder.png"),
                    fit: BoxFit.cover)),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount:
                    widget.retailOrderCategoryItems.retailCategoryItems == null
                        ? 0
                        : widget.retailOrderCategoryItems.retailCategoryItems
                            .length,
                itemBuilder: (context, j) {
                  return Visibility(
                      visible: widget.retailOrderCategoryItems
                                      .retailCategoryItems[j].facilityItems !=
                                  null &&
                              widget
                                      .retailOrderCategoryItems
                                      .retailCategoryItems[j]
                                      .facilityItems
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
                                height:
                                    MediaQuery.of(context).size.height * .10,
                                width: MediaQuery.of(context).size.width * .75,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(16)),
                                  border: Border.all(color: borderColor),
                                  color: widget
                                              .retailOrderCategoryItems
                                              .retailCategoryItems[j]
                                              .menuName ==
                                          widget
                                              .selectedRetailOrderItems.menuName
                                      ? Colors
                                          .transparent //Color.fromRGBO(239, 243, 248, 1)
                                      : Colors.transparent,
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                        height: MediaQuery.of(context).size.height *
                                            0.08,
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(
                                                top: 15.0,
                                                left: 10,
                                                bottom: 10.0)
                                            : EdgeInsets.only(
                                                top: 15.0,
                                                right: 10,
                                                bottom: 10.0),
                                        child: Text(
                                            widget
                                                .retailOrderCategoryItems
                                                .retailCategoryItems[j]
                                                .menuName,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: widget
                                                            .retailOrderCategoryItems
                                                            .retailCategoryItems[
                                                                j]
                                                            .menuName ==
                                                        widget
                                                            .selectedRetailOrderItems
                                                            .menuName
                                                    ? ColorData.toColor(
                                                        widget.colorCode) //Color.fromRGBO(239, 243, 248, 1)
                                                    : ColorData.primaryTextColor,
                                                fontFamily: tr('currFontFamily'),
                                                fontSize: 16))),
                                  ],
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  widget.showItem = 1;
                                  widget.selectedRetailOrderItems = widget
                                      .retailOrderCategoryItems
                                      .retailCategoryItems[j];
                                  widget.facilityItems = widget
                                      .selectedRetailOrderItems.facilityItems;
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ));
                })));
  }

  Widget getItemList(int facilityId, int retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.facilityItems.length,
            itemBuilder: (context, j) {
              return InkWell(
                child: Container(
                    margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                    child: Stack(
                      children: [
                        SizedBox(height: 5),
                        Container(
                          height: MediaQuery.of(context).size.height * .19,
                          width: MediaQuery.of(context).size.width * .98,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            border: Border.all(color: borderColor),
                            color: Colors.transparent,
                          ),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                  height:
                                      MediaQuery.of(context).size.height * .17,
                                  width:
                                      MediaQuery.of(context).size.width * 0.25,
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
                                            // widget
                                            //     .facilityItems[j].facilityItemId
                                            //     .toString() +
                                            // "/HQ/" +
                                            widget.facilityItems[j].imageUrl,
                                        fit: BoxFit.cover),
                                  )),
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        top: 10.0,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        bottom: 10.0)
                                    : EdgeInsets.only(
                                        top: 10.0,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        bottom: 10.0),
                                child: Row(
                                  children: [
                                    Flexible(
                                        child: Text(
                                      widget.facilityItems[j].facilityItemName,
                                      style: TextStyle(
                                          color: ColorData.toColor(
                                              widget.colorCode),
                                          fontSize: Styles.packageExpandTextSiz,
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
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        bottom: 10.0)
                                    : EdgeInsets.only(
                                        top: 30.0,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.26,
                                        bottom: 2.0),
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
                                        top: Platform.isIOS ? 100 : 90,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.26)
                                    : EdgeInsets.only(
                                        top: Platform.isIOS ? 100 : 90,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.26),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        'AED  ' +
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

                                      // Image.asset(
                                      //     'assets/images/discount.png'))
                                    ]),
                                    Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        tr('Stock') +
                                            ' : ' +
                                            widget.facilityItems[j].stock
                                                .toString(),
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        top: 90,
                                        bottom: 5,
                                        left:
                                            MediaQuery.of(context).size.width *
                                                0.68,
                                      )
                                    : EdgeInsets.only(
                                        top: 90,
                                        bottom: 5,
                                        right:
                                            MediaQuery.of(context).size.width *
                                                0.68,
                                      ),
                                height:
                                    MediaQuery.of(context).size.height * .05,
                                width: MediaQuery.of(context).size.width / 3.8,
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
                                          ? EdgeInsets.only(right: 70)
                                          : EdgeInsets.only(left: 70),
                                      child: new IconButton(
                                          icon: new Icon(Icons.delete,
                                              size: 18, color: Colors.grey),
                                          onPressed: () {
                                            if (itemCounts[widget
                                                    .facilityItems[j]
                                                    .facilityItemId] ==
                                                null) {
                                              itemCounts[widget.facilityItems[j]
                                                      .facilityItemId] =
                                                  new FacilityBeachRequest();
                                              itemCounts[widget.facilityItems[j]
                                                      .facilityItemId]
                                                  .quantity = 0;
                                            }
                                            if (itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .quantity !=
                                                    null &&
                                                itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .quantity >
                                                    0) {
                                              setState(() {
                                                itemCounts[widget
                                                        .facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity = itemCounts[
                                                            widget
                                                                .facilityItems[
                                                                    j]
                                                                .facilityItemId]
                                                        .quantity -
                                                    1;
                                                getTotal();
                                              });
                                            }
                                          }),
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
                                          style: TextStyle(color: Colors.grey)),
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
                                                if (itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .quantity >=
                                                    widget.facilityItems[j]
                                                        .stock) return;
                                                itemCounts[widget
                                                        .facilityItems[j]
                                                        .facilityItemId]
                                                    .quantity = itemCounts[
                                                            widget
                                                                .facilityItems[
                                                                    j]
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
                                          ? EdgeInsets.only(top: 70.0, left: 8)
                                          : EdgeInsets.only(
                                              top: 70.0, right: 8),
                                      child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text("Kitchen Notes")))),
                              Visibility(
                                  visible: false,
                                  //: true,
                                  child: Container(
                                    height: 40,
                                    margin: EdgeInsets.only(
                                        top: 120, left: 8, right: 8),
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.grey[400]),
                                        borderRadius: BorderRadius.circular(4)),
                                    child: TextField(
                                        onChanged: (value) {
                                          if (itemCounts[widget.facilityItems[j]
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
                                        cursorColor: ColorData.primaryTextColor,
                                        decoration: new InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          hintText: "Kitchen Notes",
                                          hintStyle: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily: tr('currFontFamily')),
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
                    )),
                onTap: () {
                  setState(() {
                    widget.selectedItemIndex = j;
                    widget.showItem = 2;
                  });
                },
              );
            }));
  }

  Widget getItemDetail() {
    screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 55);
    carouselHeight = Platform.isIOS
        ? screenHeight * (50.0 / 100.0)
        : screenHeight * (48.0 / 100.0);

    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return widget.selectedItemIndex == -1 ||
            widget.facilityItems == null ||
            widget.facilityItems.length == 0
        ? Text("")
        : Container(
            height: MediaQuery.of(context).size.height * .76,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16)),
              border: Border.all(color: Colors.transparent),
              color: Colors.transparent,
            ),
            child: Column(
              children: <Widget>[
                Container(
                    height: carouselHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            bottomLeft: Radius.circular(8)),
                        color: Colors.transparent),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8)),
                      child: Image.network(
                          serverTestPath +
                              "UploadDocument/FacilityItem/" +
                              widget.facilityItems[widget.selectedItemIndex]
                                  .imageUrl,
                          fit: BoxFit.cover),
                    )),
                Padding(
                  padding: Localizations.localeOf(context).languageCode == "en"
                      ? EdgeInsets.only(top: 10.0, right: 10, left: 10)
                      : EdgeInsets.only(top: 10.0, right: 10, left: 10),
                  child: Row(
                    children: [
                      Flexible(
                          child: Text(
                        widget.facilityItems[widget.selectedItemIndex]
                            .facilityItemName,
                        style: TextStyle(
                            color: ColorData.toColor(widget.colorCode),
                            fontSize: Styles.textSizRegular,
                            fontFamily: tr('currFontFamily')),
                      )),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.18,
                  padding: Localizations.localeOf(context).languageCode == "en"
                      ? EdgeInsets.only(top: 10.0, right: 10, left: 10)
                      : EdgeInsets.only(top: 10.0, right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: SingleChildScrollView(
                              child: getHtml(widget
                                  .facilityItems[widget.selectedItemIndex]
                                  .description))),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.48,
                          padding: Localizations.localeOf(context)
                                      .languageCode ==
                                  "en"
                              ? EdgeInsets.only(top: 20, left: 10, right: 10)
                              : EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Align(
                              alignment: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: Text(
                                'AED  ' +
                                    widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .price
                                        .toString(),
                                style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily')),
                              ))),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.48,
                          padding: Localizations.localeOf(context)
                                      .languageCode ==
                                  "en"
                              ? EdgeInsets.only(top: 20, left: 10, right: 10)
                              : EdgeInsets.only(top: 10, left: 10, right: 10),
                          child: Align(
                              alignment: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Text(
                                tr('Stock') +
                                    ': ' +
                                    widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .stock
                                        .toString(),
                                style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily')),
                              )))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 0,
                    bottom: 5,
                  ),
                  height: MediaQuery.of(context).size.height * .05,
                  width: MediaQuery.of(context).size.width / 3.8,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(right: 80)
                                : EdgeInsets.only(left: 80),
                        child: new IconButton(
                          icon: new Icon(Icons.delete,
                              size: 18, color: Colors.grey),
                          onPressed: () => setState(() {
                            if (itemCounts[widget
                                    .facilityItems[widget.selectedItemIndex]
                                    .facilityItemId] ==
                                null) {
                              itemCounts[widget
                                  .facilityItems[widget.selectedItemIndex]
                                  .facilityItemId] = new FacilityBeachRequest();
                              itemCounts[widget
                                      .facilityItems[widget.selectedItemIndex]
                                      .facilityItemId]
                                  .quantity = 0;
                            }
                            if (itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity >
                                0) {
                              itemCounts[widget
                                      .facilityItems[widget.selectedItemIndex]
                                      .facilityItemId]
                                  .quantity = itemCounts[widget
                                          .facilityItems[
                                              widget.selectedItemIndex]
                                          .facilityItemId]
                                      .quantity -
                                  1;
                            }
                            getTotal();
                          }),
                        ),
                      ),
                      Padding(
                        padding: Localizations.localeOf(context).languageCode ==
                                "en"
                            ? EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        4)
                            : EdgeInsets.only(
                                right:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        4),
                        child: VerticalDivider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: Localizations.localeOf(context).languageCode ==
                                "en"
                            ? EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        2.3,
                                top: 9)
                            : EdgeInsets.only(
                                right:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        2.3,
                                top: 9),
                        child: new Text(
                            itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId] ==
                                    null
                                ? "0"
                                : itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity
                                    .toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                      Padding(
                        padding: Localizations.localeOf(context).languageCode ==
                                "en"
                            ? EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        1.75)
                            : EdgeInsets.only(
                                right:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        1.75),
                        child: VerticalDivider(
                          color: Colors.grey,
                        ),
                      ),
                      Padding(
                        padding: Localizations.localeOf(context).languageCode ==
                                "en"
                            ? EdgeInsets.only(
                                left:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        1.60)
                            : EdgeInsets.only(
                                right:
                                    (MediaQuery.of(context).size.width / 3.8) /
                                        1.60),
                        child: new IconButton(
                            icon: new Icon(Icons.add,
                                color: Colors.grey, size: 18),
                            onPressed: () {
                              if (itemCounts[widget
                                      .facilityItems[widget.selectedItemIndex]
                                      .facilityItemId] ==
                                  null) {
                                itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId] =
                                    new FacilityBeachRequest();
                                itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity = 0;
                              }
                              if (itemCounts[widget
                                          .facilityItems[
                                              widget.selectedItemIndex]
                                          .facilityItemId]
                                      .quantity >=
                                  widget.facilityItems[widget.selectedItemIndex]
                                      .stock) return;
                              setState(() {
                                itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity = itemCounts[widget
                                            .facilityItems[
                                                widget.selectedItemIndex]
                                            .facilityItemId]
                                        .quantity +
                                    1;
                                getTotal();
                              });
                            }),
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
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(top: 70.0, left: 8)
                                : EdgeInsets.only(top: 70.0, right: 8),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text("Kitchen Notes")))),
                Visibility(
                    visible:
                        /*itemCounts[widget
                                    .facilityItems[widget.selectedItemIndex]
                                    .facilityItemId] ==
                                null ||
                            itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity ==
                                null ||
                            itemCounts[widget
                                        .facilityItems[widget.selectedItemIndex]
                                        .facilityItemId]
                                    .quantity ==
                                0
                        ? */
                        false,
                    //: true,
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.only(top: 120, left: 8, right: 8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[400]),
                          borderRadius: BorderRadius.circular(4)),
                      child: TextField(
                          onChanged: (value) {
                            if (itemCounts[widget
                                    .facilityItems[widget.selectedItemIndex]
                                    .facilityItemId] ==
                                null) {
                              itemCounts[widget
                                  .facilityItems[widget.selectedItemIndex]
                                  .facilityItemId] = new FacilityBeachRequest();
                            }
                            itemCounts[widget
                                    .facilityItems[widget.selectedItemIndex]
                                    .facilityItemId]
                                .comments = value;
                          },
                          style: TextStyle(
                              color:
                                  ColorData.primaryTextColor.withOpacity(1.0),
                              fontSize: Styles.packageExpandTextSiz,
                              fontFamily: tr('currFontFamily')),
                          maxLines: 2,
                          cursorColor: ColorData.primaryTextColor,
                          decoration: new InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Kitchen Notes",
                            hintStyle: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.packageExpandTextSiz,
                                fontFamily: tr('currFontFamily')),
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                          )),
                    ))
              ],
            ),
          );
  }

  void getTotal() {
    double totalAmt = 0;
    totalItems = 0;
    for (int j = 0;
        j < widget.retailOrderCategoryItems.retailCategoryItems.length;
        j++) {
      List<FacilityItem> facilityItems =
          widget.retailOrderCategoryItems.retailCategoryItems[j].facilityItems;
      for (int i = 0; i < facilityItems.length; i++) {
        int itemCount = itemCounts[facilityItems[i].facilityItemId] == null
            ? 0
            : itemCounts[facilityItems[i].facilityItemId].quantity;
        if (itemCount != null && itemCount > 0) {
          totalItems++;
        }
        totalAmt = totalAmt + (facilityItems[i].price * itemCount);
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
            // fontSize: FontSize(Styles.reviewTextSize),
            fontFamily: tr('currFontFamilyEnglishOnly'),
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
        },
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
        data: description != null
            ? '<html><body>' + description + '</body></html>'
            : tr('noDataFound'));
    // data: (description != null ? description : tr('noDataFound')));
  }
}
