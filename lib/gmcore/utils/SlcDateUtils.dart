import 'package:date_calc/date_calc.dart';
import 'package:slc/utils/datetime_utils.dart';

class SlcDateUtils {
  // ignore: non_constant_identifier_names
  String SERVER_FORMAT_DATE_TIME = "yyyy-MM-dd'T'HH:mm:ss'Z'";

  // ignore: non_constant_identifier_names
  String SERVER_FORMAT_DATE_TIME_TRIMMED = "yyyy-MM-dd'T'HH:mm:ss";

  // ignore: non_constant_identifier_names
  String DEFAULT_DATE_FORMAT = "dd/MM/yyyy";

  // ignore: non_constant_identifier_names
  String DISPLAY_DATE_FORMAT = "dd MMM, yyyy";

  // ignore: non_constant_identifier_names
  String ZERO = "0";

  String getTodayDateDefaultFormat() {
    var now = new DateTime.now();
    return ('${now.day}/ ${now.month}/ ${now.year}');
  }

  String getTodayDateUIShowFormat() {
    var now = new DateTime.now();

    // String zeroAddedDay = '0' + now.day.toString();
    //  String zeroAddedMonth = '0' + now.month.toString();
    // return ('${now.year}-${now.month < 10 ? zeroAddedMonth:now.month}-${now.day < 10 ? zeroAddedDay:now.day}');
    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.subtractYear(8).toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  String getTodayDateUIShowEventFormat() {
    var now = new DateTime.now();

    // String zeroAddedDay = '0' + now.day.toString();
    //  String zeroAddedMonth = '0' + now.month.toString();
    // return ('${now.year}-${now.month < 10 ? zeroAddedMonth:now.month}-${now.day < 10 ? zeroAddedDay:now.day}');
    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.subtractYear(4).toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  String getTodayDateWithAgeRestrictionUIShowEventFormat() {
    var now = new DateTime.now();
    // int ageRestriction = 8;

    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.subtractYear(4).toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  String getTodayDateWithCurrentRestrictionUIShowEventFormat() {
    var now = new DateTime.now();
    // int ageRestriction = 8;

    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  String getTodayDateWithAgeRestrictionUIShowFormat() {
    try {
      var now = new DateTime.now();
      // int ageRestriction = 8;
      final dateCalc = DateCalc(now.year, now.month, now.day);
      DateTime ageRestricted = dateCalc.subtractYear(8).toDate();
      return DateTimeUtils()
          .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
    } catch (e) {
      return '';
    }
  }

  String getTodayDateWithFutureRestrictionUIShowFormat() {
    var now = new DateTime.now();
    // int ageRestriction = 8;

    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.addYear(1).toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  String getTodayDateWithFutureEventShowFormat() {
    var now = new DateTime.now();
    // int ageRestriction = 8;

    final dateCalc = DateCalc(now.year, now.month, now.day);

    DateTime ageRestricted = dateCalc.addDay(1).toDate();

    return DateTimeUtils()
        .dateToStringFormat(ageRestricted, DateTimeUtils.YYYY_MM_DD_Format);
  }

  DateTime getPopulatedDate(String date) {
    List<String> dateSplit = date.split('-');
    DateTime dateCalc = DateCalc(
      int.parse(dateSplit[2]),
      int.parse(dateSplit[1]),
      int.parse(dateSplit[0]),
    );
    return dateCalc;
  }
}
