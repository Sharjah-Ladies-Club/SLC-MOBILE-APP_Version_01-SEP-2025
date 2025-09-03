import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/theme/colors.dart';

// ignore: must_be_immutable
class CustomRaisedButton extends StatefulWidget {
  String _btnTxt;
  Function _onTap;

  CustomRaisedButton(this._btnTxt, this._onTap);

  @override
  _CustomRaisedButtonState createState() => _CustomRaisedButtonState();
}

class _CustomRaisedButtonState extends State<CustomRaisedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
//            height: 45,
//            width: 350,
            child: ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ColorData.accentColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  )))),
              // color: ColorData.accentColor,
              // shape: new RoundedRectangleBorder(
              //   borderRadius: new BorderRadius.circular(10),
              // ),
              child: Text(
                widget._btnTxt,
                style: TextStyle(
                  color: ColorData.whiteColor,
                  fontSize: 14.0,
                  fontFamily: tr("currFontFamilyMedium"),
                  fontWeight: FontWeight.w400,
                ),
              ),
              onPressed: () {
                // print("tapped");
                widget._onTap();
              },
            ),
          ),
        ],
      ),
    );
  }
}
