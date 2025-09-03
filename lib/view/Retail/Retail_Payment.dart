// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:apple_pay_flutter/apple_pay_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_voucher_select_component.dart';
import 'package:slc/customcomponentfields/custom_form_builder/custom_form_builder.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/Retail/retail_confirmation_alert.dart';
import 'package:slc/view/Retail/web_page.dart';

import 'Retail_Page.dart';

class RetailPaymentPage extends StatefulWidget {
  int facilityId = 0;
  String retailItemSetId = "0";
  int tableNo = 0;
  String colorCode = "";
  List<FacilityItem> facilityItems = [];
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  double total = 0.0;
  double taxAmt = 0.0;
  double taxableAmt = 0.0;
  double totalAmount = 0.0;
  double netPayable = 0.0;
  double discountAmt = 0.0;
  double tipsAmt = 0;
  BillDiscounts discount = new BillDiscounts();
  GiftVocuher selectedVoucher = new GiftVocuher();
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  PaymentTerms paymentTerms = new PaymentTerms();
  bool showGiftCardRedeem = true;
  bool enablePayments = true;
  RetailPaymentPage(
      {Key key,
      this.facilityItems,
      this.itemCounts,
      this.total,
      this.facilityId,
      this.retailItemSetId,
      this.tableNo,
      this.colorCode,
      this.billDiscounts,
      this.giftVouchers,
      this.paymentTerms})
      : super(key: key);

  @override
  _RetailPayment createState() => _RetailPayment(
      facilityItems: facilityItems,
      itemCounts: itemCounts,
      total: total,
      facilityId: facilityId,
      retailItemSetId: retailItemSetId,
      tableNo: tableNo,
      colorCode: colorCode,
      billDiscounts: billDiscounts,
      giftVouchers: giftVouchers,
      paymentTerms: paymentTerms);
}

class _RetailPayment extends State<RetailPaymentPage> {
  static final borderColor = Colors.grey[200];
  var serverTestPath = URLUtils().getImageResultUrl();
  bool valuefirst = false;
  int facilityId = 0;
  String retailItemSetId = "0";
  int tableNo = 0;
  String colorCode = "";
  Utils util = new Utils();
  bool onPressedTimer = true;
  List<FacilityItem> facilityItems = [];
  List<BillDiscounts> billDiscounts = [];
  PaymentTerms paymentTerms = new PaymentTerms();
  HashMap<int, FacilityBeachRequest> itemCounts =
      new HashMap<int, FacilityBeachRequest>();
  double total = 0;
  double tipsAmount = 0;
  MaskedTextController _tipsAmountController =
      new MaskedTextController(mask: Strings.maskTipsStr);
  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);
  TextEditingController _giftCardText = new TextEditingController();
  TextEditingController _giftVoucherUsedAmount = new TextEditingController();

  // FlutterPay flutterPay = FlutterPay();
  ProgressBarHandler _handler;
  List<GiftVocuher> giftVouchers = [];
  String _vchErrorText = "";

  _RetailPayment(
      {this.facilityItems,
      this.itemCounts,
      this.total,
      this.facilityId,
      this.retailItemSetId,
      this.tableNo,
      this.colorCode,
      this.billDiscounts,
      this.giftVouchers,
      this.paymentTerms});
  @override
  Widget build(BuildContext context) {
    getTotal();
    if (giftVouchers != null && giftVouchers.length > 1) {
      widget.showGiftCardRedeem = true;
    } else {
      widget.showGiftCardRedeem = false;
    }
    // if (widget.billDiscounts != null && widget.billDiscounts.length > 0) {
    //   widget.discount = widget.billDiscounts[0];
    // }
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return Scaffold(
      backgroundColor: Colors.transparent,

      //canvasColor: Colors.transparent,
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
                builder: (context) => RetailPage(
                  facilityId: facilityId,
                  retailItemSetId: retailItemSetId,
                  facilityItems: [],
                  itemCounts: itemCounts,
                  tableNo: tableNo,
                  colorCode: colorCode,
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height * 0.99,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/beachorder.png"),
                    fit: BoxFit.cover)),
            child: SingleChildScrollView(
                child: Column(
              children: <Widget>[
                SizedBox(height: 5),
                Row(children: [getItemList(0, 0)]),
                SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width * .96,
                    margin: EdgeInsets.only(top: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(color: Colors.grey[200]),
                      color: Colors.white,
                    ),
                    child: Column(children: <Widget>[
                      Visibility(
                          visible:
                              widget.billDiscounts.length > 0 ? true : false,
                          child: ListTile(
                            leading: Icon(Icons.local_offer_outlined,
                                color: ColorData.toColor(widget.colorCode)),
                            title: Text(
                                widget.discount != null &&
                                        widget.discount.discountName != null
                                    ? widget.discount.discountName
                                    : 'Save with ' +
                                        billDiscounts.length.toString() +
                                        ' Offers',
                                style: TextStyle(
                                    color: ColorData.toColor(widget.colorCode),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                            trailing: new OutlinedButton(
                              onPressed: () {
                                displayDiscountModalBottomSheet(context);
                              },
                              child: new Text(
                                "View",
                                style: TextStyle(
                                    color: ColorData.toColor(widget.colorCode)),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )),
                      ListTile(
                        leading: Icon(Icons.local_offer_outlined,
                            color: ColorData.toColor(widget.colorCode)),
                        title: Text(tr("tipsAmount"),
                            style: TextStyle(
                                color: ColorData.toColor(widget.colorCode),
                                fontSize: Styles.packageExpandTextSiz,
                                fontFamily: tr('currFontFamily'))),
                        trailing: Container(
                            width: MediaQuery.of(context).size.width * 0.16,
                            height: MediaQuery.of(context).size.height * 0.045,
                            child: new TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _tipsAmountController,
                                textAlign: TextAlign.center,
                                decoration: new InputDecoration(
                                  contentPadding: EdgeInsets.all(5),
                                  // contentPadding: EdgeInsets.only(
                                  //     left: 10, top: 0, bottom: 0, right: 0),
                                  hintText: "TIPs",
                                  border: new OutlineInputBorder(
                                      borderSide: new BorderSide(
                                          color: Colors.black12)),
                                ),
                                onChanged: (value) {
                                  getTotal();
                                  setState(() {});
                                },
                                style: TextStyle(
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr("currFontFamilyEnglishOnly"),
                                    color: ColorData.primaryTextColor,
                                    fontWeight: FontWeight.w200))),
                      )
                    ])),
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
                                        color: ColorData.toColor(
                                            widget.colorCode)),
                                    title: Column(children: [
                                      Text(tr("gift_voucher_rdeem_amount"),
                                          style: TextStyle(
                                              color: ColorData.toColor(
                                                  widget.colorCode),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                      Text(_vchErrorText,
                                          style: TextStyle(
                                              color: ColorData.toColor(
                                                  widget.colorCode),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily: tr('currFontFamily')))
                                    ]),
                                    trailing: Container(
                                        width: MediaQuery.of(context).size.width *
                                            0.16,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.045,
                                        child: new TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller: _giftVoucherUsedAmount,
                                            textAlign: TextAlign.center,
                                            enabled: widget.selectedVoucher !=
                                                        null &&
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
                                                enteredAmt =
                                                    double.parse(value);
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.80,
                                  // tr("payment_terms_conditions")
                                  child: Text(paymentTerms.terms,
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor
                                              .withOpacity(1.0),
                                          fontSize: Styles.packageExpandTextSiz,
                                          fontFamily: tr('currFontFamily')))),
                            ],
                          ),
                        ),
                        Container(
                            margin: const EdgeInsets.only(top: 8, left: 25),
                            child: Row(children: [
                              Text(tr("dont_press_back_button"),
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 12))
                            ])),
                        Container(
                          margin: const EdgeInsets.only(top: 6, left: 8),
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
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(14)),
                                                ),
                                                content: SingleChildScrollView(
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
                                                            tr('discount_title'),
                                                            textAlign: TextAlign
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
                                                                style:
                                                                    ButtonStyle(
                                                                        foregroundColor:
                                                                            MaterialStateProperty.all<Color>(Colors
                                                                                .white),
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all<Color>(ColorData
                                                                                .grey300),
                                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
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
                                                              style:
                                                                  ButtonStyle(
                                                                      foregroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          Colors
                                                                              .white),
                                                                      backgroundColor: MaterialStateProperty.all<
                                                                              Color>(
                                                                          ColorData
                                                                              .colorBlue),
                                                                      shape: MaterialStateProperty.all<
                                                                              RoundedRectangleBorder>(
                                                                          RoundedRectangleBorder(
                                                                              borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            2.0),
                                                                      )))),
                                                              child: new Text(
                                                                tr("yes"),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: Styles
                                                                        .textSizeSmall,
                                                                    fontFamily:
                                                                        tr("currFontFamily")),
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
                                      } else {
                                        this.valuefirst = value;
                                      }
                                      setState(() {});
                                      /* Show Dialog End */
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
                      margin:
                          Localizations.localeOf(context).languageCode == "en"
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
                                                  double.tryParse(widget
                                                              .taxableAmt
                                                              .toStringAsFixed(
                                                                  2) ??
                                                          0)
                                                      .toStringAsFixed(2),
                                              // double.parse(
                                              //     (widget.taxableAmt +
                                              //             widget.taxAmt)
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(tr("Discount_amount"),
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  " " +
                                                      widget.discountAmt
                                                          .toStringAsFixed(2),
                                                  // double.parse(
                                                  //     widget.discountAmt
                                                  //         .toStringAsFixed(
                                                  //             2), (e) {
                                                  //   return 0;
                                                  // }).toStringAsFixed(2),
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
                              visible:
                                  widget.tipsAmt != null && widget.tipsAmt > 0
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
                                              child: Text(tr("tipTotal"),
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  " " +
                                                      widget.tipsAmt
                                                          .toStringAsFixed(2),
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.35,
                                          child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                  tr("gift_Voucher_amount"),
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  _giftVoucherUsedAmount.text !=
                                                          ""
                                                      ? " " +
                                                          double.parse(
                                                                  _giftVoucherUsedAmount
                                                                      .text)
                                                              .toStringAsFixed(
                                                                  2)
                                                      : "0.00",
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
                                                  double.tryParse(widget.taxAmt
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
                                    : double.parse(
                                        _giftVoucherUsedAmount.text)) >
                                0))
                    //To do

                    ? Container(
                        width: MediaQuery.of(context).size.width - 60,
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 8),
                        child: Column(children: [
                          Visibility(
                              visible: Platform.isIOS && widget.enablePayments,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black87),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      )))),
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
                                          padding: EdgeInsets.only(
                                              left: 2, right: 2),
                                          child: Icon(ApplePayIcon.apple_pay,
                                              color: Colors.white, size: 30)),
                                    ],
                                  ),
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
                                    CheckDistance withIn =
                                        await util.getLoc(context);
                                    if (!withIn.allow) {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr('info_msg'),
                                          tr("youare") +
                                              withIn.distance
                                                  .toStringAsFixed(2) +
                                              tr("from_beach"),
                                          context);
                                      Navigator.pop(context);
                                      return;
                                    }
                                    _handler.show();
                                    widget.enablePayments = false;
                                    setState(() {});
                                    List<int> selectedItems = [];
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
                                          : itemCounts[widget.facilityItems[i]
                                                  .facilityItemId]
                                              .quantity;
                                      if (itemCount > 0 &&
                                          selectedItems.indexOf(widget
                                                  .facilityItems[i]
                                                  .facilityItemId) ==
                                              -1) {
                                        selectedItems.add(widget
                                            .facilityItems[i].facilityItemId);
                                        FacilityBeachRequest item =
                                            new FacilityBeachRequest();
                                        item.facilityItemId = widget
                                            .facilityItems[i].facilityItemId;
                                        item.quantity = itemCount;
                                        item.price =
                                            widget.facilityItems[i].price;
                                        item.vatPercentage = widget
                                            .facilityItems[i].vatPercentage;
                                        item.comments = itemCounts[widget
                                                .facilityItems[i]
                                                .facilityItemId]
                                            .comments;
                                        facilityItemRequest.add(item);
                                      }
                                    }
                                    total = totalAmt;
                                    Meta m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityId,
                                            0,
                                            facilityItemRequest,
                                            widget.tableNo,
                                            billDiscount: widget.discount,
                                            discountAmt: widget.discountAmt,
                                            tipsAmount: widget.tipsAmt,
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
                                        print('{ key: $key, value: $val}');
                                        if (key == 'response') {
                                          //call apple pay
                                          Map payment =
                                              new Map<String, dynamic>.from(
                                                  val);
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
                                                    RetailConfirmationAlert(
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
                                          tr('error_caps'),
                                          m.statusMsg,
                                          context);
                                    }
                                  }
                                  // textColor: Colors.white,
                                  //color: Theme.of(context).primaryColor,
                                  )),
                          Visibility(
                              visible: widget.enablePayments,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            widget.colorCode == null
                                                ? Colors.blue[200]
                                                : ColorData.toColor(
                                                    widget.colorCode)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
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
                                // color: widget.colorCode == null
                                //     ? Colors.blue[200]
                                //     : ColorData.toColor(widget.colorCode),
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
                                  CheckDistance withIn =
                                      await util.getLoc(context);
                                  if (!withIn.allow) {
                                    util.customGetSnackBarWithOutActionButton(
                                        tr('info_msg'),
                                        tr("youare") +
                                            withIn.distance.toStringAsFixed(2) +
                                            tr("from_beach"),
                                        context);
                                    // Navigator.pop(context);
                                    return;
                                  }
                                  _handler.show();
                                  widget.enablePayments = false;
                                  setState(() {});
                                  List<int> selectedItems = [];
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
                                        : itemCounts[widget.facilityItems[i]
                                                .facilityItemId]
                                            .quantity;
                                    if (itemCount > 0 &&
                                        selectedItems.indexOf(widget
                                                .facilityItems[i]
                                                .facilityItemId) ==
                                            -1) {
                                      selectedItems.add(widget
                                          .facilityItems[i].facilityItemId);
                                      FacilityBeachRequest item =
                                          new FacilityBeachRequest();
                                      item.facilityItemId = widget
                                          .facilityItems[i].facilityItemId;
                                      item.quantity = itemCount;
                                      item.price =
                                          widget.facilityItems[i].price;
                                      item.vatPercentage =
                                          widget.facilityItems[i].vatPercentage;
                                      item.comments = itemCounts[widget
                                              .facilityItems[i].facilityItemId]
                                          .comments;
                                      facilityItemRequest.add(item);
                                    }
                                  }
                                  total = totalAmt;
                                  Meta m = await FacilityDetailRepository()
                                      .getEnquiryPaymentOrderRequest(
                                          widget.facilityId,
                                          0,
                                          facilityItemRequest,
                                          widget.tableNo,
                                          billDiscount: widget.discount,
                                          discountAmt: widget.discountAmt,
                                          tipsAmount: widget.tipsAmt,
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
                                                  : _giftVoucherUsedAmount
                                                              .text ==
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
                                      print('{ key: $key, value: $val}');
                                      if (key == 'response') {
                                        Map payment =
                                            new Map<String, dynamic>.from(val);
                                        var list = [];
                                        payment.entries.forEach((e) => {
                                              if (e.key == 'payment')
                                                {
                                                  list.add(e.value
                                                      .toString()
                                                      .replaceAll("href:", ''))
                                                },
                                            });
                                        var first = list[0]
                                            .toString()
                                            .replaceAll('{', "");
                                        if (payment["merchantIdentifier"] !=
                                            "") {
                                          openWebView(
                                              first.replaceAll("}", '').trim());
                                        } else {
                                          Navigator.of(context).pop();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RetailConfirmationAlert(
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
                              ))
                        ]),
                      )
                    : Container()
              ],
            ))),
        progressBar
      ]),
    );
  }

  Widget getItemList(int facilityId, int retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    List<int> selectedItem = [];
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 100, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.facilityItems.length,
                itemBuilder: (context, j) {
                  bool showItem = false;
                  if (itemCounts[widget.facilityItems[j].facilityItemId] !=
                      null) {
                    if (itemCounts[widget.facilityItems[j].facilityItemId]
                                .quantity >
                            0 &&
                        selectedItem.indexOf(
                                widget.facilityItems[j].facilityItemId) ==
                            -1) {
                      selectedItem.add(widget.facilityItems[j].facilityItemId);
                      showItem = true;
                    }
                  }
                  return Visibility(
                      visible: showItem,
                      /*itemCounts[
                                  widget.facilityItems[j].facilityItemId] ==
                              null
                          ? false
                          : itemCounts[widget.facilityItems[j].facilityItemId]
                                      .quantity >
                                  0
                              ? true
                              : false*/
                      child: Container(
                          margin: EdgeInsets.only(top: 5, left: 4, right: 3),
                          child: Stack(
                            children: [
                              SizedBox(height: 5),
                              Container(
                                height: itemCounts[widget.facilityItems[j]
                                                .facilityItemId] ==
                                            null ||
                                        itemCounts[widget.facilityItems[j]
                                                    .facilityItemId]
                                                .comments ==
                                            null ||
                                        itemCounts[widget.facilityItems[j]
                                                    .facilityItemId]
                                                .comments ==
                                            ""
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .17,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                          child: Image.network(
                                              // serverTestPath +
                                              //     "UploadDocument/FacilityItem/" +
                                              //     widget.facilityItems[j]
                                              //         .facilityItemId
                                              //         .toString() +
                                              //     "/HQ/" +
                                              //     widget.facilityItems[j]
                                              //         .imageUrl,
                                              serverTestPath +
                                                  "UploadDocument/FacilityItem/" +
                                                  // widget
                                                  //     .facilityItems[j].facilityItemId
                                                  //     .toString() +
                                                  // "/HQ/" +
                                                  widget.facilityItems[j]
                                                      .imageUrl,
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
                                                .facilityItemName,
                                            style: TextStyle(
                                                color: ColorData.toColor(
                                                    widget.colorCode),
                                                fontSize:
                                                    Styles.packageExpandTextSiz,
                                                fontFamily:
                                                    tr('currFontFamily')),
                                          )),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
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
                                              top: 77,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.26)
                                          : EdgeInsets.only(
                                              top: 77,
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
                                                fontFamily:
                                                    tr('currFontFamily')),
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
                                                      // fontStyle:
                                                      //     FontStyle.italic,
                                                      backgroundColor:
                                                          ColorData.toColor(
                                                              widget
                                                                  .colorCode))))

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
                                              top: 75,
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.68,
                                            )
                                          : EdgeInsets.only(
                                              top: 75,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.68,
                                            ),
                                      width: MediaQuery.of(context).size.width /
                                          3.8,
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: Localizations.localeOf(
                                                            context)
                                                        .languageCode ==
                                                    "en"
                                                ? EdgeInsets.only(
                                                    left:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                3.8) /
                                                            2.3,
                                                    top: 0)
                                                : EdgeInsets.only(
                                                    right:
                                                        (MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                3.8) /
                                                            2.3,
                                                    top: 0),
                                            child: new Text(
                                                (itemCounts[widget.facilityItems[j].facilityItemId] !=
                                                            null &&
                                                        itemCounts[widget.facilityItems[j].facilityItemId]
                                                                .quantity >
                                                            0)
                                                    ? ((itemCounts[widget
                                                                .facilityItems[
                                                                    j]
                                                                .facilityItemId]
                                                            .quantity
                                                            .toString()) +
                                                        (itemCounts[widget.facilityItems[j].facilityItemId]
                                                                    .quantity >
                                                                1
                                                            ? " (Nos)"
                                                            : " (No)"))
                                                    : "0",
                                                style: TextStyle(
                                                    color: ColorData.toColor(
                                                        widget.colorCode))),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                        visible: itemCounts[widget
                                                        .facilityItems[j]
                                                        .facilityItemId] ==
                                                    null ||
                                                itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .comments ==
                                                    null ||
                                                itemCounts[widget
                                                            .facilityItems[j]
                                                            .facilityItemId]
                                                        .comments ==
                                                    ""
                                            ? false
                                            : true,
                                        child: Container(
                                          height: 40,
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.18,
                                              left: 8,
                                              right: 8),
                                          padding: EdgeInsets.only(
                                              left: 8, right: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  itemCounts[widget.facilityItems[j].facilityItemId] ==
                                                              null ||
                                                          itemCounts[widget.facilityItems[j].facilityItemId]
                                                                  .comments ==
                                                              null
                                                      ? ""
                                                      : itemCounts[widget
                                                              .facilityItems[j]
                                                              .facilityItemId]
                                                          .comments,
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily')))),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )));
                })));
  }

  Widget getDiscountList() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 70, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.billDiscounts.length,
                itemBuilder: (context, j) {
                  return Visibility(
                      visible: true,
                      child: Container(
                          margin: EdgeInsets.only(left: 4, right: 3),
                          child: Padding(
                              padding: EdgeInsets.only(top: 0, bottom: 0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                      height: 30,
                                      child: Radio<BillDiscounts>(
                                        groupValue: widget.discount,
                                        value: billDiscounts[j],
                                        onChanged: (BillDiscounts value) {
                                          setState(() {
                                            widget.discount = value;
                                            getTotal();
                                          });
                                        },
                                      )),
                                  Text(billDiscounts[j].discountName,
                                      style: TextStyle(
                                          color: ColorData.primaryTextColor
                                              .withOpacity(1.0),
                                          fontSize: Styles.packageExpandTextSiz,
                                          fontFamily: tr('currFontFamily'))),
                                ],
                              ))));
                })));
  }

  void getTotal() {
    double totalAmt = 0;
    double totalAmtWithoutPromotion = 0;
    widget.taxAmt = 0;
    widget.taxableAmt = 0;
    widget.discountAmt = 0;
    widget.totalAmount = 0;
    widget.total = 0;

    if (_tipsAmountController.text.isEmpty) {
      widget.tipsAmt = 0;
    } else {
      widget.tipsAmt = double.parse(_tipsAmountController.text);
    }
    List<int> selectedItem = [];
    for (int i = 0; i < widget.facilityItems.length; i++) {
      // double taxableAmt = 0;
      double itemDiscountAmt = 0.0;
      // double itemDiscount = 0.0;
      double taxAmt = 0;
      if (selectedItem.indexOf(widget.facilityItems[i].facilityItemId) == -1) {
        int itemCount =
            itemCounts[widget.facilityItems[i].facilityItemId] == null
                ? 0
                : itemCounts[widget.facilityItems[i].facilityItemId].quantity;
        double taxableAmt = 0;
        if (widget.facilityItems[i].isDiscountable) {
          totalAmtWithoutPromotion =
              (widget.facilityItems[i].price * itemCount);
          if (widget.discount != null &&
              widget.discount.discountValue != null) {
            if (widget.discount.discountValue > 0) {
              if (widget.discount.discountType == 1) {
                double discountPerc = (widget.discount.discountValue / 100.0);
                itemDiscountAmt =
                    double.parse(totalAmtWithoutPromotion.toStringAsFixed(2)) *
                        discountPerc;
                itemDiscountAmt = roundDouble(
                    double.parse(itemDiscountAmt.toStringAsFixed(3)), 2);
              }
            }
          }
        }
        // double taxBeforeDis = 0;
        if (widget.facilityItems[i].vatPercentage != null) {
          taxAmt = roundDouble(
              (((widget.facilityItems[i].price * itemCount) - itemDiscountAmt) /
                      (1 + (widget.facilityItems[i].vatPercentage / 100.00))) *
                  (widget.facilityItems[i].vatPercentage / 100),
              2);
        }
        if (widget.facilityItems[i].vatPercentage == null) {
          taxableAmt = (widget.facilityItems[i].price * itemCount);
        } else {
          if (itemDiscountAmt > 0) {
            taxableAmt = (widget.facilityItems[i].price * itemCount) - taxAmt;
          } else {
            taxableAmt = ((widget.facilityItems[i].price * itemCount) /
                (1 + (widget.facilityItems[i].vatPercentage / 100.00)));
          }
        }
        widget.taxableAmt = widget.taxableAmt + taxableAmt;
        widget.discountAmt = widget.discountAmt + itemDiscountAmt;
        totalAmt = totalAmt + taxableAmt + taxAmt - itemDiscountAmt;
        widget.taxAmt = widget.taxAmt + taxAmt;
        selectedItem.add(widget.facilityItems[i].facilityItemId);
      }
    }
    widget.totalAmount = totalAmt;
    widget.netPayable = totalAmt -
        (_giftVoucherUsedAmount.text == ""
            ? 0
            : double.parse(_giftVoucherUsedAmount.text));
    total = (widget.netPayable + widget.tipsAmt);
    widget.total = (widget.netPayable + widget.tipsAmt);
  }

  double roundDouble(double value, int places) {
    int indx = value.toString().indexOf(".");
    double decimalValue = 0;
    String val = value.toStringAsFixed(3);
    debugPrint(" value :" + value.toString() + " index " + indx.toString());
    if (indx > -1) {
      val = value.toString().substring(indx + 1);
      debugPrint("val " + val);
      if (val.length > 2) {
        String threeDec = val.substring(0, 3);
        //debugPrint(" 3 dec" + threeDec);
        String lastChar = threeDec.substring(2);
        //debugPrint(" last char" + lastChar);
        String twoDigits = threeDec.substring(0, 2);
        val = value.toString().substring(0, indx) + "." + twoDigits.toString();
        if (int.parse(lastChar) >= 5) {
          decimalValue = double.parse(val) + 0.01;
          val = decimalValue.toString();
        }
      } else {
        val = value.toString();
      }
    } else {
      val = value.toString();
    }
    return double.parse(val);
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RetailWebviewPage(
                  title: tr("payment"),
                  url: val,
                  facilityId: widget.facilityId,
                  facilityItems: widget.facilityItems,
                ))).then((value) {
      widget.enablePayments = true;
      setState(() {});
    });
  }

  Widget getHtml(String description) {
    return Html(
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
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
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
            fontSize: FontSize(Styles.newTextSize),
            fontWeight: FontWeight.normal,
            color: ColorData.cardTimeAndDateColor,
            fontFamily: tr('currFontFamilyEnglishOnly'),
          ),
        },
        data: (description != null
            ? "<html><body>" + description + "</body></html>"
            : tr('noDataFound')));
  }

  // _onChangeOptionDropdown(BillDiscounts discount) {
  //   setState(() {
  //     _clearOptionGiftVoucher();
  //     widget.discount = discount;
  //     getTotal();
  //   });
  // }

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
  //                                       ? ColorData.toColor(widget.colorCode)
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
                                        ? ColorData.toColor(widget.colorCode)
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
                                              if (widget.showGiftCardRedeem) {
                                                _clearOptionGiftVoucher();
                                              }
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
                                                                height: MediaQuery
                                                                            .of(
                                                                                context)
                                                                        .size
                                                                        .height *
                                                                    0.080,
                                                                child:
                                                                    new TextFormField(
                                                                        keyboardType:
                                                                            TextInputType
                                                                                .text,
                                                                        textInputAction:
                                                                            TextInputAction
                                                                                .done,
                                                                        enableInteractiveSelection:
                                                                            false,
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
                                                                  //         BorderRadius.all(Radius.circular(
                                                                  //             5.0))),
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
                                                                  //         BorderRadius.all(
                                                                  //             Radius.circular(
                                                                  //                 5.0))),
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

  _onChangeOptionVoucherDropdown(GiftVocuher voucher) {
    setState(() {
      _giftVoucherUsedAmount.text = "0";
      getTotal();
      widget.selectedVoucher = voucher;
      if (widget.total - widget.tipsAmt >= voucher.balanceAmount) {
        _giftVoucherUsedAmount.text = voucher.balanceAmount.toStringAsFixed(2);
      } else if (widget.total - widget.tipsAmt < voucher.balanceAmount) {
        _giftVoucherUsedAmount.text =
            (widget.total - widget.tipsAmt).toStringAsFixed(2);
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
      double totalAmt = widget.netPayable == null ? 0 : widget.netPayable;
      if (voucherBalance >= 100 && enteredAmt < 100) {
        result = 1;
        return result;
      }
      if (voucherBalance > totalAmt && widget.netPayable < 0) {
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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RetailConfirmationAlert(
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
