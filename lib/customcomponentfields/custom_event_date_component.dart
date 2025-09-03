// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/customdatepicker/flutter_cupertino_date_picker.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/strings.dart';

class CustomEventDateComponent extends StatefulWidget {
  final Function selectedFunction;
  final TextEditingController dobController;
  final String isEditBtnEnabled;
  String captionText;
  bool isAddPeople = false;
  bool isFutureDate = false;
  CustomEventDateComponent(
      {this.selectedFunction,
      this.dobController,
      this.isEditBtnEnabled,
      this.isAddPeople,
      this.captionText,
      this.isFutureDate,
      Key key})
      : super(key: key);

  _CustomEventDateComponentState createState() =>
      _CustomEventDateComponentState();
}

class _CustomEventDateComponentState extends State<CustomEventDateComponent> {
  double elevationPoint = 0.0;
  DateTime _dateTime;

  @override
  void initState() {
    widget.dobController.addListener(() {
      if (widget.dobController.text.isEmpty) {
        // debugPrint("DATE :::" + Constants.INIT_EVENTDATETIME.toString());
        _dateTime = Constants.INIT_DATETIME_EVENT;
        elevationPoint = 0.0;
      } else {
        _dateTime = SlcDateUtils().getPopulatedDate(widget.dobController.text);
        elevationPoint = 5.0;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: genderForm(),
      ),
    );
  }

  Widget genderForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              if (widget.dobController.text.isEmpty) {
                // debugPrint(
                //     "DATE2 :::" + Constants.INIT_EVENTDATETIME.toString());
                _dateTime = widget.isAddPeople
                    ? Constants.INIT_EVENTDATETIME
                    : Constants.INIT_DATETIME;
              } else {
//                _dateTime = DateTimeUtils().stringToDate(
//                    widget.dobController.text, DateTimeUtils.YYYY_MM_DD_Format);
                _dateTime =
                    SlcDateUtils().getPopulatedDate(widget.dobController.text);
              }
              setState(() {});
              showDatePicker();
            }
          },
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconFn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "dob",
            controller: widget.dobController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyleWithoutArab(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: widget.captionText != null && widget.captionText != ""
                  ? widget.captionText
                  : tr("dobLabel"),
              border: underLineShow(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          )),
        ),
      ),
    );
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Calendar.calendar__16_,
        color: ColorData.inActiveIconColor,
        size: 25,
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  // prefixIconfn() {
  //   return IconButton(
  //     onPressed: () {},
  //     icon:
  //         Icon(CommonIcons.calendar_border, color: ColorData.inActiveIconColor),
  //   );
  // }
  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child:
          Icon(CommonIcons.calendar_border, color: ColorData.inActiveIconColor),
    );
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        itemTextStyle: PackageListHead.textFieldCountryCodeStyles(context),
        showTitle: true,
        confirm: Text(tr("done"),
            style: TextStyle(
              color: ColorData.colorBlue,
              fontSize: Styles.loginBtnFontSize,
              fontFamily: tr("currFontFamilyEnglishOnly"),
            )),
        cancel: Text(tr("cancel"),
            style: TextStyle(
              color: ColorData.colorRed,
              fontSize: Styles.loginBtnFontSize,
              fontFamily: tr("currFontFamilyEnglishOnly"),
            )),
      ),
      minDateTime: Constants.INIT_DATETIME_EVENT,
      maxDateTime: DateTime.parse(Constants.FUTURE_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: Constants.dobFormat,
      locale: Constants.dobLocale,
      onClose: () => {},
      onCancel: () => {},
      onChange: (dateTime, List<int> index) {},
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          widget.dobController.text = DateTimeUtils()
              .dateToStringFormat(dateTime, DateTimeUtils.DD_MM_YYYY_Format);

          widget.selectedFunction(widget.dobController.text);
          elevationPoint = 5.0;
        });
      },
    );
  }
}

class CustomEventDateWithIconComponent extends StatefulWidget {
  final Function selectedFunction;
  final TextEditingController dobController;
  final String isEditBtnEnabled;
  String captionText;
  bool isAddPeople = false;
  bool isFutureDate = false;
  String imagePath;
  CustomEventDateWithIconComponent(
      {this.selectedFunction,
      this.dobController,
      this.isEditBtnEnabled,
      this.isAddPeople,
      this.captionText,
      this.isFutureDate,
      this.imagePath,
      Key key})
      : super(key: key);

  _CustomEventDateWithIconComponentState createState() =>
      _CustomEventDateWithIconComponentState();
}

class _CustomEventDateWithIconComponentState
    extends State<CustomEventDateWithIconComponent> {
  double elevationPoint = 0.0;
  DateTime _dateTime;

  @override
  void initState() {
    widget.dobController.addListener(() {
      if (widget.dobController.text.isEmpty) {
        // debugPrint("DATE :::" + Constants.INIT_EVENTDATETIME.toString());
        _dateTime = Constants.INIT_DATETIME_EVENT;
        elevationPoint = 0.0;
      } else {
        _dateTime = SlcDateUtils().getPopulatedDate(widget.dobController.text);
        elevationPoint = 5.0;
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: genderForm(),
      ),
    );
  }

  Widget genderForm() {
    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
            if (widget.isEditBtnEnabled == Strings.ProfileCallState) {
              if (widget.dobController.text.isEmpty) {
                // debugPrint(
                //     "DATE2 :::" + Constants.INIT_EVENTDATETIME.toString());
                _dateTime = widget.isAddPeople
                    ? Constants.INIT_EVENTDATETIME
                    : Constants.INIT_DATETIME;
              } else {
//                _dateTime = DateTimeUtils().stringToDate(
//                    widget.dobController.text, DateTimeUtils.YYYY_MM_DD_Format);
                _dateTime =
                    SlcDateUtils().getPopulatedDate(widget.dobController.text);
              }
              setState(() {});
              showDatePicker();
            }
          },
          dense: true,
          minLeadingWidth: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconFn()),
          title: IgnorePointer(
              child: FormBuilderTextField(
            readOnly: true,
            name: "dob",
            controller: widget.dobController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            enableInteractiveSelection: false,
            maxLines: 1,
            style: PackageListHead.textFieldStyleWithoutArab(context, false),
            decoration: InputDecoration(
              enabled: true,
              labelText: widget.captionText != null && widget.captionText != ""
                  ? widget.captionText
                  : tr("dobLabel"),
              border: underLineShow(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          )),
        ),
      ),
    );
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {},
      icon: Icon(
        Calendar.calendar__16_,
        color: ColorData.inActiveIconColor,
        size: 25,
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  // prefixIconFn() {
  //   return Padding(
  //     padding: EdgeInsets.zero,
  //     child:
  //     Icon(CommonIcons.calendar_border, color: ColorData.inActiveIconColor),
  //   );
  // }

  prefixIconFn() {
    return Padding(
      padding: EdgeInsets.zero,
      child: widget.imagePath != null
          ? Image.asset(widget.imagePath, width: 30)
          : Icon(CommonIcons.calendar_border,
              color: ColorData.inActiveIconColor),
    );
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        itemTextStyle: PackageListHead.textFieldCountryCodeStyles(context),
        showTitle: true,
        confirm: Text(tr("done"),
            style: TextStyle(
              color: ColorData.colorBlue,
              fontSize: Styles.loginBtnFontSize,
              fontFamily: tr("currFontFamilyEnglishOnly"),
            )),
        cancel: Text(tr("cancel"),
            style: TextStyle(
              color: ColorData.colorRed,
              fontSize: Styles.loginBtnFontSize,
              fontFamily: tr("currFontFamilyEnglishOnly"),
            )),
      ),
      minDateTime: Constants.INIT_DATETIME_EVENT,
      maxDateTime: DateTime.parse(Constants.FUTURE_DATETIME),
      initialDateTime: _dateTime,
      dateFormat: Constants.dobFormat,
      locale: Constants.dobLocale,
      onClose: () => {},
      onCancel: () => {},
      onChange: (dateTime, List<int> index) {},
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          widget.dobController.text = DateTimeUtils()
              .dateToStringFormat(dateTime, DateTimeUtils.DD_MM_YYYY_Format);

          widget.selectedFunction(widget.dobController.text);
          elevationPoint = 5.0;
        });
      },
    );
  }
}
