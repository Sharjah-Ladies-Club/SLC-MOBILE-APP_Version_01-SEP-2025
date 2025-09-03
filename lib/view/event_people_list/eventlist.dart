import 'dart:convert';
import 'dart:io';
import 'dart:ui' as prefix;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
// import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share/share.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/EventParticipantTemplateResultResponse.dart';
import 'package:slc/model/EventTempleteResponse.dart';
import 'package:slc/model/EventTempleterequest.dart';
import 'package:slc/model/event_participant.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';

import 'package:slc/repo/event_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/url_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_add_people/event_add_people.dart';

import 'bloc/bloc.dart';

// ignore: must_be_immutable
class EventList extends StatelessWidget {
  int eventId;
  bool showAddPeople;
  int statusId;
  EventParticipant participation;
  final List<EventTempleteResponse> eventtemplatelist;
  final List<EventPriceCategory> eventPriceCategoryList;
  final List<EventProdCategory> eventProducts;

  EventList(
      {this.eventId,
      this.eventPriceCategoryList,
      this.showAddPeople,
      this.eventtemplatelist,
      this.participation,
      this.statusId,
      this.eventProducts});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<EventPeopleListBloc>(
      create: (context) => EventPeopleListBloc(null)
        ..add(GetEventParticipantListEvent(eventId: eventId)),
      child: AddPeoplePage(
        eventPriceCategoryList: eventPriceCategoryList,
        eventId: eventId,
        showAddPeople: showAddPeople,
        participation: participation,
        statusId: statusId,
        eventProducts: eventProducts,
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
      this.participation,
      this.statusId,
      this.eventProducts});

  final String title;
  int eventId;
  bool showAddPeople;
  int statusId;
  EventParticipant participation;
  final List<EventPriceCategory> eventPriceCategoryList;
  final List<EventProdCategory> eventProducts;
  @override
  _AddPeoplePageState createState() => _AddPeoplePageState(
      eventPricingCategoryList: eventPriceCategoryList,
      participation: participation,
      statusId: statusId);
}

class _AddPeoplePageState extends State<AddPeoplePage> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  PageController _pageController;
  Color iconColor;
  bool _isChecked = false;
  String status = "check";
  int selectedIndex = 0;
  int selectedHeadIndex = -1;
  final picker = ImagePicker();
  Utils util = new Utils();
  TextEditingController _textCtrl1 = new TextEditingController();
  TextEditingController _textCtrl2 = new TextEditingController();
  bool isElevateMobileField = true;
  int statusId;

  var hours = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];
  var mins = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];
  var second = [
    '00',
    '01',
    '02',
    '03',
    '04',
    '05',
    '06',
    '07',
    '08',
    '09',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24',
    '25',
    '26',
    '27',
    '28',
    '29',
    '30',
    '31',
    '32',
    '33',
    '34',
    '35',
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
    '46',
    '47',
    '48',
    '49',
    '50',
    '51',
    '52',
    '53',
    '54',
    '55',
    '56',
    '57',
    '58',
    '59'
  ];
  bool isExpanded = true;
  bool isMainExpanded = false;
  bool isPaidEvent = false;
  bool upload = false;
  String fileName = "";
  String apiFileName = "";
  String newFileName = "";
  String hour = "00";
  String min = "00";
  String sec = "00";
  double elevationPoint = 0.0;
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  EventParticipant participation;
  EventTempleteResponse res = new EventTempleteResponse();
  EventParticipantResponse response = new EventParticipantResponse();
  List<EventPriceCategory> eventPricingCategoryList;
  List<EventProdCategory> eventProductsList = [];
  List<EventParticipant> eventParticipantList = [];
  List<EventTempleteResponse> eventtemplateList = [];
  List<EventParticipantTemplateResultResponse> eventParticipantResults = [];
  bool dataLoaded = false;
  bool fileUploaded = false;
  int resultApproved = -1;
  var serverReceiverPath = URLUtils().getImageUploadUrl();
  var serverTestPath = URLUtils().getImageResultUrl();
  File file;

  _AddPeoplePageState(
      {this.eventPricingCategoryList, this.participation, this.statusId});

  @override
  void initState() {
    super.initState();
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });

    _pageController = PageController();
    _textCtrl1.addListener(() {
      if (_textCtrl1.text != "") elevationPoint = 5.0;
    });

    // _focusNode.addListener(() {
    //   print("Has focus: ${_focusNode.hasFocus}");
    //
    //   setState(() {
    //     if (_focusNode.hasFocus &&
    //         (widget._customLabelString == Strings.textFieldDOBLabel ||
    //             widget._customLabelString == Strings.textFieldDOBLabelArb)) {
    //       FocusScope.of(context).requestFocus(new FocusNode());
    //     }
    //     if (_focusNode.hasFocus)
    //       elevationPoint = 5.0;
    //     else if (widget._customTextEditingController.text.length == 0)
    //       elevationPoint = 0.0;
    //   });
    // });
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
    //debugPrint("dddd Status ID:" + widget.statusId.toString());
    if (statusId == Integer.Closed) {
      dataLoaded = true;
    }
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
      listener: (context, state) async {
        if (state is ShowEventPeopleListProgressBarState) {
          _handler.show();
        } else if (state is HideEventPeopleListProgressBarState) {
          _handler.dismiss();
        } else if (state is OnFailureEventPeopleListState) {
          Utils().customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is LoadPeopleList) {
          response = state.response;
          eventParticipantList.add(participation);
          Meta m = await EventRepository().getTemplateEvent(widget.eventId);
          List<EventTempleteResponse> eventListResponse = [];
          jsonDecode(m.statusMsg)['response'].forEach((f) =>
              eventListResponse.add(new EventTempleteResponse.fromJson(f)));
          participation.eventTemplates = eventListResponse;
          if (statusId == Integer.Closed) {
            dataLoaded = true;
          }
          Meta m1 = await EventRepository()
              .getEventParticipantTemplateResult(widget.eventId);
          jsonDecode(m1.statusMsg)['response'].forEach((f) =>
              eventParticipantResults
                  .add(new EventParticipantTemplateResultResponse.fromJson(f)));
          Map<int, String> prvalues = new Map<int, String>();
          for (int i = 0; i < eventParticipantResults.length; i++) {
            EventParticipantTemplateResultResponse r =
                eventParticipantResults[i];
            debugPrint(r.toJson().toString());
            if (r.value != null) {
              debugPrint(r.value.id.toString() +
                  " " +
                  participation.eventParticipantId.toString());
            }
            debugPrint(r.template.id.toString() +
                " " +
                participation.eventParticipantId.toString());

            if (r.value != null &&
                r.value.id == participation.eventParticipantId) {
              prvalues[r.template.id] = r.value.value;
              if (r.value.createdBy == null) {
                resultApproved = -1;
              } else {
                resultApproved = r.value.createdBy;
              }
            }
          }
          participation.eventTemplates = eventListResponse;
          for (int i = 0; i < participation.eventTemplates.length; i++) {
            EventTempleteResponse r = participation.eventTemplates[i];
            r.Value = prvalues[r.id];
            if (r.inputType == 2 && r.Value != null && r.Value != "") {
              fileName = r.Value;
              debugPrint("file name uplaoded" + r.Value);
            }
            setState(() {
              if (i == 0 && r.Value != "" && r.Value != null) {
                _textCtrl1.text = r.Value;
                dataLoaded = true;
              }
              if (i == 1 && r.Value != "" && r.Value != null) {
                _textCtrl2.text = r.Value;
                if (r.Value.split(":").length > 2) {
                  hour = r.Value.split(":")[0];
                  min = r.Value.split(":")[1];
                  sec = r.Value.split(":")[2];
                }
                dataLoaded = true;
              }
            });
          }
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
        } else if (state is ShowImageState) {
          if (state.file != null) {
            file = state.file;
            newFileName = state.file.path?.split("/")?.last;
            uploadImage(state.file.path);
            fileUploaded = true;
          } else {
            debugPrint("File not found");
          }
        } else if (state is ShowImageCameraState) {
          if (state.file != null) {
            file = state.file;
            newFileName = state.file.path?.split("/")?.last;
            uploadImage(state.file.path);
            fileUploaded = true;
          } else {
            debugPrint("File not found");
          }
        } else if (state is SaveTemplateState) {
          customGetSnackBarWithOutActionButton(
              "Results", "Submitted successfully for approval", context);
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
    // print('paricipant amount---> ${response.totalParticipantAmount}');

    String totalPrice = response.totalParticipantAmount != null
        ? Utils().getAmount(amount: response.totalParticipantAmount)
        : "";
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: !dataLoaded && fileUploaded
          ? Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              margin: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: Text('Submit',
                          style: EventPeopleListPageStyle
                              .eventPeopleListPageBtnTextStyleWithAr(context)),
                    ),
                  ],
                ),
                // shape: new RoundedRectangleBorder(
                //   borderRadius: new BorderRadius.circular(8),
                // ),
                style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )))),
                onPressed: () {
                  //submit///////////
                  if (participation.eventTemplates.length > 1) {
                    participation.eventTemplates[1].Value =
                        hour + ":" + min + ":" + sec;
                  }
                  if (!validateForm(context)) return;
                  Navigator.pop(context);
                  EventTempleteRequest request = new EventTempleteRequest();
                  List<EventTemplateDetails> result = [];
                  if (participation.eventTemplates != null &&
                      participation.eventTemplates.length > 0) {
                    for (var k = 0;
                        k < participation.eventTemplates.length;
                        k++) {
                      EventTemplateDetails t = new EventTemplateDetails();
                      t.id = participation.eventTemplates[k].id;
                      if (k == 2) {
                        t.value = apiFileName;
                      } else if (k == 1) {
                        t.value = hour + ":" + min + ":" + sec;
                      } else if (k == 0) {
                        t.value = participation.eventTemplates[k].Value;
                      }
                      result.add(t);
                    }
                  }
                  request.eventParticipantId = participation.eventParticipantId;
                  request.userId = participation.userId;
                  request.EventParticipantResults = result;

                  BlocProvider.of<EventPeopleListBloc>(context)
                      .add(SaveEventTemplateEvent(request: request));
                },
                // textColor: Colors.white,
                // color: Theme.of(context).primaryColor,
              ),
            )
          : Container(
              width: 0.0,
              height: 0.0,
            ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: CustomAppBar(
          title: tr('eventresult'),
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
                          ? Text((response.name != null) ? response.name : "",
                              style: EventPeopleListPageStyle
                                  .eventPeopleListPageHeadingTextStyle(context))
                          : Container(),
                    ),
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
                  resultApproved != -1 && resultApproved == 0
                      ? Center(
                          child: Text('Results pending approval',
                              style: EventPeopleListPageStyle
                                  .eventPeopleListPageSubHeadingTextStyle(
                                      context,
                                      isBlue: true)))
                      : resultApproved != -1 && resultApproved == 2
                          ? Center(
                              child: Text('Results Rejected',
                                  style: EventPeopleListPageStyle
                                      .eventPeopleListPageSubHeadingTextStyle(
                                          context,
                                          isBlue: true)))
                          : resultApproved == -1
                              ? Center(
                                  child: Text('',
                                      style: EventPeopleListPageStyle
                                          .eventPeopleListPageSubHeadingTextStyle(
                                              context,
                                              isBlue: true)))
                              : Padding(
                                  padding: EdgeInsets.only(
                                    left: 28,
                                  ),
                                  child: GestureDetector(
                                      child: Icon(
                                        Icons.share,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onTap: () async {
                                        try {
                                          // Saved with this method.
                                          var imageId = null;
                                          // await ImageDownloader
                                          //     .downloadImage(serverTestPath +
                                          //         "/UploadDocument/Event/" +
                                          //         widget.eventId.toString() +
                                          //         "/ParticipantResult/" +
                                          //         participation
                                          //             .eventParticipantId
                                          //             .toString() +
                                          //         "/" +
                                          //         "Result.jpeg");
                                          if (imageId == null) {
                                            return;
                                          }

                                          // Below is a method of obtaining saved image information.
                                          var dnFileName = '';
                                          // await ImageDownloader.findName(
                                          //     imageId);
                                          var path = '';
                                          // await ImageDownloader.findPath(
                                          //     imageId);
                                          debugPrint(" fffff :" +
                                              path +
                                              " name :" +
                                              dnFileName);
                                          List<String> paths = [];
                                          paths.add(path.toString());
                                          Share.shareFiles(paths,
                                              subject: "Event Result:" +
                                                  participation.firstName);
                                        } on PlatformException catch (error) {
                                          print(error);
                                        }
                                      }),
                                ),
                  Padding(
                    padding: Localizations.localeOf(context).languageCode ==
                            "en"
                        ? EdgeInsets.only(left: 20.0, top: 25.0, bottom: 10.0)
                        : EdgeInsets.only(right: 20.0, top: 25.0, bottom: 10.0),
                    child: (eventParticipantList != null &&
                            eventParticipantList.length > 0)
                        ? Text(tr('participant'),
                            style: EventPeopleListPageStyle
                                .eventPeopleListPageSubHeadingTextStyle(
                                    context))
                        : Container(),
                  ),
                  getMember(context),
                  Padding(
                    padding: Localizations.localeOf(context).languageCode ==
                            "en"
                        ? EdgeInsets.only(left: 20.0, top: 25.0, bottom: 10.0)
                        : EdgeInsets.only(right: 20.0, top: 25.0, bottom: 10.0),
                    child: (eventParticipantList != null &&
                            eventParticipantList.length > 0)
                        ? Text("Upload File",
                            style: EventPeopleListPageStyle
                                .eventPeopleListPageSubHeadingTextStyle(
                                    context))
                        : Container(),
                  ),
                  getUpload(context),
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
    ));
  }

  Widget getMember(BuildContext buildContext) {
    return (eventParticipantList != null && eventParticipantList.length > 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventParticipantList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              Widget leading = Container(
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Container(
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
                        ))),
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
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    leading,
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: title,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                              participation.eventTemplates
                                                          .length >
                                                      0
                                                  ? participation
                                                      .eventTemplates[0].label
                                                  : "",
                                              style: distance
                                                  .distancepage(context))),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            height: 35,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.50,
                                            child: Row(children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  // decoration: BoxDecoration(
                                                  //     border: Border.all(
                                                  //         color:
                                                  //             Colors.grey)),

                                                  child: Column(children: [
                                                    Expanded(
                                                        child: Material(
                                                            elevation: 5.0,
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  _textCtrl1,
                                                              // autofocus: true,
                                                              enableInteractiveSelection:
                                                                  false,
                                                              maxLines: 1,
                                                              readOnly:
                                                                  dataLoaded,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              inputFormatters: [
                                                                new LengthLimitingTextInputFormatter(
                                                                    5)
                                                              ],
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                filled: true,
                                                                suffix:
                                                                    Text("Kms"),
                                                                enabledBorder: OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    borderSide: BorderSide(
                                                                        color: Colors
                                                                            .white,
                                                                        width:
                                                                            3.0)),
                                                                contentPadding:
                                                                    EdgeInsets.only(
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            15.0,
                                                                        top:
                                                                            10.0,
                                                                        bottom:
                                                                            10.0),
                                                              ),
                                                              onChanged:
                                                                  (text) {
                                                                participation
                                                                    .eventTemplates[
                                                                        0]
                                                                    .Value = text;
                                                              },
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: Styles
                                                                      .textSizRegular,
                                                                  fontFamily: tr(
                                                                      "currFontFamilyEnglishOnly")),
                                                            ))),
                                                  ]))
                                            ]))
                                        /*])*/
                                        )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text(
                                              participation.eventTemplates
                                                          .length >
                                                      1
                                                  ? participation
                                                      .eventTemplates[1].label
                                                  : "",
                                              style: distance
                                                  .distancepage(context))),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          right: 8.0,
                                          top: 8.0,
                                          bottom: 0),
                                      child: Container(
                                          /*decoration: new BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(2.0)),
                                              border: new Border.all(
                                                  color: Colors.black38))*/
                                          height: 40,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 10),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        child: Material(
                                                            elevation: 5.0,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                                    child: new DropdownButton<
                                                                        String>(
                                                              value: hour,
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontSize: Styles
                                                                      .textSizRegular,
                                                                  fontFamily: tr(
                                                                      "currFontFamilyEnglishOnly")),
                                                              items: hours.map(
                                                                  (String
                                                                      value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: SizedBox(
                                                                      width: 30,
                                                                      child: new Text(
                                                                        value,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  dataLoaded
                                                                      ? null
                                                                      : (text) {
                                                                          setState(
                                                                              () {
                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                            hour =
                                                                                text;
                                                                          });
                                                                        },
                                                              icon: null,
                                                              iconSize: 0,
                                                              hint: Text(
                                                                  "  " + hour,
                                                                  style: TextStyle(
                                                                      color: ColorData
                                                                          .primaryTextColor,
                                                                      fontSize:
                                                                          Styles
                                                                              .textSizRegular,
                                                                      fontFamily:
                                                                          tr("currFontFamilyEnglishOnly"))),
                                                            )))),
                                                    Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 1,
                                                                    right: 2),
                                                            child: Text(":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .textSizRegular,
                                                                    fontFamily:
                                                                        tr("currFontFamilyEnglishOnly"))))),
                                                    Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        child: Material(
                                                            elevation: 5.0,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                                    child: new DropdownButton<
                                                                        String>(
                                                              value: min,
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontSize: Styles
                                                                      .textSizRegular,
                                                                  fontFamily: tr(
                                                                      "currFontFamilyEnglishOnly")),
                                                              items: mins.map(
                                                                  (String
                                                                      value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: SizedBox(
                                                                      width: 30,
                                                                      child: new Text(
                                                                        value,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  dataLoaded
                                                                      ? null
                                                                      : (text) {
                                                                          setState(
                                                                              () {
                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                            min =
                                                                                text;
                                                                          });
                                                                        },
                                                              icon: null,
                                                              iconSize: 0,
                                                              hint: Text(
                                                                  "  " + min,
                                                                  style: TextStyle(
                                                                      color: ColorData
                                                                          .primaryTextColor,
                                                                      fontSize:
                                                                          Styles
                                                                              .textSizRegular,
                                                                      fontFamily:
                                                                          tr("currFontFamilyEnglishOnly"))),
                                                            )))),
                                                    Container(
                                                        height: 40,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 10,
                                                                    bottom: 1,
                                                                    right: 2),
                                                            child: Text(":",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .textSizRegular,
                                                                    fontFamily:
                                                                        tr("currFontFamilyEnglishOnly"))))),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        height: 30,
                                                        child: Material(
                                                            elevation: 5.0,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                                    child: new DropdownButton<
                                                                        String>(
                                                              value: sec,
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontSize: Styles
                                                                      .textSizRegular,
                                                                  fontFamily: tr(
                                                                      "currFontFamilyEnglishOnly")),
                                                              items: second.map(
                                                                  (String
                                                                      value) {
                                                                return new DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: SizedBox(
                                                                      width: 30,
                                                                      child: new Text(
                                                                        value,
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      )),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  dataLoaded
                                                                      ? null
                                                                      : (text) {
                                                                          setState(
                                                                              () {
                                                                            FocusScope.of(context).requestFocus(FocusNode());
                                                                            sec =
                                                                                text;
                                                                          });
                                                                        },
                                                              icon: null,
                                                              iconSize: 0,
                                                              hint: Text(
                                                                  "  " + sec,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color: ColorData
                                                                          .primaryTextColor,
                                                                      fontSize:
                                                                          Styles
                                                                              .textSizRegular,
                                                                      fontFamily:
                                                                          tr("currFontFamilyEnglishOnly"))),
                                                            ))))
                                                  ])
                                              /*])*/
                                              )),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.25,
                                          child: Text("")),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0,
                                          top: 0,
                                          right: 8.0,
                                          bottom: 5.0),
                                      child: Container(
                                          height: 30,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.50,
                                          child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, top: 1),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                        height: 20,
                                                        alignment:
                                                            Alignment.center,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        child: Text(
                                                          "HH",
                                                          style: TextStyle(
                                                              color: ColorData
                                                                  .primaryTextColor,
                                                              fontSize: Styles
                                                                  .textSiz,
                                                              fontFamily: tr(
                                                                  "currFontFamilyEnglishOnly")),
                                                        )),
                                                    Container(
                                                        height: 20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0,
                                                                    bottom: 1,
                                                                    right: 2),
                                                            child: Text("",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .textSiz,
                                                                    fontFamily:
                                                                        tr("currFontFamilyEnglishOnly"))))),
                                                    Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        child: Text(
                                                          "MM",
                                                          style: TextStyle(
                                                              color: ColorData
                                                                  .primaryTextColor,
                                                              fontSize: Styles
                                                                  .textSiz,
                                                              fontFamily: tr(
                                                                  "currFontFamilyEnglishOnly")),
                                                        )),
                                                    Container(
                                                        height: 20,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.03,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 0,
                                                                    bottom: 1,
                                                                    right: 2),
                                                            child: Text("",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: TextStyle(
                                                                    color: ColorData
                                                                        .primaryTextColor,
                                                                    fontSize: Styles
                                                                        .textSiz,
                                                                    fontFamily:
                                                                        tr("currFontFamilyEnglishOnly"))))),
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.10,
                                                        alignment:
                                                            Alignment.center,
                                                        height: 20,
                                                        child: Text(
                                                          "SS",
                                                          style: TextStyle(
                                                              color: ColorData
                                                                  .primaryTextColor,
                                                              fontSize: Styles
                                                                  .textSiz,
                                                              fontFamily: tr(
                                                                  "currFontFamilyEnglishOnly")),
                                                        ))
                                                  ])
                                              /*])*/
                                              )),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )),
                  ),
                ],
              );
            })
        : Container();
  }

  Widget getUpload(BuildContext buildContext) {
    return (eventParticipantList != null && eventParticipantList.length > 0)
        ? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: eventParticipantList.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, i) {
              Widget leading = Container(
                decoration: BoxDecoration(
                    color: isExpanded == true
                        ? selectedIndex == i
                            ? Color.fromRGBO(62, 181, 227, 1)
                            : Color.fromRGBO(214, 239, 249, 1)
                        : Color.fromRGBO(214, 239, 249, 1),
                    shape: BoxShape.circle),
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
                        child: Center(
                          child: Container(
                            child: Column(
                              children: [
                                Container(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                      /*dataLoaded
                                          ? Text('')
                                          :*/
                                      Container(
                                        height: dataLoaded ? 70 : 140,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.93,
                                        child: Column(children: [
                                          dataLoaded
                                              ? Text('')
                                              : Row(children: [
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.30,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                top: 8),
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            //Center Row contents horizontally,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            //Center Row contents vertically,
                                                            children: <Widget>[
                                                              Column(
                                                                children: <
                                                                    Widget>[
                                                                  IconButton(
                                                                      iconSize:
                                                                          40,
                                                                      //tooltip: "Upload your files here",
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .add_circle_outline,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        //debugprint("SSSSSS Key Pressd"),
                                                                        displayModalBottomSheet(
                                                                            context);
                                                                      } //=> getImageFromGallery(),
                                                                      ),
                                                                  // Text(
                                                                  //   "Upload Files",
                                                                  //   style: TextStyle(
                                                                  //       color: ColorData
                                                                  //           .primaryTextColor,
                                                                  //       fontSize:
                                                                  //           Styles
                                                                  //               .textSiz,
                                                                  //       fontFamily:
                                                                  //           tr("currFontFamilyEnglishOnly")),
                                                                  // )
                                                                  ///////
                                                                ],
                                                              ),
                                                            ]),
                                                      )),
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.60,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 10),
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                              "Upload Required Documents",
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
                                                                  fontSize: Styles
                                                                      .textSiz,
                                                                  fontFamily: tr(
                                                                      "currFontFamilyEnglishOnly"))),
                                                          Text(
                                                            "Supported formats PNG, PDF or JPG",
                                                            style: TextStyle(
                                                                color: ColorData
                                                                    .primaryTextColor,
                                                                fontSize: Styles
                                                                    .textSiz,
                                                                fontFamily: tr(
                                                                    "currFontFamilyEnglishOnly")),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ]),
                                          fileName == null || fileName == ""
                                              ? Text('')
                                              : Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 20),
                                                  child: Text(
                                                      widget.eventId
                                                              .toString() +
                                                          "_" +
                                                          participation
                                                              .firstName +
                                                          ".jpg",
                                                      style: EventPeopleListPageStyle
                                                          .eventPeopleListPageSubHeadingTextStyle(
                                                              context,
                                                              isBlue: true)),
                                                )
                                        ]),
                                      ),
                                      // dataLoaded ? Text('') : Text(''),
                                      //             fileName == null || fileName == ""
                                      //                 ? Text('')
                                      //                 : Container(
                                      //                     height: 75,
                                      //                     width: MediaQuery.of(context)
                                      //                             .size
                                      //                             .width *
                                      //                         0.93,
                                      //                     child: Padding(
                                      //                       padding: const EdgeInsets.only(
                                      //                           left: 15, right: 15),
                                      //                       child: Row(
                                      //                         mainAxisAlignment:
                                      //                             MainAxisAlignment
                                      //                                 .spaceBetween,
                                      //                         //Center Row contents horizontally,
                                      //                         crossAxisAlignment:
                                      //                             CrossAxisAlignment.center,
                                      //                         children: <Widget>[
                                      //                           Row(
                                      //                             children: <Widget>[
                                      //                               /*Image.network(
                                      //                                 serverTestPath +
                                      //                                     fileName,
                                      //                                 width: MediaQuery.of(
                                      //                                             context)
                                      //                                         .size
                                      //                                         .width *
                                      //                                     0.80,
                                      //                                 fit: BoxFit.fill,*/
                                      //                               Text(
                                      //                                   widget.eventId
                                      //                                           .toString() +
                                      //                                       "_" +
                                      //                                       participation
                                      //                                           .firstName +
                                      //                                       ".jpg",
                                      //                                   style: TextStyle(
                                      //                                       color: ColorData
                                      //                                           .primaryTextColor,
                                      //                                       fontSize: Styles
                                      //                                           .reviewTextSize,
                                      //                                       fontFamily: tr(
                                      //                                           "currFontFamilyEnglishOnly"))),
                                      //                             ],
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //
                                      //                     decoration: BoxDecoration(
                                      //                       color: Colors.white,
                                      //                       boxShadow: [
                                      //                         BoxShadow(
                                      //                           color: Colors.grey,
                                      //                           blurRadius: 5.0,
                                      //                         ),
                                      //                       ],
                                      //                       borderRadius:
                                      //                           new BorderRadius.only(
                                      //                         topLeft:
                                      //                             const Radius.circular(
                                      //                                 10.0),
                                      //                         topRight:
                                      //                             const Radius.circular(
                                      //                                 10.0),
                                      //                         bottomLeft:
                                      //                             const Radius.circular(
                                      //                                 10.0),
                                      //                         bottomRight:
                                      //                             const Radius.circular(
                                      //                                 10.0),
                                      //                       ),
                                      //                     ),
                                      //                     //child:
                                      //                     /*Image.file(imageURI,
                                      // width: 100, height: 50, fit: BoxFit.cover)*/
                                      //                   ),
                                      dataLoaded
                                          ? Text('')
                                          : SizedBox(
                                              height: 15,
                                            )
                                    ]))
                              ],
                            ),
                          ),
                        )),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(left: 20.0, right: 20.0),
                  //   child: Divider(
                  //     color: Colors.black26,
                  //   ),
                  // )
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
      isExpanded = true;
    });
  }

  void _pickImage(ImageSource img) async {
    try {
      PickedFile image = PickedFile((await picker.getImage(source: img)).path);
      setState(() {
        if (image != null) {
          debugPrint(image.path);
          uploadImage(image.path);
        } else {
          debugPrint(image.path);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> uploadImage(filename) async {
    debugPrint("I am here Upload");
    var request = http.MultipartRequest(
        'POST',
        Uri.parse(serverReceiverPath +
            "?id=1&eventid=" +
            widget.eventId.toString() +
            "&eventparticipantid=" +
            participation.eventParticipantId.toString() +
            "&FileName=" +
            newFileName +
            "&uploadtype=1"));
    request.files.add(await http.MultipartFile.fromPath('picture', filename));
    var res = await request.send();
    debugPrint(" ddddddd " + res.toString());
    apiFileName = await res.stream.bytesToString();
    apiFileName = apiFileName.replaceAll('"', '');
    debugPrint(" ddddddd1 " + apiFileName);
    setState(() {
      fileName = "UploadDocument/Event/" +
          widget.eventId.toString() +
          "/ParticipantResult/" +
          participation.eventParticipantId.toString() +
          "/" +
          apiFileName;
    });
    customGetSnackBarWithOutActionButton(
        "File Upload", "File Uploaded Successfully", context);
    return res.reasonPhrase;
  }

  // void _showAlertImagePickDialog(BuildContext context) {
  //   // set up the list options
  //   Widget gallery = SimpleDialogOption(
  //     child: const Text('Gallery'),
  //     onPressed: () async {
  //       // _pickImage(ImageSource.gallery);
  //       File f = await EventRepository().getImage();
  //       debugPrint(f.path);
  //       Navigator.of(context).pop();
  //     },
  //   );
  //   Widget camera = SimpleDialogOption(
  //     child: const Text('Camera'),
  //     onPressed: () {
  //       _pickImage(ImageSource.camera);
  //       Navigator.of(context).pop();
  //     },
  //   );
  //
  //   // set up the SimpleDialog
  //   SimpleDialog dialog = SimpleDialog(
  //     title: const Text('Choose an Option'),
  //     children: <Widget>[gallery, camera],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return dialog;
  //     },
  //   );
  // }

  void displayModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: new Wrap(
                  children: <Widget>[
                    new ListTile(
                        trailing: new Icon(Icons.photo_library,
                            color: ColorData.colorBlue),
                        title: new Text('Photo Library'),
                        onTap: () {
                          BlocProvider.of<EventPeopleListBloc>(context)
                              .add(ShowImageEvent());
                          Navigator.of(context).pop();
                        }),
                    new ListTile(
                      trailing: new Icon(Icons.photo_camera,
                          color: ColorData.colorBlue),
                      title: new Text('Take Photo '),
                      onTap: () {
                        BlocProvider.of<EventPeopleListBloc>(context)
                            .add(ShowImageCameraEvent());
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ));
        });
  }

  bool validateForm(BuildContext context) {
    if (participation.eventTemplates.length > 0 &&
        participation.eventTemplates[0].isRequired &&
        participation.eventTemplates[0].Value.isEmpty) {
      customGetSnackBarWithOutActionButton(tr('error_caps'),
          participation.eventTemplates[0].validationMessage, context);
      return false;
    } else if (participation.eventTemplates.length > 1 &&
        participation.eventTemplates[1].isRequired &&
        participation.eventTemplates[1].Value.isEmpty) {
      customGetSnackBarWithOutActionButton(tr('error_caps'),
          participation.eventTemplates[1].validationMessage, context);
      return false;
    }
    return true;
  }

  customGetSnackBarWithOutActionButton(titlemsg, contentmsg, context) {
    return Get.snackbar(
      titlemsg,
      contentmsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }
}
