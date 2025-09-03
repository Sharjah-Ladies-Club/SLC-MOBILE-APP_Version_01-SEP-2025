import 'package:equatable/equatable.dart';
import 'package:slc/model/event_registration_request.dart';

abstract class EventAddPeopleEvent extends Equatable {
  const EventAddPeopleEvent();
}

class SaveEventRegistrationEvent extends EventAddPeopleEvent {
  final EventRegistrationRequest request;

  const SaveEventRegistrationEvent({this.request});

  @override
  List<Object> get props => [request];
}

class GetInitiallData extends EventAddPeopleEvent {
  @override
  List<Object> get props => null;
}

class GetUserProfileEvent extends EventAddPeopleEvent {
  @override
  List<Object> get props => null;
}

class ErrorDialogEvent extends EventAddPeopleEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class GetPaymentTerms extends EventAddPeopleEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
