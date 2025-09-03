// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/fitness/traineerprofile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/theme/styles.dart';
import '../../gmcore/storage/SPUtils.dart';
import '../../utils/constant.dart';
import '../facility_detail/facility_content/facility_fitness/facility_fitness_diet.dart';
import '../facility_detail/facility_content/facility_fitness/facility_fitness_workout.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'fitnessbuy/fitnessbuy_page.dart';

class PersonalTrainingPage extends StatelessWidget {
  int screenType;
  String colorCode;
  PersonalTrainingPage({this.screenType = 1, this.colorCode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FitnessBloc>(
      create: (context) => FitnessBloc(null)
        ..add(GetMembershipDetails(facilityId: 3))
        ..add(GetAppDescEvent(descId: screenType == 1 ? 4 : 2))
        ..add(GetPTBookingsEvent(
            classDate: DateTimeUtils().dateToStringFormat(
                DateTime.now(), DateTimeUtils.YYYY_MM_DD_Format),
            screenCode: screenType == 1 ? 5 : 6)),
      child: PersonalTraining(
        screenType: screenType,
        colorCode: colorCode,
      ),
    );
  }
}

class PersonalTraining extends StatefulWidget {
  int screenType;
  String colorCode;
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailablity;
  PersonalTraining(
      {this.screenType = 1,
      this.facilityMemberShip,
      this.classAvailablity,
      this.colorCode});
  @override
  State<PersonalTraining> createState() => _PersonalTrainingState();
}

class _PersonalTrainingState extends State<PersonalTraining>
    with TickerProviderStateMixin {
  TabController tabController;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  DateTime date = DateTime.now();
  // DateTime _selectedDate = DateTime.now();
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailablity;
  ProgressBarHandler _handler;
  int facilityId = 3;
  MyPackageBookingViewDto viewDto = new MyPackageBookingViewDto();
  String moduleDescription = "";
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(
        length: widget.screenType == 1 ? 2 : 1, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is FitnessShowProgressBar) {
            _handler.show();
          } else if (state is FitnessHideProgressBar) {
            _handler.dismiss();
          } else if (state is GetPTBookingsEventState) {
            viewDto = state.ptData;
            setState(() {});
          } else if (state is GetMembershipState) {
            if (state.facilityMembership != null &&
                SPUtil.getInt(Constants.USER_CUSTOMERID) == 0) {
              widget.facilityMemberShip = state.facilityMembership;
              widget.classAvailablity = state.classAvailablity;
              if (widget.facilityMemberShip != null &&
                  widget.facilityMemberShip.length > 0) {
                SPUtil.putInt(Constants.USER_CUSTOMERID,
                    widget.facilityMemberShip[0].customerId);
              }
            }
          } else if (state is GetAppDescState) {
            if (state.result != null) {
              moduleDescription =
                  Localizations.localeOf(context).languageCode == "en"
                      ? state.result.descEn
                      : state.result.descAr;
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorData.backgroundColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr("fitness_title"),
              ),
            ),
            body: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.3,
                  child: Image.asset(
                    widget.screenType == 1
                        ? 'assets/images/ptbg.png'
                        : "assets/images/bodybg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 2,
                  width: double.infinity,
                  color: ColorData.fitnessFacilityColor,
                ),
                Container(
                    height: screenWidth * 0.10,
                    width: double.infinity,
                    color: ColorData.fitnessBgColor,
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                    child: Text(
                        widget.screenType == 1
                            ? tr('pt_sessions')
                            : tr('body_assessment'),
                        style: TextStyle(
                            fontSize: Styles.textSizeSeventeen,
                            color: ColorData.fitnessFacilityColor,
                            fontWeight: FontWeight.bold))),
                Container(
                    height: screenWidth * 0.20,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    color: ColorData.whiteColor,
                    padding:
                        EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 8),
                    child: SingleChildScrollView(
                        child: Text(
                      moduleDescription != null
                          ? moduleDescription
                          : tr("voucher_desc"),
                      // widget.screenType == 1
                      //     ? tr("pt_description")
                      //     : tr("ba_description"),
                      style: TextStyle(
                          fontSize: Styles.packageExpandTextSiz,
                          color: ColorData.primaryTextColor),
                    ))),
                Container(
                  color: widget.screenType == 1
                      ? Colors.transparent
                      : ColorData.fitnessBgColor,
                  child: TabBar(
                    controller: tabController,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    onTap: (index) {
                      setState(() {});
                    },
                    tabs: [
                      Tab(
                          child: Container(
                              color: tabController.index == 0
                                  ? ColorData.fitnessBgColor
                                  : ColorData.whiteColor,
                              alignment: Alignment.center,
                              child: Text(
                                tr('current_booking'),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.fitnessFacilityColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                      Visibility(
                          visible: widget.screenType == 1 ? true : false,
                          child: Tab(
                            child: Container(
                                color: tabController.index == 1
                                    ? ColorData.fitnessBgColor
                                    : ColorData.whiteColor,
                                alignment: Alignment.center,
                                child: Text(
                                  tr('my_packages'),
                                  style: TextStyle(
                                      fontSize: Styles.textSizeSmall,
                                      color: ColorData.fitnessFacilityColor,
                                      fontWeight: FontWeight.bold),
                                )),
                          )),
                    ],
                  ),
                ),
                Container(
                  height: screenHeight * 0.28,
                  color: Colors.yellow,
                  child: TabBarView(
                    controller: tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Container(
                        height: screenHeight * 0.28,
                        width: screenWidth,
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    color: ColorData.fitnessBgColor))),
                        child: CurrentBookings(),
                        // color: Colors.blue,
                      ),
                      Visibility(
                          visible: widget.screenType == 1 ? true : false,
                          child: Container(
                            height: screenHeight * 0.28,
                            width: screenWidth,
                            decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                        color: ColorData.fitnessBgColor))),
                            child: MyPackages(),
                            // color: Colors.grey,
                          ))
                    ],
                  ),
                ),
                Container(
                  height: 1,
                  width: screenWidth,
                  color: ColorData.fitnessBgColor,
                ),
              ],
            ),
            bottomNavigationBar: widget.screenType == 1
                ? Container(
                    padding: EdgeInsets.only(bottom: 8),
                    color: ColorData.whiteColor,
                    height: screenHeight * 0.08,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        OutlinedButton.icon(
                          // <-- OutlinedButton

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FacilityDiet(
                                  facilityId: 3,
                                  colorCode: widget.colorCode,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: ColorData.fitnessFacilityColor,
                            // backgroundColor:
                            //     ColorData.toColor(widget.colorCode),
                            // side: BorderSide(
                            //     width: 1.0, color: ColorData.fitnessFacilityColor),
                          ),
                          icon: Icon(
                            Icons.food_bank_outlined,
                            size: 20.0,
                            color: ColorData.whiteColor,
                          ),
                          label: Text(tr('diet'),
                              style: TextStyle(
                                fontSize: Styles.loginBtnFontSize,
                                color: ColorData.whiteColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton.icon(
                          // <-- OutlinedButton

                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FacilityWorkout(
                                  facilityId: 3,
                                  colorCode: widget.colorCode,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: ColorData.fitnessFacilityColor,
                            // backgroundColor:
                            //     ColorData.toColor(widget.colorCode),
                            // side: BorderSide(
                            //     width: 1.0, color: ColorData.fitnessFacilityColor),
                          ),
                          icon: Icon(
                            Icons.video_file_outlined,
                            size: 20.0,
                            color: ColorData.whiteColor,
                          ),
                          label: Text(tr('videos'),
                              style: TextStyle(
                                fontSize: Styles.loginBtnFontSize,
                                color: ColorData.whiteColor,
                              )),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton.icon(
                          // <-- OutlinedButton
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FitnessBuyPage(
                                        facilityId: 3,
                                        retailItemSetId: "0",
                                        facilityItems: [],
                                        colorCode: widget.colorCode,
                                        pageToNavigate: 1,
                                        moduleId: 4,
                                      )),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: ColorData.fitnessFacilityColor,
                            // backgroundColor:
                            //     ColorData.toColor(widget.colorCode),
                            // side: BorderSide(
                            //     width: 1.0, color: ColorData.fitnessFacilityColor),
                          ),
                          icon: Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 20.0,
                            color: ColorData.whiteColor,
                          ),
                          label: Text(tr('buy_package'),
                              style: TextStyle(
                                fontSize: Styles.loginBtnFontSize,
                                color: ColorData.whiteColor,
                              )),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ),
        ));
  }

  Widget CurrentBookings() {
    return Container(
      height: screenHeight * 0.10,
      width: double.infinity,
      color: ColorData.whiteColor,
      child: (viewDto == null || viewDto.spaceSlots == null)
          ? Align(
              alignment: Alignment.center, child: Text(tr("no_class_schedule")))
          : ListView.separated(
              itemCount: viewDto.spaceSlots.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 0, right: 0, top: 8),
              itemBuilder: (BuildContext context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(bottom: 4, left: 4, right: 4),
                      dense: true,
                      visualDensity:
                          VisualDensity(horizontal: -4.0, vertical: -4.0),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.calendar_month_outlined,
                            color: ColorData.fitnessBgColor,
                          ),
                        ],
                      ),
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateTimeUtils().dateToStringFormat(
                                DateTimeUtils().stringToDate(
                                    viewDto.spaceSlots[index].classDate,
                                    DateTimeUtils.ServerFormat),
                                DateTimeUtils.DD_MMM_YYYY_Format),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateTimeUtils().dateToStringFormat(
                                    DateTimeUtils().stringToDate(
                                        viewDto.spaceSlots[index].classDate,
                                        DateTimeUtils.ServerFormat),
                                    DateTimeUtils.DDD_format) +
                                "-" +
                                viewDto.spaceSlots[index].classStartTime,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.primaryTextColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: SizedBox(
                        // color: Colors.red,
                        width: screenWidth * 0.38,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.wallet_membership,
                              color: ColorData.fitnessBgColor,
                              size: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                viewDto.spaceSlots[index].status,
                                style: TextStyle(
                                    fontSize: Styles.packageExpandTextSiz,
                                    color: ColorData.fitnessFacilityColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding:
                          EdgeInsets.only(bottom: 4, left: 4, right: 4),
                      dense: true,
                      visualDensity:
                          VisualDensity(horizontal: -4.0, vertical: -4.0),
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.person,
                            color: ColorData.fitnessBgColor,
                            size: 28,
                          ),
                        ],
                      ),
                      title: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => FitnessTrainersProfile(
                          //             trainerId: viewDto
                          //                 .spaceSlots[index].classTrainerID,
                          //             classDate: DateTimeUtils()
                          //                 .stringToDate(
                          //                     viewDto
                          //                         .spaceSlots[index].classDate,
                          //                     DateTimeUtils.ServerFormat)
                          //                 .toString())));
                        },
                        child: Text(viewDto.spaceSlots[index].classTrainerName,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      // trailing: SizedBox(
                      //   // color: Colors.red,
                      //   width: screenWidth * 0.38,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Icon(
                      //         Icons.timer_outlined,
                      //         color: ColorData.fitnessBgColor,
                      //         size: 16,
                      //       ),
                      //       Padding(
                      //         padding: EdgeInsets.only(left: 10, right: 10),
                      //         child: Text(
                      //           viewDto.spaceSlots[index].classEndTime,
                      //           style: TextStyle(
                      //               fontSize: Styles.packageExpandTextSiz,
                      //               color: ColorData.fitnessFacilityColor,
                      //               fontWeight: FontWeight.bold),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
              ),
            ),
    );
  }

  Widget MyPackages() {
    return Container(
      height: screenHeight * 0.10,
      width: double.infinity,
      color: ColorData.whiteColor,
      child: (viewDto == null ||
              viewDto.packageDetails == null ||
              viewDto.packageDetails.length == 0)
          ? Align(
              alignment: Alignment.center, child: Text(tr("no_packages_found")))
          : ListView.separated(
              itemCount: viewDto.packageDetails.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 0, right: 0, top: 8),
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  minLeadingWidth: 0,
                  contentPadding: EdgeInsets.all(0),
                  leading: SizedBox(
                    width: screenWidth * 0.10,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.card_giftcard_sharp,
                        color: ColorData.fitnessBgColor,
                      ),
                    ),
                  ),
                  title: SizedBox(
                    width: screenWidth * 0.60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(viewDto.packageDetails[index].packageName,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                        Text(
                          "Expire on :" +
                              DateTimeUtils().dateToStringFormat(
                                  DateTimeUtils().stringToDate(
                                      viewDto.packageDetails[index].expires
                                          .substring(0, 10),
                                      DateTimeUtils.M_DD_YYYY),
                                  DateTimeUtils.DD_MM_YYYY_Format),
                          style: TextStyle(
                              fontSize: Styles.packageExpandTextSiz,
                              color: ColorData.primaryTextColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  trailing: SizedBox(
                    width: screenWidth * 0.30,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.reduce_capacity,
                          color: ColorData.fitnessBgColor,
                          size: 16,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(tr("available"),
                                  style: Styles.textSmallPurple),
                              Text(
                                viewDto.packageDetails[index].consumed != null
                                    ? viewDto.packageDetails[index].consumed
                                        .toString()
                                    : "-" +
                                                '/' +
                                                viewDto.packageDetails[index]
                                                    .totalPackageCount
                                                    .toString() !=
                                            null
                                        ? viewDto.packageDetails[index].consumed
                                            .toString()
                                        : "-",
                                style: Styles.textDefaultPurpleWithBold,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
              ),
            ),
    );
  }
}
