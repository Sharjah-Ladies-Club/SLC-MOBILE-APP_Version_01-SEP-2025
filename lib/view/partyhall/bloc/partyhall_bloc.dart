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
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/model/terms_condition.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/view/partyhall/bloc/bloc.dart';

class PartyHallBloc extends Bloc<PartyHallEvent, PartyHallState> {
  final PartyHallBloc partyHallBloc;

  PartyHallBloc({@required this.partyHallBloc}) : super(null);
  PartyHallState get initialState => InitialPartyHallState();
  Stream<PartyHallState> mapEventToState(
    PartyHallEvent event,
  ) async* {
    if (event is PartyHallShowImageEvent) {
      try {
        // ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().getImage();
        yield PartyHallShowImageState(file: f);
        yield PartyHallNewShowImageState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is PartyHallShowImageCameraEvent) {
      try {
        // ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().takeImage();
        yield PartyHallShowImageCameraState(file: f);
        yield PartyHallNewShowImageCameraState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is PartyHallTermsData) {
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
        yield PartyHallTermsState(
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
    } else if (event is PartyHallSaveEvent) {
      try {
        Meta m = await (new FacilityDetailRepository())
            .savePartyHallDetails(event.partyHallResponse, false);
        if (m.statusCode == 200) {
          yield PartyHallSaveState(error: "Success", message: m.statusMsg);
        } else {
          yield PartyHallSaveState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is NewPartyHallSaveEvent) {
      try {
        Meta m = await (new FacilityDetailRepository())
            .saveKunoozDetails(event.kunoozResponse, false);
        if (m.statusCode == 200) {
          yield PartyHallSaveState(
              error: "Success",
              message: jsonDecode(m.statusMsg)['response'].toString());
        } else {
          yield PartyHallSaveState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is PartyHallEditEvent) {
      try {
        Meta m = await (new FacilityDetailRepository()).updatePartyHallDetails(
            event.partyHallDetailId,
            event.partyHallStatusId,
            event.isActive,
            event.enquiryProcessId);
        if (m.statusCode == 200) {
          yield PartyHallEditState(error: "Success", message: m.statusMsg);
        } else {
          yield PartyHallEditState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    } else if (event is PartyHallCancelEvent) {
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
    } else if (event is PartyHallReloadEvent) {
      try {
        PartyHallResponse partyHallDetail = new PartyHallResponse();
        if (event.partyHallDetailId != 0) {
          Meta m4 = await FacilityDetailRepository()
              .getPartyHallEnquiry(event.partyHallDetailId);
          partyHallDetail =
              PartyHallResponse.fromJson(jsonDecode(m4.statusMsg)['response']);
        }
        yield PartyHallReloadState(partyHallResponse: partyHallDetail);
      } catch (e) {
        print(e);
      }
    } else if (event is GetPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetPaymentTermsResult(paymentTerms: paymentTerms);
      }
    } else if (event is NewPartyHallImageEvent) {
      List<PartyHallDocuments> documents = [];
      Meta m =
          await (new FacilityDetailRepository()).getUploadedImages(event.id);
      if (m.statusCode == 200) {
        jsonDecode(m.statusMsg)["response"]
            .forEach((f) => documents.add(new PartyHallDocuments.fromJson(f)));
      }
      yield PartyHallImageState(documents: documents);
    }
  }
}
