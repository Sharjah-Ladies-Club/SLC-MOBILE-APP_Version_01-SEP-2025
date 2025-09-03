import 'package:equatable/equatable.dart';

abstract class EventDetailsEvent extends Equatable {
  const EventDetailsEvent();
}

class ShowEventDetailPageProgressBarEvent extends EventDetailsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideEventDetailPageProgressBarEvent extends EventDetailsEvent {
  @override
  List<Object> get props => null;
}

class EventDetailOnFailureEvent extends EventDetailsEvent {
  final String error;

  const EventDetailOnFailureEvent({this.error});

  @override
  List<Object> get props => [error];
}

class ErrorDialogEvent extends EventDetailsEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class RetryEventDetailsPageEvent extends EventDetailsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
