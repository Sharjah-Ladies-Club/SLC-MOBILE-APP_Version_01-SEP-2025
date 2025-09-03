// // ignore_for_file: must_be_immutable
import 'dart:convert';
import 'dart:io';

import 'package:apple_pay_flutter/apple_pay_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:signature/signature.dart';
import 'package:signature/signature.dart' as sign;
import 'package:slc/view/facility_detail/facility_content/facility_hall/facility_buy/web_page.dart';

import '../../../../../common/ModalRoundedProgressBar.dart';
import '../../../../../common/colors.dart';
import '../../../../../gmcore/model/Meta.dart';
import '../../../../../gmcore/storage/SPUtils.dart';
import '../../../../../model/knooz_response_dto.dart';
import '../../../../../model/terms_condition.dart';
import '../../../../../repo/facility_detail_repository.dart';
import '../../../../../theme/customIcons.dart';
import '../../../../../theme/styles.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/url_utils.dart';
import '../../../../../utils/utils.dart';
import '../../../../Retail/retail_confirmation_alert.dart';
import 'facility_buy_confirmation_alert.dart';

class FacilityBuyPaymentPage extends StatefulWidget {
  final KunoozBookingDto kunoozResponse;
  final List<TermsCondition> termsList;
  final String colorCode;
  const FacilityBuyPaymentPage(
      {@required this.kunoozResponse,
      @required this.termsList,
      @required this.colorCode});

  @override
  State<FacilityBuyPaymentPage> createState() => _FacilityBuyPaymentPageState();
}

class _FacilityBuyPaymentPageState extends State<FacilityBuyPaymentPage> {
  bool valueFirst = false;
  Utils util = Utils();
  ProgressBarHandler _handler;
  bool isCheckAll = false;
  bool valueFirstCheck = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black87,
    exportBackgroundColor: Colors.white,
  );
  var serverReceiverPath = URLUtils().getImageFacilityUploadUrl();

  bool isSignShow = true;

  @override
  void initState() {
    checkSignFile();
    super.initState();
  }

  checkSignFile() {
    var fileFilter = widget.kunoozResponse.partyHallDocumentsDto
        .where((x) => x.documentFileName.contains("signature.png"));
    if (fileFilter.isNotEmpty) {
      setState(() {
        isSignShow = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
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
            clearTermsChecked();
            _signatureController.clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.99,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //       image: AssetImage("assets/images/fitness_bg.png"),
            //       fit: BoxFit.cover),
            // ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: ColorData.toColor(widget.colorCode),
                      title: SizedBox(
                        child: Text(tr("kunooz_items"),
                            style: TextStyle(
                                fontSize: 12,
                                color: ColorData.toColor(widget.colorCode),
                                fontWeight: FontWeight.w700,
                                fontFamily: tr('currFontFamily'))),
                      ),
                      children: [getItems(screenHeight)]),
                  Visibility(
                    // visible: isSignShow,
                    child: ExpansionTile(
                        iconColor: ColorData.toColor(widget.colorCode),
                        title: SizedBox(
                          child: Text(tr("accept_others") + " *",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorData.toColor(widget.colorCode),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: tr('currFontFamily'))),
                        ),
                        children: [getTerms(context)]),
                  ),
                  Visibility(
                    // visible: isSignShow,
                    child: ExpansionTile(
                        iconColor: ColorData.toColor(widget.colorCode),
                        title: SizedBox(
                          child: Text(tr('sign_here') + " *",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: ColorData.toColor(widget.colorCode),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: tr('currFontFamily'))),
                        ),
                        children: [
                          Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: sign.Signature(
                                controller: _signatureController,
                                width: MediaQuery.of(context).size.width * 0.98,
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                backgroundColor: Colors.white,
                              ))
                        ]),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.only(top: 10, left: 8, right: 8),
                  //   height: 180,
                  //   width: MediaQuery.of(context).size.width * .98,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.all(Radius.circular(8)),
                  //     border: Border.all(color: Colors.grey[200]),
                  //     color: Colors.white,
                  //   ),
                  //   child: SingleChildScrollView(
                  //     child: Column(
                  //       children: <Widget>[
                  //         Container(
                  //           margin:
                  //               Localizations.localeOf(context).languageCode ==
                  //                       "en"
                  //                   ? const EdgeInsets.only(top: 20, left: 25)
                  //                   : const EdgeInsets.only(top: 20, right: 25),
                  //           child: Row(
                  //             children: [
                  //               Text(tr("accept_proceed"),
                  //                   style: TextStyle(
                  //                       color: ColorData.primaryTextColor
                  //                           .withOpacity(1.0),
                  //                       fontSize: Styles.textSizRegular,
                  //                       fontFamily: tr('currFontFamily'))),
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //           margin:
                  //               Localizations.localeOf(context).languageCode ==
                  //                       "en"
                  //                   ? const EdgeInsets.only(top: 8, left: 25)
                  //                   : const EdgeInsets.only(top: 8, right: 25),
                  //           child: Row(
                  //             children: [
                  //               SizedBox(
                  //                   width: MediaQuery.of(context).size.width *
                  //                       0.80,
                  //                   // tr("payment_terms_conditions")
                  //                   child: Text(widget.paymentTerms.terms,
                  //                       style: TextStyle(
                  //                           color: ColorData.primaryTextColor
                  //                               .withOpacity(1.0),
                  //                           fontSize:
                  //                               Styles.packageExpandTextSiz,
                  //                           fontFamily: tr('currFontFamily')))),
                  //             ],
                  //           ),
                  //         ),
                  //         Container(
                  //             margin: Localizations.localeOf(context)
                  //                         .languageCode ==
                  //                     "en"
                  //                 ? const EdgeInsets.only(top: 8, left: 25)
                  //                 : const EdgeInsets.only(top: 8, right: 25),
                  //             child: Row(children: [
                  //               Text(tr("don't_press_back_button"),
                  //                   style: TextStyle(
                  //                       color: Colors.lightBlue, fontSize: 12))
                  //             ])),
                  //         Container(
                  //           margin:
                  //               Localizations.localeOf(context).languageCode ==
                  //                       "en"
                  //                   ? const EdgeInsets.only(top: 6, left: 8)
                  //                   : const EdgeInsets.only(top: 6, right: 8),
                  //           child: Row(
                  //             children: [
                  //               Theme(
                  //                   data: ThemeData(
                  //                       unselectedWidgetColor:
                  //                           Colors.grey[400]),
                  //                   child: Checkbox(
                  //                     checkColor: Colors.greenAccent,
                  //                     activeColor: Colors.blue,
                  //                     value: this.valueFirst,
                  //                     onChanged: (bool value) {
                  //                       this.valueFirst = value;
                  //                       setState(() {});
                  //                     },
                  //                   )),
                  //               Text(
                  //                 tr("i_accept"),
                  //                 style: TextStyle(
                  //                     color: ColorData.primaryTextColor
                  //                         .withOpacity(1.0),
                  //                     fontSize: Styles.loginBtnFontSize,
                  //                     fontFamily: tr('currFontFamily')),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Container(
                    margin: EdgeInsets.only(
                        left: 20, top: 10, right: 20, bottom: 10),
                    child: Column(
                      children: [
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Align(
                                    alignment: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(tr("original_Amount"),
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.loginBtnFontSize,
                                            fontFamily: tr('currFontFamily')))),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "AED",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.textSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                alignment: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  " " +
                                      widget.kunoozResponse.grossAmount
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Align(
                                    alignment: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(tr("Vat_amount"),
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.loginBtnFontSize,
                                            fontFamily: tr('currFontFamily')))),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "AED",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.textSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                alignment: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  " " +
                                      widget.kunoozResponse.vatAmount
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.40,
                                child: Align(
                                    alignment: Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(tr("service_amount"),
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.loginBtnFontSize,
                                            fontFamily: tr('currFontFamily')))),
                              ),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "AED",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.textSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                alignment: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  " " +
                                      widget.kunoozResponse.serviceAmount
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.kunoozResponse.discountAmount > 0
                              ? true
                              : false,
                          child: Container(
                            // width: MediaQuery.of(context).size.width *
                            //     0.75,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Align(
                                      alignment: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text("(-) " + tr("discount_title"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily:
                                                  tr('currFontFamily')))),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "AED",
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.textSiz,
                                              fontFamily: tr('currFontFamily')),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text(
                                    " " +
                                        widget.kunoozResponse.discountAmount
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.kunoozResponse.deliveryCharges > 0
                              ? true
                              : false,
                          child: Container(
                            // width: MediaQuery.of(context).size.width *
                            //     0.75,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Align(
                                      alignment: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(tr("delivery_charges"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily:
                                                  tr('currFontFamily')))),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "AED",
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.textSiz,
                                              fontFamily: tr('currFontFamily')),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text(
                                    " " +
                                        widget.kunoozResponse.deliveryCharges
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.kunoozResponse.advanceAmount > 0
                              ? true
                              : false,
                          child: Container(
                            // width: MediaQuery.of(context).size.width *
                            //     0.75,
                            margin: EdgeInsets.only(top: 8),
                            child: Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: Align(
                                      alignment: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text("(-) " + tr("advance"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily:
                                                  tr('currFontFamily')))),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "AED",
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.textSiz,
                                              fontFamily: tr('currFontFamily')),
                                        ),
                                      ],
                                    )),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text(
                                    " " +
                                        widget.kunoozResponse.advanceAmount
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          alignment:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: SizedBox(
                              width: Localizations.localeOf(context)
                                          .languageCode ==
                                      "en"
                                  ? MediaQuery.of(context).size.width * 0.525
                                  : MediaQuery.of(context).size.width * 0.60,
                              child: Divider(
                                thickness: 1,
                              )),
                        ),
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Align(
                                      alignment: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(tr("final_Amount"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily:
                                                  tr('currFontFamily'))))),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "AED",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.textSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    ],
                                  )),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.2,
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Text(
                                    " " +
                                        widget.kunoozResponse.balanceAmount
                                            .toStringAsFixed(2),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily')),
                                  )
                                  // : Text(
                                  //     " 0.00",
                                  //     style: TextStyle(
                                  //         color: ColorData.primaryTextColor
                                  //             .withOpacity(1.0),
                                  //         fontSize: Styles.loginBtnFontSize,
                                  //         fontFamily: tr('currFontFamily')),
                                  //   ),
                                  ),
                            ],
                          ),
                        ),
                        Container(
                          // width:
                          //     MediaQuery.of(context).size.width * 0.75,
                          margin: EdgeInsets.only(top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Align(
                                      alignment: Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                      child: Text(tr("amount_to_be_paid"),
                                          style: TextStyle(
                                              color: ColorData.primaryTextColor
                                                  .withOpacity(1.0),
                                              fontSize: Styles.loginBtnFontSize,
                                              fontFamily:
                                                  tr('currFontFamily'))))),
                              Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.15,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "AED",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize: Styles.textSiz,
                                            fontFamily: tr('currFontFamily')),
                                      ),
                                    ],
                                  )),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.2,
                                alignment: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Text(
                                  " " +
                                      widget.kunoozResponse
                                          .onlineAadvanceRequestAmount
                                          .toStringAsFixed(2),
                                  style: TextStyle(
                                      color: ColorData.primaryTextColor
                                          .withOpacity(1.0),
                                      fontSize: Styles.loginBtnFontSize,
                                      fontFamily: tr('currFontFamily')),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.30,
                        //               child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(tr("original_Amount"),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily'))))),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     "AED",
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize: Styles.textSiz,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     " " +
                        //                         double.parse(
                        //                             widget.kunoozResponse
                        //                                 .grossAmount
                        //                                 .toStringAsFixed(2),
                        //                             (e) {
                        //                           return 0;
                        //                         }).toStringAsFixed(2),
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize:
                        //                             Styles.loginBtnFontSize,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Row(
                        //     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Column(
                        //         children: [
                        //           Container(
                        //             width: MediaQuery.of(context).size.width *
                        //                 0.30,
                        //             child: Align(
                        //                 alignment: Alignment.centerRight,
                        //                 child: Text(tr("Vat_amount"),
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize:
                        //                             Styles.loginBtnFontSize,
                        //                         fontFamily:
                        //                             tr('currFontFamily')))),
                        //           ),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     "AED",
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize: Styles.textSiz,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     " " +
                        //                         double.parse(
                        //                             widget.kunoozResponse
                        //                                 .vatAmount
                        //                                 .toStringAsFixed(2),
                        //                             (e) {
                        //                           return 0;
                        //                         }).toStringAsFixed(2),
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize:
                        //                             Styles.loginBtnFontSize,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: true,
                        //   // widget.kunoozResponse.discountAmount > 0
                        //   //     ? true
                        //   //     : false,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.75,
                        //     margin: EdgeInsets.only(top: 8),
                        //     child: Row(
                        //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Column(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.30,
                        //               child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(tr("discount_title"),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily')))),
                        //             ),
                        //           ],
                        //         ),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             Container(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.15,
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "AED",
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize: Styles.textSiz,
                        //                           fontFamily:
                        //                               tr('currFontFamily')),
                        //                     ),
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             Container(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.15,
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       " " +
                        //                           double.parse(
                        //                               widget.kunoozResponse
                        //                                   .discountAmount
                        //                                   .toStringAsFixed(2),
                        //                               (e) {
                        //                             return 0;
                        //                           }).toStringAsFixed(2),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily')),
                        //                     ),
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Visibility(
                        //   visible: true,
                        //   // widget.kunoozResponse.advanceAmount > 0
                        //   //     ? true
                        //   //     : false,
                        //   child: Container(
                        //     width: MediaQuery.of(context).size.width * 0.75,
                        //     margin: EdgeInsets.only(top: 8),
                        //     child: Row(
                        //       //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Column(
                        //           children: [
                        //             Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.30,
                        //               child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(tr("advance"),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily')))),
                        //             ),
                        //           ],
                        //         ),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             Container(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.15,
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       "AED",
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize: Styles.textSiz,
                        //                           fontFamily:
                        //                               tr('currFontFamily')),
                        //                     ),
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //         Column(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           children: [
                        //             Container(
                        //                 width:
                        //                     MediaQuery.of(context).size.width *
                        //                         0.15,
                        //                 child: Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.end,
                        //                   children: [
                        //                     Text(
                        //                       " " +
                        //                           double.parse(
                        //                               widget.kunoozResponse
                        //                                   .advanceAmount
                        //                                   .toStringAsFixed(2),
                        //                               (e) {
                        //                             return 0;
                        //                           }).toStringAsFixed(2),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily')),
                        //                     ),
                        //                   ],
                        //                 )),
                        //           ],
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.end,
                        //       children: [
                        //         Container(
                        //             width: Localizations.localeOf(context)
                        //                         .languageCode ==
                        //                     "en"
                        //                 ? MediaQuery.of(context).size.width *
                        //                     0.525
                        //                 : MediaQuery.of(context).size.width *
                        //                     0.60,
                        //             child: Divider(
                        //               thickness: 1,
                        //             )),
                        //       ]),
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.30,
                        //               child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(tr("final_Amount"),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily'))))),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     "AED",
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize: Styles.textSiz,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     " " +
                        //                         double.parse(
                        //                             widget.kunoozResponse
                        //                                 .payableAmount
                        //                                 .toStringAsFixed(2),
                        //                             (e) {
                        //                           return 0;
                        //                         }).toStringAsFixed(2),
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize:
                        //                             Styles.loginBtnFontSize,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   width: MediaQuery.of(context).size.width * 0.75,
                        //   margin: EdgeInsets.only(top: 8),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.30,
                        //               child: Align(
                        //                   alignment: Alignment.centerRight,
                        //                   child: Text(tr("amount_to_be_paid"),
                        //                       style: TextStyle(
                        //                           color: ColorData
                        //                               .primaryTextColor
                        //                               .withOpacity(1.0),
                        //                           fontSize:
                        //                               Styles.loginBtnFontSize,
                        //                           fontFamily:
                        //                               tr('currFontFamily'))))),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     "AED",
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize: Styles.textSiz,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //       Column(
                        //         crossAxisAlignment: CrossAxisAlignment.end,
                        //         children: [
                        //           Container(
                        //               width: MediaQuery.of(context).size.width *
                        //                   0.15,
                        //               child: Row(
                        //                 mainAxisAlignment:
                        //                     MainAxisAlignment.end,
                        //                 children: [
                        //                   Text(
                        //                     " " +
                        //                         double.parse(
                        //                             widget.kunoozResponse
                        //                                 .onlineAdvanceRequestAmount
                        //                                 .toStringAsFixed(2),
                        //                             (e) {
                        //                           return 0;
                        //                         }).toStringAsFixed(2),
                        //                     style: TextStyle(
                        //                         color: ColorData
                        //                             .primaryTextColor
                        //                             .withOpacity(1.0),
                        //                         fontSize:
                        //                             Styles.loginBtnFontSize,
                        //                         fontFamily:
                        //                             tr('currFontFamily')),
                        //                   ),
                        //                 ],
                        //               )),
                        //         ],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: Platform.isIOS &&
                          ((isSignShow && isCheckAll) || !isSignShow),
                      child: Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
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
                                      padding:
                                          EdgeInsets.only(left: 2, right: 2),
                                      child: Icon(ApplePayIcon.apple_pay,
                                          color: Colors.white, size: 30)),
                                ],
                              ),
                              onPressed: () async {
                                if (isSignShow) {
                                  bool check = await checkSignature();
                                  if (!check) return;
                                }
                                Meta m = await FacilityDetailRepository()
                                    .getFacilityPaymentOrderRequest(
                                        widget.kunoozResponse.facilityId,
                                        widget.kunoozResponse.bookingId,
                                        widget.kunoozResponse.userID,
                                        widget.kunoozResponse
                                            .onlineAadvanceRequestAmount);
                                if (m.statusCode == 200) {
                                  Map<String, dynamic> decode = m.toJson();
                                  Map userMap = jsonDecode(decode['statusMsg']);
                                  userMap.forEach((key, val) {
                                    print('{ key: $key, value: $val}');
                                    if (key == 'response') {
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
                                            widget.kunoozResponse
                                                .onlineAadvanceRequestAmount,
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
                                  setState(() {});
                                  util.customGetSnackBarWithOutActionButton(
                                      tr('error_caps'), m.statusMsg, context);
                                }
                                // double total = 0;
                                // total = widget.kunoozResponse.payableAmount;
                                // Meta m = await FacilityDetailRepository()
                                //     .getFacilityPaymentOrderRequest(
                                //     widget.facilityId,
                                //     widget.enquiryDetailId,
                                //     [],
                                //     widget.tableNo,
                                //     billDiscount: widget.discount,
                                //     discountAmt: widget.discountAmt,
                                //     tipsAmount: widget.tipsAmt,
                                //     grossAmount: widget.taxableAmt,
                                //     taxAmount: widget.taxAmt,
                                //     netAmount: widget.total,
                                //     deliveryAmount: 0,
                                //     deliveryTaxAmount: 0,
                                //     giftVoucher: widget.selectedVoucher,
                                //     bookingId: widget.bookingId != null
                                //         ? widget.bookingId
                                //         : 0,
                                //     moduleId: widget.moduleId,
                                //     giftVoucherAmount: ((widget
                                //         .selectedVoucher ==
                                //         null
                                //         ? 0
                                //         : _giftVoucherUsedAmount.text ==
                                //         ""
                                //         ? 0
                                //         : double.parse(
                                //         _giftVoucherUsedAmount
                                //             .text))));
                                // if (m.statusCode == 200) {
                                //   // ignore: unnecessary_statements
                                //   _handler.dismiss();
                                //   Map<String, dynamic> decode = m.toJson();
                                //   // print('12' + decode['statusMsg']);
                                //   Map userMap =
                                //   jsonDecode(decode['statusMsg']);
                                //   // print(userMap);
                                //   userMap.forEach((key, val) {
                                //     print('{ key: $key, value: $val}');
                                //     if (key == 'response') {
                                //       //call apple pay
                                //       Map payment =
                                //       new Map<String, dynamic>.from(
                                //           val);
                                //       if (payment["applePayUrl"] != "") {
                                //         String applePayUrl =
                                //         payment["applePayUrl"];
                                //         int orderId = payment["orderId"];
                                //         String merchantReferenceNo =
                                //         payment['merchantReferenceNo'];
                                //         String merchantIdentifier =
                                //         payment['merchantIdentifier'];
                                //         String facilityName =
                                //         payment['facilityName'];
                                //         makePayment(
                                //             widget.total,
                                //             applePayUrl,
                                //             orderId,
                                //             merchantReferenceNo,
                                //             merchantIdentifier,
                                //             facilityName);
                                //       }
                                //       else {
                                //         Navigator.of(context).pop();
                                //         Navigator.push(
                                //           context,
                                //           MaterialPageRoute(
                                //             builder: (context) =>
                                //                 RetailConfirmationAlert(
                                //                   merchantReferenceNo: payment[
                                //                   'merchantReferenceNo'],
                                //                 ),
                                //           ),
                                //         );
                                //       }
                                //     }
                                //   });
                                // }
                                // else {
                                //   _handler.dismiss();
                                //   widget.enablePayments = true;
                                //   setState(() {});
                                //   util.customGetSnackBarWithOutActionButton(
                                //       tr('error_caps'),
                                //       m.statusMsg,
                                //       context);
                                // }
                              }))),
                  Visibility(
                    visible: ((isSignShow && isCheckAll) || !isSignShow),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.toColor(widget.colorCode)),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
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
                        onPressed: () async {
                          if (isSignShow) {
                            bool check = await checkSignature();
                            if (!check) return;
                          }
                          _handler.show();
                          Meta m = await FacilityDetailRepository()
                              .getFacilityPaymentOrderRequest(
                                  widget.kunoozResponse.facilityId,
                                  widget.kunoozResponse.bookingId,
                                  widget.kunoozResponse.userID,
                                  widget.kunoozResponse
                                      .onlineAadvanceRequestAmount);
                          if (m.statusCode == 200) {
                            Map<String, dynamic> decode = m.toJson();
                            Map userMap = jsonDecode(decode['statusMsg']);
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
                                var first =
                                    list[0].toString().replaceAll('{', "");
                                if (payment["merchantIdentifier"] != "") {
                                  openWebView(first.replaceAll("}", '').trim());
                                  _handler.dismiss();
                                } else {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RetailConfirmationAlert(
                                        merchantReferenceNo:
                                            payment['merchantReferenceNo'],
                                      ),
                                    ),
                                  );
                                }
                              }
                            });
                          } else {
                            setState(() {});
                            util.customGetSnackBarWithOutActionButton(
                                tr('error_caps'), m.statusMsg, context);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          progressBar
        ],
      ),
    );
  }

  getItems(double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 8, right: 8),
      height: screenHeight * 0.26,
      padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: ColorData.eventHomePageDeSelectedCircularFill),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: ListView.separated(
        itemCount: widget.kunoozResponse.kunoozBookingItemDto.length,
        itemBuilder: (BuildContext context, index) {
          double screenWidth = MediaQuery.of(context).size.width;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: screenWidth * 0.46,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.kunoozResponse.kunoozBookingItemDto[index]
                                  .facilityItemname ??
                              "",
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.primaryTextColor,
                              fontFamily: tr("currFontFamily")),
                        ),
                        Text(
                          tr('rate') +
                              ": AED " +
                              widget.kunoozResponse.kunoozBookingItemDto[index]
                                  .price
                                  .toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.toColor(widget.colorCode),
                              fontFamily: tr("currFontFamily")),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth * 0.34,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.kunoozResponse.kunoozBookingItemDto[index].qty
                              .toString(),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.primaryTextColor,
                              fontFamily: tr("currFontFamily")),
                        ),
                        Text(
                          "AED " +
                              widget.kunoozResponse.kunoozBookingItemDto[index]
                                  .amount
                                  .toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.primaryTextColor,
                              fontFamily: tr("currFontFamily")),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Visibility(
                visible: widget.kunoozResponse.kunoozBookingItemDto[index]
                        .serviceAmount >
                    0,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "SC: AED " +
                        widget.kunoozResponse.kunoozBookingItemDto[index]
                            .serviceAmount
                            .toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: Styles.textSizeSmall,
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily")),
                  ),
                ),
              ),
              Visibility(
                visible:
                    widget.kunoozResponse.kunoozBookingItemDto[index].discount >
                        0,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "AED " +
                        widget
                            .kunoozResponse.kunoozBookingItemDto[index].discount
                            .toStringAsFixed(2),
                    style: TextStyle(
                        fontSize: Styles.textSizeSmall,
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily")),
                  ),
                ),
              ),
            ],
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget getTerms(BuildContext buildContext) {
    return SingleChildScrollView(
        child: Container(
            // decoration:
            //     BoxDecoration(border: Border.all(width: 1, color: Colors.grey[400])),
            color: ColorData.whiteColor,
            child: widget.termsList.length == 0
                ? Text("No Terms Defined",
                    style: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0),
                        fontSize: Styles.packageExpandTextSiz,
                        fontFamily: tr('currFontFamily')))
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Row(
                          children: [
                            Theme(
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.grey[400]),
                              child: Checkbox(
                                  checkColor: Colors.white,
                                  activeColor: Colors.blue,
                                  value: isCheckAll,
                                  onChanged: (bool value) {
                                    debugPrint("===========");
                                    for (int i = 0;
                                        i <= widget.termsList.length - 1;
                                        i++) {
                                      widget.termsList[i].checked = value;
                                      setState(() {
                                        isCheckAll = value;
                                      });
                                      setTermsChecked();
                                    }
                                  }),
                            ),
                            Text(tr("accept_all"),
                                style: TextStyle(
                                    color: ColorData.primaryTextColor
                                        .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily')))
                          ],
                        ),
                      ),
                      Row(children: [getTermsAndConditions(true)])
                    ],
                  )));
    // ])));
  }

  setTermsChecked() {
    int j = 0;
    for (int i = 0; i < widget.termsList.length; i++) {
      if (widget.termsList[i].checked) {
        j = j + 1;
      }
    }
    if (j == widget.termsList.length) {
      setState(() {
        this.isCheckAll = true;
      });
    } else {
      setState(() {
        this.isCheckAll = false;
      });
    }
  }

  clearTermsChecked() {
    for (int i = 0; i < widget.termsList.length; i++) {
      widget.termsList[i].checked = false;
    }
    setState(() {
      this.isCheckAll = false;
    });
  }

  Widget getTermsAndConditions(showImportant) {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey(
                "Terms_" + showImportant.toString() + "_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: widget.termsList.length,
            padding: EdgeInsets.only(bottom: 20),
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Visibility(
                  visible:
                      true, //widget.termsList[j].isImportant == showImportant,
                  child: Container(
                    width: showImportant
                        ? MediaQuery.of(context).size.width * 0.90
                        : double.infinity,
                    decoration: BoxDecoration(color: Colors.white),
                    child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) =>
                            GestureDetector(
                              child: Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor: Colors.grey[400]),
                                  child: CheckboxListTile(
                                    title: Text(widget.termsList[j].termsName,
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily'))),
                                    checkColor: Colors.white,
                                    activeColor: Colors.blue,
                                    value: this.valueFirstCheck ||
                                        widget.termsList[j].checked,
                                    onChanged: (bool value) {
                                      setState(() {
                                        widget.termsList[j].checked = value;
                                        setTermsChecked();
                                      });
                                    },
                                    controlAffinity: ListTileControlAffinity
                                        .leading, //  <-- leading Checkbox
                                  )),
                            )),
                  ));
            }));
  }

  Future<String> uploadSignature() async {
    debugPrint("I am here Upload");
    if (_signatureController.isEmpty) {
      return "Signature required";
    }
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            widget.kunoozResponse.bookingId.toString() +
            "&eventparticipantid=" +
            SPUtil.getInt(Constants.USERID).toString() +
            "&FileName=" +
            "signature.png" +
            "&uploadtype=2" +
            "&docNo=0&documentType=2"));
    final Uint8List data = await _signatureController.toPngBytes();
    request.files.add(http.MultipartFile.fromBytes('picture', data,
        filename: "signature.png"));
    var res = await request.send();
    return "Ok";
  }

  customGetSnackBarWithOutActionButton(titleMsg, contentMsg, context) {
    return Get.snackbar(
      titleMsg,
      contentMsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }

  checkSignature() async {
    String result = await uploadSignature();
    if (result != "Ok") {
      customGetSnackBarWithOutActionButton(
          "Signature", "Signature Required", context);
      return false;
    }
    return true;
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    // Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => FacilityBuyWebviewPage(
                  title: tr("payment"),
                  url: val,
                  facilityId: widget.kunoozResponse.facilityId,
                  facilityItems: widget.kunoozResponse,
                ))).then((value) {
      setState(() {});
    });
  }

  void makePayment(
      double payAmount,
      String applePayUrl,
      int orderId,
      String merchantReferenceNo,
      String merchantIdentifier,
      String facilityName) async {
    dynamic applePaymentData;
    String itemName = "Sharjah Ladies Club " + facilityName;
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
            tr('error_caps'), tr('payment_failed'), context);
      } else {
        _handler.show();
        Meta m = await FacilityDetailRepository().applePayResponse(
            applePaymentData["paymentData"].toString(), applePayUrl, orderId,
            isSamsungPay: false, FacilityId: 6);
        if (m.statusCode == 200) {
          _handler.dismiss();
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FacilityBuyConfirmationAlert(
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
          tr('error_caps'), tr('payment_failed'), context);
    }
  }
}
