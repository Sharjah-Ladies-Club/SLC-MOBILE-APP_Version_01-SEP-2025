import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/enquiry_questioners.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/model/payment_terms_response.dart';

abstract class EnquiryState extends Equatable {
  const EnquiryState();
}

class InitialEnquiryState extends EnquiryState {
  @override
  List<Object> get props => [];
}

class EnquiryShowImageState extends EnquiryState {
  final File file;
  const EnquiryShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class EnquiryNewShowImageState extends EnquiryState {
  final File file;
  const EnquiryNewShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class EnquiryShowImageCameraState extends EnquiryState {
  final File file;
  const EnquiryShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class EnquiryNewShowImageCameraState extends EnquiryState {
  final File file;
  const EnquiryNewShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class EnquiryTermsState extends EnquiryState {
  final List<TermsCondition> termsList;
  final List<MemberQuestionGroup> memberQuestions;
  final EnquiryDetailResponse enquiryDetail;
  final UserProfileInfo userProfileInfo;
  final List<Trainers> trainers;
  final List<FamilyMember> familyMembers;

  const EnquiryTermsState(
      {this.termsList,
      this.enquiryDetail,
      this.memberQuestions,
      this.userProfileInfo,
      this.trainers,
      this.familyMembers});

  @override
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

class EnquirySaveState extends EnquiryState {
  final String error;
  final String message;
  final bool proceedToPay;

  const EnquirySaveState({this.error, this.message, this.proceedToPay});

  @override
  // TODO: implement props
  List<Object> get props => [error, message, proceedToPay];
}

class EnquiryEditState extends EnquiryState {
  final String error;
  final String message;
  final int workFlow;
  const EnquiryEditState({this.error, this.message, this.workFlow});

  @override
  // TODO: implement props
  List<Object> get props => [error, message, workFlow];
}

class EnquiryCancelState extends EnquiryState {
  final String error;

  const EnquiryCancelState({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class EnquiryReloadState extends EnquiryState {
  final EnquiryDetailResponse enquiryDetailResponse;

  const EnquiryReloadState({this.enquiryDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [enquiryDetailResponse];
}

class EnquiryQuestionSaveState extends EnquiryState {
  final String error;
  final String message;

  const EnquiryQuestionSaveState({this.error, this.message});

  @override
  // TODO: implement props
  List<Object> get props => [error, message];
}

class EnquiryTimeTableState extends EnquiryState {
  final List<TimeTable> timeTables;
  final EnquiryDetailResponse enquiryDetailResponse;

  const EnquiryTimeTableState({this.timeTables, this.enquiryDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [timeTables, enquiryDetailResponse];
}

class ShowProgressBar extends EnquiryState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends EnquiryState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class GetPaymentTermsResult extends EnquiryState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
