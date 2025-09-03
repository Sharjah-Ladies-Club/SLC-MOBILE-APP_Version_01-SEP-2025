import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/event_review_list_detail.dart';
import 'package:slc/model/review_details.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/theme/styles.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';

import 'bloc/bloc.dart';
import 'event_review_detail_carousal/bloc/event_review_detail_carousal_bloc.dart';
import 'event_review_detail_carousal/bloc/event_review_detail_carousal_event.dart';
import 'event_review_detail_carousal/event_review_carousal.dart';
import 'event_review_detail_content/bloc/event_review_detail_content_bloc.dart';
import 'event_review_detail_content/event_review_content_list.dart';

// ignore: must_be_immutable
class EventReviewDetails extends StatelessWidget {
  ReviewListDetails reviewListDetails;

  EventReviewDetails({this.reviewListDetails});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ReviewDetailBloc>(
          create: (context) {
            return ReviewDetailBloc()..add(ShowProgressBarEvent());
          },
        ),
        BlocProvider<EventReviewDetailsCarousalBloc>(
          create: (context) {
            return EventReviewDetailsCarousalBloc(
                reviewDetailBloc: BlocProvider.of<ReviewDetailBloc>(context))
              ..add(GeneralList(
                  eventId: reviewListDetails.eventBasicDetail.eventId));
          },
        ),
        BlocProvider<EventReviewDetailContentBloc>(
          create: (context) {
            return EventReviewDetailContentBloc(
                reviewDetailBloc: BlocProvider.of<ReviewDetailBloc>(context));
          },
        ),
      ],
      child: _EventReviewDetails(
        reviewListDetails: reviewListDetails,
      ),
    );
  }
}

// ignore: must_be_immutable
class _EventReviewDetails extends StatefulWidget {
  ReviewListDetails reviewListDetails;

  _EventReviewDetails({this.reviewListDetails});

  @override
  State<StatefulWidget> createState() {
    return _EventReviewDetailsState(reviewListDetails: reviewListDetails);
  }
}

double screenheight = 0.0;
double carouselHeight = 0.0;
double menuHeight = 0.0;
double contentHeight = 0.0;
ProgressBarHandler _handler;

class _EventReviewDetailsState extends State<_EventReviewDetails> {
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

  ReviewDetails reviewDetails = new ReviewDetails();
  ReviewListDetails reviewListDetails;

  _EventReviewDetailsState({this.reviewListDetails});

  @override
  Widget build(BuildContext context) {
    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<ReviewDetailBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<ReviewDetailBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    screenheight = (MediaQuery.of(context).size.height);
    carouselHeight = screenheight * (45.0 / 100.0);
    contentHeight = screenheight * (55.0 / 100.0);

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    return BlocListener<ReviewDetailBloc, ReviewDetailsState>(
      listener: (BuildContext context, state) {
        if (state is ShowProgressBar) {
          _handler.show();
        } else if (state is HideProgressBar) {
          _handler.dismiss();
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
      child: BlocBuilder<ReviewDetailBloc, ReviewDetailsState>(
          builder: (BuildContext context, state) {
        if (state is FailureState) {
          //Utils().customSnackBar(state.error, context);
          return failureUI(state.error, context, reviewListDetails);
        } else if (state is OnReviewDetailsSuccess) {
          reviewDetails = state.reviewDetails;
        }

        return Stack(
          children: <Widget>[mainUI(context), progressBar],
        );
      }),
    );
  }

  Widget mainUI(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return;
      },
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: carouselHeight,
              child: EventReviewDetailsCarousal(height: carouselHeight),
            ),
            Container(
              height: contentHeight,
              child: EventReviewList(),
            )
          ],
        ),
      ),
    );
  }

  Widget failureUI(
      String error, BuildContext context, ReviewListDetails reviewListDetails) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Image(
              image: AssetImage(ImageData.error_img),
            ),
            const SizedBox(height: 30),
            Text(error, style: Styles.failureUIStyle),
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
                BlocProvider.of<EventReviewDetailsCarousalBloc>(context).add(
                    GeneralList(
                        eventId: reviewListDetails.eventBasicDetail.eventId));
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
