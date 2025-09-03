// ignore_for_file: must_be_immutable

import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/partyhall_response.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/utils/constant.dart';

class PartyHallPayment extends StatefulWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  PartyHallResponse partyHallDetail;
  double total = 0;
  double taxableAmt = 0;
  double taxAmt = 0;
  double discountAmt = 0;
  bool saveInProgress = false;
  BillDiscounts discount = new BillDiscounts();
  List<BillDiscounts> billDiscounts = [];

  PartyHallPayment(
      {Key key,
      this.facilityItem,
      this.facilityDetail,
      this.partyHallDetail,
      this.billDiscounts})
      : super(key: key);

  @override
  _PartyHallPaymentPage createState() => _PartyHallPaymentPage(
      facilityItem: facilityItem,
      facilityDetail: facilityDetail,
      partyHallDetail: partyHallDetail,
      billDiscounts: billDiscounts);
}

class _PartyHallPaymentPage extends State<PartyHallPayment> {
  bool valuefirst = false;
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  PartyHallResponse partyHallDetail;
  UserProfileInfo userProfileInfo;
  Utils util = new Utils();
  bool saveInProgress = false;
  List<BillDiscounts> billDiscounts = [];
  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);
  // FlutterPay flutterPay = FlutterPay();
  ProgressBarHandler _handler;

  _PartyHallPaymentPage(
      {this.facilityItem,
      this.facilityDetail,
      this.partyHallDetail,
      this.userProfileInfo,
      this.billDiscounts});
  @override
  Widget build(BuildContext context) {
    getTotal();
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      appBar: AppBar(
        shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30))),
        automaticallyImplyLeading: true,
        title: Text(
          tr('payment'),
          style: TextStyle(color: Colors.blue[200]),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.blue[200],
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FacilityDetailsPage(
                      facilityId: widget.facilityDetail.facilityId)),
            );
          },
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              Row(children: [getPartyHallDetails()]),
              widget.facilityDetail.facilityId == Constants.FacilityMembership
                  ? SizedBox(height: 5)
                  : Visibility(visible: false, child: Text("")),
              // widget.facilityDetail.facilityId == Constants.FacilityMembership
              //     ? Container(
              //     margin: EdgeInsets.only(top: 5, left: 8, right: 8),
              //     child: Stack(
              //       children: [
              //         SizedBox(height: 5),
              //         Container(
              //           height: MediaQuery.of(context).size.height * .12,
              //           width: MediaQuery.of(context).size.width * .98,
              //           decoration: BoxDecoration(
              //             borderRadius:
              //             BorderRadius.all(Radius.circular(8)),
              //             border: Border.all(color: Colors.grey[200]),
              //             color: Colors.white,
              //           ),
              //           child: Stack(
              //             children: <Widget>[
              //               Padding(
              //                 padding: Localizations.localeOf(context)
              //                     .languageCode ==
              //                     "en"
              //                     ? EdgeInsets.only(
              //                     top: 10.0, left: 10.0, bottom: 10.0)
              //                     : EdgeInsets.only(
              //                     top: 10.0, right: 10.0, bottom: 10.0),
              //                 child: Row(
              //                   children: [
              //                     Flexible(
              //                         child: Text(
              //                           widget.userProfileInfo
              //                               .facilityItemName ==
              //                               null
              //                               ? ""
              //                               : widget.userProfileInfo
              //                               .facilityItemName,
              //                           style: TextStyle(
              //                               color: ColorData.primaryTextColor
              //                                   .withOpacity(1.0),
              //                               fontSize:
              //                               Styles.packageExpandTextSiz,
              //                               fontFamily: tr('currFontFamily')),
              //                         )),
              //                   ],
              //                 ),
              //               ),
              //               Container(
              //                 margin: Localizations.localeOf(context)
              //                     .languageCode ==
              //                     "en"
              //                     ? const EdgeInsets.only(top: 40, left: 10)
              //                     : const EdgeInsets.only(
              //                     top: 40, right: 10),
              //                 child: Row(
              //                   children: [
              //                     Text(
              //                         'AED ' +
              //                             (widget.userProfileInfo.price ==
              //                                 null
              //                                 ? ""
              //                                 : widget.userProfileInfo.price
              //                                 .toStringAsFixed(2)),
              //                         style: TextStyle(
              //                             color: ColorData.primaryTextColor
              //                                 .withOpacity(1.0),
              //                             fontSize:
              //                             Styles.packageExpandTextSiz,
              //                             fontFamily:
              //                             tr('currFontFamily'))),
              //                   ],
              //                 ),
              //               ),
              //             ],
              //           ),
              //         )
              //       ],
              //     ))
              //     : Visibility(visible: false, child: Text("")),
              // widget.facilityDetail.facilityId == Constants.FacilityMembership
              //     ? Row(children: [
              //   getMembershipItemList(widget.facilityDetail.facilityId, 0)
              // ])
              //     : Visibility(visible: false, child: Text("")),
              SizedBox(height: 10),
              Visibility(
                  visible: widget.billDiscounts.length > 0 ? false : false,
                  child: Container(
                      width: MediaQuery.of(context).size.width * .96,
                      margin: EdgeInsets.only(top: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border.all(color: Colors.grey[200]),
                        color: Colors.white,
                      ),
                      child: Column(children: <Widget>[
                        ListTile(
                          leading: Icon(Icons.local_offer_outlined,
                              color: ColorData.toColor(
                                  widget.facilityDetail.colorCode)),
                          title: Text(
                              widget.discount != null &&
                                      widget.discount.discountName != null
                                  ? widget.discount.discountName
                                  : 'Save with ' +
                                      billDiscounts.length.toString() +
                                      ' Offers',
                              style: TextStyle(
                                  color: ColorData.toColor(
                                      widget.facilityDetail.colorCode),
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                          trailing: new OutlinedButton(
                            onPressed: () {
                              displayDiscountModalBottomSheet(context);
                            },
                            child: new Text(
                              "View",
                              style: TextStyle(
                                  color: ColorData.toColor(
                                      widget.facilityDetail.colorCode)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ]))),
              SizedBox(height: 5),
              Container(
                margin: const EdgeInsets.only(top: 0, left: 8, right: 8),
                height: 180,
                width: MediaQuery.of(context).size.width * .98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border.all(color: Colors.grey[200]),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20, left: 25),
                        child: Row(
                          children: [
                            Text(tr("accept_proceed"),
                                style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.textSizRegular,
                                    fontFamily: tr('currFontFamily'))),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 25),
                        child: Row(
                          children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(tr("payment_terms_conditions"),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.packageExpandTextSiz,
                                        fontFamily: tr('currFontFamily')))),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 8, left: 8),
                        child: Row(
                          children: [
                            Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.grey[400]),
                                child: Checkbox(
                                  checkColor: Colors.greenAccent,
                                  activeColor: Colors.blue,
                                  value: this.valuefirst,
                                  onChanged: (bool value) {
                                    setState(() {
                                      this.valuefirst = value;
                                    });
                                  },
                                )),
                            Text(
                              tr("i_accept"),
                              style: TextStyle(
                                  color: ColorData.primaryTextColor
                                      .withOpacity(1.0),
                                  fontSize: Styles.loginBtnFontSize,
                                  fontFamily: tr('currFontFamily')),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: Localizations.localeOf(context).languageCode == "en"
                        ? EdgeInsets.only(right: 20)
                        : EdgeInsets.only(left: 20),
                    child: Column(
                      children: [
                        Visibility(
                            visible: false,
                            child: Container(
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
                                              alignment: Alignment.centerRight,
                                              child: Text(tr("original_Amount"),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                " " +
                                                    double.tryParse(widget
                                                                .taxableAmt
                                                                .toStringAsFixed(
                                                                    2) ??
                                                            0)
                                                        .toStringAsFixed(2),
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
                            )),
                        Visibility(
                            visible: false,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                " " +
                                                    double.tryParse(widget
                                                                .taxAmt
                                                                .toStringAsFixed(
                                                                    2) ??
                                                            0)
                                                        .toStringAsFixed(2),
                                                // double.parse(
                                                //     widget.taxAmt
                                                //         .toStringAsFixed(2),
                                                //     (e) {
                                                //   return 0;
                                                // }).toStringAsFixed(2),
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
                            )),
                        Visibility(
                            visible: widget.billDiscounts != null &&
                                    widget.billDiscounts.length > 0
                                ? false
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.35,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(tr("Discount_amount"),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
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
                                                " " +
                                                    double.tryParse(widget
                                                                .discountAmt
                                                                .toStringAsFixed(
                                                                    2) ??
                                                            0)
                                                        .toStringAsFixed(2),
                                                // double.parse(
                                                //     widget.discountAmt
                                                //         .toStringAsFixed(2),
                                                //     (e) {
                                                //   return 0;
                                                // }).toStringAsFixed(2),
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
                          width: MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
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
                                                  fontFamily:
                                                      tr('currFontFamily'))))),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      width: MediaQuery.of(context).size.width *
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
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            " " +
                                                double.tryParse(widget.total
                                                            .toStringAsFixed(
                                                                2) ??
                                                        0)
                                                    .toStringAsFixed(2),
                                            // double.parse(
                                            //     widget.total
                                            //         .toStringAsFixed(2),
                                            //     (e) {
                                            //   return 0;
                                            // }).toStringAsFixed(2),
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
                          margin:
                              Localizations.localeOf(context).languageCode ==
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
                ],
              ),
              (valuefirst != false && widget.total != 0)
                  ? Container(
                      width: MediaQuery.of(context).size.width - 60,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                      child: Column(children: [
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              )))),
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
                          // shape: new RoundedRectangleBorder(
                          //   borderRadius: new BorderRadius.circular(8),
                          // ),
                          onPressed: () async {
                            Meta m;
                            List<FacilityBeachRequest> facilityItems = [];
                            if (!widget.saveInProgress) {
                              widget.saveInProgress = true;
                              _handler.show();

                              m = await FacilityDetailRepository()
                                  .getPartyHallPaymentOrderRequest(
                                      widget.facilityDetail.facilityId,
                                      widget.partyHallDetail.partyHallBookingId,
                                      facilityItems,
                                      0,
                                      discountAmt: widget.discountAmt,
                                      billDiscount: widget.discount,
                                      tipsAmount: 0,
                                      grossAmount: widget.taxableAmt,
                                      taxAmount: widget.taxAmt,
                                      netAmount: widget.total,
                                      deliveryAmount: 0,
                                      deliveryTaxAmount: 0);
                              if (m.statusCode == 200) {
                                // ignore: unnecessary_statements
                                widget.saveInProgress = false;
                                _handler.dismiss();
                                util.customGetSnackBarWithOutActionButton(
                                    tr('success_caps'),
                                    tr('sent_payment_link'),
                                    context);
                              } else {
                                _handler.dismiss();
                                widget.saveInProgress = false;
                                util.customGetSnackBarWithOutActionButton(
                                    tr('error_caps'), m.statusMsg, context);
                              }
                            }
                          },
                          // textColor: Colors.white,
                          // color: Theme.of(context).primaryColor,
                        )
                      ]),
                    )
                  : Container()
            ],
          ),
        ),
        progressBar
      ]),
    );
  }

  Widget getPartyHallDetails() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        height: MediaQuery.of(context).size.height * 0.205,
        width: MediaQuery.of(context).size.width * 0.96,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey[200],
          ),
          borderRadius: BorderRadius.circular(8),
        ),

        //     Container(
        //   margin: EdgeInsets.only(left: 8, right: 8),
        //   height: MediaQuery.of(context).size.height * 0.205,
        //   width: MediaQuery.of(context).size.width * 0.96,
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       width: 1,
        //       color: Colors.grey[200],
        //     ),
        //     borderRadius: BorderRadius.circular(8),
        //     color: Colors.white,
        //   ),
        //   child: Stack(
        //     children: <Widget>[
        //       Container(
        //         margin: EdgeInsets.only(left: 20, top: 20),
        //         child: Text(widget.facilityDetail.facilityGroupName,
        //             style: TextStyle(color: Colors.black54)),
        //       ),
        //       Container(
        //         margin: EdgeInsets.only(left: 20, top: 40),
        //         child: Text(widget.facilityItem.facilityItemName,
        //             style: TextStyle(fontWeight: FontWeight.bold)),
        //       ),
        //       Container(
        //         margin: EdgeInsets.only(left: 20, top: 60),
        //         child: getHtml(widget.facilityItem.description),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.only(left: 180, top: 58, bottom: 20),
        //         child: VerticalDivider(color: Colors.grey[900]),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.only(left: 220, top: 80, bottom: 20),
        //         child: Text(
        //           'AED ' + widget.facilityItem.price.toStringAsFixed(2),
        //           style: TextStyle(fontWeight: FontWeight.bold),
        //         ),
        //       ),
        //     ],
        //   ),
        // )
        child: Stack(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top: 10, left: 5),
                height: MediaQuery.of(context).size.height * 0.18,
                width: MediaQuery.of(context).size.width * 0.30,
                color: Colors.white,
                child: Image.asset(
                    widget.facilityDetail.facilityId ==
                                Constants.FacilityLeisure ||
                            widget.facilityDetail.facilityId ==
                                Constants.FacilityOlympicPool
                        ? 'assets/images/10_11_12_logo.png'
                        : 'assets/images/' +
                            widget.facilityDetail.facilityId.toString() +
                            '_logo.png',
                    height: MediaQuery.of(context).size.height * 0.18,
                    width: MediaQuery.of(context).size.width * 0.18,
                    fit: BoxFit.fill)),
            Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(
                      top: 10, left: MediaQuery.of(context).size.width * 0.35)
                  : EdgeInsets.only(
                      top: 10, right: MediaQuery.of(context).size.width * 0.35),
              height: MediaQuery.of(context).size.height * 0.16,
              width: MediaQuery.of(context).size.width * 0.60,
              child: Text(
                widget.facilityItem.facilityItemName,
                style: TextStyle(
                    fontSize: Styles.textSizRegular,
                    fontFamily: tr('currFontFamily')),
              ),
            ),
            Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(
                      top: 50, left: MediaQuery.of(context).size.width * 0.35)
                  : EdgeInsets.only(
                      top: 50, right: MediaQuery.of(context).size.width * 0.35),
              height: MediaQuery.of(context).size.height * 0.12,
              width: MediaQuery.of(context).size.width * 0.60,
              child: SingleChildScrollView(
                  child: Row(
                      children: [getHtml(widget.facilityItem.description)])),
            ),
            widget.partyHallDetail != null &&
                    widget.partyHallDetail.partyEventTypeName != null
                ? Container(
                    margin: Localizations.localeOf(context).languageCode == "en"
                        ? EdgeInsets.only(
                            top: 100,
                            left: MediaQuery.of(context).size.width * 0.35)
                        : EdgeInsets.only(
                            top: 100,
                            right: MediaQuery.of(context).size.width * 0.35),
                    child: Text(
                      widget.partyHallDetail.partyEventTypeName,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  )
                : Text(""),
          ],
        ),
      ),
    );
  }

  Widget getMenuItemList(int facilityId, int facilityItemGroupId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 0, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.partyHallDetail.selectedMenuItems.length,
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
                                                    .partyHallDetail
                                                    .selectedMenuItems[j]
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
                                                      top: 60, left: 10)
                                                  : const EdgeInsets.only(
                                                      top: 60, right: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'AED ' +
                                                      widget
                                                          .partyHallDetail
                                                          .selectedMenuItems[j]
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

  Widget getHtml(String description) {
    return Expanded(
        child: Html(
      style: {
        "body": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
          color: ColorData.primaryTextColor,
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
          // fontWeight: FontWeight.normal,
          // fontSize: FontSize(Styles.packageExpandTextSiz),
          // fontFamily: tr('currFontFamilyEnglishOnly'),
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
        ),
      },
      // customFont: tr('currFontFamilyEnglishOnly'),
      // anchorColor: ColorData.primaryTextColor,
      data: description != null
          ? "<html><body>" + description + "</body></html>"
          : tr('noDataFound'),
    ));
  }

  // void displayDiscountModalBottomSheet(context) {
  //   showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(
  //           top: Radius.circular(30),
  //         ),
  //       ),
  //       context: context,
  //       builder: (BuildContext bc) {
  //         return new Container(
  //           padding: EdgeInsets.only(top: 20),
  //           color: Colors.transparent, //could change this to Color(0xFF737373),
  //           constraints: BoxConstraints(minHeight: 200),
  //           //so you don't have to change MaterialApp canvasColor
  //           child: new Container(
  //               decoration: new BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: new BorderRadius.only(
  //                       topLeft: const Radius.circular(8.0),
  //                       topRight: const Radius.circular(8.0))),
  //               child: ListView.builder(
  //                   shrinkWrap: true,
  //                   physics: ClampingScrollPhysics(),
  //                   scrollDirection: Axis.vertical,
  //                   itemCount: widget.billDiscounts.length,
  //                   itemBuilder: (context, j) {
  //                     return Visibility(
  //                         visible: true,
  //                         child: ListTile(
  //                           leading: Icon(
  //                             Icons.local_offer_outlined,
  //                             color:
  //                                 ColorData.primaryTextColor.withOpacity(0.3),
  //                             size: 24,
  //                           ),
  //                           title: Text(billDiscounts[j].discountName,
  //                               style: TextStyle(
  //                                   color: billDiscounts[j].billDiscountId ==
  //                                               0 &&
  //                                           billDiscounts[j].voucherType == 3
  //                                       ? ColorData.toColor(
  //                                           widget.facilityDetail.colorCode)
  //                                       : ColorData.primaryTextColor
  //                                           .withOpacity(1.0),
  //                                   fontSize: Styles.packageExpandTextSiz,
  //                                   fontFamily: tr('currFontFamily'))),
  //                           trailing: billDiscounts[j].billDiscountId == 0 &&
  //                                   billDiscounts[j].voucherType == 3
  //                               ? new Text("")
  //                               : new OutlinedButton(
  //                                   style: ButtonStyle(
  //                                     shape: MaterialStateProperty.all(
  //                                         RoundedRectangleBorder(
  //                                             borderRadius:
  //                                                 BorderRadius.circular(20.0))),
  //                                   ),
  //                                   onPressed: () {
  //                                     setState(() {
  //                                       if (widget.discount != null &&
  //                                           widget.discount.discountName !=
  //                                               null &&
  //                                           widget.discount.discountId ==
  //                                               billDiscounts[j].discountId &&
  //                                           widget.discount.billDiscountId ==
  //                                               billDiscounts[j]
  //                                                   .billDiscountId) {
  //                                         widget.discount = new BillDiscounts();
  //                                       } else {
  //                                         widget.discount = billDiscounts[j];
  //                                       }
  //                                       getTotal();
  //                                     });
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                   child: new Text(
  //                                     widget.discount != null &&
  //                                             widget.discount.discountName !=
  //                                                 null &&
  //                                             widget.discount.discountId ==
  //                                                 billDiscounts[j].discountId &&
  //                                             widget.discount.billDiscountId ==
  //                                                 billDiscounts[j]
  //                                                     .billDiscountId
  //                                         ? "Remove"
  //                                         : "Apply",
  //                                     style: TextStyle(
  //                                         color: ColorData.primaryTextColor
  //                                             .withOpacity(1.0),
  //                                         fontSize: Styles.packageExpandTextSiz,
  //                                         fontFamily: tr('currFontFamily')),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ),
  //                         ));
  //                   })),
  //         );
  //       });
  // }

  void displayDiscountModalBottomSheet(context) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return new Container(
            padding: EdgeInsets.only(top: 20),
            color: Colors.transparent, //could change this to Color(0xFF737373),
            constraints: BoxConstraints(minHeight: 200),
            //so you don't have to change MaterialApp canvasColor
            child: new Container(
                decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(8.0),
                        topRight: const Radius.circular(8.0))),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: widget.billDiscounts.length,
                    itemBuilder: (context, j) {
                      return Visibility(
                          visible: true,
                          child: ListTile(
                            leading: Icon(
                              Icons.local_offer_outlined,
                              color:
                                  ColorData.primaryTextColor.withOpacity(0.3),
                              size: 24,
                            ),
                            title: Text(billDiscounts[j].discountName,
                                style: TextStyle(
                                    color: billDiscounts[j].billDiscountId ==
                                                0 &&
                                            billDiscounts[j].voucherType == 3
                                        ? ColorData.primaryTextColor
                                            .withOpacity(1.0)
                                        : ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                            trailing:
                                billDiscounts[j].billDiscountId == 0 &&
                                        billDiscounts[j].voucherType == 3
                                    ? new Text("")
                                    : new OutlinedButton(
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0))),
                                        ),
                                        onPressed: () {
                                          if (widget.discount != null &&
                                              widget.discount.discountName !=
                                                  null &&
                                              widget.discount.discountId ==
                                                  billDiscounts[j].discountId &&
                                              widget.discount.billDiscountId ==
                                                  billDiscounts[j]
                                                      .billDiscountId) {
                                            setState(() {
                                              widget.discount =
                                                  new BillDiscounts();
                                              getTotal();
                                            });
                                            Navigator.of(context).pop();
                                            return;
                                          }
                                          if (billDiscounts[j].voucherType ==
                                              5) {
                                            showDialog<Widget>(
                                              context: context,
                                              barrierDismissible:
                                                  false, // user must tap button!
                                              builder:
                                                  (BuildContext ppcontext) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .stretch,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0),
                                                          child: Center(
                                                            child: Text(
                                                              tr("enter_coupon_code"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
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
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0),
                                                          child: Center(
                                                            child: Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.50,
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.080,
                                                                child:
                                                                    new TextFormField(
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .text,
                                                                        controller:
                                                                            _couponController,
                                                                        textAlign:
                                                                            TextAlign
                                                                                .center,
                                                                        decoration:
                                                                            new InputDecoration(
                                                                          contentPadding:
                                                                              EdgeInsets.all(5),
                                                                          // contentPadding: EdgeInsets.only(
                                                                          //     left: 10, top: 0, bottom: 0, right: 0),
                                                                          hintText:
                                                                              "Coupon Code",
                                                                          border:
                                                                              new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black12)),
                                                                          // focusedBorder: OutlineInputBorder(
                                                                          //     borderSide: new BorderSide(
                                                                          //         color: Colors.grey[200]))),
                                                                        ),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                Styles.packageExpandTextSiz,
                                                                            fontFamily: tr("currFontFamilyEnglishOnly"),
                                                                            color: ColorData.primaryTextColor,
                                                                            fontWeight: FontWeight.w200))),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 10.0),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: <Widget>[
                                                              ElevatedButton(
                                                                  style: ButtonStyle(
                                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                      backgroundColor: MaterialStateProperty.all<Color>(ColorData.grey300),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            8.0),
                                                                      )))),
                                                                  // shape: RoundedRectangleBorder(
                                                                  //     borderRadius:
                                                                  //         BorderRadius.all(
                                                                  //             Radius.circular(
                                                                  //                 5.0))),
                                                                  // color: ColorData
                                                                  //     .grey300,
                                                                  child: new Text(tr("cancel"),
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
                                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                      backgroundColor: MaterialStateProperty.all<Color>(ColorData.colorBlue),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            5.0),
                                                                      )))),
                                                                  // shape: RoundedRectangleBorder(
                                                                  //     borderRadius:
                                                                  //         BorderRadius.all(Radius.circular(
                                                                  //             5.0))),
                                                                  // color: ColorData
                                                                  //     .colorBlue,
                                                                  child: new Text(
                                                                    tr("confirm"),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            Styles
                                                                                .textSizeSmall,
                                                                        fontFamily:
                                                                            tr("currFontFamily")),
                                                                  ),
                                                                  onPressed: () async {
                                                                    _handler
                                                                        .show();
                                                                    Meta m = await (new FacilityDetailRepository()).checkDiscountCoupon(
                                                                        billDiscounts[j]
                                                                            .discountId,
                                                                        _couponController
                                                                            .text
                                                                            .toString());
                                                                    if (m.statusCode ==
                                                                        200) {
                                                                      _handler
                                                                          .dismiss();
                                                                      Navigator.of(
                                                                              ppcontext)
                                                                          .pop();
                                                                      setState(
                                                                          () {
                                                                        if (widget.discount != null &&
                                                                            widget.discount.discountName !=
                                                                                null &&
                                                                            widget.discount.discountId ==
                                                                                billDiscounts[j].discountId &&
                                                                            widget.discount.billDiscountId == billDiscounts[j].billDiscountId) {
                                                                          widget.discount =
                                                                              new BillDiscounts();
                                                                        } else {
                                                                          widget.discount =
                                                                              billDiscounts[j];
                                                                        }
                                                                        getTotal();
                                                                      });
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                      util.customGetSnackBarWithOutActionButton(
                                                                          tr("Coupon"),
                                                                          "Discount Applied Successfully",
                                                                          context);
                                                                    } else {
                                                                      _handler
                                                                          .dismiss();
                                                                      util.customGetSnackBarWithOutActionButton(
                                                                          tr("Coupon"),
                                                                          m.statusMsg,
                                                                          context);
                                                                    }
                                                                  })
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
                                            setState(() {
                                              widget.discount =
                                                  billDiscounts[j];
                                              getTotal();
                                            });
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: new Text(
                                          widget.discount != null &&
                                                  widget.discount
                                                          .discountName !=
                                                      null &&
                                                  widget.discount.discountId ==
                                                      billDiscounts[j]
                                                          .discountId &&
                                                  widget.discount
                                                          .billDiscountId ==
                                                      billDiscounts[j]
                                                          .billDiscountId
                                              ? "Remove"
                                              : "Apply",
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily: tr('currFontFamily')),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                          ));
                    })),
          );
        });
  }

  /*void getTotal() {
    if (facilityDetail.facilityId == Constants.FacilityMembership) {
      if (userProfileInfo.price != null) {
        widget.total = userProfileInfo.price;
        if (userProfileInfo.vatPercentage == null) {
          widget.taxableAmt = (userProfileInfo.price);
        } else {
          widget.taxableAmt = (userProfileInfo.price) /
              (1 + (userProfileInfo.vatPercentage / 100.00));
        }
        for (int i = 0;
            i < widget.userProfileInfo.associatedProfileList.length;
            i++) {
          widget.total = widget.total +
              widget.userProfileInfo.associatedProfileList[i].price;
          if (widget.userProfileInfo.associatedProfileList[i].vatPercentage ==
              null) {
            widget.taxableAmt = widget.taxableAmt +
                (widget.userProfileInfo.associatedProfileList[i].price);
          } else {
            widget.taxableAmt = widget.taxableAmt +
                (widget.userProfileInfo.associatedProfileList[i].price) /
                    (1 +
                        (widget.userProfileInfo.associatedProfileList[i]
                                .vatPercentage /
                            100.00));
          }
        }
        widget.taxAmt = widget.total - widget.taxableAmt;
      }
    } else {
      widget.total = partyHallDetail.price;
      if (partyHallDetail.vatPercentage == null) {
        widget.taxableAmt = (partyHallDetail.price);
      } else {
        widget.taxableAmt = (partyHallDetail.price) /
            (1 + (partyHallDetail.vatPercentage / 100.00));
      }
      widget.taxAmt = widget.total - widget.taxableAmt;
    }
    if (widget.discount != null && widget.discount.discountValue != null) {
      if (widget.discount.discountValue > 0) {
        if (widget.discount.discountType == 1) {
          // widget.discountAmt =
          //     (widget.total * (widget.discount.discountValue / 100));
          widget.discountAmt = double.parse(roundDouble(
                  (widget.total * (widget.discount.discountValue / 100.0)), 2)
              .toStringAsFixed(2));
        } else {
          widget.discountAmt = widget.discount.discountValue;
        }
      }
    }
    widget.total = widget.total - widget.discountAmt;
  }*/
  void getTotal() {
    double itemDiscountAmt = 0;
    double taxableAmt = 0;
    double taxAmt = 0;
    widget.taxAmt = 0;
    widget.taxableAmt = 0;
    widget.total = 0;
    widget.discountAmt = 0;
    // if(widget.partyHallDetail!=null && widget.partyHallDetail.selectedMenuItems!=null && widget.partyHallDetail.selectedMenuItems.length>0){
    //   for (int i = 0; i < widget.partyHallDetail.selectedMenuItems.length; i++) {
    //     FacilityBeachRequest item=widget.partyHallDetail.selectedMenuItems[i];
    //     if (item.vatPercentage == null) {
    //       if (item.rate != null && item.rate > 0) {
    //         taxableAmt = (item.rate);
    //       } else {
    //         taxableAmt = (item.price);
    //       }
    //     } else {
    //       if (item.rate != null && item.rate > 0) {
    //         taxableAmt = (item.rate);
    //       } else {
    //         taxableAmt = (item.price) /
    //             (1 + (item.vatPercentage / 100.00));
    //       }
    //     }
    //     if (widget.discount != null && widget.discount.discountValue != null) {
    //       if (widget.discount.discountValue > 0) {
    //         if (widget.discount.discountType == 1) {
    //           itemDiscountAmt = double.parse(roundDouble(
    //               (taxableAmt * (widget.discount.discountValue / 100.0)), 2)
    //               .toStringAsFixed(2));
    //         }
    //       }
    //     }
    //     if (item.vatPercentage != null) {
    //       taxAmt = (taxableAmt - itemDiscountAmt) *
    //           (item.vatPercentage / 100);
    //     }
    //     widget.taxAmt=widget.taxAmt+taxAmt;
    //     widget.taxableAmt=widget.taxableAmt+taxableAmt;
    //     widget.discountAmt=widget.discountAmt+itemDiscountAmt;
    //     widget.total = widget.total + (taxableAmt - itemDiscountAmt + taxAmt);
    //   }
    // }
    if (partyHallDetail.vatPercentage == null) {
      taxableAmt = (partyHallDetail.price);
    } else {
      taxableAmt = (partyHallDetail.price) /
          (1 + (partyHallDetail.vatPercentage / 100.00));
    }
    if (widget.discount != null && widget.discount.discountValue != null) {
      if (widget.discount.discountValue > 0) {
        if (widget.discount.discountType == 1) {
          // widget.discountAmt =
          //     (widget.total * (widget.discount.discountValue / 100));
          itemDiscountAmt = double.parse(roundDouble(
                  (taxableAmt * (widget.discount.discountValue / 100.0)), 2)
              .toStringAsFixed(2));
        }
        /*else {
            widget.discountAmt = widget.discount.discountValue;
          }*/
      }
    }
    if (partyHallDetail.vatPercentage != null) {
      taxAmt = (taxableAmt - itemDiscountAmt) *
          (partyHallDetail.vatPercentage / 100);
    }
    widget.taxableAmt = widget.taxableAmt + taxableAmt;
    widget.taxAmt = widget.taxAmt + taxAmt;
    widget.discountAmt = widget.discountAmt + itemDiscountAmt;
    widget.total = widget.total + (taxableAmt - itemDiscountAmt + taxAmt);
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
