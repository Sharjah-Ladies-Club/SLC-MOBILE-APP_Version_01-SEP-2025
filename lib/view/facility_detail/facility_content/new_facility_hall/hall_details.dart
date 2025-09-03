import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/colors.dart';
import '../../../../model/facility_detail_response.dart';
import '../../../../model/facility_item.dart';
import '../../../../model/knooz_response_dto.dart';
import '../../../../theme/styles.dart';
import '../../../../utils/datetime_utils.dart';
import '../../../../utils/utils.dart';
import '../facility_hall/facility_content.dart';
import '../facility_hall/web_page_360.dart';
import 'bloc/new_facility_hall_bloc.dart';
import 'bloc/new_facility_hall_event.dart';
import 'bloc/new_facility_hall_state.dart';
import 'hall_booking.dart';

class HallDetailView extends StatelessWidget {
  final List<ImageVRDto> imageVR;
  final String colorCode;
  final int facilityId;
  final List<CateringType> cateringTypeList;
  final List<KunoozBookingListDto> partyHallEnquiryList;
  const HallDetailView(
      {this.imageVR,
      this.colorCode,
      this.facilityId,
      this.cateringTypeList,
      this.partyHallEnquiryList});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewFacilityHallBloc>(
      create: (context) => NewFacilityHallBloc(partyHallBloc: null)
        ..add(new NewFacilityHallTermsData(
            facilityId: 6, facilityItemId: 0, partyHallDetailId: 0)),
      child: HallDetails(
          imageVR: imageVR,
          cateringTypeList: cateringTypeList,
          partyHallEnquiryList: partyHallEnquiryList,
          colorCode: colorCode,
          facilityId: facilityId),
    );
  }
}

class HallDetails extends StatefulWidget {
  final List<ImageVRDto> imageVR;
  final String colorCode;
  final int facilityId;
  final List<CateringType> cateringTypeList;
  final List<KunoozBookingListDto> partyHallEnquiryList;
  const HallDetails(
      {this.imageVR,
      this.colorCode,
      this.facilityId,
      this.cateringTypeList,
      this.partyHallEnquiryList});

  @override
  State<HallDetails> createState() => _HallDetailsState();
}

class _HallDetailsState extends State<HallDetails> {
  Utils util = Utils();
  List<FacilityItem> hallList = [];

  bool isHall = true;
  bool load = false;

  int selectedIndex = -1;
  int selectedHeadIndex = -1;

  List<KunoozBookingListDto> cateringList = [];
  List<KunoozBookingListDto> enquiryHallList = [];
  bool isExpanded = false;
  bool isMainExpanded = false;

  ScrollController scrollController = ScrollController();
  int selected;

  @override
  Widget build(BuildContext context) {
    double sHeight = MediaQuery.of(context).size.height;
    double sWidth = MediaQuery.of(context).size.width;
    return BlocListener<NewFacilityHallBloc, NewFacilityHallState>(
      listener: (context, state) async {
        if (state is NewFacilityHallTermsState) {
          setState(() {
            hallList = state.orderItems.retailCategoryItems
                    .where((x) => x.categoryId == 8)
                    .first
                    .facilityItems ??
                [];
            enquiryHallList = widget.partyHallEnquiryList
                .where((x) => x.bookingTypeId == 1)
                .toList();
            cateringList = widget.partyHallEnquiryList
                .where((x) => x.bookingTypeId == 2 || x.bookingTypeId == 3)
                .toList();
            load = true;
          });
        } else if (state is OnFailure) {
          setState(() {
            load = true;
          });
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        }
      },
      child: load
          ? SizedBox(
              width: sWidth,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selected = -1;
                              isHall = true;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            minimumSize: Size(sWidth * 0.3, sHeight * 0.04),
                            backgroundColor: isHall
                                ? ColorData.toColor(widget.colorCode)
                                : Colors.grey[300],
                            side: isHall
                                ? BorderSide(color: Colors.transparent)
                                : BorderSide(color: Colors.grey[400]),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )),
                          ),
                          child: new Text(
                            tr("hall_booking"),
                            style: TextStyle(
                                fontSize: Styles.textSiz,
                                color: isHall ? Colors.white : Colors.black,
                                fontFamily: tr("currFontFamily")),
                          ),
                        ),
                        Padding(
                          padding:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? EdgeInsets.only(left: 8)
                                  : EdgeInsets.only(right: 8),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selected = -1;
                                isHall = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              minimumSize: Size(sWidth * 0.3, sHeight * 0.04),
                              backgroundColor: isHall
                                  ? Colors.grey[300]
                                  : ColorData.toColor(widget.colorCode),
                              side: isHall
                                  ? BorderSide(color: Colors.grey[400])
                                  : BorderSide(color: Colors.transparent),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              )),
                            ),
                            child: new Text(
                              tr("catering_1"),
                              style: TextStyle(
                                  fontSize: Styles.textSiz,
                                  color: isHall ? Colors.black : Colors.white,
                                  fontFamily: tr("currFontFamily")),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: sHeight * 0.3,
                    width: sWidth,
                    color: Colors.white,
                    child: isHall
                        ? hallList != null && hallList.isNotEmpty
                            ? ListView.separated(
                                key: Key(
                                    'builder ${selected.toString()}'), //attention
                                itemCount: hallList.length,
                                padding: EdgeInsets.only(bottom: 4),
                                itemBuilder: (BuildContext context, i) {
                                  return ExpansionTile(
                                      collapsedIconColor: Colors.grey,
                                      iconColor:
                                          ColorData.toColor(widget.colorCode),
                                      key: Key(i.toString()),
                                      initiallyExpanded: i == selected,
                                      tilePadding: EdgeInsets.only(
                                          left: 8, right: 8, bottom: 4),
                                      childrenPadding: EdgeInsets.only(
                                          left: 8, right: 8, bottom: 4),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  "assets/images/hall.png",
                                                  width: 30),
                                              Container(
                                                margin: Localizations.localeOf(
                                                                context)
                                                            .languageCode ==
                                                        "en"
                                                    ? EdgeInsets.only(left: 2)
                                                    : EdgeInsets.only(right: 2),
                                                width: sWidth * 0.36,
                                                child: PackageListHead
                                                    .facilityExpandTileTextStyle(
                                                        context,
                                                        1.0,
                                                        Localizations.localeOf(
                                                                        context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? hallList[i]
                                                                .facilityItemName
                                                            : hallList[i]
                                                                .facilityItemNameArabic,
                                                        ColorData.toColor(
                                                            widget.colorCode),
                                                        isExpanded &&
                                                            selectedIndex == i),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Visibility(
                                                visible: isHall,
                                                child: OutlinedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ThreeSixtyWebviewPage(
                                                                  url: widget
                                                                      .imageVR[
                                                                          i]
                                                                      .imageUrl,
                                                                  title: widget
                                                                      .imageVR[
                                                                          i]
                                                                      .imageName)),
                                                    );
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding: EdgeInsets.all(0),
                                                    backgroundColor:
                                                        ColorData.toColor(
                                                            widget.colorCode),
                                                  ),
                                                  child: Text(
                                                    "360°",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Styles.textSiz,
                                                        color: Colors.white,
                                                        fontFamily: tr(
                                                            "currFontFamily")),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: Localizations.localeOf(
                                                                context)
                                                            .languageCode ==
                                                        "en"
                                                    ? EdgeInsets.only(left: 8)
                                                    : EdgeInsets.only(right: 8),
                                                child: OutlinedButton(
                                                  onPressed: () async {
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                HallBookingView(
                                                                  facilityItemId:
                                                                      hallList[
                                                                              i]
                                                                          .facilityItemId,
                                                                  colorCode: widget
                                                                      .colorCode,
                                                                  isHall:
                                                                      isHall,
                                                                  bookingMode:
                                                                      isHall
                                                                          ? 1
                                                                          : 2,
                                                                  cateringTypeList:
                                                                      widget
                                                                          .cateringTypeList,
                                                                )));
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      maximumSize:
                                                          Size(100, 60),
                                                      backgroundColor:
                                                          Colors.white,
                                                      side: BorderSide(
                                                          color: ColorData
                                                              .toColor(widget
                                                                  .colorCode))),
                                                  child: Text(
                                                    tr("enquiry"),
                                                    style: TextStyle(
                                                        fontSize:
                                                            Styles.textSiz,
                                                        color: Colors.black,
                                                        fontFamily: tr(
                                                            "currFontFamily")),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      children: hallDetailList(
                                          hallList[i].facilityItemId),
                                      onExpansionChanged: ((newState) {
                                        if (newState)
                                          setState(() {
                                            selected = i;
                                          });
                                        else
                                          setState(() {
                                            selected = -1;
                                          });
                                      }));
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return Divider(height: 6);
                                },
                              )
                            : Center(
                                child: Text(tr('no_book'),
                                    style: TextStyle(
                                        color: ColorData.primaryTextColor,
                                        fontSize: Styles.loginBtnFontSize,
                                        fontFamily: tr('currFontFamily'))),
                              )
                        : ListView.separated(
                            key: Key(
                                'builder ${selected.toString()}'), //attention
                            itemCount: 2,
                            itemBuilder: (BuildContext context, i) {
                              return ExpansionTile(
                                  collapsedIconColor: Colors.grey,
                                  iconColor:
                                      ColorData.toColor(widget.colorCode),
                                  key: Key(i.toString()),
                                  initiallyExpanded: i == selected,
                                  tilePadding: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 4),
                                  childrenPadding: EdgeInsets.only(
                                      left: 8, right: 8, bottom: 4),
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              i == 0
                                                  ? "assets/images/catering_service.png"
                                                  : "assets/images/delivery_pickup.png",
                                              width: 30),
                                          Container(
                                            margin:
                                                Localizations.localeOf(context)
                                                            .languageCode ==
                                                        "en"
                                                    ? EdgeInsets.only(left: 2)
                                                    : EdgeInsets.only(right: 2),
                                            width: sWidth * 0.5,
                                            child: PackageListHead
                                                .facilityExpandTileTextStyle(
                                                    context,
                                                    1.0,
                                                    i == 0
                                                        ? tr(
                                                            'catering_services')
                                                        : tr('delivery_pickup'),
                                                    ColorData.toColor(
                                                        widget.colorCode),
                                                    isExpanded &&
                                                        selectedIndex == i),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(left: 12)
                                            : EdgeInsets.only(right: 12),
                                        child: OutlinedButton(
                                          onPressed: () async {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HallBookingView(
                                                          facilityItemId:
                                                              hallList[i]
                                                                  .facilityItemId,
                                                          colorCode:
                                                              widget.colorCode,
                                                          isHall: isHall,
                                                          bookingMode:
                                                              i == 0 ? 2 : 3,
                                                          cateringTypeList: widget
                                                              .cateringTypeList,
                                                          isPickup: i == 0
                                                              ? false
                                                              : true,
                                                        )));
                                          },
                                          style: OutlinedButton.styleFrom(
                                              padding: EdgeInsets.all(0),
                                              maximumSize: Size(100, 60),
                                              backgroundColor: Colors.white,
                                              side: BorderSide(
                                                  color: ColorData.toColor(
                                                      widget.colorCode))),
                                          child: Text(
                                            tr("enquiry"),
                                            style: TextStyle(
                                                fontSize: Styles.textSiz,
                                                color: Colors.black,
                                                fontFamily:
                                                    tr("currFontFamily")),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  children: cateringList.isNotEmpty
                                      ? cateringDetailList(i)
                                      : [
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, bottom: 8),
                                              child: Text(tr('no_book'),
                                                  style: TextStyle(
                                                      color: ColorData
                                                          .primaryTextColor,
                                                      fontSize: Styles
                                                          .loginBtnFontSize,
                                                      fontFamily: tr(
                                                          'currFontFamily'))),
                                            ),
                                          )
                                        ],
                                  onExpansionChanged: ((newState) {
                                    if (newState)
                                      setState(() {
                                        selected = i;
                                      });
                                    else
                                      setState(() {
                                        selected = -1;
                                      });
                                  }));
                            },
                            separatorBuilder: (BuildContext context, index) {
                              return Divider(height: 6);
                            },
                          ),
                  ),
                ],
              ),
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  hallDetailList(int facilityItemId) {
    List<Widget> columnContent = [];
    for (int i = 0; i < enquiryHallList.length; i++) {
      if (enquiryHallList[i].hallId == facilityItemId) {
        columnContent.add(Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.only(left: 12, right: 12, top: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(enquiryHallList[i].bookingTypeName,
                //     style: TextStyle(
                //         fontSize: Styles.textSizeSmall,
                //         color: Colors.black,
                //         fontFamily: tr("currFontFamily"))),
                Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(tr('booking_id'),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.black,
                              fontFamily: tr("currFontFamily"))),
                      Text(
                          enquiryHallList[i].amendmentId == 0
                              ? enquiryHallList[i].bookingId.toString()
                              : enquiryHallList[i].bookingId.toString() +
                                  "." +
                                  enquiryHallList[i].amendmentId.toString(),
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
                      Text(tr('book_date_time'),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.black,
                              fontFamily: tr("currFontFamily"))),
                      Text(
                          DateTimeUtils().dateToServerToDateFormat(
                              enquiryHallList[i].bookingFrom,
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
                              enquiryHallList[i]
                                  .payableAmount
                                  .toStringAsFixed(2),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.black,
                              fontFamily: tr("currFontFamily"))),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => KunoozBookingDetail(
                                          bookingId:
                                              enquiryHallList[i].bookingId,
                                          colorCode: widget.colorCode,
                                        )));
                          },
                          icon: Icon(
                            Icons.remove_red_eye_outlined,
                            color: ColorData.toColor(widget.colorCode),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      }
    }
    if (columnContent.isEmpty) {
      columnContent.add(Center(
        child: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8),
          child: Text(tr('no_book'),
              style: TextStyle(
                  color: ColorData.primaryTextColor,
                  fontSize: Styles.loginBtnFontSize,
                  fontFamily: tr('currFontFamily'))),
        ),
      ));
    }
    return columnContent;
  }

  cateringDetailList(int cateringType) {
    List<Widget> columnContent = [];
    for (int i = 0; i < cateringList.length; i++) {
      if (cateringType == 0 && cateringList[i].bookingTypeId == 2) {
        columnContent.add(
          Card(
            elevation: 4,
            margin: EdgeInsets.only(left: 6, right: 6, bottom: 14),
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                cateringList[i].bookingFrom,
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
                                cateringList[i]
                                    .payableAmount
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: Colors.black,
                                fontFamily: tr("currFontFamily"))),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KunoozBookingDetail(
                                            bookingId:
                                                cateringList[i].bookingId,
                                            colorCode: widget.colorCode,
                                          )));
                            },
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: ColorData.toColor(widget.colorCode),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else if (cateringType == 1 && cateringList[i].bookingTypeId == 3) {
        columnContent.add(
          Card(
            elevation: 4,
            margin: EdgeInsets.only(left: 6, right: 6, bottom: 14),
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12, top: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(cateringList[i].bookingTypeName,
                  //     style: TextStyle(
                  //         fontSize: Styles.textSizeSmall,
                  //         color: Colors.black,
                  //         fontFamily: tr("currFontFamily"))),
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
                                cateringList[i].bookingFrom,
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
                                cateringList[i]
                                    .payableAmount
                                    .toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: Colors.black,
                                fontFamily: tr("currFontFamily"))),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KunoozBookingDetail(
                                            bookingId:
                                                cateringList[i].bookingId,
                                            colorCode: widget.colorCode,
                                          )));
                            },
                            icon: Icon(
                              Icons.remove_red_eye_outlined,
                              color: ColorData.toColor(widget.colorCode),
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
    return columnContent;
  }

  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }
}
