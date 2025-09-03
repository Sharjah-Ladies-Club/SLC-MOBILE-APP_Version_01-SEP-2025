import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/enquiry_answers.dart';
import 'package:slc/model/facility_detail_item_response.dart';

abstract class FitnessEvent extends Equatable {
  const FitnessEvent();
}

class FetchFitnesssEvent extends FitnessEvent {
  // TODO: implement props
  List<Object> get props => null;
}

class ShowFitnessProgressBar extends FitnessEvent {
  // TODO: implement props
  List<Object> get props => null;
}

class HideFitnessProgressBar extends FitnessEvent {
  // TODO: implement props
  List<Object> get props => null;
}

class FitnessOnFailure extends FitnessEvent {
  final String error;

  const FitnessOnFailure({this.error});

  // TODO: implement props
  List<Object> get props => [error];
}

class BeachPageEvent extends FitnessEvent {
  final int facilityId;

  const BeachPageEvent({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class ErrorDialogEvent extends FitnessEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  // TODO: implement props
  List<Object> get props => [title, content];
}

class FitnesssInitialEvent extends FitnessEvent {
  // TODO: implement props
  List<Object> get props => null;
}

class GetFitnesssTrainerEvent extends FitnessEvent {
  final String classDate;
  const GetFitnesssTrainerEvent({this.classDate});

  // TODO: implement props
  List<Object> get props => [classDate];
}

class CheckQRCodeEvent extends FitnessEvent {
  final String scanqrCode;
  final int locationId;
  final int checkInStatus;
  const CheckQRCodeEvent(
      {this.scanqrCode, this.locationId, this.checkInStatus});

  // TODO: implement props
  List<Object> get props => [scanqrCode];
}

class SaveCheckInOutEvent extends FitnessEvent {
  final String scanqrCode;
  final int locationId;
  final int checkInStatus;
  const SaveCheckInOutEvent(
      {this.scanqrCode, this.locationId, this.checkInStatus});

  // TODO: implement props
  List<Object> get props => [scanqrCode];
}

class GetFitnessItemEvent extends FitnessEvent {
  final int facilityModeuleId;
  const GetFitnessItemEvent({this.facilityModeuleId});

  // TODO: implement props
  List<Object> get props => [facilityModeuleId];
}

class GetFitnesssTimeTableEvent extends FitnessEvent {
  final String classDate;
  final int trainerId;
  const GetFitnesssTimeTableEvent({this.classDate, this.trainerId});

  // TODO: implement props
  List<Object> get props => [classDate];
}

class GetFitnesssSpaceBookingSlotEvent extends FitnessEvent {
  final String classDate;
  final int trainerId;
  final int customerId;
  final String classNameDescription;
  final int classId;
  final int classMasterId;
  const GetFitnesssSpaceBookingSlotEvent(
      {this.classDate,
      this.trainerId,
      this.customerId,
      this.classNameDescription,
      this.classId,
      this.classMasterId});

  // TODO: implement props
  List<Object> get props =>
      [classDate, trainerId, customerId, classId, classMasterId];
}

class FitnessRefreshEvent extends FitnessEvent {
  final int facilityId;
  const FitnessRefreshEvent({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class FitnessCloseEvent extends FitnessEvent {
  final bool isClosed;
  const FitnessCloseEvent({this.isClosed});

  // TODO: implement props
  List<Object> get props => [isClosed];
}

class FitnessPageEvent extends FitnessEvent {
  final int facilityId;
  const FitnessPageEvent({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class FitnessEnquiryShowImageEvent extends FitnessEvent {
  final File file;

  const FitnessEnquiryShowImageEvent({this.file});

  // TODO: implement props
  List<Object> get props => [file];
}

class FitnessEnquiryShowImageCameraEvent extends FitnessEvent {
  final File file;

  const FitnessEnquiryShowImageCameraEvent({this.file});

  // TODO: implement props
  List<Object> get props => [file];
}

class FitnessEnquiryTermsData extends FitnessEvent {
  final int facilityId;
  final int facilityItemId;
  final int enquiryDetailId;
  const FitnessEnquiryTermsData(
      {this.facilityId, this.enquiryDetailId, this.facilityItemId});

  // TODO: implement props
  List<Object> get props => [facilityId, enquiryDetailId, facilityItemId];
}

class FitnessEnquirySaveEvent extends FitnessEvent {
  final EnquiryDetailResponse enquiryDetailResponse;
  final FacilityItems facilityItem;
  const FitnessEnquirySaveEvent(
      {this.enquiryDetailResponse, this.facilityItem});

  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse, facilityItem];
}

class FitnessEnquiryEditEvent extends FitnessEvent {
  final int enquiryDetailId;
  final int enquiryStatusId;
  final int enquiryProcessId;
  final bool isActive;
  const FitnessEnquiryEditEvent(
      {this.enquiryDetailId,
      this.enquiryStatusId,
      this.isActive,
      this.enquiryProcessId});

  // TODO: implement props
  List<Object> get props =>
      [enquiryDetailId, enquiryStatusId, isActive, enquiryProcessId];
}

class FitnessEnquiryCancelEvent extends FitnessEvent {
  final EnquiryDetailResponse enquiryDetailResponse;
  const FitnessEnquiryCancelEvent({this.enquiryDetailResponse});

  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}

class FitnessEnquiryReloadEvent extends FitnessEvent {
  final int facilityId;
  final int enquiryDetailId;
  final int facilityItemId;
  const FitnessEnquiryReloadEvent(
      {this.facilityId, this.enquiryDetailId, this.facilityItemId});

  // TODO: implement props
  List<Object> get props => [facilityId, enquiryDetailId, facilityItemId];
}

class FitnessEnquiryQuestionSaveEvent extends FitnessEvent {
  final MemberAnswerRequest memberAnswerRequest;
  const FitnessEnquiryQuestionSaveEvent({this.memberAnswerRequest});

  // TODO: implement props
  List<Object> get props => [memberAnswerRequest];
}

class FitnessEnquiryTimeTableData extends FitnessEvent {
  final int enquiryDetailId;
  final int trainerId;
  final String fromDate;
  final int facilityItemId;
  const FitnessEnquiryTimeTableData(
      {this.enquiryDetailId,
      this.trainerId,
      this.fromDate,
      this.facilityItemId});

  // TODO: implement props
  List<Object> get props =>
      [enquiryDetailId, trainerId, fromDate, facilityItemId];
}

class GetPaymentTerms extends FitnessEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class GetMembershipDetails extends FitnessEvent {
  final int userId;
  final int facilityId;
  const GetMembershipDetails({this.userId, this.facilityId});

  // TODO: implement props
  List<Object> get props => [userId];
}

class GetItemDetailsEvent extends FitnessEvent {
  final int facilityId;
  final String retailItemSetId;

  const GetItemDetailsEvent({this.facilityId, this.retailItemSetId});

  // TODO: implement props
  List<Object> get props => [facilityId, retailItemSetId];
}

class GetClassBookingId extends FitnessEvent {
  final int classId;
  final int erpCustomerId;
  final int facilityItemId;
  final int bookingId;
  final int memberTypeId;
  final int voucherCount;
  const GetClassBookingId(
      {this.classId,
      this.memberTypeId,
      this.erpCustomerId,
      this.facilityItemId,
      this.bookingId,
      this.voucherCount});

  // TODO: implement props
  List<Object> get props => [
        classId,
        erpCustomerId,
        facilityItemId,
        bookingId,
        memberTypeId,
        voucherCount
      ];
}

class GetPTBookingsEvent extends FitnessEvent {
  final String classDate;
  final int screenCode;
  const GetPTBookingsEvent({this.classDate, this.screenCode});

  // TODO: implement props
  List<Object> get props => [classDate, screenCode];
}

class GetFitnessVouchersEvent extends FitnessEvent {
  final int userId;
  const GetFitnessVouchersEvent({this.userId});

  // TODO: implement props
  List<Object> get props => [userId];
}

class GetTrainersProfileEvent extends FitnessEvent {
  final int trainerId;
  final String fromDate;
  const GetTrainersProfileEvent({this.trainerId, this.fromDate});

  // TODO: implement props
  List<Object> get props => [trainerId, fromDate];
}

class RemoveClassBooking extends FitnessEvent {
  final int classId;
  final int erpCustomerId;
  final int bookingId;
  const RemoveClassBooking({
    this.classId,
    this.erpCustomerId,
    this.bookingId,
  });

  // TODO: implement props
  List<Object> get props => [
        classId,
        erpCustomerId,
        bookingId,
      ];
}

class GetAppDescEvent extends FitnessEvent {
  final int descId;
  const GetAppDescEvent({this.descId});

  // TODO: implement props
  List<Object> get props => [descId];
}
