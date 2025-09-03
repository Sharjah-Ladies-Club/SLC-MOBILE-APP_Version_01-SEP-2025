import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/datetime_utils.dart';

import 'grooven_non_collapse_tile.dart';

bool isExpanded = false;

class CustomExpandTileProfile extends StatefulWidget {
  final UserProfileInfo userInfo;

  CustomExpandTileProfile({Key key, this.userInfo}) : super(key: key);

  @override
  _CustomExpandTileState createState() => _CustomExpandTileState();
}

class _CustomExpandTileState extends State<CustomExpandTileProfile> {
  int selectedIndex = -1;
  int selectedHeadIndex = -1;

  bool ismainExpanded = false;
  Key key;
  int number = Random().nextInt(1000000000);

  @override
  Widget build(BuildContext context) {
    key = PageStorageKey(number.toString());
    return getProfileView();
  }

  Widget getProfileView() {
    return Container(
      color: Colors.white,
      child: ListView.builder(
          itemCount: widget.userInfo.associatedProfileList.length,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, i) {
            return Card(
              child: GroovenNonCollapse(
                key: PageStorageKey(i.toString() + "PageStorageKey"),
                btnIndex: i,
                selectedIndex: selectedHeadIndex,
                onTap: (isExpanded, btnHeadIndex) {
                  updateHeadSelectedIndex(btnHeadIndex);
                },
                defaultTrailingIconColor: Colors.grey,
                onExpansionChanged: (val) {
                  setState(() {
                    ismainExpanded = val;
                  });
                },
                title: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      child:
                          widget.userInfo.associatedProfileList[i].imageFile !=
                                      null &&
                                  widget.userInfo.associatedProfileList[i]
                                          .imageFile !=
                                      ""
                              ? CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(widget.userInfo
                                      .associatedProfileList[i].imageFile),
                                  backgroundColor: Colors.transparent,
                                )
                              : CircleAvatar(
                                  child: Icon(
                                    AccountIcon.account_type,
                                    color: const Color(0xFF3EB5E3),
                                    size: 30,
                                  ),
                                  radius: 20.0,
                                  backgroundColor: Colors.white,
                                ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: new Text(
                          widget.userInfo.associatedProfileList[i]
                                      .subContractID !=
                                  null
                              ? widget.userInfo.associatedProfileList[i]
                                  .subContractID
                                  .toString()
                              : "",
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            color: ColorData.primaryTextColor,
                            fontWeight: FontWeight.bold,
                            fontFamily: tr('currFontFamilyEnglishOnly'),
                          ),
                        ))
                  ],
                ),
                children: <Widget>[
                  Container(
                    child: NestedScrollViewInnerScrollPositionKeyWidget(
                      Key(i.toString()),
                      ListView.builder(
                          key: PageStorageKey(i.toString() + "pageStorageKey"),
                          scrollDirection: Axis.vertical,
                          itemCount: 1,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, j) {
                            return Container(
                              padding: EdgeInsets.only(bottom: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15.0,
                                        top: 10.0,
                                        bottom: 10.0,
                                        right: 15.0,
                                      ),
                                      child:
                                          PackageListHead.facilityItemsListText(
                                              context,
                                              (tr("subcontract_cat_name")))),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: new Text(
                                      widget.userInfo.associatedProfileList[i]
                                                  .subContractCategoryName !=
                                              null
                                          ? widget
                                              .userInfo
                                              .associatedProfileList[i]
                                              .subContractCategoryName
                                          : "",
                                      overflow: TextOverflow.ellipsis,
                                      style: PackageListHead
                                          .textFieldCountryCodeStyles(context),
                                    ),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(
                                        left: 15.0,
                                        top: 10.0,
                                        bottom: 10.0,
                                        right: 15.0,
                                      ),
                                      child:
                                          PackageListHead.facilityItemsListText(
                                              context,
                                              (tr("subcontract_start_date")))),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                    ),
                                    child: new Text(
                                      widget.userInfo.associatedProfileList[i]
                                                  .subContractStartDate !=
                                              null
                                          ? DateTimeUtils()
                                              .dateToServerToDateFormat(
                                                  widget
                                                      .userInfo
                                                      .associatedProfileList[i]
                                                      .subContractStartDate,
                                                  DateTimeUtils.ServerFormat,
                                                  DateTimeUtils
                                                      .DD_MM_YYYY_Format)
                                          : "",
                                      style: PackageListHead
                                          .textFieldCountryCodeStyles(context),
                                    ),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          top: 10.0,
                                          bottom: 10.0,
                                          right: 15.0),
                                      child:
                                          PackageListHead.facilityItemsListText(
                                              context,
                                              (tr("subcontract_end_date")))),

                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15.0),
                                    child: new Text(
                                      widget.userInfo.associatedProfileList[i]
                                                  .subContractEndDate !=
                                              null
                                          ? DateTimeUtils()
                                              .dateToServerToDateFormat(
                                                  // userDetails["dateOfBirth"],
                                                  widget
                                                      .userInfo
                                                      .associatedProfileList[i]
                                                      .subContractEndDate,
                                                  DateTimeUtils.ServerFormat,
                                                  DateTimeUtils
                                                      .DD_MM_YYYY_Format)
                                          : "",
                                      style: PackageListHead
                                          .textFieldCountryCodeStyles(context),
                                    ),
                                  ),
                                  Align(
                                    alignment: Localizations.localeOf(context)
                                                .languageCode ==
                                            "ar"
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 15.0, left: 15.0),
                                      child: Text(
                                        widget.userInfo.associatedProfileList[i]
                                                    .subContractTStatus !=
                                                null
                                            ? widget
                                                .userInfo
                                                .associatedProfileList[i]
                                                .subContractTStatus
                                            : "",
                                        style: PackageListHead.textFieldStyles(
                                            context, true),
                                      ),
                                    ),
                                  ),
// ),
                                ],
                              ),
                            );
//
                          }),
                    ),
                  ),
                ],
              ),
            );
          }),
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
}
