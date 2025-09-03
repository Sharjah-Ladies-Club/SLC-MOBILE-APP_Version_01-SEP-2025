import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/Beach/Beach_Page.dart';
import 'package:slc/view/facility_detail/bloc/bloc.dart';
import 'package:slc/view/facility_detail/carousel/bloc/bloc.dart';
import 'package:slc/view/fitness/fitness.dart';
import 'package:slc/view/tablebooking/TableBooking_Page.dart';

import 'carousel/facility_item_carousel.dart';
import 'facility_content/bloc/bloc.dart';
import 'facility_content/facility_content.dart';
import 'facility_content/packages/bloc/bloc.dart';
import 'facility_menu/bloc/facility_menu_bloc.dart';
import 'facility_menu/facility_menu.dart';

// ignore: must_be_immutable
class FacilityDetailsPage extends StatelessWidget {
  int facilityId = 0;
  int menuId = -1;
  int listId = -1;
  bool isClosed = true;
  FacilityDetailsPage(
      {this.facilityId, this.menuId, this.listId, this.isClosed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: MultiBlocProvider(
        providers: [
          BlocProvider<FacilityDetailBloc>(
              create: (context) => FacilityDetailBloc(null)
                ..add(new FacilityDetailRefreshEvent(facilityId: facilityId))),
          BlocProvider<FacilityItemDetailBloc>(
              create: (context) => FacilityItemDetailBloc(
                  facilityDetailBloc:
                      BlocProvider.of<FacilityDetailBloc>(context),
                  facilityDetailRepository: FacilityDetailRepository())
                ..add(GetFacilityItemDetails(facilityId: facilityId))),
          BlocProvider<FacilityMenuBloc>(
              create: (context) => FacilityMenuBloc(
                  facilityDetailBloc:
                      BlocProvider.of<FacilityDetailBloc>(context),
                  facilityDetailRepository: FacilityDetailRepository())),
          BlocProvider<FacilityContentBloc>(
              create: (context) => FacilityContentBloc(null)),
          BlocProvider<FacilityDetailPackagesBloc>(
              create: (context) => FacilityDetailPackagesBloc(
                  facilityDetailBloc:
                      BlocProvider.of<FacilityDetailBloc>(context),
                  facilityDetailRepository: FacilityDetailRepository())),
        ],
        child: _FacilityPage(
            facilityId: facilityId,
            menuId: menuId,
            listId: listId,
            isClosed: isClosed),
      ),
    );
  }
}

// ignore: must_be_immutable
class _FacilityPage extends StatefulWidget {
  int facilityId = 0;
  int menuId = -1;
  int listId = -1;
  bool isClosed = true;
  String colorCode = "";
  _FacilityPage({this.facilityId, this.menuId, this.listId, this.isClosed});

  @override
  State<StatefulWidget> createState() {
    return _Page();
  }
}

ProgressDialog progressDialog;
ProgressBarHandler _handler;
double screenHeight = 0.0;
double carouselHeight = 0.0;
double menuHeight = 0.0;
double contentHeight = 0.0;
double buttonHeight = 0.0;

class _Page extends State<_FacilityPage> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();

    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  // @override
  // // TODO: implement mounted
  // bool get mounted  {
  //   widget.listId = -1;
  //   super.mounted;
  // }

  @override
  void dispose() {
    // widget.listId = -1;
    _silentNotificationHandler.disposeStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + 55);
    carouselHeight = Platform.isIOS
        ? screenHeight * (50.0 / 100.0)
        : screenHeight * (47.0 / 100.0);
    menuHeight = Platform.isIOS ? 55 : 55;
    contentHeight = Platform.isIOS
        ? screenHeight * (40.0 / 100.0)
        : contentHeight = screenHeight * (44.0 / 100.0);
    buttonHeight = 40.0;
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<FacilityDetailBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<FacilityDetailBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return BlocListener<FacilityDetailBloc, FacilityDetailState>(
      listener: (context, state) {
        if (state is ShowFacilityDetailProgressBarState) {
          _handler.show();
        } else if (state is HideFacilityDetailProgressBarState) {
          _handler.dismiss();
        } else if (state is FacilityDetailsOnFailure) {
          _handler.dismiss();
        } else if (state is BeachPageState) {
        } else if (state is FacilityDetailRefreshState) {
          widget.colorCode = state.facilityDetailResponse.colorCode;
          setState(() {
            widget.isClosed = state.facilityDetailResponse.isClosed;
          });

          debugPrint(
              "ColorCodeCCCCCCCCCCCCCCCCCCCCCCCCCCCCC" + widget.colorCode);
        } else if (state is FacilityDetailCloseState) {
          setState(() {
            widget.isClosed = state.isClosed;
          });
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
      child: BlocBuilder<FacilityDetailBloc, FacilityDetailState>(
        builder: (context, state) {
          if (state is BeachPageState) {
            if (state.facilityId == Constants.FacilityBeach) {
              return BeachPage(
                facilityId: widget.facilityId,
                facilityItemGroupId: 20031,
                facilityItems: [],
              );
            }
            if (state.facilityId == Constants.FacilityLafeel) {
              return TableBookingPage(
                facilityId: widget.facilityId,
                facilityItemGroupId: 0,
              );
            }
          } else if (state is FitnessPageState) {
            return FitnessPage(
              facilityId: 3,
              colorCode: widget.colorCode,
              shop: widget.isClosed,
              haveFitnessMemberShip: 0,
              facilityMemberShip: [],
            );
          } else if (state is FacilityDetailsOnFailure) {
            return retryUi(state.error);
          }
          return RefreshIndicator(
            key: refreshKey,
            backgroundColor: Colors.white,
            onRefresh: refreshList,
            child: ListView(
              children: <Widget>[
                Container(
                    height: screenHeight + 55,
                    color: Colors.white,
                    child: Stack(
                        children: <Widget>[mainUI(context), progressBar])),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget mainUI(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          height: carouselHeight,
          child: FacilityItemCarousel(
            height: carouselHeight,
          ),
        ),
        Container(
          height: menuHeight,
          child: FacilityMenu(menuHeight, widget.menuId, () {
            widget.listId = -1;
          }),
        ),
        Container(
          height: contentHeight,
          child: FacilityContent(listId: widget.listId, menuId: widget.menuId),
        ),
        (widget.facilityId == Constants.FacilityBeach ||
                widget.facilityId == Constants.FacilityLafeel ||
                widget.facilityId == Constants.FacilityFitness)
            // &&
            //     widget.isClosed != null &&
            //     !widget
            //         .isClosed //widget.facilityId == Constants.FacilityCollage
            ? Container(
                width: MediaQuery.of(context).size.width - 60,
                margin: EdgeInsets.only(left: 10.0, right: 10.0),
                child: ElevatedButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                            widget.facilityId == Constants.FacilityBeach
                                ? tr('Buy_beach_pass')
                                : widget.facilityId == Constants.FacilityLafeel
                                    ? tr('book_table')
                                    : widget.facilityId ==
                                            Constants.FacilityFitness
                                        ? tr('fitness_title')
                                        : tr('book_party_hall'),
                            style: EventPeopleListPageStyle
                                .eventPeopleListPageBtnTextStyleWithAr(
                                    context)),
                      ),
                    ],
                  ),
                  style: ButtonStyle(
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Constants.FacilityKunooz == widget.facilityId
                            ? ColorData.toColor("199D9A")
                            : Constants.FacilityLafeel == widget.facilityId
                                ? ColorData.toColor("F7933A")
                                : Constants.FacilityFitness == widget.facilityId
                                    ? ColorData.toColor("A81B8D")
                                    : Theme.of(context).primaryColor,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      )))),
                  // shape: new RoundedRectangleBorder(
                  //   borderRadius: new BorderRadius.circular(8),
                  // ),
                  onPressed: () {
                    debugPrint("this is Facility" +
                        Constants.FacilityFitness.toString());
                    if (widget.facilityId == Constants.FacilityFitness) {
                      if (!widget.isClosed) {
                        setState(() {
                          BlocProvider.of<FacilityDetailBloc>(context).add(
                              FitnessPageEvent(facilityId: widget.facilityId));
                        });
                      } else {
                        Utils util = new Utils();
                        util.customGetSnackBarWithOutActionButton(
                            tr("shopclosed"), tr("shopmaintenance"), context);
                      }
                    } else {
                      setState(() {
                        BlocProvider.of<FacilityDetailBloc>(context)
                            .add(BeachPageEvent(facilityId: widget.facilityId));
                      });
                    }
                  },
                  // textColor: Colors.white,
                  // color: Constants.FacilityKunooz == widget.facilityId
                  //     ? ColorData.toColor("199D9A")
                  //     : Constants.FacilityLafeel == widget.facilityId
                  //         ? ColorData.toColor("F7933A")
                  //         : Theme.of(context).primaryColor,
                ),
              )
            : Text(""),
      ],
    );
  }

  Widget retryUi(String error) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              const SizedBox(height: 30),
              Image(
                image: AssetImage(ImageData.error_img),
              ),
              const SizedBox(height: 30),
              Text(error),
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
                      Radius.circular(10.0),
                    )))),
                onPressed: _retryPage,
                child: Text(
                  tr("retry"),
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    BlocProvider.of<FacilityDetailBloc>(context)
      ..add(FacilityDetailRefreshEvent(facilityId: widget.facilityId));
    BlocProvider.of<FacilityItemDetailBloc>(context)
        .add(ReloadFacilityItemDetails(facilityId: widget.facilityId));
    return null;
  }

  _retryPage() {
    BlocProvider.of<FacilityDetailBloc>(context)
      ..add(FacilityDetailRefreshEvent(facilityId: widget.facilityId));
    BlocProvider.of<FacilityItemDetailBloc>(context)
      ..add(GetFacilityItemDetails(facilityId: widget.facilityId));
  }
}
