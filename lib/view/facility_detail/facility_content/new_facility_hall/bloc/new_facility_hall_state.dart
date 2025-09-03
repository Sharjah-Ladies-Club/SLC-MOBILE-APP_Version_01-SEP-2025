import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/partyhall_response.dart';
import 'package:slc/model/terms_condition.dart';

import '../../../../../model/knooz_response_dto.dart';
import '../../../../../model/payment_terms_response.dart';

abstract class NewFacilityHallState extends Equatable {
  const NewFacilityHallState();
}

class InitialNewFacilityHallState extends NewFacilityHallState {
  @override
  List<Object> get props => [];
}

class NewFacilityHallTermsState extends NewFacilityHallState {
  final List<TermsCondition> termsList;
  final PartyHallResponse partyHallDetail;
  final FacilityDetailResponse facilityDetail;
  final List<FacilityItem> menuItemList;
  final List<Venue> venueList;
  final List<EventType> eventTypeList;

  final RetailOrderItemsCategory orderItems;
  const NewFacilityHallTermsState(
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

class GetFacilityPaymentTermsResult extends NewFacilityHallState {
  final PaymentTerms paymentTerms;
  const GetFacilityPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}

class NewFacilityHallShowImageState extends NewFacilityHallState {
  final File file;
  const NewFacilityHallShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NewFacilityHallNewShowImageState extends NewFacilityHallState {
  final File file;
  const NewFacilityHallNewShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NewFacilityHallShowImageCameraState extends NewFacilityHallState {
  final File file;
  const NewFacilityHallShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NewFacilityHallNewShowImageCameraState extends NewFacilityHallState {
  final File file;
  const NewFacilityHallNewShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class NewFacilityHallSaveState extends NewFacilityHallState {
  final String error;
  final String timeStamp;
  final String message;

  const NewFacilityHallSaveState({this.error, this.message, this.timeStamp});

  @override
  // TODO: implement props
  List<Object> get props => [error, message, timeStamp];
}

class NewFacilityHallImageState extends NewFacilityHallState {
  final List<PartyHallDocumentsDto> documents;

  const NewFacilityHallImageState({this.documents});

  @override
  // TODO: implement props
  List<Object> get props => [documents];
}

class NewFacilityHallEditState extends NewFacilityHallState {
  final String error;
  final String message;

  const NewFacilityHallEditState({this.error, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [error, message];
}

class NewFacilityHallCancelState extends NewFacilityHallState {
  final String error;

  const NewFacilityHallCancelState({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class NewFacilityHallReloadState extends NewFacilityHallState {
  final PartyHallResponse partyHallResponse;

  const NewFacilityHallReloadState({this.partyHallResponse});

  @override
  // TODO: implement props
  List<Object> get props => [partyHallResponse];
}

class NewFacilityHallKunoozState extends NewFacilityHallState {
  final KunoozBookingDto bookingResponse;

  const NewFacilityHallKunoozState({this.bookingResponse});

  @override
  // TODO: implement props
  List<Object> get props => [bookingResponse];
}

class NewFacilityHallDeliveryState extends NewFacilityHallState {
  final List<DeliveryCharges> deliveryCharges;

  const NewFacilityHallDeliveryState({this.deliveryCharges});

  @override
  // TODO: implement props
  List<Object> get props => [deliveryCharges];
}

class NewFacilityHallDocumentTypeState extends NewFacilityHallState {
  final List<DocumentType> documentTypes;

  const NewFacilityHallDocumentTypeState({this.documentTypes});

  @override
  // TODO: implement props
  List<Object> get props => [documentTypes];
}

class OnFailure extends NewFacilityHallState {
  final String error;

  const OnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
