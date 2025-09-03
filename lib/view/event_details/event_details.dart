import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:slc/common/ModalRoundedProgressBar.dart';
import 'package:slc/common/colors.dart';
import 'package:slc/common/progress_dialog.dart';
import 'package:slc/customcomponentfields/alert_dialog/custom_alert_dialog.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/theme/images.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/utils/silent_notification_handler.dart';
import 'package:slc/utils/utils.dart';
import 'package:slc/view/event_details/bloc/bloc.dart';
import 'package:slc/view/event_details/event_carousel/bloc/bloc.dart';

import 'event_carousel/event_carousel.dart';
import 'event_detail_content/bloc/event_detail_content_bloc.dart';
import 'event_detail_content/event_detail_content.dart';

// ignore: must_be_immutable
class EventDetails extends StatelessWidget {
  int eventId;
  int statusId;

  EventDetails({this.eventId, this.statusId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EventDetailsBloc>(create: (context) => EventDetailsBloc()),
        BlocProvider<EventDetailContentBloc>(
            create: (context) => EventDetailContentBloc(null)),
        BlocProvider<EventCarouselBloc>(
            create: (context) => EventCarouselBloc(
                eventDetailsBloc: BlocProvider.of<EventDetailsBloc>(context))
              ..add(GetEventDetailsEvent(eventId: eventId))),
      ],
      child: _EventDetails(
        eventId: eventId,
        statusId: statusId,
      ),
    );
  }
}

// ignore: must_be_immutable
class _EventDetails extends StatefulWidget {
  int eventId;
  int statusId;

  _EventDetails({this.eventId, this.statusId});

  @override
  State<StatefulWidget> createState() {
    return _EventDetailsPage(statusId: statusId);
  }
}

ProgressDialog progressDialog;
ProgressBarHandler _handler;
double screenHeight = 0.0;
double carouselHeight = 0.0;
double contentHeight = 0.0;
double screenWidth = 0.0;

class _EventDetailsPage extends State<_EventDetails> {
  SilentNotificationHandler _silentNotificationHandler =
      SilentNotificationHandler.instance;
  Map _source = {Constants.NOTIFICATION_KEY: 'empty'};

  int statusId;
  _EventDetailsPage({this.statusId});
  @override
  void initState() {
    super.initState();
    Constants.isViewMore = false;
    _silentNotificationHandler.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = (MediaQuery.of(context).size.height);
    screenWidth = MediaQuery.of(context).size.width;
    carouselHeight = screenHeight * (35.0 / 100.0);
    contentHeight = screenHeight * (65.0 / 100.0);

    var progressBar = ModalRoundedProgressBar(
      //getting the handler
      handleCallback: (handler) {
        _handler = handler;
        return;
      },
    );

    if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_TOKEN_EXPIRED) {
      BlocProvider.of<EventDetailsBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("session_expired")));
    } else if (_source[Constants.NOTIFICATION_KEY] ==
        Constants.NOTIFICATION_INVALID_USER) {
      BlocProvider.of<EventDetailsBloc>(context)
        ..add(ErrorDialogEvent(
            title: tr("warning_caps"), content: tr("user_inactive")));
    }

    return Scaffold(
      body: BlocListener<EventDetailsBloc, EventDetailsState>(
        listener: (context, state) {
          if (state is ShowEventDetailProgressBarState) {
            _handler.show();
          } else if (state is HideEventDetailProgressBarState) {
            _handler.dismiss();
          } else if (state is EventDetailOnFailureState) {
            _handler.dismiss();
            Utils().customGetSnackBarWithOutActionButton(
                tr('error_caps'), (state.error), context);
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
          } else if (state is ReTryingEventDetailsPageState) {
            BlocProvider.of<EventCarouselBloc>(context)
                .add(GetEventDetailsEvent(eventId: widget.eventId));
          }
        },
        child: BlocBuilder<EventDetailsBloc, EventDetailsState>(
          builder: (context, state) {
            if (state is EventDetailOnFailureState) {
              return retryUi(state.error);
            }
            return Container(
                child: Stack(children: <Widget>[mainUI(), progressBar]));
          },
        ),
      ),
    );
  }

  Widget mainUI() {
    return Column(
      children: <Widget>[
        Container(
          height: carouselHeight,
          child: EventCarousel(height: carouselHeight),
        ),
        Container(
          height: contentHeight,
          child: EventDetailContent(
            statusId: widget.statusId,
          ),
        )
      ],
    );
  }

  Widget retryUi(String error) {
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
              style: TextStyle(
                color: ColorData.primaryTextColor,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    ColorData.accentColor,
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
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
  }

  _retryPage() {
    BlocProvider.of<EventDetailsBloc>(context)
      ..add(RetryEventDetailsPageEvent());
  }
}
