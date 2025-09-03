import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/table_booking.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/TableBooking/bloc/bloc.dart';
import 'package:slc/view/facility_detail/facility_detail.dart';
import 'package:table_calendar/table_calendar.dart';

// ignore: must_be_immutable
class TableBookingPage extends StatelessWidget {
  int facilityId;
  int facilityItemGroupId;
  TableBookingPage({this.facilityId, this.facilityItemGroupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F8FF),
      body: MultiBlocProvider(
        providers: [
          BlocProvider<TableBookingBloc>(
              create: (context) => TableBookingBloc(tableBookingBloc: null)
                ..add(GetItemDetailsEvent(
                    facilityId: facilityId,
                    facilityItemGroupId: facilityItemGroupId))),
        ],
        child: TableBookingHomePage(
          facilityId: facilityId,
          facilityItemGroupId: facilityItemGroupId,
        ),
      ),
    );
  }
}

class TableBookingHomePage extends StatefulWidget {
  final int facilityId;
  final int facilityItemGroupId;
  TableBookingHomePage({
    this.facilityId,
    this.facilityItemGroupId,
  });
  @override
  _TableBookingPage createState() {
    return _TableBookingPage();
  }
}

class _TableBookingPage extends State<TableBookingHomePage> {
  var value = 1;
  static final borderColor = Colors.grey[200];
  CalendarController _controller = new CalendarController();
  List<AvailableTables> currentSlots = [];
  List<TextEditingController> guestControllers = [];
  Utils util = new Utils();
  bool showCalendar = false;
  bool showBookingSlots = false;
  double total = 0;
  String fStartDate = "00:00";
  String fEndDate = "00:00";
  List<TimeSlot> _dropdownItems = [];
  List<TimeSlot> _dropdownToItems = [];
  List<TimeSlot> _dropdownToItemStore = [];
  // List<DropdownMenuItem<TimeSlot>> _dropdownFrom;
  // List<DropdownMenuItem<TimeSlot>> _dropdownTo;
  TimeSlot _selectedItemFrom;
  TimeSlot _selectedItemTo;
  String selectedDate = "";
  DateTime get date => DateTime.now();
  _TableBookingPage() {
    TimeSlotFill();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TableBookingBloc, TableBookingState>(
      listener: (context, state) {
        if (state is LoadTableBookingItemList) {}
      },
      child: Scaffold(
        backgroundColor: Color(0xFFF0F8FF),
        appBar: AppBar(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          automaticallyImplyLeading: true,
          title: Text(
            tr('book_table'),
            style: TextStyle(color: Colors.blue[200]),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.blue[200],
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => FacilityDetailsPage(
                          facilityId: widget.facilityId,
                        )),
              );
            },
          ),
          actions: <Widget>[],
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: Container(
              child: Column(
            children: <Widget>[
              Container(
                // margin: EdgeInsets.only(left: 1),
                height: MediaQuery.of(context).size.height * 0.87,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  color: Colors.white,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Visibility(
                        visible: true,
                        child: Container(
                          margin: EdgeInsets.only(top: 8, left: 8, right: 8),
                          height: MediaQuery.of(context).size.height * 0.075,
                          width: double.infinity,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: [
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.23,
                                        child: ButtonTheme(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                foregroundColor:
                                                    MaterialStateProperty.all<
                                                        Color>(Colors.white),
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>((value == 1)
                                                            ? ColorData.toColor(
                                                                "F7933A")
                                                            : Colors.grey[200]),
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                )))),
                                            // shape: RoundedRectangleBorder(
                                            //   borderRadius: Localizations
                                            //                   .localeOf(context)
                                            //               .languageCode ==
                                            //           "en"
                                            //       ? BorderRadius.only(
                                            //           topLeft:
                                            //               Radius.circular(16),
                                            //           bottomLeft:
                                            //               Radius.circular(16))
                                            //       : BorderRadius.only(
                                            //           topRight:
                                            //               Radius.circular(16),
                                            //           bottomRight:
                                            //               Radius.circular(16)),
                                            // ),
                                            onPressed: () {
                                              setState(() {
                                                value = 1;
                                                showCalendar = false;
                                                currentSlots.clear();
                                              });
                                            },
                                            // color: (value == 1)
                                            //     ? ColorData.toColor("F7933A")
                                            //     : Colors.grey[200],
                                            child: Text(tr("fine_dine"),
                                                style: TextStyle(
                                                    fontSize: Styles
                                                        .packageExpandTextSiz,
                                                    color: (value == 1)
                                                        ? Colors.white
                                                        : Colors.black54)),
                                          ),
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.24,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 2;
                                            showCalendar = false;
                                            currentSlots.clear();
                                          });
                                        },
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    (value == 2)
                                                        ? ColorData.toColor(
                                                            "F7933A")
                                                        : Colors.grey[200]),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero))),
                                        // color: (value == 2)
                                        //     ? ColorData.toColor("F7933A")
                                        //     : Colors.grey[200],
                                        child: Text(tr("cafe"),
                                            style: TextStyle(
                                                fontSize:
                                                    Styles.packageExpandTextSiz,
                                                color: (value == 2)
                                                    ? Colors.white
                                                    : Colors.black54)),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.24,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            value = 3;
                                            showCalendar = false;
                                            currentSlots.clear();
                                          });
                                        },
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    (value == 3)
                                                        ? ColorData.toColor(
                                                            "F7933A")
                                                        : Colors.grey[200]),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.zero))),
                                        // color: (value == 3)
                                        //     ? ColorData.toColor("F7933A")
                                        //     : Colors.grey[200],
                                        child: Text(tr("lounge"),
                                            style: TextStyle(
                                                fontSize:
                                                    Styles.packageExpandTextSiz,
                                                color: (value == 3)
                                                    ? Colors.white
                                                    : Colors.black54)),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.23,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                            foregroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.white),
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    (value == 4)
                                                        ? ColorData.toColor(
                                                            "F7933A")
                                                        : Colors.grey[200]),
                                            shape: MaterialStateProperty.all<
                                                    RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                              topRight: Radius.circular(10.0),
                                              bottomRight:
                                                  Radius.circular(10.0),
                                            )))),
                                        // shape: RoundedRectangleBorder(
                                        //   borderRadius: Localizations.localeOf(
                                        //                   context)
                                        //               .languageCode ==
                                        //           "en"
                                        //       ? BorderRadius.only(
                                        //           topRight: Radius.circular(16),
                                        //           bottomRight:
                                        //               Radius.circular(16))
                                        //       : BorderRadius.only(
                                        //           topLeft: Radius.circular(16),
                                        //           bottomLeft:
                                        //               Radius.circular(16)),
                                        // ),
                                        onPressed: () {
                                          setState(() {
                                            value = 4;
                                            showCalendar = false;
                                            currentSlots.clear();
                                          });
                                        },
                                        // color: (value == 4)
                                        //     ? ColorData.toColor("F7933A")
                                        //     : Colors.grey[200],
                                        child: Text(tr("terrace"),
                                            style: TextStyle(
                                                fontSize:
                                                    Styles.packageExpandTextSiz,
                                                color: (value == 4)
                                                    ? Colors.white
                                                    : Colors.black54)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                    Visibility(
                        visible: !showCalendar,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [getAreaLayout()]))),
                    Visibility(
                        visible: showCalendar,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.75,
                            width: MediaQuery.of(context).size.width * 0.99,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCalendar(),
                                ])))
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget getAreaLayout() {
    // debugPrint("CallAgain" + widget.facilityItems.length.toString());
    return Container(
      alignment: Alignment.topCenter,
      child: InkWell(
          onTap: () {
            setState(() {
              showCalendar = true;
            });
          },
          child: Image.asset(
              value == 1
                  ? 'assets/images/table_layout_3.png'
                  : value == 2
                      ? 'assets/images/table_layout_2.png'
                      : value == 3
                          ? 'assets/images/table_layout_4.png'
                          : 'assets/images/table_layout_1.png',
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width * 0.99,
              fit: BoxFit.fill)),
    );
  }

  Widget getCalendar() {
    showBookingSlots = false;
    return Expanded(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 0, left: 8, right: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey[400]),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            children: <Widget>[
              TableCalendar(
                initialCalendarFormat: CalendarFormat.week,
                calendarStyle: CalendarStyle(
                    todayColor: Colors.grey[400],
                    selectedColor: Theme.of(context).primaryColor,
                    weekendStyle: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0)),
                    weekdayStyle: TextStyle(
                        color: ColorData.primaryTextColor.withOpacity(1.0)),
                    outsideWeekendStyle: TextStyle(color: Colors.grey),
                    todayStyle: TextStyle(
                        fontSize: Styles.packageExpandTextSiz,
                        fontFamily: tr('currFontFamily'),
                        color: Colors.white)),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekendStyle: TextStyle().copyWith(
                      color: ColorData.primaryTextColor.withOpacity(1.0)),
                  weekdayStyle: TextStyle().copyWith(
                      color: ColorData.primaryTextColor.withOpacity(1.0)),
                ),
                headerStyle: HeaderStyle(
                  centerHeaderTitle: true,
                  formatButtonVisible: false,
                ),
                startingDayOfWeek: StartingDayOfWeek.sunday,
                builders: CalendarBuilders(
                  selectedDayBuilder: (context, date, events) => Container(
                      // margin: const EdgeInsets.all(5.0),
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 6, right: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8.0)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                  todayDayBuilder: (context, date, events) => Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 6, right: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        date.day.toString(),
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                calendarController: _controller,
                onDaySelected: _onDaySelected,
                onCalendarCreated: _onCalendarCreated,
              )
            ],
          ),
        ),
        Container(
            margin: EdgeInsets.only(top: 2, left: 8, right: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey[400]),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                            // elevation: 5.0,
                            child: Container(
                                child: Text(
                          tr("from_time"),
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: Styles.textSizRegular,
                              fontFamily: tr("currFontFamilyEnglishOnly")),
                        ))))),
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                        elevation: 5.0,
                        child: DropdownButtonHideUnderline(
                            child: new DropdownButton<TimeSlot>(
                          value: _selectedItemFrom,
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: Styles.textSizRegular,
                              fontFamily: tr("currFontFamilyEnglishOnly")),
                          items: _dropdownItems.map((TimeSlot value) {
                            return new DropdownMenuItem<TimeSlot>(
                              value: value,
                              child: SizedBox(
                                  width: 60,
                                  child: new Text(
                                    value.timeValue,
                                    textAlign: TextAlign.center,
                                  )),
                            );
                          }).toList(),
                          onChanged: (timeslot) async {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectedItemFrom = timeslot;
                              toTimeSlotFill(_selectedItemFrom.id);
                            });

                            String areaName = "";
                            if (value == 1) {
                              areaName = "Fine Dining";
                            }
                            if (value == 2) {
                              areaName = "Cafe";
                            }
                            if (value == 3) {
                              areaName = "Lounge";
                            }
                            if (value == 4) {
                              areaName = "Terrace";
                            }
                            Meta m = await FacilityDetailRepository()
                                .getBookingTableList(
                                    areaName,
                                    selectedDate,
                                    _selectedItemFrom.timeValue,
                                    _selectedItemTo.timeValue);

                            if (m.statusCode == 200) {
                              List<AvailableTables> availableTables = [];
                              // new List<AvailableTables>();
                              jsonDecode(m.statusMsg)['response'].forEach((f) =>
                                  availableTables
                                      .add(new AvailableTables.fromJson(f)));
                              guestControllers.clear();
                              for (int i = 0; i < availableTables.length; i++) {
                                guestControllers
                                    .add(new TextEditingController());
                              }
                              setState(() {
                                currentSlots = availableTables;
                              });
                            }
                          },
                          icon: null,
                          iconSize: 0,
                          hint: Text("  ",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.textSizRegular,
                                  fontFamily: tr("currFontFamilyEnglishOnly"))),
                        ))),
                  ),
                ),
                new Expanded(
                    flex: 1,
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Material(
                            // elevation: 5.0,
                            child: Container(
                                child: Text(
                          tr("to_time"),
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: Styles.textSizRegular,
                              fontFamily: tr("currFontFamilyEnglishOnly")),
                        ))))),
                new Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                        elevation: 5.0,
                        child: DropdownButtonHideUnderline(
                            child: new DropdownButton<TimeSlot>(
                          value: _selectedItemTo,
                          style: TextStyle(
                              color: ColorData.primaryTextColor,
                              fontSize: Styles.textSizRegular,
                              fontFamily: tr("currFontFamilyEnglishOnly")),
                          items: _dropdownToItems.map((TimeSlot value) {
                            return new DropdownMenuItem<TimeSlot>(
                              value: value,
                              child: SizedBox(
                                  width: 60,
                                  child: new Text(
                                    value.timeValue,
                                    textAlign: TextAlign.center,
                                  )),
                            );
                          }).toList(),
                          onChanged: (timeslot) async {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _selectedItemTo = timeslot;
                            });
                            String areaName = "";
                            if (value == 1) {
                              areaName = "Fine Dining";
                            }
                            if (value == 2) {
                              areaName = "Cafe";
                            }
                            if (value == 3) {
                              areaName = "Lounge";
                            }
                            if (value == 4) {
                              areaName = "Terrace";
                            }
                            Meta m = await FacilityDetailRepository()
                                .getBookingTableList(
                                    areaName,
                                    selectedDate,
                                    _selectedItemFrom.timeValue,
                                    _selectedItemTo.timeValue);

                            if (m.statusCode == 200) {
                              List<AvailableTables> availableTables = [];
                              // new List<AvailableTables>();
                              jsonDecode(m.statusMsg)['response'].forEach((f) =>
                                  availableTables
                                      .add(new AvailableTables.fromJson(f)));
                              guestControllers.clear();
                              for (int i = 0; i < availableTables.length; i++) {
                                guestControllers
                                    .add(new TextEditingController());
                              }
                              setState(() {
                                currentSlots = availableTables;
                              });
                            }
                          },
                          icon: null,
                          iconSize: 0,
                          hint: Text("  ",
                              style: TextStyle(
                                  color: ColorData.primaryTextColor,
                                  fontSize: Styles.textSizRegular,
                                  fontFamily: tr("currFontFamilyEnglishOnly"))),
                        ))),
                  ),
                ),
              ],
            )),
        Container(
          margin: EdgeInsets.only(left: 8, right: 8, top: 14),
          height: MediaQuery.of(context).size.height * 0.42,
          width: MediaQuery.of(context).size.width * 0.98,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey[400]),
              color: Colors.white),
          child: Visibility(
              visible: showCalendar,
              child: Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [getTables()]))),
          // Visibility(
          //     visible: showBookingSlots, child: getBookingSlots())
        ),
      ],
    ));
    // );
    // ));
  }

  Widget getTables() {
    return Expanded(
        child: currentSlots.length == 0
            ? Padding(
                padding: EdgeInsets.only(top: 25, right: 10, left: 10),
                child: Text(tr("table_booking_time"),
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSizRegular,
                        fontFamily: tr("currFontFamilyEnglishOnly"))))
            : ListView.builder(
                key: PageStorageKey("Table_PageStorageKey"),
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: currentSlots.length,
                itemBuilder: (context, j) {
                  //return //Container(child: Text(enquiryDetailResponse[j].firstName));
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.15,
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 5, top: 0),
                    decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16)),
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: 50,
                            width: 50,
                            margin: const EdgeInsets.only(top: 20, left: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              child: Image.asset(
                                "assets/images/" +
                                    ((currentSlots[j].noOfSeats == 2 ||
                                            currentSlots[j].noOfSeats == 4 ||
                                            currentSlots[j].noOfSeats == 6)
                                        ? currentSlots[j].noOfSeats.toString() +
                                            ".png"
                                        : "2.png"),
                                height: 50,
                                width: 50,
                              ),
                            )),
                        Padding(
                          padding: Localizations.localeOf(context)
                                      .languageCode ==
                                  "en"
                              ? EdgeInsets.only(
                                  top: 15.0,
                                  left:
                                      MediaQuery.of(context).size.width * 0.17,
                                  bottom: 5.0)
                              : EdgeInsets.only(
                                  top: 15.0,
                                  right:
                                      MediaQuery.of(context).size.width * 0.17,
                                  bottom: 5.0),
                          child: Row(
                            children: [
                              Flexible(
                                  child: Text(
                                tr('table_no') +
                                    currentSlots[j].tableNo.toString() +
                                    tr("available_seats") +
                                    currentSlots[j].noOfSeats.toString(),
                                style: TextStyle(
                                    color: ColorData.toColor("F7933A"),
                                    fontSize: Styles.packageExpandTextSiz,
                                    fontFamily: tr('currFontFamily')),
                              )),
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: const EdgeInsets.only(top: 10, left: 25),
                        //   child: Row(
                        //     children: [
                        //       Image.asset(
                        //         "assets/images/" +
                        //             currentSlots[j].noOfSeats.toString() +
                        //             ".png",
                        //         height: 30,
                        //         width: 30,
                        //       ),
                        //       Padding(
                        //           padding: EdgeInsets.only(left: 15),
                        //           child: Text(
                        //               'Table No :' +
                        //                   currentSlots[j].tableNo.toString() +
                        //                   "  Available Seats :" +
                        //                   currentSlots[j].noOfSeats.toString(),
                        //               style: TextStyle(color: Colors.black54))),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(top: 60, left: 25),
                          child: Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.10),
                                  child: Text("  No of Guests :",
                                      style: TextStyle(color: Colors.black54))),
                            ],
                          ),
                        ),
                        Container(
                          margin: Localizations.localeOf(context)
                                      .languageCode ==
                                  "en"
                              ? EdgeInsets.only(
                                  top: 50,
                                  bottom: 5,
                                  left:
                                      MediaQuery.of(context).size.width * 0.40,
                                )
                              : EdgeInsets.only(
                                  top: 50,
                                  bottom: 5,
                                  right:
                                      MediaQuery.of(context).size.width * 0.40,
                                ),
                          height: MediaQuery.of(context).size.height * .05,
                          width: MediaQuery.of(context).size.width / 3.8,
                          decoration: BoxDecoration(
                            border: Border.all(color: borderColor),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Stack(
                            children: [
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(right: 80)
                                    : EdgeInsets.only(left: 80),
                                child: new IconButton(
                                    icon: new Icon(Icons.delete,
                                        size: 18, color: Colors.grey),
                                    onPressed: () {
                                      if (currentSlots[j].bookingSeats !=
                                              null &&
                                          currentSlots[j].bookingSeats > 0) {
                                        setState(() {
                                          currentSlots[j].bookingSeats =
                                              currentSlots[j].bookingSeats - 1;
                                        });
                                      }
                                    }),
                              ),
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                4)
                                    : EdgeInsets.only(
                                        right:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                4),
                                child: VerticalDivider(
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                2.3,
                                        top: 9)
                                    : EdgeInsets.only(
                                        right:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                2.3,
                                        top: 9),
                                child: new Text(
                                    currentSlots[j].bookingSeats == null
                                        ? "0"
                                        : currentSlots[j]
                                            .bookingSeats
                                            .toString(),
                                    style: TextStyle(color: Colors.grey)),
                              ),
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                1.75)
                                    : EdgeInsets.only(
                                        right:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                1.75),
                                child: VerticalDivider(
                                  color: Colors.grey,
                                ),
                              ),
                              Padding(
                                padding: Localizations.localeOf(context)
                                            .languageCode ==
                                        "en"
                                    ? EdgeInsets.only(
                                        left:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                1.60)
                                    : EdgeInsets.only(
                                        right:
                                            (MediaQuery.of(context).size.width /
                                                    3.8) /
                                                1.60),
                                child: new IconButton(
                                    icon: new Icon(Icons.add,
                                        color: Colors.grey, size: 18),
                                    onPressed: () => setState(() {
                                          if (currentSlots[j].bookingSeats ==
                                              null) {
                                            currentSlots[j].bookingSeats = 0;
                                          }
                                          if (currentSlots[j].bookingSeats >=
                                              currentSlots[j].noOfSeats) return;
                                          currentSlots[j].bookingSeats =
                                              currentSlots[j].bookingSeats + 1;
                                        })),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 45,
                            left: MediaQuery.of(context).size.width * 0.70,
                          ),
                          width: double.infinity,
                          child: Row(
                            children: [
                              ButtonTheme(
                                minWidth: 80,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (currentSlots[j].bookingSeats == null ||
                                        currentSlots[j].bookingSeats == 0) {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("booking"),
                                          "Select No Of Guest",
                                          context);
                                      return;
                                    }

                                    Meta m =
                                        await (new FacilityDetailRepository())
                                            .saveTableBooking(
                                                currentSlots[j].tableId,
                                                selectedDate,
                                                _selectedItemFrom.timeValue,
                                                _selectedItemTo.timeValue,
                                                currentSlots[j].bookingSeats);
                                    if (m.statusCode == 200) {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FacilityDetailsPage(
                                                    facilityId:
                                                        widget.facilityId)),
                                      );
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("booking"),
                                          "Booked Successfuly",
                                          context);
                                    } else {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("booking"), m.statusMsg, context);
                                    }
                                  },
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ColorData.toColor("F7933A")),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      )))),
                                  // color: ColorData.toColor("F7933A"),
                                  // shape: RoundedRectangleBorder(
                                  //   borderRadius: BorderRadius.circular(8.0),
                                  // ),
                                  child: Text(tr("book"),
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              // Container(
                              //   child: getCustomContainer(),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }));
  }

  Widget getBookingSlots() {
    return Expanded(
        child: ListView.builder(
            key: PageStorageKey("Slot_PageStorageKey"),
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: currentSlots.length,
            itemBuilder: (context, j) {
              //return //Container(child: Text(enquiryDetailResponse[j].firstName));
              return Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.94,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Text(currentSlots[j].tableNo.toString(),
                      style: TextStyle(
                          color: ColorData.primaryTextColor,
                          fontSize: Styles.packageExpandTextSiz,
                          fontFamily: tr('currFontFamily'))));
            }));
  }

  void _onCalendarCreated(DateTime day, DateTime day1, CalendarFormat format) {
    selectedDate = _controller.selectedDay.toString().substring(0, 10);
  }

  void _onDaySelected(DateTime day, List events, List holidays) async {
    print('CALLBACK: _onDaySelected');
    selectedDate = day.toString().substring(0, 10);
    setState(() {
      currentSlots.clear();
    });

    String areaName = "";
    if (value == 1) {
      areaName = "Fine Dining";
    }
    if (value == 2) {
      areaName = "Cafe";
    }
    if (value == 3) {
      areaName = "Lounge";
    }
    if (value == 4) {
      areaName = "Terrace";
    }
    Meta m = await FacilityDetailRepository().getBookingTableList(areaName,
        selectedDate, _selectedItemFrom.timeValue, _selectedItemTo.timeValue);

    if (m.statusCode == 200) {
      List<AvailableTables> availableTables =
          []; // new List<AvailableTables>();
      jsonDecode(m.statusMsg)['response']
          .forEach((f) => availableTables.add(new AvailableTables.fromJson(f)));
      guestControllers.clear();
      for (int i = 0; i < availableTables.length; i++) {
        guestControllers.add(new TextEditingController());
      }
      setState(() {
        currentSlots = availableTables;
      });
    }
  }

  void TimeSlotFill() {
    for (int i = 8, j = 0; i < 24; i++, j += 2) {
      TimeSlot ts = new TimeSlot();
      ts.id = j;
      ts.timeValue = i.toString().padLeft(2, '0') + ":" + "00";
      _dropdownItems.add(ts);
      if (i > 0) {
        ts = new TimeSlot();
        ts.id = j;
        ts.timeValue = i.toString().padLeft(2, '0') + ":" + "00";
        _dropdownToItemStore.add(ts);
      }
      if (i < 23) {
        ts = new TimeSlot();
        ts.id = j + 1;
        ts.timeValue = i.toString().padLeft(2, '0') + ":" + "30";
        _dropdownItems.add(ts);
      }
      ts = new TimeSlot();
      ts.id = j + 1;
      ts.timeValue = i.toString().padLeft(2, '0') + ":" + "30";
      _dropdownToItemStore.add(ts);
    }
    toTimeSlotFill(0);
    _selectedItemFrom = _dropdownItems[0];
  }

  void toTimeSlotFill(int index) {
    _dropdownToItems.clear();
    //debugPrint("  iiiiiiiii " + index.toString());
    for (int i = index + 1; i < _dropdownToItemStore.length; i++) {
      _dropdownToItems.add(_dropdownToItemStore[i]);
    }
    _selectedItemTo = _dropdownToItems[0];
  }
}
