import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class OtpEvent extends Equatable {
  const OtpEvent();
}

//class OtpVerificationPressed extends OtpEvent {
//  @override
//  List<Object> get props => null;
//}

class OtpVerificationPressed extends OtpEvent {
  final int userId;
  final String otp;
  final bool isCorporate;

  const OtpVerificationPressed(
      {@required this.userId, @required this.otp, this.isCorporate = false});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'LoginButtonPressed { }';
}

class ResendOtpPressed extends OtpEvent {
  final int userId;
  final int otpTypeId;

  const ResendOtpPressed({@required this.userId, @required this.otpTypeId});

  @override
  List<Object> get props => [];
}

// class HideTimerEvent extends OtpEvent {
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

class OnLanguagechangeInReg extends OtpEvent {
  final BuildContext context;

  const OnLanguagechangeInReg({
    @required this.context,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogEvent extends OtpEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
