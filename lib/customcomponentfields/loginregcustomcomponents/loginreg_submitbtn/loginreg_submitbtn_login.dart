import 'package:flutter/material.dart';
import 'package:slc/theme/styles.dart';

// ignore: must_be_immutable
class LoginRegSubmitButton extends StatelessWidget {
  String btnTitle;
  Function loginBtn;

  LoginRegSubmitButton(this.btnTitle, this.loginBtn);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.3,
      height: 43.0,
      margin: Localizations.localeOf(context).languageCode == "en"
          ? EdgeInsets.only(right: 20.0)
          : EdgeInsets.only(left: 20.0),
      child: new ElevatedButton(
        child: Container(
          child: PackageListHead.snackBarTextStyle(context, btnTitle),
        ),
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(
                Theme.of(context).primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            )))),
        // shape: new RoundedRectangleBorder(
        //   borderRadius: new BorderRadius.circular(8),
        // ),
        onPressed: () {
          loginBtn();
        },
        // textColor: Colors.white,
        // color: Theme.of(context).primaryColor,
      ),
    );
  }
}
