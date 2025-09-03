import 'dart:ui' as prefix;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefields.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/fonts.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/iconsfile.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/otp/pin_code_text_field.dart';
import 'package:slc/view/registration/page_one/base_info_one.dart';

// ignore: must_be_immutable
class LoginPageRender extends StatefulWidget {
  TextEditingController _mobilenoController;
  TextEditingController _passwordController;
  Function onCountryCodeCallBack;

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
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: LoginPageFields(
                widget._mobilenoController,
                /*mobileNumber*/
                tr('mobileNumber'),
                countryCodeForMobile,
                IconsFile.leadIconForMobile,
                TextInputTypeFile.textInputTypeMobile,
                TextInputAction.done,
                (_selectedCountry) => {
                      widget.onCountryCodeCallBack(_selectedCountry.countryId),
                    },
                () => {}),
          ),
          PinCodeTextField(
            textDirection: Localizations.localeOf(context).languageCode == "en"
                ? prefix.TextDirection.ltr
                : prefix.TextDirection.rtl,
            autofocus: false,
            controller: widget._passwordController,
            hideCharacter: true,
            highlight: true,
            defaultBorderColor: ColorData.eventHomePageDeSelectedCircularFill,
            maxLength: 4,
            pinBoxWidth: 55.0,
            pinBoxHeight: 50.0,
            maskCharacter: Strings.maskText,
            onDone: (text) {},
            wrapAlignment: WrapAlignment.spaceAround,
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
          Container(
            margin: EdgeInsets.only(top: 10.0, right: 10.0),
            child: Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  _onRegisterChangePasswordPressed();
                },
                child: PackageListHead.customTextView(
                    context, 1.0, tr('changePassword'), true, null),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _onRegisterChangePasswordPressed() {
    SPUtil.remove(Constants.REG_USER_EMAIL);
    SPUtil.remove(Constants.REG_USER_MOBILE);
    Constants.isChangePassword = true;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return BaseInfoOne();
        },
      ),
    );
  }
}
