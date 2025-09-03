import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefield_login.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/fonts.dart';
import 'package:slc/utils/iconsfile.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/pin_code_text_field_login.dart';

class LoginPageRender extends StatefulWidget {
  final TextEditingController _mobilenoController;
  final TextEditingController _passwordController;
  final Function onCountryCodeCallBack;

  LoginPageRender(this._mobilenoController, this._passwordController,
      this.onCountryCodeCallBack);

  @override
  _LoginPageRenderState createState() => _LoginPageRenderState();
}

class _LoginPageRenderState extends State<LoginPageRender> {
  GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  Utils util = Utils();
  String countryCodeForMobile = "+971";

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: LoginPageFields(
              widget._mobilenoController,
              tr('mobileNumber'),
              countryCodeForMobile,
              IconsFile.leadIconForMobile,
              TextInputTypeFile.textInputTypeMobile,
              TextInputAction.done,
              (_selectedCountry) => {
                widget.onCountryCodeCallBack(_selectedCountry.countryId),
              },
              //() => {}
            ),
          ),
          PinCodeTextField(
            textDirection: Localizations.localeOf(context).languageCode == "en"
                ? prefix.TextDirection.ltr
                : prefix.TextDirection.rtl,
            autofocus: false,
            controller: widget._passwordController,
            hideCharacter: true,
            highlight: true,
            defaultBorderColor: ColorData.textFieldUnderLine,
            maxLength: 4,
            pinBoxWidth: MediaQuery.of(context).size.width < 350.0
                ? (MediaQuery.of(context).size.width / 4) - 23.0
                : 65.0,
            pinBoxHeight: MediaQuery.of(context).size.width < 350.0
                ? ((MediaQuery.of(context).size.width / 4) - 23.0) - 15.0
                : 50.0,
            maskCharacter: Strings.maskText,
            onDone: (text) {
              print("DONE $text");
              print("DONE CONTROLLER ${widget._passwordController.text}");
            },
            wrapAlignment: WrapAlignment.spaceAround,
            pinBoxBorderWidth: 0.5,
            pinBoxDecoration: ProvidedPinBoxDecoration.defaultPinBoxDecoration,
            pinTextStyle: TextStyle(
              fontSize: FontSizeData.fontSizeThirty,
              fontFamily: tr('currFontFamily'),
            ),
            pinTextAnimatedSwitcherTransition:
                ProvidedPinBoxTextAnimation.scalingTransition,
            pinTextAnimatedSwitcherDuration:
                Duration(milliseconds: Integer.milliseconds),
            highlightAnimationBeginColor: ColorData.blackColor,
            highlightAnimationEndColor: ColorData.whiteColor,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

//  _onRegisterChangePasswordPressed() {
//    SPUtil.remove(Constants.REG_USER_EMAIL);
//    SPUtil.remove(Constants.REG_USER_MOBILE);
//    Constants.isChangePassword = true;
//    Navigator.of(context).push(
//      MaterialPageRoute(
//        builder: (context) {
//          return BaseInfoOne();
//        },
//      ),
//    );
//  }
}
