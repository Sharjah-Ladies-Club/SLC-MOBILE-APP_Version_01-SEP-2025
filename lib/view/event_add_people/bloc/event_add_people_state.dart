import 'package:equatable/equatable.dart';
import 'package:slc/common/custom_nationality_picker/custom_nationality_code.dart';
import 'package:slc/model/GenderResponse.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/model/payment_terms_response.dart';

abstract class EventAddPeopleState extends Equatable {
  const EventAddPeopleState();
}

class InitialEventAddPeopleState extends EventAddPeopleState {
  @override
  List<Object> get props => [];
}

class LoadInitialData extends EventAddPeopleState {
  final List<GenderResponse> genderList;
  final List<NationalityResponse> nationalityList;

  const LoadInitialData({this.nationalityList, this.genderList});

  @override
  // TODO: implement props
  List<Object> get props => [genderList, nationalityList];
}

class GetProfileState extends EventAddPeopleState {
  final UserProfileInfo userProfileInfo;

  const GetProfileState({this.userProfileInfo});

  @override
  List<Object> get props => [userProfileInfo];
}

class OnSuccessEventRegistration extends EventAddPeopleState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnInitialDataFailureEventRegistration extends EventAddPeopleState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnFailureEventRegistration extends EventAddPeopleState {
  final String error;

  const OnFailureEventRegistration({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ShowEventRegistrationProgressBar extends EventAddPeopleState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideEventRegistrationProgressBar extends EventAddPeopleState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogState extends EventAddPeopleState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class GetPaymentTermsResult extends EventAddPeopleState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
