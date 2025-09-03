import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();
}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;
  final int countryId;
  final int applicationId;

  const LoginButtonPressed({
    @required this.username,
    @required this.password,
    @required this.countryId,
    @required this.applicationId,
  });

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnLanguagechange extends LoginEvent {
  final BuildContext context;

  const OnLanguagechange({
    @required this.context,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PageOneContinueButtonPressed extends LoginEvent {
  final String mobileNumber;
  final String email;
  final int countryId;
  final String countrycode;
  final String pagePath;

  const PageOneContinueButtonPressed(
      {@required this.mobileNumber,
      @required this.email,
      @required this.countryId,
      @required this.pagePath,
      @required this.countrycode});

  @override
  List<Object> get props => [];

  @override
  String toString() => 'PageOneContinueButtonPressed';
}
