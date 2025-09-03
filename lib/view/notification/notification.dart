import 'dart:convert';
import 'dart:io';
import 'dart:ui' as prefix;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/first_letter_capitalized.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/customcomponentfields/customappbar.dart';
import 'package:slc/db/table_data.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/gmcore/utils/GMUtils.dart';
import 'package:slc/model/notification_list_response.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/booleans.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/datetime_utils.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/notification/notification_detail_pages_updated.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'bloc/bloc.dart';

class NotificationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() async {
      Constants.isNotFromNotificationFamily = false;
      Constants.isFromNotificationFamily = 0;
      Navigator.pop(context, true);
      return false;
    }

    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: BlocProvider(
          create: (context) {
            return NotificationBloc()
              ..add(
                  NotificationGetList(userId: SPUtil.getInt(Constants.USERID)));
          },
          child: NotificationPage(),
        ),
      ),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<NotificationListResponse> notificationResponseList = [];
  // new List<NotificationListResponse>();
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};
  Meta notificationResponseMeta = Meta();
  var localeEn = 'en';
  var localeAr = 'ar';
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    return BlocProvider.of<NotificationBloc>(context)
        .add(NotificationGetList(userId: SPUtil.getInt(Constants.USERID)));
  }

  @override
  void initState() {
    Constants.isNotFromNotificationFamily = true;
    Constants.isFromNotificationFamily = 1;
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
    super.initState();
  }

  @override
  void dispose() {
    Booleans.isChecked = false;
    super.dispose();
  }

  ProgressBarHandler _handler;

  String noDataFoundErrorText = "";
  Utils util = Utils();

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<NotificationBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<NotificationBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<NotificationBloc, NotificationState>(
      listener: (BuildContext context, state) async {
        if (state is OnNotificationGetReadStatusSuccess) {
          bool isRefresh = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationDetail(
                        notificationListResponse:
                            state.notificationListResponse,
                      )));
          if (isRefresh) {
            return BlocProvider.of<NotificationBloc>(context).add(
                NotificationGetList(userId: SPUtil.getInt(Constants.USERID)));
          }
        } else if (state is OnNotificationGetReadStatusFailure) {
          util.customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is OnNotificationClearSuccess) {
          setState(() {
            notificationResponseList = [];
            noDataFoundErrorText = tr('noDataFound');
          });
          util.customGetSnackBarWithOutActionButton(
              tr('success_caps'), tr("notificationCleared"), context);
        } else if (state is OnNotificationClearFailure) {
        } else if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
        } else if (state is OnNotificationGetListSuccess) {
          notificationResponseMeta = state.meta;
          notificationResponseList.clear();
          jsonDecode(state.meta.statusMsg)['response'].forEach((f) {
            notificationResponseList
                .add(new NotificationListResponse.fromJson(f));
          });

          if (notificationResponseList.length == 0 ||
              notificationResponseList.length == null) {
            noDataFoundErrorText = tr('noDataFound');
          } else {
            notificationResponseList.sort((a, b) => DateTimeUtils()
                .convertUTCToLocalDateTime(DateTime.parse(b.createdDate))
                .compareTo(DateTimeUtils()
                    .convertUTCToLocalDateTime(DateTime.parse(a.createdDate))));
          }

          storeNotificationListInLocal(state.meta);
        } else if (state is OnNotificationGetListFailure) {
          Utils().customGetSnackBarWithActionButton(
              tr('error_caps'), state.error, context);
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
        }
      },
      child: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (BuildContext context, state) {
          return Stack(children: <Widget>[
            buildScaffold(context),
            progressBar,
          ]);
        },
      ),
    );
  }

  Widget buildScaffold(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: CustomAppBar(
          title: tr('notification'),
        ),
      ),
      body: RefreshIndicator(
          key: refreshKey,
          onRefresh: refreshList,
          child: Container(
            color: Color.fromRGBO(241, 246, 251, 1),
            /*titleStrings.removeAt()*/
            child: Column(
              children: <Widget>[
                Visibility(
                    visible: notificationResponseList.length != 0 &&
                        notificationResponseList.length != null,
                    child: Align(
                      alignment:
                          Localizations.localeOf(context).languageCode == "en"
                              ? Alignment.topRight
                              : Alignment.topLeft,
                      child: GestureDetector(
                        onTap: () {
                          customAlertDialog(
                              context,
                              tr('areuwantclearall'),
                              tr('ok'),
                              tr('cancel'),
                              'Notification',
                              tr('confirm'),
                              () => {
                                    BlocProvider.of<NotificationBloc>(context)
                                        .add(ClearAllClicked(
                                            userId: SPUtil.getInt(
                                                Constants.USERID)))
                                  });
                        },
                        child: Padding(
                          padding:
                              Localizations.localeOf(context).languageCode ==
                                      "en"
                                  ? const EdgeInsets.only(
                                      top: 10.0, right: 17.0, bottom: 5.0)
                                  : const EdgeInsets.only(
                                      top: 10.0, left: 17.0, bottom: 5.0),
                          child: Text(
                            tr('clearal'),
                            style: NotificationListPageStyle
                                .notificationListClearAllTextStyle(context),
                          ),
                        ),
                      ),
                    )),
                notificationResponseList.length == null ||
                        notificationResponseList.length == 0
                    ? Center(
                        child: Container(
                          child: Text(noDataFoundErrorText,
                              style: NotificationListPageStyle
                                  .notificationListNoDataFoundTextStyle(
                                      context)),
                          margin: EdgeInsets.only(
                              top: (MediaQuery.of(context).size.height / 2) -
                                  50.0),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            primary: false,
                            itemCount: notificationResponseList.length,
                            itemBuilder: (BuildContext context, int i) {
                              var parsedDate = DateTimeUtils()
                                  .convertUTCToLocalDateTime(DateTime.parse(
                                      notificationResponseList[i].createdDate));
                              var eng = timeago.format(
                                  parsedDate.subtract(new Duration(
                                      microseconds: 1 * 44 * 1000)),
                                  locale: localeEn);
                              var arab = timeago.format(
                                  parsedDate.subtract(new Duration(
                                      microseconds: 1 * 44 * 1000)),
                                  locale: localeAr);

                              return Container(
                                margin: EdgeInsets.only(
                                  top: i == 0 ? 0.0 : 10.0,
                                  left: 15.0,
                                  right: 15.0,
                                ),

                                child: Card(
                                    elevation: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 5.0),
                                      child: ListTile(
                                        //lead: false,
                                        onTap: () async {
                                          setState(() {
                                            Constants.isFromNotificationFamily =
                                                2;
                                            Constants
                                                    .isNotFromNotificationFamily =
                                                true;
                                          });

                                          bool isAvailable = await GMUtils()
                                              .isInternetConnected();
                                          if (isAvailable) {
                                            if (notificationResponseList[i]
                                                    .isRead ==
                                                true) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          NotificationDetail(
                                                            notificationListResponse:
                                                                notificationResponseList[
                                                                    i],
                                                          )));
                                            } else if (notificationResponseList[
                                                        i]
                                                    .isRead ==
                                                false) {
                                              BlocProvider.of<NotificationBloc>(
                                                      context)
                                                  .add(
                                                NotificationGetReadStatus(
                                                    notificationCardId:
                                                        notificationResponseList[
                                                                i]
                                                            .notificationUserId),
                                              );
                                            }
                                          } else {
                                            util.customGetSnackBarWithOutActionButton(
                                                tr('error_caps'),
                                                tr("nonetworkviewnotification"),
                                                context);
                                          }
                                        },
                                        leading: Container(
                                            margin: EdgeInsets.only(left: 10.0),
                                            height: 35.0,
                                            width: 35.0,
                                            child: imageUI(
                                                notificationResponseList[i]
                                                    .notificationTypeImageUrl
                                                //  ,context
                                                )),

                                        title: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 15.0, left: 10.0),
                                          child: Text(
                                            notificationResponseList[i].title !=
                                                    null
                                                ? Capitalized
                                                    .capitalizeFirstLetter(
                                                        notificationResponseList[
                                                                i]
                                                            .title)
                                                : "",
                                            style: NotificationListPageStyle
                                                .notificationListTitleTextStyle(
                                                    context),
                                          ),
                                        ),
                                        // ),
                                        subtitle: Padding(
                                          padding: EdgeInsets.only(
                                              top: 5.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                //  height: 50.0,
                                                child: Text(
                                                  notificationResponseList[i]
                                                                  .shortMessage ==
                                                              null ||
                                                          notificationResponseList[
                                                                      i]
                                                                  .shortMessage ==
                                                              ""
                                                      ? ""
                                                      : Capitalized
                                                          .capitalizeFirstLetter(
                                                              notificationResponseList[
                                                                      i]
                                                                  .shortMessage),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: NotificationListPageStyle
                                                      .notificationListShortDescriptionTextStyle(
                                                          context),
                                                ),
                                              ),
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10.0,
                                                          bottom: 10.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? Alignment
                                                                .bottomLeft
                                                            : Alignment
                                                                .bottomRight,
                                                        child: Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              CommonIcons.clock,
                                                              color: ColorData
                                                                  .notificationTimeTextColor,
                                                              size: 12,
                                                            ),
                                                            Padding(
                                                              padding: Localizations.localeOf(
                                                                              context)
                                                                          .languageCode ==
                                                                      "en"
                                                                  ? EdgeInsets.only(
                                                                      left: 8.0,
                                                                      top: 3.0)
                                                                  : EdgeInsets.only(
                                                                      right:
                                                                          8.0,
                                                                      top: 3.0),
                                                              child: new Text(
                                                                Localizations.localeOf(context)
                                                                            .languageCode ==
                                                                        "en"
                                                                    ? eng
                                                                    : arab,
                                                                textDirection:
                                                                    prefix
                                                                        .TextDirection
                                                                        .ltr,
                                                                style: NotificationListPageStyle
                                                                    .notificationListTimeTextStyle(
                                                                        context),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? Alignment
                                                                .bottomRight
                                                            : Alignment
                                                                .bottomLeft,
                                                        child:
                                                            notificationResponseList[
                                                                        i]
                                                                    .isRead
                                                                ? Container()
                                                                : Container(
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            10.0),
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(2),
                                                                    decoration:
                                                                        new BoxDecoration(
                                                                      color: ColorData
                                                                          .colorBlue,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              6),
                                                                    ),
                                                                    constraints: BoxConstraints(
                                                                        minWidth:
                                                                            8,
                                                                        minHeight:
                                                                            8,
                                                                        maxHeight:
                                                                            8,
                                                                        maxWidth:
                                                                            8),
                                                                  ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                                // ),
                              );
                            }),
                      ),
              ],
            ),
          )),
    ));
  }

  Widget failureUI(OnNotificationGetListFailure state) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image(
              image: AssetImage(ImageData.error_img),
            ),
            const SizedBox(height: 30),
            Text(
              state.error,
              style: Styles.failureUIStyle,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              // color: ColorData.accentColor,
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(ColorData.accentColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(5.0),
                  )))),
              onPressed: () {
                //  _retryPage
              },
              child: Text(
                tr("retry"),
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  storeNotificationListInLocal(Meta m) async {
    await Utils().saveOfflineData(
        TableDetails.CID_NOTIFICATION_LIST +
            SPUtil.getInt(Constants.USERID).toString(),
        m);
  }

  Widget imageUI(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        child: Center(
          child: SizedBox(
              height: 15.0, width: 15.0, child: CircularProgressIndicator()),
        ),
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
