import 'package:equatable/equatable.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();
}

class ShowEventProgressBarEvent extends EventsEvent {
  @override
  List<Object> get props => null;
}

class HideEventProgressBarEvent extends EventsEvent {
  @override
  List<Object> get props => null;
}

class EventOnFailureEvent extends EventsEvent {
  final String error;

  const EventOnFailureEvent({this.error});

  @override
  List<Object> get props => [error];
}

class RefreshEvent extends EventsEvent {
  @override
  List<Object> get props => null;
}

class SilentRefreshEvent extends EventsEvent {
  @override
  List<Object> get props => null;
}

class ErrorDialogEvent extends EventsEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  List<Object> get props => [title, content];
}
