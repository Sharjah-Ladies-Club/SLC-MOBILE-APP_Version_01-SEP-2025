import 'package:equatable/equatable.dart';
import 'package:slc/model/hear_about_us_detail.dart';

abstract class RegisterTermsAndConditionsState extends Equatable {
  const RegisterTermsAndConditionsState();
}

class InitialRegisterTermsAndConditionsState
    extends RegisterTermsAndConditionsState {
  @override
  List<Object> get props => [];
}

class ShowRegisterTermsAndConditionsProgressBarState
    extends RegisterTermsAndConditionsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideRegisterTermsAndConditionsProgressBarState
    extends RegisterTermsAndConditionsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HearAboutUsListSuccessListener extends RegisterTermsAndConditionsState {
  final List<HearAboutUsDetail> hearAboutUsList;

  const HearAboutUsListSuccessListener(this.hearAboutUsList);

  @override
  // TODO: implement props
  List<Object> get props => [this.hearAboutUsList];
}

class RegisterTermsAndConditionsOnSuccess
    extends RegisterTermsAndConditionsState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class RegisterTermsAndConditionsOnFailure
    extends RegisterTermsAndConditionsState {
  final String error;

  const RegisterTermsAndConditionsOnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
