import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/facility_detail/facility_content/bloc/bloc.dart';

import '../../../../common/colors.dart';
import '../../../../customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import '../../../../model/terms_condition.dart';
import '../../../../theme/styles.dart';
import '../../../../utils/utils.dart';
import '../../facility_detail.dart';
import 'facility_buy/facility_buy_payment.dart';

class KunoozBookingDetail extends StatelessWidget {
  final int bookingId;
  final String colorCode;

  KunoozBookingDetail({@required this.bookingId, @required this.colorCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FacilityContentBloc>(
        create: (context) => FacilityContentBloc(null)
          ..add(new GetKunoozBookingData(bookingId: this.bookingId))
          ..add(GetKunoozPaymentTerms(facilityId: 6)),
        child: KunoozBookingDetailPage(
            colorCode: colorCode, bookingId: bookingId));
  }
}

class KunoozBookingDetailPage extends StatefulWidget {
  final int bookingId;
  final String colorCode;

  KunoozBookingDetailPage({@required this.colorCode, @required this.bookingId});

  @override
  State<KunoozBookingDetailPage> createState() => KunoozBookingDetailState();
}

class KunoozBookingDetailState extends State<KunoozBookingDetailPage> {
  int showDetail = 0;
  Utils util = Utils();
  // PaymentTerms paymentTerms = new PaymentTerms();
  List<TermsCondition> termsList = [];
  bool load = false;
  KunoozBookingDto kunoozResponse = new KunoozBookingDto();
  String bookingNo = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = (MediaQuery.of(context).size.height);
    double screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<FacilityContentBloc, FacilityContentState>(
        listener: (context, state) async {
          if (state is KunoozBookingData) {
            kunoozResponse = state.bookingResponse;
            if (int.parse(kunoozResponse.amendmentNo) > 0) {
              bookingNo = kunoozResponse.bookingId.toString() +
                  "-" +
                  kunoozResponse.amendmentNo;
            } else {
              bookingNo = kunoozResponse.bookingId.toString();
            }
            setState(() {
              load = true;
            });
          }
          if (state is KunoozAmendContractData) {
            KunuoozContractDto contractResponse = state.contractResponse;
            if (contractResponse != null) {
              amendBottomSheet(
                  context, screenWidth, screenHeight, contractResponse);
            } else {
              util.customGetSnackBarWithOutActionButton(
                  tr('error_caps'), "Amend data not found", context);
            }
          }
          if (state is KunoozPaymentTerms) {
            termsList = state.termsList;
            setState(() {});
          }
          if (state is KunoozContractDownload) {
            String contractUrl = state.url;
            downloadFacilityPdf(contractUrl, "Contract", true);
            setState(() {});
          }
          if (state is KunoozAmendmentDownload) {
            downloadFacilityPdf(state.url, "Amend", false);
            setState(() {});
          }
          if (state is KunoozCancelBooking) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => FacilityDetailsPage(
                        facilityId: 6,
                        menuId: 8,
                      )),
            );
            util.customGetSnackBarWithOutActionButton(
                tr("kunooz"), state.cancelResp, context);
          }
          if (state is KunoozRevertAmendmentState) {
            util.customGetSnackBarWithOutActionButton(
                tr("kunooz"), state.revertMessage, context);
            setState(() {
              load = false;
            });
            BlocProvider.of<FacilityContentBloc>(context)
                .add(GetKunoozBookingData(bookingId: kunoozResponse.bookingId));
          }
        },
        child: Scaffold(
          appBar: AppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            automaticallyImplyLeading: true,
            title: Text(
              tr('detail_page'),
              style: TextStyle(color: Colors.blue[200]),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blue[200],
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: <Widget>[],
            backgroundColor: Colors.white,
          ),
          body: load
              ? SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                showDetail == 0
                                                    ? ColorData.toColor(
                                                        widget.colorCode)
                                                    : Colors.grey[200]),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                          Radius.circular(2.0),
                                        )))),
                                    onPressed: () async {
                                      setState(() {
                                        showDetail = 0;
                                      });
                                    },
                                    child: Text(
                                      tr("booking_detail"),
                                      style: TextStyle(
                                          fontSize: Styles.textSiz,
                                          color: showDetail == 0
                                              ? Colors.white
                                              : ColorData.primaryTextColor,
                                          fontFamily: tr("currFontFamily")),
                                    ),
                                  )),
                              Visibility(
                                visible: kunoozResponse.amendment != null &&
                                        kunoozResponse.amendment.isNotEmpty
                                    ? true
                                    : false,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  showDetail == 1
                                                      ? ColorData.toColor(
                                                          widget.colorCode)
                                                      : Colors.grey[200]),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                            Radius.circular(2.0),
                                          )))),
                                      onPressed: () async {
                                        setState(() {
                                          showDetail = 1;
                                        });
                                      },
                                      child: Text(
                                        tr("amend_detail"),
                                        style: TextStyle(
                                            fontSize: Styles.textSiz,
                                            color: showDetail == 1
                                                ? Colors.white
                                                : ColorData.primaryTextColor,
                                            fontFamily: tr("currFontFamily")),
                                      ),
                                    )),
                              ),
                              Visibility(
                                visible: kunoozResponse.kunoozReceipt != null &&
                                        kunoozResponse.kunoozReceipt.length > 0
                                    ? true
                                    : false,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          foregroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  showDetail == 2
                                                      ? ColorData.toColor(
                                                          widget.colorCode)
                                                      : Colors.grey[200]),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                            Radius.circular(2.0),
                                          )))),
                                      onPressed: () async {
                                        setState(() {
                                          showDetail = 2;
                                        });
                                      },
                                      child: Text(tr("receipt_detail"),
                                          style: TextStyle(
                                              fontSize: Styles.textSiz,
                                              color: showDetail == 2
                                                  ? Colors.white
                                                  : ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showDetail == 1 ? false : true,
                          child: Container(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ColorData
                                      .eventHomePageDeSelectedCircularFill),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tr("booking_id"),
                                        style: TextStyle(
                                            fontSize: Styles.textSizeSmall,
                                            color: ColorData.primaryTextColor,
                                            fontFamily: tr("currFontFamily"))),
                                    Text(bookingNo,
                                        style: TextStyle(
                                            fontSize: Styles.textSizeSmall,
                                            color: ColorData.primaryTextColor,
                                            fontFamily: tr("currFontFamily"))),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tr('booking_type'),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Text(kunoozResponse.bookingTypeName ?? "",
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tr('booking_date_time'),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Text(
                                          DateTimeUtils()
                                              .dateToServerToDateFormat(
                                                  kunoozResponse.bookingFrom,
                                                  DateTimeUtils.ServerFormat,
                                                  DateTimeUtils
                                                      .DD_MM_YYYY_HH_MM_Format),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tr('event_name'),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Text(
                                          kunoozResponse.bookingEventName ?? "",
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(tr('guest_count'),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Text(
                                          kunoozResponse.gurrantedGuest
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        showDetail == 0
                            ? showBookingDetail(screenHeight)
                            : showDetail == 1
                                ? showAmendDetail(screenWidth, screenHeight)
                                : showReceiptDetail(screenHeight),
                        Visibility(
                          visible: showDetail == 0 ? true : false,
                          child: Container(
                            width: screenWidth,
                            margin: Localizations.localeOf(context)
                                        .languageCode ==
                                    "en"
                                ? EdgeInsets.only(
                                    right: 20, top: 10, bottom: 10)
                                : EdgeInsets.only(left: 0, top: 10, bottom: 10),
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Align(
                                            alignment:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                            child: Text(tr("original_Amount"),
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor
                                                        .withOpacity(1.0),
                                                    fontSize:
                                                        Styles.loginBtnFontSize,
                                                    fontFamily:
                                                        tr('currFontFamily')))),
                                      ),
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment:
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Text(
                                          " " +
                                              kunoozResponse.grossAmount
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Align(
                                            alignment:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment:
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Text(
                                          " " +
                                              kunoozResponse.vatAmount
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
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.40,
                                        child: Align(
                                            alignment:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                            child: Text(tr("service_amount"),
                                                style: TextStyle(
                                                    color: ColorData
                                                        .primaryTextColor
                                                        .withOpacity(1.0),
                                                    fontSize:
                                                        Styles.loginBtnFontSize,
                                                    fontFamily:
                                                        tr('currFontFamily')))),
                                      ),
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment:
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Text(
                                          " " +
                                              kunoozResponse.serviceAmount
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
                                  visible: kunoozResponse.discountAmount > 0
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Align(
                                              alignment:
                                                  Localizations.localeOf(context)
                                                              .languageCode ==
                                                          "en"
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: Text(
                                                  "(-) " + tr("discount_title"),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily')))),
                                        ),
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
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          alignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Text(
                                            " " +
                                                kunoozResponse.discountAmount
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: kunoozResponse.deliveryCharges > 0
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Align(
                                              alignment:
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: Text(
                                                  tr("delivery_charges"),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily')))),
                                        ),
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
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          alignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Text(
                                            " " +
                                                kunoozResponse.deliveryCharges
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: kunoozResponse.advanceAmount > 0
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
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.40,
                                          child: Align(
                                              alignment:
                                                  Localizations.localeOf(
                                                                  context)
                                                              .languageCode ==
                                                          "en"
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: Text(
                                                  "(-) " + tr("advance"),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily')))),
                                        ),
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
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          alignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Text(
                                            " " +
                                                kunoozResponse.advanceAmount
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.75,
                                  margin: EdgeInsets.only(top: 8),
                                  alignment: Localizations.localeOf(context)
                                              .languageCode ==
                                          "en"
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: SizedBox(
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
                                ),
                                Container(
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.75,
                                  margin: EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Align(
                                              alignment:
                                                  Localizations.localeOf(context)
                                                              .languageCode ==
                                                          "en"
                                                      ? Alignment.centerRight
                                                      : Alignment.centerLeft,
                                              child: Text(tr("final_Amount"),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor
                                                          .withOpacity(1.0),
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily'))))),
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
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        alignment:
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Text(
                                          " " +
                                              kunoozResponse.balanceAmount
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
                                  visible: showDetail == 0 &&
                                          kunoozResponse
                                                  .onlineAadvanceRequestAmount >
                                              0
                                      ? true
                                      : false,
                                  child: Container(
                                    // width:
                                    //     MediaQuery.of(context).size.width * 0.75,
                                    margin: EdgeInsets.only(top: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.4,
                                            child: Align(
                                                alignment:
                                                    Localizations.localeOf(context)
                                                                .languageCode ==
                                                            "en"
                                                        ? Alignment.centerRight
                                                        : Alignment.centerLeft,
                                                child: Text(
                                                    tr("amount_to_be_paid"),
                                                    style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor
                                                            .withOpacity(1.0),
                                                        fontSize: Styles
                                                            .loginBtnFontSize,
                                                        fontFamily:
                                                            tr('currFontFamily'))))),
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
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          alignment:
                                              Localizations.localeOf(context)
                                                          .languageCode ==
                                                      "en"
                                                  ? Alignment.centerRight
                                                  : Alignment.centerLeft,
                                          child: Text(
                                            " " +
                                                kunoozResponse
                                                    .onlineAadvanceRequestAmount
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
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: showDetail == 2 ? true : false,
                          child: Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: ElevatedButton(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(tr('download_contract'),
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
                                          ColorData.toColor(widget.colorCode)),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  )))),
                              onPressed: () async {
                                BlocProvider.of<FacilityContentBloc>(context)
                                    .add(GetKunoozContractDownload(
                                        bookingId: widget.bookingId));
                              },
                              // textColor: Colors.white,
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : CircularProgressIndicator(),
          bottomNavigationBar: (showDetail == 0 &&
                  kunoozResponse.advanceAmount == 0 &&
                  kunoozResponse.amendmentStatusId != 1 &&
                  kunoozResponse.onlineAadvanceRequestAmount == 0)
              ? Padding(
                  padding: EdgeInsets.only(bottom: 4, left: 20, right: 20),
                  child:
                      cancelEnquiryBtn(screenWidth * 0.38, screenHeight * 0.04),
                )
              : (showDetail == 0 && kunoozResponse.amendmentStatusId == 1)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        rejectAmendBtn(screenWidth * 0.34, screenHeight * 0.04),
                        acceptAmendBtn(screenWidth * 0.34, screenHeight * 0.04),
                      ],
                    )
                  : (showDetail == 0 &&
                          kunoozResponse.onlineAadvanceRequestAmount != null &&
                          kunoozResponse.onlineAadvanceRequestAmount > 0 &&
                          kunoozResponse.advanceAmount == 0)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            cancelEnquiryBtn(
                                screenWidth * 0.38, screenHeight * 0.04),
                            proceedToPayBtn(
                                screenWidth * 0.38, screenHeight * 0.04),
                          ],
                        )
                      : Visibility(
                          visible: (showDetail == 0 &&
                              kunoozResponse.onlineAadvanceRequestAmount !=
                                  null &&
                              kunoozResponse.onlineAadvanceRequestAmount > 0),
                          child: Padding(
                            padding:
                                EdgeInsets.only(bottom: 4, left: 20, right: 20),
                            child: proceedToPayBtn(
                                screenWidth * 0.7, screenHeight * 0.04),
                          ),
                        ),
        ));
  }

  cancelEnquiryBtn(double sWidth, double sHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sWidth, sHeight),
        maximumSize: Size(sWidth, sHeight),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () async {
        customAlertDialog(
            context,
            tr("confirm_enquiry_text"),
            tr("yes"),
            tr("no"),
            tr("confirm_cancel"),
            tr("confirm"),
            () => {
                  BlocProvider.of<FacilityContentBloc>(context).add(
                      GetKunoozCancelBooking(
                          bookingId: kunoozResponse.bookingId))
                });
      },
      child: Text(tr("cancel_enquiry"),
          style: EventPeopleListPageStyle
              .eventPeopleListPageSubHeadingTextStyleWithoutAr(context)),
    );
  }

  rejectAmendBtn(double sWidth, double sHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sWidth, sHeight),
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () async {
        customAlertDialog(
            context,
            tr("reject_amendment_text"),
            tr("yes"),
            tr("no"),
            tr("confirm_rever"),
            tr("confirm"),
            () => {
                  Navigator.pop(context),
                  BlocProvider.of<FacilityContentBloc>(context).add(
                      GetKunoozRevertAmendmentEvent(
                          bookingId: kunoozResponse.bookingId, isAccept: 2))
                });
      },
      child: Text(tr("reject"),
          style: EventPeopleListPageStyle
              .eventPeopleListPageSubHeadingTextStyleWithoutAr(context)),
    );
  }

  acceptAmendBtn(double sWidth, double sHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sWidth, sHeight),
        backgroundColor: ColorData.toColor(widget.colorCode),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () async {
        customAlertDialog(
            context,
            tr("amend_enquiry_text"),
            tr("yes"),
            tr("no"),
            tr("confirm_amend"),
            tr("confirm"),
            () => {
                  Navigator.pop(context),
                  BlocProvider.of<FacilityContentBloc>(context).add(
                      GetKunoozRevertAmendmentEvent(
                          bookingId: kunoozResponse.bookingId, isAccept: 1))
                });
      },
      child: Text(tr("amend"),
          style: EventPeopleListPageStyle.eventPeopleListPageBtnTextStyleWithAr(
              context)),
    );
  }

  proceedToPayBtn(double sWidth, double sHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(sWidth, sHeight),
        maximumSize: Size(sWidth, sHeight),
        backgroundColor: ColorData.toColor(widget.colorCode),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: Text(tr('proceed_to_pay'),
                style: EventPeopleListPageStyle
                    .eventPeopleListPageBtnTextStyleWithAr(context)),
          ),
        ],
      ),
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FacilityBuyPaymentPage(
                      kunoozResponse: kunoozResponse,
                      termsList: termsList,
                      colorCode: widget.colorCode,
                    )));
        BlocProvider.of<FacilityContentBloc>(context)
            .add(GetKunoozBookingData(bookingId: widget.bookingId));
      },
      // textColor: Colors.white,
      //color: Theme.of(context).primaryColor,
    );
  }

  showBookingDetail(double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: screenHeight * 0.24,
      padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: ColorData.eventHomePageDeSelectedCircularFill),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: (kunoozResponse.kunoozBookingItemDto != null &&
              kunoozResponse.kunoozBookingItemDto.isNotEmpty)
          ? ListView.separated(
              itemCount: kunoozResponse.kunoozBookingItemDto.length,
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
                                kunoozResponse.kunoozBookingItemDto[index]
                                        .facilityItemname ??
                                    "",
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.primaryTextColor,
                                    fontFamily: tr("currFontFamily")),
                              ),
                              Text(
                                tr('rate') +
                                    ": AED  " +
                                    kunoozResponse
                                        .kunoozBookingItemDto[index].price
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
                                kunoozResponse.kunoozBookingItemDto[index].qty
                                    .toString(),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.primaryTextColor,
                                    fontFamily: tr("currFontFamily")),
                              ),
                              Text(
                                "AED  " +
                                    kunoozResponse
                                        .kunoozBookingItemDto[index].amount
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
                      visible: kunoozResponse
                                  .kunoozBookingItemDto[index].serviceAmount >
                              0
                          ? true
                          : false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "SC: AED  " +
                              kunoozResponse
                                  .kunoozBookingItemDto[index].serviceAmount
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
                          kunoozResponse.kunoozBookingItemDto[index].discount >
                                  0
                              ? true
                              : false,
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Disc: AED  " +
                              kunoozResponse
                                  .kunoozBookingItemDto[index].discount
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
            )
          : Center(
              child: Text("No Data Found",
                  style: TextStyle(
                      fontSize: Styles.textSizeSmall,
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"))),
            ),
    );
  }

  showAmendDetail(double screenWidth, double screenHeight) {
    return SizedBox(
      height: screenHeight * 0.76,
      child: (kunoozResponse.amendment != null &&
              kunoozResponse.amendment.isNotEmpty)
          ? ListView.separated(
              itemCount: kunoozResponse.amendment.length,
              padding: EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (BuildContext context, index) {
                bool hideAmendDate =
                    (kunoozResponse.amendment[index].bookingFrom ==
                            kunoozResponse.amendment[index].bookingFromChange)
                        ? false
                        : true;
                bool hideAmendGuestCount =
                    (kunoozResponse.amendment[index].actualGuest ==
                            kunoozResponse.amendment[index].amendedGuest)
                        ? false
                        : true;
                bool hideAmendTotal =
                    (kunoozResponse.amendment[index].actualAmount ==
                            kunoozResponse.amendment[index].amendedAmount)
                        ? false
                        : true;
                String contractNo = "";
                if (kunoozResponse.amendment[index].amendmentNo > 0) {
                  contractNo = kunoozResponse.amendment[index].amendmentNoShow +
                      "-" +
                      kunoozResponse.amendment[index].amendmentNo.toString();
                } else {
                  contractNo = kunoozResponse.amendment[index].amendmentNoShow;
                }
                return Container(
                  padding:
                      EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: ColorData.eventHomePageDeSelectedCircularFill),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tr("contract_no"),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr("currFontFamily"))),
                          Text(contractNo,
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  fontWeight: FontWeight.w500,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr("currFontFamily"))),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(tr('booking_detail'),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamily"))),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(tr('date_time'),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.primaryTextColor,
                                    fontFamily: tr("currFontFamily"))),
                            Text(
                                DateTimeUtils().dateToServerToDateFormat(
                                    kunoozResponse.amendment[index].bookingFrom,
                                    DateTimeUtils.ServerFormat,
                                    DateTimeUtils.DD_MM_YYYY_HH_MM_Format),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.primaryTextColor,
                                    fontFamily: tr("currFontFamily"))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(tr('guest_count'),
                                    style: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr("currFontFamily"))),
                                Text(
                                    kunoozResponse.amendment[index].actualGuest
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr("currFontFamily"))),
                              ],
                            ),
                            Text(
                              "AED  " +
                                      kunoozResponse
                                          .amendment[index].actualAmount
                                          .toStringAsFixed(2) ??
                                  "",
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: ColorData.toColor(widget.colorCode),
                                  fontFamily: tr("currFontFamily")),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        // visible: !hideAmendAll,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Text(tr('amend_from'),
                                  style: TextStyle(
                                      fontSize: Styles.textSizeSmall,
                                      color: ColorData.primaryTextColor,
                                      fontFamily: tr("currFontFamily"))),
                            ),
                            Visibility(
                              visible: true,
                              child: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(tr('date_time'),
                                        style: TextStyle(
                                            fontSize: Styles.textSizeSmall,
                                            color: ColorData.primaryTextColor,
                                            fontFamily: tr("currFontFamily"))),
                                    Text(
                                        DateTimeUtils()
                                            .dateToServerToDateFormat(
                                                kunoozResponse.amendment[index]
                                                    .bookingFromChange,
                                                DateTimeUtils.ServerFormat,
                                                DateTimeUtils
                                                    .DD_MM_YYYY_HH_MM_Format),
                                        style: TextStyle(
                                            fontSize: Styles.textSizeSmall,
                                            color: ColorData.primaryTextColor,
                                            fontFamily: tr("currFontFamily"))),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: true,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(tr('guest_count'),
                                            style: TextStyle(
                                                fontSize: Styles.textSizeSmall,
                                                color:
                                                    ColorData.primaryTextColor,
                                                fontFamily:
                                                    tr("currFontFamily"))),
                                        Text(
                                            kunoozResponse
                                                .amendment[index].amendedGuest
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: Styles.textSizeSmall,
                                                color:
                                                    ColorData.primaryTextColor,
                                                fontFamily:
                                                    tr("currFontFamily"))),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                      visible: true,
                                      child: Text(
                                        "AED  " +
                                                kunoozResponse.amendment[index]
                                                    .amendedAmount
                                                    .toStringAsFixed(2) ??
                                            "",
                                        style: TextStyle(
                                            fontSize: Styles.textSizeSmall,
                                            color: ColorData.toColor(
                                                widget.colorCode),
                                            fontFamily: tr("currFontFamily")),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                BlocProvider.of<FacilityContentBloc>(context)
                                    .add(GetKunoozAmendmentDownload(
                                        amendmentId: kunoozResponse
                                            .amendment[index].amendmentId));
                              },
                              icon: Icon(
                                Icons.download_outlined,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  BlocProvider.of<FacilityContentBloc>(context)
                                      .add(GetKunoozAmendContractData(
                                          amendId: kunoozResponse
                                              .amendment[index].amendmentId));
                                },
                                icon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: ColorData.toColor(widget.colorCode),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, index) {
                return SizedBox(height: screenHeight * 0.01);
              },
            )
          : Center(
              child: Text("No Data Found",
                  style: TextStyle(
                      fontSize: Styles.textSizeSmall,
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"))),
            ),
    );
  }

  showReceiptDetail(double screenHeight) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: screenHeight * 0.3,
      padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            Border.all(color: ColorData.eventHomePageDeSelectedCircularFill),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: (kunoozResponse.kunoozReceipt != null &&
              kunoozResponse.kunoozReceipt.isNotEmpty)
          ? ListView.separated(
              itemCount: kunoozResponse.kunoozReceipt.length,
              itemBuilder: (BuildContext context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          kunoozResponse.kunoozReceipt[index].tenderType,
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.primaryTextColor,
                              fontFamily: tr("currFontFamily")),
                        ),
                        Text(
                          kunoozResponse.kunoozReceipt[index].paymentMode,
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: ColorData.primaryTextColor,
                              fontFamily: tr("currFontFamily")),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              DateTimeUtils().dateToServerToDateFormat(
                                  kunoozResponse
                                      .kunoozReceipt[index].createdDate,
                                  DateTimeUtils.ServerFormat,
                                  DateTimeUtils.DD_MM_YYYY_HH_MM_Format),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr("currFontFamily"))),
                          Text(
                            "AED  " +
                                kunoozResponse.kunoozReceipt[index].amount
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.toColor(widget.colorCode),
                                fontFamily: tr("currFontFamily")),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
              separatorBuilder: (BuildContext context, index) {
                return Divider();
              },
            )
          : Center(
              child: Text("No Data Found",
                  style: TextStyle(
                      fontSize: Styles.textSizeSmall,
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"))),
            ),
    );
  }

  void amendBottomSheet(context, double screenWidth, double screenHeight,
      KunuoozContractDto kunoozContractDto) {
    List<AmendedDetails> actualDetails = kunoozContractDto.actaulDetails;
    List<AmendedDetails> amendedDetails = kunoozContractDto.amendedDetails;
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            margin: EdgeInsets.only(left: 1, right: 1),
            padding: EdgeInsets.all(20),
            height: screenHeight * 0.6,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(20.0),
                    topRight: const Radius.circular(20.0))),
            child: kunoozContractDto != null
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Amend To",
                              style: TextStyle(
                                  fontSize: Styles.textSizRegular,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr("currFontFamily"))),
                          Text(kunoozContractDto.contractNo,
                              style: TextStyle(
                                  fontSize: Styles.textSizRegular,
                                  color: ColorData.primaryTextColor,
                                  fontFamily: tr("currFontFamily")))
                        ],
                      ),
                      Container(
                        height: screenHeight * 0.2,
                        width: screenWidth,
                        margin: EdgeInsets.only(top: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: ColorData
                                  .eventHomePageDeSelectedCircularFill),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: (actualDetails != null &&
                                actualDetails.isNotEmpty)
                            ? ListView.separated(
                                itemCount: actualDetails.length,
                                padding:
                                    EdgeInsets.only(top: 12, left: 8, right: 8),
                                itemBuilder: (BuildContext context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(actualDetails[index].itemDescription,
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "QTY: " +
                                                    actualDetails[index]
                                                        .quantity
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.textSizeSmall,
                                                    color: ColorData
                                                        .primaryTextColor,
                                                    fontFamily:
                                                        tr("currFontFamily"))),
                                            Text(
                                                "AED  " +
                                                    actualDetails[index]
                                                        .totalWithTax
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.textSizeSmall,
                                                    color: ColorData.toColor(
                                                        widget.colorCode),
                                                    fontFamily:
                                                        tr("currFontFamily"))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return Divider();
                                },
                              )
                            : Center(
                                child: Text("No Actual Data Found",
                                    style: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr("currFontFamily"))),
                              ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 14),
                        child: Text("Amend From",
                            style: TextStyle(
                                fontSize: Styles.textSizRegular,
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamily"))),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        height: screenHeight * 0.2,
                        width: screenWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: ColorData
                                  .eventHomePageDeSelectedCircularFill),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: (amendedDetails != null &&
                                amendedDetails.isNotEmpty)
                            ? ListView.separated(
                                itemCount: amendedDetails.length,
                                padding:
                                    EdgeInsets.only(top: 12, left: 8, right: 8),
                                itemBuilder: (BuildContext context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          amendedDetails[index].itemDescription,
                                          style: TextStyle(
                                              fontSize: Styles.textSizeSmall,
                                              color: ColorData.primaryTextColor,
                                              fontFamily:
                                                  tr("currFontFamily"))),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                "QTY: " +
                                                    amendedDetails[index]
                                                        .quantity
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.textSizeSmall,
                                                    color: ColorData
                                                        .primaryTextColor,
                                                    fontFamily:
                                                        tr("currFontFamily"))),
                                            Text(
                                                "AED  " +
                                                    amendedDetails[index]
                                                        .totalWithTax
                                                        .toStringAsFixed(2),
                                                style: TextStyle(
                                                    fontSize:
                                                        Styles.textSizeSmall,
                                                    color: ColorData.toColor(
                                                        widget.colorCode),
                                                    fontFamily:
                                                        tr("currFontFamily"))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return Divider();
                                },
                              )
                            : Center(
                                child: Text("No Amend Data Found",
                                    style: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr("currFontFamily"))),
                              ),
                      ),
                    ],
                  )
                : Center(
                    child: Text("No Data Found",
                        style: TextStyle(
                            fontSize: Styles.textSizeSmall,
                            color: ColorData.primaryTextColor,
                            fontFamily: tr("currFontFamily"))),
                  ),
          );
        });
  }

  downloadFacilityPdf(String url, String fileName, bool isContract) async {
    String tempFileName = url.split("/").last;
    if (url.isEmpty) {
      debugPrint("ERROR");
      util.customGetSnackBarWithOutActionButton(
          tr("kunooz"), tr('invalid_doc'), context);
    }
    bool dirDownloadExists = true;
    var directory;
    if (Platform.isIOS) {
      directory = await getDownloadsDirectory();
    } else {
      directory = "/storage/emulated/0/Download/";
      dirDownloadExists = await Directory(directory).exists();
      if (Platform.isAndroid) {
        if (dirDownloadExists) {
          directory = "/storage/emulated/0/Download/";
        } else {
          directory = "/storage/emulated/0/Downloads/";
        }
      }
    }
    HttpClient httpClient = new HttpClient();
    File file;
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      String filePath = '$directory/$tempFileName';
      // '$directory/$fileName-${(DateTime.now().microsecond.toString())}.pdf';
      file = File(filePath);
      await file.writeAsBytes(bytes);
      debugPrint("Downloaded:::::::::::::::::::");
      util.customGetSnackBarWithOutActionButton(
          tr("kunooz"),
          isContract
              ? tr('contract_document_downloaded')
              : tr('amend_document_downloaded'),
          context);
    } else {
      debugPrint("ERROR");
      util.customGetSnackBarWithOutActionButton(
          tr("kunooz"), tr('document_not_found'), context);
    }
  }
}
