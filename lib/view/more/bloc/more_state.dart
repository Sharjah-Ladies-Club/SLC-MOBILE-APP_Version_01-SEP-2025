import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class MoreState extends Equatable {
  const MoreState();
}

class InitialMoreState extends MoreState {
  @override
  List<Object> get props => [];
}

class ShowMoreProgressBarState extends MoreState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideMoreProgressBarState extends MoreState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LogoutSuccess extends MoreState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeactivateSuccess extends MoreState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeactivateFailure extends MoreState {
  final String error;

  const DeactivateFailure({@required this.error});
  @override
  List<Object> get props => [error];
}

class LogoutFailure extends MoreState {
  final String error;

  const LogoutFailure({@required this.error});
  @override
  List<Object> get props => [error];
}

class ErrorDialogState extends MoreState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
