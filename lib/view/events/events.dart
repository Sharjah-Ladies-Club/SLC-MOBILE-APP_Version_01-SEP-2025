import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/events/bloc/bloc.dart';
import 'package:slc/view/events/event_tab_choice/tab_choice_chip.dart';
import 'package:slc/view/events/tab_content/bloc/tab_content_bloc.dart';
import 'package:slc/view/events/tab_content/event_tab_content.dart';
import 'event_tab_choice/bloc/bloc.dart';

double wid = 0.0;
List<RadioModel> tabHeader = [];

tabConfigure(BuildContext context) {
  if (tabHeader.length == 0) {
    tabNameHandler(context);
  } else if (tabHeader.length > 0) {
    tabHeader.clear();
    tabNameHandler(context);
  }
}

tabNameHandler(BuildContext context) {
  tabHeader.add(RadioModel(mobileCategoryName: 'events', isSelected: true));
  tabHeader.add(RadioModel(mobileCategoryName: 'reviews', isSelected: false));
}

// ignore: must_be_immutable
class Events extends StatelessWidget {
  double statusBarHeight =
      SPUtil.getDouble(Constants.STATUSBAR_HEIGHT, defValue: 0.0);

//  Events(this.statusBarHeight);

  @override
  Widget build(BuildContext context) {
    tabConfigure(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider<EventsBloc>(
          create: (context) {
            return EventsBloc();
          },
        ),
        BlocProvider<TabChoiceChipBloc>(
          create: (context) {
            return TabChoiceChipBloc(BlocProvider.of<EventsBloc>(context))
              ..add(ShowEventTabHeader(tab: tabHeader));
          },
        ),
        BlocProvider<TabContentBloc>(
          create: (context) {
            return TabContentBloc(BlocProvider.of<EventsBloc>(context));
          },
        ),
      ],
      child: _Events(
        statusBarHeight: statusBarHeight,
      ),
    );
  }
}

// ignore: must_be_immutable
class _Events extends StatefulWidget {
  double statusBarHeight = 0.0;

  _Events({Key key, this.statusBarHeight}) : super(key: key);

  @override
  _EventsState createState() => _EventsState();
}

ProgressDialog progressDialog;
ProgressBarHandler _handler;
double tabBarHeight = 0.0;
double tabContentHeight = 0.0;
double tabContentWidth = 0.0;

class _EventsState extends State<_Events> with AutomaticKeepAliveClientMixin {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    // TODO: implement initState
    // super.close();
    // _silentNotificationHandler.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    tabContentWidth = MediaQuery.of(context).size.width - 10;
    double appBarHeight = AppBar().preferredSize.height;

    // ignore: non_constant_identifier_names
    double RemainingHeight = MediaQuery.of(context).size.height -
        (appBarHeight +
            kBottomNavigationBarHeight +
            SPUtil.getDouble(Constants.STATUSBAR_HEIGHT, defValue: 0.0));

    tabBarHeight = (RemainingHeight * (8.0 / 100.0));
    tabContentHeight = (RemainingHeight * (91.0 / 100.0));
    var refreshKey = GlobalKey<RefreshIndicatorState>();

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] == Constants.NOTIFICATION_EVENT) {
      /*It will load current active tab only*/
      BlocProvider.of<EventsBloc>(context)..add(SilentRefreshEvent());
      SPUtil.putBool(Constants.IS_SILENT_NOTIFICATION_CALLED_FOR_EVENT, true);
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_TOKEN_EXPIRED) {
      print('user NOTIFICATION_TOKEN_EXPIRED---> ');

      BlocProvider.of<EventsBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_INVALID_USER) {
      print('user NOTIFICATION_INVALID_USER---> ');
      BlocProvider.of<EventsBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.LANGUAGE_CHANGE_REFRESH_EVENT) {
      BlocProvider.of<EventsBloc>(context)..add(ShowEventProgressBarEvent());
      BlocProvider.of<EventsBloc>(context)..add(RefreshEvent());
      SPUtil.putBool(Constants.LANGUAGE_CHANGE_REFRESH_EVENT, false);
    }

    Future<Null> refreshList() async {
      refreshKey.currentState?.show(atTop: false);
      BlocProvider.of<EventsBloc>(context)..add(ShowEventProgressBarEvent());
      BlocProvider.of<EventsBloc>(context)..add(RefreshEvent());
      return null;
    }

    return Scaffold(
      body: BlocListener<EventsBloc, EventsState>(
        listener: (context, state) {
          if (state is ShowEventProgressBarState) {
            _handler.show();
          } else if (state is HideEventProgressBarState) {
            _handler.dismiss();
          } else if (state is OnFailureEventState) {
            _handler.dismiss();
            Utils().customGetSnackBarWithOutActionButton(
                tr('error_caps'), (state.error), context);
          } else if (state is RefreshState) {
            BlocProvider.of<TabChoiceChipBloc>(context)
              ..add(ShowRefreshEventTabHeader(tab: tabHeader));
          } else if (state is SilentRefreshState) {
            BlocProvider.of<TabChoiceChipBloc>(context)
              ..add(SilentShowRefreshEventTabHeader(tab: tabHeader));
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
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return RefreshIndicator(
              key: refreshKey,
              onRefresh: refreshList,
              child: Container(
                  child: Stack(children: <Widget>[mainUi(), progressBar])),
            );
          },
        ),
      ),
    );
  }

  Widget mainUi() {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, left: 8.0, top: 8.0),
      child: Column(
        children: <Widget>[
          Container(height: tabBarHeight, child: EventTab(tabContentWidth)),
          Container(
              height: tabContentHeight - 8,
              child: EventTabContent(tabContentWidth)),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
