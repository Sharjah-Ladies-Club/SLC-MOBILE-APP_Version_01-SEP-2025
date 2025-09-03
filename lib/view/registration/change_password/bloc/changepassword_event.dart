import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();
}

//class OtpVerificationPressed extends ChangePasswordEvent {
//  @override
//  List<Object> get props => null;
//}

class ConfirmBtnPressed extends ChangePasswordEvent {
  final int userId;
  final String password;

  const ConfirmBtnPressed({
    @required this.userId,
    @required this.password,
  });

  @override
  List<Object> get props => [];

  @override
  String toString() => 'ConfirmBtnPressed { }';
}

// class HideTimerEvent extends ChangePasswordEvent {
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

class OnLanguagechangeInReg extends ChangePasswordEvent {
  final BuildContext context;

  const OnLanguagechangeInReg({
    @required this.context,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}
