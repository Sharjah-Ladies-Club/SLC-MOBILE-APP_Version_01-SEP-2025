import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateFormat dobFormat = DateFormat("MM-dd-yyyy", 'en_US');

  // ignore: non_constant_identifier_names
  static DateFormat DD_MM_YYYY_Format = DateFormat("dd-MM-yyyy", 'en_US');

  static DateFormat DD_MM_YYYY_HH_MM_Format =
      DateFormat("dd-MM-yyyy HH:mm", 'en_US');
  // ignore: non_constant_identifier_names
  static DateFormat YYYY_MM_DD_Format = DateFormat("yyyy-MM-dd", 'en_US');

  // ignore: non_constant_identifier_names
  static DateFormat ServerFormat = DateFormat("yyyy-MM-dd'T'H:m:s", 'en_US');

  static DateFormat ServerFormatTwo = DateFormat("yyyy-MM-dd H:m:s", 'en_US');

  // ignore: non_constant_identifier_names
  static DateFormat DD_MMM_YYYY_Format = DateFormat("dd MMM yyyy", 'en_US');
  static DateFormat M_DD_YYYY = DateFormat("M/dd/yyyy", 'en_US');
  static DateFormat DDD_format = DateFormat("EEEE", 'en_US');

  DateTime stringToDate(String date, DateFormat format) {
    return format.parse(date);
  }

  String dateToStringFormat(DateTime date, DateFormat format) {
    return format.format(date);
  }

  String dateToServerToDateFormat(
      String date, DateFormat actualFormat, DateFormat resultFormat) {
    print(date);

    // var res = DateTime.parse(date);

    DateTime res = stringToDate(date, actualFormat);
// print(t.day);
// print(t.month);
// print(t.year);

// String result= res.day.toString()+"-"+res.month.toString()+"-"+res.year.toString();
    // print(stringToDate(date.split('T')[0].toString(), actualFormat));
    // String convertedDate =
    // dateToStringFormat(stringToDate(date.split('T')[0].toString(), actualFormat), resultFormat);
    // dateToStringFormat(stringToDate(date, actualFormat), resultFormat);

    // print(stringToDate("24-09-1968",DD_MM_YYYY_Format))
    String convertedDate = dateToStringFormat(res, resultFormat);
    print(convertedDate);
    return convertedDate;
  }

//     String dateToServerToDateFormat(
//       String date, DateFormat actualFormat, DateFormat resultFormat) {
//     print(date);

// DateTime t=stringToDate(date, actualFormat);
// print(t.day);
// print(t.month);
// print(t.year);
//     // print(stringToDate(date.split('T')[0].toString(), actualFormat));
//     String convertedDate =
//        // dateToStringFormat(stringToDate(date.split('T')[0].toString(), actualFormat), resultFormat);
//         dateToStringFormat(stringToDate(date, actualFormat), resultFormat);
//         print(convertedDate);
//     return convertedDate;
//   }

  DateTime convertUTCToLocalDateTime(DateTime dateTime) {
    print("dateUtc: $dateTime"); // 2019-10-10 12:05:01

// convert it to local
    var dateLocal = dateTime.toLocal();
    print("local: $dateLocal"); // 2019-

    return dateLocal;
  }
}
