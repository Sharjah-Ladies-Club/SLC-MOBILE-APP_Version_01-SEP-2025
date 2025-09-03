import 'package:equatable/equatable.dart';
import 'package:slc/model/event_review_question_details.dart';

abstract class EventWriteReviewEvent extends Equatable {
  const EventWriteReviewEvent();
}

class ShowEventWriteReviewProgressBarEvent extends EventWriteReviewEvent {
  @override
  List<Object> get props => null;
}

class HideEventWriteReviewProgressBarEvent extends EventWriteReviewEvent {
  @override
  List<Object> get props => null;
}

class OnEventListLoadEvent extends EventWriteReviewEvent {
  final EventReviewQuestion eventReviewQuestion;

  const OnEventListLoadEvent({this.eventReviewQuestion});

  @override
  List<Object> get props => [eventReviewQuestion];
}

class OnFailureEvent extends EventWriteReviewEvent {
  final String error;

  const OnFailureEvent({this.error});

  @override
  List<Object> get props => [error];
}

class OnWriteReviewSuccessEvent extends EventWriteReviewEvent {
  @override
  List<Object> get props => null;
}

class ErrorDialogEvent extends EventWriteReviewEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

