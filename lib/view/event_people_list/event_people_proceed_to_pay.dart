import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/repo/event_repository.dart';
// import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/utils/flutter_masked_text.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_people_list/PaymentFooter.dart';
import 'package:slc/view/event_people_list/web_page.dart';
import 'package:apple_pay_flutter/apple_pay_flutter.dart';

import '../../common/colors.dart';
import '../../model/facility_item.dart';
import '../../model/giftvoucher_request.dart';
import '../../model/payment_terms_response.dart';
import '../../repo/facility_detail_repository.dart';
import 'package:slc/utils/strings.dart';
import 'bloc/bloc.dart';
import 'event_people_list.dart';
// import 'event_people_list.dart';

// ignore: must_be_immutable
class EventPeopleProceedToPay extends StatelessWidget {
  int eventId;
  final List<EventPriceCategory> eventPriceCategoryList;
  bool showAddPeople;
  double total = 0;
  bool enablePayments = true;
  double taxAmt = 0;
  double taxableAmt = 0;
  double discountAmt = 0;
  bool saveInProgress = false;
  BillDiscounts discount = new BillDiscounts();
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  GiftVocuher selectedVoucher = new GiftVocuher();

  EventPeopleProceedToPay({
    this.eventId,
    this.eventPriceCategoryList,
    this.showAddPeople,
    this.taxableAmt,
    this.billDiscounts,
    this.giftVouchers,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventPeopleListBloc>(
      create: (context) => EventPeopleListBloc(null)
        ..add(GetEventParticipantListEvent(eventId: eventId)),
      child: PaymentPage(
          eventPriceCategoryList: eventPriceCategoryList,
          eventId: eventId,
          title: tr("payment"),
          showAddPeople: showAddPeople,
          taxableAmt: taxableAmt,
          billDiscounts: billDiscounts,
          giftVouchers: giftVouchers),
    );
  }
}

// ignore: must_be_immutable
class PaymentPage extends StatefulWidget {
  PaymentPage(
      {Key key,
      this.title,
      this.eventPriceCategoryList,
      this.eventId,
      this.showAddPeople,
      this.taxableAmt,
      this.billDiscounts,
      this.giftVouchers});

  final String title;
  int eventId;
  bool showAddPeople;
  double total = 0;
  bool enablePayments = true;
  double taxAmt = 0;
  double taxableAmt = 0;
  double discountAmt = 0;
  bool saveInProgress = false;
  BillDiscounts discount = new BillDiscounts();
  List<BillDiscounts> billDiscounts = [];
  List<GiftVocuher> giftVouchers = [];
  PaymentTerms terms = new PaymentTerms(termsId: 0, terms: "");
  GiftVocuher selectedVoucher = new GiftVocuher();
  final List<EventPriceCategory> eventPriceCategoryList;

  @override
  _PaymentPageState createState() =>
      _PaymentPageState(eventPricingCategoryList: eventPriceCategoryList);
}

class _PaymentPageState extends State<PaymentPage> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  PageController _pageController;
  Color iconColor;
  bool _isChecked = false;
  String status = "check";
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  Utils util = new Utils();
  bool onPressedTimer = true;
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  EventParticipantResponse response = new EventParticipantResponse();
  List<EventPriceCategory> eventPricingCategoryList;
  MaskedTextController _couponController =
      new MaskedTextController(mask: Strings.maskEngCouponValidationStr);
  // FlutterPay flutterPay = FlutterPay();

  _PaymentPageState({this.eventPricingCategoryList});

  @override
  void initState() {
    super.initState();
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });

    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<EventPeopleListBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<EventPeopleListBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<EventPeopleListBloc, EventPeopleListState>(
      listener: (context, state) {
        if (state is ShowEventPeopleListProgressBarState) {
          _handler.show();
        } else if (state is HideEventPeopleListProgressBarState) {
          _handler.dismiss();
        } else if (state is OnFailureEventPeopleListState) {
          Utils().customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is LoadPeopleList) {
          response = state.response;
          widget.taxableAmt = response.totalParticipantAmount != 0.0
              ? response.totalParticipantAmount
              : 0.0;
          widget.total = widget.taxableAmt;
        } else if (state is ErrorDialogState &&
            !SPUtil.getBool(Constants.PREVENT_MULTIPLE_DIALOG)) {
          SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, true);
          SPUtil.remove(Constants.USERID);
          getCustomAlertPositive(
            context,
            positive: () {
              SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, false);
              exit(0);
            },
            title: tr("payment"),
            content: state.content,
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<EventPeopleListBloc, EventPeopleListState>(
          builder: (context, state) {
            return Container(
                child: Stack(children: <Widget>[
              response != null ? mainUi() : Container(),
              progressBar
            ]));
          },
        ),
      ),
    );
  }

  Widget mainUi() {
    // print('widget.showAddPeople---> ${widget.showAddPeople}');
    // print('widget.eventId---> ${widget.eventId}');
    // print('widget.eventId---> ${response.name}');
    // print('widget.eventId---> ${_isChecked}');
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: Platform.isIOS ? 100.0 : 75.0,
              margin: EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 10),
              child: response.name != null && _isChecked
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        response.eventParticipantList != null &&
                                response.eventParticipantList.length >= 0
                            ? Container(
                                width: MediaQuery.of(context).size.width - 60,
                                margin: EdgeInsets.only(
                                    top: 8, left: 10.0, right: 10.0),
                                child: Column(children: [
                                  Visibility(
                                      visible: Platform.isIOS &&
                                          widget.enablePayments,
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              foregroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.black),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                Radius.circular(8.0),
                                              )))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                    tr('proceed_to_applepay'),
                                                    style: EventPeopleListPageStyle
                                                        .eventPeopleListPageBtnTextStyleWithAr(
                                                            context)),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 2, right: 2),
                                                  child: Icon(
                                                      ApplePayIcon.apple_pay,
                                                      color: Colors.white,
                                                      size: 30)),
                                            ],
                                          ),
                                          // shape: new RoundedRectangleBorder(
                                          //   borderRadius:
                                          //       new BorderRadius.circular(8),
                                          // ),
                                          // color: Colors.black,
                                          onPressed: () async {
                                            _handler.show();
                                            widget.enablePayments = false;
                                            setState(() {});
                                            // widget.total =
                                            //     response.totalParticipantAmount !=
                                            //             0.0
                                            //         ? response
                                            //             .totalParticipantAmount
                                            //         : 0.0;
                                            Meta m = await EventRepository()
                                                .getPaymentOrderRequest(
                                                    widget.eventId,
                                                    widget.discountAmt,
                                                    widget.discount != null
                                                        ? widget
                                                            .discount.discountId
                                                        : 0);
                                            if (m.statusCode == 200) {
                                              // ignore: unnecessary_statements
                                              _handler.dismiss;
                                              Map<String, dynamic> decode =
                                                  m.toJson();
                                              // print('12' + decode['statusMsg']);
                                              Map userMap = jsonDecode(
                                                  decode['statusMsg']);
                                              // print(userMap);
                                              userMap.forEach((key, val) {
                                                print(
                                                    '{ key: $key, value: $val}');
                                                if (key == 'response') {
                                                  //call apple pay
                                                  Map payment = new Map<String,
                                                      dynamic>.from(val);
                                                  String applePayUrl =
                                                      payment["applePayUrl"];
                                                  int orderId =
                                                      payment["orderId"];
                                                  String merchantReferenceNo =
                                                      payment[
                                                          'merchantReferenceNo'];
                                                  String merchantIdentifier =
                                                      payment[
                                                          'merchantIdentifier'];
                                                  String facilityName =
                                                      payment['facilityName'];
                                                  makePayment(
                                                      widget.total,
                                                      applePayUrl,
                                                      orderId,
                                                      merchantReferenceNo,
                                                      merchantIdentifier,
                                                      facilityName);
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
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.white),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Theme.of(context)
                                                          .primaryColor),
                                              shape: MaterialStateProperty.all<
                                                      RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                Radius.circular(8.0),
                                              )))),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                child: Text(
                                                    tr('proceed_to_pay'),
                                                    style: EventPeopleListPageStyle
                                                        .eventPeopleListPageBtnTextStyleWithAr(
                                                            context)),
                                              ),
                                            ],
                                          ),
                                          // shape: new RoundedRectangleBorder(
                                          //   borderRadius:
                                          //       new BorderRadius.circular(8),
                                          // ),
                                          onPressed: () async {
                                            // ignore: unnecessary_statements
                                            _handler.show();
                                            widget.enablePayments = false;
                                            setState(() {});
                                            Meta m = await EventRepository()
                                                .getPaymentOrderRequest(
                                                    widget.eventId,
                                                    widget.discountAmt,
                                                    widget.discount != null
                                                        ? widget
                                                            .discount.discountId
                                                        : 0);

                                            if (m.statusCode == 200) {
                                              // ignore: unnecessary_statements
                                              _handler.dismiss();

                                              Map<String, dynamic> decode =
                                                  m.toJson();

                                              Map userMap = jsonDecode(
                                                  decode['statusMsg']);
                                              print(userMap);
                                              userMap.forEach((key, val) {
                                                print(
                                                    '{ key: $key, value: $val}');
                                                if (key == 'response') {
                                                  Map payment = new Map<String,
                                                      dynamic>.from(val);
                                                  var list = [];
                                                  payment.entries
                                                      .forEach((e) => {
                                                            if (e.key ==
                                                                'payment')
                                                              {
                                                                list.add(e.value
                                                                    .toString()
                                                                    .replaceAll(
                                                                        "href:",
                                                                        ''))
                                                              },
                                                          });
                                                  var first = list[0]
                                                      .toString()
                                                      .replaceAll('{', "");
                                                  openWebView(first
                                                      .replaceAll("}", '')
                                                      .trim());
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
                                            //  getAccessToken();
                                          }

                                          // textColor: Colors.white,
                                          // color: Theme.of(context).primaryColor,
                                          ))
                                ]),
                              )
                            : Container(),
                      ],
                    )
                  : Container(),
            ),
          ],
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: CustomAppBar(
            title: tr('payment'),
          ),
        ),
        body: SingleChildScrollView(
          child: response.name != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        child: getMember(context),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x25252525),
                                blurRadius: 2,
                                spreadRadius: 2)
                          ],
                        )),
                    SizedBox(height: 10),
                    Visibility(
                        visible: widget.billDiscounts.length > 0 ? true : false,
                        child: Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * .96,
                                margin: EdgeInsets.only(top: 5),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8)),
                                  border: Border.all(color: Colors.grey[200]),
                                  color: Colors.white,
                                ),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    leading: Icon(Icons.local_offer_outlined,
                                        color: ColorData.primaryTextColor
                                            .withOpacity(1.0)),
                                    title: Text(
                                        widget.discount != null &&
                                                widget.discount.discountName !=
                                                    null
                                            ? widget.discount.discountName
                                            : 'Save with ' +
                                                widget.billDiscounts.length
                                                    .toString() +
                                                ' Offers',
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor
                                                .withOpacity(1.0),
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily: tr('currFontFamily'))),
                                    trailing: new OutlinedButton(
                                      onPressed: () {
                                        displayDiscountModalBottomSheet(
                                            context);
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
                                ])))),
                    // SizedBox(height: 5),
                    // Visibility(
                    //     visible: widget.showGiftCardRedeem, // Giftcard
                    //     child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.start,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Container(
                    //               width:
                    //                   MediaQuery.of(context).size.width * .98,
                    //               decoration: BoxDecoration(
                    //                 borderRadius:
                    //                     BorderRadius.all(Radius.circular(8)),
                    //                 border: Border.all(color: Colors.grey[200]),
                    //                 color: Colors.white,
                    //               ),
                    //               child: FormBuilder(
                    //                   child: Column(children: <Widget>[
                    //                 Visibility(
                    //                     visible: widget.showGiftCardRedeem,
                    //                     child: Container(
                    //                       padding: EdgeInsets.fromLTRB(
                    //                           1.0, 0, 1.0, 0),
                    //                       child: CustomGiftVoucherComponent(
                    //                           selectedFunction:
                    //                               _onChangeOptionVoucherDropdown,
                    //                           voucherController: _giftCardText,
                    //                           isEditBtnEnabled:
                    //                               Strings.ProfileCallState,
                    //                           voucherResponse:
                    //                               giftVouchers == null
                    //                                   ? []
                    //                                   : giftVouchers,
                    //                           label: tr('gift_card')),
                    //                     )),
                    //                 Container(
                    //                   padding:
                    //                       EdgeInsets.fromLTRB(1.0, 0, 1.0, 0),
                    //                   child: ListTile(
                    //                     leading: Icon(
                    //                         Icons.local_offer_outlined,
                    //                         color: ColorData.primaryTextColor),
                    //                     title: Column(children: [
                    //                       Text(tr("gift_voucher_rdeem_amount"),
                    //                           style: TextStyle(
                    //                               color: ColorData
                    //                                   .primaryTextColor,
                    //                               fontSize: Styles
                    //                                   .packageExpandTextSiz,
                    //                               fontFamily:
                    //                                   tr('currFontFamily'))),
                    //                       Text(_vchErrorText,
                    //                           style: TextStyle(
                    //                               color: ColorData
                    //                                   .primaryTextColor,
                    //                               fontSize: Styles
                    //                                   .packageExpandTextSiz,
                    //                               fontFamily:
                    //                                   tr('currFontFamily')))
                    //                     ]),
                    //                     trailing: Container(
                    //                         width: MediaQuery.of(context).size.width *
                    //                             0.16,
                    //                         height: MediaQuery.of(context)
                    //                                 .size
                    //                                 .height *
                    //                             0.045,
                    //                         child: new TextFormField(
                    //                             keyboardType:
                    //                                 TextInputType.number,
                    //                             controller:
                    //                                 _giftVoucherUsedAmount,
                    //                             enabled: widget.selectedVoucher !=
                    //                                         null &&
                    //                                     widget.selectedVoucher
                    //                                             .giftVoucherId !=
                    //                                         null &&
                    //                                     widget.selectedVoucher
                    //                                             .giftVoucherId >
                    //                                         0 &&
                    //                                     widget.selectedVoucher
                    //                                             .balanceAmount >
                    //                                         100
                    //                                 ? true
                    //                                 : false,
                    //                             textAlign: TextAlign.center,
                    //                             decoration: new InputDecoration(
                    //                               contentPadding:
                    //                                   EdgeInsets.all(5),
                    //                               // contentPadding: EdgeInsets.only(
                    //                               //     left: 10, top: 0, bottom: 0, right: 0),
                    //                               hintText: "",
                    //                               border: new OutlineInputBorder(
                    //                                   borderSide:
                    //                                       new BorderSide(
                    //                                           color: Colors
                    //                                               .black12)),
                    //                               // focusedBorder: OutlineInputBorder(
                    //                               //     borderSide: new BorderSide(
                    //                               //         color: Colors.grey[200]))),
                    //                             ),
                    //                             onChanged: (value) {
                    //                               _vchErrorText = "";
                    //                               double enteredAmt = 0;
                    //                               if (value != "" &&
                    //                                   widget.selectedVoucher !=
                    //                                       null) {
                    //                                 enteredAmt =
                    //                                     double.parse(value);
                    //                               } else {
                    //                                 //_giftVoucherUsedAmount.text =
                    //                                 //  "";
                    //                                 getTotal();
                    //                                 //FocusScope.of(context).requestFocus(focusNode);
                    //                                 return;
                    //                               }
                    //                               if (enteredAmt < 100 &&
                    //                                   widget.selectedVoucher
                    //                                           .balanceAmount >
                    //                                       100) {
                    //                                 _vchErrorText = tr(
                    //                                     "amount_should_be_hundred_or_greater");
                    //                               } else if (widget
                    //                                       .selectedVoucher
                    //                                       .balanceAmount <
                    //                                   100) {
                    //                                 _giftVoucherUsedAmount
                    //                                         .text =
                    //                                     widget.selectedVoucher
                    //                                         .balanceAmount
                    //                                         .toStringAsFixed(2);
                    //                               } else if (widget
                    //                                       .selectedVoucher
                    //                                       .balanceAmount <
                    //                                   enteredAmt) {
                    //                                 _vchErrorText = tr(
                    //                                     "amount_should_be_not_be_greater_than_balance_amount");
                    //                                 _giftVoucherUsedAmount
                    //                                         .text =
                    //                                     widget.selectedVoucher
                    //                                         .balanceAmount
                    //                                         .toStringAsFixed(2);
                    //                               }
                    //                               //setState(() {});
                    //                               getTotal();
                    //                               if (widget.total < 0) {
                    //                                 _vchErrorText = tr(
                    //                                     "amount_should_be_not_be_greater_than_total_amount");
                    //                                 getTotal();
                    //                               }
                    //                             },
                    //                             style: TextStyle(
                    //                                 fontSize: Styles
                    //                                     .packageExpandTextSiz,
                    //                                 fontFamily:
                    //                                     tr("currFontFamilyEnglishOnly"),
                    //                                 color: ColorData.primaryTextColor,
                    //                                 fontWeight: FontWeight.w200))),
                    //                   ),
                    //                 ),
                    //               ])))
                    //         ])),
                    SizedBox(height: 5),
                    Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 35),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(tr("accept_proceed"),
                                  style: EventDetailPageStyle.acceptProceed(
                                    context,
                                  )),
                              Container(
                                height: 100,
                                margin: EdgeInsets.only(top: 12),
                                child: SingleChildScrollView(
                                  child: Text(
                                    tr("payment_terms_conditions"),
                                    style: EventDetailPageStyle
                                        .eventDetailPageTextStyleWithAr(
                                            context),
                                  ),
                                ),
                              ),
                              Text(tr("dont_press_back_button"),
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 12)),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: _isChecked,
                                    onChanged: (val) => {
                                      setState(() {
                                        _isChecked = val;
                                      })
                                    },
                                  ),
                                  Text(
                                    tr("i_accept"),
                                    style: EventDetailPageStyle.acceptProceed(
                                        context),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0x25252525),
                                blurRadius: 2,
                                spreadRadius: 2)
                          ],
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(tr("original_Amount"),
                                          style: EventDetailPageStyle
                                              .eventOriginalStyleWithAr(
                                                  context))),
                                  Container(margin: EdgeInsets.only(top: 12)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 8),
                                      child: Row(
                                        children: [
                                          Text(
                                            "AED  ",
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                          Text(
                                            " " +
                                                widget.taxableAmt
                                                    .toStringAsFixed(2),
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                        ],
                                      )),
                                  Container(),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    margin: EdgeInsets.only(top: 12),
                                    child: Divider(
                                      thickness: 1,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(tr("discount_title"),
                                          style: EventDetailPageStyle
                                              .eventOriginalStyleWithAr(
                                                  context))),
                                  Container(margin: EdgeInsets.only(top: 12)),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "AED  ",
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                          Text(
                                            " " +
                                                widget.discountAmt
                                                    .toStringAsFixed(2),
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                        ],
                                      )),
                                  Container(),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.30,
                                    margin: EdgeInsets.only(top: 12),
                                    child: Divider(
                                      thickness: 1,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.96,
                          margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      tr("final_Amount"),
                                      style: EventDetailPageStyle
                                          .eventDetailPageTextStyleWithAr(
                                              context),
                                    ),
                                    margin: EdgeInsets.only(top: 12),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                      margin: EdgeInsets.only(top: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            "AED   ",
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                          Text(
                                            "" +
                                                widget.total.toStringAsFixed(2),
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {
                        //     if (rateTxtOnTap != null) rateTxtOnTap();
                        //   },
                        //   highlightColor: Color(0x00000000),
                        //   splashColor: Color(0x00000000),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.end,
                        //     children: [
                        //       Container(
                        //         margin: EdgeInsets.only(top: 12, right: 15),
                        //         child: Text(
                        //           tr("rate_Txt"),
                        //           style: TextStyle(
                        //               fontSize: 12,
                        //               color: (rateTxtOnTap != null)
                        //                   ? Colors.lightBlue
                        //                   : Colors.grey[400]),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    )
                    // PaymentFooter(
                    //   //  finalTxt: "Final Amount",
                    //   // original: "Original Amount",
                    //   originalAmt:
                    //       response.totalParticipantAmount.toStringAsFixed(2),
                    //   subItem: "",
                    //   subItemAmt: "",
                    // )
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  Widget getMember(BuildContext buildContext) {
    return (response.eventParticipantList != null &&
            response.eventParticipantList.length > 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: response.eventParticipantList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              // String eventAmountPrice =
              //     response.eventParticipantList[i].amount != null
              //         ? Utils().getAmount(
              //             amount: response.eventParticipantList[i].amount)
              //         : "";
              Widget leading = Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(62, 181, 227, 1),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 4.0),
                  child: Icon(
                    CommonIcons.user_one,
                    color: Colors.white,
                  ),
                ),
              );
              Widget title = Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                    (response.eventParticipantList[i].firstName != null)
                        ? response.eventParticipantList[i].firstName
                        : "",
                    style: EventPeopleListPageStyle
                        .eventPeopleListPageSubHeadingTextStyle(context)),
              );
              return response.eventParticipantList[i].isPaid == false
                  ? Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: Card(
                              color: Colors.white,
                              elevation: 0.0,
                              child: ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    title,
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "AED  ",
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                          Text(
                                            response
                                                .eventParticipantList[i].amount
                                                .toStringAsFixed(2),
                                            style: EventDetailPageStyle
                                                .eventDetailPageTextStyleWithAr(
                                                    context),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                leading: leading,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Divider(
                            color: Colors.black26,
                          ),
                        )
                      ],
                    )
                  : Container();
            })
        : Container();
  }

  void openWebView(String url) {
    String val = url + "&slim=true";
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WebviewPage(
                title: tr("payment"),
                url: val,
                showAddPeople: widget.showAddPeople,
                eventPriceCategoryList: widget.eventPriceCategoryList,
                eventId: widget.eventId))).then((value) {
      widget.enablePayments = true;
      // setState(() {});
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
          Navigator.of(context).pop();
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EventPeopleList(
                        eventId: widget.eventId,
                        eventPriceCategoryList: widget.eventPriceCategoryList,
                        showAddPeople: widget.showAddPeople,
                      )));
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
                            title: Text(widget.billDiscounts[j].discountName,
                                style: TextStyle(
                                    color: widget.billDiscounts[j]
                                                    .billDiscountId ==
                                                0 &&
                                            widget.billDiscounts[j]
                                                    .voucherType ==
                                                3
                                        ? ColorData.primaryTextColor
                                            .withOpacity(1.0)
                                        : ColorData.primaryTextColor
                                            .withOpacity(1.0),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily'))),
                            trailing:
                                widget.billDiscounts[j].billDiscountId == 0 &&
                                        widget.billDiscounts[j].voucherType == 3
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
                                          // if (widget.showGiftCardRedeem) {
                                          //   _clearOptionGiftVoucher();
                                          // }
                                          if (widget.discount != null &&
                                              widget.discount.discountName !=
                                                  null &&
                                              widget.discount.discountId ==
                                                  widget.billDiscounts[j]
                                                      .discountId &&
                                              widget.discount.billDiscountId ==
                                                  widget.billDiscounts[j]
                                                      .billDiscountId) {
                                            setState(() {
                                              widget.discount =
                                                  new BillDiscounts();
                                              getTotal();
                                            });
                                            Navigator.of(context).pop();
                                            return;
                                          }

                                          if (widget.billDiscounts[j]
                                                  .voucherType ==
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
                                                                    Meta m = await (new FacilityDetailRepository()).checkEventDiscountCoupon(
                                                                        widget
                                                                            .billDiscounts[
                                                                                j]
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
                                                                        // if (widget
                                                                        //     .showGiftCardRedeem) {
                                                                        //   _clearOptionGiftVoucher();
                                                                        // }
                                                                        if (widget.discount != null &&
                                                                            widget.discount.discountName !=
                                                                                null &&
                                                                            widget.discount.discountId ==
                                                                                widget.billDiscounts[j].discountId &&
                                                                            widget.discount.billDiscountId == widget.billDiscounts[j].billDiscountId) {
                                                                          widget.discount =
                                                                              new BillDiscounts();
                                                                        } else {
                                                                          widget.discount =
                                                                              widget.billDiscounts[j];
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
                                                  widget.billDiscounts[j];
                                              getTotal();
                                            });
                                            Navigator.of(context).pop();
                                          }

                                          // } else {
                                          //   setState(() {
                                          //     widget.discount =
                                          //         widget.billDiscounts[j];
                                          //     getTotal();
                                          //   });
                                          //   Navigator.of(context).pop();
                                          // }
                                          // if (widget.billDiscounts[j]
                                          //         .voucherType ==
                                          //     7) {
                                          //   showDialog<Widget>(
                                          //     context: context,
                                          //     barrierDismissible:
                                          //         false, // user must tap button!
                                          //     builder:
                                          //         (BuildContext ppcontext) {
                                          //       return AlertDialog(
                                          //         shape: RoundedRectangleBorder(
                                          //           borderRadius:
                                          //               BorderRadius.all(
                                          //                   Radius.circular(
                                          //                       14)),
                                          //         ),
                                          //         content:
                                          //             SingleChildScrollView(
                                          //           scrollDirection:
                                          //               Axis.vertical,
                                          //           child: Column(
                                          //             mainAxisSize:
                                          //                 MainAxisSize.min,
                                          //             crossAxisAlignment:
                                          //                 CrossAxisAlignment
                                          //                     .stretch,
                                          //             children: <Widget>[
                                          //               Padding(
                                          //                 padding:
                                          //                     EdgeInsets.only(
                                          //                         top: 10.0),
                                          //                 child: Center(
                                          //                   child: Text(
                                          //                     tr("enter_coupon_code"),
                                          //                     textAlign:
                                          //                         TextAlign
                                          //                             .center,
                                          //                     style: TextStyle(
                                          //                       color: ColorData
                                          //                           .primaryTextColor,
                                          //                       fontFamily: tr(
                                          //                           "currFontFamily"),
                                          //                       fontWeight:
                                          //                           FontWeight
                                          //                               .w500,
                                          //                       fontSize: Styles
                                          //                           .textSizeSmall,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //               ),
                                          //               // Padding(
                                          //               //   padding:
                                          //               //       EdgeInsets.only(
                                          //               //           top: 10.0),
                                          //               //   child: Center(
                                          //               //     child: Container(
                                          //               //         width: MediaQuery.of(
                                          //               //                     context)
                                          //               //                 .size
                                          //               //                 .width *
                                          //               //             0.50,
                                          //               //         height: MediaQuery.of(
                                          //               //                     context)
                                          //               //                 .size
                                          //               //                 .height *
                                          //               //             0.080,
                                          //               //         child:
                                          //               //             new TextFormField(
                                          //               //                 keyboardType:
                                          //               //                     TextInputType
                                          //               //                         .number,
                                          //               //                 controller:
                                          //               //                     _couponController,
                                          //               //                 textAlign:
                                          //               //                     TextAlign
                                          //               //                         .center,
                                          //               //                 decoration:
                                          //               //                     new InputDecoration(
                                          //               //                   contentPadding:
                                          //               //                       EdgeInsets.all(5),
                                          //               //                   // contentPadding: EdgeInsets.only(
                                          //               //                   //     left: 10, top: 0, bottom: 0, right: 0),
                                          //               //                   hintText:
                                          //               //                       "Coupon Code",
                                          //               //                   border:
                                          //               //                       new OutlineInputBorder(borderSide: new BorderSide(color: Colors.black12)),
                                          //               //                   // focusedBorder: OutlineInputBorder(
                                          //               //                   //     borderSide: new BorderSide(
                                          //               //                   //         color: Colors.grey[200]))),
                                          //               //                 ),
                                          //               //                 style: TextStyle(
                                          //               //                     fontSize:
                                          //               //                         Styles.packageExpandTextSiz,
                                          //               //                     fontFamily: tr("currFontFamilyEnglishOnly"),
                                          //               //                     color: ColorData.primaryTextColor,
                                          //               //                     fontWeight: FontWeight.w200))),
                                          //               //   ),
                                          //               // ),
                                          //               Padding(
                                          //                 padding:
                                          //                     EdgeInsets.only(
                                          //                         top: 10.0),
                                          //                 child: Row(
                                          //                   mainAxisAlignment:
                                          //                       MainAxisAlignment
                                          //                           .spaceEvenly,
                                          //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          //                   children: <Widget>[
                                          //                     ElevatedButton(
                                          //                         style: ButtonStyle(
                                          //                             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          //                             backgroundColor: MaterialStateProperty.all<Color>(ColorData.grey300),
                                          //                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          //                                 borderRadius: BorderRadius.all(
                                          //                               Radius.circular(
                                          //                                   5.0),
                                          //                             )))),
                                          //                         // shape: RoundedRectangleBorder(
                                          //                         //     borderRadius:
                                          //                         //         BorderRadius.all(
                                          //                         //             Radius.circular(
                                          //                         //                 5.0))),
                                          //                         // color: ColorData
                                          //                         //     .grey300,
                                          //                         child: new Text(tr("cancel"),
                                          //                             style: TextStyle(
                                          //                                 color: ColorData.primaryTextColor,
                                          //                                 //                                color: Colors.black45,
                                          //                                 fontSize: Styles.textSizeSmall,
                                          //                                 fontFamily: tr("currFontFamily"))),
                                          //                         onPressed: () {
                                          //                           Navigator.of(
                                          //                                   ppcontext)
                                          //                               .pop();
                                          //                         }),
                                          //                     ElevatedButton(
                                          //                         style: ButtonStyle(
                                          //                             foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                          //                             backgroundColor: MaterialStateProperty.all<Color>(ColorData.colorBlue),
                                          //                             shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                          //                                 borderRadius: BorderRadius.all(
                                          //                               Radius.circular(
                                          //                                   5.0),
                                          //                             )))),
                                          //                         // shape: RoundedRectangleBorder(
                                          //                         //     borderRadius:
                                          //                         //         BorderRadius.all(Radius.circular(
                                          //                         //             5.0))),
                                          //                         // color: ColorData
                                          //                         //     .colorBlue,
                                          //                         child: new Text(
                                          //                           tr("confirm"),
                                          //                           style: TextStyle(
                                          //                               color: Colors
                                          //                                   .white,
                                          //                               fontSize:
                                          //                                   Styles
                                          //                                       .textSizeSmall,
                                          //                               fontFamily:
                                          //                                   tr("currFontFamily")),
                                          //                         ),
                                          //                         onPressed: () async {
                                          //                           _handler
                                          //                               .show();
                                          //                           Meta m = await (new FacilityDetailRepository()).checkDiscountCoupon(
                                          //                               widget.billDiscounts[j].discountId,
                                          //                               // _couponController
                                          //                               //     .text
                                          //                               //     .toString()
                                          //                               "0");
                                          //                           if (m.statusCode ==
                                          //                               200) {
                                          //                             _handler
                                          //                                 .dismiss();
                                          //                             Navigator.of(
                                          //                                     ppcontext)
                                          //                                 .pop();
                                          //                             setState(
                                          //                                 () {
                                          //                               // if (widget
                                          //                               //     .showGiftCardRedeem) {
                                          //                               //   _clearOptionGiftVoucher();
                                          //                               // }
                                          //                               if (widget.discount != null &&
                                          //                                   widget.discount.discountName !=
                                          //                                       null &&
                                          //                                   widget.discount.discountId ==
                                          //                                       widget.billDiscounts[j].discountId &&
                                          //                                   widget.discount.billDiscountId == widget.billDiscounts[j].billDiscountId) {
                                          //                                 widget.discount =
                                          //                                     new BillDiscounts();
                                          //                               } else {
                                          //                                 widget.discount =
                                          //                                     widget.billDiscounts[j];
                                          //                               }
                                          //                               getTotal();
                                          //                             });
                                          //                             Navigator.of(
                                          //                                     context)
                                          //                                 .pop();
                                          //                             util.customGetSnackBarWithOutActionButton(
                                          //                                 tr("Coupon"),
                                          //                                 "Discount Applied Successfully",
                                          //                                 context);
                                          //                           } else {
                                          //                             _handler
                                          //                                 .dismiss();
                                          //                             util.customGetSnackBarWithOutActionButton(
                                          //                                 tr("Coupon"),
                                          //                                 m.statusMsg,
                                          //                                 context);
                                          //                           }
                                          //                         })
                                          //                   ],
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //         ),
                                          //       );
                                          //     },
                                          //   );
                                          // } else {
                                          //   setState(() {
                                          //     // if (widget.showGiftCardRedeem) {
                                          //     //   _clearOptionGiftVoucher();
                                          //     // }
                                          //     widget.discount =
                                          //         widget.billDiscounts[j];
                                          //     getTotal();
                                          //   });
                                          //   Navigator.of(context).pop();
                                          // }
                                        },
                                        child: new Text(
                                          widget.discount != null &&
                                                  widget.discount
                                                          .discountName !=
                                                      null &&
                                                  widget.discount.discountId ==
                                                      widget.billDiscounts[j]
                                                          .discountId &&
                                                  widget.discount
                                                          .billDiscountId ==
                                                      widget.billDiscounts[j]
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
    double totalAmt = 0;
    double totalAmtWithoutPromotion = widget.taxableAmt;
    widget.taxAmt = 0;
    widget.discountAmt = 0;
    widget.total = 0;

    if (widget.discount != null && widget.discount.discountValue != null) {
      if (widget.discount.discountValue > 0) {
        if (widget.discount.discountType == 1) {
          widget.discountAmt = double.parse(roundDouble(
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

    widget.total = widget.taxableAmt - widget.discountAmt;
    //double taxAmt = (widget.facilityItems[i].price * itemCount) - taxableAmt;
    //widget.taxAmt = widget.taxAmt + taxAmt;

    // total = totalAmt -
    //     (_giftVoucherUsedAmount.text == ""
    //         ? 0
    //         : double.parse(_giftVoucherUsedAmount.text));
    // widget.total = totalAmt -
    //     (_giftVoucherUsedAmount.text == ""
    //         ? 0
    //         : double.parse(_giftVoucherUsedAmount.text));
  }

  double roundDouble(double value, int places) {
    double mod = math.pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
