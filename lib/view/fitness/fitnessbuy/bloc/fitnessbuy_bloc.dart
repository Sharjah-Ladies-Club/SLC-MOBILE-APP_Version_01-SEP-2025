import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_item_response.dart';

// import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/model/payment_terms_response.dart';
// import 'package:slc/model/facility_item.dart';
//
// import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class FitnessBuyBloc extends Bloc<FitnessBuyEvent, FitnessBuyState> {
  final FitnessBuyBloc fitnessBuyBloc;

  FitnessBuyBloc({@required this.fitnessBuyBloc}) : super(null);

  FitnessBuyState get initialState => InitialFitnessBuyState();

  Stream<FitnessBuyState> mapEventToState(
    FitnessBuyEvent event,
  ) async* {
    if (event is GetItemDetailsEvent) {
      Meta m = await FacilityDetailRepository()
          .getOnlineFitnessFacilityCategoryDetail(event.facilityId, 3);

      if (m.statusCode == 200) {
        List<FacilityDetailItem> facilityItemList = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => facilityItemList.add(new FacilityDetailItem.fromJson(f)));
        yield LoadFitnessItemList(fitnessItems: facilityItemList);
      }
    } else if (event is GetDiscountEvent) {
      Meta m = await FacilityDetailRepository()
          .getDiscountList(event.facilityId, event.billAmount);
      if (m.statusCode == 200) {
        List<BillDiscounts> billDiscounts = [];
        jsonDecode(m.statusMsg)['response']
            .forEach((f) => billDiscounts.add(new BillDiscounts.fromJson(f)));
        yield LoadDiscountList(billDiscounts: billDiscounts);
      }
    } else if (event is GetOrderStatusEvent) {
      Meta m = await FacilityDetailRepository()
          .getOrderStatus(event.merchantReferenceNo);
      if (m.statusCode == 200) {
        OrderStatus orderStatus =
            OrderStatus.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetOrderStatusState(orderStatus: orderStatus);
      }
    } else if (event is GetPaymentTerms) {
      Meta m =
          await FacilityDetailRepository().getPaymentTerms(event.facilityId);
      if (m.statusCode == 200) {
        PaymentTerms paymentTerms =
            PaymentTerms.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetPaymentTermsResult(paymentTerms: paymentTerms);
      }
    } else if (event is FitnessBuyEnquirySaveEvent) {
      try {
        Meta m = await (new FacilityDetailRepository())
            .saveEnquiryDetails(event.enquiryDetailResponse, false);
        if (m.statusCode == 200) {
          yield FitnessBuyEnquirySaveState(
              error: "Success",
              message: m.statusMsg,
              facilityItem: event.facilityItem);
        } else {
          yield FitnessBuyEnquirySaveState(error: m.statusMsg, message: "");
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
