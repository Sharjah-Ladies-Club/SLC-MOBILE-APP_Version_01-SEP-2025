// ignore_for_file: must_be_immutable

import 'dart:ui' as prefix;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/event_list_response.dart';
import 'package:slc/model/event_review_list_detail.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/view/event_details/event_details.dart';
import 'package:slc/view/event_specific_view/events_specific_review.dart';
import 'package:slc/view/events/tab_content/bloc/bloc.dart';

import 'event_review_details/event_review_details.dart';

class EventTabContent extends StatelessWidget {
  double tabContentWidth;

  EventTabContent(this.tabContentWidth);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabContentBloc, TabContentState>(
      builder: (context, state) {
        if (state is EventListLoaded) {
          SPUtil.putBool(
              Constants.IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT, false);
          if (state.eventListResponse != null &&
              state.eventListResponse.length > 0) {
            return tab1(state.eventListResponse);
          } else {
            return Container(
              child: Center(
                child: Text(tr("noDataFound"),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily"))),
              ),
            );
          }
        } else if (state is ReviewListLoaded) {
          SPUtil.putBool(
              Constants.IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT, false);
          if (state.reviewListDetails != null &&
              state.reviewListDetails.length > 0) {
            return tab2(state.reviewListDetails);
          } else {
            return Container(
              child: Center(
                child: Text(tr("noDataFound"),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily"))),
              ),
            );
          }
        }
        return Container();
      },
    );
  }

  Widget tab2(List<ReviewListDetails> reviewListDetails) {
    return ListView.builder(
        key: PageStorageKey<int>(2),
        shrinkWrap: true,
        itemCount: reviewListDetails.length,
        itemBuilder: (BuildContext context, int index) {
          return reviewListDetails[index] != null
              ? GestureDetector(
                  child: secondTab(reviewListDetails[index], context),
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return EventReviewDetails(
                            reviewListDetails: reviewListDetails[index],
                          );
                        },
                      ),
                    )
                  },
                )
              : Container(
                  child: Center(
                    child: Text(tr("noDataFound"),
                        style: TextStyle(
                            color: ColorData.primaryTextColor,
                            fontFamily: tr("currFontFamily"))),
                  ),
                );
        });
  }

  Widget firstTab(EventListResponse eventListResponse, BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      child: Container(
          padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
          height: 165.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(top: 5),
              // leading: imageView(eventListResponse.imageURL, context),
              title: detailsView(
                  eventListResponse, context, eventListResponse.imageURL))),
    );
  }

  Widget tab1(List<EventListResponse> eventListResponse) {
    return ListView.builder(
        key: PageStorageKey<int>(1),
        shrinkWrap: true,
        itemCount: eventListResponse.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: firstTab(eventListResponse[index], context),
              onTap: () => _navigateToDetailOrReview(
                  eventListResponse, eventListResponse[index], context));
        });
  }

  _navigateToDetailOrReview(List<EventListResponse> eventList,
      EventListResponse eventListResponse, BuildContext context) {
    if (eventListResponse.statusId == Integer.Review &&
        eventListResponse.isReviewPending) {
      tab1NextScreen(eventList, eventListResponse, context);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return EventDetails(
              eventId: eventListResponse.id,
              statusId: eventListResponse.statusId,
            );
          },
        ),
      );
    }
  }

  tab1NextScreen(List<EventListResponse> eventList,
      EventListResponse eventListResponse, BuildContext context) async {
    final responseFromPage = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          SPUtil.remove("FeedBackSelectedList");
          return EventSpecificReview(eventListResponse.id);
        },
      ),
    );

    if (responseFromPage != 0) {
      eventList.removeWhere((event) => event.id == responseFromPage);

      BlocProvider.of<TabContentBloc>(context)
          .add(EventRefresh(eventListResponse: eventList));
    }
  }

  Widget secondTab(ReviewListDetails reviewListDetails, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(5),
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: reviewListDetails.eventBasicDetail.defaultImage != null
                    ? reviewListDetails
                                .eventBasicDetail.defaultImage.imageUrl !=
                            null
                        ? reviewListDetails.eventBasicDetail.defaultImage
                                    .imageUrl.length >
                                0
                            ? NetworkImage(reviewListDetails
                                .eventBasicDetail.defaultImage.imageUrl)
                            : AssetImage("assets/images/ic_launcher.png")
                        : AssetImage("assets/images/ic_launcher.png")
                    : AssetImage("assets/images/ic_launcher.png"),
                fit: BoxFit.cover,
              )),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Text(
                reviewListDetails.eventBasicDetail.name != null
                    ? reviewListDetails.eventBasicDetail.name
                    : "",
                style: TextStyle(
                  color: Color.fromRGBO(58, 181, 228, 1),
                  fontWeight: FontWeight.bold,
                  fontFamily: tr("currFontFamilyEnglishOnly"),
                ),
              ),
            ),
            Visibility(
              visible:
                  reviewListDetails.eventBasicDetail.shortDescription != null,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 8, 10, 5),
                child: Text(
                  reviewListDetails.eventBasicDetail.shortDescription != null
                      ? reviewListDetails.eventBasicDetail.shortDescription
                      : "",
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"),
                      fontSize: 12.0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Row(
                children: <Widget>[
                  Icon(
                    CommonIcons.calendar_border,
                    color: ColorData.primaryTextColor,
                    size: 12,
                  ),
                  Container(
                    margin: Localizations.localeOf(context).languageCode == "en"
                        ? EdgeInsets.only(top: 5.0, left: 3.0)
                        : EdgeInsets.only(top: 5.0, right: 3.0),
                    child: Text(
                      reviewListDetails.eventBasicDetail.dateRange != null
                          ? reviewListDetails.eventBasicDetail.dateRange
                          : "",
                      textDirection: prefix.TextDirection.ltr,
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontSize: 12.0,
                          fontFamily: tr('currFontFamilyEnglishOnly')),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 10, 5),
              child: Row(
                children: <Widget>[
                  new Icon(
                    CommonIcons.time_half,
                    color: ColorData.primaryTextColor,
                    size: 12,
                  ),
                  Container(
                    margin: Localizations.localeOf(context).languageCode == "en"
                        ? EdgeInsets.only(top: 5.0, left: 3.0)
                        : EdgeInsets.only(top: 5.0, right: 3.0),
                    child: Text(
                      reviewListDetails.eventBasicDetail.timeRange != null
                          ? reviewListDetails.eventBasicDetail.timeRange
                          : "",
                      textDirection: prefix.TextDirection.ltr,
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontSize: 12.0,
                          fontFamily: tr('currFontFamilyEnglishOnly')),
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Row(
                children: <Widget>[
                  Row(children: <Widget>[
                    Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(58, 181, 228, 1),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Center(
                            child: Text(
                          reviewListDetails.overAllRating != null
                              ? reviewListDetails.overAllRating.toString()
                              : "",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: tr("currFontFamilyEnglishOnly"),
                              fontSize: 14.0),
                        ))),
                    Padding(
                      padding:
                          Localizations.localeOf(context).languageCode == "en"
                              ? const EdgeInsets.only(left: 8.0)
                              : const EdgeInsets.only(right: 8.0),
                      child: Text(
                        reviewListDetails.overAllRatingText != null
                            ? reviewListDetails.overAllRatingText
                            : "",
                        style: TextStyle(
                            fontFamily: tr("currFontFamily"),
                            fontSize: 12.0,
                            color: ColorData.primaryTextColor),
                      ),
                    )
                  ]),
                  Spacer(),
                  Row(children: <Widget>[
                    Text(
                      tr("txt_top_5_review"),
                      style: TextStyle(
                          color: Color.fromRGBO(58, 181, 228, 1),
                          fontFamily: tr("currFontFamily"),
                          fontSize: 11.0),
                    ),
                    Icon(Icons.keyboard_arrow_down,
                        size: 16, color: Color.fromRGBO(58, 181, 228, 1))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget imageView(String imageURL, BuildContext context) {
    return Container(
      margin: Localizations.localeOf(context).languageCode == "en"
          ? EdgeInsets.only(left: 5.0, right: 5.0)
          : EdgeInsets.only(right: 5.0, left: 5.0),
      width: tabContentWidth / 2.5,
      height: tabContentWidth * 0.34,
      child: imageUI(imageURL),
    );
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: imageProvider,
              // fit: BoxFit.cover,
              fit: BoxFit.fill),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget detailsView(
      EventListResponse response, BuildContext context, String imageURL) {
    return Row(children: [
      Container(child: imageView(imageURL, context)),
      Expanded(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Padding(
              padding: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(top: 8.0)
                  : EdgeInsets.only(right: 5.0),
              child: new Text(
                response != null
                    ? response.name != null
                        ? response.name
                        : ""
                    : "",
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: tr('currFontFamily'),
                    color: Color.fromRGBO(58, 181, 228, 1),
                    fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(top: 2.0)
                  : EdgeInsets.only(right: 5.0),
              child: Text(
                response != null
                    ? response.description != null
                        ? response.description
                        : ""
                    : "",
                style: TextStyle(
                    fontSize: 12,
                    color: ColorData.primaryTextColor,
                    fontFamily: tr('currFontFamily'),
                    fontWeight: FontWeight.w100),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
//          GestureDetector(
//            onTap: () => {},
//            child: Text(
//              'Read more...',
//              style: TextStyle(
//                  fontSize: 12,
//                  fontFamily: 'HelveticaNeue',
//                  fontWeight: FontWeight.w200),
//              overflow: TextOverflow.ellipsis,
//              maxLines: 1,
//            ),
//          ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    CommonIcons.time_half,
                    size: 14,
                  ),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 5.0, top: 4.0)
                            : EdgeInsets.only(right: 5.0, top: 4.0),
                    child: Text(
                        response != null
                            ? response.timeRange != null
                                ? response.timeRange
                                : ""
                            : "",
                        textDirection: prefix.TextDirection.ltr,
                        style: TextStyle(
                            color: ColorData.primaryTextColor,
                            fontSize: 12,
                            fontFamily: "HelveticaNeue",
                            fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ),
            //Start
            Visibility(
                visible: response.statusId != Integer.Closed,
                child: Padding(
                  padding: const EdgeInsets.only(top: 2.0),
                  child: new Row(
                    children: <Widget>[
                      new Icon(
                        CommonIcons.user_two,
                        size: 14,
                      ),
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 5.0, top: 4.0)
                                : EdgeInsets.only(right: 5.0, top: 4.0),
                        child: Text(
                            response != null
                                ? response.availableSeats != null &&
                                        response.availableSeats > 0
                                    ? tr('available_seats') +
                                        " " +
                                        response.availableSeats.toString()
                                    : tr("sold_out")
                                : "",
                            textDirection: prefix.TextDirection.ltr,
                            style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontSize: 12,
                                fontFamily: "HelveticaNeue",
                                fontWeight: FontWeight.w500)),
                      )
                    ],
                  ),
                )),

            //End
            Padding(
              padding: EdgeInsets.only(top: 4.0),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    CommonIcons.calendar_border,
                    size: 14,
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          Localizations.localeOf(context).languageCode == "en"
                              ? EdgeInsets.only(left: 5.0, top: 4.0)
                              : EdgeInsets.only(right: 5.0, top: 4.0),

                      child: new AutoSizeText(
                        response != null
                            ? response.dateRange != null
                                ? response.dateRange
                                : ""
                            : "",
                        maxFontSize: 12,
                        minFontSize: 10,
                        maxLines: 1,
                        textAlign:
                            Localizations.localeOf(context).languageCode == "ar"
                                ? TextAlign.end
                                : TextAlign.start,
                        textDirection: prefix.TextDirection.ltr,
                        style: TextStyle(
                            fontSize: 12,
                            color: ColorData.primaryTextColor,
                            fontFamily: "HelveticaNeue",
                            fontWeight: FontWeight.w500),
//                     overflow: TextOverflow.ellipsis,
                      ),

//                  child: Text(
//                    response != null
//                        ? response.dateRange != null ? response.dateRange : ""
//                        : "",
//                    textDirection: TextDirection.ltr,
//                    style: TextStyle(
//                        fontSize: 12,
//                        fontFamily: "HelveticaNeue",
//                        fontWeight: FontWeight.w500),
//                    overflow: TextOverflow.ellipsis,
//                  ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                color: Colors.grey, height: 0.2, width: tabContentWidth / 1.5),
            Padding(
                padding: Localizations.localeOf(context).languageCode == "en"
                    ? EdgeInsets.only(top: 5.0, bottom: 5.0)
                    : EdgeInsets.only(top: 0.0, bottom: 2.0),
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    response.statusId == Integer.Opened
                        ? Image.asset('assets/images/qrcode.png')
                        : Icon(CommonIcons.review,
                            size: 14, color: Color.fromRGBO(58, 181, 228, 1)),
                    Padding(
                      padding: EdgeInsets.only(left: 5.0, top: 3.0, right: 5.0),
                      child: Text(
                        response.status != null
                            ? response.statusId == Integer.Opened
                                ? tr("opened")
                                : response.statusId == Integer.Review
                                    ? tr("review")
                                    : response.statusId == Integer.Upcoming
                                        ? tr("upcoming")
                                        : response.statusId == Integer.Closed
                                            ? tr("closed")
                                            : response.statusId ==
                                                    Integer.Registration_Started
                                                ? tr("Registration_Started")
                                                : response.statusId ==
                                                        Integer.Event_Started
                                                    ? tr("Event_Started")
                                                    : response.statusId ==
                                                            Integer
                                                                .Submit_Results
                                                        ? tr("Submit_Results")
                                                        : response.statusId ==
                                                                Integer
                                                                    .Registration_Completed
                                                            ? tr(
                                                                "Registration_Completed")
                                                            : ""
                            : "",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            fontFamily: tr('currFontFamily'),
                            color: Color.fromRGBO(58, 181, 228, 1)),
                      ),
                    ),
                  ],
                )

//            Row(
//                //  mainAxisSize: MainAxisSize.min,
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  Padding(
//                    padding:
//                        Localizations.localeOf(context).languageCode == "en"
//                            ? EdgeInsets.fromLTRB(6.0, 8.0, 8.0, 8.0)
//                            : EdgeInsets.only(right: 5.0),
//                    child: Text(
//                      tr('status'),
//                      style: TextStyle(
//                          fontSize: 12,
//                          color: ColorData.primaryTextColor,
//                          fontFamily:
//                              tr('currFontFamily'),
//                          fontWeight: FontWeight.w500),
//                    ),
//                  ),
//                  Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: <Widget>[
//                      response.statusId == Integer.Opened
//                          ? Image.asset('assets/images/qrcode.png')
//                          : Icon(CommonIcons.review,
//                              size: 14, color: Color.fromRGBO(58, 181, 228, 1)),
//                      Padding(
//                        padding:
//                            EdgeInsets.only(left: 5.0, top: 3.0, right: 5.0),
//                        child: Text(
//                          response.status != null
//                              ? response.statusId == Integer.Opened
//                                  ? tr("opened")
//                                  : response.statusId == Integer.Review
//                                      ?
//                                          tr("review")
//                                      : response.statusId == Integer.Upcoming
//                                          ?
//                                              tr("upcoming")
//                                          : response.statusId == Integer.Closed
//                                              ?
//                                                  tr("closed")
//                                              : response.statusId ==
//                                                      Integer
//                                                          .Registration_Started
//                                                  ?
//                                                      tr(
//                                                          "Registration_Started")
//                                                  : response.statusId ==
//                                                          Integer.Event_Started
//                                                      ? AppLocalizations.of(
//                                                              context)
//                                                          tr("Event_Started")
//                                                      : ""
//                              : "",
//                          style: TextStyle(
//                              fontSize: 10,
//                              fontWeight: FontWeight.bold,
//                              fontFamily:
//                                  tr('currFontFamily'),
//                              color: Color.fromRGBO(58, 181, 228, 1)),
//                        ),
//                      ),
//                    ],
//                  )
//                ]),
                )
          ],
        ),
      ))
    ]);
  }
}
