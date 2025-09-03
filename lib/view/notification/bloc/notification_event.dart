import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();
}

class NotificationGetList extends NotificationEvent {
  final int userId;

  const NotificationGetList({
    @required this.userId,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'userId {}';

// fName : "${profileDetails[0]}",lName :  "${profileDetails[1]}",email : "${profileDetails[2]}",dob : "${profileDetails[3]}",gender :"${profileDetails[4]}"
}

class NotificationGetReadStatus extends NotificationEvent {
  final int notificationCardId;

  const NotificationGetReadStatus({
    @required this.notificationCardId,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'notificationGetReadStatus {}';

// fName : "${profileDetails[0]}",lName :  "${profileDetails[1]}",email : "${profileDetails[2]}",dob : "${profileDetails[3]}",gender :"${profileDetails[4]}"
}

class ClearAllClicked extends NotificationEvent {
  final int userId;

  const ClearAllClicked({
    @required this.userId,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'userId {}';

// fName : "${profileDetails[0]}",lName :  "${profileDetails[1]}",email : "${profileDetails[2]}",dob : "${profileDetails[3]}",gender :"${profileDetails[4]}"
}

class NotificationCardClicked extends NotificationEvent {
  final int notificationCardId;

  const NotificationCardClicked({
    @required this.notificationCardId,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'notificationCardId {}';

// fName : "${profileDetails[0]}",lName :  "${profileDetails[1]}",email : "${profileDetails[2]}",dob : "${profileDetails[3]}",gender :"${profileDetails[4]}"
}

class ErrorDialogEvent extends NotificationEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

