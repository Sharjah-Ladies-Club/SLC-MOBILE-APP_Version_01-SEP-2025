// ignore_for_file: must_be_immutable, unused_import

import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/enquiry_questioners.dart';
import 'package:slc/view/fitness/traineerprofile.dart';
import 'package:slc/model/transaction_response.dart';

abstract class FitnessState extends Equatable {
  const FitnessState();
}

class InitialFitnessState extends FitnessState {
  List<Object> get props => [];
}

class ShowFitnessProgressBarState extends FitnessState {
  // TODO: implement props
  List<Object> get props => null;
}

class HideFitnessProgressBarState extends FitnessState {
  // TODO: implement props
  List<Object> get props => null;
}

class FitnesssOnFailure extends FitnessState {
  final String error;

  const FitnesssOnFailure({this.error});

  // TODO: implement props
  List<Object> get props => [error];
}

class FitnessPageState extends FitnessState {
  final int facilityId;

  const FitnessPageState({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class ErrorDialogState extends FitnessState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  // TODO: implement props
  List<Object> get props => [title, content];
}

// class FitnessRefreshState extends FitnessState {
//   final FitnessResponse FitnessResponse;
//   const FitnessRefreshState({this.FitnessResponse});
//   @override
//   // TODO: implement props
//   List<Object> get props => [FitnessResponse];
// }

class FitnessCloseState extends FitnessState {
  final bool isClosed;
  const FitnessCloseState({this.isClosed});

  // TODO: implement props
  List<Object> get props => [isClosed];
}

class GetFitnesssTrainerState extends FitnessState {
  List<TrainerProfile> fitnessTrainers;
  GetFitnesssTrainerState({this.fitnessTrainers});

  // TODO: implement props
  List<Object> get props => [fitnessTrainers];
}

class CheckQRCodeState extends FitnessState {
  QRResult result;
  CheckQRCodeState({this.result});

  // TODO: implement props
  List<Object> get props => [result];
}

class SaveCheckInOutState extends FitnessState {
  QRResult result;
  SaveCheckInOutState({this.result});

  // TODO: implement props
  List<Object> get props => [result];
}

class GetFitnessItemState extends FitnessState {
  List<FacilityItems> fitnessItem;
  List<FacilityResponse> facilityResponse;
  GetFitnessItemState({this.fitnessItem, this.facilityResponse});

  // TODO: implement props
  List<Object> get props => [fitnessItem, facilityResponse];
}

class GetFitnesssTimeTableState extends FitnessState {
  ClassTimeTable fitnessTimeTable;
  GetFitnesssTimeTableState({this.fitnessTimeTable});

  // TODO: implement props
  List<Object> get props => [fitnessTimeTable];
}

class GetFitnesssSpaceBookingSlotState extends FitnessState {
  ClassBookingViewDto fitnessSpaceBookingSlots;
  GetFitnesssSpaceBookingSlotState({this.fitnessSpaceBookingSlots});

  // TODO: implement props
  List<Object> get props => [fitnessSpaceBookingSlots];
}

class FitnessEnquiryShowImageState extends FitnessState {
  final File file;
  const FitnessEnquiryShowImageState({this.file});

  // TODO: implement props
  List<Object> get props => null;
}

// class FitnessEnquiryNewShowImageState extends FitnessState {
//   final File file;
//   const FitnessEnquiryNewShowImageState({this.file});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

class FitnessEnquiryShowImageCameraState extends FitnessState {
  final File file;
  const FitnessEnquiryShowImageCameraState({this.file});

  // TODO: implement props
  List<Object> get props => null;
}

// class FitnessEnquiryNewShowImageCameraState extends FitnessState {
//   final File file;
//   const FitnessEnquiryNewShowImageCameraState({this.file});
//
//   @override
//   // TODO: implement props
//   List<Object> get props => null;
// }

class FitnessEnquiryTermsState extends FitnessState {
  final List<TermsCondition> termsList;
  final List<MemberQuestionGroup> memberQuestions;
  final EnquiryDetailResponse enquiryDetail;
  final UserProfileInfo userProfileInfo;
  final List<Trainers> trainers;
  final List<FamilyMember> familyMembers;

  const FitnessEnquiryTermsState(
      {this.termsList,
      this.enquiryDetail,
      this.memberQuestions,
      this.userProfileInfo,
      this.trainers,
      this.familyMembers});

  // TODO: implement props
  List<Object> get props => [
        termsList,
        enquiryDetail,
        memberQuestions,
        userProfileInfo,
        trainers,
        familyMembers
      ];
}

class FitnessEnquirySaveState extends FitnessState {
  final String error;
  final String message;
  final bool proceedToPay;
  final FacilityItems facilityItem;

  const FitnessEnquirySaveState(
      {this.error, this.message, this.proceedToPay, this.facilityItem});

  // TODO: implement props
  List<Object> get props => [error, message, proceedToPay, facilityItem];
}

class FitnessEnquiryEditState extends FitnessState {
  final String error;
  final String message;
  final int workFlow;
  const FitnessEnquiryEditState({this.error, this.message, this.workFlow});

  // TODO: implement props
  List<Object> get props => [error, message, workFlow];
}

class FitnessEnquiryCancelState extends FitnessState {
  final String error;

  const FitnessEnquiryCancelState({this.error});

  // TODO: implement props
  List<Object> get props => [error];
}

class FitnessEnquiryReloadState extends FitnessState {
  final EnquiryDetailResponse enquiryDetailResponse;

  const FitnessEnquiryReloadState({this.enquiryDetailResponse});

  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}

class FitnessEnquiryQuestionSaveState extends FitnessState {
  final String error;
  final String message;

  const FitnessEnquiryQuestionSaveState({this.error, this.message});

  // TODO: implement props
  List<Object> get props => [error, message];
}

class FitnessEnquiryTimeTableState extends FitnessState {
  final List<TimeTable> timeTables;
  final EnquiryDetailResponse enquiryDetailResponse;

  const FitnessEnquiryTimeTableState(
      {this.timeTables, this.enquiryDetailResponse});

  // TODO: implement props
  List<Object> get props => [timeTables, enquiryDetailResponse];
}

class FitnessShowProgressBar extends FitnessState {
  // TODO: implement props
  List<Object> get props => null;
}

class FitnessHideProgressBar extends FitnessState {
  // TODO: implement props
  List<Object> get props => null;
}

class FitnessGetPaymentTermsResult extends FitnessState {
  final PaymentTerms paymentTerms;
  const FitnessGetPaymentTermsResult({this.paymentTerms});

  // TODO: implement props
  List<Object> get props => [paymentTerms];
}

class LoadFitnessItemList extends FitnessState {
  final List<FacilityDetailItem> fitnessItems;

  const LoadFitnessItemList({this.fitnessItems});

  // TODO: implement props
  List<Object> get props => [LoadFitnessItemList];
}

class GetClassBookingIdState extends FitnessState {
  BookingIdResult bookingIdDetails;
  int facilityItemId;
  int classId;
  GetClassBookingIdState(
      {this.bookingIdDetails, this.facilityItemId, this.classId});

  // TODO: implement props
  List<Object> get props => [bookingIdDetails, facilityItemId, classId];
}

class GetMembershipState extends FitnessState {
  List<FacilityMembership> facilityMembership;
  MembershipClassAvailDto classAvailablity;
  GetMembershipState({this.facilityMembership, this.classAvailablity});

  // TODO: implement props
  List<Object> get props => [facilityMembership, classAvailablity];
}

class GetPTBookingsEventState extends FitnessState {
  MyPackageBookingViewDto ptData;
  GetPTBookingsEventState({this.ptData});

  // TODO: implement props
  List<Object> get props => [ptData];
}

class GetFitnessVoucherState extends FitnessState {
  List<LoyaltyVoucherResponse> voucherRedemptionList = [];
  List<String> voucherRedemptionFacilities = [];
  List<LoyaltyVoucherResponse> displayVoucherRedemptionList;
  GetFitnessVoucherState(
      {this.displayVoucherRedemptionList,
      this.voucherRedemptionFacilities,
      this.voucherRedemptionList});

  // TODO: implement props
  List<Object> get props => [
        displayVoucherRedemptionList,
        voucherRedemptionFacilities,
        voucherRedemptionList
      ];
}

class RemoveClassBookingState extends FitnessState {
  String result;
  RemoveClassBookingState({this.result});

  // TODO: implement props
  List<Object> get props => [result];
}

class GetTrainersProfileState extends FitnessState {
  ClassTimeTable fitnessTimeTable;
  GetTrainersProfileState({
    this.fitnessTimeTable,
  });

  // TODO: implement props
  List<Object> get props => [fitnessTimeTable];
}

class GetAppDescState extends FitnessState {
  ModuleDescription result;
  GetAppDescState({this.result});

  // TODO: implement props
  List<Object> get props => [result];
}
