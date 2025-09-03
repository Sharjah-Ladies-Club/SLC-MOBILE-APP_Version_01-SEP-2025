import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/model/partyhall_response.dart';

abstract class PartyHallEvent extends Equatable {
  const PartyHallEvent();
}

class PartyHallShowImageEvent extends PartyHallEvent {
  final File file;

  const PartyHallShowImageEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class PartyHallShowImageCameraEvent extends PartyHallEvent {
  final File file;

  const PartyHallShowImageCameraEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class PartyHallTermsData extends PartyHallEvent {
  final int facilityId;
  final int facilityItemId;
  final int partyHallDetailId;
  const PartyHallTermsData(
      {this.facilityId, this.partyHallDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, partyHallDetailId, facilityItemId];
}

class PartyHallSaveEvent extends PartyHallEvent {
  final PartyHallResponse partyHallResponse;
  const PartyHallSaveEvent({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class NewPartyHallSaveEvent extends PartyHallEvent {
  final KunoozBookingDto kunoozResponse;
  const NewPartyHallSaveEvent({this.kunoozResponse});

  @override
  // TODO: implement props
  List<Object> get props => [kunoozResponse];
}

class NewPartyHallImageEvent extends PartyHallEvent {
  final int id;
  const NewPartyHallImageEvent({this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class PartyHallEditEvent extends PartyHallEvent {
  final int partyHallDetailId;
  final int partyHallStatusId;
  final bool isActive;
  final int enquiryProcessId;
  const PartyHallEditEvent(
      {this.partyHallDetailId,
      this.partyHallStatusId,
      this.isActive,
      this.enquiryProcessId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [partyHallDetailId, partyHallStatusId, isActive, enquiryProcessId];
}

class PartyHallCancelEvent extends PartyHallEvent {
  final PartyHallResponse partyHallResponse;
  const PartyHallCancelEvent({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class PartyHallReloadEvent extends PartyHallEvent {
  final int facilityId;
  final int partyHallDetailId;
  final int facilityItemId;
  const PartyHallReloadEvent(
      {this.facilityId, this.partyHallDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, partyHallDetailId, facilityItemId];
}

class GetPaymentTerms extends PartyHallEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
