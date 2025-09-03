import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/loginpagefiledwhite.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/iconsfile.dart';
import 'package:slc/utils/strings.dart';
import 'package:slc/utils/textinputtypefile.dart';
import 'package:slc/utils/utils.dart';

class BaseInfoOnePageRender extends StatefulWidget {
  final TextEditingController mobilenoController;
  final TextEditingController emailController;
  final Function onCountryCodeCallBack;

  BaseInfoOnePageRender(
      {Key key,
      this.mobilenoController,
      this.emailController,
      this.onCountryCodeCallBack})
      : super(key: key);

  @override
  _BaseInfoOnePageRenderState createState() => _BaseInfoOnePageRenderState();
}

class _BaseInfoOnePageRenderState extends State<BaseInfoOnePageRender> {
//  final GlobalKey<FormBuilderState> _baseInfoOneFormKey =
//      GlobalKey<FormBuilderState>(debugLabel: 'baseinfo1');

  String countryCodeForMobile = "+971";
  Utils util = Utils();
  RegExp regExp = new RegExp(
    Constants.UAE_MOBILE_PATTERN,
    caseSensitive: false,
    multiLine: false,
  );

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
//      key: _baseInfoOneFormKey,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: LoginPageFieldWhite(
                widget.mobilenoController,
                /*mobileNumber*/

                tr('mobileNumber'),
                countryCodeForMobile,
                IconsFile.leadIconForMobile,
                TextInputTypeFile.textInputTypeMobile,
                TextInputAction.done,
                (_selectedCountry) => {
                      // setState(() {

                      //   _selectedCountryId = _selectedCountry.countryId;
                      // }),
                      widget.onCountryCodeCallBack(_selectedCountry.countryId,
                          _selectedCountry.dialCode),
                    },
                () => {},
                isWhite: true),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: LoginPageFieldWhite(
                widget.emailController,
                tr('emailLabel'),
                Strings.countryCodeForNonMobileField,
                CommonIcons.mail,
                TextInputTypeFile.textInputTypeEmail,
                TextInputAction.done,
                () => {},
                () => {},
                isWhite: true),
          ),
        ],
      ),
    );
  }
}
