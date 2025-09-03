import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/view/obb_spa/bloc/bloc.dart';

import '../../common/colors.dart';
import '../../model/obb_recommendation_response.dart';
import '../../theme/styles.dart';
import '../../utils/utils.dart';
import 'my_recommendation.dart';

class MyConsultation extends StatelessWidget {
  int facilityId;
  String colorCode;
  MyConsultation({this.facilityId, this.colorCode});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        // create: (context) =>
        //     BeachBloc(beachBloc: BlocProvider.of<BeachBloc>(context))..add(new GetOrderStatusEvent(
        //         merchantReferenceNo: merchantReferenceNo))
        create: (context) {
          return ObbConsultBloc(obbConsultBloc: null)
            ..add(new GetRecommendationEvent(facilityId: facilityId));
        },
        child: _MyConsultation(
          facilityId: facilityId,
          colorCode: colorCode,
        ),
      ),
    );
  }
}

class _MyConsultation extends StatefulWidget {
  final int facilityId;
  final String colorCode;
  _MyConsultation({this.facilityId, this.colorCode});
  @override
  State<_MyConsultation> createState() => _MyConsultationState();
}

class _MyConsultationState extends State<_MyConsultation> {
  List<Recommendation> recommendation = [];
  double sWidth = 0.0, sHeight = 0.0;
  String logo = '';

  bool load = false;

  Utils util = Utils();

  @override
  void initState() {
    logo = 'assets/images/${widget.facilityId}_logo.png';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sWidth = MediaQuery.of(context).size.width;
    sHeight = MediaQuery.of(context).size.height;
    return BlocListener<ObbConsultBloc, ObbConsultState>(
      listener: (context, state) async {
        if (state is GetRecommendationState) {
          if (state.recommendation != null) {
            setState(() {
              recommendation = state.recommendation;
            });
          }
          setState(() {
            load = true;
          });
        }

        if (state is OnFailure) {
          setState(() {
            load = true;
          });
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: ColorData.backgroundColor,
          appBar: AppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            automaticallyImplyLeading: true,
            title: Text(tr('recommendations'),
                style: TextStyle(color: Colors.blue[200])),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blue[200],
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.white,
          ),
          body: load
              ? recommendation.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: recommendation.length,
                      itemBuilder: (BuildContext context, int index) {
                        DateTime dateTime = widget.facilityId == 1
                            ? recommendation[index].spa_ReceiptDate != null &&
                                    recommendation[index]
                                        .spa_ReceiptDate
                                        .isNotEmpty
                                ? DateTime.parse(
                                    recommendation[index].spa_ReceiptDate)
                                : DateTime.now()
                            : recommendation[index].obb_ReceiptDate != null &&
                                    recommendation[index]
                                        .obb_ReceiptDate
                                        .isNotEmpty
                                ? DateTime.parse(
                                    recommendation[index].obb_ReceiptDate)
                                : DateTime.now();
                        String date = DateFormat('MMM dd yyyy')
                            .format(dateTime)
                            .toString();
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyRecommendation(
                                        facilityId: widget.facilityId,
                                        recommendationId: recommendation[index]
                                            .recommendationID,
                                        colorCode: widget.colorCode,
                                        userInfoId:
                                            recommendation[index].userInfoId)));
                          },
                          child: ObbRecommendation(
                            date: date,
                            followUp:
                                recommendation[index].followUpTreatment ?? "-",
                            nextVisit: recommendation[index].nextVisit ?? "-",
                            by: recommendation[index].therapistName ?? "-",
                            logo: logo,
                          ),
                        );
                      })
                  : Center(
                      child: Text(tr('noDataFound'),
                          // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: Styles.loginBtnFontSize,
                            fontFamily: tr('currFontFamily'),
                            color: ColorData.primaryTextColor,
                          )),
                    )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}

class ObbRecommendation extends StatelessWidget {
  final String date, logo, followUp, nextVisit, by;
  const ObbRecommendation(
      {this.date, this.logo, this.followUp, this.nextVisit, this.by});

  @override
  Widget build(BuildContext context) {
    double sWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: Localizations.localeOf(context).languageCode == "en"
                ? EdgeInsets.only(left: 10, top: 10, bottom: 6)
                : EdgeInsets.only(right: 10, top: 10, bottom: 6),
            child: Text(date,
                // overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: Styles.loginBtnFontSize,
                  fontWeight: FontWeight.w500,
                  fontFamily: tr('currFontFamily'),
                  color: ColorData.primaryTextColor,
                )),
          ),
          Card(
            margin: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Image.asset(
                    logo,
                    width: sWidth * 0.25,
                  ),
                ),
                Container(
                  width: sWidth * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(tr("service_recommend"),
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Styles.loginBtnFontSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: tr('currFontFamily'),
                              color: ColorData.primaryTextColor,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(tr("follow_up") + ": " + followUp ?? "-",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Styles.loginBtnFontSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: tr('currFontFamily'),
                              color: ColorData.primaryTextColor,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(tr("next_visit") + ": " + nextVisit ?? "-",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Styles.loginBtnFontSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: tr('currFontFamily'),
                              color: ColorData.primaryTextColor,
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 4, bottom: 8),
                        child: Text(tr("by") + ": " + by ?? "-",
                            // overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: Styles.loginBtnFontSize,
                              fontWeight: FontWeight.w500,
                              fontFamily: tr('currFontFamily'),
                              color: ColorData.primaryTextColor,
                            )),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_outlined,
                    size: 18, color: Colors.grey)
              ],
            ),
          )
        ],
      ),
    );
  }
}
