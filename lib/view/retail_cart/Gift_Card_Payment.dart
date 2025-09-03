// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as uiprefix;
import 'package:flutter/services.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/view/retail_cart/Gift_Card_Page.dart';
import 'package:slc/view/retail_cart/retail_cart_confirmation_alert.dart';
import 'package:slc/view/retail_cart/web_page.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/custom_address_select_component.dart';
import 'package:slc/common/custom_voucher_select_component.dart';
import 'package:slc/common/custom_city_select_component.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:apple_pay_flutter/apple_pay_flutter.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';

class GiftCardPaymentPage extends StatefulWidget {
  int facilityId = 0;
  int retailItemSetId = 0;
  int tableNo = 0;
  GiftCardImage giftCardImage = new GiftCardImage();
  GiftCardCategory giftCardCategory = new GiftCardCategory();
  GiftCardItemsPrice giftCardPrice = new GiftCardItemsPrice();
  String giftCardText = "";
  GiftCardCategory giftTo = new GiftCardCategory();
  String sharedMobileNo = "";
  double total = 0;
  double taxAmt = 0;
  double taxableAmt = 0;
  double deliveryTaxableAmt = 0;
  double giftUsedVoucherAmout = 0;
  String colorCode = "";
  bool showDeliveryAddress = false;
  bool showPickupAddress = false;
  bool showGiftCardRedeem = false;
  List<DeliveryAddress> deliveryAddresses = []; //new  List<DeliveryAddress>();
  List<DeliveryCharges> deliveryCharges = []; // new List<DeliveryCharges>();
  double discountAmt = 0;
  BillDiscounts discount = new BillDiscounts();
  GiftVocuher selectedVoucher = new GiftVocuher();
  List<BillDiscounts> billDiscounts = []; // new List<BillDiscounts>();
  List<GiftVocuher> giftVouchers = [];
  PaymentTerms paymentTerms = new PaymentTerms();
  bool enablePayments = true;
  GiftCardPaymentPage(
      {Key key,
      this.giftCardImage,
      this.giftCardCategory,
      this.giftCardPrice,
      this.giftCardText,
      this.giftTo,
      this.sharedMobileNo,
      this.total,
      this.facilityId,
      this.retailItemSetId,
      this.tableNo,
      this.colorCode,
      this.deliveryAddresses,
      this.deliveryCharges,
      this.billDiscounts,
      this.giftVouchers,
      this.paymentTerms})
      : super(key: key);

  @override
  _GiftCardPayment createState() => _GiftCardPayment(
      giftCardCategory: giftCardCategory,
      giftCardImage: giftCardImage,
      giftCardPrice: giftCardPrice,
      giftCardText: giftCardText,
      giftTo: giftTo,
      sharedMobileNo: sharedMobileNo,
      total: total,
      facilityId: facilityId,
      retailItemSetId: retailItemSetId,
      tableNo: tableNo,
      colorCode: colorCode,
      deliveryAddresses: deliveryAddresses,
      deliveryCharges: deliveryCharges,
      billDiscounts: billDiscounts,
      giftVouchers: giftVouchers,
      paymentTerms: paymentTerms);
}

class _GiftCardPayment extends State<GiftCardPaymentPage> {
  double screenHeight = 0.0;
  double carouselHeight = 0.0;
  double menuHeight = 0.0;
  double contentHeight = 0.0;
  double buttonHeight = 0.0;

  // static final borderColor = Colors.grey[200];
  GiftCardImage giftCardImage = new GiftCardImage();
  GiftCardCategory giftCardCategory = new GiftCardCategory();
  GiftCardItemsPrice giftCardPrice = new GiftCardItemsPrice();
  String giftCardText = "";
  GiftCardCategory giftTo = new GiftCardCategory();
  String sharedMobileNo = "";
  var serverTestPath = URLUtils().getImageResultUrl();
  // int _value = 0;
  bool valuefirst = false;
  int facilityId = 0;
  int retailItemSetId = 0;
  int tableNo = 0;
  Utils util = new Utils();
  double total = 0;
  String colorCode = "";
  int deliveryAddressId = 0;
  List<DeliveryAddress> deliveryAddresses = []; // new List<DeliveryAddress>();
  List<DeliveryCharges> deliveryCharges = []; // new List<DeliveryCharges>();
  List<BillDiscounts> billDiscounts = []; // new List<BillDiscounts>();
  List<GiftVocuher> giftVouchers = []; // new List<BillDiscounts>();
  PaymentTerms paymentTerms = new PaymentTerms();
  MaskedTextController _deliveryAddress =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  MaskedTextController _streetName =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  MaskedTextController _contactNo =
      new MaskedTextController(mask: Strings.maskMobileValidationStr);

  MaskedTextController _landmark =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  MaskedTextController _city =
      new MaskedTextController(mask: Strings.maskEngValidationStr);

  MaskedTextController _deliveryNotes =
      new MaskedTextController(mask: Strings.maskEngCommentValidationStr);
  DeliveryCharges selectedDeliveryCharges = new DeliveryCharges();
  // MaskedTextController _billDiscount =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);

  TextEditingController _giftCardText = new TextEditingController();

  // MaskedTextController _giftVoucherAmount =
  //     new MaskedTextController(mask: Strings.maskEngCommentValidationStr);

  TextEditingController _giftVoucherUsedAmount = new TextEditingController();

  // FlutterPay flutterPay = FlutterPay();
  ProgressBarHandler _handler;
  // String _platformVersion = 'Unknown';
  String _vchErrorText = "";
  _GiftCardPayment(
      {this.giftCardCategory,
      this.giftCardImage,
      this.giftCardPrice,
      this.giftCardText,
      this.giftTo,
      this.sharedMobileNo,
      this.total,
      this.facilityId,
      this.retailItemSetId,
      this.tableNo,
      this.colorCode,
      this.deliveryAddresses,
      this.deliveryCharges,
      this.billDiscounts,
      this.giftVouchers,
      this.paymentTerms});
  @override
  Widget build(BuildContext context) {
    getTotal();
    screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 55);
    carouselHeight = Platform.isIOS
        ? screenHeight * (43.0 / 100.0)
        : screenHeight * (40.0 / 100.0);
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
                builder: (context) =>
                    GiftCardPage(facilityId: facilityId, colorCode: colorCode),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/beachorder.png"),
                    fit: BoxFit.cover)),
          ),
          Container(
            child: SingleChildScrollView(
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
                                  color: ColorData.toColor(widget.colorCode)),
                              title: Text(
                                  widget.discount != null &&
                                          widget.discount.discountName != null
                                      ? widget.discount.discountName
                                      : 'Save with ' +
                                          billDiscounts.length.toString() +
                                          ' Offers',
                                  style: TextStyle(
                                      color:
                                          ColorData.toColor(widget.colorCode),
                                      fontSize: Styles.packageExpandTextSiz,
                                      fontFamily: tr('currFontFamily'))),
                              trailing: new OutlinedButton(
                                onPressed: () {
                                  displayDiscountModalBottomSheet(context);
                                },
                                child: new Text(
                                  "View",
                                  style: TextStyle(
                                      color:
                                          ColorData.toColor(widget.colorCode)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ]))),
                  SizedBox(height: 5),
                  Visibility(
                      visible: false,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.98,
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 5),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            widget.showPickupAddress
                                                ? (Colors.white)
                                                : (widget.colorCode == null
                                                    ? Colors.blue[200]
                                                    : ColorData.toColor(
                                                        widget.colorCode))),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.40,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(tr('delivery_address'),
                                              style: TextStyle(
                                                fontSize: Styles.textSizeSmall,
                                                color: widget.showPickupAddress
                                                    ? (widget.colorCode == null
                                                        ? Colors.blue[200]
                                                        : ColorData.toColor(
                                                            widget.colorCode))
                                                    : ColorData.whiteColor,
                                                fontFamily:
                                                    tr('currFontFamily'),
                                              ))),
                                    ),
                                  ],
                                ),
                                // shape: new RoundedRectangleBorder(
                                //   borderRadius: new BorderRadius.circular(8),
                                // ),
                                // color: widget.showPickupAddress
                                //     ? (Colors.white)
                                //     : (widget.colorCode == null
                                //         ? Colors.blue[200]
                                //         : ColorData.toColor(widget.colorCode)),
                                onPressed: () async {
                                  setState(() {
                                    _deliveryNotes.text = "";
                                    _streetName.text = "";
                                    _landmark.text = "";
                                    _contactNo.text = "";
                                    _city.text = "";
                                    deliveryAddressId = 0;
                                    widget.showPickupAddress = false;
                                    selectedDeliveryCharges =
                                        new DeliveryCharges();
                                    selectedDeliveryCharges.price = 0;
                                  });
                                },
                                // textColor: Colors.white,
                                //color: Theme.of(context).primaryColor,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            !widget.showPickupAddress
                                                ? (Colors.white)
                                                : (widget.colorCode == null
                                                    ? Colors.blue[200]
                                                    : ColorData.toColor(
                                                        widget.colorCode))),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(tr('pickup'),
                                              style: TextStyle(
                                                fontSize: Styles.textSizeSmall,
                                                color: !widget.showPickupAddress
                                                    ? (widget.colorCode == null
                                                        ? Colors.blue[200]
                                                        : ColorData.toColor(
                                                            widget.colorCode))
                                                    : ColorData.whiteColor,
                                                fontFamily:
                                                    tr('currFontFamily'),
                                              ))),
                                    ),
                                  ],
                                ),
                                // shape: new RoundedRectangleBorder(
                                //   borderRadius: new BorderRadius.circular(8),
                                // ),
                                // color: !widget.showPickupAddress
                                //     ? (Colors.white)
                                //     : (widget.colorCode == null
                                //         ? Colors.blue[200]
                                //         : ColorData.toColor(widget.colorCode)),
                                onPressed: () async {
                                  setState(() {
                                    widget.showPickupAddress =
                                        !widget.showPickupAddress;
                                    _deliveryNotes.text = "";
                                    _streetName.text = "";
                                    _landmark.text = "";
                                    _contactNo.text = "";
                                    _city.text = "";
                                    deliveryAddressId = 0;
                                    selectedDeliveryCharges =
                                        new DeliveryCharges();
                                    selectedDeliveryCharges.price = 0;
                                  });
                                  if (deliveryAddresses.length > 0) {
                                    _onChangeOptionDropdown(
                                        deliveryAddresses[0]);
                                  }
                                },
                                // textColor: Colors.white,
                                //color: Theme.of(context).primaryColor,
                              ),
                            ]),
                      )),
                  SizedBox(height: 5),
                  Visibility(
                      visible: widget.showDeliveryAddress,
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
                                      visible: false,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                        child: CustomDeliveryComponent(
                                            selectedFunction:
                                                _onChangeOptionDropdown,
                                            deliveryController:
                                                _deliveryAddress,
                                            isEditBtnEnabled:
                                                Strings.ProfileCallState,
                                            deliveryResponse:
                                                deliveryAddresses == null
                                                    ? []
                                                    : deliveryAddresses,
                                            label: tr('delivery_address')),
                                      )),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                    child: LoginPageFieldWhite(
                                      _streetName,
                                      tr('street_name'),
                                      Strings.countryCodeForNonMobileField,
                                      CommonIcons.account,
                                      TextInputTypeFile.textInputTypeName,
                                      TextInputAction.done,
                                      () => {},
                                      () => {},
                                      readOnly: widget.showPickupAddress,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                    child: LoginPageFieldWhite(
                                        _landmark,
                                        tr('landmark'),
                                        Strings.countryCodeForNonMobileField,
                                        CommonIcons.location,
                                        TextInputTypeFile.textInputTypeName,
                                        TextInputAction.done,
                                        () => {},
                                        () => {},
                                        readOnly: widget.showPickupAddress),
                                  ),
                                  Visibility(
                                      visible: !widget.showPickupAddress,
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                        child: CustomDeliveryChargesComponent(
                                            selectedFunction:
                                                _onChangeChargesOptionDropdown,
                                            deliveryController: _city,
                                            isEditBtnEnabled:
                                                Strings.ProfileCallState,
                                            deliveryResponse:
                                                deliveryCharges == null
                                                    ? []
                                                    : deliveryCharges,
                                            label: tr('city')),
                                      )),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                    child: LoginPageFieldWhite(
                                        _contactNo,
                                        tr('phone'),
                                        Strings.countryCodeForNonMobileField,
                                        CommonIcons.phone,
                                        TextInputTypeFile.textInputTypeName,
                                        TextInputAction.done,
                                        () => {},
                                        () => {},
                                        readOnly: widget.showPickupAddress),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                                    child: LoginPageFieldWhite(
                                        _deliveryNotes,
                                        tr('notes'),
                                        Strings.countryCodeForNonMobileField,
                                        CommonIcons.review,
                                        TextInputTypeFile.textInputTypeName,
                                        TextInputAction.done,
                                        () => {},
                                        () => {}),
                                  )
                                ])))
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
                                            voucherResponse:
                                                giftVouchers == null
                                                    ? []
                                                    : giftVouchers,
                                            label: tr('gift_card')),
                                      )),
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
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
                                                fontFamily:
                                                    tr('currFontFamily')))
                                      ]),
                                      trailing: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.16,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.045,
                                          child: new TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              controller:
                                                  _giftVoucherUsedAmount,
                                              textAlign: TextAlign.center,
                                              decoration: new InputDecoration(
                                                contentPadding:
                                                    EdgeInsets.all(5),
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
                                                  _giftVoucherUsedAmount.text =
                                                      "";
                                                  getTotal();
                                                  return;
                                                }
                                                if (enteredAmt < 100 &&
                                                    widget.selectedVoucher
                                                            .balanceAmount >
                                                        100) {
                                                  _vchErrorText = tr(
                                                      "amount_should_be_hundred_or_greater");
                                                } else if (widget
                                                        .selectedVoucher
                                                        .balanceAmount <
                                                    100) {
                                                  _giftVoucherUsedAmount.text =
                                                      widget.selectedVoucher
                                                          .balanceAmount
                                                          .toStringAsFixed(2);
                                                } else if (widget
                                                        .selectedVoucher
                                                        .balanceAmount <
                                                    enteredAmt) {
                                                  _vchErrorText = tr(
                                                      "amount_should_be_not_be_greater_than_balance_amount");
                                                  _giftVoucherUsedAmount.text =
                                                      widget.selectedVoucher
                                                          .balanceAmount
                                                          .toStringAsFixed(2);
                                                }
                                                setState(() {});
                                                getTotal();
                                                if (widget.total < 0) {
                                                  _vchErrorText = tr(
                                                      "amount_should_be_not_be_greater_than_total_amount");
                                                  getTotal();
                                                }
                                              },
                                              style: TextStyle(
                                                  fontSize: Styles
                                                      .packageExpandTextSiz,
                                                  fontFamily: tr(
                                                      "currFontFamilyEnglishOnly"),
                                                  color: ColorData
                                                      .primaryTextColor,
                                                  fontWeight:
                                                      FontWeight.w200))),
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
                            margin: const EdgeInsets.only(
                                top: 20, left: 20, right: 20),
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
                            margin: const EdgeInsets.only(
                                top: 8, left: 20, right: 20),
                            child: Row(
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Text(paymentTerms.terms,
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
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
                                        unselectedWidgetColor:
                                            Colors.grey[400]),
                                    child: Checkbox(
                                      checkColor: Colors.greenAccent,
                                      activeColor: Colors.blue,
                                      value: this.valuefirst,
                                      onChanged: (bool value) {
                                        // setState(() {
                                        //   this.valuefirst = value;
                                        // });
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
                                                              tr('discount_title'),
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
                                                                  style: ButtonStyle(
                                                                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                      backgroundColor: MaterialStateProperty.all<Color>(ColorData.grey300),
                                                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.all(
                                                                        Radius.circular(
                                                                            2.0),
                                                                      )))),
                                                                  // color:
                                                                  // ColorData.grey300,
                                                                  child: new Text(tr("no"),
                                                                      style: TextStyle(
                                                                          color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                                                          fontSize: Styles.textSizeSmall,
                                                                          fontFamily: tr("currFontFamily"))),
                                                                  onPressed: () {
                                                                    setState(
                                                                        () {
                                                                      this.valuefirst =
                                                                          value;
                                                                    });
                                                                    Navigator.of(
                                                                            pcontext)
                                                                        .pop();
                                                                  }),
                                                              ElevatedButton(
                                                                style: ButtonStyle(
                                                                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                                                    backgroundColor: MaterialStateProperty.all<Color>(ColorData.colorBlue),
                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                                                        borderRadius: BorderRadius.all(
                                                                      Radius.circular(
                                                                          2.0),
                                                                    )))),
                                                                child: new Text(
                                                                  tr("yes"),
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          Styles
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
                                                                    value =
                                                                        false;
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
                            ),
                            Visibility(
                                visible: false,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    " " +
                                                        double.tryParse((widget.deliveryTaxableAmt ==
                                                                            null
                                                                        ? 0
                                                                        : widget
                                                                            .deliveryTaxableAmt)
                                                                    .toStringAsFixed(
                                                                        2) ??
                                                                0)
                                                            .toStringAsFixed(2),
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
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
                                visible: widget.giftVouchers != null &&
                                        widget.giftVouchers.length > 0
                                    ? true
                                    : false,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    _giftVoucherUsedAmount
                                                                .text !=
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
                                              alignment: Alignment.centerRight,
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
                                                    double.tryParse(widget.total
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
                    ],
                  ),
                  (valuefirst != false && total != 0)
                      ? Container(
                          width: MediaQuery.of(context).size.width - 60,
                          margin:
                              EdgeInsets.only(left: 10.0, right: 10.0, top: 8),
                          child: Column(children: [
                            Visibility(
                                visible:
                                    Platform.isIOS && widget.enablePayments,
                                child: ElevatedButton(
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
                                  // shape: new RoundedRectangleBorder(
                                  //   borderRadius: new BorderRadius.circular(8),
                                  // ),
                                  // color: Colors
                                  //     .black /*widget.colorCode == null
                                  //     ? Colors.blue[200]
                                  //     : ColorData.toColor(widget.colorCode)*/
                                  // ,
                                  onPressed: () async {
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    // if (_streetName.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_street_name"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_landmark.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_landmark"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_city.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_city"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_contactNo.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_contact_no"),
                                    //       context);
                                    //   return;
                                    // }
                                    _handler.show();
                                    widget.enablePayments = false;
                                    setState(() {});
                                    // DeliveryAddress deliveryAddress =
                                    //     new DeliveryAddress();
                                    // deliveryAddress.userId =
                                    //     SPUtil.getInt(Constants.USERID);
                                    // deliveryAddress.deliveryAddressId =
                                    //     deliveryAddressId;
                                    // deliveryAddress.streetName =
                                    //     _streetName.text.toString();
                                    // deliveryAddress.landmark =
                                    //     _landmark.text.toString();
                                    // deliveryAddress.city =
                                    //     _city.text.toString();
                                    // deliveryAddress.contactNo =
                                    //     _contactNo.text.toString();
                                    // deliveryAddress.deliveryNotes =
                                    //     _deliveryNotes.text.toString();
                                    double totalAmt = 0;

                                    FacilityBeachRequest item =
                                        new FacilityBeachRequest();
                                    item.facilityItemId =
                                        widget.giftCardPrice.facilityItemId;
                                    item.quantity = 1;
                                    item.price = widget.giftCardPrice.price;
                                    item.vatPercentage =
                                        widget.giftCardPrice.vatPercentage;
                                    item.comments = "";
                                    facilityItemRequest.add(item);
                                    total = totalAmt;
                                    Meta m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityId,
                                            0,
                                            facilityItemRequest,
                                            widget.tableNo,
                                            billDiscount: widget.discount,
                                            discountAmt: widget.discountAmt,
                                            grossAmount: widget.taxableAmt,
                                            taxAmount: widget.taxAmt,
                                            netAmount: widget.total,
                                            giftCardImageId:
                                                giftCardImage.giftCardImageId,
                                            giftCardText: giftCardText,
                                            giftCategoryId:
                                                giftCardCategory.categoryId,
                                            giftCategoryPrice:
                                                giftCardPrice.price,
                                            giftToId: giftTo.categoryId,
                                            giftSharedMobileNo: sharedMobileNo);
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
                                                    RetailCartConfirmationAlert(
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
                                  },
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
                                    // if (_streetName.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_street_name"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_landmark.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_landmark"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_city.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_city"),
                                    //       context);
                                    //   return;
                                    // }
                                    // if (_contactNo.text.isEmpty) {
                                    //   util.customGetSnackBarWithOutActionButton(
                                    //       tr('error_caps'),
                                    //       tr("enter_contact_no"),
                                    //       context);
                                    //   return;
                                    // }
                                    _handler.show();
                                    widget.enablePayments = false;
                                    setState(() {});
                                    // DeliveryAddress deliveryAddress =
                                    //     new DeliveryAddress();
                                    // deliveryAddress.userId =
                                    //     SPUtil.getInt(Constants.USERID);
                                    // deliveryAddress.deliveryAddressId =
                                    //     deliveryAddressId;
                                    // deliveryAddress.streetName =
                                    //     _streetName.text.toString();
                                    // deliveryAddress.landmark =
                                    //     _landmark.text.toString();
                                    // deliveryAddress.city = _city.text.toString();
                                    // deliveryAddress.contactNo =
                                    //     _contactNo.text.toString();
                                    // deliveryAddress.deliveryNotes =
                                    //     _deliveryNotes.text.toString();
                                    double totalAmt = 0;
                                    List<FacilityBeachRequest>
                                        facilityItemRequest = [];
                                    FacilityBeachRequest item =
                                        new FacilityBeachRequest();
                                    item.facilityItemId =
                                        widget.giftCardPrice.facilityItemId;
                                    item.quantity = 1;
                                    item.price = widget.giftCardPrice.price;
                                    item.vatPercentage =
                                        widget.giftCardPrice.vatPercentage;
                                    item.comments = "";
                                    facilityItemRequest.add(item);
                                    total = totalAmt;
                                    Meta m = await FacilityDetailRepository()
                                        .getEnquiryPaymentOrderRequest(
                                            widget.facilityId,
                                            0,
                                            facilityItemRequest,
                                            widget.tableNo,
                                            billDiscount: widget.discount,
                                            discountAmt: widget.discountAmt,
                                            grossAmount: widget.taxableAmt,
                                            taxAmount: widget.taxAmt,
                                            netAmount: widget.total,
                                            giftCardImageId:
                                                giftCardImage.giftCardImageId,
                                            giftCardText: giftCardText,
                                            giftCategoryId:
                                                giftCardCategory.categoryId,
                                            giftCategoryPrice:
                                                giftCardPrice.price,
                                            giftToId: giftTo.categoryId,
                                            giftSharedMobileNo: sharedMobileNo);

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
                                                    RetailCartConfirmationAlert(
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
                                  },
                                  // textColor: Colors.white,
                                  //color: Theme.of(context).primaryColor,
                                ))
                          ]),
                        )
                      : Container()
                ],
              ),
            ),
          ),
          progressBar
        ],
      ),
    );
  }

  Widget getItemList(int facilityId, int retailItemSetId) {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Expanded(
        child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: carouselHeight - 70, minWidth: double.infinity),
            child: Directionality(
                textDirection: uiprefix.TextDirection.ltr,
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          height: carouselHeight - 70,
                          width: MediaQuery.of(context).size.width * 0.96,
                          child: Image.network(
                              widget.giftCardImage.giftCardImageUrl,
                              fit: BoxFit.fill),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                            left: 38,
                            top: 130,
                          ),
                          // Localizations.localeOf(context).languageCode == "en"
                          //     ? EdgeInsets.only(top: 2, left: 5)
                          //     : EdgeInsets.only(top: 5, right: 5),
                          child: Text(giftCardText,
                              style: TextStyle(
                                  color: ColorData.primaryTextColor
                                      .withOpacity(1.0),
                                  fontSize: Styles.textSizeSmall,
                                  fontFamily: tr('currFontFamily')))),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.84,
                          top: MediaQuery.of(context).size.height * 0.126,
                        ),
                        // Localizations.localeOf(context).languageCode == "en"
                        //     ? EdgeInsets.only(top: 2, left: 5)
                        //     : EdgeInsets.only(top: 5, right: 5),
                        child: Text(giftCardPrice.price.toStringAsFixed(0),
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.reviewTextSize,
                                fontFamily: tr('currFontFamily'))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.48,
                          top: MediaQuery.of(context).size.height * 0.26,
                        ),
                        child: Text(
                            giftCardImage.validityDays.toString() + " days",
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.reviewTextSize,
                                fontFamily: tr('currFontFamily'))),
                      )
                    ],
                  ),
                ))));
  }

  void getTotal() {
    double totalAmt = 0;
    // double totalAmtWithoutPromotion = 0;
    widget.taxAmt = 0;
    widget.taxableAmt = 0;
    widget.deliveryTaxableAmt = 0;
    widget.discountAmt = 0;
    widget.total = 0;
    double taxableAmt = 0;
    double itemDiscountAmt = 0;
    double taxAmt = 0;
    taxableAmt = (widget.giftCardPrice.price) /
        (1 + (widget.giftCardPrice.vatPercentage / 100.00));

    if (widget.discount != null && widget.discount.discountValue != null) {
      if (widget.discount.discountValue > 0) {
        if (widget.discount.discountType == 1) {
          itemDiscountAmt = double.parse(roundDouble(
                  (taxableAmt * (widget.discount.discountValue / 100.0)), 2)
              .toStringAsFixed(2));
        }
      }
    }
    widget.taxableAmt = widget.taxableAmt + taxableAmt;
    widget.discountAmt = widget.discountAmt + itemDiscountAmt;
    //calculate the tax after discount here
    if (widget.giftCardPrice.vatPercentage == null) {
      taxAmt = 0;
    } else {
      taxAmt = roundDouble(
          (taxableAmt - itemDiscountAmt) *
              (widget.giftCardPrice.vatPercentage / 100.0),
          3);
    }
    widget.taxAmt = widget.taxAmt + taxAmt;
    totalAmt = totalAmt + taxableAmt - itemDiscountAmt + taxAmt;

    double deliveryTaxableAmt = 0;
    if (selectedDeliveryCharges.vatPercentage == null) {
      deliveryTaxableAmt = (selectedDeliveryCharges.price);
    } else {
      deliveryTaxableAmt = selectedDeliveryCharges.price /
          (1 + (selectedDeliveryCharges.vatPercentage / 100.00));
      // double deliveryTaxAmt =
      //     (selectedDeliveryCharges.price) - deliveryTaxableAmt;
      double deliveryTaxAmt = roundDouble(
          deliveryTaxableAmt * (selectedDeliveryCharges.vatPercentage / 100),
          2);
      widget.taxAmt = widget.taxAmt + deliveryTaxAmt;
    }
    widget.taxAmt = roundDouble(widget.taxAmt, 2);
    widget.deliveryTaxableAmt = deliveryTaxableAmt;
    total = totalAmt +
        (selectedDeliveryCharges.price == null
            ? 0
            : selectedDeliveryCharges.price);
    widget.total = totalAmt +
        (selectedDeliveryCharges.price == null
            ? 0
            : selectedDeliveryCharges.price) -
        (_giftVoucherUsedAmount.text == ""
            ? 0
            : double.parse(_giftVoucherUsedAmount.text));
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    //Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RetailCartWebviewPage(
                  title: tr("payment"),
                  url: val,
                  facilityId: widget.facilityId,
                  facilityItems: [],
                ))).then((value) {
      widget.enablePayments = true;
      setState(() {});
    });
  }

  Widget getHtml(String description) {
    return Html(
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
            fontWeight: FontWeight.w500,
            fontFamily: tr('currFontFamilyEnglishOnly'),
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
          ),
        },
        // customFont: tr('currFontFamilyEnglishOnly'),
        // anchorColor: ColorData.primaryTextColor,
        data: (description != null
            ? "<html><body>" + description + "</body></html>"
            : tr('noDataFound')));
  }

  _onChangeOptionDropdown(DeliveryAddress address) {
    setState(() {
      _deliveryNotes.text = address.deliveryNotes;
      _streetName.text = address.streetName;
      _landmark.text = address.landmark;
      _contactNo.text = address.contactNo;
      _city.text = address.city;
      deliveryAddressId = address.deliveryAddressId;
      for (int i = 0; i < deliveryCharges.length; i++) {
        if (deliveryCharges[i].cityName == address.city) {
          _onChangeChargesOptionDropdown(deliveryCharges[i]);
          break;
        }
      }
    });
  }

  _onChangeChargesOptionDropdown(DeliveryCharges charges) {
    setState(() {
      selectedDeliveryCharges = charges;
      getTotal();
    });
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

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
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
                                          _clearOptionGiftVoucher();
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
                                                                        _clearOptionGiftVoucher();
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
                                              _clearOptionGiftVoucher();
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
          //Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RetailCartConfirmationAlert(
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
