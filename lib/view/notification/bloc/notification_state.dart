import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/notification_list_response.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
}

class InitialNotificationState extends NotificationState {
  @override
  List<Object> get props => [];
}

class LoadingProgressState extends NotificationState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadedProgressState extends NotificationState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ShowProgressBar extends NotificationState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends NotificationState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnNotificationGetListSuccess extends NotificationState {
  // final List<NotificationListResponse> notificationResponseList;
  final Meta meta;

  const OnNotificationGetListSuccess({@required this.meta});

  @override
  // TODO: implement props
  List<Object> get props => [meta];
}

class OnNotificationGetListFailure extends NotificationState {
  final String error;

  const OnNotificationGetListFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnNotificationGetReadStatusSuccess extends NotificationState {
  final String title;
  final String message;
  final String imgUrl;
  final int notificationUserId;
  final String webNavigationUrl;
  final String shortMessage;
  final NotificationListResponse notificationListResponse;

  const OnNotificationGetReadStatusSuccess({
    @required this.title,
    @required this.message,
    @required this.imgUrl,
    @required this.notificationUserId,
    this.webNavigationUrl,
    this.shortMessage,
    @required this.notificationListResponse,
  });

  @override
  // TODO: implement props
  List<Object> get props => [
        title,
        message,
        imgUrl,
        notificationUserId,
        webNavigationUrl,
        shortMessage,
        notificationListResponse
      ];
}

// class OnNotificationGetReadStatusSuccess extends NotificationState {
//   // final String title;
//   // final String message;

//     final NotificationListResponse notificationResponseList;

//       const OnNotificationGetReadStatusSuccess(
//       {@required this.notificationResponseList});

//   // const OnNotificationGetReadStatusSuccess(
//   //     {@required this.title, @required this.message});

//   @override
//   // TODO: implement props
//   List<Object> get props => [notificationResponseList];
// }

class OnNotificationGetReadStatusFailure extends NotificationState {
  final String error;

  const OnNotificationGetReadStatusFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnNotificationCardDetailsGetSuccess extends NotificationState {
  final String title;
  final String message;

  const OnNotificationCardDetailsGetSuccess(
      {@required this.title, @required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [title, message];
}

class OnNotificationCardDetailsGetFailure extends NotificationState {
  final String error;

  const OnNotificationCardDetailsGetFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnNotificationClearSuccess extends NotificationState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnNotificationClearFailure extends NotificationState {
  final String error;

  const OnNotificationClearFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ErrorDialogState extends NotificationState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
