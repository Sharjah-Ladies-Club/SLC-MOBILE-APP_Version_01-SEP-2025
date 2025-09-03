import 'package:flutter/material.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/styles.dart';

// ignore: must_be_immutable
class LoginRegSubmitButton extends StatelessWidget {
  String btnTitle;
  Function loginBtn;

  LoginRegSubmitButton(this.btnTitle, this.loginBtn);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.3,
      height: 43.0,
      margin: EdgeInsets.only(top: 20.0, right: 10.0),
      child: new ElevatedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                child: PackageListHead.snackBarTextStyle(context, btnTitle)),
            Localizations.localeOf(context).languageCode == "en"
                ? Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Image.asset(
                      'assets/images/leftArrow.png',
                      height: 12,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(
                      Arrow.reverse_arrow,
                      size: 18,
                    ),
                  )
          ],
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
