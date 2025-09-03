//import 'package:country_code_picker/country_codes.dart';
// import 'package:email_validator/email_validator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/custom_country_code_picker/custom_country_code_picker_login.dart';

import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/strings.dart';

class LoginPageFields extends StatefulWidget {
  final TextEditingController _customTextEditingController;
  final String _customLabelString;
  final String _defaultCountryCode;
  final IconData _customLeadIcon;
  final TextInputType _customTextInputType;
  final TextInputAction _keyboardAction;
  final Function _onTapCountryCode;

  //final Function _onTap;

  LoginPageFields(
    this._customTextEditingController,
    this._customLabelString,
    this._defaultCountryCode,
    this._customLeadIcon,
    this._customTextInputType,
    this._keyboardAction,
    this._onTapCountryCode,
    //  this._onTap,
  );

  @override
  _LoginPageFieldsState createState() {
    return _LoginPageFieldsState();
  }
}

class _LoginPageFieldsState extends State<LoginPageFields> {
  FocusNode _focusNode = FocusNode();
  String _dialCode = "971";
  double elevationPoint = 0.0;
  bool isCountryCodeChanged = false;

  // bool _passwordObscureChange = false;
  bool isElevateMobileField = false;

  @override
  void initState() {
    super.initState();

    _dialCode = widget._defaultCountryCode;
    widget._customTextEditingController.addListener(() {
      if (widget._customTextEditingController.text != Strings.txtMT)
        elevationPoint = 5.0;
    });

    _focusNode.addListener(() {
      setState(() {
        if (widget._customLabelString == tr('mobileNumber') &&
            widget._defaultCountryCode != null) {
          if (_focusNode.hasFocus) {
            isElevateMobileField = true;
          } else if (!_focusNode.hasFocus &&
              widget._customTextEditingController.text.length == 0) {
            isElevateMobileField = false;
          }
        } else {
          isElevateMobileField = true;
        }

        if (_focusNode.hasFocus) {
          elevationPoint = 5.0;
        } else if (widget._customTextEditingController.text.length == 0 &&
            !isCountryCodeChanged) {
          elevationPoint = 0.0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 100.0),
      // padding: EdgeInsets.only(left: 10.0,top:20.0,bottom: 20.0),
      child: Card(
        color: ColorData.loginBackgroundColor,
        // color: ColorData.colorRed,
        elevation: elevationPoint,
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          minLeadingWidth: 0.0,
          horizontalTitleGap: 0.0,
          leading: Container(
              margin: Localizations.localeOf(context).languageCode == "en"
                  ? EdgeInsets.only(right: 10.0)
                  : EdgeInsets.only(left: 10.0),
              child: prefixIconfn()),

          title: FormBuilderTextField(
            name: widget._customLabelString,
            controller: widget._customTextEditingController,
            keyboardType: widget._customTextInputType,
            textInputAction: widget._keyboardAction,
            inputFormatters: inputFormatterfn(_dialCode == '+971' ? 9 : 10),
            focusNode: _focusNode,

            enableInteractiveSelection: false,

            minLines: 1,
            maxLines: 1,

            // maxLength: mobileMaxLengthFn(),
            style: (widget._customLabelString == tr('mobileNumber'))
                ? PackageListHead.textFieldStylesForNumbers(context, false)
                : PackageListHead.textFieldStyles(context, false),

            decoration: new InputDecoration(
              isDense: true,
              labelText: widget._customLabelString,
              suffixIcon: siffixIconfn(),
              contentPadding: (elevationPoint == 5.0)
                  ? EdgeInsets.only(top: 20.0)
                  : EdgeInsets.only(
                      left: 10.0, top: 20.0, bottom: 20.0, right: 10.0),
              labelStyle: (elevationPoint == 5.0 && isElevateMobileField)
                  ? PackageListHead.textFieldStyles(context, true)
                  : PackageListHead.textFieldStyles(context, false),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent, width: 0.5),
              ),
              enabledBorder: (elevationPoint == 5.0)
                  ? OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.transparent, width: 0.5))
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                          color: ColorData.textFieldUnderLine, width: 0.5),
                    ),
            ),
          ),
          //        ),
        ),
      ),
    );
  }

  countryPickerfn() {
    return CountryCodePicker(
      // focusNode: _focusNode,
      //  textStyle: TextStyle( fontFamily: "HelveticaNeue",color: ColorData.secondaryTextColor),
      onChanged: (country) => {
        widget._onTapCountryCode(country),
        setState(() {
          // _selectedCountry = country;
          _dialCode = country.dialCode;
          elevationPoint = 5.0;
          isCountryCodeChanged = true;
        }),
      },
      // padding:EdgeInsets.only()
      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      initialSelection: widget._defaultCountryCode,
      // favorite: [],
      searchStyle: TextStyle(
          color: ColorData.primaryTextColor,
          fontWeight: null,
          // fontSize: 10.0,
          fontFamily: tr('currFontFamilyEnglishOnly')),
      // optional. Shows only country name and flag
      showCountryOnly: false,
      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,
      // optional. aligns the flag and the Text left
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
  }

  siffixIconfn() {
    if (widget._customLabelString == Strings.textFieldDOBLabel ||
        widget._customLabelString == Strings.textFieldDOBLabelArb) {
      return IconButton(
        onPressed: () {},
        icon: Icon(CommonIcons.calendar_border),
      );
    }
  }

  prefixIconfn() {
    if (widget._customLabelString == tr('mobileNumber')) {
      if (widget._defaultCountryCode == null) {
        return Icon(Icons.phone_iphone);
      } else {
        // return Container(height:2.0);
        return countryPickerfn();
      }
    } else {
      return Padding(
        padding: EdgeInsets.only(top: 4.0),
        child: Icon(
          widget._customLeadIcon,
          color: ColorData.inActiveIconColor,
        ),
      );
    }
  }

  verticalLine() {
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
      child: VerticalDivider(width: 2, color: Colors.black),
    );
  }
}
