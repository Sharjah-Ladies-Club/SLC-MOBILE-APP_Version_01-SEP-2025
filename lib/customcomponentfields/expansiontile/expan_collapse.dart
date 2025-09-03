import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/partyhall_response.dart';
// import 'package:slc/view/partyhall/new_partyhall.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/repo/generic_repo.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/enquiry/enquiry_payment.dart';
import 'package:slc/view/enquiry/new_enquiry.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';

import 'grooven_non_collapse_tile.dart';
import 'groovenexpan.dart';

bool isExpanded = false;

// ignore: must_be_immutable
class CustomExpandTile extends StatefulWidget {
  List<FacilityDetailItem> facilityItemList;
  int facilityId;
  String colorCode;
  int listIndex = -1;

  CustomExpandTile(
      {Key key,
      this.facilityItemList,
      this.colorCode,
      this.listIndex,
      this.facilityId})
      : super(key: key);

  @override
  _CustomExpandTileState createState() => _CustomExpandTileState();
}

class _CustomExpandTileState extends State<CustomExpandTile> {
  int selectedIndex = -1;
  int selectedHeadIndex = -1;

  bool ismainExpanded = false;
  Key key;
  int number = Random().nextInt(2000000000);
  HashMap<int, List<EnquiryDetailResponse>> enquiryList =
      new HashMap<int, List<EnquiryDetailResponse>>();
  HashMap<int, List<PartyHallResponse>> partyHallEnquiryList =
      new HashMap<int, List<PartyHallResponse>>();
  AutoScrollController scrlController;
  Utils util = new Utils();

  @override
  void initState() {
    // TODO: implement initState
    scrlController = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.vertical);
    selectedIndex = widget.listIndex;
    isExpanded = true;
    scrollPositionIndex();
    super.initState();
  }

  Future scrollPositionIndex() async {
    await scrlController.scrollToIndex(widget.listIndex,
        preferPosition: AutoScrollPosition.begin);
    scrlController.highlight(widget.listIndex);
  }

  @override
  Widget build(BuildContext context) {
    key = PageStorageKey(number.toString());
    return Material(child: getView());
  }

  Widget getView() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        controller: scrlController,
        key: key,
        scrollDirection: Axis.vertical,
        itemCount: widget.facilityItemList.length,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, i) {
          return _wrapScrollTag(
            index: i,
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  elevation: isExpanded && selectedIndex == i ? 5.0 : 0.0,
                  child: GroovinExpansionTile(
                    initiallyExpanded: i == widget.listIndex ? true : false,
                    key: PageStorageKey(i.toString() + "AutoCloseExpansion"),
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
                    defaultTrailingIconColor: isExpanded && selectedIndex == i
                        ? ColorData.toColor(widget.colorCode)
                        : Colors.grey,
                    title: PackageListHead.facilityExpandTileTextStyle(
                        context,
                        1.0,
                        widget.facilityItemList[i].facilityItemGroup.trim(),
                        ColorData.toColor(widget.colorCode),
                        isExpanded && selectedIndex == i),
                    children: <Widget>[
                      Container(
                        child: NestedScrollViewInnerScrollPositionKeyWidget(
                          Key(i.toString()),
                          ListView.builder(
                              key: PageStorageKey(
                                  i.toString() + "pageStorageKey"),
                              scrollDirection: Axis.vertical,
                              itemCount: widget
                                  .facilityItemList[i].facilityItems.length,
                              shrinkWrap: true,
                              physics: ClampingScrollPhysics(),
                              itemBuilder: (context, j) {
                                String price = Utils().getAmount(
                                    amount: widget.facilityItemList[i]
                                        .facilityItems[j].price);
                                return GroovenNonCollapse(
                                  key: PageStorageKey(
                                      j.toString() + "PageStorageKey"),
                                  btnIndex: j,
                                  selectedIndex: selectedHeadIndex,
                                  onTap: (isExpanded, btnHeadIndex) async {
                                    if (widget.facilityItemList[i]
                                            .facilityItemGroupId ==
                                        58) {
                                      Meta m = await FacilityDetailRepository()
                                          .getItemPartyHallEnquiryList(
                                              widget
                                                  .facilityItemList[i]
                                                  .facilityItems[j]
                                                  .facilityItemId,
                                              0);
                                      List<PartyHallResponse> enquiryResponse =
                                          [];
                                      // new List<PartyHallResponse>();
                                      jsonDecode(m.statusMsg)['response']
                                          .forEach((f) => enquiryResponse.add(
                                              new PartyHallResponse.fromJson(
                                                  f)));
                                      partyHallEnquiryList[widget
                                          .facilityItemList[i]
                                          .facilityItems[j]
                                          .facilityItemId] = enquiryResponse;
                                    } else {
                                      Meta m = await FacilityDetailRepository()
                                          .getItemEnquiryList(
                                              widget
                                                  .facilityItemList[i]
                                                  .facilityItems[j]
                                                  .facilityItemId,
                                              0);
                                      List<EnquiryDetailResponse>
                                          enquiryResponse = [];
                                      // new List<EnquiryDetailResponse>();
                                      jsonDecode(m.statusMsg)['response']
                                          .forEach((f) => enquiryResponse.add(
                                              new EnquiryDetailResponse
                                                  .fromJson(f)));
                                      enquiryList[widget
                                          .facilityItemList[i]
                                          .facilityItems[j]
                                          .facilityItemId] = enquiryResponse;
                                    }
                                    updateHeadSelectedIndex(btnHeadIndex);
                                  },
                                  defaultTrailingIconColor: Colors.grey,
                                  onExpansionChanged: (val) {
                                    setState(() {
                                      ismainExpanded = val;
                                    });
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      PackageListHead.packageExpandTextStyle(
                                          context,
                                          1.0,
                                          widget
                                              .facilityItemList[i]
                                              .facilityItems[j]
                                              .facilityItemName,
                                          false),
                                      Padding(
                                        padding: Localizations.localeOf(context)
                                                    .languageCode ==
                                                "en"
                                            ? EdgeInsets.only(left: 8.0)
                                            : EdgeInsets.only(right: 8.0),
                                        child: Text(
                                          price,
                                          style: TextStyle(
                                            fontSize:
                                                Styles.packageExpandTextSiz,
                                            fontFamily:
                                                tr("currFontFamilyEnglishOnly"),
//                                          fontWeight: FontWeight.bold,
                                            color: ColorData.primaryTextColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.zero,
                                      padding: EdgeInsets.only(
                                          left: 15.0, right: 25.0, bottom: 0.0),
                                      child: getHtml(widget.facilityItemList[i]
                                          .facilityItems[j].description),
                                    ),
                                    widget.facilityItemList[i].facilityItems[j]
                                                .isBookable &&
                                            widget
                                                    .facilityItemList[i]
                                                    .facilityItems[j]
                                                    .itemTypeId !=
                                                1 &&
                                            widget.facilityId != 19 &&
                                            widget.facilityId != 13 &&
                                            widget.facilityId != 4 &&
                                            widget.facilityId != 9 &&
                                            widget.facilityId != 6 &&
                                            widget.facilityId != 3
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                                Container(
                                                  // decoration: new BoxDecoration(
                                                  //     borderRadius:
                                                  //         BorderRadius.circular(
                                                  //             4)),
                                                  padding: Localizations
                                                                  .localeOf(
                                                                      context)
                                                              .languageCode ==
                                                          "en"
                                                      ? EdgeInsets.only(
                                                          bottom: 5, right: 35)
                                                      : EdgeInsets.only(
                                                          bottom: 5, left: 35),
                                                  // height: MediaQuery.of(context)
                                                  //         .size
                                                  //         .height /
                                                  //     19,
                                                  // child: ButtonTheme(
                                                  //   height:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .height /
                                                  //           23,
                                                  //   minWidth:
                                                  //       MediaQuery.of(context)
                                                  //               .size
                                                  //               .width /
                                                  //           4,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        foregroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                                Colors.white),
                                                        backgroundColor:
                                                            MaterialStateProperty.all<Color>(
                                                                ColorData.toColor(widget
                                                                    .colorCode)),
                                                        shape: MaterialStateProperty.all<
                                                                RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(4),
                                                                side: BorderSide(color: ColorData.toColor(widget.colorCode))))),
                                                    onPressed: () async {
                                                      FacilityDetailResponse
                                                          facilityDetailResponse =
                                                          new FacilityDetailResponse();
                                                      Meta m = await (new FacilityDetailRepository())
                                                          .getFacilityDetails(
                                                              widget
                                                                  .facilityId);
                                                      if (m.statusCode == 200) {
                                                        facilityDetailResponse =
                                                            FacilityDetailResponse
                                                                .fromJson(jsonDecode(
                                                                        m.statusMsg)[
                                                                    'response']);
                                                      }
                                                      List<Meta> metaList =
                                                          await Future.wait([
                                                        GeneralRepo()
                                                            .getNationalityList(),
                                                        GeneralRepo()
                                                            .getGenderList()
                                                      ]);
                                                      List<NationalityResponse>
                                                          nationalityList = [];
                                                      // List();
                                                      List<GenderResponse>
                                                          genderList =
                                                          []; // List();

                                                      if (metaList[0]
                                                                  .statusCode ==
                                                              200 &&
                                                          metaList[1]
                                                                  .statusCode ==
                                                              200) {
                                                        jsonDecode(metaList[0]
                                                                    .statusMsg)[
                                                                "response"]
                                                            .forEach((f) =>
                                                                nationalityList.add(
                                                                    new NationalityResponse
                                                                            .fromJson(
                                                                        f)));

                                                        jsonDecode(metaList[1]
                                                                    .statusMsg)[
                                                                "response"]
                                                            .forEach((f) =>
                                                                genderList.add(
                                                                    new GenderResponse
                                                                            .fromJson(
                                                                        f)));
                                                      }
                                                      Navigator.pop(context);
                                                      // if (facilityDetailResponse
                                                      //             .facilityId ==
                                                      //         Constants
                                                      //             .FacilityCollage &&
                                                      //     widget.facilityItemList[i]
                                                      //             .facilityItemGroupId ==
                                                      //         58) {
                                                      //   // Navigator.push(
                                                      //   //   context,
                                                      //   //   MaterialPageRoute(
                                                      //   //     builder: (context) =>
                                                      //   //         NewPartyHall(
                                                      //   //       facilityItem: widget
                                                      //   //           .facilityItemList[
                                                      //   //               i]
                                                      //   //           .facilityItems[j],
                                                      //   //       facilityDetail:
                                                      //   //           facilityDetailResponse,
                                                      //   //       partyHallDetailId:
                                                      //   //           0,
                                                      //   //       screenType: Constants
                                                      //   //           .Screen_Add_Enquiry,
                                                      //   //     ),
                                                      //   //   ),
                                                      //   // );
                                                      // } else {

                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              NewEnquiry(
                                                            facilityItem: widget
                                                                .facilityItemList[
                                                                    i]
                                                                .facilityItems[j],
                                                            facilityDetail:
                                                                facilityDetailResponse,
                                                            enquiryDetailId: 0,
                                                            screenType: 0,
                                                          ),
                                                        ),
                                                      );
                                                      // }
                                                    },
                                                    // color: ColorData.toColor(
                                                    //     widget.colorCode),
                                                    // shape:
                                                    //     RoundedRectangleBorder(
                                                    //   borderRadius:
                                                    //       BorderRadius.circular(
                                                    //           4),
                                                    // ),
                                                    child: Text(tr('enquiry'),
                                                        style: TextStyle(
                                                          fontSize: Styles
                                                              .loginBtnFontSize,
                                                          color: ColorData
                                                              .whiteColor,
                                                          fontFamily: tr(
                                                              'currFontFamily'),
                                                        )),
                                                  ),
                                                  //)
                                                )
                                              ])
                                        : Text(""),
                                    widget.facilityItemList[i].facilityItems[j]
                                                .isBookable &&
                                            widget.facilityId != 3
                                        ? Container(
                                            padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                                bottom: 10.0),
                                            child: Row(children: [
                                              // widget.facilityItemList[i]
                                              //             .facilityItemGroupId ==
                                              //         58
                                              //     ? (partyHallEnquiryList[widget
                                              //                 .facilityItemList[
                                              //                     i]
                                              //                 .facilityItems[j]
                                              //                 .facilityItemId] ==
                                              //             null
                                              // Text("")
                                              // : getPartyHallEnquiryList(
                                              //     partyHallEnquiryList[widget
                                              //         .facilityItemList[
                                              //             i]
                                              //         .facilityItems[j]
                                              //         .facilityItemId],
                                              //     j,
                                              //     i))
                                              enquiryList[widget
                                                          .facilityItemList[i]
                                                          .facilityItems[j]
                                                          .facilityItemId] ==
                                                      null
                                                  ? Text("")
                                                  : getEnquiryList(
                                                      enquiryList[widget
                                                          .facilityItemList[i]
                                                          .facilityItems[j]
                                                          .facilityItemId],
                                                      j,
                                                      i)
                                            ]))
                                        : Text("")
                                  ],
                                );
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
                i == widget.facilityItemList.length - 1 ||
                        isExpanded == true && i == selectedIndex
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

  Widget getEnquiryList(List<EnquiryDetailResponse> enquiryDetailResponse,
      int itemRow, int parentRow) {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey(itemRow.toString() + "PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: enquiryDetailResponse.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                height: MediaQuery.of(context).size.height * .16,
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
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(top: 10, left: 10)
                                : EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                            "Name : " +
                                enquiryDetailResponse[j].firstName +
                                " " +
                                enquiryDetailResponse[j].lastName,
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.packageExpandTextSiz,
                                fontFamily: tr('currFontFamily'))),
                      ),
                    ]),
                    Row(children: [
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(top: 10, left: 10)
                                : EdgeInsets.only(top: 10, right: 10),
                        child: Text(
                            "Enquiry ID : " +
                                enquiryDetailResponse[j]
                                    .enquiryDetailId
                                    .toString(),
                            style: TextStyle(
                                color:
                                    ColorData.primaryTextColor.withOpacity(1.0),
                                fontSize: Styles.packageExpandTextSiz,
                                fontFamily: tr('currFontFamily'))),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        enquiryDetailResponse[j].enquiryStatusId ==
                                Constants.Work_Flow_Schedules
                            ? Text("")
                            : Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(top: 5, right: 20)
                                    : EdgeInsets.only(top: 5, left: 20),

                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            ColorData.primaryTextColor),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.grey[200]),
                                    // shape: MaterialStateProperty.all<
                                    //         RoundedRectangleBorder>(
                                    //     // RoundedRectangleBorder(
                                    //     //     borderRadius:
                                    //     //         BorderRadius.circular(4),
                                    //     //     side: BorderSide(
                                    //     //         color: ColorData.primaryTextColor))
                                    // )),
                                  ),
                                  onPressed: () async {
                                    showDialog<Widget>(
                                      context: context,
                                      barrierDismissible:
                                          false, // user must tap button!
                                      builder: (BuildContext pcontext) {
                                        return AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14)),
                                          ),
                                          content: SingleChildScrollView(
                                            scrollDirection: Axis.vertical,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Center(
                                                    child: Text(
                                                      tr("enquiry"),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: ColorData
                                                            .primaryTextColor,
                                                        fontFamily: tr(
                                                            "currFontFamily"),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: Styles
                                                            .textSizeSmall,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Center(
                                                    child: Text(
                                                      tr('cancel_confirm'),
                                                      style: TextStyle(
                                                          color: ColorData
                                                              .primaryTextColor,
                                                          fontSize:
                                                              Styles.textSiz,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          fontFamily: tr(
                                                              "currFontFamily")),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 10.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: <Widget>[
                                                      ElevatedButton(
                                                          style: ButtonStyle(
                                                              foregroundColor:
                                                                  MaterialStateProperty.all<Color>(Colors
                                                                      .white),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<Color>(
                                                                      ColorData
                                                                          .grey300),
                                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                  RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                Radius.circular(
                                                                    5.0),
                                                              )))),
                                                          // shape: RoundedRectangleBorder(
                                                          //     borderRadius: BorderRadius
                                                          //         .all(Radius
                                                          //             .circular(
                                                          //                 5.0))),
                                                          // color:
                                                          //     ColorData.grey300,
                                                          child: new Text("No",
                                                              style: TextStyle(
                                                                  color: ColorData
                                                                      .primaryTextColor,
//                                color: Colors.black45,
                                                                  fontSize: Styles
                                                                      .textSizeSmall,
                                                                  fontFamily:
                                                                      tr("currFontFamily"))),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    pcontext)
                                                                .pop();
                                                          }),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                            foregroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .white),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        ColorData
                                                                            .colorBlue),
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                              Radius.circular(
                                                                  5.0),
                                                            )))),
                                                        // shape: RoundedRectangleBorder(
                                                        //     borderRadius:
                                                        //         BorderRadius.all(
                                                        //             Radius.circular(
                                                        //                 5.0))),
                                                        // color:
                                                        //     ColorData.colorBlue,
                                                        child: new Text(
                                                          "Yes",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: Styles
                                                                  .textSizeSmall,
                                                              fontFamily: tr(
                                                                  "currFontFamily")),
                                                        ),
                                                        onPressed: () async {
                                                          Navigator.of(pcontext)
                                                              .pop();
                                                          enquiryDetailResponse[
                                                                  j]
                                                              .enquiryStatusId = 0;
                                                          enquiryDetailResponse[
                                                                  j]
                                                              .isActive = false;
                                                          enquiryDetailResponse[
                                                                  j]
                                                              .erpCustomerId = 0;
                                                          enquiryDetailResponse[
                                                                      j]
                                                                  .vatPercentage =
                                                              enquiryDetailResponse[
                                                                              j]
                                                                          .vatPercentage ==
                                                                      null
                                                                  ? 0
                                                                  : enquiryDetailResponse[
                                                                          j]
                                                                      .vatPercentage;
                                                          Meta m = await (new FacilityDetailRepository())
                                                              .saveEnquiryDetails(
                                                                  enquiryDetailResponse[
                                                                      j],
                                                                  true);
                                                          if (m.statusCode ==
                                                              200) {
                                                            Navigator.pop(
                                                                context);
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      FacilityDetailsPage(
                                                                          facilityId:
                                                                              widget.facilityId)),
                                                            );
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("enquiry"),
                                                                "Cancelled Successfuly",
                                                                context);
                                                          } else {
                                                            util.customGetSnackBarWithOutActionButton(
                                                                tr("enquiry"),
                                                                m.statusMsg,
                                                                context);
                                                          }
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  // color: Colors.grey[200],
                                  // textColor: Colors.white,
                                  child: Text(tr("cancel"),
                                      style: TextStyle(
                                        fontSize: Styles.loginBtnFontSize,
                                        color: ColorData.primaryTextColor,
                                        fontFamily: tr('currFontFamily'),
                                      )),
                                ),
                                //),
                              ),
                        Padding(
                          padding:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? EdgeInsets.only(top: 5, right: 20)
                                  : EdgeInsets.only(top: 5, left: 20),
                          child: ElevatedButton(
                            // shape: RoundedRectangleBorder(
                            //   borderRadius: BorderRadius.circular(4),
                            // ),
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(
                                    Colors.white),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        ColorData.toColor(widget.colorCode)),
                                shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        side: BorderSide(
                                            color: ColorData.toColor(
                                                widget.colorCode))))),
                            onPressed: () async {
                              if (enquiryDetailResponse[j].enquiryStatusId ==
                                  Constants.Work_Flow_New) return;
                              if (enquiryDetailResponse[j] != null &&
                                  enquiryDetailResponse[j].enquiryProcessId ==
                                      1) return;

                              FacilityDetailResponse facilityDetailResponse =
                                  new FacilityDetailResponse();
                              Meta m = await (new FacilityDetailRepository())
                                  .getFacilityDetails(widget.facilityId);
                              if (m.statusCode == 200) {
                                facilityDetailResponse =
                                    FacilityDetailResponse.fromJson(
                                        jsonDecode(m.statusMsg)['response']);
                              }
                              if (enquiryDetailResponse[j].enquiryStatusId !=
                                  Constants.Work_Flow_Payment) {
                                List<Meta> metaList = await Future.wait([
                                  GeneralRepo().getNationalityList(),
                                  GeneralRepo().getGenderList()
                                ]);
                                List<NationalityResponse> nationalityList = [];
                                // List();
                                List<GenderResponse> genderList = []; //List();

                                if (metaList[0].statusCode == 200 &&
                                    metaList[1].statusCode == 200) {
                                  jsonDecode(metaList[0].statusMsg)["response"]
                                      .forEach((f) => nationalityList.add(
                                          new NationalityResponse.fromJson(f)));

                                  jsonDecode(metaList[1].statusMsg)["response"]
                                      .forEach((f) => genderList
                                          .add(new GenderResponse.fromJson(f)));
                                }
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NewEnquiry(
                                      facilityItem: widget
                                          .facilityItemList[parentRow]
                                          .facilityItems[itemRow],
                                      facilityDetail: facilityDetailResponse,
                                      enquiryDetailId: enquiryDetailResponse[j]
                                          .enquiryDetailId,
                                      screenType: enquiryDetailResponse[j]
                                                  .enquiryStatusId ==
                                              Constants
                                                  .Work_Flow_UploadDocuments //2
                                          ? Constants.Screen_Upload_Document
                                          : enquiryDetailResponse[j]
                                                      .enquiryStatusId ==
                                                  Constants.Work_Flow_Schedules
                                              ? Constants.Screen_Schedule //3
                                              : enquiryDetailResponse[j]
                                                          .enquiryStatusId ==
                                                      Constants
                                                          .Work_Flow_AnswerQuestions
                                                  ? Constants.Screen_Questioner
                                                  : Constants
                                                      .Screen_Accept_Terms, //2
                                    ),
                                  ),
                                );
                              } else if (enquiryDetailResponse[j]
                                          .enquiryStatusId ==
                                      Constants.Work_Flow_Payment //4
                                  ) {
                                Meta m = await FacilityDetailRepository()
                                    .getDiscountList(
                                        facilityDetailResponse.facilityId,
                                        enquiryDetailResponse[j].price);
                                List<BillDiscounts> billDiscounts = [];
                                // new List<BillDiscounts>();
                                if (m.statusCode == 200) {
                                  jsonDecode(m.statusMsg)['response'].forEach(
                                      (f) => billDiscounts
                                          .add(new BillDiscounts.fromJson(f)));
                                }
                                Meta m1 = await FacilityDetailRepository()
                                    .getPaymentTerms(
                                  facilityDetailResponse.facilityId,
                                );
                                PaymentTerms paymentTerms = new PaymentTerms();
                                if (m1.statusCode == 200) {
                                  paymentTerms = new PaymentTerms.fromJson(
                                      jsonDecode(m1.statusMsg)["response"]);
                                }

                                if (paymentTerms == null) {
                                  paymentTerms = new PaymentTerms();
                                }
                                Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EnquiryPayment(
                                              facilityItem: widget
                                                  .facilityItemList[parentRow]
                                                  .facilityItems[itemRow],
                                              facilityDetail:
                                                  facilityDetailResponse,
                                              enquiryDetail:
                                                  enquiryDetailResponse[j],
                                              billDiscounts: billDiscounts,
                                              paymentTerms: paymentTerms,
                                            )));
                              }
                            },
                            // color: ColorData.toColor(widget.colorCode),
                            // textColor: Colors.white,
                            child: Text(
                                enquiryDetailResponse[j].enquiryStatusId ==
                                        Constants.Work_Flow_New
                                    ? tr("pending")
                                    : enquiryDetailResponse[j].enquiryStatusId ==
                                            Constants.Work_Flow_UploadDocuments
                                        ? enquiryDetailResponse[j]
                                                    .enquiryProcessId ==
                                                0
                                            ? tr('upload_your_documents')
                                            : tr("upload_proces")
                                        : enquiryDetailResponse[j].enquiryStatusId ==
                                                Constants
                                                    .Work_Flow_AnswerQuestions
                                            ? enquiryDetailResponse[j]
                                                        .enquiryProcessId ==
                                                    0
                                                ? tr("questions")
                                                : tr("questions_process")
                                            : enquiryDetailResponse[j]
                                                        .enquiryStatusId ==
                                                    Constants
                                                        .Work_Flow_AcceptTerms
                                                //3
                                                ? enquiryDetailResponse[j]
                                                            .enquiryProcessId ==
                                                        0
                                                    ? (widget.facilityId ==
                                                            Constants
                                                                .FacilityMembership
                                                        ? tr("accept")
                                                        : tr("accept_others"))
                                                    : tr("accept_process")
                                                : enquiryDetailResponse[j]
                                                            .enquiryStatusId ==
                                                        Constants
                                                            .Work_Flow_Payment
                                                    //4
                                                    ? enquiryDetailResponse[j]
                                                                .enquiryProcessId ==
                                                            0
                                                        ? tr("proceed_to_pay")
                                                        : tr("payment_process")
                                                    : enquiryDetailResponse[j]
                                                                .enquiryProcessId ==
                                                            0
                                                        ? tr("schedule")
                                                        : tr('schedule_process'),
                                style: TextStyle(
                                  fontSize: Styles.loginBtnFontSize,
                                  color: ColorData.whiteColor,
                                  fontFamily: tr('currFontFamily'),
                                )),
                          ),
                          // ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }));
  }

//   Widget getPartyHallEnquiryList(List<PartyHallResponse> enquiryDetailResponse,
//       int itemRow, int parentRow) {
//     return Expanded(
//         child: ListView.builder(
//             key: PageStorageKey(itemRow.toString() + "PageStorageKey"),
//             shrinkWrap: true,
//             physics: ClampingScrollPhysics(),
//             scrollDirection: Axis.vertical,
//             itemCount: enquiryDetailResponse.length,
//             itemBuilder: (context, j) {
//               //return //Container(child: Text(enquiryDetailResponse[j].firstName));
//               return Container(
//                 height: MediaQuery.of(context).size.height * .16,
//                 width: MediaQuery.of(context).size.width * .98,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(15)),
//                   border: Border.all(color: Colors.grey[200]),
//                   color: Colors.white,
//                 ),
//                 child: Column(
//                   children: <Widget>[
//                     // Padding(
//                     //     padding: EdgeInsets.only(top: 10),
//                     //     child: Divider(color: Colors.grey[900])),
//                     Row(children: [
//                       Padding(
//                         padding:
//                         Localizations.localeOf(context).languageCode == "en"
//                             ? EdgeInsets.only(top: 10, left: 10)
//                             : EdgeInsets.only(top: 10, right: 10),
//                         child: Text(
//                             "Event : " +
//                                 enquiryDetailResponse[j].partyEventTypeName,
//
//                             style: TextStyle(
//                                 color:
//                                 ColorData.primaryTextColor.withOpacity(1.0),
//                                 fontSize: Styles.packageExpandTextSiz,
//                                 fontFamily: tr('currFontFamily'))),
//                       ),
//                     ]),
//                     Row(children: [
//                       Padding(
//                         padding:
//                         Localizations.localeOf(context).languageCode == "en"
//                             ? EdgeInsets.only(top: 10, left: 10)
//                             : EdgeInsets.only(top: 10, right: 10),
//                         child: Text(
//                             "Enquiry ID : " +
//                                 enquiryDetailResponse[j]
//                                     .partyHallBookingId
//                                     .toString(),
//                             style: TextStyle(
//                                 color:
//                                 ColorData.primaryTextColor.withOpacity(1.0),
//                                 fontSize: Styles.packageExpandTextSiz,
//                                 fontFamily: tr('currFontFamily'))),
//                       ),
//                     ]),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                          Padding(
//                           padding: Localizations.localeOf(context)
//                               .languageCode ==
//                               "en"
//                               ? EdgeInsets.only(top: 5, right: 20)
//                               : EdgeInsets.only(top: 5, left: 20),
//
//                           child: ElevatedButton(
//                             style: ButtonStyle(
//                               foregroundColor:
//                               MaterialStateProperty.all<Color>(
//                                   ColorData.primaryTextColor),
//                               backgroundColor:
//                               MaterialStateProperty.all<Color>(
//                                   Colors.grey[200]),
//                               // shape: MaterialStateProperty.all<
//                               //         RoundedRectangleBorder>(
//                               //     // RoundedRectangleBorder(
//                               //     //     borderRadius:
//                               //     //         BorderRadius.circular(4),
//                               //     //     side: BorderSide(
//                               //     //         color: ColorData.primaryTextColor))
//                               // )),
//                             ),
//                             onPressed: () async {
//                               showDialog<Widget>(
//                                 context: context,
//                                 barrierDismissible:
//                                 false, // user must tap button!
//                                 builder: (BuildContext pcontext) {
//                                   return AlertDialog(
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(14)),
//                                     ),
//                                     content: SingleChildScrollView(
//                                       scrollDirection: Axis.vertical,
//                                       child: Column(
//                                         mainAxisSize: MainAxisSize.min,
//                                         crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                         children: <Widget>[
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: Center(
//                                               child: Text(
//                                                 tr("enquiry"),
//                                                 textAlign:
//                                                 TextAlign.center,
//                                                 style: TextStyle(
//                                                   color: ColorData
//                                                       .primaryTextColor,
//                                                   fontFamily: tr(
//                                                       "currFontFamily"),
//                                                   fontWeight:
//                                                   FontWeight.w500,
//                                                   fontSize: Styles
//                                                       .textSizeSmall,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: Center(
//                                               child: Text(
//                                                 tr('cancel_confirm'),
//                                                 style: TextStyle(
//                                                     color: ColorData
//                                                         .primaryTextColor,
//                                                     fontSize:
//                                                     Styles.textSiz,
//                                                     fontWeight:
//                                                     FontWeight.w400,
//                                                     fontFamily: tr(
//                                                         "currFontFamily")),
//                                               ),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                                 top: 10.0),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                               MainAxisAlignment
//                                                   .spaceEvenly,
//                                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                               children: <Widget>[
//                                                 ElevatedButton(
//                                                     style: ButtonStyle(
//                                                         foregroundColor:
//                                                         MaterialStateProperty.all<Color>(Colors.white),
//                                                         backgroundColor:
//                                                         MaterialStateProperty.all<Color>(ColorData.grey300),
//                                                         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                             RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.all(
//                                                                   Radius.circular(10.0),
//                                                                 )))),
//                                                     // shape: RoundedRectangleBorder(
//                                                     //     borderRadius: BorderRadius
//                                                     //         .all(Radius
//                                                     //         .circular(
//                                                     //         5.0))),
//                                                     // color:
//                                                     // ColorData.grey300,
//                                                     child: new Text("No",
//                                                         style: TextStyle(
//                                                             color: ColorData
//                                                                 .primaryTextColor,
// //                                color: Colors.black45,
//                                                             fontSize: Styles
//                                                                 .textSizeSmall,
//                                                             fontFamily: tr(
//                                                                 "currFontFamily"))),
//                                                     onPressed: () {
//                                                       Navigator.of(
//                                                           pcontext)
//                                                           .pop();
//                                                     }),
//                                                 ElevatedButton(
//                                                   style: ButtonStyle(
//                                                       foregroundColor:
//                                                       MaterialStateProperty.all<Color>(Colors.white),
//                                                       backgroundColor:
//                                                       MaterialStateProperty.all<Color>(ColorData.colorBlue),
//                                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                                           RoundedRectangleBorder(
//                                                               borderRadius: BorderRadius.all(
//                                                                 Radius.circular(10.0),
//                                                               )))),
//                                                   // shape: RoundedRectangleBorder(
//                                                   //     borderRadius:
//                                                   //     BorderRadius.all(
//                                                   //         Radius.circular(
//                                                   //             5.0))),
//                                                   // color:
//                                                   // ColorData.colorBlue,
//                                                   child: new Text(
//                                                     "Yes",
//                                                     style: TextStyle(
//                                                         color:
//                                                         Colors.white,
//                                                         fontSize: Styles
//                                                             .textSizeSmall,
//                                                         fontFamily: tr(
//                                                             "currFontFamily")),
//                                                   ),
//                                                   onPressed: () async {
//                                                     Navigator.of(pcontext)
//                                                         .pop();
//                                                     Meta m = await (new FacilityDetailRepository())
//                                                         .updatePartyHallDetails(
//                                                         enquiryDetailResponse[
//                                                         j].partyHallBookingId,enquiryDetailResponse[
//                                                     j].partyHallStatusId,false,0
//                                                         );
//                                                     if (m.statusCode ==
//                                                         200) {
//                                                       Navigator.pop(
//                                                           context);
//                                                       Navigator.push(
//                                                         context,
//                                                         MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 FacilityDetailsPage(
//                                                                     facilityId:
//                                                                     widget.facilityId)),
//                                                       );
//                                                       util.customGetSnackBarWithOutActionButton(
//                                                           tr("party_hall"),
//                                                           "Cancelled Successfuly",
//                                                           context);
//                                                     } else {
//                                                       util.customGetSnackBarWithOutActionButton(
//                                                           tr("enquiry"),
//                                                           m.statusMsg,
//                                                           context);
//                                                     }
//                                                   },
//                                                 )
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                             // color: Colors.grey[200],
//                             // textColor: Colors.white,
//                             child: Text(tr("cancel"),
//                                 style: TextStyle(
//                                   fontSize: Styles.loginBtnFontSize,
//                                   color: ColorData.primaryTextColor,
//                                   fontFamily: tr('currFontFamily'),
//                                 )),
//                           ),
//                           //),
//                         ),
//                         Padding(
//                           padding:
//                           Localizations.localeOf(context).languageCode ==
//                               "en"
//                               ? EdgeInsets.only(top: 5, right: 20)
//                               : EdgeInsets.only(top: 5, left: 20),
//                           child: ElevatedButton(
//                             // shape: RoundedRectangleBorder(
//                             //   borderRadius: BorderRadius.circular(4),
//                             // ),
//                             style: ButtonStyle(
//                                 foregroundColor: MaterialStateProperty.all<Color>(
//                                     Colors.white),
//                                 backgroundColor:
//                                 MaterialStateProperty.all<Color>(
//                                     ColorData.toColor(widget.colorCode)),
//                                 shape: MaterialStateProperty.all<
//                                     RoundedRectangleBorder>(
//                                     RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(4),
//                                         side: BorderSide(
//                                             color: ColorData.toColor(
//                                                 widget.colorCode))))),
//                             onPressed: () async {
//                               FacilityDetailResponse facilityDetailResponse =
//                               new FacilityDetailResponse();
//                               Meta m = await (new FacilityDetailRepository())
//                                   .getFacilityDetails(widget.facilityId);
//                               if (m.statusCode == 200) {
//                                 facilityDetailResponse =
//                                     FacilityDetailResponse.fromJson(
//                                         jsonDecode(m.statusMsg)['response']);
//                               }
//                               // if (enquiryDetailResponse[j].partyHallStatusId !=
//                               //     Constants.Work_Flow_Payment) {
//                               //   List<Meta> metaList = await Future.wait([
//                               //     GeneralRepo().getNationalityList(),
//                               //     GeneralRepo().getGenderList()
//                               //   ]);
//                               //   List<NationalityResponse> nationalityList =[];
//                               //   // List();
//                               //   List<GenderResponse> genderList = [];//List();
//                               //
//                               //   if (metaList[0].statusCode == 200 &&
//                               //       metaList[1].statusCode == 200) {
//                               //     jsonDecode(metaList[0].statusMsg)["response"]
//                               //         .forEach((f) => nationalityList.add(
//                               //         new NationalityResponse.fromJson(f)));
//                               //
//                               //     jsonDecode(metaList[1].statusMsg)["response"]
//                               //         .forEach((f) => genderList
//                               //         .add(new GenderResponse.fromJson(f)));
//                               //   }
//                               //   Navigator.pop(context);
//                               //   Navigator.push(
//                               //     context,
//                               //     MaterialPageRoute(
//                               //       builder: (context) => NewPartyHall(
//                               //         facilityItem: widget
//                               //             .facilityItemList[parentRow]
//                               //             .facilityItems[itemRow],
//                               //         facilityDetail: facilityDetailResponse,
//                               //         partyHallDetailId: enquiryDetailResponse[j]
//                               //             .partyHallBookingId,
//                               //         screenType:  enquiryDetailResponse[j].partyHallStatusId==Constants.Work_Flow_UploadDocuments?
//                               //         Constants.Screen_Upload_Document:Constants.Screen_Contract //3
//                               //              //2
//                               //       ),
//                               //     ),
//                               //   );
//                               // }
//                               // else if (enquiryDetailResponse[j]
//                               //     .partyHallStatusId ==
//                               //     Constants.Work_Flow_Payment //4
//                               // ) {
//                               //   Meta m = await FacilityDetailRepository()
//                               //       .getDiscountList(
//                               //       facilityDetailResponse.facilityId,
//                               //       enquiryDetailResponse[j].total);
//                               //       // facilityDetailResponse.facilityId
//                               //       //     .toString() +
//                               //       // " " +
//                               //       // enquiryDetailResponse[j].total.toString());
//                               //   List<BillDiscounts> billDiscounts =
//                               //   new List<BillDiscounts>();
//                               //   if (m.statusCode == 200) {
//                               //     jsonDecode(m.statusMsg)['response'].forEach(
//                               //             (f) => billDiscounts
//                               //             .add(new BillDiscounts.fromJson(f)));
//                               //   }
//                               //   if (billDiscounts == null) {
//                               //     billDiscounts = new List<BillDiscounts>();
//                               //   }
//                               //   Navigator.pop(context);
//                               //   Navigator.push(
//                               //       context,
//                               //       MaterialPageRoute(
//                               //           builder: (context) => PartyHallPayment(
//                               //             facilityItem: widget
//                               //                 .facilityItemList[parentRow]
//                               //                 .facilityItems[itemRow],
//                               //             facilityDetail:
//                               //             facilityDetailResponse,
//                               //             partyHallDetail:
//                               //             enquiryDetailResponse[j],
//                               //             billDiscounts: billDiscounts,
//                               //           )));
//                               // }
//                             },
//                             // color: ColorData.toColor(widget.colorCode),
//                             // textColor: Colors.white,
//                             child:Text(
//                                 // enquiryDetailResponse[j].partyHallStatusId ==
//                                 //     Constants.Work_Flow_New
//                                 //     ? tr("pending")
//                                      enquiryDetailResponse[j].partyHallStatusId ==
//                                     Constants.Work_Flow_UploadDocuments
//                                     ? tr('upload_your_documents')
//                                     : enquiryDetailResponse[j]
//                                     .partyHallStatusId ==
//                                     Constants
//                                         .Work_Flow_AcceptTerms
//                                       ?tr("accept"):
//                                      enquiryDetailResponse[j]
//                                          .partyHallStatusId  ==
//                                     Constants
//                                         .Work_Flow_Payment
//                                         ? tr("proceed_to_pay")
//                                     : tr("view_contract"),
//                                 style: TextStyle(
//                                   fontSize: Styles.loginBtnFontSize,
//                                   color: ColorData.whiteColor,
//                                   fontFamily: tr('currFontFamily'),
//                                 )),
//                           ),
//                           // ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }));
//   }

  Widget getHtml(String description) {
    return Html(
      // customFont: tr('currFontFamilyEnglishOnly'),
      // anchorColor: ColorData.primaryTextColor,
      shrinkWrap: false,
      style: {
        "body": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.all(0),
          color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
          // fontWeight: FontWeight.w500,
        ),
        // "p": Style(
        //   padding: EdgeInsets.all(0),
        //   margin: Margins.all(0),
        // ),
        "span": Style(
          padding: EdgeInsets.all(0),
          margin: Margins.zero,
          fontSize: FontSize(Styles.newTextSize),
          fontWeight: FontWeight.normal,
          color: ColorData.cardTimeAndDateColor,
          fontFamily: tr('currFontFamilyEnglishOnly'),
        ),
        // "h6": Style(
        //   padding: EdgeInsets.all(0),
        //   margin:Margins.zero,
        // ),
      },
      data: description != null
          ? '<html><body>' + description + '</body></html>'
          : tr('noDataFound'),
    );
  }

  void updateSelectedIndex(btnIndex) {
    setState(() {
      selectedIndex = btnIndex;
      isExpanded = false;
    });
  }

  updateHeadSelectedIndex(btnHeadIndex) {
    setState(() {
      selectedHeadIndex = btnHeadIndex;
      ismainExpanded = false;
    });
  }

  Widget _wrapScrollTag({int index, Widget child}) => AutoScrollTag(
        key: ValueKey(index),
        controller: scrlController,
        index: index,
        child: child,
        highlightColor: Colors.black.withOpacity(0.1),
      );
}
