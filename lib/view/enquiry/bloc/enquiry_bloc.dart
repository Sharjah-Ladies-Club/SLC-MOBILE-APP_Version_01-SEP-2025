import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/enquiry_answers.dart';
import 'package:slc/model/enquiry_questioners.dart';
import 'package:slc/model/enquiry_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/event_people_list/image_picker_provider.dart';
import 'package:slc/model/payment_terms_response.dart';

import './bloc.dart';

class EnquiryBloc extends Bloc<EnquiryEvent, EnquiryState> {
  final EnquiryBloc enquiryBloc;

  EnquiryBloc({@required this.enquiryBloc}) : super(null);

  EnquiryState get initialState => InitialEnquiryState();

  Stream<EnquiryState> mapEventToState(
    EnquiryEvent event,
  ) async* {
    if (event is EnquiryShowImageEvent) {
      try {
        //ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().getImage();
        print("FFFFFFFFFFFFFFFFFFFFF" + f.path);
        yield EnquiryShowImageState(file: f);
        yield EnquiryNewShowImageState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is EnquiryShowImageCameraEvent) {
      try {
        ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().takeImage();
        yield EnquiryShowImageCameraState(file: f);
        yield EnquiryNewShowImageCameraState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is EnquiryTermsData) {
      try {
        yield ShowProgressBar();
        List<TermsCondition> termsList = [];
        List<MemberQuestionGroup> memberQuestions = [];
        UserProfileInfo userProfileInfo = new UserProfileInfo();
        EnquiryDetailResponse enquiryDetail = new EnquiryDetailResponse();
        TrainersList trainers = new TrainersList();
        FamilyMemberList familyMemberList = new FamilyMemberList();
        Meta m = await (new FacilityDetailRepository())
            .getTermsList(event.facilityId);
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"]
              .forEach((f) => termsList.add(new TermsCondition.fromJson(f)));
        }
        Meta mf = await FacilityDetailRepository().getEnquiryFamilyList();
        if (mf.statusCode == 200) {
          familyMemberList =
              FamilyMemberList.fromJson(jsonDecode(mf.statusMsg)['response']);
          if (event.facilityId == Constants.FacilityFitness) {
            familyMemberList.familyDetails = familyMemberList.familyDetails
                .where((element) =>
                    element.customerId ==
                    SPUtil.getInt(Constants.USER_CUSTOMERID))
                .toList();
            // debugPrint(" CUUUUUUUUUUUUUUUUUUUUUUU S" +
            //     SPUtil.getInt(Constants.USER_CUSTOMERID).toString());
          }
        }
        Meta m1 = await (new FacilityDetailRepository())
            .getMemberQuestionsList(event.facilityId, event.enquiryDetailId);
        if (m1.statusCode == 200) {
          debugPrint(jsonDecode(m1.statusMsg)["response"].toString());
          jsonDecode(m1.statusMsg)["response"].forEach(
              (f) => memberQuestions.add(new MemberQuestionGroup.fromJson(f)));
        }
        if (event.enquiryDetailId != 0) {
          Meta m = await FacilityDetailRepository()
              .getItemEnquiryList(event.facilityItemId, event.enquiryDetailId);
          List<EnquiryDetailResponse> enquiryResponse = [];
          jsonDecode(m.statusMsg)['response'].forEach((f) =>
              enquiryResponse.add(new EnquiryDetailResponse.fromJson(f)));
          if (enquiryResponse.length > 0) {
            enquiryDetail = enquiryResponse[0];
          }
          Meta m2 = await FacilityDetailRepository()
              .getEnquiryTrainersList(event.enquiryDetailId, "", "");
          trainers =
              TrainersList.fromJson(jsonDecode(m2.statusMsg)['response']);
          Meta pm = await ProfileRepo().getEnquiryProfileDetail();
          userProfileInfo = new UserProfileInfo.fromJson(
              jsonDecode(pm.statusMsg)["response"]);
        }
        yield EnquiryTermsState(
            termsList: termsList,
            enquiryDetail: enquiryDetail,
            memberQuestions: memberQuestions,
            userProfileInfo: userProfileInfo,
            trainers: trainers.trainers,
            familyMembers: familyMemberList.familyDetails);
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is EnquiryTimeTableData) {
      try {
        //yield ShowProgressBar();
        TimeTableList timeTableList = new TimeTableList();
        EnquiryDetailResponse enquiryDetail = new EnquiryDetailResponse();
        if (event.enquiryDetailId != 0) {
          Meta m2 = await FacilityDetailRepository().getEnquiryTimeTableList(
              event.enquiryDetailId, event.trainerId, event.fromDate);
          timeTableList =
              TimeTableList.fromJson(jsonDecode(m2.statusMsg)['response']);
          if (event.facilityItemId != 0) {
            Meta m = await FacilityDetailRepository().getItemEnquiryList(
                event.facilityItemId, event.enquiryDetailId);
            List<EnquiryDetailResponse> enquiryResponse = [];
            jsonDecode(m.statusMsg)['response'].forEach((f) =>
                enquiryResponse.add(new EnquiryDetailResponse.fromJson(f)));
            if (enquiryResponse.length > 0) {
              enquiryDetail = enquiryResponse[0];
            }
          }
        }
        yield EnquiryTimeTableState(
            timeTables: timeTableList.timeTables,
            enquiryDetailResponse: enquiryDetail);
        // yield HideProgressBar();
      } catch (e) {
        print(e);
        //yield HideProgressBar();
      }
    } else if (event is EnquirySaveEvent) {
      try {
        yield ShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryDetails(event.enquiryDetailResponse, false);
        if (m.statusCode == 200) {
          yield EnquirySaveState(error: "Success", message: m.statusMsg);
        } else {
          yield EnquirySaveState(error: m.statusMsg, message: "");
        }
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is EnquiryEditEvent) {
      try {
        yield ShowProgressBar();
        Meta m = await (new FacilityDetailRepository()).updateEnquiryDetails(
            event.enquiryDetailId,
            event.enquiryStatusId,
            event.isActive,
            event.enquiryProcessId);
        debugPrint(
            " edit enquiry: " + m.statusCode.toString() + " " + m.statusMsg);
        if (m.statusCode == 200) {
          yield EnquiryEditState(
              error: "Success",
              message: m.statusMsg,
              workFlow: event.enquiryStatusId);
        } else {
          yield EnquiryEditState(error: m.statusMsg, message: "", workFlow: 0);
        }
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is EnquiryCancelEvent) {
      try {
        yield ShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryDetails(event.enquiryDetailResponse, true);
        if (m.statusCode == 200) {
          yield EnquiryCancelState(error: "Success");
        } else {
          yield EnquiryCancelState(error: m.statusMsg);
        }
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is EnquiryReloadEvent) {
      try {
        yield ShowProgressBar();
        EnquiryDetailResponse enquiryDetail = new EnquiryDetailResponse();
        if (event.enquiryDetailId != 0) {
          Meta m = await FacilityDetailRepository()
              .getItemEnquiryList(event.facilityItemId, event.enquiryDetailId);
          List<EnquiryDetailResponse> enquiryResponse = [];
          jsonDecode(m.statusMsg)['response'].forEach((f) =>
              enquiryResponse.add(new EnquiryDetailResponse.fromJson(f)));
          if (enquiryResponse.length > 0) {
            enquiryDetail = enquiryResponse[0];
          }
        }
        yield EnquiryReloadState(enquiryDetailResponse: enquiryDetail);
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is EnquiryQuestionSaveEvent) {
      try {
        yield ShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryQuestionDetails(event.memberAnswerRequest);
        if (m.statusCode == 200) {
          MemberAnswerResult result = new MemberAnswerResult();
          result =
              MemberAnswerResult.fromJson(jsonDecode(m.statusMsg)['response']);
          yield EnquirySaveState(
              error: "Success",
              message: result.validationResult,
              proceedToPay: result.proceedToPay);
        } else {
          yield EnquirySaveState(error: m.statusMsg, message: "");
        }
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is GetPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetPaymentTermsResult(paymentTerms: paymentTerms);
      }
    }
  }
}
