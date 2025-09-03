import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/review_details.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/utils/datetime_utils.dart';

import 'bloc/event_review_detail_content_bloc.dart';
import 'bloc/event_review_detail_content_state.dart';
import 'dart:ui' as prefix;

class EventReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _EventReviewList();
  }
}

class _EventReviewList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ContentView();
  }
}

class _ContentView extends State<_EventReviewList> {
  ReviewDetails reviewDetails = ReviewDetails();

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventReviewDetailContentBloc,
        EventReviewDetailContentState>(
      listener: (context, state) {
        if (state is OnReviewDetailLoadSuccess) {
          reviewDetails = state.reviewDetails;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<EventReviewDetailContentBloc,
            EventReviewDetailContentState>(
          builder: (context, state) {
            return (reviewDetails != null &&
                    reviewDetails.reviewEventDetailsViewDtos != null &&
                    reviewDetails.reviewEventDetailsViewDtos.length > 0)
                ? getEventWriteReview(context, reviewDetails)
                : Container();
          },
        ),
      ),
    );
  }

  Widget getEventWriteReview(
      BuildContext context, ReviewDetails reviewDetails) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Align(
                  alignment: Alignment.center,
                  child: Text(
                      reviewDetails.eventBasicDetail != null
                          ? reviewDetails.eventBasicDetail.name != null
                              ? reviewDetails.eventBasicDetail.name
                              : ""
                          : "",
                      style: TextStyle(
                          color: ColorData.colorBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                          fontFamily: tr('currFontFamily')))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
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
                        padding: const EdgeInsets.only(top: 4.0, left: 5.0),
                        child: Text(
                          reviewDetails.eventBasicDetail != null
                              ? reviewDetails.eventBasicDetail.venue != null
                                  ? reviewDetails.eventBasicDetail.venue
                                  : ""
                              : "",
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: 14.0,
                              fontFamily: tr('currFontFamily')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(CommonIcons.calendar_border,
                          size: 15, color: Colors.black45),
                      Container(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 5.0, top: 4.0)
                                : EdgeInsets.only(right: 5.0, top: 4.0),
                        child: new Text(
                          reviewDetails.eventBasicDetail != null
                              ? reviewDetails.eventBasicDetail.dateRange != null
                                  ? reviewDetails.eventBasicDetail.dateRange
                                  : ""
                              : "",
                          textDirection: prefix.TextDirection.ltr,
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: 14.0,
                              fontFamily: tr('currFontFamilyEnglishOnly')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 12.0),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(CommonIcons.time_half,
                          size: 15, color: Colors.black45),
                      Container(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 5.0, top: 4.0)
                                : EdgeInsets.only(right: 5.0, top: 4.0),
                        child: new Text(
                          reviewDetails.eventBasicDetail != null
                              ? reviewDetails.eventBasicDetail.timeRange != null
                                  ? reviewDetails.eventBasicDetail.timeRange
                                  : ""
                              : "",
                          textDirection: prefix.TextDirection.ltr,
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: 14.0,
                              fontFamily: tr('currFontFamilyEnglishOnly')),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Divider(
                color: ColorData.blackColor,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Column(
                children: reviewDetails.reviewEventDetailsViewDtos != null
                    ? reviewDetails.reviewEventDetailsViewDtos.length > 0
                        ? getList(reviewDetails.reviewEventDetailsViewDtos)
                        : getNoDataList()
                    : getNoDataList(),
              )),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getNoDataList() {
    return [
      Center(
          child: Container(
        child: Text(tr("noDataFound"),
            style: TextStyle(
              color: ColorData.primaryTextColor,
              fontFamily: tr("currFontFamily"),
            )),
      ))
    ];
  }

  getList(List<ReviewEventDetailsViewDtos> reviewEventDetailsViewDtos) {
    List<Widget> resultList = [];
    for (int i = 0; i < reviewEventDetailsViewDtos.length; i++) {
      resultList.add(Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  reviewEventDetailsViewDtos[i].userName != null
                      ? reviewEventDetailsViewDtos[i].userName
                      : "",
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: 14.0,
                      fontFamily: tr('currFontFamily')),
                ),
                Text(
                  reviewEventDetailsViewDtos[i].reviewDate != null
                      ? DateTimeUtils().dateToServerToDateFormat(
                          reviewEventDetailsViewDtos[i].reviewDate,
                          DateTimeUtils.ServerFormat,
                          DateTimeUtils.DD_MMM_YYYY_Format)
                      : "",
                  textDirection: prefix.TextDirection.ltr,
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: 14.0,
                      fontFamily: tr('currFontFamilyEnglishOnly')),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                children: <Widget>[
                  Text(
                    tr("txt_rating"),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: 14.0,
                        fontFamily: tr('currFontFamily')),
                  ),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 8.0)
                            : EdgeInsets.only(right: 8.0),
                    child: reviewEventDetailsViewDtos[i].ratingLogoUrl != null
                        ? Image.network(
                            reviewEventDetailsViewDtos[i].ratingLogoUrl,
                            height: 20.0,
                          )
                        : AssetImage(ImageData.slcLogImage),
                  ),
                  Padding(
                    padding:
                        Localizations.localeOf(context).languageCode == "en"
                            ? EdgeInsets.only(left: 8.0)
                            : EdgeInsets.only(right: 8.0),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 5.0, right: 5.0, top: 3.0, bottom: 3.0),
                            child: Text(
                              reviewEventDetailsViewDtos[i].rating != null
                                  ? reviewEventDetailsViewDtos[i].rating
                                  : "",
                              style: TextStyle(
                                color: ColorData.primaryTextColor,
                                fontFamily: tr("currFontFamilyEnglishOnly"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      reviewEventDetailsViewDtos[i].comments != null
                          ? reviewEventDetailsViewDtos[i].comments
                          : "",
                      maxLines: 3,
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontSize: 14.0,
                          fontFamily: tr('currFontFamily')),
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 20.0),
              child: reviewEventDetailsViewDtos.length - 1 == i
                  ? Container()
                  : Divider(
                      color: ColorData.blackColor,
                    ),
            ),
          ],
        ),
      ));
    }
    return resultList;
  }
}
