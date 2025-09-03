import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/firebase/CustomNotificationFunction.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/repo/user_repository.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/dashboard/dashboard.dart';
import 'package:slc/view/home/bloc/bloc.dart';
import 'package:slc/view/home/facility/bloc/bloc.dart';
import 'package:slc/view/home/facility/facility.dart';
import 'package:slc/view/home/facility_group/bloc/bloc.dart';
import 'package:slc/view/home/facility_group/facility_group.dart';
import 'package:slc/view/login/login_page.dart';
import 'package:slc/view/notification/notification.dart';
import 'carousel/bloc/bloc.dart';
import 'carousel/carousel.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  double statusBarHeight =
      SPUtil.getDouble(Constants.STATUSBAR_HEIGHT, defValue: 0.0);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (context) {
            return HomeBloc()..add(ShowCommonProgresser());
          },
        ),
        BlocProvider<CarouselBloc>(
          create: (context) {
            return CarouselBloc(homeBloc: BlocProvider.of<HomeBloc>(context))
              ..add(GetCarouselList());
          },
        ),
        BlocProvider<FacilityGroupBloc>(
          create: (context) {
            return FacilityGroupBloc(
                homeBloc: BlocProvider.of<HomeBloc>(context))
              ..add(GetFacilityGroupList());
          },
        ),
        BlocProvider<FacilityBloc>(
          create: (context) {
            return FacilityBloc(homeBloc: BlocProvider.of<HomeBloc>(context));
//              ..add(RefreshFacility(selectedFacilityGroupId: 0));
          },
        )
      ],
      child: _Homepage(statusBarHeight),
    );
  }
}

// ignore: must_be_immutable
class _Homepage extends StatefulWidget {
  double statusBarHeight = 0.0;

  _Homepage(this.statusBarHeight);

  @override
  State<StatefulWidget> createState() {
    return HomepageState();
  }
}

class HomepageState extends State<_Homepage>
    with AutomaticKeepAliveClientMixin {
  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;

  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};
  double mainImageView = 0.0;
  double facilityImageView = 0.0;
  Utils util = Utils();

  // StreamSubscription<GeofenceStatus> _geofenceStatusStream;
  // String geofenceStatus = '';
  // bool showEnter = true;
  // bool showExit = false;
  HomepageState();

  // ignore: close_sinks
  HomeBloc homeBloc = HomeBloc();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    configLocalNotification();
    registerNotification(context);
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  void configLocalNotification() {
    // var initializationSettingsAndroid =
    //     new AndroidInitializationSettings('ic_launcher');
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('ic_notify');
    //  var initializationSettingsIOS = new IOSInitializationSettings();

    var initializationSettingsIOS = DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  }

  Future onSelectNotification(String payload) async {
    if (!Constants.isViewMore && !Constants.isLogoutDoneToClearPreference) {
      if (payload != null) {
        try {
          if (SPUtil.getInt(Constants.USERID) != 0) {
            if (!Constants.isNotFromNotificationFamily) {
              //this is to reset the event chiose chip selection
              Constants.eventsCurrentSelectedChoiseChip = 0;
              Get.offAll(Dashboard(
                selectedIndex: 0,
              ));
              Get.to(NotificationList());
              Constants.isNotFromNotificationFamily = false;
            } else if (Constants.isFromNotificationFamily == 2) {
              //this is to reset the event chiose chip selection
              Constants.eventsCurrentSelectedChoiseChip = 0;
              Navigator.pop(context, true);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NotificationList()));
            } else if (Constants.isFromNotificationFamily == 1) {
              //this is to reset the event chiose chip selection
              Constants.eventsCurrentSelectedChoiseChip = 0;
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => NotificationList()));
            }
          } else {
            Get.offAll(LoginPage(userRepository: UserRepository()));
          }
        } catch (e) {
          print(e);
        }
      }
    } else if (Constants.isViewMore) {
      Constants.isViewMore = false;
    }
  }

  String payload;

  // ignore: missing_return
  static Future<dynamic> back(
    Map<String, dynamic> message,
  ) {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        new FlutterLocalNotificationsPlugin();

    if (message.containsKey('notification')) {
      (message['image'] == "" || message['image'].toString().trim().length == 0)
          ? showOngoingNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              body: message['message'].toString(),
            )
          : showImageNotification(
              flutterLocalNotificationsPlugin,
              title: message['title'].toString(),
              picture: Image.network(message['image']),
              body: message['message'].toString(),
            );
    }
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {},
          )
        ],
      ),
    );
  }

  registerNotification(BuildContext context) {
    // subscribeTopics();

    FirebaseMessaging.onMessage.listen((RemoteMessage messageObj) {
      RemoteNotification notification = messageObj.notification;
      // AndroidNotification android = messageObj.notification?.android;
      Map<String, dynamic> message = messageObj.data;
      Constants.isLogoutDoneToClearPreference = false;
      if (Platform.isIOS) {
        if (message['title'] != null &&
            message['title'].toString() != 'SilentNotification') {
          (message['image'] == "" ||
                  message['image'].toString().trim().length == 0)
              ? showOngoingNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                )
              : showImageNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                  picture: Image.network(message['image']),
                );
        } else {
          SilentNotificationHandler silentNotificationHandler =
              SilentNotificationHandler.instance;
          silentNotificationHandler.updateData(
              prepareSilentNotification(message['message'].toString()));
        }
      } else {
        if (message['title'] != null &&
            message['title'].toString() != 'SilentNotification') {
          debugPrint(jsonEncode(message));
          (message['image'] == "" ||
                  message['image'].toString().trim().length == 0)
              ? showOngoingNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                )
              : showImageNotification(
                  flutterLocalNotificationsPlugin,
                  title: message['title'].toString(),
                  body: message['message'].toString(),
                  picture: Image.network(message['image']),
                );
        } else {
          SilentNotificationHandler silentNotificationHandler =
              SilentNotificationHandler.instance;
          silentNotificationHandler.updateData(
              prepareSilentNotification(message['message'].toString()));
        }
      }
      return false;
      // showNotification(notification);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!Constants.isViewMore && !Constants.isLogoutDoneToClearPreference) {
        if (payload != null) {
          try {
            if (SPUtil.getInt(Constants.USERID) != 0) {
              if (!Constants.isNotFromNotificationFamily) {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;
                Get.offAll(Dashboard(
                  selectedIndex: 0,
                ));
                Get.to(NotificationList());
                Constants.isNotFromNotificationFamily = false;
              } else if (Constants.isFromNotificationFamily == 2) {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;
                Navigator.pop(context, true);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationList()));
              } else if (Constants.isFromNotificationFamily == 1) {
                //this is to reset the event chiose chip selection
                Constants.eventsCurrentSelectedChoiseChip = 0;
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationList()));
              }
            } else {
              Get.offAll(LoginPage(userRepository: UserRepository()));
            }
          } catch (e) {
            print(e);
          }
        }
      } else if (Constants.isViewMore) {
        Constants.isViewMore = false;
      }
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void subscribeTopics() {
    firebaseMessaging.subscribeToTopic('/topics/SilentNotification');
  }

  Map<String, String> prepareSilentNotification(String type) {
    print(type);
    switch (type) {
      case Constants.NOTIFICATION_INVALID_USER:
        {
          return {
            Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_INVALID_USER
          };
        }
        break;

      case Constants.NOTIFICATION_EVENT:
        {
          return {Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_EVENT};
        }
        break;
      case Constants.NOTIFICATION_FACILITY:
        {
          return {Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_FACILITY};
        }
        break;
      case Constants.NOTIFICATION_CAROUSEL:
        {
          return {Constants.NOTIFICATION_KEY: Constants.NOTIFICATION_CAROUSEL};
        }
        break;

      default:
        {
          return {Constants.NOTIFICATION_KEY: 'empty'};
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenHeight = (MediaQuery.of(context).size.height);

    double appBarHeight = AppBar().preferredSize.height;

    double remainingHeight = screenHeight -
        (appBarHeight +
            kBottomNavigationBarHeight +
            SPUtil.getDouble(Constants.STATUSBAR_HEIGHT, defValue: 0.0));

    mainImageView = (remainingHeight * (42.0 / 100.0));
    facilityImageView = (remainingHeight * (16.0 / 100.0));
    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_CAROUSEL) {
      BlocProvider.of<CarouselBloc>(context)..add(GetCarouselList());
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_FACILITY) {
      BlocProvider.of<FacilityGroupBloc>(context)..add(GetFacilityGroupList());
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<HomeBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<HomeBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.LANGUAGE_CHANGE_REFRESH_HOME) {
      triggerBloc();
      SPUtil.putBool(Constants.LANGUAGE_CHANGE_REFRESH_HOME, false);
    }
    BlocProvider.of<HomeBloc>(context)..add(GetMarketingQuestionList());
    return Scaffold(
      backgroundColor: ColorData.backgroundColor,
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is ShowProgressBar) {
            _handler.show();
          } else if (state is HideProgressBar) {
            _handler.dismiss();
          } else if (state is OnFailure) {
            _handler.dismiss();
          } else if (state is ReTryingState) {
            _handler.show();
            BlocProvider.of<CarouselBloc>(context)..add(GetCarouselList());
            BlocProvider.of<FacilityGroupBloc>(context)
              ..add(GetFacilityGroupList());
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
          } else if (state is MarketingQuestionLoadedState) {
            if (state.marketingQuesitons != null &&
                state.marketingQuesitons.length > 0) {
              showDialog<Widget>(
                context: context,
                barrierDismissible: false, // user must tap button!
                builder: (BuildContext pcontext) {
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
                                "Marketing Question",
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
                                Localizations.localeOf(context).languageCode ==
                                        "ar"
                                    ? state.marketingQuesitons[0].questionAr
                                    : state.marketingQuesitons[0].question,
                                style: TextStyle(
                                    color: ColorData.primaryTextColor,
                                    fontSize: Styles.textSiz,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: tr("currFontFamily")),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(top: 10.0, left: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                // RaisedButton(
                                //     shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.all(
                                //             Radius.circular(5.0))),
                                //     color: ColorData.grey300,
                                //     child: new Text("Later",
                                //         style: TextStyle(
                                //             color: ColorData.primaryTextColor,
                                //             fontSize: Styles.textSizeSmall,
                                //             fontFamily: tr("currFontFamily"))),
                                //     onPressed: () {
                                //       Navigator.of(pcontext).pop();
                                //     }),
                                ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.black87),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                ColorData.grey300),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                          Radius.circular(5.0),
                                        )))),
                                    // shape: RoundedRectangleBorder(
                                    //     borderRadius: BorderRadius.all(
                                    //         Radius.circular(5.0))),
                                    // color: ColorData.grey300,
                                    child: new Text("No",
                                        style: TextStyle(
                                            color: ColorData.primaryTextColor,
                                            fontSize: Styles.textSizeSmall,
                                            fontFamily: tr("currFontFamily"))),
                                    onPressed: () async {
                                      Navigator.of(pcontext).pop();
                                      Meta m = await (new HomeRepository())
                                          .saveMarketingAnswer(
                                              state.marketingQuesitons[0]
                                                  .questionId,
                                              0);
                                      if (m.statusCode == 200) {
                                        util.customGetSnackBarWithOutActionButton(
                                            tr("survey"),
                                            "Thanks for your valuable feedback",
                                            context);
                                      } else {
                                        util.customGetSnackBarWithOutActionButton(
                                            tr("survey"), m.statusMsg, context);
                                      }
                                    }),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.white),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              ColorData.colorBlue),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      )))),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.all(
                                  //         Radius.circular(5.0))),
                                  // color: ColorData.colorBlue,
                                  child: new Text(
                                    "Yes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: Styles.textSizeSmall,
                                        fontFamily: tr("currFontFamily")),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(pcontext).pop();
                                    Meta m = await (new HomeRepository())
                                        .saveMarketingAnswer(
                                            state.marketingQuesitons[0]
                                                .questionId,
                                            1);
                                    if (m.statusCode == 200) {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("survey"),
                                          "Thanks for your valuable feedback",
                                          context);
                                    } else {
                                      util.customGetSnackBarWithOutActionButton(
                                          tr("survey"), m.statusMsg, context);
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
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is OnFailure) {
              return Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Image(
                        image: AssetImage(ImageData.error_img),
                      ),
                      const SizedBox(height: 30),
                      Text(state.error),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ColorData.accentColor),
                            shape: MaterialStateProperty
                                .all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            )))),
                        // color: ColorData.accentColor,
                        onPressed: _retryPage,
                        child: Text(
                          tr("retry"),
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ErrorDialogState) {}
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: ListView(
                children: <Widget>[
                  Container(
                      height: remainingHeight,
                      child: Stack(children: <Widget>[mainUi(), progressBar])),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    triggerBloc();
    return null;
  }

  triggerBloc() {
    BlocProvider.of<HomeBloc>(context)..add(ShowCommonProgresser());
    BlocProvider.of<CarouselBloc>(context)..add(RefreshGetCarouselList());
  }

  Widget mainUi() {
    SPUtil.putBool(Constants.IS_MENU_TAB_FULL, false);
    return Column(
      children: <Widget>[
        Container(
            height: mainImageView,
            child: Carousel(
              height: mainImageView,
            )),
        Container(
            height: facilityImageView,
            child: FacilityGroup(
              height: facilityImageView,
            )),
        Container(height: mainImageView, child: Facility())
      ],
    );
  }

  _retryPage() {
    BlocProvider.of<HomeBloc>(context).add(RetryTapped());
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage messageObj) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  RemoteNotification notification = messageObj.notification;
  Map<String, dynamic> message = messageObj.data;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();

  if (message.containsKey('notification')) {
    (message['image'] == "" || message['image'].toString().trim().length == 0)
        ? showOngoingNotification(
            flutterLocalNotificationsPlugin,
            title: message['title'].toString(),
            body: message['message'].toString(),
          )
        : showImageNotification(
            flutterLocalNotificationsPlugin,
            title: message['title'].toString(),
            picture: Image.network(message['image']),
            body: message['message'].toString(),
          );
  }

  print("Handling a background message: ${messageObj.messageId}");
}
