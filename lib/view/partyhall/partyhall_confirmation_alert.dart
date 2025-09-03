// import 'dart:math';
// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:slc/theme/styles.dart';

class PartyHallConfirmationAlert extends StatelessWidget {
  String enquiryId = "";
  int facilityId;
  PartyHallConfirmationAlert({this.enquiryId, this.facilityId});
  @override
  Widget build(BuildContext context) {
    return _PartyHallConfirmationAlert(
        enquiryId: enquiryId, facilityId: this.facilityId);
  }
}

class _PartyHallConfirmationAlert extends StatefulWidget {
  String enquiryId = "";
  int facilityId;
  _PartyHallConfirmationAlert({this.enquiryId, this.facilityId});
  @override
  _PartyHallConfirmationAlertState createState() =>
      _PartyHallConfirmationAlertState(
          enquiryId: enquiryId, facilityId: facilityId);
}

class _PartyHallConfirmationAlertState
    extends State<_PartyHallConfirmationAlert> {
  String enquiryId = "";
  int facilityId;
  _PartyHallConfirmationAlertState({this.enquiryId, this.facilityId});
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Alert();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(100.0),
        //   child: CustomAppBar(
        //     title: tr('thanks_page'),
        //   ),
        // ),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          title: Text(tr('thanks_page'),
              style: TextStyle(color: Colors.blue[200])),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        FacilityDetailsPage(facilityId: facilityId)),
              );
            },
          ),
          backgroundColor: Colors.white,
        ),
        body:
            // SingleChildScrollView(
            //   child:
            Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/beachorder.png"),
                  fit: BoxFit.cover)),
          height: MediaQuery.of(context).size.height * 0.99,
          width: MediaQuery.of(context).size.width * 0.99,
          // color: Color(0xFFF0F8FF),
          child: Container(
            margin: EdgeInsets.only(right: 10, left: 10),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20),
                  height: 100,
                  child: MaterialButton(
                    shape: CircleBorder(
                        side: BorderSide(
                            width: 2,
                            color: Colors.green,
                            style: BorderStyle.solid)),
                    child: Icon(
                      Icons.check,
                      color: Colors.green,
                      size: 30,
                    ),
                    color: Colors.lightGreen[100],
                    textColor: Colors.amber,
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FacilityDetailsPage(
                                  facilityId: facilityId,
                                )),
                      );
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    tr('yourEnquirySubmitted'),
                    style: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0),
                        fontSize: Styles.textSizRegular,
                        fontFamily: tr('currFontFamily')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    tr('yourTransactionNo'),
                    style: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0),
                        fontSize: Styles.textSizeSmall,
                        fontFamily: tr('currFontFamily')),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Text(
                    widget.enquiryId != null ? widget.enquiryId : "",
                    style: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0),
                        fontSize: Styles.textSizeSmall,
                        fontFamily: tr('currFontFamily')),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    // );
  }
}
