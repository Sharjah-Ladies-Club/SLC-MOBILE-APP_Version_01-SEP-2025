import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/facility_detail/facility_content/facility_hall/web_page_360.dart';

// import 'package:slc/view/partyhall/new_hall_booking.dart';

import 'facility_content.dart';

bool isExpanded = false;

// ignore: must_be_immutable
class FacilityDetailHall extends StatelessWidget {
  List<ImageVRDto> imageVR;
  String colorCode;
  int facilityId;
  List<CateringType> cateringTypeList;
  List<KunoozBookingListDto> partyHallEnquiryList;
  FacilityDetailHall(
      {this.imageVR,
      this.colorCode,
      this.facilityId,
      this.cateringTypeList,
      this.partyHallEnquiryList});

  @override
  Widget build(BuildContext context) {
    return Hall(
        imageVR, colorCode, facilityId, cateringTypeList, partyHallEnquiryList);
  }
}

// ignore: must_be_immutable
class Hall extends StatefulWidget {
  List<ImageVRDto> imageVR;
  String colorCode;
  int facilityId;
  AutoScrollController scrlController;
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int listIndex = -1;
  List<CateringType> cateringTypeList;
  List<KunoozBookingListDto> partyHallEnquiryList;
  bool ismainExpanded = false;
  Key key = PageStorageKey("100000000000");
  Utils util = new Utils();

  Hall(this.imageVR, this.colorCode, this.facilityId, this.cateringTypeList,
      this.partyHallEnquiryList);

  @override
  State<StatefulWidget> createState() {
    return HallState();
  }
}

class HallState extends State<Hall> {
  Utils util = Utils();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  @override
  Widget build(BuildContext context) {
    screenHeight = (MediaQuery.of(context).size.height);
    screenWidth = MediaQuery.of(context).size.width;
    return getHallScreen(widget.imageVR);
  }

  Widget getHallScreen1(List<ImageVRDto> halls) {
    return SingleChildScrollView(
        child: ListView.builder(
            key: PageStorageKey("Halls_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: halls.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                height: MediaQuery.of(context).size.height * .12,
                width: MediaQuery.of(context).size.width * .98,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  border: Border.all(color: Colors.grey[200]),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    // Padding(
                    //     padding: EdgeInsets.only(top: 10),
                    //     child: Divider(color: Colors.grey[900])),
                    Row(children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10, left: 10),
                        child: Text(halls[j].imageName,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.packageExpandTextSiz,
                                fontFamily: tr('currFontFamily'))),
                      )
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 0, right: 20),
                          child: ButtonTheme(
                            height: MediaQuery.of(context).size.height / 23,
                            minWidth: MediaQuery.of(context).size.width / 4,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          ColorData.grey300),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                    Radius.circular(4.0),
                                  )))),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(4),
                              // ),
                              onPressed: () async {
                                EnquiryDetailResponse enquiryDetailResponse =
                                    getEnquiry(halls[j].imageName);
                                Meta m = await (new FacilityDetailRepository())
                                    .saveEnquiryDetails(
                                        enquiryDetailResponse, false);
                                if (m.statusCode == 200) {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("enquiry"),
                                      "Posted Successfully",
                                      context);
                                } else {
                                  util.customGetSnackBarWithOutActionButton(
                                      tr("enquiry"), m.statusMsg, context);
                                }
                              },
                              // color: Colors.grey[300],
                              // textColor: Colors.white,
                              child: Text(tr("enquiry"),
                                  style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.primaryTextColor,
                                    fontFamily: tr('currFontFamily'),
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 0, right: 20),
                          child: ButtonTheme(
                            height: MediaQuery.of(context).size.height / 23,
                            minWidth:
                                MediaQuery.of(context).copyWith().size.width /
                                    4,
                            child: ElevatedButton(
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
                                    Radius.circular(4.0),
                                  )))),
                              // shape: RoundedRectangleBorder(
                              //   borderRadius: BorderRadius.circular(4),
                              // ),
                              onPressed: () async {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ThreeSixtyWebviewPage(
                                              url: halls[j].imageUrl,
                                              title: halls[j].imageName)),
                                );
                              },
                              // color: ColorData.toColor(widget.colorCode),
                              // textColor: Colors.white,
                              child: Text(tr("view_360"),
                                  style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.whiteColor,
                                    fontFamily: tr('currFontFamily'),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }

  Widget getHallScreen(List<ImageVRDto> halls) {
    widget.scrlController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    return Column(children: [
      Container(
        color: Colors.white,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(tr('select_your_booking'),
                style: TextStyle(
                    fontSize: Styles.textSizeSmall,
                    color: Colors.black,
                    fontFamily: tr("currFontFamily"))),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          ColorData.toColor(widget.colorCode)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      )))),
                  child: new Text(
                    tr('hall_booking'),
                    style: TextStyle(
                        fontSize: Styles.textSizeSmall,
                        color: Colors.white,
                        fontFamily: tr("currFontFamily")),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => NewHallBooking(
                    //               facilityId: 6,
                    //               screenType: Constants.Screen_Add_Enquiry,
                    //               hallList: widget.imageVR,
                    //               bookingMode: 1,
                    //               cateringTypeList: widget.cateringTypeList,
                    //               colorCode: widget.colorCode,
                    //               partyHallEnquiryId: 0,
                    //             )),
                    //   );
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.grey[200]),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      )))),
                  child: new Text(
                    tr('catering_1'),
                    style: TextStyle(
                        fontSize: Styles.textSizeSmall,
                        color: Colors.black,
                        fontFamily: tr("currFontFamily")),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => NewHallBooking(
                    //             facilityId: 6,
                    //             screenType: Constants.Screen_Add_Enquiry,
                    //             hallList: widget.imageVR,
                    //             bookingMode: 2,
                    //             cateringTypeList: widget.cateringTypeList,
                    //             colorCode: widget.colorCode,
                    //             partyHallEnquiryId: 0,
                    //           )),
                    // );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        height: screenHeight * 0.30,
        width: screenWidth,
        color: Colors.white,
        margin: EdgeInsets.only(left: 20, right: 20),
        child: ListView.separated(
            itemCount: widget.partyHallEnquiryList.length,
            itemBuilder: (BuildContext context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 6, right: 6, top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.partyHallEnquiryList[index].bookingTypeName,
                        style: TextStyle(
                            fontSize: Styles.textSizeSmall,
                            color: Colors.black,
                            fontFamily: tr("currFontFamily"))),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(tr('book_date_time'),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: Colors.black,
                                  fontFamily: tr("currFontFamily"))),
                          Text(
                              DateTimeUtils().dateToServerToDateFormat(
                                  widget
                                      .partyHallEnquiryList[index].bookingFrom,
                                  DateTimeUtils.ServerFormat,
                                  DateTimeUtils.DD_MM_YYYY_HH_MM_Format),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: Colors.black,
                                  fontFamily: tr("currFontFamily"))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "AED " +
                                  widget
                                      .partyHallEnquiryList[index].payableAmount
                                      .toStringAsFixed(2),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: Colors.black,
                                  fontFamily: tr("currFontFamily"))),
                          ElevatedButton(
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
                                  Radius.circular(5.0),
                                )))),
                            child: new Text(
                              tr('view'),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: Colors.white,
                                  fontFamily: tr("currFontFamily")),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KunoozBookingDetail(
                                            bookingId: widget
                                                .partyHallEnquiryList[index]
                                                .bookingId,
                                            colorCode: widget.colorCode,
                                          )));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider()),
      ),
    ]);
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
    request.totalClass = 0;
    request.balanceClass = 0;
    request.consumedClass = 0;
    request.contacts = [];
    final String formatted =
        DateFormat('dd-MM-yyyy', 'en_US').format(DateTime.now());
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
    request.enquiryProcessId = 0;
    request.rate = 0;
    request.userID = SPUtil.getInt(Constants.USERID);
    // request.erpCustomerId = SPUtil.getInt(Constants.USER_CUSTOMERID);
    return request;
  }
}
