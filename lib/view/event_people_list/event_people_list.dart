import 'dart:convert';
import 'dart:io';
import 'dart:ui' as prefix;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/expansiontile/groovenexpan.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/EventTempleteResponse.dart';
import 'package:slc/model/event_participant.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';

import 'package:slc/repo/event_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_add_people/event_add_people.dart';

import '../../model/facility_item.dart';
import '../../model/giftvoucher_request.dart';
import '../../repo/facility_detail_repository.dart';
import 'bloc/bloc.dart';
import 'event_people_proceed_to_pay.dart';
import 'eventlist.dart';

// ignore: must_be_immutable
class EventPeopleList extends StatelessWidget {
  int eventId;
  bool showAddPeople;
  int statusId;

  final List<EventPriceCategory> eventPriceCategoryList;

  EventPeopleList(
      {this.eventId,
      this.eventPriceCategoryList,
      this.showAddPeople,
      this.statusId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventPeopleListBloc>(
      create: (context) => EventPeopleListBloc(null)
        ..add(GetEventParticipantListEvent(eventId: eventId)),
      child: AddPeoplePage(
        eventPriceCategoryList: eventPriceCategoryList,
        eventId: eventId,
        showAddPeople: showAddPeople,
        statusId: statusId,
      ),
    );
  }
}

// ignore: must_be_immutable
class AddPeoplePage extends StatefulWidget {
  AddPeoplePage(
      {Key key,
      this.title,
      this.eventPriceCategoryList,
      this.eventId,
      this.showAddPeople,
      this.statusId});

  final String title;
  int eventId;
  bool showAddPeople;
  int statusId;
  final List<EventPriceCategory> eventPriceCategoryList;

  @override
  _AddPeoplePageState createState() => _AddPeoplePageState(
      eventPricingCategoryList: eventPriceCategoryList, statusId: statusId);
}

class _AddPeoplePageState extends State<AddPeoplePage> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  PageController _pageController;
  Color iconColor;
  bool _isChecked = false;
  String status = "check";
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int statusId;

  bool isExpanded = false;
  bool isMainExpanded = false;
  bool isPaidEvent = false;
  bool qr_status = false;

  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  EventTempleteResponse res = new EventTempleteResponse();
  EventParticipantResponse response = new EventParticipantResponse();
  List<EventPriceCategory> eventPricingCategoryList;
  List<EventParticipant> eventParticipantList = [];
  List<EventTempleteResponse> eventtemplateList = [];

  File file;
  String fileName = "";
  String uploadResponse = "";
  _AddPeoplePageState({this.eventPricingCategoryList, this.statusId});
  ImagePicker picker = ImagePicker();
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
          eventParticipantList = response.eventParticipantList;
          isPaid();
          _isChecked = response.isAddMe;
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
            title: state.title,
            content: state.content,
          );
        }
        // else if (state is ShowImageState) {
        //   if (state.file != null) {
        //     uploadImage(state.file.path);
        //     fileName = state.file.path?.split("/")?.last;
        //   } else {
        //     debugPrint("File not found");
        //   }
        // }
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
    // print('paricipant amount---> ${response.totalParticipantAmount}');
    String totalPrice = response.totalParticipantAmount != null
        ? Utils().getAmount(amount: response.totalParticipantAmount)
        : "";
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: !widget.showAddPeople
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: 50.0,
                margin: EdgeInsets.only(
                    top: 10.0, left: 20.0, right: 20.0, bottom: 20.0),
                child: response.name != null && !isExpanded
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: eventParticipantList.length >= 0
                                ? MediaQuery.of(context).size.width / 2 - 30
                                : null,
                            child: ElevatedButton(
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Text(tr('addPeople'),
                                        style: EventPeopleListPageStyle
                                            .eventPeopleListPageBtnTextStyleWithAr(
                                                context)),
                                  ),
                                ],
                              ),
                              // shape: new RoundedRectangleBorder(
                              //   borderRadius: new BorderRadius.circular(8),
                              // ),
                              onPressed: () {
                                if (eventParticipantList == null ||
                                        eventParticipantList.length <
                                            10 /*
                            int.parse(SPUtil.getString(
                                Constants.EventRegistrationCount,
                                defValue: '0'))*/
                                    ) {
                                  Get.off(() => (EventAddPeople(
                                        eventPricingCategoryList:
                                            eventPricingCategoryList,
                                        eventId: widget.eventId,
                                        isAddMe: false,
                                        showAddPeople: widget.showAddPeople,
                                        eventProducts:
                                            response.eventProdCategoryList,
                                      )));
                                } else {
                                  Utils().customGetSnackBarWithOutActionButton(
                                      tr('warning_caps'),
                                      tr('event_max_add_count') +
                                          "10" +
                                          tr('event_max_people'),
                                      context);
                                }
                              },
                              // textColor: Colors.white,
                              // color: Theme.of(context).primaryColor,
                            ),
                          ),
                          ((isPaidEvent == true ||
                                      eventPricingCategoryList.length > 0) &&
                                  response.totalParticipantAmount != 0.0)
                              ? Container(
                                  width: MediaQuery.of(context).size.width / 2 -
                                      30,
                                  margin:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: ElevatedButton(
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
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    //   borderRadius:
                                    //       new BorderRadius.circular(8),
                                    // ),
                                    onPressed: () async {
                                      //Payment.....................................
                                      if (eventParticipantList != null &&
                                          response.totalParticipantAmount !=
                                              0.0) {
                                        Meta m = await FacilityDetailRepository()
                                            .getEventDiscountList(
                                                widget.eventId,
                                                response
                                                    .totalParticipantAmount);
                                        List<BillDiscounts> billDiscounts = [];
                                        // new List<BillDiscounts>();
                                        if (m.statusCode == 200) {
                                          jsonDecode(m.statusMsg)['response']
                                              .forEach((f) => billDiscounts.add(
                                                  new BillDiscounts.fromJson(
                                                      f)));
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
                                        Meta m1 =
                                            await FacilityDetailRepository()
                                                .getGiftVouchers();
                                        if (m1.statusCode == 200) {
                                          jsonDecode(m1.statusMsg)['response']
                                              .forEach((f) => vouchers.add(
                                                  new GiftVocuher.fromJson(f)));
                                        }
                                        // Disable collage
                                        if (vouchers == null) {
                                          vouchers = [];
                                        }

                                        /*Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EventPeopleProceedToPay(
                                                  eventId: widget.eventId,
                                                  eventPriceCategoryList: widget
                                                      .eventPriceCategoryList);
                                            },
                                          ),
                                        );*/
                                        Get.off(() => (EventPeopleProceedToPay(
                                              eventId: widget.eventId,
                                              eventPriceCategoryList:
                                                  widget.eventPriceCategoryList,
                                              showAddPeople:
                                                  widget.showAddPeople,
                                              taxableAmt: 0,
                                              billDiscounts: billDiscounts,
                                            )));
                                      }
                                    },
                                    // textColor: Colors.white,
                                    // color: Theme.of(context).primaryColor,
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(
                        // width: MediaQuery.of(context).size.width / 2 - 30,
                        // margin: EdgeInsets.only(left: 10.0, right: 10.0),
                        // child: RaisedButton(
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: <Widget>[
                        //       Container(
                        //         child: Text('Submit',
                        //             style: EventPeopleListPageStyle
                        //                 .eventPeopleListPageBtnTextStyleWithAr(
                        //                     context)),
                        //       ),
                        //     ],
                        //   ),
                        //   shape: new RoundedRectangleBorder(
                        //     borderRadius: new BorderRadius.circular(8),
                        //   ),
                        //   onPressed: () {},
                        //   textColor: Colors.white,
                        //   color: Theme.of(context).primaryColor,
                        // ),
                        ),
              )
            : Container(
                width: 0.0,
                height: 0.0,
              ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: CustomAppBar(
            title: tr('eventReg'),
          ),
        ),
        body: SingleChildScrollView(
          child: response.name != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Align(
                          alignment: Alignment.center,
                          child: response.name != null
                              ? Text(
                                  (response.name != null) ? response.name : "",
                                  style: EventPeopleListPageStyle
                                      .eventPeopleListPageHeadingTextStyle(
                                          context))
                              : Container()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, bottom: 12.0, left: 10.0, right: 10.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(CommonIcons.location,
                                  color: Colors.black45, size: 20.0),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 4.0, left: 5.0, right: 5.0),
                                child: Text(
                                    (response.venue != null)
                                        ? response.venue
                                        : "",
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: EventPeopleListPageStyle
                                        .eventPeopleListPageSubHeadingTextStyle(
                                            context)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(CommonIcons.calendar_border,
                                  size: 16, color: Colors.black45),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, top: 4.0, right: 5.0),
                                child: Text(
                                    (response.dateRange != null)
                                        ? response.dateRange
                                        : "",
                                    textDirection: prefix.TextDirection.ltr,
                                    style: EventPeopleListPageStyle
                                        .eventPeopleListPageTextStyleWithoutAr(
                                            context)),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Icon(CommonIcons.time_half,
                                    size: 16, color: Colors.black45),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.0, top: 16.0, right: 5.0),
                                child: Text(
                                    (response.timeRange != null)
                                        ? response.timeRange
                                        : "",
                                    textDirection: prefix.TextDirection.ltr,
                                    style: EventPeopleListPageStyle
                                        .eventPeopleListPageTextStyleWithoutAr(
                                            context)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: Localizations.localeOf(context).languageCode ==
                              "en"
                          ? EdgeInsets.only(left: 20.0, top: 25.0, bottom: 10.0)
                          : EdgeInsets.only(
                              right: 20.0, top: 25.0, bottom: 10.0),
                      child: (eventParticipantList != null &&
                              eventParticipantList.length > 0)
                          ? Text(tr('members'),
                              style: EventPeopleListPageStyle
                                  .eventPeopleListPageSubHeadingTextStyle(
                                      context))
                          : Container(),
                    ),
                    getMember(context),
                    !qr_status
                        ? (eventParticipantList != null &&
                                eventParticipantList.length > 0)
                            ? Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    top: 30.0,
                                    bottom: 10.0,
                                    right: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(tr('total'),
                                        style: EventPeopleListPageStyle
                                            .eventPeopleListPageSubHeadingTextStyle(
                                                context)),
                                    Text(
                                      (response.totalParticipantAmount
                                                  .toString() !=
                                              null)
                                          ? totalPrice
                                          : "",
                                      style: EventDetailPageStyle
                                          .eventDetailPageTextStyleWithAr(
                                              context),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                        : isExpanded
                            ? Center(
                                //       child: Column(
                                //           mainAxisAlignment: MainAxisAlignment.center,
                                //           children: <Widget>[
                                //           Container(
                                //               //color: Colors.blueGrey,
                                //               height: 45,
                                //               width:
                                //                   MediaQuery.of(context).size.width *
                                //                       0.93,
                                //               child: Stack(
                                //                 children: <Widget>[
                                //                   Positioned(
                                //                       left: 15,
                                //                       top: 0,
                                //                       //right: 0.0,
                                //                       bottom: 0,
                                //                       child: Text(
                                //                           "Upload Required Documents",
                                //                           style: TextStyle(
                                //                               fontSize: 16))),
                                //                   Positioned(
                                //                       left: 18,
                                //                       top: 25,
                                //                       //right: 0.0,
                                //                       bottom: 0,
                                //                       child: Text(
                                //                           "Supported formats PNG, PDF or JPG",
                                //                           style: TextStyle(
                                //                               fontSize: 11,
                                //                               color: Colors.grey)))
                                //                 ],
                                //               )),
                                //           Container(
                                //               height: 95,
                                //               width:
                                //                   MediaQuery.of(context).size.width *
                                //                       0.93,
                                //               child: DottedBorder(
                                //                 dashPattern: [3, 3],
                                //                 radius: Radius.circular(500),
                                //                 //  radius: Radius.circular(100),
                                //                 color: Colors.grey,
                                //                 //gap: 3,
                                //                 strokeWidth: 1,
                                //                 child: Center(
                                //                   child: Stack(children: <Widget>[
                                //                     Row(
                                //                         mainAxisAlignment:
                                //                             MainAxisAlignment
                                //                                 .center, //Center Row contents horizontally,
                                //                         crossAxisAlignment:
                                //                             CrossAxisAlignment
                                //                                 .center, //Center Row contents vertically,
                                //                         children: <Widget>[
                                //                           Column(
                                //                             children: <Widget>[
                                //                               IconButton(
                                //                                   iconSize: 50,
                                //                                   //tooltip: "Upload your files here",
                                //                                   icon: Icon(
                                //                                     Icons
                                //                                         .add_circle_outline,
                                //                                     color:
                                //                                         Colors.grey,
                                //                                     //  size: 70,
                                //                                   ),
                                //                                   onPressed:
                                //                                       () {} //=> getImageFromGallery(),
                                //                                   ),
                                //                               Text("Upload Flies")
                                //                               ///////
                                //                             ],
                                //                           ),
                                //                         ]),
                                //                   ]),
                                //                 ),
                                //               )),
                                //           SizedBox(
                                //             height: 15,
                                //           ),
                                //           //imageURI == null
                                //           //? Text('')
                                //           //           :
                                //           Container(
                                //             child: Padding(
                                //               padding: const EdgeInsets.only(
                                //                   left: 15, right: 15),
                                //               child: Row(
                                //                 mainAxisAlignment: MainAxisAlignment
                                //                     .spaceBetween, //Center Row contents horizontally,
                                //                 crossAxisAlignment:
                                //                     CrossAxisAlignment.center,
                                //                 children: <Widget>[
                                //                   Row(
                                //                     children: <Widget>[
                                //                       Icon(
                                //                         Icons.insert_drive_file,
                                //                         color: Colors.redAccent,
                                //                         //  size: 70,
                                //                       ),
                                //                       ButtonTheme(
                                //                         height: 10,
                                //                         minWidth: 70,
                                //                         child: RaisedButton(
                                //                             color: Colors.white,
                                //                             elevation: 0,
                                //                             child: Container(
                                //                               //color: Colors.white,
                                //                               child: Text(""),
                                //                             ),
                                //                             onPressed: () {
                                //                               showDialog(
                                //                                 context: context,
                                //                                 builder: (context) {
                                //                                   return Dialog(
                                //                                       shape: RoundedRectangleBorder(
                                //                                           borderRadius:
                                //                                               BorderRadius.circular(
                                //                                                   40)),
                                //                                       elevation: 16,
                                //                                       child: Container(
                                //                                           height:
                                //                                               400.0,
                                //                                           width:
                                //                                               360.0,
                                //                                           child: Text(
                                //                                               "")));
                                //                                 },
                                //                               );
                                //                             }),
                                //                       )
                                //                     ],
                                //                   ),
                                //                   IconButton(
                                //                     onPressed: () {
                                //                       setState(() {
                                //                         //  imageURI = null;
                                //                       });
                                //                     },
                                //                     icon: Icon(Icons.close),
                                //                     color: Colors.grey,
                                //                     //  size: 70,
                                //                   ),
                                //                 ],
                                //               ),
                                //             ),
                                //             height: 60,
                                //             //width: 100,
                                //             width: MediaQuery.of(context).size.width *
                                //                 0.93,
                                //             decoration: BoxDecoration(
                                //               color: Colors.white,
                                //               boxShadow: [
                                //                 BoxShadow(
                                //                   color: Colors.grey,
                                //                   blurRadius: 5.0,
                                //                 ),
                                //               ],
                                //               borderRadius: new BorderRadius.only(
                                //                 topLeft: const Radius.circular(10.0),
                                //                 topRight: const Radius.circular(10.0),
                                //                 bottomLeft:
                                //                     const Radius.circular(10.0),
                                //                 bottomRight:
                                //                     const Radius.circular(10.0),
                                //               ),
                                //             ),
                                //             //child:
                                //             /*Image.file(imageURI,
                                // width: 100, height: 50, fit: BoxFit.cover)*/
                                //           ),
                                //           SizedBox(
                                //             height: 15,
                                //           )
                                //         ]))
                                )
                            : Container(),
                    response.name == null || eventParticipantList.length == 0
                        ? Padding(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Checkbox(
                                    value: _isChecked,
                                    onChanged: (bool value) {
                                      if (eventParticipantList == null ||
                                              eventParticipantList.length <
                                                  10 /*
                                  int.parse(SPUtil.getString(
                                      Constants
                                          .EventRegistrationCount,
                                      defValue: '0'))*/
                                          ) {
                                        if (!response.isAddMe &&
                                            !widget.showAddPeople) {
                                          _isChecked = value;
                                          setState(() {});
                                          Get.off(() => (EventAddPeople(
                                                eventPricingCategoryList:
                                                    eventPricingCategoryList,
                                                eventId: widget.eventId,
                                                isAddMe: true,
                                                showAddPeople:
                                                    widget.showAddPeople,
                                                eventProducts: response
                                                    .eventProdCategoryList,
                                              )));
                                        }
                                      } else {
                                        Utils()
                                            .customGetSnackBarWithOutActionButton(
                                                tr('warning_caps'),
                                                tr('event_max_add_count') +
                                                    "10" +
                                                    tr('event_max_people'),
                                                context);
                                      }
                                    }),
                                Padding(
                                  padding: EdgeInsets.only(top: 4.0),
                                  child: Text(tr('addMe'),
                                      style: EventPeopleListPageStyle
                                          .eventPeopleListPageTextStyleWithAr(
                                              context)),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  Widget getMember(BuildContext buildContext) {
    return (eventParticipantList != null && eventParticipantList.length > 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventParticipantList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              String eventAmountPrice = eventParticipantList[i].amount != null
                  ? Utils().getAmount(amount: eventParticipantList[i].amount)
                  : "";
              Widget leading = Container(
                decoration: BoxDecoration(
                    color: isExpanded == true
                        ? selectedIndex == i
                            ? Color.fromRGBO(62, 181, 227, 1)
                            : Color.fromRGBO(214, 239, 249, 1)
                        : Color.fromRGBO(214, 239, 249, 1),
                    shape: BoxShape.circle),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 4.0),
                  child: Icon(
                    CommonIcons.user_one,
                    color: isExpanded == true
                        ? selectedIndex == i
                            ? Colors.white
                            : ColorData.colorBlue
                        : ColorData.colorBlue,
                  ),
                ),
              );
              Widget title = Padding(
                padding: EdgeInsets.only(top: 4.0),
                child: Text(
                    (eventParticipantList[i].firstName != null)
                        ? eventParticipantList[i].firstName
                        : "",
                    style: isExpanded == true
                        ? selectedIndex == i
                            ? EventPeopleListPageStyle
                                .eventPeopleListPageSubHeadingTextStyle(context,
                                    isBlue: true)
                            : EventPeopleListPageStyle
                                .eventPeopleListPageSubHeadingTextStyle(context)
                        : EventPeopleListPageStyle
                            .eventPeopleListPageSubHeadingTextStyle(context)),
              );
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: Card(
                        color: Colors.white,
                        elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                        child: !eventParticipantList[i].isPaid
                            ? ListTile(
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    title,
                                    Expanded(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 28.0),
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
                                              eventParticipantList[i]
                                                  .amount
                                                  .toStringAsFixed(2),
                                              style: EventDetailPageStyle
                                                  .eventDetailPageTextStyleWithAr(
                                                      context),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                leading: leading,
                                trailing: Container(
                                  child: InkWell(
                                    child: Icon(Icons.delete),
                                    onTap: () async {
                                      _handler.show();
                                      Meta m = await EventRepository()
                                          .getEventDelete(
                                        eventParticipantList[i]
                                            .eventParticipantId,
                                      );
                                      debugPrint(eventParticipantList[i]
                                          .eventParticipantId
                                          .toString());
                                      if (m.statusCode == 200 ||
                                          m.statusCode != 200) {
                                        _handler.dismiss();
                                        print(m.toJson());
                                      }

                                      if (m.statusCode == 200) {
                                        setState(() {
                                          response.totalParticipantAmount =
                                              response.totalParticipantAmount -
                                                  eventParticipantList[i]
                                                      .amount;
                                          eventParticipantList =
                                              List.from(eventParticipantList)
                                                ..removeAt(i);
                                        });
                                      }
                                      _handler.dismiss();
                                      //Delete.....................
                                    },
                                  ),
                                ),
                              )
                            : GroovinExpansionTile(
                                btnIndex: i,
                                selectedIndex: selectedIndex,
                                onTap: (isExpanded, btnIndex) {
                                  updateSelectedIndex(btnIndex);
                                },
                                onExpansionChanged: (val) {
                                  setState(() {
                                    isExpanded = val;
                                  });
                                },
                                defaultTrailingIconColor:
                                    isExpanded && selectedIndex == i
                                        ? Theme.of(context).primaryColor
                                        : Color.fromRGBO(83, 87, 90, 1),
                                leading: leading,
                                title: title,
                                children: <Widget>[
                                  Center(
                                    child: InkWell(
                                        onTap: () async {
                                          debugPrint(" sssssss " +
                                              widget.showAddPeople.toString());
                                          if (!widget.showAddPeople ||
                                              widget.statusId ==
                                                  Integer
                                                      .Registration_Completed)
                                            return;
                                          Meta m = await EventRepository()
                                              .getTemplateEvent(widget.eventId);
                                          // print(m.toJson());
                                          _handler.show();
                                          if (m.statusCode == 200) {
                                            _handler.dismiss();
                                            List<EventTempleteResponse>
                                                eventListResponse = [];
                                            jsonDecode(m.statusMsg)['response']
                                                .forEach((f) =>
                                                    eventListResponse.add(
                                                        new EventTempleteResponse
                                                            .fromJson(f)));
                                            eventParticipantList[i]
                                                    .eventTemplates =
                                                eventListResponse;
                                          } else {
                                            _handler.dismiss();
                                          }
                                          if (eventParticipantList[i]
                                                      .eventTemplates ==
                                                  null ||
                                              eventParticipantList[i]
                                                      .eventTemplates
                                                      .length ==
                                                  0) return;

                                          setState(() {
                                            qr_status = true;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EventList(
                                                        eventId: widget.eventId,
                                                        eventPriceCategoryList:
                                                            widget
                                                                .eventPriceCategoryList,
                                                        showAddPeople: widget
                                                            .showAddPeople,
                                                        eventtemplatelist:
                                                            eventtemplateList,
                                                        participation:
                                                            eventParticipantList[
                                                                i],
                                                        statusId:
                                                            widget.statusId,
                                                      )),
                                            );
                                          });
                                        },
                                        child: Container(
                                          height: 100.0,
                                          width: 100,
                                          child: QrImage(
                                            data:
                                                eventParticipantList[i].qrCode,
                                            version: QrVersions.auto,
                                            size: 200.0,
                                            foregroundColor:
                                                ColorData.primaryTextColor,
                                          ),
                                        )),
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: !widget.showAddPeople
                                          ? Text("")
                                          : Text(
                                              "Click QR code to enter results",
                                              style: EventPeopleListPageStyle
                                                  .eventPeopleListPageTextStyleWithAr(
                                                      context))),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 5.0),
                                    child: Divider(
                                      color: Colors.black12,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 15.0,
                                        right: 15.0,
                                        bottom: 15.0,
                                        top: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
//                                  mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Visibility(
                                              visible: eventParticipantList[i]
                                                          .amount >
                                                      0 &&
                                                  (eventParticipantList[i]
                                                          .eventPricingCategoryName !=
                                                      null),
                                              child: Text(
                                                  (eventParticipantList[i]
                                                              .eventPricingCategoryName !=
                                                          null)
                                                      ? eventParticipantList[i]
                                                          .eventPricingCategoryName
                                                      : "",
                                                  style: EventPeopleListPageStyle
                                                      .eventPeopleListPageTextStyleWithAr(
                                                          context)),
                                            ),
                                            Visibility(
                                              visible: eventParticipantList[i]
                                                      .amount >
                                                  0,
                                              child: Container(
                                                  margin: EdgeInsets.only(
                                                      top: eventParticipantList[i].amount >
                                                                  0 &&
                                                              eventParticipantList[i]
                                                                      .eventPricingCategoryName !=
                                                                  null
                                                          ? 10.0
                                                          : 0.0),
                                                  child: Text(
                                                      (eventParticipantList[i]
                                                                  .amount
                                                                  .toString() !=
                                                              null)
                                                          ? eventAmountPrice
                                                          : null,
                                                      style: EventPeopleListPageStyle
                                                          .eventPeopleListPageTextStyleWithoutAr(
                                                              context))),
                                            )
                                          ],
                                        ),
                                        eventParticipantList[i].isPaid
                                            ? Text(tr('paid'),
                                                style: EventPeopleListPageStyle
                                                    .eventPeopleListPageTextStyleWithAr(
                                                        context,
                                                        isBlue: true))
                                            : Text(tr('not_paid'),
                                                style: EventPeopleListPageStyle
                                                    .eventPeopleListPageTextStyleWithAr(
                                                        context,
                                                        isBlue: true)),
                                      ],
                                    ),
                                  )
                                ],
                              )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0),
                    child: Divider(
                      color: Colors.black26,
                    ),
                  )
                ],
              );
            })
        : Container();
  }

  void isPaid() {
    setState(() {
      for (int i = 0; i < eventParticipantList.length; i++) {
        if (eventParticipantList[i].isPaid == false) {
          isPaidEvent = true;
        }
      }
    });
  }

  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }
}
