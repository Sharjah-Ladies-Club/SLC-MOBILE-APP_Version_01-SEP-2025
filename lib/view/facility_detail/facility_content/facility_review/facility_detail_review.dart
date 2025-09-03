import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/model/enquiry_response.dart';
import '../../../../utils/utils.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/constant.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:slc/customcomponentfields/expansiontile/groovenexpan.dart';

bool isExpanded = false;

// ignore: must_be_immutable
class FacilityDetailReview extends StatelessWidget {
  List<ReviewsResponse> reviews;
  String colorCode;
  int facilityId;

  FacilityDetailReview({this.reviews, this.colorCode, this.facilityId});

  @override
  Widget build(BuildContext context) {
    return Reviews(reviews, colorCode, facilityId);
  }
}

// ignore: must_be_immutable
class Reviews extends StatefulWidget {
  List<ReviewsResponse> reviews;
  String colorCode;
  int facilityId;
  AutoScrollController scrlController;
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int listIndex = -1;

  bool ismainExpanded = false;
  Key key = PageStorageKey("100000000000");
  Utils util = new Utils();

  Reviews(this.reviews, this.colorCode, this.facilityId);

  @override
  State<StatefulWidget> createState() {
    return ReviewsState();
  }
}

class ReviewsState extends State<Reviews> {
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    return getReviewScreen(widget.reviews);
  }

  Widget getReviewScreen(List<ReviewsResponse> reviews) {
    widget.scrlController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: widget.scrlController,
        key: widget.key,
        scrollDirection: Axis.vertical,
        itemCount: reviews.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) {
          // debugPrint("Image URL" + reviews[i].ratingLogoUrl);
          return _wrapScrollTag(
            index: i,
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation:
                      isExpanded && widget.selectedIndex == i ? 5.0 : 0.0,
                  child: GroovinExpansionTile(
                    initiallyExpanded: i == widget.listIndex ? true : false,
                    key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
                    btnIndex: i,
                    selectedIndex: widget.selectedIndex,
                    onTap: (isExpanded, btnIndex) {
                      updateSelectedIndex(btnIndex);
                    },
                    onExpansionChanged: (val) {
                      setState(() {
                        isExpanded = val;
                      });
                    },
                    defaultTrailingIconColor:
                        isExpanded && widget.selectedIndex == i
                            ? ColorData.toColor(widget.colorCode)
                            : Colors.grey,
                    title: PackageListHead.facilityExpandTileTextStyle(
                        context,
                        1.0,
                        reviews[i].userName,
                        ColorData.toColor(widget.colorCode),
                        isExpanded && widget.selectedIndex == i),
                    children: <Widget>[
                      Container(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10.0, left: 15, right: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: ColorData.colorBlue,
                                          ),
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                left: 8.0,
                                                right: 8.0,
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                tr("txt_rated"),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15.0,
                                                    fontFamily:
                                                        tr('currFontFamily')),
                                              ))),

                                      Container(
                                          height: 30,
                                          width: 30,
                                          decoration: BoxDecoration(
                                              color: ColorData.toColor(
                                                  widget.colorCode)),
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: (reviews[i].ratingLogoUrl.indexOf(
                                                        "VeryBadActive.png") >
                                                    -1
                                                ? Icon(Icons.sentiment_very_dissatisfied_outlined,
                                                    color: Colors.white
                                                        .withOpacity(0.7),
                                                    size: 24)
                                                : reviews[i].ratingLogoUrl.indexOf("BadActive.png") >
                                                        -1
                                                    ? Icon(Icons.sentiment_dissatisfied_outlined,
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        size: 24)
                                                    : reviews[i].ratingLogoUrl.indexOf("GoodActive.png") >
                                                            -1
                                                        ? Icon(Icons.sentiment_satisfied_outlined,
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.7),
                                                            size: 24)
                                                        : Icon(Icons.sentiment_very_satisfied_outlined,
                                                            color: Colors.white.withOpacity(0.7),
                                                            size: 24)),
                                            onPressed: () {},
                                          )),
                                      Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: ColorData.toColor(
                                              widget.colorCode),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              left: 5.0,
                                              right: 5.0,
                                              top: 3.0,
                                            ),
                                            child: Text(
                                              reviews[i].rating != null
                                                  ? reviews[i].rating
                                                  : "",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: tr(
                                                    "currFontFamilyEnglishOnly"),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // ),
                                      // )
                                    ]),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateTimeUtils().dateToStringFormat(
                                            DateTimeUtils().stringToDate(
                                                reviews[i]
                                                    .reviewDate
                                                    .substring(0, 10),
                                                DateTimeUtils
                                                    .YYYY_MM_DD_Format),
                                            DateTimeUtils.DD_MM_YYYY_Format),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor,
                                            fontSize: 14.0,
                                            fontFamily: tr('currFontFamily')),
                                      )
                                    ]),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  top: 10.0, left: 15, right: 15, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    reviews[i].comments != null
                                        ? reviews[i].comments
                                        : "",
                                    maxLines: 3,
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor,
                                        fontSize: 14.0,
                                        fontFamily: tr('currFontFamily')),
                                  ),
                                ],
                              ))
                        ],
                      )
                          /*],
                      )*/
                          /*        }),
                        ),*/
                          ),
                    ],
                  ),
                ),
                i == reviews.length - 1 ||
                        isExpanded == true && i == widget.selectedIndex
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Divider(),
                      )
              ],
            ),
          );
        },
      ),
    );
  }

  void updateSelectedIndex(btnIndex) {
    setState(() {
      widget.selectedIndex = btnIndex;
      isExpanded = false;
    });
  }

  updateHeadSelectedIndex(btnHeadIndex) {
    setState(() {
      widget.selectedHeadIndex = btnHeadIndex;
      widget.ismainExpanded = false;
    });
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: widget.scrlController,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
  EnquiryDetailResponse getEnquiry(String hallName) {
    EnquiryDetailResponse request = new EnquiryDetailResponse();
    request.facilityId = widget.facilityId;
    request.facilityItemId = 0;
    request.firstName = SPUtil.getString(Constants.USER_FIRSTNAME);
    request.lastName = SPUtil.getString(Constants.USER_LASTNAME);
    request.enquiryStatusId = 1;
    request.supportDocuments = [];
    request.contacts = [];
    final DateTime now = DateTime.now();
    final String formatted = DateFormat('dd-MM-yyyy', 'en_US').format(now);
    request.DOB = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(SPUtil.getString(Constants.USER_DOB),
            DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);

    request.enquiryDate = DateTimeUtils().dateToStringFormat(
        DateTimeUtils().stringToDate(
            formatted.toString(), DateTimeUtils.DD_MM_YYYY_Format),
        DateTimeUtils.dobFormat);
    request.nationalityId = SPUtil.getInt(Constants.USER_NATIONALITYID);
    request.preferedTime = "";
    request.languages = "";
    request.emiratesID = "";
    request.address = "";
    request.genderId = SPUtil.getInt(Constants.USER_GENDERID);
    request.comments = "New Hall Enquiry - " + hallName;
    request.isActive = true;
    request.enquiryTypeId = 1;
    request.countryId = SPUtil.getInt(Constants.USER_COUNTRYID);
    request.facilityItemName = "";
    request.faclitiyItemDescription = "";
    request.price = 0;
    request.vatPercentage = 0;
    request.facilityImageName = "";
    request.facilityImageUrl = "";
    request.enquiryDetailId = 0;
    request.userID = SPUtil.getInt(Constants.USERID);
    return request;
  }
}
