import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();
}

class InitialChangePasswordState extends ChangePasswordState {
  @override
  List<Object> get props => [];
}

class LanguageSwitchedSuccess extends ChangePasswordState {
  @override
  List<Object> get props => null;
}

class LanguageSwitchedFailure extends ChangePasswordState {
  final String error;

  const LanguageSwitchedFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ShowProgressBar extends ChangePasswordState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends ChangePasswordState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccess extends ChangePasswordState {
  final String response;
  final String responseType;

  const OnSuccess({@required this.response, @required this.responseType});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFailure extends ChangePasswordState {
  final String error;
  final String responseType;

  const OnFailure({@required this.error, @required this.responseType});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
