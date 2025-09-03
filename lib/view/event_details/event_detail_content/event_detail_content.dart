// ignore_for_file: must_be_immutable

import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html_textview_render/html_text_view.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_raised_button.dart';
import 'package:slc/model/event_detail_response.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_details/event_detail_content/bloc/bloc.dart';
import 'package:slc/view/event_details/event_detail_content/event_direction.dart';
import 'package:slc/view/event_people_list/event_people_list.dart';

class EventDetailContent extends StatelessWidget {
  int statusId;
  EventDetailContent({this.statusId});
  @override
  Widget build(BuildContext context) {
    return _EventDetailContent(
      statusId: statusId,
    );
  }
}

class _EventDetailContent extends StatefulWidget {
  int statusId;
  _EventDetailContent({this.statusId});
  @override
  State<StatefulWidget> createState() {
    return _EventDetailContentPage();
  }
}

class _EventDetailContentPage extends State<_EventDetailContent> {
  int statusId;
  _EventDetailContentPage({this.statusId});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventDetailContentBloc, EventDetailContentState>(
      builder: (context, state) {
        if (state is LoadEventDetailContentState) {
          return showContentView(state.eventDetailResponse);
        }
        return Container();
      },
    );
  }

  Widget showContentView(EventDetailResponse eventDetailResponse) {
//    String price = eventDetailResponse.price != null
//        ? (int.parse(eventDetailResponse.price.toString().split('.')[1]))
//                    .toString() ==
//                '0'
//            ? eventDetailResponse.price.toString().split('.')[0]
//            : eventDetailResponse.price.toString()
//        : "";
//
    String price = eventDetailResponse.price != null
        ? Utils().getAmount(amount: eventDetailResponse.price)
        : "0.00";

    String btnName = tr('regBtn');
    if (eventDetailResponse.isViewParticipants) {
      btnName = tr('view_people');
    }
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: (eventDetailResponse.isRegisterAllowed ||
              eventDetailResponse.isViewParticipants)
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: 50.0,
              margin: EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              child: CustomRaisedButton(
                  btnName,
                  () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) {
                              return EventPeopleList(
                                eventId: eventDetailResponse.eventId,
                                eventPriceCategoryList:
                                    eventDetailResponse.eventPriceCategoryList,
                                showAddPeople:
                                    eventDetailResponse.isViewParticipants,
                                statusId: widget.statusId,
                              );
                            },
                          ),
                        ),
                      }))
          : Container(
              width: 0.0,
              height: 0.0,
            ),
      body: SingleChildScrollView(
        child: Container(
            color: Colors.white,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(
                    eventDetailResponse.name,
                    style: EventDetailPageStyle.eventDetailPageHeadingTextStyle(
                        context),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
                  child: InkWell(
                    onTap: () {
                      if (eventDetailResponse.latitude != null) {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  /*MapWebviewPage(
                                  url: Constants.GOOGLE_MAP_LOCATION_URL +
                                      "&origin=Current+Location&destination=" +
                                      eventDetailResponse.latitude.toString() +
                                      "," +
                                      eventDetailResponse.longitude.toString() +
                                      "&travelmode=driving&dir_action=navigate",
                                  title: "Event Location"))*/
                                  EventDirection(
                                    colorCode: "",
                                    facilityId: 4,
                                    platitude: eventDetailResponse.latitude,
                                    plongitude: eventDetailResponse.longitude,
                                  )),
                        );
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(CommonIcons.location,
                                color: Colors.black45, size: 20.0),
                            Container(
                              padding: EdgeInsets.only(top: 4.0, left: 5.0),
                              child: Text(
                                eventDetailResponse.venue != null
                                    ? eventDetailResponse.venue
                                    : "",
                                style: EventDetailPageStyle
                                    .eventDetailPageSubHeadingTextStyle(
                                        context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: 25.0, right: 25.0, top: 10.0, bottom: 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(CommonIcons.calendar_border,
                            size: 15, color: Colors.black45),
                        Container(
                          padding:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? EdgeInsets.only(left: 5.0, top: 4.0)
                                  : EdgeInsets.only(right: 5.0, top: 4.0),
                          child: Text(eventDetailResponse.dateRange,
                              textDirection: prefix.TextDirection.ltr,
                              style: EventDetailPageStyle
                                  .eventDetailPageTextStyleWithoutAr(context)),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(top: 14.0),
                          child: Icon(CommonIcons.time_half,
                              size: 15, color: Colors.black45),
                        ),
                        Container(
                          padding:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? EdgeInsets.only(left: 5.0, top: 16.0)
                                  : EdgeInsets.only(right: 5.0, top: 16.0),
                          child: Text(eventDetailResponse.timeRange,
                              textDirection: prefix.TextDirection.ltr,
                              style: EventDetailPageStyle
                                  .eventDetailPageTextStyleWithoutAr(context)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
                  child: Text(tr('aboutEvent'),
                      style: EventDetailPageStyle
                          .eventDetailPageTextStyleWithNewAr(context)

//                        style: TextStyle(
//                            color: ColorData.primaryTextColor,
//                            //  fontWeight: FontWeight.bold,
//                            fontSize: 12.0,
//                            fontFamily:
//                                .tr('currFontFamily')),
                      )),
              Padding(
                padding: EdgeInsets.only(
                    top: 5.0, left: 25.0, right: 20.0, bottom: 10.0),
                child: Html(
                  // anchorColor: ColorData.primaryTextColor,
                  style: {
                    "body": Style(
                      padding: EdgeInsets.all(0),
                      margin: Margins.all(0),
                      color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                      fontSize: FontSize(Styles.textSiz),
                      //color: ColorData.primaryTextColor,
                    ),
                    "p": Style(
                      padding: EdgeInsets.all(0),
                      margin: Margins.all(0),
                    ),
                    "span": Style(
                      padding: EdgeInsets.all(0),
                      margin: Margins.all(0),
                      // fontWeight: FontWeight.bold,
                      fontSize: FontSize(Styles.newTextSize),
                      fontFamily: tr('currFontFamily'),
                      color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
                    ),
                    "h6": Style(
                        fontSize: FontSize(Styles.newTextSize),
                        padding: EdgeInsets.all(0),
                        margin: Margins.all(0)),
                  },
                  data: '<html><body>' +
                      eventDetailResponse.contentOverview +
                      '</body></html>',
                  // customFont: tr('currFontFamily'),
                ),
              ),
              (eventDetailResponse.price > 0)
                  ? Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: ListTile(
                        leading: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(tr('regFees'),
                              style: EventDetailPageStyle
                                  .eventDetailPageTextStyleWithNewAr(context)),
                        ),
                        trailing: (eventDetailResponse.price != null &&
                                eventDetailResponse.price > 0)
                            ? Text(price,
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithoutAr(context)

//                          style: TextStyle(
//                              color: ColorData.primaryTextColor,
////                                  fontWeight: FontWeight.bold,
//                              fontSize: 12.0,
//                              fontFamily:
//                                  .tr('currFontFamilyEnglishOnly'))

                                )
                            : Text(tr('free'),
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithAr(context)

//                          style: TextStyle(
//                              color: ColorData.primaryTextColor,
////                              fontWeight: FontWeight.bold,
//                              fontSize: 12.0,
//                              fontFamily:
//                                  .tr('currFontFamily'))

                                ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: ListTile(
                        leading: Container(
                          margin: EdgeInsets.only(top: 5.0),
                          child: Text(tr('regFees'),
                              style: EventDetailPageStyle
                                  .eventDetailPageTextStyleWithNewAr(context)),
                        ),
                        trailing: (eventDetailResponse.price != null &&
                                eventDetailResponse.price > 0)
                            ? Text(price,
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithoutAr(context))
                            : Text(tr('free'),
                                style: EventDetailPageStyle
                                    .eventDetailPageTextStyleWithAr(context)),
                      ),
                    ),
              (eventDetailResponse.eventPriceCategoryList != null &&
                      eventDetailResponse.eventPriceCategoryList.length > 0)
                  ? Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 5.0),
                      child: Text(tr('catFees'),
                          style: EventDetailPageStyle
                              .eventDetailPageTextStyleWithNewAr(context)))
                  : Container(),
              (eventDetailResponse.eventPriceCategoryList != null &&
                      eventDetailResponse.eventPriceCategoryList.length > 0)
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.only(top: 5, bottom: 5),
                      itemCount:
                          eventDetailResponse.eventPriceCategoryList.length,
                      itemBuilder: (BuildContext context, int index) {
//                  String eventPriceCategory = eventDetailResponse
//                      .eventPriceCategoryList[index].price !=
//                      null
//                      ? (int.parse(eventDetailResponse
//                      .eventPriceCategoryList[index].price
//                      .toString()
//                      .split('.')[1]))
//                      .toString() ==
//                      '0'
//                      ? eventDetailResponse
//                      .eventPriceCategoryList[index].price
//                      .toString()
//                      .split('.')[0]
//                      : eventDetailResponse
//                      .eventPriceCategoryList[index].price
//                      .toString()
//                      : "";

                        String eventPriceCategory = eventDetailResponse
                                    .eventPriceCategoryList[index].price !=
                                null
                            ? Utils().getAmount(
                                amount: eventDetailResponse
                                    .eventPriceCategoryList[index].price)
                            : "";

                        return Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, bottom: 10.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                      (eventDetailResponse
                                                  .eventPriceCategoryList[index]
                                                  .name !=
                                              null)
                                          ? eventDetailResponse
                                              .eventPriceCategoryList[index]
                                              .name
                                          : "",
                                      style: EventDetailPageStyle
                                          .eventDetailPageTextStyleWithOpa(
                                              context)

//                                    style: TextStyle(
//                                        color: ColorData.primaryTextColor,
////                                              fontWeight: FontWeight.w500,
//                                        fontSize: 12.0,
//                                        fontFamily:
//
//                                            .tr('currFontFamily'))

                                      ),
                                  Text(
                                      (eventDetailResponse
                                                  .eventPriceCategoryList[index]
                                                  .price
                                                  .toString() !=
                                              null)
                                          ? eventPriceCategory
                                          : "",
                                      style: EventDetailPageStyle
                                          .eventDetailPageTextStyleWithoutAr(
                                              context)

//                                    style: TextStyle(
//                                        color: ColorData.primaryTextColor,
////                                              fontWeight: FontWeight.w500,
//                                        fontSize: 12.0,
//                                        fontFamily: AppLocalizations.of(
//                                            context)
//                                            .tr('currFontFamilyEnglishOnly'))

                                      )
                                ],
                              ),
                              getHtml(eventDetailResponse
                                  .eventPriceCategoryList[index].description)
                            ],
                          ),
                        );
                      },
                    )
                  : Container()
            ])),
      ),
    );
  }

  Widget getHtml(String description) {
    return Html(
      style: {
        "body": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
          fontWeight: FontWeight.bold,
          fontSize: FontSize(Styles.discountTextSize),
          color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
          fontFamily: tr('currFontFamily'),
        ),
        "p": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
        ),
        "span": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
          fontWeight: FontWeight.bold,
          fontSize: FontSize(Styles.discountTextSize),
          color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
          fontFamily: tr('currFontFamily'),
        ),
        "h6": Style(
            fontFamily: tr('currFontFamily'),
            padding: EdgeInsets.all(0),
            margin: Margins.all(0)),
      },
      // customFont: tr('currFontFamilyEnglishOnly'),
      // anchorColor: ColorData.primaryTextColor,
      data: description != null
          ? "<html><body>" + description + "</body></html>"
          : "",
    );
  }
}
