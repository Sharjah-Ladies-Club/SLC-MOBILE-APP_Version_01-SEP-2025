import 'package:equatable/equatable.dart';

abstract class NSurveyEvent extends Equatable {
  const NSurveyEvent();
}

class RetryTapped extends NSurveyEvent {
  @override
  List<Object> get props => null;
}

class PullToRefreshEvent extends NSurveyEvent {
  @override
  List<Object> get props => null;
}

class SurveyShowProgressBarEvent extends NSurveyEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SurveyHideProgressBarEvent extends NSurveyEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SurveyFailureEvent extends NSurveyEvent {
  final String error;

  const SurveyFailureEvent({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class SurveySuccessEvent extends NSurveyEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogEvent extends NSurveyEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
