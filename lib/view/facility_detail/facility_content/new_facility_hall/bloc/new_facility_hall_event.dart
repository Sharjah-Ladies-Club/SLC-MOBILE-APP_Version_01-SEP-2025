import 'dart:io';

import 'package:equatable/equatable.dart';

import '../../../../../model/knooz_response_dto.dart';
import '../../../../../model/partyhall_response.dart';

abstract class NewFacilityHallEvent extends Equatable {
  const NewFacilityHallEvent();
}

class NewFacilityHallTermsData extends NewFacilityHallEvent {
  final int facilityId;
  final int facilityItemId;
  final int partyHallDetailId;
  const NewFacilityHallTermsData(
      {this.facilityId, this.partyHallDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, partyHallDetailId, facilityItemId];
}

class GetFacilityPaymentTerms extends NewFacilityHallEvent {
  final int facilityId;

  const GetFacilityPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class NewFacilityHallShowImageEvent extends NewFacilityHallEvent {
  final File file;

  const NewFacilityHallShowImageEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class NewFacilityHallShowImageCameraEvent extends NewFacilityHallEvent {
  final File file;

  const NewFacilityHallShowImageCameraEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class NewFacilityHallSaveEvent extends NewFacilityHallEvent {
  final PartyHallResponse partyHallResponse;
  const NewFacilityHallSaveEvent({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class NewPartyHallSaveEvent extends NewFacilityHallEvent {
  final KunoozBookingDto kunoozResponse;
  const NewPartyHallSaveEvent({this.kunoozResponse});

  @override
  // TODO: implement props
  List<Object> get props => [kunoozResponse];
}

class NewPartyHallImageEvent extends NewFacilityHallEvent {
  final int id;
  const NewPartyHallImageEvent({this.id});

  @override
  // TODO: implement props
  List<Object> get props => [id];
}

class NewFacilityHallEditEvent extends NewFacilityHallEvent {
  final int partyHallDetailId;
  final int partyHallStatusId;
  final bool isActive;
  final int enquiryProcessId;
  const NewFacilityHallEditEvent(
      {this.partyHallDetailId,
      this.partyHallStatusId,
      this.isActive,
      this.enquiryProcessId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [partyHallDetailId, partyHallStatusId, isActive, enquiryProcessId];
}

class NewFacilityHallCancelEvent extends NewFacilityHallEvent {
  final PartyHallResponse partyHallResponse;
  const NewFacilityHallCancelEvent({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class NewFacilityHallReloadEvent extends NewFacilityHallEvent {
  final int facilityId;
  final int partyHallDetailId;
  final int facilityItemId;
  const NewFacilityHallReloadEvent(
      {this.facilityId, this.partyHallDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, partyHallDetailId, facilityItemId];
}

class NewFacilityHallKunoozEvent extends NewFacilityHallEvent {
  final int bookingId;
  const NewFacilityHallKunoozEvent({this.bookingId});

  @override
  // TODO: implement props
  List<Object> get props => [bookingId];
}

class NewFacilityHallDeliveryEvent extends NewFacilityHallEvent {
  final int itemGroup;
  const NewFacilityHallDeliveryEvent({this.itemGroup});

  @override
  // TODO: implement props
  List<Object> get props => [itemGroup];
}

class NewFacilityDocumentTypeEvent extends NewFacilityHallEvent {
  const NewFacilityDocumentTypeEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
