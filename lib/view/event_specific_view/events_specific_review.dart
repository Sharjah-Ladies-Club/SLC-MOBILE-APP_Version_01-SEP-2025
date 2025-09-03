import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/event_review_question_details.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_specific_view/bloc/bloc.dart';
import 'package:slc/view/event_specific_view/event_specific_view_carousal/event_review_carousal.dart';
import 'package:slc/view/event_specific_view/event_specific_view_content/event_specific_review_content.dart';
import 'package:slc/view/registration/reg_terms_and_conditions_common/custom_success_dialog.dart';

import 'event_specific_view_carousal/bloc/event_review_write_carousal_bloc.dart';
import 'event_specific_view_carousal/bloc/event_review_write_carousal_event.dart';
import 'event_specific_view_content/bloc/event_review_write_content_bloc.dart';

// ignore: must_be_immutable
class EventSpecificReview extends StatelessWidget {
  int eventId;

  EventSpecificReview(this.eventId);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventReviewWriteBloc>(
          create: (context) {
            return EventReviewWriteBloc(null);
          },
        ),
        BlocProvider<EventReviewWriteCarousalBloc>(
          create: (context) {
            return EventReviewWriteCarousalBloc(
                eventReviewWriteBloc:
                    BlocProvider.of<EventReviewWriteBloc>(context))
              ..add(GetEventWriteReviewQuestions(eventId: this.eventId));
          },
        ),
        BlocProvider<EventReviewWriteContentBloc>(
          create: (context) {
            return EventReviewWriteContentBloc(
                eventReviewWriteBloc:
                    BlocProvider.of<EventReviewWriteBloc>(context));
          },
        ),
      ],
      child: _EventSpecificReview(this.eventId),
    );
  }
}

// ignore: must_be_immutable
class _EventSpecificReview extends StatefulWidget {
  int eventId;

  _EventSpecificReview(this.eventId);

  @override
  State<StatefulWidget> createState() {
    return _EventSpecificReviewState();
  }
}

double screenHeight = 0.0;
double carouselHeight = 0.0;
double menuHeight = 0.0;
double contentHeight = 0.0;
DialogHandler _handlerDialog;
ProgressBarHandler _handler;

class _EventSpecificReviewState extends State<_EventSpecificReview> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  EventReviewQuestion eventReviewQuestion;

  @override
  void initState() {
    super.initState();
    Constants.isViewMore = false;
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {
    var progressBar = ModalRoundedProgressBar(
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<EventReviewWriteBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<EventReviewWriteBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    } else if (_source != null &&
        _source[Constants.NOTIFICATION_KEY] == Constants.KEYBOARD_HIDE_REVIEW) {
      hideKeyboard();
      _source = {Constants.NOTIFICATION_KEY: 'empty'};
    }

    var dialogHolder = ModalRoundedDialog(
      //getting the handler
      handleCallback: (handler) {
        _handlerDialog = handler;
        return;
      },
      title: tr("txt_success"),
      content: tr("txt_event_review_success_msg"),
      positiveCallBack: () {
        Navigator.pop(context, eventReviewQuestion.eventBasic.eventId);
      },
    );

    screenHeight = (MediaQuery.of(context).size.height);
    carouselHeight = screenHeight * (45.0 / 100.0);
    contentHeight = screenHeight * (55.0 / 100.0);

    return BlocListener<EventReviewWriteBloc, EventReviewWriteState>(
      listener: (BuildContext context, state) {
        if (state is ShowReviewWriteProgressBarState) {
          _handler.show();
        } else if (state is HideReviewWriteProgressBarState) {
          _handler.dismiss();
        } else if (state is OnWriteReviewSuccessState) {
          SPUtil.remove("FeedBackSelectedList");
          _handlerDialog.show();
        } else if (state is OnFailureReviewWriteState) {
          Utils().customGetSnackBarWithOutActionButton(
              tr('error_caps'), (state.error), context);
        } else if (state is OnEventListLoadState) {
          eventReviewQuestion = state.eventReviewQuestion;
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
      child: BlocBuilder<EventReviewWriteBloc, EventReviewWriteState>(
        builder: (BuildContext context, state) {
          if (state is OnFailureReviewWriteState) {
            failureUI(
                state.error, context, eventReviewQuestion.eventBasic.eventId);
            //Utils().customSnackBar(state.error, context);
          }
          return Stack(
            children: <Widget>[mainUI(context), progressBar, dialogHolder],
          );
        },
      ),
    );
  }

  Widget mainUI(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Container(
          child: ListView.builder(
            itemCount: 1,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                color: ColorData.whiteColor,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: carouselHeight,
                      child: EventItemCarousal(
                        height: carouselHeight,
                      ),
                    ),
                    Container(
                      child: EventSpecificReviewContent(
                        widget.eventId,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
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

  Widget failureUI(String error, BuildContext context, int eventId) {
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
              style: TextStyle(color: ColorData.primaryTextColor),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
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
              // color: ColorData.accentColor,
              onPressed: () {
                EventReviewWriteCarousalBloc(
                    eventReviewWriteBloc:
                        BlocProvider.of<EventReviewWriteBloc>(context))
                  ..add(GetEventWriteReviewQuestions(eventId: eventId));
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
}
