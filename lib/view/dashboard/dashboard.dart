import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/custom_app_bar/bloc/custom_app_bar_bloc.dart';
import 'package:slc/common/custom_app_bar/bloc/custom_app_bar_event.dart';
import 'package:slc/common/default_scaffold.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/customIcons.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/events/events.dart';
import 'package:slc/view/home/bloc/bloc.dart';
import 'package:slc/view/home/home_page.dart';
import 'package:slc/view/more/more.dart';
import 'package:slc/view/survey/survey.dart';

// ignore: must_be_immutable
class Dashboard extends StatelessWidget {
  int selectedIndex;
  int facilityId;

  Dashboard({this.selectedIndex, this.facilityId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
        BlocProvider<CustomAppBarBloc>(
            create: (context) =>
                CustomAppBarBloc()..add(GetNotificationBadgeStatus())),
      ],
      child: _Dashboard(
          selectedIndex: this.selectedIndex, facilityId: this.facilityId),
    );
  }
}

// ignore: must_be_immutable
class _Dashboard extends StatefulWidget {
  int selectedIndex;
  int facilityId;

  _Dashboard({this.selectedIndex, this.facilityId});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DashboardPage(selectedIndex: selectedIndex, facilityId: facilityId);
  }
}

class _DashboardPage extends State<_Dashboard> with TickerProviderStateMixin {
  int selectedIndex = 0;
  int facilityId = 0;
  _DashboardPage({this.selectedIndex, this.facilityId});
  final PageStorageBucket bucket = PageStorageBucket();
  bool itemselect = true;
  double statusBarHeight = 0;
  List<Widget> pages = [];
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    pages = [
      DefaultScaffold(
        PageStorageKey(Constants.HOME),
        "home",
        HomePage(),
        0,
      ),
      DefaultScaffold(PageStorageKey(Constants.EVENTS), "event", Events(), 1),
      DefaultScaffold(
          PageStorageKey(Constants.SURVEY),
          "survey",
          Survey(
            facilityId: widget.facilityId,
          ),
          2),
      DefaultScaffold(PageStorageKey(Constants.MORE), "more", More(), 3),
    ];
    if (widget.selectedIndex != null && widget.selectedIndex > 0) {
      selectedIndex = widget.selectedIndex;
      SchedulerBinding.instance.addPostFrameCallback((_) => {_onItemTapped(2)});
    }
  }

  void _onItemTapped(int index) {
    //this is to reset the event chiose chip selection
    Constants.eventsCurrentSelectedChoiseChip = 0;

    pageController.jumpToPage(index);
    setState(() {
      selectedIndex = index;
    });
    itemselect = false;
  }

  // ignore: missing_return
  Map<String, String> prepareSilentNotification(int type) {
    switch (type) {
      case 0:
        {
          if (SPUtil.getBool(Constants.LANGUAGE_CHANGE_REFRESH_HOME)) {
            return {
              Constants.NOTIFICATION_KEY: Constants.LANGUAGE_CHANGE_REFRESH_HOME
            };
          }
        }
        break;

      case 1:
        {
          if (SPUtil.getBool(Constants.LANGUAGE_CHANGE_REFRESH_EVENT)) {
            return {
              Constants.NOTIFICATION_KEY:
                  Constants.LANGUAGE_CHANGE_REFRESH_EVENT
            };
          }
        }
        break;
      case 2:
        {
          if (SPUtil.getBool(Constants.LANGUAGE_CHANGE_REFRESH_SURVEY)) {
            return {
              Constants.NOTIFICATION_KEY:
                  Constants.LANGUAGE_CHANGE_REFRESH_SURVEY
            };
          }
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
    statusBarHeight = MediaQuery.of(context).padding.top;
    SPUtil.putDouble(Constants.STATUSBAR_HEIGHT, statusBarHeight);

    Future<void> _onPageChanged(int index) async {
      BlocProvider.of<CustomAppBarBloc>(context)
        ..add(GetNotificationBadgeStatus());

      // setState(() {
      //   SilentNotificationHandler silentNotificationHandler =
      //       SilentNotificationHandler.instance;
      //   silentNotificationHandler.updateData(prepareSilentNotification(index));
      // });
    }

    return Scaffold(
      bottomNavigationBar: Container(
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(15), topLeft: Radius.circular(15)),
          boxShadow: <BoxShadow>[
            BoxShadow(color: Colors.black12, spreadRadius: 5, blurRadius: 1)
          ],
        ),
        child: DefaultTabController(
          initialIndex: selectedIndex,
          length: 4,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              // height: 50,
              padding: EdgeInsets.only(left: 5, right: 5),
              //padding: EdgeInsets.only(top: 0,bottom: 0,left: 5,right: 5),
              child: TabBar(
                labelPadding: EdgeInsets.only(right: 10, left: 10),
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.elliptical(50, 50),
                        topRight: Radius.elliptical(50, 50),
                        bottomLeft: Radius.elliptical(50, 50),
                        bottomRight: Radius.elliptical(50, 50)),
                    color: Color.fromRGBO(239, 243, 248, 1)),
                onTap: _onItemTapped,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        selectedIndex == 0
                            ? new Icon(CustomIcons.HomeSelected,
                                color: Color.fromRGBO(62, 181, 227, 1))
                            : new Icon(CustomIcons.HomeUnselect,
                                color: Color.fromRGBO(147, 164, 184, 1)),
                        (selectedIndex == 0)
                            ? Expanded(
                                child: Container(
                                padding: EdgeInsets.only(top: 6),
                                child: new Text(
                                  tr(
                                    "home",
                                  ),
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorData.primaryTextColor,
                                      fontFamily: tr('currFontFamily'),
                                      fontSize: 11),
                                ),
                              ))
                            : new Text("")
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        selectedIndex == 1
                            ? Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: new Icon(CustomIcons.CalendarSelected,
                                    color: Color.fromRGBO(62, 181, 227, 1)),
                              )
                            : Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: new Icon(CustomIcons.CalendarUnselect,
                                    color: Color.fromRGBO(147, 164, 184, 1)),
                              ),
                        (selectedIndex == 1 && itemselect == false)
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(top: 6),
                                  child: new Text(tr("event"),
                                      textAlign: TextAlign.center,
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: ColorData.primaryTextColor,
                                          fontFamily: tr('currFontFamily'),
                                          fontSize: 11)),
                                ),
                              )
                            : new Text("")
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        selectedIndex == 2
                            ? new Icon(
                                CustomIcons.SurveySelected,
                                color: Color.fromRGBO(62, 181, 227, 1),
                                size: 25,
                              )
                            : new Icon(
                                CustomIcons.SurveyUnselect,
                                color: Color.fromRGBO(147, 164, 184, 1),
                                size: 25,
                              ),
                        (selectedIndex == 2 && itemselect == false)
                            ? Expanded(
                                child: Container(
                                padding: EdgeInsets.only(top: 6),
                                child: new Text(
                                  tr("survey"),
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorData.primaryTextColor,
                                      fontFamily: tr('currFontFamily'),
                                      fontSize: 11),
                                ),
                              ))
                            : new Text("")
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        selectedIndex == 3
                            ? new Icon(
                                CustomIcons.MoreSelected,
                                color: Color.fromRGBO(62, 181, 227, 1),
                                size: 25,
                              )
                            : new Icon(
                                CustomIcons.MoreUnselected,
                                color: Color.fromRGBO(147, 164, 184, 1),
                                size: 25,
                              ),
                        (selectedIndex == 3 && itemselect == false)
                            ? Expanded(
                                child: Container(
                                padding: EdgeInsets.only(top: 6),
                                child: new Text(
                                    tr(
                                      "more",
                                    ),
                                    textAlign: TextAlign.center,
                                    style: new TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: tr('currFontFamily'),
                                      color: ColorData.primaryTextColor,
                                      fontSize: 11,
                                    )),
                              ))
                            : new Text("")
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: _onPageChanged,
        children: pages,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
