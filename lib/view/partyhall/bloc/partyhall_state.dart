import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/partyhall_response.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/terms_condition.dart';

abstract class PartyHallState extends Equatable {
  const PartyHallState();
}

class InitialPartyHallState extends PartyHallState {
  @override
  List<Object> get props => [];
}

class PartyHallShowImageState extends PartyHallState {
  final File file;
  const PartyHallShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PartyHallNewShowImageState extends PartyHallState {
  final File file;
  const PartyHallNewShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PartyHallShowImageCameraState extends PartyHallState {
  final File file;
  const PartyHallShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PartyHallNewShowImageCameraState extends PartyHallState {
  final File file;
  const PartyHallNewShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class PartyHallTermsState extends PartyHallState {
  final List<TermsCondition> termsList;
  final PartyHallResponse partyHallDetail;
  final FacilityDetailResponse facilityDetail;
  final List<FacilityItem> menuItemList;
  final List<Venue> venueList;
  final List<EventType> eventTypeList;

  final RetailOrderItemsCategory orderItems;
  const PartyHallTermsState(
      {this.termsList,
      this.partyHallDetail,
      this.facilityDetail,
      this.menuItemList,
      this.venueList,
      this.eventTypeList,
      this.orderItems});

  @override
  // TODO: implement props
  List<Object> get props => [
        termsList,
        partyHallDetail,
        facilityDetail,
        menuItemList,
        venueList,
        eventTypeList,
        orderItems
      ];
}

class PartyHallSaveState extends PartyHallState {
  final String error;
  final String message;

  const PartyHallSaveState({this.error, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [error, message];
}

class PartyHallImageState extends PartyHallState {
  final List<PartyHallDocuments> documents;

  const PartyHallImageState({this.documents});

  @override
  // TODO: implement props
  List<Object> get props => [documents];
}

class PartyHallEditState extends PartyHallState {
  final String error;
  final String message;

  const PartyHallEditState({this.error, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [error, message];
}

class PartyHallCancelState extends PartyHallState {
  final String error;

  const PartyHallCancelState({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class PartyHallReloadState extends PartyHallState {
  final PartyHallResponse partyHallResponse;

  const PartyHallReloadState({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class GetPaymentTermsResult extends PartyHallState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
