import 'package:equatable/equatable.dart';

abstract class EventDetailsState extends Equatable {
  const EventDetailsState();
}

class InitialEventDetailsState extends EventDetailsState {
  @override
  List<Object> get props => [];
}

class ShowEventDetailProgressBarState extends EventDetailsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideEventDetailProgressBarState extends EventDetailsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class EventDetailOnFailureState extends EventDetailsState {
  final String error;

  const EventDetailOnFailureState({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ErrorDialogState extends EventDetailsState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class ReTryingEventDetailsPageState extends EventDetailsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
