// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/model/facility_response.dart';
// import 'package:slc/theme/colors.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';

import 'package:slc/view/fitness/gymentry.dart';
import 'package:slc/view/fitness/passes.dart';
import 'package:slc/view/fitness/personaltraining.dart';
import 'package:slc/view/fitness/timetables.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';

import '../../common/colors.dart';
import '../../gmcore/storage/SPUtils.dart';
import '../../utils/constant.dart';
import '../../utils/utils.dart';

class FitnessPage extends StatelessWidget {
  int facilityId;
  String colorCode;
  String appBarTitle;
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailDetail;
  int haveFitnessMemberShip;
  bool shop = false;

  FitnessPage(
      {this.facilityId = 3,
      this.colorCode,
      this.facilityMemberShip,
      this.haveFitnessMemberShip = 0,
      this.classAvailDetail,
      this.shop});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessBloc>(
      create: (context) =>
          FitnessBloc(null)..add(GetMembershipDetails(facilityId: facilityId)),
      child: Fitness(appBarTitle, shop, facilityMemberShip, classAvailDetail,
          haveFitnessMemberShip, colorCode),
    );
  }
}

class Fitness extends StatefulWidget {
  String appBarTitle;
  List<FitnessActivity> fitnessActivity;
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailDetail;
  int haveFitnessMemberShip;
  String colorCode;
  bool shop = false;
  Fitness(this.appBarTitle, this.shop, this.facilityMemberShip,
      this.classAvailDetail, this.haveFitnessMemberShip, this.colorCode);
  @override
  State<Fitness> createState() => _FitnessState();
}

class _FitnessState extends State<Fitness> {
  List<FitnessActivity> fitnessActivity;
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailDetail;
  int haveFitnessMemberShip;
  List<String> facilityImg = [
    'assets/images/gym_menu.jpeg',
    'assets/images/class_menu.jpeg',
    'assets/images/body_menu.jpeg',
    'assets/images/steam_menu.jpeg',
    'assets/images/pt_menu.jpeg',
    'assets/images/voucher_menu.jpeg',
  ];

  ProgressBarHandler _handler;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("On Fitness Page;;;;" + widget.colorCode);
    FitnessActivity f1 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 1,
        fitnessActivityName: "Gym Use",
        fitnessActivityImageURL: "assets/images/gym_menu.jpeg",
        colorCode: widget.colorCode);
    FitnessActivity f2 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 2,
        fitnessActivityName: "Join a class",
        fitnessActivityImageURL: "assets/images/class_menu.jpeg",
        colorCode: widget.colorCode);
    FitnessActivity f3 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 2,
        fitnessActivityName: "Body Assesment",
        fitnessActivityImageURL: "assets/images/body_menu.jpeg",
        colorCode: widget.colorCode);
    FitnessActivity f4 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 2,
        fitnessActivityName: "Steam and Suna",
        fitnessActivityImageURL: "assets/images/schedules.png",
        colorCode: widget.colorCode);
    FitnessActivity f5 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 2,
        fitnessActivityName: "PT Sessions",
        fitnessActivityImageURL: "assets/images/schedules.png",
        colorCode: widget.colorCode);
    FitnessActivity f6 = new FitnessActivity(
        facilityId: 3,
        fitnessActivityId: 2,
        fitnessActivityName: "Vouchers",
        fitnessActivityImageURL: "assets/images/schedules.png",
        colorCode: widget.colorCode);
    if (widget.fitnessActivity == null) {
      widget.fitnessActivity = [];
    }
    widget.fitnessActivity.clear();
    widget.fitnessActivity.add(f1);
    widget.fitnessActivity.add(f2);
    widget.fitnessActivity.add(f3);
    widget.fitnessActivity.add(f4);
    widget.fitnessActivity.add(f5);
    widget.fitnessActivity.add(f6);
    Utils util = new Utils();
    BuildContext ctxt = context;

    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is FitnessShowProgressBar) {
            _handler.show();
          } else if (state is FitnessHideProgressBar) {
            _handler.dismiss();
          } else if (state is GetMembershipState) {
            if (state.classAvailablity != null) {
              widget.classAvailDetail = state.classAvailablity;
              haveFitnessMemberShip =
                  widget.classAvailDetail.haveFitnessMemberShip;
            }
            if (state.facilityMembership != null &&
                SPUtil.getInt(Constants.USER_CUSTOMERID) == 0) {
              widget.facilityMemberShip = state.facilityMembership;
              widget.classAvailDetail = state.classAvailablity;
              if (widget.facilityMemberShip != null &&
                  widget.facilityMemberShip.length > 0) {
                SPUtil.putInt(Constants.USER_CUSTOMERID,
                    widget.facilityMemberShip[0].customerId);
              }
            }
          }
        },
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))),
            automaticallyImplyLeading: true,
            title: Text(
              tr("fitness_title"),
              style: TextStyle(color: ColorData.colorBlue),
              textAlign: TextAlign.center,
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              color: Colors.blue[200],
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FacilityDetailsPage(
                      facilityId: 3,
                    ),
                  ),
                );
              },
            ),
          ),
          // appBar: PreferredSize(
          //   preferredSize: Size.fromHeight(63.0),
          //   child: Column(
          //     children: <Widget>[
          //       CustomAppBar(
          //         title: "Fitness 180",
          //       ),
          //     ],
          //   ),
          // ),
          backgroundColor: ColorData.whiteColor,
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/fitness_bg.png"),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: GridView(
                scrollDirection: Axis.vertical,
                physics: ClampingScrollPhysics(),
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: 0.9,
                    maxCrossAxisExtent: 300),
                children: List.generate(6, (index) {
                  return GestureDetector(
                    onTap: () {
                      if (widget.classAvailDetail != null &&
                          widget.classAvailDetail.isCustomerBlocked == 1) {
                        util.customGetSnackBarWithOutActionButton(
                            tr('info_msg'),
                            Localizations.localeOf(context).languageCode == "ar"
                                ? widget.classAvailDetail.aR_MSG
                                : widget.classAvailDetail.eN_MSG,
                            context);
                        return false;
                      }

                      if (index == 6 && widget.haveFitnessMemberShip <= 1) {
                        util.customGetSnackBarWithOutActionButton(
                            tr('info_msg'),
                            tr("passes_not_avaial_for_your_membership"),
                            ctxt);
                        // } else if (index == 3 &&
                        //     widget.classAvailDetail.steamSauna == 0) {
                        //   util.customGetSnackBarWithOutActionButton(
                        //       tr('info_msg'),
                        //       tr("suna_not_avaial_for_your_membership"),
                        //       ctxt);
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => index == 0
                                    ? GymEntryPage(
                                        screenType: 1,
                                        haveFitnessMemberShip:
                                            haveFitnessMemberShip,
                                        facilityMembers:
                                            widget.facilityMemberShip,
                                        classAvailability:
                                            widget.classAvailDetail,
                                        gateCode: 9,
                                        colorCode: widget.colorCode,
                                      )
                                    : index == 1
                                        ? TimeTableListPage()
                                        : index == 2
                                            ? PersonalTrainingPage(
                                                screenType: 2,
                                                colorCode: widget.colorCode)
                                            : index == 3
                                                ? GymEntryPage(
                                                    screenType: 2,
                                                    haveFitnessMemberShip:
                                                        haveFitnessMemberShip,
                                                    facilityMembers: widget
                                                        .facilityMemberShip,
                                                    classAvailability:
                                                        widget.classAvailDetail,
                                                    gateCode: 10,
                                                    colorCode: widget.colorCode,
                                                  )
                                                : index == 4
                                                    ? PersonalTrainingPage(
                                                        screenType: 1,
                                                        colorCode:
                                                            widget.colorCode)
                                                    : Passes()));
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 10.0, top: 10.0),
                      child: Center(
                        child: GridTile(
                          child: Image.asset(
                            facilityImg[index],
                          ),
                          // child:Image.asset(widget.facilityResponseList[index].facilityImageURL)
                        ),
                      ),
                      // color: Colors.blue[400],
                      margin: EdgeInsets.all(1.0),
                    ),
                  );
                }),
              ),
            ),
          ),
        )));
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
//              colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn)
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 30.0, width: 30.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
