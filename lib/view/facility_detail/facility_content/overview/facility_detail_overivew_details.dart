import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/theme/styles.dart';

// ignore: must_be_immutable
class FacilityOverView extends StatelessWidget {
  String description;

  FacilityOverView(this.description);

  @override
  Widget build(BuildContext context) {
    return Overview(description);
  }
}

// ignore: must_be_immutable
class Overview extends StatefulWidget {
  String description;

  Overview(this.description);

  @override
  State<StatefulWidget> createState() {
    return OverviewState();
  }
}

class OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return getOverviewDescriptionScreen(widget.description);
  }

  Widget getOverviewDescriptionScreen(String description) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
          top: 25.0, left: 15.0, right: 15.0, bottom: 10.0),
      child: SingleChildScrollView(
        child: Html(
            // customFont: tr('currFontFamily'),
            data: description,
            style: {
              "body": Style(
                padding: EdgeInsets.all(0),
                margin: Margins.all(0),
                color: ColorData.primaryTextColor,
              ),
              "p": Style(
                padding: EdgeInsets.all(0),
                margin: Margins.all(0),
              ),
              "span": Style(
                padding: EdgeInsets.all(0),
                margin: Margins.all(0),
                fontWeight: FontWeight.bold,
                fontSize: FontSize(Styles.discountTextSize),
                color: ColorData.cardTimeAndDateColor.withOpacity(0.5),
                fontFamily: tr('currFontFamily'),
              ),
              "h6": Style(
                  fontFamily: tr('currFontFamily'),
                  padding: EdgeInsets.all(0),
                  margin: Margins.all(0)),
            }),
      ),
    );
  }
}
