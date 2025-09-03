import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';
import '../../../../model/facility_detail_response.dart';
import '../../../../model/terms_condition.dart';

class FacilityContentBloc
    extends Bloc<FacilityContentEvent, FacilityContentState> {
  FacilityContentBloc(FacilityContentState initialState) : super(initialState);

  FacilityContentState get initialState => InitialFacilityContentState();

  Stream<FacilityContentState> mapEventToState(
    FacilityContentEvent event,
  ) async* {
    if (event is FetchTabContent) {
      yield InitialFacilityContentState();
      yield PopulateFacilityTabData(
        tabId: event.tabId,
        tabName: event.tabName,
        tabType: event.tabType,
        response: event.response,
        // menuId:event.menuId
      );
    } else if (event is GetKunoozBookingData) {
      Meta m = await FacilityDetailRepository()
          .postKunoozBookingData(event.bookingId);
      if (m.statusCode == 200) {
        KunoozBookingDto facilityDetail =
            KunoozBookingDto.fromJson(jsonDecode(m.statusMsg)['response']);
        yield KunoozBookingData(bookingResponse: facilityDetail);
      }
    } else if (event is GetKunoozAmendContractData) {
      Meta m = await FacilityDetailRepository()
          .getKunoozAmendContractData(event.amendId);
      if (m.statusCode == 200) {
        KunuoozContractDataDto amendContractDetail =
            KunuoozContractDataDto.fromJson(jsonDecode(m.statusMsg));
        yield KunoozAmendContractData(
            contractResponse: amendContractDetail.response);
      }
    } else if (event is GetKunoozPaymentTerms) {
      List<TermsCondition> termsList = [];
      Meta m =
          await FacilityDetailRepository().getKunoozTermsList(event.facilityId);
      if (m.statusCode == 200) {
        Meta m = await (new FacilityDetailRepository())
            .getTermsList(event.facilityId);
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"]
              .forEach((f) => termsList.add(new TermsCondition.fromJson(f)));
        }
        // PaymentTerms paymentTerms =
        //     PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield KunoozPaymentTerms(termsList: termsList);
      }
    } else if (event is GetKunoozContractDownload) {
      Meta m = await FacilityDetailRepository()
          .getKunoozContractDownload(event.bookingId);

      if (m.statusCode == 200) {
        Map<String, dynamic> documentResp = <String, dynamic>{};
        documentResp = jsonDecode(m.statusMsg);
        String url = documentResp['response']['appdownloadUrl'];
        yield KunoozContractDownload(
            url: url, timeStamp: DateTime.now().toString());
      }
    } else if (event is GetKunoozAmendmentDownload) {
      Meta m = await FacilityDetailRepository()
          .getKunoozAmendmentDownload(event.amendmentId);
      if (m.statusCode == 200) {
        Map<String, dynamic> documentResp = <String, dynamic>{};
        documentResp = jsonDecode(m.statusMsg);
        String url = documentResp['response']['appdownloadUrl'];
        yield KunoozAmendmentDownload(
            url: url, timeStamp: DateTime.now().toString());
      }
    } else if (event is GetKunoozCancelBooking) {
      FacilityDetailResponse facilityDetailResponse =
          new FacilityDetailResponse();
      List<ImageVRDto> imageVR = [];
      List<CateringType> cateringTypeList = [];
      List<KunoozBookingListDto> partyHallEnquiryList = [];
      Meta f = await (new FacilityDetailRepository()).getFacilityDetails(6);
      if (f.statusCode == 200) {
        facilityDetailResponse = FacilityDetailResponse.fromJson(
            jsonDecode(f.statusMsg)['response']);

        // jsonDecode(f.statusMsg)["response"]["partyHallEnquiryList"].forEach(
        //     (f) =>
        //         partyHallEnquiryList.add(new KunoozBookingListDto.fromJson(f)));
        // jsonDecode(f.statusMsg)["response"]["imageVR"]
        //     .forEach((f) => imageVR.add(new ImageVRDto.fromJson(f)));
        // jsonDecode(f.statusMsg)["response"]["cateringTypeList"]
        //     .forEach((f) => cateringTypeList.add(new CateringType.fromJson(f)));
      }
      Meta m = await FacilityDetailRepository()
          .getKunoozCancelBooking(event.bookingId);
      if (m.statusCode == 200) {
        String cancelResp =
            jsonDecode(m.statusMsg)['response']['postStatusMessage'];
        yield KunoozCancelBooking(cancelResp: cancelResp);
      } else {
        yield KunoozCancelBooking(cancelResp: m.statusMsg);
      }
    } else if (event is GetKunoozRevertAmendmentEvent) {
      Meta m = await FacilityDetailRepository()
          .postKunoozRevertAmendmentData(event.bookingId, event.isAccept);
      if (m.statusCode == 200) {
        yield KunoozRevertAmendmentState(revertMessage: "Updated successfully");
      }
    }
  }
}
