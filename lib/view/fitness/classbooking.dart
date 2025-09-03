// ignore_for_file: must_be_immutable

import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customCalendar.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/transaction_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/view/fitness/bloc/bloc.dart';
import 'package:slc/view/fitness/traineerprofile.dart';

import 'fitnessbuy/fitnessbuy_payment.dart';

class ClassBookingListPage extends StatelessWidget {
  int trainerId = 0;
  String classDate = "";
  int customerId = 0;
  String className = "";
  String classNameDescription = "";
  int classMasterId = 0;
  int classId = 0;
  int facilityItemId = 0;
  List<TrainerProfile> trainerProfile;
  ClassBookingListPage(
      {this.trainerId,
      this.classDate,
      this.customerId,
      this.className,
      this.classMasterId,
      this.classNameDescription,
      this.classId,
      this.facilityItemId,
      this.trainerProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FitnessBloc>(
              create: (context) => FitnessBloc(null)
                ..add(GetMembershipDetails(facilityId: 3))
                ..add(GetFitnesssSpaceBookingSlotEvent(
                  classDate: classDate,
                  trainerId: trainerId,
                  customerId: customerId,
                  classMasterId: classMasterId,
                  classNameDescription: classNameDescription,
                ))
                ..add(GetPaymentTerms(facilityId: 3))),
        ],
        child: ClassBooking(
            trainerId: trainerId,
            classDate: classDate,
            customerId: customerId,
            className: className,
            classNameDescription: classNameDescription,
            classId: classId,
            classMasterId: classMasterId,
            facilityItemId: facilityItemId,
            trainerProfile: trainerProfile),
      ),
    );
  }
}

class ClassBooking extends StatefulWidget {
  String className;
  String classNameDescription;
  int trainerId = 0;
  String classDate = "";
  int customerId = 0;
  int classId = 0;
  int classMasterId = 0;
  List<TrainerProfile> trainerProfile;
  List<FacilityMembership> facilityMemberShip;
  MembershipClassAvailDto classAvailablity;
  int facilityItemId = 0;

  ClassBooking(
      {this.trainerId = 0,
      this.classDate = "",
      this.customerId = 0,
      this.className = "",
      this.classNameDescription,
      this.classId,
      this.classMasterId,
      this.facilityMemberShip,
      this.classAvailablity,
      this.facilityItemId,
      this.trainerProfile});
  @override
  State<ClassBooking> createState() => _ClassBookingState();
}

class _ClassBookingState extends State<ClassBooking>
    with TickerProviderStateMixin {
  double carouselHeight = 0.0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  // CalendarController _controller = new CalendarController();
  List<TimeTable> currentSlots = [];
  List<FacilityMembership> facilityMemberShip;
  List<TrainerProfile> trainerProfile;
  MembershipClassAvailDto classAvailablity;
  int haveFitnessMemberShip = 0;
  int cmAvailVoucherCount = 0;
  String classDesc = "";
  String colorCode;
  String selectedDate = "";
  ScrollController controller = ScrollController();
  TabController tabController;
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  DateTime date = DateTime.now();
  DateTime _selectedDate;
  ClassBookingViewDto spaceBookingList = new ClassBookingViewDto();
  int bookingId = 0;
  BookingIdResult bookingDetails = new BookingIdResult();
  List<FacilityItems> facilityItem = [];
  FacilityDetailResponse facilityDetail;
  int enquiryDetailId = 0;
  PaymentTerms paymentTerms = new PaymentTerms();
  int joinClass = 0;

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
    HashMap<int, FacilityBeachRequest> itemCounts =
        new HashMap<int, FacilityBeachRequest>();

    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );
    return BlocListener<FitnessBloc, FitnessState>(
        listener: (context, state) async {
          if (state is ShowFitnessProgressBarState) {
            _handler.show();
          } else if (state is HideFitnessProgressBarState) {
            _handler.dismiss();
          } else if (state is GetMembershipState) {
            _selectedDate = DateTimeUtils()
                .stringToDate(widget.classDate, DateTimeUtils.ServerFormat);
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
            if (state.classAvailablity != null) {
              haveFitnessMemberShip =
                  state.classAvailablity.haveFitnessMemberShip;
              cmAvailVoucherCount = state.classAvailablity.availableVoucher;
              joinClass = state.classAvailablity.joinAClass;
            }
            setState(() {});
          } else if (state is GetTrainersProfileState) {
            widget.trainerProfile = state.fitnessTimeTable.trainersProfile;
            setState(() {});
          } else if (state is GetFitnesssSpaceBookingSlotState) {
            spaceBookingList = new ClassBookingViewDto();
            spaceBookingList = state.fitnessSpaceBookingSlots;
            if (spaceBookingList != null) {
              if (spaceBookingList.spaceSlots != null &&
                  spaceBookingList.spaceSlots.length > 0) {
                classDesc = Localizations.localeOf(context).languageCode == "en"
                    ? spaceBookingList.spaceSlots[0].classDetailsEnglish
                    : spaceBookingList.spaceSlots[0].classDetailsArabic;
              } else if (spaceBookingList.bookingSlots != null &&
                  spaceBookingList.bookingSlots.length > 0) {
                classDesc = Localizations.localeOf(context).languageCode == "en"
                    ? spaceBookingList.bookingSlots[0].classDetailsEnglish
                    : spaceBookingList.bookingSlots[0].classDetailsArabic;
              }
              // classDesc
            } else {
              spaceBookingList.spaceSlots = [];
              spaceBookingList.bookingSlots = [];
            }
            setState(() {});
          } else if (state is FitnessGetPaymentTermsResult) {
            paymentTerms = state.paymentTerms;
          } else if (state is GetClassBookingIdState) {
            bookingDetails = state.bookingIdDetails;
            if (haveFitnessMemberShip == 0 ||
                joinClass == 0 ||
                (haveFitnessMemberShip == 1 && cmAvailVoucherCount == 0)) {
              bookingId = 0;
              Meta f1 = await FacilityDetailRepository()
                  .getFitnessItem(state.facilityItemId);
              if (f1.statusCode == 200) {
                facilityItem.clear();
                jsonDecode(f1.statusMsg)['response'].forEach(
                    (f) => facilityItem.add(new FacilityItems.fromJson(f)));
              }

              // double totalItems = 1;
              double total = 0; //widget.facilityItem.price;
              Meta m = await FacilityDetailRepository()
                  .getDiscountList(3, total, itemId: state.facilityItemId);
              List<BillDiscounts> billDiscounts = [];
              // new List<BillDiscounts>();
              if (m.statusCode == 200) {
                jsonDecode(m.statusMsg)['response'].forEach(
                    (f) => billDiscounts.add(new BillDiscounts.fromJson(f)));
              }
              if (billDiscounts == null) {
                // billDiscounts = new List<BillDiscounts>();
                billDiscounts = [];
              }
              List<GiftVocuher> vouchers = [];
              var v = new GiftVocuher();
              v.giftCardText = "Select Voucher";
              v.balanceAmount = 0;
              v.giftVoucherId = 0;
              vouchers.add(v);
              Meta m1 = await FacilityDetailRepository().getGiftVouchers();
              if (m1.statusCode == 200) {
                jsonDecode(m1.statusMsg)['response']
                    .forEach((f) => vouchers.add(new GiftVocuher.fromJson(f)));
              }
              // Disable collage
              if (vouchers == null) {
                vouchers = [];
              }
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => new FitnessBuyPaymentPage(
                      facilityItems: facilityItem,
                      total: total,
                      itemCounts: itemCounts,
                      retailItemSetId: "",
                      facilityId: 3,
                      tableNo: state.classId,
                      colorCode: "A81B8D",
                      billDiscounts: billDiscounts,
                      giftVouchers: vouchers,
                      paymentTerms: paymentTerms,
                      bookingId: bookingId,
                      enquiryDetailId: 0,
                      moduleId: 12,
                      screenCode: 5,
                    ),
                  ));
            } else {
              BlocProvider.of<FitnessBloc>(context).add(GetTrainersProfileEvent(
                  trainerId: 0, fromDate: widget.classDate));
              BlocProvider.of<FitnessBloc>(context).add(
                  GetFitnesssSpaceBookingSlotEvent(
                      classDate: widget.classDate,
                      trainerId: widget.trainerId,
                      customerId: widget.customerId,
                      classMasterId: widget.classMasterId,
                      classNameDescription: widget.classNameDescription));
            }
          } else if (state is RemoveClassBookingState) {
            if (state.result == "OK") {
              customGetSnackBarWithOutActionButton(
                  tr("class_bookings"), tr("class_removed"), context);
              BlocProvider.of<FitnessBloc>(context).add(GetTrainersProfileEvent(
                  trainerId: 0, fromDate: widget.classDate));
              BlocProvider.of<FitnessBloc>(context).add(
                  GetFitnesssSpaceBookingSlotEvent(
                      classDate: widget.classDate,
                      trainerId: widget.trainerId,
                      customerId: widget.customerId,
                      classMasterId: widget.classMasterId,
                      classNameDescription: widget.classNameDescription));
            } else {
              customGetSnackBarWithOutActionButton(
                  tr("booking"), tr("class_removed"), context);
            }
          }
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: ColorData.whiteColor,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(100.0),
              child: CustomAppBar(
                title: tr("class_bookings"),
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
                                _selectedDate != null
                                    ? (DateFormat("MMMM", "en_US")
                                            .format(_selectedDate)
                                            .toUpperCase() +
                                        ' ' +
                                        DateFormat("yyyy", 'en_US')
                                            .format(_selectedDate)
                                            .toUpperCase())
                                    : "",
                                style: Styles.textDefaultWithColor),
                          ),
                          _selectedDate != null
                              ? Container(
                                  // height: screenHeight,
                                  padding: EdgeInsets.only(left: 50, right: 50),
                                  color: ColorData.fitnessBgColor,
                                  child: CustomDatePicker(
                                    DateTime.now(),
                                    width: screenWidth * 0.100,
                                    initialSelectedDate: _selectedDate,
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
                                      _selectedDate = date;
                                      String classDate = DateTimeUtils()
                                          .dateToStringFormat(_selectedDate,
                                              DateTimeUtils.YYYY_MM_DD_Format);
                                      widget.classDate = classDate;
                                      BlocProvider.of<FitnessBloc>(context).add(
                                          GetTrainersProfileEvent(
                                              trainerId: 0,
                                              fromDate: widget.classDate));
                                      BlocProvider.of<FitnessBloc>(context).add(
                                          GetFitnesssSpaceBookingSlotEvent(
                                              classDate: widget.classDate,
                                              trainerId: widget.trainerId,
                                              customerId: widget.customerId,
                                              classMasterId:
                                                  widget.classMasterId,
                                              classNameDescription:
                                                  widget.classNameDescription));
                                      setState(() {});
                                    },
                                  ),
                                )
                              : Container(child: Text("")),
                          Container(
                              width: screenWidth,
                              alignment: Alignment.centerLeft,
                              padding:
                                  EdgeInsets.only(top: 8, left: 8, right: 8),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 30,
                                        child: Text(
                                          widget.className,
                                          style: TextStyle(
                                              fontSize: Styles.textSizTwenty,
                                              fontWeight: FontWeight.bold,
                                              color: ColorData
                                                  .fitnessFacilityColor),
                                        )),
                                    Container(
                                        height: 80,
                                        width: screenWidth,
                                        child: SingleChildScrollView(
                                            child: Text(
                                          classDesc,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontSize:
                                                  Styles.packageExpandTextSiz,
                                              color:
                                                  ColorData.primaryTextColor),
                                        ))),
                                  ])),
                        ],
                      )),
                  TabBar(
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
                                tr('space_avail'),
                                style: TextStyle(
                                    fontSize: Styles.textSizeSmall,
                                    color: ColorData.fitnessFacilityColor,
                                    fontWeight: FontWeight.bold),
                              ))),
                      Tab(
                        child: Container(
                            color: tabController.index == 1
                                ? ColorData.fitnessBgColor
                                : ColorData.whiteColor,
                            alignment: Alignment.center,
                            child: Text(
                              tr('my_booking'),
                              style: TextStyle(
                                  fontSize: Styles.textSizeSmall,
                                  color: ColorData.fitnessFacilityColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  Container(
                    height: screenHeight * 0.30,
                    // color: Colors.yellow,
                    child: TabBarView(
                      controller: tabController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          height: screenHeight * 0.35,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: ColorData.fitnessBgColor))),
                          child: spaceAvailability(),
                          // color: Colors.blue,
                        ),
                        Container(
                          height: screenHeight * 0.35,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: ColorData.fitnessBgColor))),
                          child: myBookings(),
                          // color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: ColorData.fitnessBgColor,
                  )
                ]),
                progressBar
              ],
            ),
          ),
        ));
  }

  Widget spaceAvailability() {
    return Container(
      height: screenHeight * 0.20,
      width: double.infinity,
      color: ColorData.whiteColor,
      child: spaceBookingList != null &&
              spaceBookingList.spaceSlots != null &&
              spaceBookingList.spaceSlots.length > 0
          ? ListView.separated(
              itemCount: spaceBookingList.spaceSlots.length,
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
                            spaceBookingList.spaceSlots[index].classStartTime +
                                "-" +
                                spaceBookingList.spaceSlots[index].classEndTime,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat("EEEE")
                                .format(_selectedDate)
                                .toUpperCase(),
                            style: TextStyle(
                                fontSize: Styles.packageExpandTextSiz,
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
                              Icons.reduce_capacity,
                              color: ColorData.fitnessBgColor,
                              size: 16,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Text(
                                spaceBookingList
                                        .spaceSlots[index].noOfGuestBooked
                                        .toString() +
                                    "/" +
                                    spaceBookingList
                                        .spaceSlots[index].classMaxParticipants
                                        .toString(),
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
                          print(spaceBookingList
                              .spaceSlots[index].classTrainerID);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FitnessTrainersProfile(
                                      trainerId: spaceBookingList
                                          .spaceSlots[index].classTrainerID,
                                      trainerProfile: widget.trainerProfile,
                                      classDate:
                                          widget.classDate.indexOf("T") != -1
                                              ? DateTimeUtils()
                                                  .stringToDate(
                                                      widget.classDate,
                                                      DateTimeUtils
                                                          .ServerFormat)
                                                  .toString()
                                              : widget.classDate
                                                  .substring(0, 10))));
                        },
                        child: Text(
                            Localizations.localeOf(context).languageCode == "en"
                                ? spaceBookingList
                                    .spaceSlots[index].classTrainerName
                                : spaceBookingList
                                    .spaceSlots[index].classTrainerNameArabic,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      trailing: InkWell(
                        onTap: () async {
                          // Check Buy Buttont
                          if (haveFitnessMemberShip == 0 ||
                              joinClass == 0 ||
                              (haveFitnessMemberShip == 1 &&
                                  cmAvailVoucherCount <= 0)) {
                            customAlertDialog(
                                context,
                                tr("no_void_option"),
                                tr("yes"),
                                tr("no"),
                                tr(""),
                                tr("confirm"),
                                () => {
                                      Navigator.of(context).pop(),
                                      BlocProvider.of<FitnessBloc>(context).add(
                                          GetClassBookingId(
                                              classId: spaceBookingList
                                                  .spaceSlots[index].classId,
                                              memberTypeId:
                                                  haveFitnessMemberShip,
                                              erpCustomerId: SPUtil.getInt(
                                                  Constants.USERID),
                                              facilityItemId: spaceBookingList
                                                  .spaceSlots[index]
                                                  .facilityItemId,
                                              bookingId: 0,
                                              voucherCount:
                                                  cmAvailVoucherCount))
                                    });
                          } else if (haveFitnessMemberShip == 1 &&
                              cmAvailVoucherCount > 0 &&
                              joinClass == 1) {
                            customAlertDialog(
                                context,
                                tr("pending_classes") +
                                    ' ' +
                                    cmAvailVoucherCount.toString() +
                                    "\n\n" +
                                    tr('class_cancel_msg'),
                                tr("yes"),
                                tr("no"),
                                tr("available_vocuher_count"),
                                tr("confirm"),
                                () => {
                                      Navigator.of(context).pop(),
                                      BlocProvider.of<FitnessBloc>(context).add(
                                          GetClassBookingId(
                                              classId: spaceBookingList
                                                  .spaceSlots[index].classId,
                                              memberTypeId:
                                                  haveFitnessMemberShip,
                                              erpCustomerId: SPUtil.getInt(
                                                  Constants.USERID),
                                              facilityItemId: spaceBookingList
                                                  .spaceSlots[index]
                                                  .facilityItemId,
                                              bookingId: 0,
                                              voucherCount:
                                                  cmAvailVoucherCount))
                                    });
                          } else {
                            customAlertDialog(
                                context,
                                tr('class_cancel_msg'),
                                tr("yes"),
                                tr("no"),
                                tr(""),
                                tr("confirm"),
                                () => {
                                      Navigator.of(context).pop(),
                                      BlocProvider.of<FitnessBloc>(context).add(
                                          GetClassBookingId(
                                              classId: spaceBookingList
                                                  .spaceSlots[index].classId,
                                              memberTypeId:
                                                  haveFitnessMemberShip,
                                              erpCustomerId: SPUtil.getInt(
                                                  Constants.USERID),
                                              facilityItemId: spaceBookingList
                                                  .spaceSlots[index]
                                                  .facilityItemId,
                                              bookingId: 0,
                                              voucherCount:
                                                  cmAvailVoucherCount))
                                    });
                          }

                          // getCustomAlertPositive(context, positive: () {
                          //   if (haveFitnessMemberShip == 1 &&
                          //       cmAvailVoucherCount > 0) {
                          //   } else {
                          //     BlocProvider.of<FitnessBloc>(context).add(
                          //         GetClassBookingId(
                          //             classId: widget.classId,
                          //             memberTypeId: haveFitnessMemberShip,
                          //             erpCustomerId:
                          //                 SPUtil.getInt(Constants.USERID),
                          //             facilityItemId: spaceBookingList
                          //                 .spaceSlots[index].facilityItemId,
                          //             bookingId: 0,
                          //             voucherCount: cmAvailVoucherCount));
                          //   }
                          // },
                          //     title: tr("confirm"),
                          //     content: tr("no_void_option"));
                        },
                        child: Container(
                          width: screenWidth * 0.21,
                          // height: 50,
                          padding: EdgeInsets.all(0),
                          margin: EdgeInsets.only(right: 10),
                          // left: 4, right: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: ColorData.fitnessFacilityColor),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4))),
                          alignment: Alignment.centerRight,
                          // width: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                size: 16,
                                color: ColorData.fitnessFacilityColor,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 4),
                                child: Text(
                                  (haveFitnessMemberShip == 0 ||
                                              joinClass == 0) ||
                                          (haveFitnessMemberShip == 1 &&
                                              cmAvailVoucherCount == 0)
                                      ? tr("buy")
                                      : spaceBookingList
                                          .spaceSlots[index].status,
                                  style: TextStyle(
                                    fontSize: Styles.reviewTextSize,
                                    color: ColorData.fitnessFacilityColor,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
              ),
            )
          : Align(
              alignment: Alignment.center,
              child: Text(tr("no_classes_scheduled_for_day"),
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: Styles.packageExpandTextSiz))),
    );
  }

  Widget myBookings() {
    return Container(
      height: screenHeight * 0.20,
      width: double.infinity,
      color: ColorData.whiteColor,
      child: spaceBookingList != null &&
              spaceBookingList.bookingSlots != null &&
              spaceBookingList.bookingSlots.length > 0
          ? ListView.separated(
              itemCount: spaceBookingList.bookingSlots.length,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 0, right: 0, top: 8),
              itemBuilder: (BuildContext context, index) {
                DateTime classTime = DateTimeUtils().stringToDate(
                    spaceBookingList.bookingSlots[index].classDate,
                    DateTimeUtils.ServerFormat);
                int d = classTime.difference(DateTime.now()).inHours;
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
                      title: Text(
                        DateFormat('dd-MM-yyyy').format(DateTime.parse(
                            spaceBookingList.bookingSlots[index].classDate)),
                        style: TextStyle(
                            fontSize: Styles.packageExpandTextSiz,
                            color: ColorData.fitnessFacilityColor,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        DateFormat("EEEE")
                                .format(DateTime.parse(spaceBookingList
                                    .bookingSlots[index].classDate))
                                .toUpperCase() +
                            " " +
                            spaceBookingList
                                .bookingSlots[index].classStartTime +
                            "-" +
                            spaceBookingList.bookingSlots[index].classEndTime,
                        style: TextStyle(
                            fontSize: Styles.textSizeSmall,
                            color: ColorData.primaryTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                      trailing: Visibility(
                          visible: false,
                          child: SizedBox(
                              width: screenWidth * 0.23,
                              // height: 50,
                              child: InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  // left: 4, right: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              ColorData.fitnessFacilityColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  alignment: Alignment.center,
                                  // width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: ColorData.fitnessFacilityColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                          tr("confirm"),
                                          style: TextStyle(
                                            fontSize: Styles.reviewTextSize,
                                            color:
                                                ColorData.fitnessFacilityColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))),
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
                          //             trainerId: spaceBookingList
                          //                 .bookingSlots[index].classTrainerID,
                          //             classDate: DateTimeUtils()
                          //                 .stringToDate(widget.classDate,
                          //                     DateTimeUtils.ServerFormat)
                          //                 .toString())));
                        },
                        child: Text(
                            spaceBookingList
                                .bookingSlots[index].classTrainerName,
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.fitnessFacilityColor,
                                fontWeight: FontWeight.bold)),
                      ),
                      trailing: Visibility(
                          visible: (d >= 3 &&
                                  (haveFitnessMemberShip >= 1 ||
                                      haveFitnessMemberShip == 1 &&
                                          cmAvailVoucherCount > 0))
                              ? true
                              : false,
                          child: SizedBox(
                              width: screenWidth * 0.23,
                              // height: 50,
                              child: InkWell(
                                onTap: () {
                                  // var ctx = context;
                                  customAlertDialog(
                                      context,
                                      tr('do_you_want_to_remove_class'),
                                      tr('yes'),
                                      tr('no'),
                                      tr('confirm'),
                                      tr('remove_class'), () {
                                    Navigator.pop(context);
                                    BlocProvider.of<FitnessBloc>(context).add(
                                        RemoveClassBooking(
                                            classId: spaceBookingList
                                                .bookingSlots[index].classId,
                                            bookingId: spaceBookingList
                                                .bookingSlots[index].bookingId,
                                            erpCustomerId: SPUtil.getInt(
                                                Constants.USER_CUSTOMERID)));
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  // left: 4, right: 4),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color:
                                              ColorData.fitnessFacilityColor),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  alignment: Alignment.center,
                                  // width: 60,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_forever_outlined,
                                        size: 16,
                                        color: ColorData.fitnessFacilityColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 4),
                                        child: Text(
                                          'REMOVE',
                                          style: TextStyle(
                                            fontSize: Styles.reviewTextSize,
                                            color:
                                                ColorData.fitnessFacilityColor,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))),
                    )
                  ],
                );
              },
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 1,
              ),
            )
          : Align(
              alignment: Alignment.center,
              child: Text(tr("no_classes_scheduled_for_day"),
                  style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: Styles.packageExpandTextSiz))),
    );
  }

  customGetSnackBarWithOutActionButton(titlemsg, contentmsg, context) {
    return Get.snackbar(
      titlemsg,
      contentmsg,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: ColorData.activeIconColor,
      isDismissible: true,
      duration: Duration(seconds: 3),
    );
  }
}
