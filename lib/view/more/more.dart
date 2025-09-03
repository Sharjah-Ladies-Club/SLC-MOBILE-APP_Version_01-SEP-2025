import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/loginregcustomcomponents/common_switch_button.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/booleans.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/dimension.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/login/login_page.dart';
import 'package:slc/view/more/bloc/bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class More extends StatelessWidget {
//  UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    //return Container();
    return BlocProvider<MoreBloc>(
      create: (context) => MoreBloc(),
      child: _More(),
    );
  }
}

class _More extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MorePage();
  }
}

class _MorePage extends State<_More> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};
  Utils util = Utils();
  ProgressBarHandler _handler;
  String versionName = "";
  MorePageStyle morePageStyle = MorePageStyle();

  @override
  void initState() {
    super.initState();
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });

    getVersionName().then((val) => setState(() {
          versionName = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<MoreBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<MoreBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<MoreBloc, MoreState>(
      listener: (context, state) {
        if (state is ShowMoreProgressBarState) {
          _handler.show();
        } else if (state is HideMoreProgressBarState) {
          _handler.dismiss();
        } else if (state is LogoutSuccess) {
          setState(() {
            Constants.iSEditClickedInProfile = false;
            Constants.isLogoutDoneToClearPreference = true;
            SPUtil.remove(Constants.USERID);
            Booleans.hasTimerStopped = true;
          });

          Get.offAll(() => LoginPage(
                userRepository: UserRepository(),
              ));
        } else if (state is LogoutFailure) {
          _handler.dismiss();
          Navigator.of(context).pop();
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), tr("logout_failed"), context);
        } else if (state is ErrorDialogState &&
            !SPUtil.getBool(Constants.PREVENT_MULTIPLE_DIALOG)) {
          SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, true);
          SPUtil.remove(Constants.USERID);
          getCustomAlertPositive(
            context,
            positive: () {
              SPUtil.putBool(Constants.PREVENT_MULTIPLE_DIALOG, false);

              exit(0);
            },
            title: state.title,
            content: state.content,
          );
        } else if (state is DeactivateSuccess) {
          setState(() {
            Constants.iSEditClickedInProfile = false;
            Constants.isLogoutDoneToClearPreference = true;
            SPUtil.remove(Constants.USERID);
            Booleans.hasTimerStopped = true;
          });

          Get.offAll(() => LoginPage(
                userRepository: UserRepository(),
              ));
        }
      },
      child: BlocBuilder<MoreBloc, MoreState>(
        builder: (context, state) {
          return Stack(children: <Widget>[mainUI(), progressBar]);
        },
      ),
    );
  }

  Widget mainUI() {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  versionName,
                  style: TextStyle(
                      color: ColorData.secondaryTextColor,
                      fontSize: Dimension.fontSizeTwelve),
                )),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: ListTile(
                leading: SvgPicture.asset(ImageData.language),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    morePageStyle.morePageTextStyle(context, 'language'),
                    CustomSwitchField('more', (bool onLngSwitchVal) {
                      SPUtil.putBool(
                          Constants.LANGUAGE_CHANGE_REFRESH_HOME, true);
                      SPUtil.putBool(
                          Constants.LANGUAGE_CHANGE_REFRESH_EVENT, true);
                      SPUtil.putBool(
                          Constants.LANGUAGE_CHANGE_REFRESH_SURVEY, true);
                      setState(() {
                        SilentNotificationHandler silentNotificationHandler =
                            SilentNotificationHandler.instance;
                        silentNotificationHandler.updateData({
                          Constants.NOTIFICATION_KEY:
                              Constants.LANGUAGE_CHANGE_REFRESH_HOME
                        });
                      });
                    }),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Divider(height: 4.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 5.0, left: 15.0, right: 15.0),
              child: ListTile(
                leading: SvgPicture.asset(
                  ImageData.more_about,
                  height: 35.0,
                  width: 35.0,
                ),
                title: Container(
                  margin: EdgeInsets.only(
                    right: Localizations.localeOf(context).languageCode == "en"
                        ? 40.0
                        : 0.0,
                    left: Localizations.localeOf(context).languageCode == "en"
                        ? 0.0
                        : 40.0,
                  ),
                  child: Center(
                    child: morePageStyle.morePageTextStyle(context, 'about_us'),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: 5.0,
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 35.0
                      : 20.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 20.0
                      : 35.0),
              child: Text(
                tr('about_us_content'),
                textAlign: TextAlign.justify,
                style: morePageStyle.morePageAboutUsTextStyle(context),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 30.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 30.0
                      : 36.0,
                  top: 10.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    launch(
                        "tel://" + tr('more_phone_number').replaceAll(' ', ''));
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        ImageData.more_call,
                        height: 26.0,
                        width: 26.0,
                      ),
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 20.0)
                                : EdgeInsets.only(right: 20.0),
                        child: morePageStyle.morePageTextStyleForNumbers(
                            context, 'more_phone_number'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 20.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 20.0
                      : 36.0,
                  top: 5.0),
//              padding: EdgeInsets.only(left: 36.0, right: 20.0, top: 5.0),
              child: Divider(height: 4.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 30.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 30.0
                      : 36.0,
                  top: 5.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    send(tr('more_email_id'), context);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        ImageData.more_mail,
                        height: 26.0,
                        width: 26.0,
                      ),
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 20.0)
                                : EdgeInsets.only(right: 20.0),
                        child: morePageStyle.morePageTextStyleForEmailNumbers(
                            context, 'more_email_id'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 20.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 20.0
                      : 36.0,
                  top: 5.0),
              child: Divider(height: 4.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 30.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 30.0
                      : 36.0,
                  top: 5.0),
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    sendURL(Constants.MORE_LOCATION, context);
                  },
                  child: Row(
                    children: <Widget>[
                      SvgPicture.asset(
                        ImageData.more_location,
                        height: 26.0,
                        width: 26.0,
                      ),
                      Padding(
                        padding:
                            Localizations.localeOf(context).languageCode == "en"
                                ? EdgeInsets.only(left: 20.0)
                                : EdgeInsets.only(right: 20.0),
                        child: morePageStyle.morePageTextStyle(
                            context, 'more_location'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Localizations.localeOf(context).languageCode == "en"
                      ? 36.0
                      : 20.0,
                  right: Localizations.localeOf(context).languageCode == "en"
                      ? 20.0
                      : 36.0,
                  top: 5.0),
              child: Divider(height: 4.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0, right: 15.0, top: 5.0, bottom: 5.0),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 30.0,
                    right: 30.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          sendURL(Constants.MORE_FACEBOOK, context);
                        },
                        child: SvgPicture.asset(
                          ImageData.more_social_fb,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendURL(Constants.MORE_TWITTER, context);
                        },
                        child: SvgPicture.asset(
                          ImageData.more_social_twitter,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendURL(Constants.MORE_INSTAGRAM, context);
                        },
                        child: SvgPicture.asset(
                          ImageData.more_social_instagram,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendURL(Constants.MORE_SITE, context);
                        },
                        child: SvgPicture.asset(
                          ImageData.more_social_web,
                          height: 40.0,
                          width: 40.0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          String message = tr('whatsAppStaticMorePageMsg') +
                              " " +
                              SPUtil.getString(Constants.USER_FIRSTNAME) +
                              " " +
                              SPUtil.getString(Constants.USER_LASTNAME) +
                              ".";

                          goToWhatsApp1(
                              tr('more_phone_number').replaceAll('+', ''),
                              message);
                          // goToWhatsApp(Constants.whatsAppURL(
                          //     tr('more_phone_number').replaceAll('+', ''),
                          //     tr('whatsAppStaticMorePageMsg') +
                          //         " " +
                          //         Constants.whatsAppReplaceTxt +
                          //         "."));
                        },
                        child: Container(
                          decoration: BoxDecoration(
//                                      color: Color.fromRGBO(14, 150, 119, 1),
                              color: ColorData.successSnakBr,
                              shape: BoxShape.circle),
                          child: Padding(
                            padding: EdgeInsets.all(9.0),
                            child: Icon(WhatsAppIcon.whatsapp,
                                size: 22, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 15.0),
              child: Divider(height: 4.0),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
              child: ListTile(
                leading: SvgPicture.asset(ImageData.logout),
                title: morePageStyle.morePageTextStyle(context, 'logout'),
                onTap: () {
                  getCustomAlertPositiveNegative(context, positive: () {
                    BlocProvider.of<MoreBloc>(context).add(
                      LogoutEvent(),
                    );
                  }, negative: () {
                    Navigator.of(context).pop();
                  }, title: tr("logout"), content: tr("logout_description"));
                },
              ),
            ),
            Visibility(
                visible: Platform.isIOS,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 15.0),
                  child: Divider(height: 4.0),
                )),
            Visibility(
                visible: true,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 10.0, left: 15.0, right: 15.0),
                  child: ListTile(
                    leading: Icon(Icons.delete_forever_outlined),
                    title:
                        morePageStyle.morePageTextStyle(context, 'deactivate'),
                    onTap: () {
                      getCustomAlertPositiveNegative(context, positive: () {
                        BlocProvider.of<MoreBloc>(context).add(
                          DeactivateEvent(),
                        );
                      }, negative: () {
                        Navigator.of(context).pop();
                      },
                          title: tr("deactivate"),
                          content: tr("deactivate_description"));
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<String> getVersionName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    return tr('version') + " " + version;
  }

  Future<void> sendURL(String url, BuildContext context) async {
    try {
      await launch(url);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorData.accentColor,
        content: Text(
          tr("emailClientNotFoundError"),
        ),
      ));
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: ColorData.accentColor,
      //     content: Text(
      //       tr("emailClientNotFoundError"),
      //     ),
      //   ),
      // );
      print(error);
    }
  }

  Future<void> send(String mailId, BuildContext context) async {
    final Email email = Email(
      recipients: [mailId],
      isHTML: false,
    );

    try {
      await FlutterEmailSender.send(email);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: ColorData.accentColor,
        content: Text(
          tr("emailClientNotFoundError"),
        ),
      ));
      // Scaffold.of(context).showSnackBar(
      //   SnackBar(
      //     backgroundColor: ColorData.accentColor,
      //     content: Text(
      //       tr("emailClientNotFoundError"),
      //     ),
      //   ),
      // );
      print(error);
    }
  }

  // Future<void> goToWhatsApp(whatsAppURL) async {
  //   debugPrint("LLLLLLLLLLLLLLLLLLLLLLLLL \n$whatsAppURL");
  //   await canLaunch(whatsAppURL)
  //       ? launch(whatsAppURL)
  //       : util.customGetSnackBarWithOutActionButton(
  //           tr('error_caps'), tr("whatsAppNotInstalled"), context);
  // }

  Future<void> goToWhatsApp1(String contact, String whatsAppURL) async {
    var androidUrl = "whatsapp://send?phone=$contact&text=$whatsAppURL";
    var iosUrl = "https://wa.me/$contact?text=${Uri.parse(whatsAppURL)}";
    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      util.customGetSnackBarWithOutActionButton(
          tr('error_caps'), tr("whatsAppNotInstalled"), context);
    }
  }
}
