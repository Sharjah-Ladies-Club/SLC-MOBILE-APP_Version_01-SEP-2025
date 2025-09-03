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
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/model/transaction_response.dart';
import 'package:slc/model/user_profile_info.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/repo/profile_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/event_people_list/image_picker_provider.dart';

import './bloc.dart';

class FitnessBloc extends Bloc<FitnessEvent, FitnessState> {
  FitnessBloc(FitnessState initialState) : super(initialState);

  FitnessState get initialState => InitialFitnessState();

  Stream<FitnessState> mapEventToState(
    FitnessEvent event,
  ) async* {
    if (event is GetFitnesssTrainerEvent) {
      Meta m = await FacilityDetailRepository()
          .getFitnessTrainersList(event.classDate);
      if (m.statusCode == 200) {
        List<TrainerProfile> trainers = [];
        jsonDecode(m.statusMsg)['response']['trainers']
            .forEach((f) => trainers.add(new TrainerProfile.fromJson(f)));
        yield GetFitnesssTrainerState(fitnessTrainers: trainers);
      }
    } else if (event is GetFitnesssTimeTableEvent) {
      yield ShowFitnessProgressBarState();
      Meta m = await FacilityDetailRepository()
          .getFitnessTimeTableList(event.trainerId, event.classDate);
      if (m.statusCode == 200) {
        ClassTimeTable fitnessTimeTable = new ClassTimeTable();
        fitnessTimeTable =
            ClassTimeTable.fromJson(jsonDecode(m.statusMsg)['response']);
        if (fitnessTimeTable == null ||
            fitnessTimeTable.classSlots == null ||
            fitnessTimeTable.classSlots.length == 0) {
          yield GetFitnesssTimeTableState(
              fitnessTimeTable: new ClassTimeTable());
        } else {
          yield GetFitnesssTimeTableState(fitnessTimeTable: fitnessTimeTable);
        }
      }
      yield HideFitnessProgressBarState();
    } else if (event is GetFitnesssSpaceBookingSlotEvent) {
      yield ShowFitnessProgressBarState();
      Meta m = await FacilityDetailRepository().getFitnessSpaceBookingList(
          event.classDate,
          event.trainerId,
          event.customerId,
          event.classMasterId);
      if (m.statusCode == 200) {
        ClassBookingViewDto fitnessTimeTable = new ClassBookingViewDto();
        fitnessTimeTable =
            ClassBookingViewDto.fromJson(jsonDecode(m.statusMsg)['response']);
        if (fitnessTimeTable == null ||
            ((fitnessTimeTable.spaceSlots == null ||
                    fitnessTimeTable.spaceSlots.length == 0) &&
                (fitnessTimeTable.bookingSlots == null ||
                    fitnessTimeTable.bookingSlots.length == 0))) {
          yield GetFitnesssSpaceBookingSlotState(
              fitnessSpaceBookingSlots: new ClassBookingViewDto());
        } else {
          yield GetFitnesssSpaceBookingSlotState(
              fitnessSpaceBookingSlots: fitnessTimeTable);
        }
      }
      yield HideFitnessProgressBarState();
    } else if (event is ShowFitnessProgressBar) {
      yield ShowFitnessProgressBarState();
    } else if (event is HideFitnessProgressBar) {
      yield HideFitnessProgressBarState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is FitnessOnFailure) {
      yield FitnesssOnFailure(error: event.error);
    } else if (event is FitnesssInitialEvent) {
      yield InitialFitnessState();
    } else if (event is FitnessPageEvent) {
      yield FitnessPageState(facilityId: event.facilityId);
    } else if (event is FitnessCloseEvent) {
      yield FitnessCloseState(isClosed: event.isClosed);
    } else if (event is FitnessEnquiryShowImageEvent) {
      try {
        //ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().getImage();
        print("FFFFFFFFFFFFFFFFFFFFF" + f.path);
        yield FitnessEnquiryShowImageState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is FitnessEnquiryShowImageCameraEvent) {
      try {
        ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().takeImage();
        yield FitnessEnquiryShowImageCameraState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is FitnessEnquiryTermsData) {
      try {
        yield ShowFitnessProgressBarState();
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
        Meta m1 = await (new FacilityDetailRepository())
            .getFitnessMemberQuestionsList(
                event.facilityId, event.enquiryDetailId);
        if (m1.statusCode == 200) {
          jsonDecode(m1.statusMsg)["response"].forEach(
              (q) => memberQuestions.add(new MemberQuestionGroup.fromJson(q)));
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
          }
        }
        debugPrint(" CUUUUUUUUUUUUUUUUUUUUUUU PASS FACILITYID" +
            event.facilityId.toString());

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
        yield FitnessEnquiryTermsState(
            termsList: termsList,
            enquiryDetail: enquiryDetail,
            memberQuestions: memberQuestions,
            userProfileInfo: userProfileInfo,
            trainers: trainers.trainers,
            familyMembers: familyMemberList.familyDetails);
        yield HideFitnessProgressBarState();
      } catch (e) {
        print(e);
        yield HideFitnessProgressBarState();
      }
    } else if (event is FitnessEnquiryTimeTableData) {
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
        yield FitnessEnquiryTimeTableState(
            timeTables: timeTableList.timeTables,
            enquiryDetailResponse: enquiryDetail);
        // yield HideProgressBar();
      } catch (e) {
        print(e);
        //yield HideProgressBar();
      }
    } else if (event is FitnessEnquirySaveEvent) {
      try {
        yield FitnessShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryDetails(event.enquiryDetailResponse, false);
        if (m.statusCode == 200) {
          yield FitnessEnquirySaveState(
              error: "Success",
              message: m.statusMsg,
              facilityItem: event.facilityItem);
        } else {
          yield FitnessEnquirySaveState(error: m.statusMsg, message: "");
        }
        yield FitnessHideProgressBar();
      } catch (e) {
        print(e);
        yield FitnessHideProgressBar();
      }
    } else if (event is FitnessEnquiryEditEvent) {
      try {
        yield FitnessShowProgressBar();
        Meta m = await (new FacilityDetailRepository()).updateEnquiryDetails(
            event.enquiryDetailId,
            event.enquiryStatusId,
            event.isActive,
            event.enquiryProcessId);
        debugPrint(
            " edit enquiry: " + m.statusCode.toString() + " " + m.statusMsg);
        if (m.statusCode == 200) {
          yield FitnessEnquiryEditState(
              error: "Success",
              message: m.statusMsg,
              workFlow: event.enquiryStatusId);
        } else {
          yield FitnessEnquiryEditState(
              error: m.statusMsg, message: "", workFlow: 0);
        }
        yield FitnessHideProgressBar();
      } catch (e) {
        print(e);
        yield FitnessHideProgressBar();
      }
    } else if (event is FitnessEnquiryCancelEvent) {
      try {
        yield FitnessShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryDetails(event.enquiryDetailResponse, true);
        if (m.statusCode == 200) {
          yield FitnessEnquiryCancelState(error: "Success");
        } else {
          yield FitnessEnquiryCancelState(error: m.statusMsg);
        }
        yield FitnessHideProgressBar();
      } catch (e) {
        print(e);
        yield FitnessHideProgressBar();
      }
    } else if (event is FitnessEnquiryReloadEvent) {
      try {
        yield FitnessShowProgressBar();
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
        yield FitnessEnquiryReloadState(enquiryDetailResponse: enquiryDetail);
        yield FitnessHideProgressBar();
      } catch (e) {
        print(e);
        yield FitnessHideProgressBar();
      }
    } else if (event is FitnessEnquiryQuestionSaveEvent) {
      try {
        yield FitnessShowProgressBar();
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryQuestionDetails(event.memberAnswerRequest);
        if (m.statusCode == 200) {
          MemberAnswerResult result = new MemberAnswerResult();
          result =
              MemberAnswerResult.fromJson(jsonDecode(m.statusMsg)['response']);
          yield FitnessEnquiryQuestionSaveState(
              error: "Success", message: result.validationResult);
        } else {
          yield FitnessEnquirySaveState(error: m.statusMsg, message: "");
        }
        yield FitnessHideProgressBar();
      } catch (e) {
        print(e);
        yield FitnessHideProgressBar();
      }
    } else if (event is GetPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield FitnessGetPaymentTermsResult(paymentTerms: paymentTerms);
      }
    } else if (event is GetItemDetailsEvent) {
      Meta m = await FacilityDetailRepository()
          .getOnlineFitnessFacilityCategoryDetail(event.facilityId, 6);

      if (m.statusCode == 200) {
        List<FacilityDetailItem> facilityItemList = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => facilityItemList.add(new FacilityDetailItem.fromJson(f)));
        yield LoadFitnessItemList(fitnessItems: facilityItemList);
      }
    } else if (event is CheckQRCodeEvent) {
      Meta m = await FacilityDetailRepository()
          .getCheckInOut("", event.locationId, 1);
      if (m.statusCode == 200) {
        QRResult result =
            QRResult.fromJson(jsonDecode(m.statusMsg)['response']);
        yield CheckQRCodeState(result: result);
      }
    } else if (event is SaveCheckInOutEvent) {
      Meta m = await FacilityDetailRepository().getCheckInOut(
          event.scanqrCode, event.locationId, event.checkInStatus);
      if (m.statusCode == 200) {
        QRResult result =
            QRResult.fromJson(jsonDecode(m.statusMsg)['response']);
        yield SaveCheckInOutState(result: result);
      }
    } else if (event is GetFitnessItemEvent) {
      Meta m = await FacilityDetailRepository()
          .getFitnessItem(event.facilityModeuleId);
      if (m.statusCode == 200) {
        QRResult result =
            QRResult.fromJson(jsonDecode(m.statusMsg)['response']);
        yield CheckQRCodeState(result: result);
      }
    } else if (event is GetClassBookingId) {
      if (event.memberTypeId >= 2 ||
          (event.memberTypeId == 1 && event.voucherCount > 0)) {
        Meta m = await FacilityDetailRepository().getAddToFitnessClass(
            event.classId,
            event.facilityItemId,
            event.bookingId,
            event.memberTypeId);
        if (m.statusCode == 200) {
          BookingIdResult bookingIdDetails =
              BookingIdResult.fromJson(jsonDecode(m.statusMsg)['response']);
          yield GetClassBookingIdState(
              bookingIdDetails: bookingIdDetails,
              facilityItemId: event.facilityItemId,
              classId: event.classId);
          //todo refresh
        }
      } else {
        yield GetClassBookingIdState(
            facilityItemId: event.facilityItemId, classId: event.classId);
      }
    } else if (event is GetMembershipDetails) {
      Meta m = await FacilityDetailRepository()
          .getUserMembershipfacilityUrl(event.facilityId);
      if (m.statusCode == 200) {
        SLCMemberships slcMemberships = new SLCMemberships();
        slcMemberships =
            SLCMemberships.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetMembershipState(
            facilityMembership: slcMemberships.memberShipDetail,
            classAvailablity: slcMemberships.classAvailDetail);
      }
    } else if (event is GetPTBookingsEvent) {
      yield ShowFitnessProgressBarState();
      Meta m = await FacilityDetailRepository()
          .getPTPackageDetails(event.classDate, event.screenCode);
      if (m.statusCode == 200) {
        MyPackageBookingViewDto packageBookingViewDto =
            new MyPackageBookingViewDto();
        packageBookingViewDto = MyPackageBookingViewDto.fromJson(
            jsonDecode(m.statusMsg)['response']);
        if (packageBookingViewDto == null ||
            ((packageBookingViewDto.spaceSlots == null ||
                    packageBookingViewDto.spaceSlots.length == 0) &&
                (packageBookingViewDto.packageDetails == null ||
                    packageBookingViewDto.packageDetails.length == 0))) {
          yield GetPTBookingsEventState(ptData: new MyPackageBookingViewDto());
        } else {
          yield GetPTBookingsEventState(ptData: packageBookingViewDto);
        }
      }
      yield HideFitnessProgressBarState();
    } else if (event is GetFitnessVouchersEvent) {
      yield ShowFitnessProgressBarState();
      List<LoyaltyVoucherResponse> voucherRedemptionList = [];
      List<String> voucherRedemptionFacilities = [];
      List<LoyaltyVoucherResponse> displayVoucherRedemptionList = [];

      Meta m = await (new FacilityDetailRepository())
          .getFitnessRedemptionList(0, 0, 6);
      if (m.statusCode == 200) {
        jsonDecode(m.statusMsg)["response"].forEach((f) =>
            voucherRedemptionList.add(new LoyaltyVoucherResponse.fromJson(f)));
      }
      if (voucherRedemptionList != null && voucherRedemptionList.length > 0) {
        String firstFacility = "";
        for (var v in voucherRedemptionList) {
          if (voucherRedemptionFacilities.indexOf(v.voucherName) == -1) {
            voucherRedemptionFacilities.add(v.voucherName);
            if (firstFacility == "") {
              firstFacility = v.voucherName;
            }
          }
          if (v.voucherName == firstFacility) {
            displayVoucherRedemptionList.add(v);
          }
        }
      }
      yield GetFitnessVoucherState(
          displayVoucherRedemptionList: displayVoucherRedemptionList,
          voucherRedemptionFacilities: voucherRedemptionFacilities,
          voucherRedemptionList: voucherRedemptionList);
      yield HideFitnessProgressBarState();
    } else if (event is RemoveClassBooking) {
      Meta m = await FacilityDetailRepository().removeFitnessClass(
        event.classId,
        event.bookingId,
      );
      if (m.statusCode == 200) {
        yield RemoveClassBookingState(
            result: jsonDecode(m.statusMsg)['response']);
        //todo refresh
      } else {
        yield RemoveClassBookingState(result: "Failed");
      }
    } else if (event is GetTrainersProfileEvent) {
      yield ShowFitnessProgressBarState();
      Meta m = await FacilityDetailRepository()
          .getTrainersProfile(event.trainerId, event.fromDate);
      if (m.statusCode == 200) {
        ClassTimeTable timeTable = new ClassTimeTable();
        timeTable =
            ClassTimeTable.fromJson(jsonDecode(m.statusMsg)["response"]);
        yield GetTrainersProfileState(fitnessTimeTable: timeTable);
        yield HideFitnessProgressBarState();
        //todo refresh
      } else {
        yield RemoveClassBookingState(result: "Failed");
        yield HideFitnessProgressBarState();
      }
    } else if (event is GetAppDescEvent) {
      Meta m = await FacilityDetailRepository().getAppContentDesc(event.descId);
      if (m.statusCode == 200) {
        ModuleDescription result =
            ModuleDescription.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetAppDescState(result: result);
      }
    } else if (event is HideFitnessProgressBar) {
      yield HideFitnessProgressBarState();
    }
  }
}
