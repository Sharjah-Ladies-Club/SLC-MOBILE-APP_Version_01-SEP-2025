import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';

import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import '../../../model/payment_terms_response.dart';
import './bloc.dart';

class BeachBloc extends Bloc<BeachEvent, BeachState> {
  final BeachBloc beachBloc;

  BeachBloc({@required this.beachBloc}) : super(null);
  BeachState get initialState => InitialBeachState();

  Stream<BeachState> mapEventToState(
    BeachEvent event,
  ) async* {
    if (event is GetItemDetailsEvent) {
      Meta m = await FacilityDetailRepository().getOnlineFacilityItemsPriceList(
          event.facilityId, event.facilityItemGroupId);
      if (m.statusCode == 200) {
        List<FacilityItem> facilityItems = new List<FacilityItem>();
        List<FacilityItem> response = jsonDecode(m.statusMsg)['response']
            .forEach((f) => facilityItems.add(new FacilityItem.fromJson(f)));
        debugPrint("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS" +
            facilityItems.length.toString());
        yield LoadBeachItemList(facilityItems: facilityItems);
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
    }
  }
}
