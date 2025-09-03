import 'package:equatable/equatable.dart';
import 'package:slc/model/event_review_question_details.dart';

abstract class EventReviewWriteState extends Equatable {
  const EventReviewWriteState();
}

class InitialEventReviewWriteState extends EventReviewWriteState {
  @override
  List<Object> get props => [];
}

class ShowReviewWriteProgressBarState extends EventReviewWriteState {
  @override
  List<Object> get props => null;
}

class HideReviewWriteProgressBarState extends EventReviewWriteState {
  @override
  List<Object> get props => null;
}

class OnFailureReviewWriteState extends EventReviewWriteState {
  final String error;

  const OnFailureReviewWriteState({this.error});

  @override
  List<Object> get props => [error];
}

class OnEventListLoadState extends EventReviewWriteState {
  final EventReviewQuestion eventReviewQuestion;

  const OnEventListLoadState({this.eventReviewQuestion});

  @override
  List<Object> get props => [eventReviewQuestion];
}

class OnWriteReviewSuccessState extends EventReviewWriteState {
  @override
  List<Object> get props => null;
}


class ErrorDialogState extends EventReviewWriteState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

