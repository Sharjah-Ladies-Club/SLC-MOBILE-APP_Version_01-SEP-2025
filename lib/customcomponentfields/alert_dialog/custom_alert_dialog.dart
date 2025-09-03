import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/theme/styles.dart';

Future<Widget> customAlertPositive(BuildContext context, String mesageTxt,
    String positiveTxt, String alertTitle, Function positiveBtnClicked) async {
  return showDialog<Widget>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    alertTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"),
                      fontWeight: FontWeight.w500,
                      fontSize: Styles.textSizeSmall,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    mesageTxt,
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontWeight: FontWeight.w400,
                        fontFamily: tr("currFontFamily")),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      // color: ColorData.colorBlue,
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorData.colorBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          )))),
                      child: new Text(
                        positiveTxt,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Styles.textSizeSmall,
                            fontFamily: tr("currFontFamily")),
                      ),
                      onPressed: () async {
                        Navigator.pop(context);
                        positiveBtnClicked();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<Widget> customAlertDialog(
    BuildContext context,
    String mesageTxt,
    String positiveTxt,
    String negativeTxt,
    String pageTitle,
    String alertTitle,
    Function positiveBtnClicked) async {
  return showDialog<Widget>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    alertTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"),
                      fontWeight: FontWeight.w500,
                      fontSize: Styles.textSizeSmall,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    mesageTxt,
                    style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontWeight: FontWeight.w400,
                        fontFamily: tr("currFontFamily")),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.grey300),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )))),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(5.0))),
                        // color: ColorData.grey300,
                        child: new Text(negativeTxt,
                            style: TextStyle(
                                color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                fontSize: Styles.textSizeSmall,
                                fontFamily: tr("currFontFamily"))),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    ElevatedButton(
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      // color: ColorData.colorBlue,
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorData.colorBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          )))),
                      child: new Text(
                        positiveTxt,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: Styles.textSizeSmall,
                            fontFamily: tr("currFontFamily")),
                      ),
                      onPressed: () async {
                        if (pageTitle == "Notification") {
                          bool isAvailable =
                              await GMUtils().isInternetConnected();
                          if (isAvailable) {
                            positiveBtnClicked();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                            customAlertDialog(
                                context,
                                tr('nonetwork'),
                                tr('retry'),
                                tr('cancel'),
                                'Notification',
                                tr('retry'),
                                () => {});
                          }
                        } else if (pageTitle == tr("otp")) {
                          Navigator.pop(context);
                          positiveBtnClicked();
                        } else {
                          positiveBtnClicked();
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<Widget> getCustomAlertPositive(BuildContext context,
    {Function positive, String title, String content}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return new WillPopScope(
        // ignore: missing_return
        onWillPop: () {},
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      title /*tr("logout")*/,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily"),
                        fontSize: Styles.textSizeSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      content /*tr("logout_description")*/,
                      style: TextStyle(
                        fontSize: Styles.textSiz,
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily"),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.colorBlue),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )))),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(5.0))),
                        // color: ColorData.colorBlue,
                        child: new Text(
                          tr("ok"),
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.white,
                              fontFamily: tr("currFontFamily")),
                        ),
                        onPressed: positive,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Future<Widget> getCustomAlertPositiveNegative(BuildContext context,
    {Function positive,
    Function negative,
    String title,
    String content}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontFamily: tr("currFontFamily"),
                      fontSize: Styles.textSizeSmall,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Center(
                  child: Text(
                    content,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: ColorData.primaryTextColor,
                      fontSize: Styles.textSiz,
                      fontFamily: tr("currFontFamily"),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.grey300),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )))),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius:
                        //         BorderRadius.all(Radius.circular(5.0))),
                        // color: ColorData.grey300,
                        child: new Text(tr("cancel"),
                            style: TextStyle(
                                fontSize: Styles.textSizeSmall,
                                color: ColorData.primaryTextColor,
//                                color: Colors.black45,
                                fontFamily: tr("currFontFamily"))),
                        onPressed: negative),
                    ElevatedButton(
                      style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              ColorData.colorBlue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          )))),
                      // shape: RoundedRectangleBorder(
                      //     borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      // color: ColorData.colorBlue,
                      child: new Text(
                        tr("ok"),
                        style: TextStyle(
                            fontSize: Styles.textSizeSmall,
                            color: Colors.white,
                            fontFamily: tr("currFontFamily")),
                      ),
                      onPressed: positive,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

//foce updATE ALERT

Future<Widget> getCustomForceUpdatePositiveBtnAlert(BuildContext context,
    {Function positive,
    String title,
    String content,
    String positiveBtnName}) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context1) {
      return new WillPopScope(
        onWillPop: () {
          exit(0);
          //return;
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
          ),
          content: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      title /*tr("logout")*/,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontFamily: tr("currFontFamily"),
                        fontSize: Styles.textSizeSmall,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Center(
                    child: Text(
                      content /*tr("logout_description")*/,
                      style: TextStyle(
                        color: ColorData.primaryTextColor,
                        fontSize: Styles.textSiz,
                        fontFamily: tr("currFontFamily"),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.colorBlue),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            )))),
                        child: new Text(
                          positiveBtnName,
                          style: TextStyle(
                              fontSize: Styles.textSizeSmall,
                              color: Colors.white,
                              fontFamily: tr("currFontFamily")),
                        ),
                        onPressed: positive,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
