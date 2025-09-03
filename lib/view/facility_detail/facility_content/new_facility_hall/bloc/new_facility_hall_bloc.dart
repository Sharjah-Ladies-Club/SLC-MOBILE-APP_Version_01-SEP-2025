import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/booking_timetable.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/partyhall_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import '../../../../../model/knooz_response_dto.dart';
import '../../../../../model/payment_terms_response.dart';
import '../../../../../repo/event_repository.dart';
import 'new_facility_hall_event.dart';
import 'new_facility_hall_state.dart';

class NewFacilityHallBloc
    extends Bloc<NewFacilityHallEvent, NewFacilityHallState> {
  final NewFacilityHallBloc partyHallBloc;

  NewFacilityHallBloc({@required this.partyHallBloc}) : super(null);
  NewFacilityHallState get initialState => InitialNewFacilityHallState();
  Stream<NewFacilityHallState> mapEventToState(
    NewFacilityHallEvent event,
  ) async* {
    if (event is NewFacilityHallShowImageEvent) {
      try {
        // ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().getImage();
        yield NewFacilityHallShowImageState(file: f);
        yield NewFacilityHallNewShowImageState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallShowImageCameraEvent) {
      try {
        // ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().takeImage();
        yield NewFacilityHallShowImageCameraState(file: f);
        yield NewFacilityHallNewShowImageCameraState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallTermsData) {
      try {
        List<TermsCondition> termsList = [];
        List<EventType> eventTypeList = [];
        List<Venue> venueList = [];
        PartyHallResponse partyHallDetail = new PartyHallResponse();
        Meta m = await (new FacilityDetailRepository())
            .getTermsList(event.facilityId);
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"]
              .forEach((f) => termsList.add(new TermsCondition.fromJson(f)));
        }
        Meta mev = await (new FacilityDetailRepository()).getEventTypeList();
        if (mev.statusCode == 200) {
          jsonDecode(mev.statusMsg)["response"]
              .forEach((f) => eventTypeList.add(new EventType.fromJson(f)));
        }
        Meta mv = await (new FacilityDetailRepository()).getVenueList();
        if (mv.statusCode == 200) {
          jsonDecode(mv.statusMsg)["response"]
              .forEach((f) => venueList.add(new Venue.fromJson(f)));
        }
        FacilityDetailResponse facilityDetailResponse =
            new FacilityDetailResponse();
        Meta m1 = await (new FacilityDetailRepository())
            .getFacilityDetails(event.facilityId);
        if (m1.statusCode == 200) {
          facilityDetailResponse = FacilityDetailResponse.fromJson(
              jsonDecode(m1.statusMsg)['response']);
        }
        Meta m3 =
            await FacilityDetailRepository().getOnlinePartyHallItemPriceList(6);
        List<FacilityItem> menuItems = [];

        RetailOrderItemsCategory retailCategoryItems =
            new RetailOrderItemsCategory();

        if (m3.statusCode == 200) {
          retailCategoryItems = RetailOrderItemsCategory.fromJson(
              jsonDecode(m3.statusMsg)['response']);
        }
        if (event.partyHallDetailId != 0) {
          Meta m4 = await FacilityDetailRepository()
              .getPartyHallEnquiry(event.partyHallDetailId);
          if (m4.statusCode == 200) {
            partyHallDetail = PartyHallResponse.fromJson(
                jsonDecode(m4.statusMsg)['response']);
          }
        }
        yield NewFacilityHallTermsState(
            termsList: termsList,
            partyHallDetail: partyHallDetail,
            facilityDetail: facilityDetailResponse,
            menuItemList: menuItems,
            venueList: venueList,
            eventTypeList: eventTypeList,
            orderItems: retailCategoryItems);
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallSaveEvent) {
      try {
        Meta m = await (new FacilityDetailRepository())
            .savePartyHallDetails(event.partyHallResponse, false);
        if (m.statusCode == 200) {
          yield NewFacilityHallSaveState(
              error: "Success", message: m.statusMsg);
        } else {
          yield NewFacilityHallSaveState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is NewPartyHallSaveEvent) {
      try {
        Meta m = await (new FacilityDetailRepository())
            .saveKunoozDetails(event.kunoozResponse, false);
        if (m.statusCode == 200) {
          yield NewFacilityHallSaveState(
              error: "Success",
              timeStamp: DateTime.now().toString(),
              message: m.statusMsg);
          // message: jsonDecode(m.statusMsg)['response'].toString());
        } else {
          yield NewFacilityHallSaveState(
              error: m.statusMsg, message: "${DateTime.now()}");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallEditEvent) {
      try {
        Meta m = await (new FacilityDetailRepository()).updatePartyHallDetails(
            event.partyHallDetailId,
            event.partyHallStatusId,
            event.isActive,
            event.enquiryProcessId);
        if (m.statusCode == 200) {
          yield NewFacilityHallEditState(
              error: "Success", message: m.statusMsg);
        } else {
          yield NewFacilityHallEditState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallCancelEvent) {
      try {
        /* Meta m = await (new FacilityDetailRepository())
            .savePartyHallDetails(event.partyHallResponse, true);
        if (m.statusCode == 200) {
          yield PartyHallCancelState(error: "Success");
        } else {
          yield PartyHallCancelState(error: m.statusMsg);
        }*/
      } catch (e) {
        print(e);
      }
    } else if (event is NewFacilityHallReloadEvent) {
      try {
        PartyHallResponse partyHallDetail = new PartyHallResponse();
        if (event.partyHallDetailId != 0) {
          Meta m4 = await FacilityDetailRepository()
              .getPartyHallEnquiry(event.partyHallDetailId);
          partyHallDetail =
              PartyHallResponse.fromJson(jsonDecode(m4.statusMsg)['response']);
        }
        yield NewFacilityHallReloadState(partyHallResponse: partyHallDetail);
      } catch (e) {
        print(e);
      }
    } else if (event is GetFacilityPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetFacilityPaymentTermsResult(paymentTerms: paymentTerms);
      }
    } else if (event is NewPartyHallImageEvent) {
      List<PartyHallDocumentsDto> documents = [];
      Meta m =
          await (new FacilityDetailRepository()).getUploadedImages(event.id);
      if (m.statusCode == 200) {
        jsonDecode(m.statusMsg)["response"].forEach(
            (f) => documents.add(new PartyHallDocumentsDto.fromJson(f)));
      }
      yield NewFacilityHallImageState(documents: documents);
    } else if (event is NewFacilityHallKunoozEvent) {
      Meta m = await FacilityDetailRepository()
          .postKunoozBookingData(event.bookingId);
      if (m.statusCode == 200) {
        KunoozBookingDto facilityDetail =
            KunoozBookingDto.fromJson(jsonDecode(m.statusMsg)['response']);
        yield NewFacilityHallKunoozState(bookingResponse: facilityDetail);
      }
    } else if (event is NewFacilityHallDeliveryEvent) {
      Meta m = await FacilityDetailRepository()
          .getOnlineFacilityTransportCharges(event.itemGroup);
      if (m.statusCode == 200) {
        List<DeliveryCharges> deliveryCharges = [];
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"].forEach(
              (f) => deliveryCharges.add(new DeliveryCharges.fromJson(f)));
        }
        yield NewFacilityHallDeliveryState(deliveryCharges: deliveryCharges);
      }
    } else if (event is NewFacilityDocumentTypeEvent) {
      Meta m = await FacilityDetailRepository().getKunoozDocumentType();
      if (m.statusCode == 200) {
        List<DocumentType> documentTypes = [];
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"]
              .forEach((f) => documentTypes.add(new DocumentType.fromJson(f)));
        }
        yield NewFacilityHallDocumentTypeState(documentTypes: documentTypes);
      }
    }
  }
}
