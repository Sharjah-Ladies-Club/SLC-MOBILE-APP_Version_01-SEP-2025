import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slc/model/user_profile_info.dart';

abstract class ProfileEvents extends Equatable {
  const ProfileEvents();
}

class GeneralList extends ProfileEvents {
  @override
  List<Object> get props => null;
}

class ProfileSaveBtnPressed extends ProfileEvents {
  final UserProfileInfo profileDetails;

  const ProfileSaveBtnPressed({
    @required this.profileDetails,
  });

  @override
  List<Object> get props => [profileDetails];
}

class ResendOtpPressed extends ProfileEvents {
  final int userId;
  final int otpTypeId;

  const ResendOtpPressed({@required this.userId, @required this.otpTypeId});

  @override
  List<Object> get props => [];
}
class ErrorDialogEvent extends ProfileEvents {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

