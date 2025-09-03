import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/enquiry_answers.dart';

abstract class EnquiryEvent extends Equatable {
  const EnquiryEvent();
}

class EnquiryShowImageEvent extends EnquiryEvent {
  final File file;

  const EnquiryShowImageEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class EnquiryShowImageCameraEvent extends EnquiryEvent {
  final File file;

  const EnquiryShowImageCameraEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class EnquiryTermsData extends EnquiryEvent {
  final int facilityId;
  final int facilityItemId;
  final int enquiryDetailId;
  const EnquiryTermsData(
      {this.facilityId, this.enquiryDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, enquiryDetailId, facilityItemId];
}

class EnquirySaveEvent extends EnquiryEvent {
  final EnquiryDetailResponse enquiryDetailResponse;
  const EnquirySaveEvent({this.enquiryDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}

class EnquiryEditEvent extends EnquiryEvent {
  final int enquiryDetailId;
  final int enquiryStatusId;
  final int enquiryProcessId;
  final bool isActive;
  const EnquiryEditEvent(
      {this.enquiryDetailId,
      this.enquiryStatusId,
      this.isActive,
      this.enquiryProcessId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [enquiryDetailId, enquiryStatusId, isActive, enquiryProcessId];
}

class EnquiryCancelEvent extends EnquiryEvent {
  final EnquiryDetailResponse enquiryDetailResponse;
  const EnquiryCancelEvent({this.enquiryDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}

class EnquiryReloadEvent extends EnquiryEvent {
  final int facilityId;
  final int enquiryDetailId;
  final int facilityItemId;
  const EnquiryReloadEvent(
      {this.facilityId, this.enquiryDetailId, this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, enquiryDetailId, facilityItemId];
}

class EnquiryQuestionSaveEvent extends EnquiryEvent {
  final MemberAnswerRequest memberAnswerRequest;
  const EnquiryQuestionSaveEvent({this.memberAnswerRequest});

  @override
  // TODO: implement props
  List<Object> get props => [memberAnswerRequest];
}

class EnquiryTimeTableData extends EnquiryEvent {
  final int enquiryDetailId;
  final int trainerId;
  final String fromDate;
  final int facilityItemId;
  const EnquiryTimeTableData(
      {this.enquiryDetailId,
      this.trainerId,
      this.fromDate,
      this.facilityItemId});

  @override
  // TODO: implement props
  List<Object> get props =>
      [enquiryDetailId, trainerId, fromDate, facilityItemId];
}

class GetPaymentTerms extends EnquiryEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
