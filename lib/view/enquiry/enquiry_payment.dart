// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as uiprefix;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_voucher_select_component.dart';
import 'package:slc/customcomponentfields/custom_form_builder/custom_form_builder.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/enquiry/web_page.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/enquiry/enquiry_confirmation_alert.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:apple_pay_flutter/apple_pay_flutter.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';

class EnquiryPayment extends StatefulWidget {
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  EnquiryDetailResponse enquiryDetail;
  double total = 0;
  double taxableAmt = 0;
  double taxAmt = 0;
  double discountAmt = 0;
  UserProfileInfo userProfileInfo = new UserProfileInfo();
  bool saveInProgress = false;
  BillDiscounts discount = new BillDiscounts();
  GiftVocuher selectedVoucher = new GiftVocuher();
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  bool showGiftCardRedeem = true;
  bool enablePayments = true;
  PaymentTerms paymentTerms = new PaymentTerms();
  EnquiryPayment(
      {Key key,
      this.facilityItem,
      this.facilityDetail,
      this.enquiryDetail,
      this.userProfileInfo,
      this.billDiscounts,
      this.giftVouchers,
      this.paymentTerms})
      : super(key: key);

  @override
  _EnquiryPaymentPage createState() => _EnquiryPaymentPage(
      facilityItem: facilityItem,
      facilityDetail: facilityDetail,
      enquiryDetail: enquiryDetail,
      userProfileInfo: userProfileInfo,
      billDiscounts: billDiscounts,
      giftVouchers: giftVouchers,
      paymentTerms: paymentTerms);
}

class _EnquiryPaymentPage extends State<EnquiryPayment> {
  bool valuefirst = false;
  FacilityItems facilityItem;
  FacilityDetailResponse facilityDetail;
  EnquiryDetailResponse enquiryDetail;
  UserProfileInfo userProfileInfo;
  Utils util = new Utils();
  bool saveInProgress = false;
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);
  TextEditingController _giftCardText = new TextEditingController();

  // MaskedTextController _giftVoucherAmount =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  TextEditingController _giftVoucherUsedAmount = new TextEditingController();

  // FlutterPay flutterPay = FlutterPay();
  ProgressBarHandler _handler;
  String _vchErrorText = "";
  PaymentTerms paymentTerms = new PaymentTerms();

  _EnquiryPaymentPage(
      {this.facilityItem,
      this.facilityDetail,
      this.enquiryDetail,
      this.userProfileInfo,
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
              widget.facilityDetail.facilityId == Constants.FacilityMembership
                  ? Row(children: [getMembershipEnquiryDetails()])
                  : Row(children: [getEnquiryDetails()]),
              widget.facilityDetail.facilityId == Constants.FacilityMembership
                  ? SizedBox(height: 5)
                  : Visibility(visible: false, child: Text("")),
              widget.facilityDetail.facilityId == Constants.FacilityMembership
                  ? Container(
                      margin: EdgeInsets.only(top: 5, left: 8, right: 8),
                      child: Stack(
                        children: [
                          SizedBox(height: 5),
                          Container(
                            height: MediaQuery.of(context).size.height * .12,
                            width: MediaQuery.of(context).size.width * .98,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Colors.grey[200]),
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
                                        widget.userProfileInfo
                                                    .facilityItemName ==
                                                null
                                            ? ""
                                            : widget.userProfileInfo
                                                .facilityItemName,
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
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
                                      : const EdgeInsets.only(
                                          top: 40, right: 10),
                                  child: Row(
                                    children: [
                                      Text(
                                          'AED ' +
                                              (widget.userProfileInfo.price ==
                                                      null
                                                  ? ""
                                                  : widget.userProfileInfo.price
                                                      .toStringAsFixed(2)),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              fontFamily:
                                                  tr('currFontFamily'))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))
                  : Visibility(visible: false, child: Text("")),
              widget.facilityDetail.facilityId == Constants.FacilityMembership
                  ? Row(children: [
                      getMembershipItemList(widget.facilityDetail.facilityId, 0)
                    ])
                  : Visibility(visible: false, child: Text("")),
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
                                          widget.facilityDetail.colorCode)),
                                  title: Column(children: [
                                    Text(tr("gift_voucher_rdeem_amount"),
                                        style: TextStyle(
                                            color: ColorData.toColor(widget
                                                .facilityDetail.colorCode),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily'))),
                                    Text(_vchErrorText,
                                        style: TextStyle(
                                            color: ColorData.toColor(widget
                                                .facilityDetail.colorCode),
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
                                          textAlign: TextAlign.center,
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
                                            //    ,
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
                                                0.35,
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
                      (widget.total != 0 ||
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
                              // color: Colors.black,
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
                                Meta m;
                                if (!widget.saveInProgress) {
                                  widget.saveInProgress = true;
                                  _handler.show();
                                  widget.enablePayments = false;
                                  setState(() {});
                                  if (widget.facilityDetail.facilityId ==
                                      Constants.FacilityMembership) {
                                    // double totalAmt = 0;
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    FacilityBeachRequest item =
                                        new FacilityBeachRequest();
                                    item.facilityItemId =
                                        widget.userProfileInfo.facilityItemId;
                                    item.quantity = 1;
                                    item.price = widget.userProfileInfo.price;
                                    item.vatPercentage =
                                        widget.userProfileInfo.vatPercentage;
                                    facilityItemRequest.add(item);
                                    for (int i = 0;
                                        i <
                                            widget.userProfileInfo
                                                .associatedProfileList.length;
                                        i++) {
                                      int itemCount = 1;
                                      if (itemCount > 0) {
                                        FacilityBeachRequest item =
                                            new FacilityBeachRequest();
                                        item.facilityItemId = widget
                                            .userProfileInfo
                                            .associatedProfileList[i]
                                            .facilityItemId;
                                        item.quantity = itemCount;
                                        item.price = widget.userProfileInfo
                                            .associatedProfileList[i].price;
                                        item.vatPercentage = widget
                                            .userProfileInfo
                                            .associatedProfileList[i]
                                            .vatPercentage;
                                        facilityItemRequest.add(item);
                                      }
                                    }
                                    // double total = widget.total;
                                    m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityDetail.facilityId,
                                            widget
                                                .enquiryDetail.enquiryDetailId,
                                            facilityItemRequest,
                                            0,
                                            discountAmt: widget.discountAmt,
                                            billDiscount: widget.discount,
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
                                  } else {
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityDetail.facilityId,
                                            widget
                                                .enquiryDetail.enquiryDetailId,
                                            facilityItemRequest,
                                            0,
                                            discountAmt: widget.discountAmt,
                                            billDiscount: widget.discount,
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
                                  }
                                  if (m.statusCode == 200) {
                                    _handler.dismiss();
                                    // ignore: unnecessary_statements
                                    widget.saveInProgress = false;
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
                                                  EnquiryConfirmationAlert(
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
                                    widget.saveInProgress = false;
                                  }
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
                                Meta m;
                                if (!widget.saveInProgress) {
                                  widget.saveInProgress = true;
                                  _handler.show();
                                  widget.enablePayments = false;
                                  setState(() {});
                                  if (widget.facilityDetail.facilityId ==
                                      Constants.FacilityMembership) {
                                    // double totalAmt = 0;
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    FacilityBeachRequest item =
                                        new FacilityBeachRequest();
                                    item.facilityItemId =
                                        widget.userProfileInfo.facilityItemId;
                                    item.quantity = 1;
                                    item.price = widget.userProfileInfo.price;
                                    item.vatPercentage =
                                        widget.userProfileInfo.vatPercentage;
                                    facilityItemRequest.add(item);
                                    for (int i = 0;
                                        i <
                                            widget.userProfileInfo
                                                .associatedProfileList.length;
                                        i++) {
                                      int itemCount = 1;
                                      if (itemCount > 0) {
                                        FacilityBeachRequest item =
                                            new FacilityBeachRequest();
                                        item.facilityItemId = widget
                                            .userProfileInfo
                                            .associatedProfileList[i]
                                            .facilityItemId;
                                        item.quantity = itemCount;
                                        item.price = widget.userProfileInfo
                                            .associatedProfileList[i].price;
                                        item.vatPercentage = widget
                                            .userProfileInfo
                                            .associatedProfileList[i]
                                            .vatPercentage;
                                        facilityItemRequest.add(item);
                                      }
                                    }
                                    double total = widget.total;
                                    m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityDetail.facilityId,
                                            widget
                                                .enquiryDetail.enquiryDetailId,
                                            facilityItemRequest,
                                            0,
                                            discountAmt: widget.discountAmt,
                                            billDiscount: widget.discount,
                                            tipsAmount: 0,
                                            grossAmount: widget.taxableAmt,
                                            taxAmount: widget.taxAmt,
                                            netAmount: widget.total,
                                            deliveryAmount: 0,
                                            deliveryTaxAmount: 0,
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
                                  } else {
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityDetail.facilityId,
                                            widget
                                                .enquiryDetail.enquiryDetailId,
                                            facilityItemRequest,
                                            0,
                                            discountAmt: widget.discountAmt,
                                            billDiscount: widget.discount,
                                            tipsAmount: 0,
                                            grossAmount: widget.taxableAmt,
                                            taxAmount: widget.taxAmt,
                                            netAmount: widget.total,
                                            deliveryAmount: 0,
                                            deliveryTaxAmount: 0,
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
                                  }
                                }
                                if (m.statusCode == 200) {
                                  // ignore: unnecessary_statements
                                  widget.saveInProgress = false;
                                  _handler.dismiss();
                                  Map<String, dynamic> decode = m.toJson();
                                  print('12' + decode['statusMsg']);
                                  Map userMap = jsonDecode(decode['statusMsg']);
                                  print(userMap);
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
                                      if (payment["merchantIdentifier"] != "") {
                                        openWebView(
                                            first.replaceAll("}", '').trim());
                                      } else {
                                        Navigator.of(context).pop();
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EnquiryConfirmationAlert(
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
                                  widget.saveInProgress = false;
                                  widget.enablePayments = true;
                                  setState(() {});
                                  util.customGetSnackBarWithOutActionButton(
                                      tr('error_caps'), m.statusMsg, context);
                                }
                              },
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

  Widget getEnquiryDetails() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8),
        height: widget.facilityDetail.facilityId == Constants.FacilityMembership
            ? MediaQuery.of(context).size.height * 0.274
            : MediaQuery.of(context).size.height * 0.205,
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
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.60,
              child: SingleChildScrollView(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [getHtml(widget.facilityItem.description)])),
            ),
            Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(
                      top: 120, left: MediaQuery.of(context).size.width * 0.35)
                  : EdgeInsets.only(
                      top: 120,
                      right: MediaQuery.of(context).size.width * 0.35),
              height: MediaQuery.of(context).size.height * 0.9,
              width: MediaQuery.of(context).size.width * 0.60,
              child: Text(
                widget.enquiryDetail != null &&
                        widget.enquiryDetail.firstName != null
                    ? widget.enquiryDetail.firstName
                    : "",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getMembershipEnquiryDetails() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: Directionality(
            textDirection: uiprefix.TextDirection.ltr,
            child: Container(
                // margin: EdgeInsets.only(left: 1),
                height: MediaQuery.of(context).size.height * 0.27,
                width: MediaQuery.of(context).size.width * 0.96,
                margin: EdgeInsets.only(left: 8, right: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    // width: 1,
                    color: Colors.grey[200],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                /*decoration: BoxDecoration(
                                            border: Border.all(
                                              // width: 1,
                                              color: Colors.grey[400],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),*/
                child: Material(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  //elevation: 5.0,
                  color: Colors.white,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        child: Image.asset('assets/images/MembershipCard.png',
                            height: MediaQuery.of(context).size.height * 0.27,
                            width: MediaQuery.of(context).size.width * 0.93,
                            fit: BoxFit.fill),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: 10),
                        child: Row(children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    tr('tentative'),
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor,
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')),
                                  ))),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.02,
                            left: 10),
                        child: Row(children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Text(
                                tr('customer_id') +
                                    ':' +
                                    (widget.userProfileInfo.customerId == null
                                            ? ""
                                            : widget.userProfileInfo.customerId)
                                        .toString(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorData.primaryTextColor,
                                    fontSize: Styles.loginBtnFontSize,
                                    fontFamily: tr('currFontFamily')),
                              )),
                          // Container(
                          //     width: MediaQuery.of(context).size.width * 0.40,
                          //     height: MediaQuery.of(context).size.height * 0.03,
                          //     child: Text(
                          //       widget.userProfileInfo.customerId == null
                          //           ? ""
                          //           : widget.userProfileInfo.customerId
                          //               .toString(),
                          //       textAlign: TextAlign.start,
                          //       style: TextStyle(
                          //           color: ColorData.primaryTextColor,
                          //           fontSize: Styles.loginBtnFontSize,
                          //           fontFamily: tr('currFontFamily')),
                          //     ))
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.05,
                            left: 10),
                        child: Row(children: [
                          Container(
                              width: MediaQuery.of(context).size.width * 0.60,
                              height: MediaQuery.of(context).size.height * 0.03,
                              child: Text(
                                'Name : ' +
                                    (widget.userProfileInfo.firstName == null
                                        ? ""
                                        : widget.userProfileInfo.firstName +
                                            ' ' +
                                            widget.userProfileInfo.lastName),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: ColorData.primaryTextColor,
                                    fontSize: Styles.loginBtnFontSize,
                                    fontFamily: tr('currFontFamily')),
                              )),
                        ]),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.10,
                            left: MediaQuery.of(context).size.width * 0.25),
                        child: Column(children: [
                          Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.68,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                child: Text(
                                  'Membership ID : ' +
                                      (widget.userProfileInfo
                                                  .membershipNumber ==
                                              null
                                          ? ""
                                          : widget.userProfileInfo
                                              .membershipNumber),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor,
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                )),
                          ]),
                          Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.68,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                child: Text(
                                  'Type: ' +
                                      (widget.userProfileInfo
                                                  .facilityItemName ==
                                              null
                                          ? ""
                                          : widget.userProfileInfo
                                              .facilityItemName),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor,
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                )),
                          ]),
                          Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.68,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                child: Text(
                                  tr('valid_from') +
                                      ' : ' +
                                      (widget.userProfileInfo
                                                  .membershipStartDate ==
                                              null
                                          ? ""
                                          : DateTimeUtils().dateToStringFormat(
                                              DateTimeUtils().stringToDate(
                                                  widget.userProfileInfo
                                                      .membershipStartDate
                                                      .substring(0, 10),
                                                  DateTimeUtils
                                                      .YYYY_MM_DD_Format),
                                              DateTimeUtils.DD_MM_YYYY_Format)),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor,
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                )),
                          ]),
                          Row(children: [
                            Container(
                                width: MediaQuery.of(context).size.width * 0.68,
                                height:
                                    MediaQuery.of(context).size.height * 0.03,
                                child: Text(
                                  tr('valid_until') +
                                      ': ' +
                                      (widget.userProfileInfo
                                                  .membershipEndDate ==
                                              null
                                          ? ""
                                          : DateTimeUtils().dateToStringFormat(
                                              DateTimeUtils().stringToDate(
                                                  widget.userProfileInfo
                                                      .membershipEndDate
                                                      .substring(0, 10),
                                                  DateTimeUtils
                                                      .YYYY_MM_DD_Format),
                                              DateTimeUtils.DD_MM_YYYY_Format)),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor,
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                )),
                          ])
                        ]),
                      ),
                    ],
                  ),
                ))));
  }

  Widget getMembershipItemList(int facilityId, int facilityItemGroupId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints:
                BoxConstraints(minHeight: 0, minWidth: double.infinity),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: widget.userProfileInfo.associatedProfileList.length,
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
                                                    .userProfileInfo
                                                    .associatedProfileList[j]
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
                                                      top: 40,
                                                      left: 10,
                                                      right: 10)
                                                  : const EdgeInsets.only(
                                                      top: 40,
                                                      right: 10,
                                                      left: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  'Start Date ' +
                                                      DateTimeUtils().dateToStringFormat(
                                                          DateTimeUtils().stringToDate(
                                                              widget
                                                                  .userProfileInfo
                                                                  .associatedProfileList[
                                                                      j]
                                                                  .subContractStartDate
                                                                  .substring(
                                                                      0, 10),
                                                              DateTimeUtils
                                                                  .YYYY_MM_DD_Format),
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .packageExpandTextSiz,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                              Text(
                                                  'End Date ' +
                                                      DateTimeUtils().dateToStringFormat(
                                                          DateTimeUtils().stringToDate(
                                                              widget
                                                                  .userProfileInfo
                                                                  .associatedProfileList[
                                                                      j]
                                                                  .subContractEndDate
                                                                  .substring(
                                                                      0, 10),
                                                              DateTimeUtils
                                                                  .YYYY_MM_DD_Format),
                                                          DateTimeUtils
                                                              .DD_MM_YYYY_Format),
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
                                                          .userProfileInfo
                                                          .associatedProfileList[
                                                              j]
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
      // customFont: tr('currFontFamilyEnglishOnly'),
      // anchorColor: ColorData.primaryTextColor,
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
          fontSize: FontSize(Styles.newTextSize),
          fontWeight: FontWeight.normal,
          color: ColorData.cardTimeAndDateColor,
          fontFamily: tr('currFontFamilyEnglishOnly'),
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
        ),
      },
      data: description != null
          ? "<html><body>" + description + "</body></html>"
          : tr('noDataFound'),
    ));
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EnquiryWebviewPage(
                title: tr("payment"),
                url: val,
                facilityId: widget.facilityDetail.facilityId,
                facilityItem: widget.facilityItem,
                enquiryDetail: widget.enquiryDetail))).then((value) {
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

  void getTotal() {
    double itemDiscountAmt = 0;
    double taxableAmt = 0;
    double taxAmt = 0;
    widget.taxAmt = 0;
    widget.taxableAmt = 0;
    widget.total = 0;
    widget.discountAmt = 0;
    if (facilityDetail.facilityId == Constants.FacilityMembership) {
      if (userProfileInfo.rate != null) {
        if (userProfileInfo.vatPercentage == null) {
          taxableAmt = (userProfileInfo.rate);
        } else {
          taxableAmt = (userProfileInfo.rate);
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
        if (userProfileInfo.vatPercentage != null) {
          taxAmt = (taxableAmt - itemDiscountAmt) *
              (userProfileInfo.vatPercentage / 100);
        }
        widget.taxableAmt = widget.taxableAmt + taxableAmt;
        widget.taxAmt = widget.taxAmt + taxAmt;
        widget.discountAmt = widget.discountAmt + itemDiscountAmt;
        widget.total = widget.total + (taxableAmt - itemDiscountAmt + taxAmt);
        for (int i = 0;
            i < widget.userProfileInfo.associatedProfileList.length;
            i++) {
          if (widget.userProfileInfo.associatedProfileList[i].vatPercentage ==
              null) {
            taxableAmt = (widget.userProfileInfo.associatedProfileList[i].rate);
          } else {
            taxableAmt = (widget.userProfileInfo.associatedProfileList[i].rate);
          }
          if (widget.discount != null &&
              widget.discount.discountValue != null) {
            if (widget.discount.discountValue > 0) {
              if (widget.discount.discountType == 1) {
                // widget.discountAmt =
                //     (widget.total * (widget.discount.discountValue / 100));
                itemDiscountAmt = double.parse(roundDouble(
                        (taxableAmt * (widget.discount.discountValue / 100.0)),
                        2)
                    .toStringAsFixed(2));
              }
              /*else {
              widget.discountAmt = widget.discount.discountValue;
            }*/
            }
          }
          if (widget.userProfileInfo.associatedProfileList[i].vatPercentage !=
              null) {
            taxAmt = (taxableAmt - itemDiscountAmt) *
                (widget.userProfileInfo.associatedProfileList[i].vatPercentage /
                    100);
          }
          widget.taxableAmt = widget.taxableAmt + taxableAmt;
          widget.taxAmt = widget.taxAmt + taxAmt;
          widget.discountAmt = widget.discountAmt + itemDiscountAmt;
          widget.total = widget.total +
              (taxableAmt - itemDiscountAmt + taxAmt) -
              (_giftVoucherUsedAmount.text == ""
                  ? 0
                  : double.parse(_giftVoucherUsedAmount.text));
        }
      }
    } else {
      if (enquiryDetail.vatPercentage == null) {
        if (enquiryDetail.rate != null && enquiryDetail.rate > 0) {
          taxableAmt = (enquiryDetail.rate);
        } else {
          taxableAmt = (enquiryDetail.price);
        }
      } else {
        if (enquiryDetail.rate != null && enquiryDetail.rate > 0) {
          taxableAmt = (enquiryDetail.rate);
        } else {
          taxableAmt = (enquiryDetail.price) /
              (1 + (enquiryDetail.vatPercentage / 100.00));
        }
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
      if (enquiryDetail.vatPercentage != null) {
        taxAmt = (taxableAmt - itemDiscountAmt) *
            (enquiryDetail.vatPercentage / 100);
      }
      widget.taxableAmt = widget.taxableAmt + taxableAmt;
      widget.taxAmt = widget.taxAmt + taxAmt;
      widget.discountAmt = widget.discountAmt + itemDiscountAmt;
      widget.total = widget.total +
          (taxableAmt - itemDiscountAmt + taxAmt) -
          (_giftVoucherUsedAmount.text == ""
              ? 0
              : double.parse(_giftVoucherUsedAmount.text));
    }
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

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
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EnquiryConfirmationAlert(
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
