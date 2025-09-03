// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_code_picker.dart';
import 'package:slc/customcomponentfields/customdatepicker/flutter_cupertino_date_picker.dart';
import 'package:slc/gmcore/utils/SlcDateUtils.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/strings.dart';

class LoginPageFieldWhite extends StatefulWidget {
  final TextEditingController _customTextEditingController;
  final String _customLabelString;
  final String _defaultCountryCode;
  final IconData _customLeadIcon;
  final TextInputType _customTextInputType;
  final TextInputAction _keyboardAction;
  final Function _onTapCountryCode;
  final Function onTap;
  bool isCountryCodeReadOnly;
  bool readOnly = false;
  int maxLines = 1;
  bool isWhite = false;
  LoginPageFieldWhite(
      this._customTextEditingController,
      this._customLabelString,
      this._defaultCountryCode,
      this._customLeadIcon,
      this._customTextInputType,
      this._keyboardAction,
      this._onTapCountryCode,
      this.onTap,
      {Key key,
      isCountryCodeReadOnly: false,
      this.maxLines = 1,
      this.readOnly = false,
      this.isWhite = false})
      : super(key: key);

  @override
  _LoginPageFieldWhiteState createState() {
    return _LoginPageFieldWhiteState();
  }
}

class _LoginPageFieldWhiteState extends State<LoginPageFieldWhite> {
  DateTime _dateTime;
  String todayDate =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();

  FocusNode _focusNode = FocusNode();

  String _dialCode = "971";

  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();

    _dialCode = widget._defaultCountryCode;

    widget._customTextEditingController.addListener(() {
      if (widget._customTextEditingController.text != Strings.txtMT)
        elevationPoint = 5.0;
    });

    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");

      setState(() {
        if (_focusNode.hasFocus &&
            (widget._customLabelString == Strings.textFieldDOBLabel ||
                widget._customLabelString == Strings.textFieldDOBLabelArb)) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
        if (_focusNode.hasFocus)
          elevationPoint = 5.0;
        else if (widget._customTextEditingController.text.length == 0)
          elevationPoint = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var themeStyle = Theme.of(context);
    return Container(
      child: Card(
        color: widget.isWhite
            ? ColorData.whiteColor
            : ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          dense: true,
          minLeadingWidth: 0,
          // horizontalTitleGap: 4.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconfn()),
          title: FormBuilderTextField(
            name: widget._customLabelString,
            controller: widget._customTextEditingController,
            keyboardType: widget._customTextInputType,
            textInputAction: widget._keyboardAction,
            inputFormatters: inputFormatterfn(_dialCode == '+971' ? 9 : 10),
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            autofocus: false,
            enableInteractiveSelection: false,
            maxLines: widget.maxLines,
            style: (widget._customLabelString == tr('mobileNumber') ||
                    widget._customLabelString == tr('emailLabel') ||
                    widget._customLabelString == tr('contact_email'))
                ? PackageListHead.textFieldStylesForNumbers(context, false)
                : PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              labelText: widget._customLabelString,
              border: underLineShow(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.only(
                  left: 5.0, right: 15.0, top: 10.0, bottom: 10.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          ),
        ),
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  countryPickerfn() {
    return CountryCodePicker(
      isCountryCodeReadOnly: widget.isCountryCodeReadOnly == null
          ? false
          : widget.isCountryCodeReadOnly,
      onChanged: (country) => {
        widget._onTapCountryCode(country),
        setState(() {
          _dialCode = country.dialCode;
        }),
      },
      initialSelection: widget._defaultCountryCode,
      searchStyle: TextStyle(
          color: ColorData.primaryTextColor,
          fontWeight: null,
          fontFamily: tr('currFontFamilyEnglishOnly')),
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
    );
  }

  inputFormatterfn(len) {
    if (widget._customTextInputType == TextInputType.number)
      return <TextInputFormatter>[
        // WhitelistingTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(len)
      ];
    if (widget._customLabelString == tr('emailLabel') ||
        widget._customLabelString == tr('contact_email')) {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(new RegExp(r'[A-Za-z0-9.@_\-]')),
        // WhitelistingTextInputFormatter(new RegExp(r'[A-Za-z0-9.@_\-]')),
      ];
    }
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {
        //showDatePicker();
      },
      icon: Icon(CommonIcons.dropdown, size: 12.0, color: Colors.transparent),
    );
  }

  prefixIconfn() {
    if (widget._customLabelString == tr('mobileNumber')) {
      if (widget._defaultCountryCode == null) {
        return Icon(Icons.phone_iphone);
      } else {
        return countryPickerfn();
      }
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: Icon(widget._customLeadIcon, color: ColorData.inActiveIconColor),
      );
    }
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(tr("done"), style: TextStyle(color: ColorData.colorBlue)),
        cancel: Text(tr("cancel"), style: TextStyle(color: ColorData.colorRed)),
      ),
      minDateTime: DateTime.parse(Constants.MIN_DATETIME),
      maxDateTime: DateTime.parse(todayDate),
      initialDateTime: _dateTime,
      dateFormat: Constants.dobFormat,
      locale: Constants.dobLocale,
      onClose: () => {},
      onCancel: () => {},
      onChange: (dateTime, List<int> index) {},
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          int _month = dateTime.month;
          String _convertedMonth = dateTime.month.toString();
          int _day = dateTime.day;
          String _convertedDay = dateTime.day.toString();
          if (_day < 10) {
            _convertedDay = '0' + dateTime.day.toString();
          }
          if (_month < 10) {
            _convertedMonth = '0' + dateTime.month.toString();
          }
          widget._customTextEditingController.text =
              (_convertedDay + _convertedMonth + dateTime.year.toString());
          elevationPoint = 5.0;
        });
      },
    );
  }

  verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

//_fieldFocusChange(context, currFocus, label, term) {}
}

class GiftPageFields extends StatefulWidget {
  final TextEditingController _customTextEditingController;
  final String _customLabelString;
  final String _defaultCountryCode;
  final TextInputType _customTextInputType;
  final TextInputAction _keyboardAction;
  final Function _onTapCountryCode;
  final Function onTap;
  bool isCountryCodeReadOnly;
  bool readOnly = false;
  int maxLines = 1;
  GiftPageFields(
      this._customTextEditingController,
      this._customLabelString,
      this._defaultCountryCode,
      this._customTextInputType,
      this._keyboardAction,
      this._onTapCountryCode,
      this.onTap,
      {Key key,
      isCountryCodeReadOnly: false,
      this.maxLines = 1,
      this.readOnly = false})
      : super(key: key);

  @override
  _GiftPageFieldsState createState() {
    return _GiftPageFieldsState();
  }
}

class _GiftPageFieldsState extends State<GiftPageFields> {
  DateTime _dateTime;
  String todayDate =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();

  FocusNode _focusNode = FocusNode();

  String _dialCode = "971";

  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();

    _dialCode = widget._defaultCountryCode;

    widget._customTextEditingController.addListener(() {
      if (widget._customTextEditingController.text != Strings.txtMT)
        elevationPoint = 5.0;
    });

    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");

      setState(() {
        if (_focusNode.hasFocus &&
            (widget._customLabelString == Strings.textFieldDOBLabel ||
                widget._customLabelString == Strings.textFieldDOBLabelArb)) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
        if (_focusNode.hasFocus)
          elevationPoint = 5.0;
        else if (widget._customTextEditingController.text.length == 0)
          elevationPoint = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var themeStyle = Theme.of(context);

    return Container(
      child: Card(
        color: ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          title: FormBuilderTextField(
            name: widget._customLabelString,
            controller: widget._customTextEditingController,
            keyboardType: widget._customTextInputType,
            textInputAction: widget._keyboardAction,
            inputFormatters: inputFormatterfn(_dialCode == '+971' ? 9 : 10),
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            autofocus: false,
            enableInteractiveSelection: false,
            maxLines: widget.maxLines,
            style: (widget._customLabelString == tr('mobileNumber') ||
                    widget._customLabelString == tr('emailLabel') ||
                    widget._customLabelString == tr('contact_email'))
                ? PackageListHead.textFieldStylesForNumbers(context, false)
                : PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              labelText: widget._customLabelString,
              border: underLineShow(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 10.0),
//            contentPadding: EdgeInsets.all(5.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          ),
        ),
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  countryPickerfn() {
    return CountryCodePicker(
      isCountryCodeReadOnly: widget.isCountryCodeReadOnly == null
          ? false
          : widget.isCountryCodeReadOnly,
      onChanged: (country) => {
        widget._onTapCountryCode(country),
        setState(() {
          _dialCode = country.dialCode;
        }),
      },
      initialSelection: widget._defaultCountryCode,
      searchStyle: TextStyle(
          color: ColorData.primaryTextColor,
          fontWeight: null,
          fontFamily: tr('currFontFamilyEnglishOnly')),
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
    );
  }

  inputFormatterfn(len) {
    if (widget._customTextInputType == TextInputType.number)
      return <TextInputFormatter>[
        // WhitelistingTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(len)
      ];
    if (widget._customLabelString == tr('emailLabel') ||
        widget._customLabelString == tr('contact_email')) {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(new RegExp(r'[A-Za-z0-9.@_\-]')),
        // WhitelistingTextInputFormatter(new RegExp(r'[A-Za-z0-9.@_\-]')),
      ];
    }
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {
        //showDatePicker();
      },
      icon: Icon(CommonIcons.dropdown, size: 12.0, color: Colors.transparent),
    );
  }

  // prefixIconfn() {
  //   if (widget._customLabelString == tr('mobileNumber')) {
  //     if (widget._defaultCountryCode == null) {
  //       return Icon(Icons.phone_iphone);
  //     } else {
  //       return countryPickerfn();
  //     }
  //   } else {
  //     return Padding(
  //       padding: EdgeInsets.only(top: 4.0),
  //       child: Icon(
  //         widget._customLeadIcon,
  //         color: ColorData.inActiveIconColor,
  //       ),
  //     );
  //   }
  // }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(tr("done"), style: TextStyle(color: ColorData.colorBlue)),
        cancel: Text(tr("cancel"), style: TextStyle(color: ColorData.colorRed)),
      ),
      minDateTime: DateTime.parse(Constants.MIN_DATETIME),
      maxDateTime: DateTime.parse(todayDate),
      initialDateTime: _dateTime,
      dateFormat: Constants.dobFormat,
      locale: Constants.dobLocale,
      onClose: () => {},
      onCancel: () => {},
      onChange: (dateTime, List<int> index) {},
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          int _month = dateTime.month;
          String _convertedMonth = dateTime.month.toString();
          int _day = dateTime.day;
          String _convertedDay = dateTime.day.toString();
          if (_day < 10) {
            _convertedDay = '0' + dateTime.day.toString();
          }
          if (_month < 10) {
            _convertedMonth = '0' + dateTime.month.toString();
          }
          widget._customTextEditingController.text =
              (_convertedDay + _convertedMonth + dateTime.year.toString());
          elevationPoint = 5.0;
        });
      },
    );
  }

  verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

//_fieldFocusChange(context, currFocus, label, term) {}
}

class LoginPageFieldWithIconWhite extends StatefulWidget {
  final TextEditingController _customTextEditingController;
  final String _customLabelString;
  final String _defaultCountryCode;
  final IconData _customLeadIcon;
  final TextInputType _customTextInputType;
  final TextInputAction _keyboardAction;
  final Function _onTapCountryCode;
  final Function onTap;
  bool isCountryCodeReadOnly;
  bool readOnly = false;
  int maxLines = 1;
  bool isWhite = false;
  String imagePath;
  LoginPageFieldWithIconWhite(
      this._customTextEditingController,
      this._customLabelString,
      this._defaultCountryCode,
      this._customLeadIcon,
      this._customTextInputType,
      this._keyboardAction,
      this._onTapCountryCode,
      this.onTap,
      {Key key,
      isCountryCodeReadOnly: false,
      this.maxLines = 1,
      this.readOnly = false,
      this.isWhite = false,
      this.imagePath})
      : super(key: key);

  @override
  _LoginPageFieldWithIconWhiteState createState() {
    return _LoginPageFieldWithIconWhiteState();
  }
}

class _LoginPageFieldWithIconWhiteState
    extends State<LoginPageFieldWithIconWhite> {
  DateTime _dateTime;
  String todayDate =
      SlcDateUtils().getTodayDateWithAgeRestrictionUIShowFormat();

  FocusNode _focusNode = FocusNode();

  String _dialCode = "971";

  double elevationPoint = 0.0;

  @override
  void initState() {
    super.initState();

    _dialCode = widget._defaultCountryCode;

    widget._customTextEditingController.addListener(() {
      if (widget._customTextEditingController.text != Strings.txtMT)
        elevationPoint = 5.0;
    });

    _focusNode.addListener(() {
      print("Has focus: ${_focusNode.hasFocus}");

      setState(() {
        if (_focusNode.hasFocus &&
            (widget._customLabelString == Strings.textFieldDOBLabel ||
                widget._customLabelString == Strings.textFieldDOBLabelArb)) {
          FocusScope.of(context).requestFocus(new FocusNode());
        }
        if (_focusNode.hasFocus)
          elevationPoint = 5.0;
        else if (widget._customTextEditingController.text.length == 0)
          elevationPoint = 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //var themeStyle = Theme.of(context);

    return Container(
      child: Card(
        color: widget.isWhite
            ? ColorData.whiteColor
            : ColorData.loginBackgroundColor,
        elevation: elevationPoint,
        child: ListTile(
          dense: true,
          minLeadingWidth: 0,
          // horizontalTitleGap: 4.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(left: 0.0)
                  : EdgeInsets.only(right: 5.0),
              child: prefixIconfn()),
          title: FormBuilderTextField(
            name: widget._customLabelString,
            controller: widget._customTextEditingController,
            keyboardType: widget._customTextInputType,
            textInputAction: widget._keyboardAction,
            inputFormatters: inputFormatterfn(_dialCode == '+971' ? 9 : 10),
            focusNode: _focusNode,
            readOnly: widget.readOnly,
            autofocus: false,
            enableInteractiveSelection: false,
            maxLines: widget.maxLines,
            style: (widget._customLabelString == tr('mobileNumber') ||
                    widget._customLabelString == tr('emailLabel') ||
                    widget._customLabelString == tr('contact_email'))
                ? PackageListHead.textFieldStylesForNumbers(context, false)
                : PackageListHead.textFieldStyles(context, false),
            decoration: InputDecoration(
              labelText: widget._customLabelString,
              border: underLineShow(),
              suffixIcon: siffixIconfn(),
              contentPadding: EdgeInsets.only(
                  left: 5.0, right: 15.0, top: 10.0, bottom: 10.0),
              labelStyle: (elevationPoint == 5.0)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
            ),
          ),
        ),
      ),
    );
  }

  underLineShow() {
    if (elevationPoint == 5.0) {
      return InputBorder.none;
    }
  }

  countryPickerfn() {
    return CountryCodePicker(
      isCountryCodeReadOnly: widget.isCountryCodeReadOnly == null
          ? false
          : widget.isCountryCodeReadOnly,
      onChanged: (country) => {
        widget._onTapCountryCode(country),
        setState(() {
          _dialCode = country.dialCode;
        }),
      },
      initialSelection: widget._defaultCountryCode,
      searchStyle: TextStyle(
          color: ColorData.primaryTextColor,
          fontWeight: null,
          fontFamily: tr('currFontFamilyEnglishOnly')),
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      alignLeft: false,
    );
  }

  inputFormatterfn(len) {
    if (widget._customTextInputType == TextInputType.number)
      return <TextInputFormatter>[
        // WhitelistingTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(len)
      ];
    if (widget._customLabelString == tr('emailLabel') ||
        widget._customLabelString == tr('contact_email')) {
      return <TextInputFormatter>[
        FilteringTextInputFormatter.allow(new RegExp(r'[A-Za-z0-9.@_\-]')),
        // WhitelistingTextInputFormatter(new RegExp(r'[A-Za-z0-9.@_\-]')),
      ];
    }
  }

  siffixIconfn() {
    return IconButton(
      onPressed: () {
        //showDatePicker();
      },
      icon: Icon(CommonIcons.dropdown, size: 12.0, color: Colors.transparent),
    );
  }

  // prefixIconfn() {
  //   if (widget._customLabelString == tr('mobileNumber')) {
  //     if (widget._defaultCountryCode == null) {
  //       return Icon(Icons.phone_iphone);
  //     } else {
  //       return countryPickerfn();
  //     }
  //   } else {
  //     return Padding(
  //       padding: EdgeInsets.zero,
  //       child: Icon(widget._customLeadIcon, color: ColorData.inActiveIconColor),
  //     );
  //   }
  // }

  prefixIconfn() {
    if (widget._customLabelString == tr('mobileNumber')) {
      if (widget._defaultCountryCode == null) {
        return Icon(Icons.phone_iphone);
      } else {
        return countryPickerfn();
      }
    } else {
      return Padding(
        padding: EdgeInsets.zero,
        child: widget.imagePath != null
            ? Image.asset(widget.imagePath, width: 30)
            : Icon(widget._customLeadIcon, color: ColorData.inActiveIconColor),
      );
    }
  }

  void showDatePicker() {
    DatePicker.showDatePicker(
      context,
      pickerTheme: DateTimePickerTheme(
        showTitle: true,
        confirm: Text(tr("done"), style: TextStyle(color: ColorData.colorBlue)),
        cancel: Text(tr("cancel"), style: TextStyle(color: ColorData.colorRed)),
      ),
      minDateTime: DateTime.parse(Constants.MIN_DATETIME),
      maxDateTime: DateTime.parse(todayDate),
      initialDateTime: _dateTime,
      dateFormat: Constants.dobFormat,
      locale: Constants.dobLocale,
      onClose: () => {},
      onCancel: () => {},
      onChange: (dateTime, List<int> index) {},
      onConfirm: (dateTime, List<int> index) {
        setState(() {
          _dateTime = dateTime;
          int _month = dateTime.month;
          String _convertedMonth = dateTime.month.toString();
          int _day = dateTime.day;
          String _convertedDay = dateTime.day.toString();
          if (_day < 10) {
            _convertedDay = '0' + dateTime.day.toString();
          }
          if (_month < 10) {
            _convertedMonth = '0' + dateTime.month.toString();
          }
          widget._customTextEditingController.text =
              (_convertedDay + _convertedMonth + dateTime.year.toString());
          elevationPoint = 5.0;
        });
      },
    );
  }

  verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }

//_fieldFocusChange(context, currFocus, label, term) {}
}
