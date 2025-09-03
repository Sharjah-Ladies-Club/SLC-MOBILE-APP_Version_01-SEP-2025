// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_voucher_select_component.dart';
import 'package:slc/customcomponentfields/custom_form_builder/custom_form_builder.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/Beach/confirmation_alert.dart';
import 'package:slc/view/Beach/web_page.dart';
import '../../../model/payment_terms_response.dart';
import '../../utils/constant.dart';
import 'Beach_Page.dart';
import 'package:apple_pay_flutter/apple_pay_flutter.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';

class BeachPaymentPage extends StatefulWidget {
  int facilityId = 0;
  int facilityItemGroupId = 0;
  List<FacilityItem> facilityItems = [];
  HashMap<int, int> itemCounts = new HashMap<int, int>();
  double total = 0;
  double taxAmt = 0;
  double taxableAmt = 0;
  double discountAmt = 0;
  bool saveInProgress = false;
  BillDiscounts discount = new BillDiscounts();
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  PaymentTerms terms = new PaymentTerms(termsId: 0, terms: "");
  GiftVocuher selectedVoucher = new GiftVocuher();
  bool showGiftCardRedeem = true;
  bool enablePayments = true;
  BeachPaymentPage(
      {Key key,
      this.facilityItems,
      this.itemCounts,
      this.total,
      this.facilityId,
      this.facilityItemGroupId,
      this.billDiscounts,
      this.giftVouchers,
      this.terms})
      : super(key: key);

  @override
  _BeachPayment createState() => _BeachPayment(
      facilityItems: facilityItems,
      itemCounts: itemCounts,
      total: total,
      facilityId: facilityId,
      facilityItemGroupId: facilityItemGroupId,
      billDiscounts: billDiscounts,
      giftVouchers: giftVouchers,
      terms: terms);
}

class _BeachPayment extends State<BeachPaymentPage> {
  bool valuefirst = false;
  int facilityId = 0;
  int facilityItemGroupId = 0;
  Utils util = new Utils();
  List<FacilityItem> facilityItems = [];
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  HashMap<int, int> itemCounts = new HashMap<int, int>();
  bool onPressedTimer = true;
  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);
  TextEditingController _giftCardText = new TextEditingController();

  // MaskedTextController _giftVoucherAmount =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  TextEditingController _giftVoucherUsedAmount = new TextEditingController();

  double total = 0;
  bool saveInProgress = false;
  // FlutterPay flutterPay = FlutterPay();
  ProgressBarHandler _handler;
  String _vchErrorText = "";
  PaymentTerms terms = new PaymentTerms(termsId: 0, terms: "");

  _BeachPayment(
      {this.facilityItems,
      this.itemCounts,
      this.total,
      this.facilityId,
      this.facilityItemGroupId,
      this.billDiscounts,
      this.giftVouchers,
      this.terms});
  @override
  Widget build(BuildContext context) {
    getTotal();
    if (giftVouchers != null && giftVouchers.length > 1) {
      widget.showGiftCardRedeem = true;
    } else {
      widget.showGiftCardRedeem = false;
    }

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
                builder: (context) => BeachPage(
                  facilityId: facilityId,
                  facilityItemGroupId: facilityItemGroupId,
                  facilityItems: facilityItems,
                  itemCounts: itemCounts,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(height: 5),
              Row(children: [getItemList(0, 0)]),
              SizedBox(height: 10),
              Visibility(
                  visible: widget.billDiscounts.length > 0 ? true : false,
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
                              color:
                                  ColorData.primaryTextColor.withOpacity(1.0)),
                          title: Text(
                              widget.discount != null &&
                                      widget.discount.discountName != null
                                  ? widget.discount.discountName
                                  : 'Save with ' +
                                      billDiscounts.length.toString() +
                                      ' Offers',
                              style: TextStyle(
                                  color: ColorData.primaryTextColor
                                      .withOpacity(1.0),
                                  fontSize: Styles.packageExpandTextSiz,
                                  fontFamily: tr('currFontFamily'))),
                          trailing: new OutlinedButton(
                            onPressed: () {
                              displayDiscountModalBottomSheet(context);
                            },
                            child: new Text(
                              "View",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor
                                      .withOpacity(1.0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ]))),
              SizedBox(height: 5),
              Visibility(
                  visible: widget.showGiftCardRedeem, // Giftcard
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Colors.grey[200]),
                              color: Colors.white,
                            ),
                            child: FormBuilder(
                                child: Column(children: <Widget>[
                              Visibility(
                                  visible: widget.showGiftCardRedeem,
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                    child: CustomGiftVoucherComponent(
                                        selectedFunction:
                                            _onChangeOptionVoucherDropdown,
                                        voucherController: _giftCardText,
                                        isEditBtnEnabled:
                                            Strings.ProfileCallState,
                                        voucherResponse: giftVouchers == null
                                            ? []
                                            : giftVouchers,
                                        label: tr('gift_card')),
                                  )),
                              Container(
                                padding: EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                child: ListTile(
                                  leading: Icon(Icons.local_offer_outlined,
                                      color: ColorData.primaryTextColor),
                                  title: Column(children: [
                                    Text(tr("gift_voucher_rdeem_amount"),
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor,
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily'))),
                                    Text(_vchErrorText,
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor,
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily')))
                                  ]),
                                  trailing: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.16,
                                      height: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.045,
                                      child: new TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller: _giftVoucherUsedAmount,
                                          enabled:
                                              widget.selectedVoucher != null &&
                                                      widget.selectedVoucher
                                                              .giftVoucherId !=
                                                          null &&
                                                      widget.selectedVoucher
                                                              .giftVoucherId >
                                                          0 &&
                                                      widget.selectedVoucher
                                                              .balanceAmount >
                                                          100
                                                  ? true
                                                  : false,
                                          textAlign: TextAlign.center,
                                          decoration: new InputDecoration(
                                            contentPadding: EdgeInsets.all(5),
                                            // contentPadding: EdgeInsets.only(
                                            //     left: 10, top: 0, bottom: 0, right: 0),
                                            hintText: "",
                                            border: new OutlineInputBorder(
                                                borderSide: new BorderSide(
                                                    color: Colors.black12)),
                                            // focusedBorder: OutlineInputBorder(
                                            //     borderSide: new BorderSide(
                                            //         color: Colors.grey[200]))),
                                          ),
                                          onChanged: (value) {
                                            _vchErrorText = "";
                                            double enteredAmt = 0;
                                            if (value != "" &&
                                                widget.selectedVoucher !=
                                                    null) {
                                              enteredAmt = double.parse(value);
                                            } else {
                                              //_giftVoucherUsedAmount.text =
                                              //  "";
                                              getTotal();
                                              //FocusScope.of(context).requestFocus(focusNode);
                                              return;
                                            }
                                            if (enteredAmt < 100 &&
                                                widget.selectedVoucher
                                                        .balanceAmount >
                                                    100) {
                                              _vchErrorText = tr(
                                                  "amount_should_be_hundred_or_greater");
                                            } else if (widget.selectedVoucher
                                                    .balanceAmount <
                                                100) {
                                              _giftVoucherUsedAmount.text =
                                                  widget.selectedVoucher
                                                      .balanceAmount
                                                      .toStringAsFixed(2);
                                            } else if (widget.selectedVoucher
                                                    .balanceAmount <
                                                enteredAmt) {
                                              _vchErrorText = tr(
                                                  "amount_should_be_not_be_greater_than_balance_amount");
                                              _giftVoucherUsedAmount.text =
                                                  widget.selectedVoucher
                                                      .balanceAmount
                                                      .toStringAsFixed(2);
                                            }
                                            //setState(() {});
                                            getTotal();
                                            if (widget.total < 0) {
                                              _vchErrorText = tr(
                                                  "amount_should_be_not_be_greater_than_total_amount");
                                              getTotal();
                                            }
                                          },
                                          style: TextStyle(
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily: tr(
                                                  "currFontFamilyEnglishOnly"),
                                              color: ColorData.primaryTextColor,
                                              fontWeight: FontWeight.w200))),
                                ),
                              ),
                            ])))
                      ])),
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
                        margin:
                            const EdgeInsets.only(top: 16, left: 8, right: 8),
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
                        margin:
                            const EdgeInsets.only(top: 6, left: 8, right: 8),
                        child: Row(
                          children: [
                            SizedBox(
                                // color: Colors.red,
                                // height:
                                //     MediaQuery.of(context).size.height * 0.08,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Text(
                                    terms
                                        .terms, //tr("payment_terms_conditions")
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.packageExpandTextSiz,
                                        fontFamily: tr('currFontFamily')))),
                          ],
                        ),
                      ),
                      Container(
                          margin:
                              const EdgeInsets.only(top: 16, left: 8, right: 8),
                          child: Row(children: [
                            Text(tr("dont_press_back_button"),
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 12))
                          ])),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 16, left: 8, right: 8),
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
                                    if (value) {
                                      if (widget.billDiscounts.length > 0 &&
                                          widget.discountAmt <= 0) {
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
                                                          tr('discount_title'),
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
                                                          tr('discount_confirmation_msg'),
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
                                                              style:
                                                                  ButtonStyle(
                                                                      foregroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                      backgroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          ColorData
                                                                              .grey300),
                                                                      shape: MaterialStateProperty.all<
                                                                              RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius
                                                                                  .all(
                                                                        Radius.circular(
                                                                            2.0),
                                                                      )))),
                                                              // color:
                                                              // ColorData.grey300,
                                                              child: new Text(
                                                                  tr("no"),
                                                                  style: TextStyle(
                                                                      color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                                                      fontSize: Styles.textSizeSmall,
                                                                      fontFamily: tr("currFontFamily"))),
                                                              onPressed: () {
                                                                setState(() {
                                                                  this.valuefirst =
                                                                      value;
                                                                });
                                                                Navigator.of(
                                                                        pcontext)
                                                                    .pop();
                                                              }),
                                                          ElevatedButton(
                                                            style: ButtonStyle(
                                                                foregroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        Colors
                                                                            .white),
                                                                backgroundColor:
                                                                    MaterialStateProperty.all<
                                                                            Color>(
                                                                        ColorData
                                                                            .colorBlue),
                                                                shape: MaterialStateProperty.all<
                                                                        RoundedRectangleBorder>(
                                                                    RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          2.0),
                                                                )))),
                                                            child: new Text(
                                                              tr("yes"),
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
                                                              setState(() {
                                                                value = false;
                                                                this.valuefirst =
                                                                    value;
                                                              });
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
                                        this.valuefirst = value;
                                      }
                                    }
                                    setState(() {});
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
                                          child: Text(tr("original_Amount"),
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
                                                double.tryParse(widget
                                                            .taxableAmt
                                                            .toStringAsFixed(
                                                                2) ??
                                                        0)
                                                    .toStringAsFixed(2),
                                            // double.parse(
                                            //     widget.taxableAmt
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
                        Container(
                          width: MediaQuery.of(context).size.width * 0.75,
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
                                                double.tryParse(widget.taxAmt
                                                            .toStringAsFixed(
                                                                2) ??
                                                        0)
                                                    .toStringAsFixed(2),

                                            // double.parse(
                                            //         widget.taxAmt
                                            //             .toStringAsFixed(2),
                                            //         (e) {
                                            //       return 0;
                                            //     }).toStringAsFixed(2),
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
                        Visibility(
                            visible: widget.billDiscounts != null &&
                                    widget.billDiscounts.length > 0
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
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
                        Visibility(
                            visible: widget.showGiftCardRedeem,
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
                                                0.40,
                                        child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                                tr("gift_Voucher_amount"),
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
                                                _giftVoucherUsedAmount.text !=
                                                        ""
                                                    ? " " +
                                                        double.parse(
                                                                _giftVoucherUsedAmount
                                                                    .text)
                                                            .toStringAsFixed(2)
                                                    : "0.00",
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
              (valuefirst != false &&
                      (total != 0 ||
                          (_giftVoucherUsedAmount.text == ""
                                  ? 0
                                  : double.parse(_giftVoucherUsedAmount.text)) >
                              0))
                  ? Container(
                      width: MediaQuery.of(context).size.width - 60,
                      margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 8),
                      child: Column(children: [
                        Visibility(
                            visible: Platform.isIOS && widget.enablePayments,
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(tr('proceed_to_applepay'),
                                        style: EventPeopleListPageStyle
                                            .eventPeopleListPageBtnTextStyleWithAr(
                                                context)),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 2, right: 2),
                                      child: Icon(ApplePayIcon.apple_pay,
                                          color: Colors.white, size: 30)),
                                ],
                              ),
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )))),

                              // shape: new RoundedRectangleBorder(
                              //   borderRadius: new BorderRadius.circular(8),
                              // ),
                              // color: Colors
                              //     .black /*widget.colorCode == null
                              //         ? Colors.blue[200]
                              //         : ColorData.toColor(widget.colorCode)*/
                              // ,
                              onPressed: () async {
                                if (widget.showGiftCardRedeem) {
                                  if (validGiftCardAmount() == 1) {
                                    util.customGetSnackBarWithOutActionButton(
                                        tr('error_caps'),
                                        tr("amount_should_be_hundred_or_greater"),
                                        context);
                                    return;
                                  }
                                  if (validGiftCardAmount() == 2) {
                                    util.customGetSnackBarWithOutActionButton(
                                        tr('error_caps'),
                                        tr("redeemption_shouldnot_greater_than_total"),
                                        context);
                                    return;
                                  }
                                }
                                _handler.show();
                                widget.enablePayments = false;
                                setState(() {});
                                double totalAmt = 0;
                                List<FacilityBeachRequest> facilityItemRequest =
                                    [];
                                for (int i = 0;
                                    i < widget.facilityItems.length;
                                    i++) {
                                  int itemCount = itemCounts[widget
                                              .facilityItems[i]
                                              .facilityItemId] ==
                                          null
                                      ? 0
                                      : itemCounts[widget
                                          .facilityItems[i].facilityItemId];
                                  if (itemCount > 0) {
                                    FacilityBeachRequest item =
                                        new FacilityBeachRequest();
                                    item.facilityItemId =
                                        widget.facilityItems[i].facilityItemId;
                                    item.quantity = itemCount;
                                    item.price = widget.facilityItems[i].price;
                                    item.vatPercentage =
                                        widget.facilityItems[i].vatPercentage;
                                    facilityItemRequest.add(item);
                                  }
                                }

                                total = totalAmt;
                                Meta m = await FacilityDetailRepository()
                                    .getEnquiryPaymentOrderRequest(
                                        widget.facilityId,
                                        0,
                                        facilityItemRequest,
                                        0,
                                        billDiscount: widget.discount,
                                        discountAmt: widget.discountAmt,
                                        tipsAmount: 0,
                                        grossAmount: widget.taxableAmt,
                                        taxAmount: widget.taxAmt,
                                        netAmount: widget.total,
                                        deliveryAmount: 0,
                                        deliveryTaxAmount: 0,
                                        bookingId: 0,
                                        moduleId: 0,
                                        giftVoucher: widget.selectedVoucher,
                                        giftVoucherAmount:
                                            ((widget.selectedVoucher == null
                                                ? 0
                                                : _giftVoucherUsedAmount.text ==
                                                        ""
                                                    ? 0
                                                    : double.parse(
                                                        _giftVoucherUsedAmount
                                                            .text))));
                                if (m.statusCode == 200) {
                                  // ignore: unnecessary_statements
                                  _handler.dismiss();
                                  Map<String, dynamic> decode = m.toJson();
                                  // print('12' + decode['statusMsg']);
                                  Map userMap = jsonDecode(decode['statusMsg']);
                                  // print(userMap);
                                  userMap.forEach((key, val) {
                                    print('{ key: $key, value: $val}');
                                    if (key == 'response') {
                                      //call apple pay
                                      Map payment =
                                          new Map<String, dynamic>.from(val);
                                      if (payment["applePayUrl"] != "") {
                                        String applePayUrl =
                                            payment["applePayUrl"];
                                        int orderId = payment["orderId"];
                                        String merchantReferenceNo =
                                            payment['merchantReferenceNo'];
                                        String merchantIdentifier =
                                            payment['merchantIdentifier'];
                                        String facilityName =
                                            payment['facilityName'];
                                        makePayment(
                                            widget.total,
                                            applePayUrl,
                                            orderId,
                                            merchantReferenceNo,
                                            merchantIdentifier,
                                            facilityName);
                                      } else {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ConfirmationAlert(
                                              merchantReferenceNo: payment[
                                                  'merchantReferenceNo'],
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  });
                                } else {
                                  _handler.dismiss();
                                  widget.enablePayments = true;
                                  setState(() {});
                                  util.customGetSnackBarWithOutActionButton(
                                      tr('error_caps'), m.statusMsg, context);
                                }
                              },
                              // textColor: Colors.white,
                              //color: Theme.of(context).primaryColor,
                            )),
                        Visibility(
                            visible: widget.enablePayments,
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
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    )))),
                                // shape: new RoundedRectangleBorder(
                                //   borderRadius: new BorderRadius.circular(8),
                                // ),
                                onPressed: () async {
                                  if (widget.showGiftCardRedeem) {
                                    if (validGiftCardAmount() == 1) {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr('error_caps'),
                                          tr("amount_should_be_hundred_or_greater"),
                                          context);
                                      return;
                                    }
                                    if (validGiftCardAmount() == 2) {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr('error_caps'),
                                          tr("redeemption_shouldnot_greater_than_total"),
                                          context);
                                      return;
                                    }
                                  }
                                  if (!widget.saveInProgress) {
                                    _handler.show();
                                    widget.saveInProgress = true;
                                    widget.enablePayments = false;
                                    setState(() {});
                                    double totalAmt = 0;
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    // new List<FacilityBeachRequest>();
                                    for (int i = 0;
                                        i < widget.facilityItems.length;
                                        i++) {
                                      int itemCount = itemCounts[widget
                                                  .facilityItems[i]
                                                  .facilityItemId] ==
                                              null
                                          ? 0
                                          : itemCounts[widget
                                              .facilityItems[i].facilityItemId];
                                      if (itemCount > 0) {
                                        FacilityBeachRequest item =
                                            new FacilityBeachRequest();
                                        item.facilityItemId = widget
                                            .facilityItems[i].facilityItemId;
                                        item.quantity = itemCount;
                                        item.price =
                                            widget.facilityItems[i].price;
                                        item.vatPercentage = widget
                                            .facilityItems[i].vatPercentage;
                                        facilityItemRequest.add(item);
                                      }
                                    }
                                    total = totalAmt;
                                    Meta m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityId,
                                            0,
                                            facilityItemRequest,
                                            0,
                                            billDiscount: widget.discount,
                                            discountAmt: widget.discountAmt,
                                            tipsAmount: 0,
                                            grossAmount: widget.taxableAmt,
                                            taxAmount: widget.taxAmt,
                                            netAmount: widget.total,
                                            deliveryAmount: 0,
                                            deliveryTaxAmount: 0,
                                            bookingId: 0,
                                            moduleId: 0,
                                            giftVoucher: widget.selectedVoucher,
                                            giftVoucherAmount: ((widget
                                                        .selectedVoucher ==
                                                    null
                                                ? 0
                                                : _giftVoucherUsedAmount.text ==
                                                        ""
                                                    ? 0
                                                    : double.parse(
                                                        _giftVoucherUsedAmount
                                                            .text))));
                                    if (m.statusCode == 200) {
                                      // ignore: unnecessary_statements
                                      _handler.dismiss();
                                      Map<String, dynamic> decode = m.toJson();
                                      // print('12' + decode['statusMsg']);
                                      Map userMap =
                                          jsonDecode(decode['statusMsg']);
                                      // print(userMap);
                                      userMap.forEach((key, val) {
                                        // print('{ key: $key, value: $val}');
                                        if (key == 'response') {
                                          Map payment =
                                              new Map<String, dynamic>.from(
                                                  val);
                                          var list = [];
                                          payment.entries.forEach((e) => {
                                                if (e.key == 'payment')
                                                  {
                                                    list.add(e.value
                                                        .toString()
                                                        .replaceAll(
                                                            "href:", ''))
                                                  },
                                              });
                                          var first = list[0]
                                              .toString()
                                              .replaceAll('{', "");
                                          if (payment["merchantIdentifier"] !=
                                              "") {
                                            openWebView(first
                                                .replaceAll("}", '')
                                                .trim());
                                          } else {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ConfirmationAlert(
                                                  merchantReferenceNo: payment[
                                                      'merchantReferenceNo'],
                                                ),
                                              ),
                                            );
                                          }
                                          widget.saveInProgress = false;
                                        }
                                      });
                                    } else {
                                      _handler.dismiss();
                                      widget.enablePayments = true;
                                      setState(() {});
                                      util.customGetSnackBarWithOutActionButton(
                                          tr('error_caps'),
                                          m.statusMsg,
                                          context);
                                      widget.saveInProgress = false;
                                    }
                                  }
                                }
                                // textColor: Colors.white,
                                // color: Theme.of(context).primaryColor,
                                ))
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

  Widget getItemList(int facilityId, int facilityItemGroupId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 0, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.facilityItems.length,
                itemBuilder: (context, j) {
                  return
                      //    ? Text("")
                      //  :
                      Visibility(
                          visible: (itemCounts[widget
                                          .facilityItems[j].facilityItemId] !=
                                      null &&
                                  itemCounts[widget
                                          .facilityItems[j].facilityItemId] !=
                                      0)
                              ? true
                              : false,
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
                                                widget.facilityItems[j]
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
                                                      top: 40, left: 10)
                                                  : const EdgeInsets.only(
                                                      top: 40, right: 10),
                                          child: Row(
                                            children: [
                                              Text(
                                                  'AED ' +
                                                      widget.facilityItems[j]
                                                          .price
                                                          .toStringAsFixed(2) +
                                                      '  ',
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                              Visibility(
                                                  visible: widget
                                                          .facilityItems[j]
                                                          .isDiscountable
                                                      ? true
                                                      : false,
                                                  child: Text(
                                                      tr("discountable"),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: Styles
                                                              .reviewTextSize,
                                                          // fontStyle:
                                                          //     FontStyle.italic,
                                                          backgroundColor:
                                                              ColorData.toColor(
                                                                  "65B0C7"))))
                                              //Image.asset(
                                              //    'assets/images/discount.png'))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? EdgeInsets.only(
                                                      top: 30,
                                                      bottom: 5,
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.68,
                                                    )
                                                  : EdgeInsets.only(
                                                      top: 30,
                                                      bottom: 5,
                                                      right:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.68,
                                                    ),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .05,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3.8,
                                          // decoration: BoxDecoration(
                                          //   border:
                                          //       Border.all(color: Colors.grey[200]),
                                          //   color: Colors.white,
                                          //   borderRadius: BorderRadius.circular(16),
                                          // ),
                                          child: Stack(
                                            children: [
                                              Padding(
                                                padding: Localizations
                                                                .localeOf(
                                                                    context)
                                                            .languageCode ==
                                                        "en"
                                                    ? EdgeInsets.only(
                                                        left: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3.8) /
                                                            2.3,
                                                        top: 9)
                                                    : EdgeInsets.only(
                                                        right: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                3.8) /
                                                            2.3,
                                                        top: 9),
                                                child: new Text(
                                                    (itemCounts[widget
                                                                    .facilityItems[
                                                                        j]
                                                                    .facilityItemId] ==
                                                                null
                                                            ? "0"
                                                            : itemCounts[widget
                                                                    .facilityItems[
                                                                        j]
                                                                    .facilityItemId]
                                                                .toString()) +
                                                        (itemCounts[widget
                                                                        .facilityItems[
                                                                            j]
                                                                        .facilityItemId] !=
                                                                    null &&
                                                                itemCounts[widget
                                                                        .facilityItems[
                                                                            j]
                                                                        .facilityItemId] >
                                                                    1
                                                            ? " (Nos)"
                                                            : " (No)"),
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                              ),
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

  void getTotal() {
    double totalAmt = 0;
    double totalAmtWithoutPromotion = 0;
    widget.taxAmt = 0;
    widget.taxableAmt = 0;
    widget.discountAmt = 0;
    widget.total = 0;
    for (int i = 0; i < widget.facilityItems.length; i++) {
      int itemCount = itemCounts[widget.facilityItems[i].facilityItemId] == null
          ? 0
          : itemCounts[widget.facilityItems[i].facilityItemId];
      // debugPrint(widget.facilityItems[i].vatPercentage.toString() + " vat ");
      double taxableAmt = 0;
      double itemDiscountAmt = 0;
      double taxAmt = 0;
      taxableAmt = (widget.facilityItems[i].rate * itemCount);
      //totalAmt = totalAmt + (widget.facilityItems[i].price * itemCount);
      if (widget.facilityItems[i].isDiscountable) {
        totalAmtWithoutPromotion = (widget.facilityItems[i].rate * itemCount);
        if (widget.discount != null && widget.discount.discountValue != null) {
          if (widget.discount.discountValue > 0) {
            if (widget.discount.discountType == 1) {
              itemDiscountAmt = double.parse(roundDouble(
                      (totalAmtWithoutPromotion *
                          (widget.discount.discountValue / 100.0)),
                      2)
                  .toStringAsFixed(2));
            }
            /*else {
              discount = widget.discount.discountValue;
            }*/
          }
        }
      }
      widget.taxableAmt = widget.taxableAmt + taxableAmt;
      widget.discountAmt = widget.discountAmt + itemDiscountAmt;
      //calculate the tax after discount here
      if (widget.facilityItems[i].vatPercentage == null) {
        taxAmt = 0;
      } else {
        taxAmt = (taxableAmt - itemDiscountAmt) *
            (widget.facilityItems[i].vatPercentage / 100.0);
      }
      widget.taxAmt = widget.taxAmt + taxAmt;
      totalAmt = totalAmt + taxableAmt - itemDiscountAmt + taxAmt;
      //double taxAmt = (widget.facilityItems[i].price * itemCount) - taxableAmt;
      //widget.taxAmt = widget.taxAmt + taxAmt;
    }
    total = totalAmt -
        (_giftVoucherUsedAmount.text == ""
            ? 0
            : double.parse(_giftVoucherUsedAmount.text));
    widget.total = totalAmt -
        (_giftVoucherUsedAmount.text == ""
            ? 0
            : double.parse(_giftVoucherUsedAmount.text));
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => BeachWebviewPage(
                  title: tr("payment"),
                  url: val,
                  facilityId: widget.facilityId,
                  facilityItems: widget.facilityItems,
                ))).then((value) {
      widget.enablePayments = true;
      setState(() {});
    });
  }

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
                                          if (widget.showGiftCardRedeem) {
                                            _clearOptionGiftVoucher();
                                          }
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
                                                                            5.0),
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
                                                                        if (widget
                                                                            .showGiftCardRedeem) {
                                                                          _clearOptionGiftVoucher();
                                                                        }
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
                                              if (widget.showGiftCardRedeem) {
                                                _clearOptionGiftVoucher();
                                              }
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
  //                                       ? ColorData.primaryTextColor
  //                                           .withOpacity(1.0)
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
  _onChangeOptionVoucherDropdown(GiftVocuher voucher) {
    setState(() {
      _giftVoucherUsedAmount.text = "0";
      getTotal();
      widget.selectedVoucher = voucher;
      if (widget.total >= voucher.balanceAmount) {
        _giftVoucherUsedAmount.text = voucher.balanceAmount.toStringAsFixed(2);
      } else if (widget.total < voucher.balanceAmount) {
        _giftVoucherUsedAmount.text = widget.total.toStringAsFixed(2);
      }
      getTotal();
    });
  }

  _clearOptionGiftVoucher() {
    if (widget.showGiftCardRedeem) {
      widget.selectedVoucher = giftVouchers[0];
      _giftCardText.text = widget.selectedVoucher.giftCardText;
      for (int i = 0; i < giftVouchers.length; i++) {
        if (giftVouchers[i].giftVoucherId ==
            widget.selectedVoucher.giftVoucherId) {
          _onChangeOptionVoucherDropdown(giftVouchers[i]);
          break;
        }
      }
      _giftVoucherUsedAmount.text = "0";
      setState(() {});
    }
  }

  int validGiftCardAmount() {
    int result = 0;
    if (_giftVoucherUsedAmount.text != "" && widget.selectedVoucher != null) {
      double enteredAmt = double.parse(_giftVoucherUsedAmount.text);
      double voucherBalance = widget.selectedVoucher.balanceAmount == null
          ? 0
          : widget.selectedVoucher.balanceAmount;
      double totalAmt = widget.total == null ? 0 : widget.total;
      if (voucherBalance >= 100 && enteredAmt < 100) {
        result = 1;
        return result;
      }
      if (voucherBalance > totalAmt && widget.total < 0) {
        result = 2;
        return result;
      }
    }
    return result;
  }

  void makePayment(
      double payAmount,
      String applePayUrl,
      int orderId,
      String merchantReferenceNo,
      String merchantIdentifier,
      String facilityName) async {
    String itemName = "Sharjah Ladies Club " + facilityName;
    dynamic applePaymentData;
    List<PaymentItem> paymentItems = [
      PaymentItem(label: itemName, amount: payAmount, shippingcharge: 0.00)
    ];

    try {
      // initiate payment
      applePaymentData = await ApplePayFlutter.makePayment(
        countryCode: "AE",
        currencyCode: "AED",
        paymentNetworks: [
          PaymentNetwork.visa,
          PaymentNetwork.mastercard,
        ],
        merchantIdentifier: merchantIdentifier,
        paymentItems: paymentItems,
        customerEmail: SPUtil.getString(Constants.USER_EMAIL),
        customerName: SPUtil.getString(Constants.USER_FIRSTNAME),
        companyName: "Sharjah Ladies Club",
      );

      if (applePaymentData == null ||
          applePaymentData["paymentData"] == null ||
          applePaymentData["paymentData"].toString() == "") {
        _handler.dismiss();
        util.customGetSnackBarWithOutActionButton(
            tr('error_caps'), "Payment Failed Please try again", context);
      } else {
        _handler.show();
        Meta m = await FacilityDetailRepository().applePayResponse(
            applePaymentData["paymentData"].toString(), applePayUrl, orderId);
        if (m.statusCode == 200) {
          _handler.dismiss();
          // Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConfirmationAlert(
                merchantReferenceNo: merchantReferenceNo,
              ),
            ),
          );
        } else {
          _handler.dismiss();
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), m.statusMsg, context);
        }
      }
      // This logs the Apple Pay response data
      // applePaymentData.toString());

    } on PlatformException {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), "Payment Failed Please try again", context);
    }
  }
}
