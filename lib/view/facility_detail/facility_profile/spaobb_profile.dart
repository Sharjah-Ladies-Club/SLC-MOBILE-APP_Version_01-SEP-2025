import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_details/event_details.dart';
import 'package:slc/view/obb_spa/my_consultation.dart';

bool isExpanded = false;

// ignore: must_be_immutable
class SpaOBBProfile extends StatelessWidget {
  SLCMemberships slcMembership;
  List<FacilityMembership> facilityMembership;
  MembershipClassAvailDto classAvailablity;
  String colorCode;
  int facilityId;
  bool isShopClosed;
  bool showViewConsultation;

  SpaOBBProfile(
      {this.slcMembership,
      this.facilityMembership,
      this.classAvailablity,
      this.colorCode,
      this.facilityId,
      this.isShopClosed,
      this.showViewConsultation = false});

  @override
  Widget build(BuildContext context) {
    debugPrint("FFFFFF" + facilityId.toString());
    return SpaOBBProfilePage(
        slcMembership,
        facilityMembership,
        classAvailablity,
        colorCode,
        facilityId,
        isShopClosed,
        showViewConsultation);
  }
}

// ignore: must_be_immutable
class SpaOBBProfilePage extends StatefulWidget {
  SLCMemberships slcMembership;
  List<FacilityMembership> facilityMembership;
  MembershipClassAvailDto classAvailablity;
  String colorCode;
  int facilityId;
  AutoScrollController scrlController;
  int selectedIndex = -1;
  int selectedHeadIndex = -1;
  int listIndex = -1;
  bool isShopClosed = false;
  bool ismainExpanded = false;
  bool showViewConsultation;
  Key key = PageStorageKey("100000000001");
  Utils util = new Utils();
  SpaOBBProfilePage(
      this.slcMembership,
      this.facilityMembership,
      this.classAvailablity,
      this.colorCode,
      this.facilityId,
      this.isShopClosed,
      this.showViewConsultation);

  @override
  State<StatefulWidget> createState() {
    return SpaOBBProfilePageState();
  }
}

class SpaOBBProfilePageState extends State<SpaOBBProfilePage> {
  Utils util = Utils();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    debugPrint("This is Test FM:::::::::::::::::::::::::::::" +
        widget.facilityMembership.length.toString());
    debugPrint("This is Test FacilityID:::::::::::::::::::::::::::::" +
        widget.facilityId.toString());
    List<FacilityMembership> newLst = widget.facilityMembership;
    List<FacilityMembership> cuLst = widget.facilityMembership;
    FacilityMembership fa = new FacilityMembership();

    if (newLst != null && newLst.length > 0) {
      fa = newLst[0];
    } else if (cuLst != null && cuLst.length > 0) {
      fa = cuLst[0];
    }
    return Container(
      margin: const EdgeInsets.only(
          top: 15.0, left: 15.0, right: 15.0, bottom: 10.0),
      width: 400,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.25,
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/fmcardbg.jpeg',
                  fit: BoxFit.cover,
                ),
                Padding(
                    padding: EdgeInsets.only(top: 20, left: 8, right: 8),
                    child: Row(
                      children: [
                        Text(
                          fa != null ? fa.membershipName : tr('dalouk_guest'),
                          style: TextStyle(
                              color: ColorData.fitnessFacilityColor,
                              fontSize: Styles.textSizeSeventeen,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "",
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: Styles.textSizeSmall,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 8),
                        width: 75,
                        height: 75,
                        child: Material(
                          color: Colors.white,
//                      elevation: 1.0,
                          shape: CircleBorder(),
                          child: Container(
                            decoration: new BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border:
                                  Border.all(width: 3.0, color: Colors.white10),
                            ),
                            padding: EdgeInsets.all(3.0),
                            // need to change image
                            child: Container(
                              child: fa != null &&
                                      fa.profileImage != null &&
                                      fa.profileImage != ""
                                  ? CircleAvatar(
                                      radius: 30.0,
                                      backgroundImage:
                                          NetworkImage(fa.profileImage),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : CircleAvatar(
                                      child: Icon(
                                        AccountIcon.account_type,
                                        color: const Color(0xFF3EB5E3),
                                        size: 70,
                                      ),
                                      radius: 40.0,
                                      backgroundColor: Colors.white,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: screenWidth * 0.52,
                        height: screenHeight * 0.16,
                        margin: EdgeInsets.only(left: 30, right: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(top: 20)),
                            Text(
                              (fa.customerName != null) ? fa.customerName : "",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.textSizeSmall,
                                  fontWeight: FontWeight.bold),
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            Text(
                              (fa.membershipId != null && fa.membershipId > 0)
                                  ? tr("membership_number") +
                                      " : " +
                                      fa.membershipId.toString()
                                  : "",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 5)),
                            Text(
                              (fa.membershipId != null && fa.membershipId > 0)
                                  ? tr('customer_id') +
                                      " : " +
                                      fa.customerId.toString()
                                  : "",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 5)),
                            Text(
                              (fa.membershipId != null && fa.membershipId > 0)
                                  ? tr("valid_upto") +
                                      " : " +
                                      DateTimeUtils().dateToStringFormat(
                                          DateTimeUtils().stringToDate(
                                              fa.endDate,
                                              DateTimeUtils.ServerFormat),
                                          DateTimeUtils.DD_MMM_YYYY_Format)
                                  : "",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.packageExpandTextSiz),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Align(
                //   alignment: Alignment.centerRight,
                //   child:
                // ),
              ],
            ),
          ),
          Visibility(
              visible: widget.showViewConsultation &&
                      (widget.facilityId == 1 || widget.facilityId == 2)
                  ? true
                  : false,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyConsultation(
                                  facilityId: widget.facilityId,
                                  colorCode: widget.colorCode,
                                )));
                  },
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          widget.colorCode == null
                              ? Colors.blue[200]
                              : ColorData.toColor(widget.colorCode)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      )))),
                  child: Text(tr('view_consult')))),
          // widget.classAvailablity.showBuyButton
          //     ? SizedBox(
          //         child: new OutlinedButton(
          //           style: ButtonStyle(
          //               foregroundColor:
          //                   MaterialStateProperty.all<Color>(Colors.white),
          //               // backgroundColor: MaterialStateProperty.all<Color>(
          //               //     ColorData.toColor(widget.colorCode)),
          //               shape:
          //                   MaterialStateProperty.all<RoundedRectangleBorder>(
          //                       RoundedRectangleBorder(
          //                           borderRadius: BorderRadius.all(
          //                 Radius.circular(10.0),
          //               )))),
          //           onPressed: () {
          //             if (!widget.isShopClosed) {
          //               debugPrint("HHHHHHHHHHHHHHHHHHHHHHHHHHH" +
          //                   widget.facilityId.toString());
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => FitnessMembershipPage(
          //                         memID:
          //                             widget.facilityMembership[0].membershipId,
          //                         memName: widget
          //                             .facilityMembership[0].membershipCategory,
          //                         abcID:
          //                             widget.facilityMembership[0].customerId,
          //                         validity:
          //                             widget.facilityMembership[0].endDate,
          //                         facilityId: widget.facilityId,
          //                         colorCode: "A81B8D",
          //                         moduleId: widget.facilityId == 3
          //                             ? 11
          //                             : widget.facilityId == 2
          //                                 ? 12
          //                                 : widget.facilityId == 1
          //                                     ? 13
          //                                     : 0)),
          //               );
          //             } else {
          //               Utils util = new Utils();
          //               util.customGetSnackBarWithOutActionButton(
          //                   tr("shopclosed"), tr("shopmaintenance"), context);
          //             }
          //           },
          //           child: new Text(
          //             tr('buy_membership'),
          //             style: TextStyle(color: ColorData.fitnessFacilityColor),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //       )
          SizedBox(
              child: Text(
                  Localizations.localeOf(context).languageCode == "ar"
                      ? widget.classAvailablity.aR_MSG
                      : widget.classAvailablity.eN_MSG,
                  style: TextStyle(color: ColorData.fitnessFacilityColor),
                  textAlign: TextAlign.center))
        ],
      ),
    );
    // return getFacilityProfileScreen(widget.facilityMembership[0]);
  }

  Widget getFacilityProfileScreen(FacilityMembership description) {
    return SingleChildScrollView(
        padding: const EdgeInsets.only(
            top: 25.0, left: 15.0, right: 15.0, bottom: 10.0),
        child: Container(
          height: screenHeight * 0.3,
          width: 500,
          color: Colors.red,
          child: Image.asset(
            'assets/images/setambg.png',
            fit: BoxFit.cover,
          ),
        ));
  }
}
