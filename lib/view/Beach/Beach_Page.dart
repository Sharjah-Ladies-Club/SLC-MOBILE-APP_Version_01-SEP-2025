// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/view/Beach/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/model/payment_terms_response.dart';

import 'Beach_Payment.dart';

class BeachPage extends StatelessWidget {
  int facilityId;
  int facilityItemGroupId;
  List<int> SelectedItems = [];
  List<FacilityItem> facilityItems = new List<FacilityItem>();
  HashMap<int, int> itemCounts = new HashMap<int, int>();
  BeachPage(
      {this.facilityId,
      this.facilityItemGroupId,
      this.facilityItems,
      this.itemCounts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<BeachBloc>(
              create: (context) => BeachBloc()
                ..add(GetItemDetailsEvent(
                    facilityId: facilityId,
                    facilityItemGroupId: facilityItemGroupId))
                ..add(GetPaymentTerms(facilityId: facilityId))),
        ],
        child: BeachHomePage(
            facilityId: facilityId,
            facilityItemGroupId: facilityItemGroupId,
            facilityItems: facilityItems,
            itemCounts: itemCounts),
      ),
    );
  }
}

class BeachHomePage extends StatefulWidget {
  final int facilityId;
  final int facilityItemGroupId;
  List<FacilityItem> facilityItems = new List<FacilityItem>();
  HashMap<int, int> itemCounts = new HashMap<int, int>();

  BeachHomePage(
      {this.facilityId,
      this.facilityItemGroupId,
      this.facilityItems,
      this.itemCounts});

  @override
  _BeachPage createState() {
    return _BeachPage(itemCounts: itemCounts);
  }
}

class _BeachPage extends State<BeachHomePage> {
  static final borderColor = Colors.grey[200];
  final String formatted =
      DateFormat('dd-MM-yyyy', 'en_US').format(DateTime.now());
  bool onPressedTimer = true;
  PaymentTerms terms;

  double total = 0;
  // List<FacilityItems> facilityItems = new List<FacilityItems>();
  HashMap<int, int> itemCounts = new HashMap<int, int>();
  DateTime get date => DateTime.now();
  _BeachPage({this.itemCounts});
  Widget build(BuildContext context) {
    debugPrint("coming inside beach page");
    return BlocListener<BeachBloc, BeachState>(
      listener: (context, state) {
        if (state is LoadBeachItemList) {
          if (itemCounts == null) itemCounts = new HashMap<int, int>();
          debugPrint("coming inside beach page" +
              widget.facilityItems.length.toString());
          if (widget.facilityItems.length == 0) {
            setState(() {
              widget.facilityItems = state.facilityItems;
            });
          } else {
            setState(() {
              getTotal();
            });
          }
        }
        if (state is GetPaymentTermsResult) {
          setState(() {
            terms = state.paymentTerms;
          });
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
            'Beach Pass',
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityDetailsPage(
                          facilityId: widget.facilityId,
                        )),
              );
            },
          ),
          actions: <Widget>[],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              Container(
                // margin: EdgeInsets.only(left: 1),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      child: Image.asset('assets/images/beach_pass.png',
                          height: MediaQuery.of(context).size.height * 0.33,
                          width: MediaQuery.of(context).size.width * 0.99,
                          fit: BoxFit.fill),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.22,
                          right: 20),
                      child: Row(
                        mainAxisAlignment:
                            Localizations.localeOf(context).languageCode == "en"
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Text(
                            Localizations.localeOf(context).languageCode == "en"
                                ? 'Date : \t' + formatted
                                : formatted + ' : Date ',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.250,
                          right: 20),
                      child: Row(
                        mainAxisAlignment:
                            Localizations.localeOf(context).languageCode == "en"
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('EEEE', 'en_US').format(date),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr('currFontFamily')),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.28,
                          bottom: 15,
                        ),
                        child: Row(
                            mainAxisAlignment:
                                Localizations.localeOf(context).languageCode ==
                                        "en"
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  // padding: const EdgeInsets.only(
                                  //     top: 5.0, bottom: 5, right: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.orange[400],
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(13.0),
                                      bottomLeft: Radius.circular(13.0),
                                    ),
                                  ),
                                  child: (widget.facilityItems != null &&
                                          widget.facilityItems.length > 0 &&
                                          widget.facilityItems[0].isHoliday)
                                      ? Text(
                                          tr(
                                              "holiday"), //     textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14))
                                      : (date.weekday != DateTime.friday &&
                                              date.weekday !=
                                                  DateTime.saturday &&
                                              date.weekday != DateTime.sunday)
                                          ? Text(
                                              tr(
                                                  "weekDay"), //     textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14))
                                          : Text(
                                              tr(
                                                  "weekEnd"), //     textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14))),
                            ])),
                  ],
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  // margin: EdgeInsets.only(
                  //     top: MediaQuery.of(context).size.height * 0.40),
                  child: Row(children: [
                    getItemList(widget.facilityId, widget.facilityItemGroupId),
                  ])),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.80,
                    margin: EdgeInsets.only(right: 16, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                child: Text(tr("Payable_Amount"),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')))),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                                // margin: EdgeInsets.only(top: 8),
                                child: Row(
                              children: [
                                Text(
                                  "AED  ",
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.textSiz,
                                      fontFamily: tr('currFontFamily')),
                                ),
                                Text(
                                  " " +
                                      double.parse(total.toStringAsFixed(2),
                                          (e) {
                                        return 0;
                                      }).toStringAsFixed(2),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
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
              SizedBox(height: 10),
              total != 0
                  ? Container(
                      width: MediaQuery.of(context).size.width - 60,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: ElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Text(tr('proceed_to_pay'),
                                  style: EventPeopleListPageStyle
                                      .eventPeopleListPageBtnTextStyleWithAr(
                                          context)),
                            ),
                          ],
                        ),
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            )))),
                        // shape: new RoundedRectangleBorder(
                        //   borderRadius: new BorderRadius.circular(8),
                        // ),
                        onPressed: onPressedTimer == true
                            ? () async {
                                onPressedTimer = false;
                                Timer(Duration(seconds: 45), () {
                                  onPressedTimer = true;
                                });
                                setState(() {});

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
                                          new BeachPaymentPage(
                                        facilityItems: widget.facilityItems,
                                        total: total,
                                        itemCounts: itemCounts,
                                        facilityItemGroupId:
                                            widget.facilityItemGroupId,
                                        facilityId: widget.facilityId,
                                        billDiscounts: billDiscounts,
                                        giftVouchers: vouchers,
                                        terms: terms,
                                      ),
                                    ));
                              }
                            : null,
                        // textColor: Colors.white,
                        // color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Container(),
            ],
          )),
        ),
      ),
    );
  }

  Widget getItemList(int facilityId, int facilityItemGroupId) {
    debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.facilityItems.length,
            itemBuilder: (context, j) {
              return Container(
                  margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                  child: Stack(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        height: MediaQuery.of(context).size.height * .12,
                        width: MediaQuery.of(context).size.width * .98,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: borderColor),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? EdgeInsets.only(
                                      top: 10.0, left: 10.0, bottom: 10.0)
                                  : EdgeInsets.only(
                                      top: 10.0, right: 10.0, bottom: 10.0),
                              child: Row(
                                children: [
                                  Flexible(
                                      child: Text(
                                    widget.facilityItems[j].facilityItemName,
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
                              margin: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? const EdgeInsets.only(top: 40, left: 10)
                                  : const EdgeInsets.only(top: 40, right: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'AED ' +
                                        widget.facilityItems[j].price
                                            .toString() +
                                        '  ',
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.packageExpandTextSiz,
                                        fontFamily: tr('currFontFamily')),
                                  ),
                                  Visibility(
                                      visible:
                                          widget.facilityItems[j].isDiscountable
                                              ? true
                                              : false,
                                      child: Text(tr("discountable"),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: Styles.reviewTextSize,
                                              //fontStyle: FontStyle.italic,
                                              backgroundColor:
                                                  ColorData.toColor("65B0C7"))))

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
                                      top: 28,
                                      bottom: 5,
                                      left: MediaQuery.of(context).size.width *
                                          0.68,
                                    )
                                  : EdgeInsets.only(
                                      top: 28,
                                      bottom: 5,
                                      right: MediaQuery.of(context).size.width *
                                          0.68,
                                    ),
                              height: MediaQuery.of(context).size.height * .05,
                              width: MediaQuery.of(context).size.width * 0.26,
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      debugPrint(
                                          "QQQQQQQQQQQQQQQQQQQQ1111111111111111111");
                                      if (itemCounts[widget.facilityItems[j]
                                              .facilityItemId] ==
                                          null) {
                                        itemCounts[widget.facilityItems[j]
                                            .facilityItemId] = 0;
                                      }

                                      if (itemCounts[widget.facilityItems[j]
                                              .facilityItemId] >
                                          0) {
                                        itemCounts[widget.facilityItems[j]
                                            .facilityItemId] = itemCounts[widget
                                                .facilityItems[j]
                                                .facilityItemId] -
                                            1;
                                      }
                                      getTotal();
                                      setState(() {});
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .05,
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        border: Border(
                                            right: BorderSide(
                                          color: Colors.grey,
                                        )),
                                      ),
                                      child: Icon(Icons.delete,
                                          size: 18, color: Colors.grey),
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                    width: MediaQuery.of(context).size.width *
                                        0.08,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border(
                                          right: BorderSide(
                                        color: Colors.grey,
                                      )),
                                    ),
                                    child: Text(
                                      itemCounts[widget.facilityItems[j]
                                                  .facilityItemId] ==
                                              null
                                          ? "0"
                                          : itemCounts[widget.facilityItems[j]
                                                  .facilityItemId]
                                              .toString(),
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      if (itemCounts[widget.facilityItems[j]
                                              .facilityItemId] ==
                                          null) {
                                        itemCounts[widget.facilityItems[j]
                                            .facilityItemId] = 0;
                                      }

                                      itemCounts[widget.facilityItems[j]
                                          .facilityItemId] = itemCounts[widget
                                              .facilityItems[j]
                                              .facilityItemId] +
                                          1;
                                      getTotal();
                                      setState(() {});
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .05,
                                      width: MediaQuery.of(context).size.width *
                                          0.08,
                                      alignment: Alignment.center,
                                      child: Icon(Icons.add,
                                          size: 18, color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                              // child: Stack(
                              //   children: [
                              //     Padding(
                              //       padding: Localizations.localeOf(context)
                              //                   .languageCode ==
                              //               "en"
                              //           ? EdgeInsets.only(right: 80)
                              //           : EdgeInsets.only(left: 80),
                              //       child: Container(
                              //         color: Colors.red,
                              //         child: new IconButton(
                              //           icon: new Icon(Icons.delete,
                              //               size: 18, color: Colors.grey),
                              //           onPressed: () => setState(() {
                              //             debugPrint(
                              //                 "QQQQQQQQQQQQQQQQQQQQ1111111111111111111");
                              //             if (itemCounts[widget.facilityItems[j]
                              //                     .facilityItemId] ==
                              //                 null) {
                              //               itemCounts[widget.facilityItems[j]
                              //                   .facilityItemId] = 0;
                              //             }
                              //
                              //             itemCounts[widget.facilityItems[j]
                              //                 .facilityItemId] = itemCounts[
                              //                     widget.facilityItems[j]
                              //                         .facilityItemId] -
                              //                 1;
                              //             getTotal();
                              //             debugPrint(
                              //                 "QQQQQQQQQQQQQQQQQQQQ2222222222222222222222222");
                              //             // if (itemCounts[widget.facilityItems[j]
                              //             //         .facilityItemId] ==
                              //             //     null) {
                              //             //   itemCounts[widget.facilityItems[j]
                              //             //       .facilityItemId] = 0;
                              //             // }
                              //             // if (itemCounts[widget.facilityItems[j]
                              //             //         .facilityItemId] >
                              //             //     0) {
                              //             //   itemCounts[widget.facilityItems[j]
                              //             //       .facilityItemId] = itemCounts[
                              //             //           widget.facilityItems[j]
                              //             //               .facilityItemId] -
                              //             //       1;
                              //             // }
                              //             // getTotal();
                              //           }),
                              //         ),
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: Localizations.localeOf(context)
                              //                   .languageCode ==
                              //               "en"
                              //           ? EdgeInsets.only(
                              //               left: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   4)
                              //           : EdgeInsets.only(
                              //               right: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   4),
                              //       child: VerticalDivider(
                              //         color: Colors.grey,
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: Localizations.localeOf(context)
                              //                   .languageCode ==
                              //               "en"
                              //           ? EdgeInsets.only(
                              //               left: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   2.3,
                              //               top: 9)
                              //           : EdgeInsets.only(
                              //               right: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   2.3,
                              //               top: 9),
                              //       child: new Text(
                              //           itemCounts[widget.facilityItems[j]
                              //                       .facilityItemId] ==
                              //                   null
                              //               ? "0"
                              //               : itemCounts[widget.facilityItems[j]
                              //                       .facilityItemId]
                              //                   .toString(),
                              //           style: TextStyle(color: Colors.grey)),
                              //     ),
                              //     Padding(
                              //       padding: Localizations.localeOf(context)
                              //                   .languageCode ==
                              //               "en"
                              //           ? EdgeInsets.only(
                              //               left: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   1.75)
                              //           : EdgeInsets.only(
                              //               right: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   1.75),
                              //       child: VerticalDivider(
                              //         color: Colors.grey,
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: Localizations.localeOf(context)
                              //                   .languageCode ==
                              //               "en"
                              //           ? EdgeInsets.only(
                              //               left: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   1.60)
                              //           : EdgeInsets.only(
                              //               right: (MediaQuery.of(context)
                              //                           .size
                              //                           .width /
                              //                       3.8) /
                              //                   1.60),
                              //       child: new IconButton(
                              //           icon: new Icon(Icons.add,
                              //               color: Colors.grey, size: 18),
                              //           onPressed: () => setState(() {
                              //                 if (itemCounts[widget
                              //                         .facilityItems[j]
                              //                         .facilityItemId] ==
                              //                     null) {
                              //                   itemCounts[widget
                              //                       .facilityItems[j]
                              //                       .facilityItemId] = 0;
                              //                 }
                              //
                              //                 itemCounts[widget.facilityItems[j]
                              //                     .facilityItemId] = itemCounts[
                              //                         widget.facilityItems[j]
                              //                             .facilityItemId] +
                              //                     1;
                              //                 getTotal();
                              //               })),
                              //     ),
                              //   ],
                              // ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ));
            }));
  }

  void getTotal() {
    double totalAmt = 0;
    for (int i = 0; i < widget.facilityItems.length; i++) {
      int itemCount = itemCounts[widget.facilityItems[i].facilityItemId] == null
          ? 0
          : itemCounts[widget.facilityItems[i].facilityItemId];
      totalAmt = totalAmt + (widget.facilityItems[i].price * itemCount);
    }
    total = totalAmt;
  }
}
