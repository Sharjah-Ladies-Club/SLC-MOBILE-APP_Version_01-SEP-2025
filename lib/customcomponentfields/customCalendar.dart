import 'package:date_picker_timeline/extra/color.dart';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:date_picker_timeline/gestures/tap.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../common/colors.dart';

class CustomDatePicker extends StatefulWidget {
  /// Start Date in case user wants to show past dates
  /// If not provided calendar will start from the initialSelectedDate
  final DateTime startDate;

  /// Width of the selector
  final double width;

  /// Height of the selector
  final double height;

  /// DatePicker Controller
  final DatePickerController controller;

  /// Text color for the selected Date
  final Color selectedTextColor;

  /// Background color for the selector
  final Color selectionColor;

  /// Text Color for the deactivated dates
  final Color deactivatedColor;

  /// TextStyle for Month Value
  final TextStyle monthTextStyle;

  /// TextStyle for day Value
  final TextStyle dayTextStyle;

  /// TextStyle for the date Value
  final TextStyle dateTextStyle;

  final TextStyle selectedDayTextStyle;

  /// Current Selected Date
  final DateTime /*?*/ initialSelectedDate;

  /// Contains the list of inactive dates.
  /// All the dates defined in this List will be deactivated
  final List<DateTime> inactiveDates;

  /// Contains the list of active dates.
  /// Only the dates in this list will be activated.
  final List<DateTime> activeDates;

  /// Callback function for when a different date is selected
  final DateChangeListener onDateChange;

  /// Max limit up to which the dates are shown.
  /// Days are counted from the startDate
  final int daysCount;

  /// Locale for the calendar default: en_us
  final String locale;

  CustomDatePicker(
    this.startDate, {
    Key key,
    this.width = 60,
    this.height = 60,
    this.controller,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectedTextColor = Colors.white,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.deactivatedColor = AppColors.defaultDeactivatedColor,
    this.selectedDayTextStyle = defaultDayTextStyle,
    this.initialSelectedDate,
    this.activeDates,
    this.inactiveDates,
    this.daysCount = 500,
    this.onDateChange,
    this.locale = "en_US",
  }) : assert(
            activeDates == null || inactiveDates == null,
            "Can't "
            "provide both activated and deactivated dates List at the same time.");

  @override
  State<StatefulWidget> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  DateTime _currentDate;

  ScrollController _controller = ScrollController();

  TextStyle selectedDateStyle;
  TextStyle selectedMonthStyle;
  TextStyle selectedDayStyle;

  TextStyle deactivatedDateStyle;
  TextStyle deactivatedMonthStyle;
  TextStyle deactivatedDayStyle;

  @override
  void initState() {
    // Init the calendar locale
    initializeDateFormatting(widget.locale, null);
    // Set initial Values
    _currentDate = widget.initialSelectedDate;

    if (widget.controller != null) {
      widget.controller.setDatePickerState(this);
    }

    this.selectedDateStyle =
        widget.dateTextStyle.copyWith(color: widget.selectedTextColor);
    this.selectedMonthStyle =
        widget.monthTextStyle.copyWith(color: widget.selectedTextColor);
    // this.selectedDayStyle =
    //     widget.dayTextStyle.copyWith(color: widget.selectedTextColor);
    this.selectedDayStyle = widget.selectedDayTextStyle;

    this.deactivatedDateStyle =
        widget.dateTextStyle.copyWith(color: widget.deactivatedColor);
    this.deactivatedMonthStyle =
        widget.monthTextStyle.copyWith(color: widget.deactivatedColor);
    this.deactivatedDayStyle =
        widget.dayTextStyle.copyWith(color: widget.deactivatedColor);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: ListView.builder(
        itemCount: widget.daysCount,
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (context, index) {
          // get the date object based on the index position
          // if widget.startDate is null then use the initialDateValue
          DateTime date;
          DateTime _date = widget.startDate.add(Duration(days: index));
          date = new DateTime(_date.year, _date.month, _date.day);

          bool isDeactivated = false;

          // check if this date needs to be deactivated for only DeactivatedDates
          if (widget.inactiveDates != null) {
//            print("Inside Inactive dates.");
            for (DateTime inactiveDate in widget.inactiveDates) {
              if (_compareDate(date, inactiveDate)) {
                isDeactivated = true;
                break;
              }
            }
          }

          // check if this date needs to be deactivated for only ActivatedDates
          if (widget.activeDates != null) {
            isDeactivated = true;
            for (DateTime activateDate in widget.activeDates) {
              // Compare the date if it is in the
              if (_compareDate(date, activateDate)) {
                isDeactivated = false;
                break;
              }
            }
          }

          // Check if this date is the one that is currently selected
          bool isSelected =
              _currentDate != null ? _compareDate(date, _currentDate) : false;

          // Return the Date Widget
          return CustomDateWidget(
            date: date,
            selectedDayTextStyle:
                isSelected ? widget.selectedDayTextStyle : widget.dayTextStyle,
            monthTextStyle: isDeactivated
                ? deactivatedMonthStyle
                : isSelected
                    ? selectedMonthStyle
                    : widget.monthTextStyle,
            dateTextStyle: isDeactivated
                ? deactivatedDateStyle
                : isSelected
                    ? selectedDateStyle
                    : widget.dateTextStyle,
            dayTextStyle: isDeactivated
                ? deactivatedDayStyle
                : isSelected
                    ? selectedDayStyle
                    : widget.dayTextStyle,
            width: widget.width,
            locale: widget.locale,
            isSelected: isSelected,
            index: index,
            selectionColor:
                isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              // Don't notify listener if date is deactivated
              if (isDeactivated) return;

              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange(selectedDate);
              }
              setState(() {
                _currentDate = selectedDate;
              });
            },
          );
        },
      ),
    );
  }

  /// Helper function to compare two dates
  /// Returns True if both dates are the same
  bool _compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}

class DatePickerController {
  _CustomDatePickerState _datePickerState;

  void setDatePickerState(_CustomDatePickerState state) {
    _datePickerState = state;
  }

  void jumpToSelection() {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    // jump to the current Date
    _datePickerState._controller
        .jumpTo(_calculateDateOffset(_datePickerState._currentDate));
  }

  /// This function will animate the Timeline to the currently selected Date
  void animateToSelection(
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    // animate to the current date
    _datePickerState._controller.animateTo(
        _calculateDateOffset(_datePickerState._currentDate),
        duration: duration,
        curve: curve);
  }

  /// This function will animate to any date that is passed as a parameter
  /// In case a date is out of range nothing will happen
  void animateToDate(DateTime date,
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _datePickerState._controller.animateTo(_calculateDateOffset(date),
        duration: duration, curve: curve);
  }

  /// Calculate the number of pixels that needs to be scrolled to go to the
  /// date provided in the argument
  double _calculateDateOffset(DateTime date) {
    final startDate = new DateTime(
        _datePickerState.widget.startDate.year,
        _datePickerState.widget.startDate.month,
        _datePickerState.widget.startDate.day);

    int offset = date.difference(startDate).inDays;
    return (offset * _datePickerState.widget.width) + (offset * 6);
  }
}

/// ***
/// This class consists of the DateWidget that is used in the ListView.builder
///
/// Author: Vivek Kaushik <me@vivekkasuhik.com>
/// github: https://github.com/iamvivekkaushik/
/// ***

class CustomDateWidget extends StatelessWidget {
  final double width;
  final DateTime date;
  final TextStyle monthTextStyle,
      dayTextStyle,
      dateTextStyle,
      selectedDayTextStyle;
  final Color selectionColor;
  final DateSelectionCallback onDateSelected;
  final String locale;
  final bool isSelected;
  final int index;

  CustomDateWidget({
    @required this.date,
    @required this.monthTextStyle,
    @required this.dayTextStyle,
    @required this.dateTextStyle,
    @required this.selectedDayTextStyle,
    @required this.selectionColor,
    @required this.isSelected,
    @required this.index,
    this.width,
    this.onDateSelected,
    this.locale,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: width,
        margin: EdgeInsets.only(left: index == 0 ? 3 : 0, right: 3),
        decoration: BoxDecoration(
          border: Border(
              left: BorderSide(color: Colors.transparent, width: 0),
              top: BorderSide(color: Colors.transparent, width: 0),
              bottom: BorderSide(color: Colors.transparent, width: 0),
              right:
                  BorderSide(color: ColorData.fitnessFacilityColor, width: 0)),
          // borderRadius: BorderRadius.all(Radius.circular(0.0)),
          color: ColorData.fitnessBgColor, //selectionColor,
        ),
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: isSelected
                        ? ColorData.fitnessFacilityColor
                        : ColorData.fitnessBgColor,
                    border: Border(
                        bottom: BorderSide(
                            color: isSelected
                                ? ColorData.fitnessBgColor
                                : ColorData.fitnessFacilityColor))),
                height: 30,
                alignment: Alignment.center,
                // margin: EdgeInsets.only(
                //     left: index == 0 ? 3 : 0, right: index == 0 ? 3 : 0),
                child: Text(
                    new DateFormat("E", locale)
                        .format(date)
                        .toUpperCase(), // WeekDay
                    style: selectedDayTextStyle),
              ),
              Container(
                color: selectionColor,
                height: 30,
                // margin: EdgeInsets.only(
                //     left: index == 0 ? 3 : 0, right: index == 0 ? 3 : 0),
                alignment: Alignment.center,
                child: Text(date.day.toString(), // Date
                    style: dateTextStyle),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected(this.date);
        }
      },
    );
  }
}
