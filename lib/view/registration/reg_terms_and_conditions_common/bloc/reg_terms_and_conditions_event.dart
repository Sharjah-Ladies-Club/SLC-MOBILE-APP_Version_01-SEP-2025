import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slc/model/reg_user_info.dart';

abstract class RegisterTermsAndConditionsEvent extends Equatable {
  const RegisterTermsAndConditionsEvent();
}

class FetchHearAboutUsListEvent extends RegisterTermsAndConditionsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FetchHearAboutUsListLanguageEvent
    extends RegisterTermsAndConditionsEvent {
  final BuildContext context;

  const FetchHearAboutUsListLanguageEvent({
    @required this.context,
  });

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowHearAboutUsProgressBar extends RegisterTermsAndConditionsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideHearAboutUsProgressBar extends RegisterTermsAndConditionsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HearAboutUsOnFailure extends RegisterTermsAndConditionsEvent {
  final String error;

  const HearAboutUsOnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class RegistrationSaveEvent extends RegisterTermsAndConditionsEvent {
  final UserInfo userInfo;

  const RegistrationSaveEvent({this.userInfo});

  @override
  // TODO: implement props
  List<Object> get props => [userInfo];
}

class RegistrationSaveSuccessEvent extends RegisterTermsAndConditionsEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
