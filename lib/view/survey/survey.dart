// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/colors.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/survey/bloc/bloc.dart';
import 'package:slc/view/survey/survey_facility/bloc/bloc.dart';
import 'package:slc/view/survey/survey_facility/survey_facility.dart';
import 'package:slc/view/survey/survey_question/bloc/bloc.dart';
import 'package:slc/view/survey/survey_question/survey_question.dart';

class Survey extends StatelessWidget {
  int facilityId;
  Survey({this.facilityId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NSurveyBloc>(
          create: (context) {
            return NSurveyBloc();
          },
        ),
        BlocProvider<SurveyFacilityBloc>(
          create: (context) {
            return SurveyFacilityBloc(
                surveyBloc: BlocProvider.of<NSurveyBloc>(context))
              ..add(GetSurveyFacilityEvent());
          },
        ),
        BlocProvider<SurveyQuestionBloc>(
          create: (context) {
            return SurveyQuestionBloc(
                surveyBloc: BlocProvider.of<NSurveyBloc>(context));
          },
        )
      ],
      child: SurveyForm(
        facilityId: this.facilityId,
      ),
    );
  }
}

class SurveyForm extends StatefulWidget {
  int facilityId;
  SurveyForm({this.facilityId});
  @override
  State<StatefulWidget> createState() {
    return _SurveyState();
  }
}

class _SurveyState extends State<SurveyForm> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  ProgressDialog progressDialog;
  ProgressBarHandler _handler;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> refreshList() async {
    SPUtil.putBool(Constants.IS_FACILITY_LIST_RELOADED, true);
    refreshKey.currentState?.show(atTop: false);
    BlocProvider.of<SurveyFacilityBloc>(context)..add(GetSurveyFacilityEvent());
    return null;
  }

  @override
  void initState() {
    super.initState();
    Constants.isViewMore = false;
    /*Pull refresh handler for drop down list*/
    SPUtil.putBool(Constants.IS_FACILITY_LIST_RELOADED, false);
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      BlocProvider.of<NSurveyBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<NSurveyBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] ==
            Constants.LANGUAGE_CHANGE_REFRESH_SURVEY) {
      SPUtil.putBool(Constants.IS_FACILITY_LIST_RELOADED, true);
      BlocProvider.of<SurveyFacilityBloc>(context)
        ..add(GetSurveyFacilityEvent());
      SPUtil.putBool(Constants.LANGUAGE_CHANGE_REFRESH_SURVEY, false);
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] == Constants.KEYBOARD_HIDE_SURVEY) {
      hideKeyboard();
    }

    return Scaffold(
      body: BlocListener<NSurveyBloc, NSurveyState>(listener: (context, state) {
        if (state is SuccessState) {
          Utils().customGetSnackBarWithOutActionButton(
              tr('success_caps'), tr('survey_sav'), context);
          SPUtil.putBool(Constants.IS_FACILITY_LIST_RELOADED, true);
          BlocProvider.of<SurveyFacilityBloc>(context)
            ..add(GetSurveyFacilityEvent());
          //  surveySnackBar(ColorData.greenColor, appl.tr("survey_sav"));
        } else if (state is FailureState) {
          _handler.dismiss();
          Utils().customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
          // surveySnackBar(ColorData.redColor, state.error);
        } else if (state is ShowProgressState) {
          _handler.show();
        } else if (state is HideProgressState) {
          _handler.dismiss();
        } else if (state is RetryState) {
          _handler.dismiss();
          reTryUI(state.error);
        } else if (state is PullToRefreshState) {
          BlocProvider.of<NSurveyBloc>(context)..add(PullToRefreshEvent());
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
      }, child: BlocBuilder<NSurveyBloc, NSurveyState>(
          builder: (BuildContext context, state) {
        return RefreshIndicator(
          onRefresh: refreshList,
          child: Container(
              child: Stack(children: <Widget>[mainUi(), progressBar])),
        );
      })),
    );
  }

  surveySnackBar(bgColor, msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: ColorData.greenColor,
      content: Text(
        msg,
        style: Styles.failureUIStyle,
      ),
    ));
    // Scaffold.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: ColorData.greenColor,
    //     content: Text(
    //       msg,
    //       style: Styles.failureUIStyle,
    //     ),
    //   ),
    // );
  }

  Widget mainUi() {
    double screenheight = (MediaQuery.of(context).size.height);

    double appBarHeight = AppBar().preferredSize.height;

    double remainingHeight = screenheight -
        (appBarHeight +
            kBottomNavigationBarHeight +
            SPUtil.getDouble(Constants.STATUSBAR_HEIGHT, defValue: 0.0));

    double facilityView = (remainingHeight * (55.0 / 100.0));
    double questionView = (remainingHeight * (45.0 / 100.0));
    return GestureDetector(
      child: Scaffold(
        backgroundColor: ColorData.whiteColor,
//      key: _surveyScaffoldKey,
        body: ListView.builder(
          itemCount: 1,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: facilityView,
                    child: SurveyFacilitySelection(
                      facilityViewHeight: facilityView,
                      selectedFacilityId: widget.facilityId,
                    ),
                  ),
                  Container(
                    // height: questionView,
                    child: SurveyQuestions(
                      questionViewHeight: questionView,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
      onTap: () {
        hideKeyboard();
      },
    );
  }

  hideKeyboard() {
    //HideKeyboard
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  Widget reTryUI(String error) {
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
              error,
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
  }

  _retryPage() {
    BlocProvider.of<SurveyFacilityBloc>(context)..add(GetSurveyFacilityEvent());
  }
}
