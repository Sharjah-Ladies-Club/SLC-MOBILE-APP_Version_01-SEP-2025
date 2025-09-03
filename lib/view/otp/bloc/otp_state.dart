import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class OtpState extends Equatable {
  const OtpState();
}

class InitialOtpState extends OtpState {
  @override
  List<Object> get props => [];
}

class LanguageSwitchedSuccess extends OtpState {
  @override
  List<Object> get props => null;
}

class LanguageSwitchedFailure extends OtpState {
  final String error;

  const LanguageSwitchedFailure({@required this.error});

  @override
  List<Object> get props => [error];
}

class ShowProgressBar extends OtpState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends OtpState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnSuccess extends OtpState {
  final String response;
  final String responseType;

  const OnSuccess({@required this.response, @required this.responseType});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFailure extends OtpState {
  final String error;
  final String responseType;

  const OnFailure({@required this.error, @required this.responseType});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
class ErrorDialogState extends OtpState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
