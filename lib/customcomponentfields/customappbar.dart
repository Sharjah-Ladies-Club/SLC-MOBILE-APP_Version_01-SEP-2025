import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_app_bar/CustomNotificationIcon.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/facility_request.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/chatbot/chat_bot.dart';
import 'package:slc/view/event_people_list/event_people_list.dart';
import 'package:slc/view/healthnbeauty/healthnbeauty.dart';
import 'package:slc/view/home/web_page_vr.dart';
import 'package:slc/view/mypage/my_page.dart';
import 'package:slc/view/notification/notification.dart';
import 'package:slc/view/profile/profile_new.dart';

import 'alert_dialog/custom_alert_dialog.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatefulWidget {
  final String title;
  final String fNameController;
  final String lNameController;
  final String customDobcontroller;
  final String emailController;
  final String ddInitialValue;
  final GlobalKey<FormBuilderState> profileFormKey;
  final Function actionClicked;
  final int eventId;
  final bool showAddPeople;
  final List<EventPriceCategory> eventPricingCategoryList;
  bool titleType;
  String titleImage;

  CustomAppBar(
      {this.title,
      this.fNameController,
      this.lNameController,
      this.customDobcontroller,
      this.emailController,
      this.ddInitialValue,
      this.profileFormKey,
      this.actionClicked,
      this.eventId,
      this.eventPricingCategoryList,
      this.titleType: false,
      this.showAddPeople,
      this.titleImage: ""});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  IconData editToSave = Icons.save;
  IconData saveToEdit = Icons.edit;
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0)),
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 1)
          ]),
      width: MediaQuery.of(context).size.width,
      height: AppBar().preferredSize.height,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
        child: Container(
          color: Colors.white,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                leadingIconShowLogic(),
                // Container(child: Text(''),),
                pageTitle(),
                trailingIconShowLogic(
                    // ,analytics,observer
                    ),
                //  Container(child: Text(''),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget pageTitle() {
    if (widget.titleType) {
      return Expanded(
        child: Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              fontFamily: tr('currFontFamilyEnglishOnly')),
        ),
      );
    } else if ((widget.title ==
            tr(
              "home",
            ) ||
        widget.title ==
            tr(
              "event",
            ) ||
        widget.title ==
            tr(
              "survey",
            ) ||
        widget.title ==
            tr(
              "more",
            ))) {
      return Container();
    } else if (widget.title == tr('notification')) {
      return Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            color: ColorData.activeIconColor,
            fontWeight: FontWeight.bold,
            fontFamily: "HelveticaNeue"),
      );
    } else if (widget.title == tr('chat')) {
      return Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            color: ColorData.activeIconColor,
            fontWeight: FontWeight.bold,
            fontFamily: "HelveticaNeue"),
      );
    } else if (widget.titleImage != "") {
      return Text("");
    } else if (widget.title != null) {
      return Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 20,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
            fontFamily: tr('currFontFamily')),
      );
    } else
      return Container();
  }

  leadingIconShowLogic() {
    if (widget.title == tr("home") ||
        widget.title == tr("event") ||
        widget.title == tr("survey") ||
        widget.title == tr("more")) {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Image.asset(
                  'assets/images/home_icon.png',
                  fit: BoxFit.contain,
                  height: 32,
                )),
            Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Image.asset(
                  'assets/images/dcurrency.png',
                  fit: BoxFit.contain,
                  height: 18,
                ))
            // Padding(
            //     padding: EdgeInsets.only(top: 4),
            //     child: Text(tr("currency"),
            //         style: TextStyle(
            //           fontSize: 16,
            //           fontWeight: FontWeight.w600,
            //           fontFamily: tr('currFontFamilyEnglishOnly'),
            //           color: ColorData.primaryTextColor.withOpacity(0.5),
            //         )))
          ],
        ),
      );
    }
    if (widget.titleType) {
      return IconButton(
        onPressed: () {
          Navigator.pop(context, true);
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => NotificationList()));
          Constants.isNotFromNotificationFamily = false;
          Constants.isFromNotificationFamily = 0;
        },
        icon: Icon(Icons.arrow_back_ios,
            size: 25, color: Theme.of(context).primaryColor),
      );
    } else if (widget.title == tr("profile")) {
      return IconButton(
        onPressed: () {
          if (Constants.iSEditClickedInProfile) {
            _onWillPop(context);
          } else {
            Navigator.pop(context);
          }
        },
        icon: Icon(Icons.arrow_back_ios,
            size: 25, color: Theme.of(context).primaryColor),
      );
    } /*else if (widget.title == tr("payment")) {
      return IconButton(
        onPressed: () {},
        icon: Icon(Icons.arrow_back_ios, size: 25, color: Colors.white),
      );
    }*/
    else if (widget.title ==
            tr(
              "home",
            ) ||
        widget.title ==
            tr(
              "event",
            ) ||
        widget.title ==
            tr(
              "survey",
            ) ||
        widget.title ==
            tr(
              "more",
            )) {
      return Container(
          //this is to show the title
//        margin: EdgeInsets.only(left: 20.0, right: 20),
//        child: Text(
//          widget.title,
//          style: TextStyle(
//              fontSize: 20,
//              color: Theme.of(context).primaryColor,
//              fontFamily:
//                  tr('currFontFamilyMedium')),
//        ),
          );
    } else if (widget.title == tr('notification')) {
      return IconButton(
          onPressed: () {
            Constants.isNotFromNotificationFamily = false;
            Constants.isFromNotificationFamily = 0;
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: ColorData.activeIconColor,
          ));
    } else {
      return IconButton(
        onPressed: () {
          if (widget.title == tr('addPeople')) {
            Get.off(() => (EventPeopleList(
                  eventId: widget.eventId,
                  eventPriceCategoryList: widget.eventPricingCategoryList,
                  showAddPeople: widget.showAddPeople,
                )));
          } else {
            setState(() {
              Constants.iSEditClickedInProfile = false;
            });
            Navigator.pop(context);
          }
        },
        icon: Icon(Icons.arrow_back_ios,
            size: 25, color: Theme.of(context).primaryColor),
      );
    }
  }

  Future<bool> _onWillPop(context) async {
    return (await customAlertDialog(
            context,
            tr("discard_message"),
            tr("yes"),
            tr("no"),
            tr("otp"),
            tr("confirm"),
            () => {
                  Navigator.of(context).pop(),
                })) ??
        false;
  }

  trailingIconShowLogic() {
    if (widget.titleType) {
      return Container(
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications, size: 25, color: Colors.transparent),
        ),
      );
    }

    if (widget.title == tr("profile")) {
      return Container(
        margin: EdgeInsets.only(bottom: 15.0),
        child: IconButton(
          onPressed: () {
            if (!Constants.iSEditClickedInProfile) {
              // setState(() {
              //     Constants.iSPageFromProfile = true;
              // });
              widget.actionClicked(!Constants.iSEditClickedInProfile);
            } else {
              widget.actionClicked(!Constants.iSEditClickedInProfile);
            }
          },
          icon: trailingIconShow(),
        ),
      );
    } else if (widget.title ==
            tr(
              "home",
            ) ||
        widget.title ==
            tr(
              "event",
            ) ||
        widget.title ==
            tr(
              "survey",
            ) ||
        widget.title ==
            tr(
              "more",
            )) {
      return Container(
        // width: MediaQuery.of(context).size.width * 0.95,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
//            Center(child: SvgPicture.asset('assets/images/ic_chatbot.svg',color: Colors.grey,height: 25.0,)),
//             Padding(
//                 padding: EdgeInsets.only(top: 4, left: 0, right: 0, bottom: 10),
//                 child: Text(tr("currency"),
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       fontFamily: tr('currFontFamilyEnglishOnly'),
//                       color: ColorData.primaryTextColor.withOpacity(0.5),
//                     ))),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;
                FacilityRequest request = FacilityRequest(facilityGroupId: 1);
                Meta m1 =
                    await HomeRepository().getOnlineShopFacilityData(request);
                if (m1.statusCode == 200) {
                  List<FacilityResponse> facilityResponseList = [];
                  // new List<FacilityResponse>();

                  jsonDecode(m1.statusMsg)['response'].forEach((f) =>
                      facilityResponseList
                          .add(new FacilityResponse.fromJson(f)));

                  facilityResponseList.sort((a, b) =>
                      a.facilityDisplayOrder.compareTo(b.facilityDisplayOrder));
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        //return Profile(Strings.ProfileInitialState);
                        return Healthnbeauty(
                            facilityResponseList[0].facilityGroupName,
                            facilityResponseList,
                            true);
                      },
                    ),
                  );
                }
              },
              icon: Icon(Icons.add_shopping_cart, size: 30, color: Colors.grey),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      //return Profile(Strings.ProfileInitialState);
                      return MyPage();
                    },
                  ),
                );
              },
              icon: Icon(CommonIcons.user_two, size: 25, color: Colors.grey),
            ),

            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      //return Profile(Strings.ProfileInitialState);
                      return ChatBot();
                    },
                  ),
                );
              },
              icon: SvgPicture.asset('assets/images/ic_chatbot.svg',
                  color: Colors.grey),
            ),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () async {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return VRWebviewPage(
                          url: Constants.VRSourceUrl, title: tr("tour_title"));
                    },
                  ),
                );
              },
              icon: Icon(Icons.tour_outlined, size: 24, color: Colors.grey),
            ),
            newNotificationBadge(),
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      //return Profile(Strings.ProfileInitialState);
                      return ProfileNew(Strings.ProfileInitialState);
                    },
                  ),
                );
              },
              icon: Icon(CustomIcons.female_avatar_and_circle22,
                  size: 25, color: Colors.grey),
            ),
          ],
        ),
      );
    } else {
      return Container(
        child: IconButton(
          onPressed: () {},
          icon: Icon(Icons.notifications, size: 25, color: Colors.transparent),
        ),
      );
    }
  }

  trailingIconShow() {
    return Icon(Constants.iSEditClickedInProfile ? editToSave : saveToEdit,
        size: 25, color: Theme.of(context).primaryColor);
  }

  newNotificationBadge() {
    return Stack(
      children: <Widget>[
        IconButton(
          onPressed: () {
            //this is to reset the event chiose chip selection
            Constants.eventsCurrentSelectedChoiseChip = 0;

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return NotificationList();
                },
              ),
            );
          },
          icon: NotificationIcon(),
        ),
      ],
    );
  }
}
