// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
// import 'package:table_calendar/table_calendar.dart';

import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/customCalendar.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:slc/view/fitness/classbooking.dart';
import 'package:slc/view/fitness/traineerprofile.dart';

import '../../model/transaction_response.dart';

class TimeTableListPage extends StatelessWidget {
  DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FitnessBloc>(
              create: (context) => FitnessBloc(null)
                ..add(GetMembershipDetails(facilityId: 3))
                ..add(GetTrainersProfileEvent(
                    trainerId: 0,
                    fromDate: DateTimeUtils().dateToStringFormat(
                        selectedDate, DateTimeUtils.YYYY_MM_DD_Format)))),
        ],
        child: TimeTableList(selectedDate: selectedDate),
      ),
    );
  }
}

class TimeTableList extends StatefulWidget {
  @override
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailablity;
  DateTime selectedDate;
  TimeTableList(
      {this.facilityMemberShip, this.classAvailablity, this.selectedDate});
  State<TimeTableList> createState() => _TimeTableListState();
}

class _TimeTableListState extends State<TimeTableList>
    with TickerProviderStateMixin {
  double carouselHeight = 0.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // CalendarController _controller = new CalendarController();
  List<TimeTable> currentSlots = [];
  //String selectedDate = "";
  ScrollController controller = ScrollController();
  TabController tabController;
  int selectedIndex = 0;
  int tolLength = 0;
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  PageController pgcontroller = PageController(viewportFraction: 0.2);
  List<TrainerProfile> fitnessTrainers;
  ClassTimeTable timeTable = new ClassTimeTable();
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailablity;
  DateTime selectedDate;
  @override
  void initState() {
    // TODO: implement initState
    tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }
  // TabController tabController = new TabController(length: 2, vsync: vsync)

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 55);
    carouselHeight = Platform.isIOS
        ? screenHeight * (50.0 / 100.0)
        : screenHeight * (47.0 / 100.0);
    screenWidth = MediaQuery.of(context).size.width;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) {
          if (state is ShowFitnessProgressBarState) {
            _handler.show();
          } else if (state is HideFitnessProgressBarState) {
            _handler.dismiss();
          } else if (state is GetTrainersProfileState) {
            fitnessTrainers = state.fitnessTimeTable.trainersProfile;
            timeTable = state.fitnessTimeTable;
            tolLength = fitnessTrainers.length;
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
            setState(() {});
          }
          // else if (state is GetFitnesssTimeTableState) {
          //   timeTable = state.fitnessTimeTable;
          //   setState(() {});
          // }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorData.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr("fitness_title"),
              ),
            ),
            body: Stack(
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  SizedBox(
                    height: screenHeight * 0.20,
                    width: screenWidth,
                    child: Image.asset(
                      'assets/images/classbg.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                      width: screenWidth,
                      // height: screenHeight * 0.20,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: ColorData.fitnessBgColor,
                      ))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 20,
                            width: screenWidth,
                            color: ColorData.fitnessFacilityColor,
                            alignment: Alignment.center,
                            child: Text(
                                DateFormat("MMMM")
                                        .format(widget.selectedDate)
                                        .toUpperCase() +
                                    ' ' +
                                    DateFormat("yyyy")
                                        .format(widget.selectedDate)
                                        .toUpperCase(),
                                style: Styles.textDefaultWithColor),
                          ),
                          Container(
                            // height: screenHeight,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            color: ColorData.fitnessBgColor,
                            child: Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.1,
                                  child: Image.asset(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? 'assets/images/farrow_left.png'
                                        : 'assets/images/farrow_right.png',
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.74,
                                  child: CustomDatePicker(
                                    DateTime.now(),
                                    width: screenWidth * 0.100,
                                    initialSelectedDate: widget.selectedDate,
                                    monthTextStyle: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.fitnessFacilityColor,
                                        fontWeight: FontWeight.bold),
                                    selectionColor:
                                        ColorData.fitnessFacilityColor,
                                    selectedTextColor: ColorData.fitnessBgColor,
                                    selectedDayTextStyle: TextStyle(
                                        fontSize: Styles.loginBtnFontSize,
                                        color: ColorData.fitnessBgColor,
                                        fontWeight: FontWeight.bold),
                                    dayTextStyle: TextStyle(
                                        fontSize: Styles.loginBtnFontSize,
                                        color: ColorData.fitnessFacilityColor,
                                        fontWeight: FontWeight.bold),
                                    dateTextStyle: TextStyle(
                                        fontSize: Styles.textSizeSmall,
                                        color: ColorData.fitnessFacilityColor,
                                        fontWeight: FontWeight.bold),
                                    onDateChange: (date) {
                                      if (widget.selectedDate != date) {
                                        widget.selectedDate = date;
                                        String classDate = DateTimeUtils()
                                            .dateToStringFormat(
                                                widget.selectedDate,
                                                DateTimeUtils
                                                    .YYYY_MM_DD_Format);
                                        BlocProvider.of<FitnessBloc>(context)
                                            .add(GetTrainersProfileEvent(
                                                trainerId: 0,
                                                fromDate: classDate));
                                        // BlocProvider.of<FitnessBloc>(context).add(
                                        //     GetFitnesssTimeTableEvent(
                                        //         classDate: classDate,
                                        //         trainerId: 0));
                                        setState(() {});
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: screenWidth * 0.1,
                                  child: Image.asset(
                                    Localizations.localeOf(context)
                                                .languageCode ==
                                            "en"
                                        ? 'assets/images/farrow_right.png'
                                        : 'assets/images/farrow_left.png',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                              width: screenWidth,
                              padding: EdgeInsets.zero,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: tolLength >= 5 ? true : false,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex == 0
                                                ? selectedIndex = 0
                                                : selectedIndex =
                                                    selectedIndex - 1;
                                            pgcontroller.animateToPage(
                                                selectedIndex,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.easeIn);
                                          });
                                        },
                                        child: Container(
                                          height: screenHeight * 0.08,
                                          width: screenWidth * 0.10,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/farrow_left.png',
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    height: screenHeight * 0.08,
                                    width: screenWidth * 0.76,
                                    child: PageView.builder(
                                        controller: pgcontroller,
                                        itemCount: tolLength,
                                        scrollDirection: Axis.horizontal,
                                        padEnds: false,
                                        pageSnapping: true,
                                        itemBuilder:
                                            (BuildContext context, index) {
                                          return UnconstrainedBox(
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            FitnessTrainersProfile(
                                                              trainerId:
                                                                  fitnessTrainers[
                                                                          index]
                                                                      .trainerID,
                                                              trainerProfile:
                                                                  fitnessTrainers,
                                                            )));
                                                setState(() {
                                                  selectedIndex = index;
                                                });
                                              },
                                              child: CircleAvatar(
                                                // backgroundColor: selectedIndex ==
                                                //         index
                                                //     ? ColorData.fitnessFacilityColor
                                                //     : Colors.transparent,
                                                radius: 23.0,
                                                child: CircleAvatar(
                                                  radius: 23.0,
                                                  backgroundColor:
                                                      ColorData.whiteColor,
                                                  backgroundImage: NetworkImage(
                                                      fitnessTrainers[index]
                                                          .trainerImageFile),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                  ),
                                  Visibility(
                                      visible: tolLength >= 5 ? true : false,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex + 1 == tolLength
                                                ? selectedIndex = tolLength - 1
                                                : selectedIndex =
                                                    selectedIndex + 1;
                                            pgcontroller.animateToPage(
                                                selectedIndex,
                                                duration:
                                                    Duration(milliseconds: 400),
                                                curve: Curves.easeIn);
                                          });
                                        },
                                        child: Container(
                                          height: screenHeight * 0.08,
                                          width: screenWidth * 0.10,
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                            'assets/images/farrow_right.png',
                                          ),
                                        ),
                                      )),
                                ],
                              )),
                        ],
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 40,
                        width: screenWidth * 0.24,
                        decoration: BoxDecoration(
                            color: ColorData.fitnessBgColor,
                            border: Border(
                                right: BorderSide(
                                    color: ColorData.fitnessFacilityColor))),
                        alignment: Alignment.center,
                        child: Text(tr("time"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 40,
                        width: screenWidth * 0.24,
                        decoration: BoxDecoration(
                            color: ColorData.fitnessBgColor,
                            border: Border(
                                right: BorderSide(
                                    color: ColorData.fitnessFacilityColor))),
                        alignment: Alignment.center,
                        child: Text(tr("training"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 40,
                        width: screenWidth * 0.24,
                        decoration: BoxDecoration(
                            color: ColorData.fitnessBgColor,
                            border: Border(
                                right: BorderSide(
                                    color: ColorData.fitnessFacilityColor))),
                        alignment: Alignment.center,
                        child: Text(tr('trainer'),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        height: 40,
                        width: screenWidth * 0.24,
                        decoration: BoxDecoration(
                            color: ColorData.fitnessBgColor,
                            border: Border(
                                right: BorderSide(
                                    color: ColorData.fitnessFacilityColor))),
                        alignment: Alignment.center,
                        child: Text(tr("status"),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  Container(
                      width: screenWidth,
                      height: screenHeight * 0.52,
                      child: timeTable != null &&
                              timeTable.classSlots != null &&
                              timeTable.classSlots.length > 0
                          ? ListView.builder(
                              itemCount: timeTable.classSlots.length,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, index) {
                                return InkWell(
                                  onTap: () {
                                    print(
                                        "LLLLLLLLLLLLL${timeTable.classSlots[index].noOfGuestBooked} < ${timeTable.classSlots[index].classMaxParticipants}");
                                    if (timeTable
                                            .classSlots[index].noOfGuestBooked <
                                        timeTable.classSlots[index]
                                            .classMaxParticipants) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ClassBookingListPage(
                                                    className: Localizations
                                                                    .localeOf(
                                                                        context)
                                                                .languageCode ==
                                                            "en"
                                                        ? timeTable
                                                            .classSlots[index]
                                                            .className
                                                        : timeTable
                                                            .classSlots[index]
                                                            .classNameArabic,
                                                    classNameDescription: Localizations
                                                                    .localeOf(
                                                                        context)
                                                                .languageCode ==
                                                            "en"
                                                        ? timeTable
                                                                .classSlots[
                                                                    index]
                                                                .classDetailsEnglish
                                                                .toString() +
                                                            ""
                                                        : timeTable
                                                            .classSlots[index]
                                                            .classDetailsArabic,
                                                    classDate: timeTable
                                                        .classSlots[index]
                                                        .classDate,
                                                    trainerId: timeTable
                                                        .classSlots[index]
                                                        .classTrainerID,
                                                    customerId: SPUtil.getInt(
                                                        Constants
                                                            .USER_CUSTOMERID),
                                                    classId: timeTable
                                                        .classSlots[index]
                                                        .classId,
                                                    classMasterId: timeTable
                                                        .classSlots[index]
                                                        .classMasterId,
                                                    trainerProfile:
                                                        fitnessTrainers,
                                                  )));
                                    } else {
                                      Utils util = new Utils();
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("booking"),
                                          tr("no_seats_avaialable"),
                                          context);
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 40,
                                        width: screenWidth * 0.24,
                                        decoration: BoxDecoration(
                                            color: ColorData.whiteColor,
                                            border: Border(
                                                left: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor),
                                                right: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor),
                                                bottom: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor))),
                                        alignment: Alignment.center,
                                        child: Text(
                                            timeTable.classSlots[index]
                                                    .classStartTime +
                                                "-" +
                                                timeTable.classSlots[index]
                                                    .classEndTime,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.ttCellStyle),
                                      ),
                                      Container(
                                        height: 40,
                                        width: screenWidth * 0.24,
                                        decoration: BoxDecoration(
                                            color: ColorData.whiteColor,
                                            border: Border(
                                                right: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor),
                                                bottom: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor))),
                                        alignment: Alignment.center,
                                        child: Text(
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? timeTable
                                                    .classSlots[index].className
                                                : timeTable.classSlots[index]
                                                    .classNameArabic,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.ttCellStyle),
                                      ),
                                      Container(
                                        height: 40,
                                        width: screenWidth * 0.24,
                                        decoration: BoxDecoration(
                                            color: ColorData.whiteColor,
                                            border: Border(
                                                right: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor),
                                                bottom: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor))),
                                        alignment: Alignment.center,
                                        child: Text(
                                            Localizations.localeOf(context)
                                                        .languageCode ==
                                                    "en"
                                                ? timeTable.classSlots[index]
                                                    .classTrainerName
                                                : timeTable.classSlots[index]
                                                    .classTrainerNameArabic,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.ttCellStyle),
                                      ),
                                      Container(
                                        height: 40,
                                        width: screenWidth * 0.24,
                                        decoration: BoxDecoration(
                                            color: ColorData.whiteColor,
                                            border: Border(
                                                right: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor),
                                                bottom: BorderSide(
                                                    color: ColorData
                                                        .fitnessBgColor))),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              height: 18,
                                              width: screenWidth * 0.24,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: ColorData
                                                    .fitnessFacilityColor
                                                    .withOpacity(0.5),
                                              ),
                                              child: Text(
                                                  timeTable.classSlots[index]
                                                              .noOfGuestBooked <
                                                          timeTable
                                                              .classSlots[index]
                                                              .classMaxParticipants
                                                      ? (timeTable
                                                                      .classSlots[
                                                                          index]
                                                                      .classMaxParticipants -
                                                                  timeTable
                                                                      .classSlots[
                                                                          index]
                                                                      .noOfGuestBooked)
                                                              .toString() +
                                                          '   ' +
                                                          tr("available")
                                                      : (timeTable
                                                                  .classSlots[
                                                                      index]
                                                                  .noOfGuestBooked ==
                                                              timeTable
                                                                  .classSlots[
                                                                      index]
                                                                  .classMaxParticipants)
                                                          ? tr("full")
                                                          : "",
                                                  style: Styles.ttCellStyle),
                                            ),
                                            timeTable.classSlots[index]
                                                        .noOfGuestBooked >
                                                    timeTable.classSlots[index]
                                                        .classMaxParticipants
                                                ? Container(
                                                    height: 18,
                                                    width: screenWidth * 0.24,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: ColorData
                                                          .fitnessTextBgColor,
                                                    ),
                                                    child: Text(
                                                        (timeTable
                                                                        .classSlots[
                                                                            index]
                                                                        .noOfGuestBooked -
                                                                    timeTable
                                                                        .classSlots[
                                                                            index]
                                                                        .classMaxParticipants)
                                                                .toString() +
                                                            " Waiting",
                                                        style: Styles
                                                            .ttCellWVStyle))
                                                : SizedBox(height: 1)
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })
                          : Align(
                              alignment: Alignment.center,
                              child: Text(tr('no_class_schedule')))),
                ]),
                progressBar
              ],
            ),
          ),
        ));
  }
}
