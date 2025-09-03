import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide NestedScrollView;
// import 'package:flutter_html_textview_render/html_text_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:slc/common/first_letter_capitalized.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/customcomponentfields/network_cached_image/custom_cached_image.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/notification_list_response.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/booleans.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/imgutils.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/view/dashboard/dashboard.dart';
import 'package:slc/view/event_details/event_details.dart';
import 'package:slc/view/event_specific_view/events_specific_review.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/view/web_view/notification_detail_webview.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/view/profile/profile_new.dart';

import 'notification.dart';

class NotificationDetail extends StatefulWidget {
  final NotificationListResponse notificationListResponse;

  NotificationDetail({this.notificationListResponse});

  @override
  _NotificationDetailState createState() => _NotificationDetailState();
}

class _NotificationDetailState extends State<NotificationDetail>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Constants.isNotFromNotificationFamily = true;
    Booleans.isChecked = false;
    Booleans.condition = true;
//    Constants.isFromNotificationFamily
    Constants.isFromNotificationFamily = 2;
    super.initState();
  }

  @override
  void dispose() {
// Booleans.condition = false;
    Booleans.isChecked = true;
    super.dispose();
  }

  double carouselHeight;
  double contentHeight;

  Future<bool> _onWillPop() async {
    Constants.isNotFromNotificationFamily = true;
    Constants.isFromNotificationFamily = 1;
    Navigator.pop(context, true);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => NotificationList()));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = AppBar().preferredSize.height;
    double screenHeight = (MediaQuery.of(context).size.height);
    double remainingHeight =
        screenHeight - (appBarHeight + MediaQuery.of(context).padding.top);
    carouselHeight = remainingHeight * (45.0 / 100.0);
    contentHeight = remainingHeight * (55.0 / 100.0);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(200.0),
            child: CustomAppBar(
              titleType: Constants.isPageFromNotificationList,
              title: Capitalized.capitalizeFirstLetter(
                  widget.notificationListResponse.title),
            ),
          ),
          body: pageDesign(context),
        ),
      ),
    );
  }

  eventReview(int eventId) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          Constants.isViewMore = true;
          SPUtil.remove("FeedBackSelectedList");
          return EventSpecificReview(eventId);
        },
      ),
    );
  }

  Widget pageDesign(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: carouselHeight,
          child: mainUI(
              context,
              carouselHeight,
              widget.notificationListResponse.imageUrl,
              widget.notificationListResponse.title),
        ),
        Container(
          color: ColorData.whiteColor,
          height: contentHeight,
          child: facilityContent(widget.notificationListResponse.message,
              widget.notificationListResponse.title),
        )
      ],
    );
  }

  Widget facilityContent(descriptionText, titleText) {
    return Scaffold(
      backgroundColor: ColorData.whiteColor,
      bottomNavigationBar: Visibility(
        visible: widget.notificationListResponse.navigationTypeId !=
                    Integer.NoNavigation &&
                widget.notificationListResponse.navigationTypeId !=
                    Integer.NoNavigationZeroIncluded
            ? true
            : false,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin:
              EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0, bottom: 20.0),
          child: new ElevatedButton(
            // padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).primaryColor,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                )))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.notificationListResponse.viewMoreButtonName != null
                      ? Capitalized.capitalizeFirstLetter(
                          widget.notificationListResponse.viewMoreButtonName)
                      : "",
                  style: NotificationDetailPageStyle
                      .notificationDetailViewMoreBtnTextStyle(context),
                ),
                Localizations.localeOf(context).languageCode == "en"
                    ? Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Image.asset(
                          'assets/images/leftArrow.png',
                          height: 14,
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Arrow.reverse_arrow,
                          size: 20,
                        ),
                      ),
              ],
            ),
            // shape: new RoundedRectangleBorder(
            //   borderRadius: new BorderRadius.circular(8),
            // ),
            onPressed: () {
              setState(() {
                Constants.isFromNotificationFamily = 0;
                Constants.isNotFromNotificationFamily = false;
              });
              if (widget.notificationListResponse.navigationTypeId ==
                  Integer.OutSideNavigation) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationWebView(
                            widget.notificationListResponse.title,
                            widget.notificationListResponse.webNavigationUrl)));
              } else if (widget.notificationListResponse.navigationTypeId ==
                  Integer.InsideNavigation) {
                if (widget.notificationListResponse.applicationModuleId ==
                    Integer.FacilityDetail) {
                  Navigator.push(context, new MaterialPageRoute(
                    builder: (context) {
                      Constants.isViewMore = true;
                      return FacilityDetailsPage(
                        facilityId:
                            widget.notificationListResponse.referenceId > 0
                                ? widget.notificationListResponse.referenceId
                                : 1,
                      );
                    },
                  ));
                } else if (widget
                        .notificationListResponse.applicationModuleId ==
                    Integer.FacilitySurvey) {
                  SPUtil.putInt(Constants.SELECTED_FACILITY_ID,
                      widget.notificationListResponse.referenceId);
                  Constants.isViewMore = true;
                  Get.offAll(Dashboard(
                    selectedIndex: 2,
                  ));
                } else if (widget
                        .notificationListResponse.applicationModuleId ==
                    Integer.EventDetail) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        Constants.isViewMore = true;
                        return EventDetails(
                          eventId:
                              widget.notificationListResponse.referenceId > 0
                                  ? widget.notificationListResponse.referenceId
                                  : 1,
                        );
                      },
                    ),
                  );
                } else if (widget
                        .notificationListResponse.applicationModuleId ==
                    Integer.EventFeedback) {
                  eventReview(widget.notificationListResponse.referenceId > 0
                      ? widget.notificationListResponse.referenceId
                      : 0);
                } else if (widget
                        .notificationListResponse.applicationModuleId ==
                    Integer.MemberProfile) {
                  Constants.eventsCurrentSelectedChoiseChip = 0;

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        //return Profile(Strings.ProfileInitialState);
                        return ProfileNew(Strings.ProfileInitialState);
                      },
                    ),
                  );
                }
              }
            },
            // textColor: Colors.white,
            // color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            // debugPrint(" desc " + descriptionText);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Commented because of uat feedbacks.
//                Padding(
//                  padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
//                  child: Text(
//                    Capitalized.capitalizeFirstLetter(titleText),
//                    overflow: TextOverflow.ellipsis,
//                    maxLines: 2,
//                    style: NotificationDetailPageStyle
//                        .notificationDetailNotificationTitleTextStyle(context),
//                  ),
//                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 5.0),
                    child: getHtml(
                        Capitalized.capitalizeFirstLetter(descriptionText))),
              ],
            );
          }),
    );
//      ),
//    );
  }

  Widget mainUI(BuildContext context, carousalHeight, imgUrl, titleText) {
    return SizedBox(
      height: carousalHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          carouselUi(context, imgUrl),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 30.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: ColorData.whiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  boxShadow: [BoxShadow(color: Colors.white12, blurRadius: 2)]),
            ),
          ),
        ],
      ),
    );
  }

  Widget getHtml(String description) {
    return Html(
      //customFont: tr('currFontFamilyEnglishOnly'),
      //anchorColor: ColorData.primaryTextColor,
      style: {
        "body": Style(
            padding: EdgeInsets.all(0),
            margin: Margins.all(0),
            fontSize: FontSize(Styles.textSizeSmall),
            color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
            fontFamily: tr('currFontFamily')),
        "p": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
        ),
        "span": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
          fontWeight: FontWeight.w400,
          // fontSize: FontSize(Styles.reviewTextSize),
          // // color: ColorData.cardTimeAndDateColor,
          // fontFamily: tr('currFontFamilyEnglishOnly'),
        ),
        "h6": Style(
            // fontFamily: tr('currFontFamilyEnglishOnly'),
            // fontWeight: FontWeight.bold,
            // fontSize: FontSize(Styles.reviewTextSize),
            // // color: ColorData.cardTimeAndDateColor,
            padding: EdgeInsets.all(0),
            margin: Margins.all(0)),
      },
      data: description != null
          ? '<html><body>' + description + '</body></html>'
          : tr('noDataFound'),
    );
  }

  Widget carouselUi(BuildContext context, imgUrl) {
    if (imgUrl != null && imgUrl != "") {
      return Container(
        color: ColorData.backgroundColor,
        child: CustomCachedImage(imgUrl),
      );
    } else {
      return NotificationAppBarImage();
    }
  }
}
