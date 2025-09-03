import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/dimension.dart';

// ignore: must_be_immutable
class CustomSwitchField extends StatefulWidget {
  String pageTitle;
  Function onLngSwitch;

  CustomSwitchField(this.pageTitle, this.onLngSwitch);

  @override
  CustomSwitchFieldState createState() => CustomSwitchFieldState();
}

class CustomSwitchFieldState extends State<CustomSwitchField> {
  @override
  Widget build(BuildContext context) {
//    var data = EasyLocalizationProvider.of(context).data;
    return Padding(
      padding: Localizations.localeOf(context).languageCode == "ar"
          ? const EdgeInsets.only(top: 8.0)
          : const EdgeInsets.all(0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "English",
            style: TextStyle(
              color: Localizations.localeOf(context).languageCode == "en"
                  ? Theme.of(context).primaryColor
                  : ColorData.primaryTextColor,
              fontSize: Dimension.fontSizeTwelve,
              fontFamily: tr('currFontFamilyEnglishOnly'),
            ),
          ),
          CupertinoSwitch(
            activeColor: Theme.of(context).primaryColor,
            value: Localizations.localeOf(context).languageCode == "ar"
                ? true
                : false,
            onChanged: (val) {
              if (val) {
                SPUtil.putInt(
                    Constants.CURRENT_LANGUAGE, Constants.LANGUAGE_ARABIC);
                Get.updateLocale(Locale("ar", "DZ"));
                context.setLocale(Locale("ar", "DZ"));
                print(Localizations.localeOf(context).languageCode);
              } else {
                SPUtil.putInt(
                    Constants.CURRENT_LANGUAGE, Constants.LANGUAGE_ENGLISH);
                Get.updateLocale(Locale("en", "US"));
                context.setLocale(Locale("en", "US"));
                print(Localizations.localeOf(context).languageCode);
              }
              // debugPrint(Localizations.localeOf(context).languageCode +
              //     " language code " +
              //     SPUtil.getInt(Constants.CURRENT_LANGUAGE).toString());
              widget.onLngSwitch(val);
              // onLangchange(context);
            },
          ),
          Text(
            "عربى",
            style: TextStyle(
              color: Localizations.localeOf(context).languageCode == "ar"
                  ? Theme.of(context).primaryColor
                  : ColorData.primaryTextColor,
              fontSize: Dimension.fontSizeTwelve,
              fontFamily: tr('currFontFamily'),
            ),
          ),
        ],
        // ),
      ),
    );
  }
}
