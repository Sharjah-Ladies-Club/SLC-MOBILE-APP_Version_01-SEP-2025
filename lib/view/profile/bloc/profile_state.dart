import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/user_profile_info.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();
}

class InitialProfileState extends ProfileState {
  @override
  List<Object> get props => [];
}

class SuccessState extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FailureState extends ProfileState {
  final String error;

  const FailureState({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ShowProgressBar extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowNewProgressBar extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnProfileSuccess extends ProfileState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnProfileFailure extends ProfileState {
  final String error;

  const OnProfileFailure({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class OnGeneralListSuccess extends ProfileState {
  final List<GenderResponse> genderList;

  final List<NationalityResponse> nationalityList;

  final UserProfileInfo userProfileInfo;

  const OnGeneralListSuccess(
      {this.genderList, this.nationalityList, this.userProfileInfo});

  @override
  List<Object> get props => [genderList, nationalityList];
}

class OnUserProfileUpdate extends ProfileState {
  final String message;

  OnUserProfileUpdate({this.message});

  @override
  List<Object> get props => [message];
}

class OnSuccessOTPResend extends ProfileState {
  final String response;

  const OnSuccessOTPResend({@required this.response});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class OnFailureOTPResend extends ProfileState {
  final String error;

  const OnFailureOTPResend({@required this.error});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ErrorDialogState extends ProfileState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
