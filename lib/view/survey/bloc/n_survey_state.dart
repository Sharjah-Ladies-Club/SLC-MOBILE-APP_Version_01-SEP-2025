import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class NSurveyState extends Equatable {
  const NSurveyState();
}

class InitialSurveyState extends NSurveyState {
  @override
  List<Object> get props => [];
}

class ShowProgressState extends NSurveyState {
  @override
  List<Object> get props => [];
}

class HideProgressState extends NSurveyState {
  @override
  List<Object> get props => [];
}

class SuccessState extends NSurveyState {
  @override
  List<Object> get props => [];
}

class FailureState extends NSurveyState {
  final String error;

  const FailureState({@required this.error});

  @override
  List<Object> get props => [error];
}

class RetryState extends NSurveyState {
  final String error;

  const RetryState({@required this.error});

  @override
  List<Object> get props => [error];
}

class PullToRefreshState extends NSurveyState {
  @override
  List<Object> get props => [];
}

class ErrorDialogState extends NSurveyState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

