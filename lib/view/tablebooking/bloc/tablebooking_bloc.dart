import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';

// import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class TableBookingBloc extends Bloc<TableBookingEvent, TableBookingState> {
  final TableBookingBloc tableBookingBloc;

  TableBookingBloc({@required this.tableBookingBloc}) : super(null);

  TableBookingState get initialState => InitialTableBookingState();

  @override
  Stream<TableBookingState> mapEventToState(
    TableBookingEvent event,
  ) async* {
    if (event is GetItemDetailsEvent) {
      Meta m = await FacilityDetailRepository().getOnlineFacilityItemsPriceList(
          event.facilityId, event.facilityItemGroupId);
      if (m.statusCode == 200) {
        List<FacilityItem> facilityItems = [];
        facilityItems = jsonDecode(m.statusMsg)['response']
            .forEach((f) => facilityItems.add(new FacilityItem.fromJson(f)));
        yield LoadTableBookingItemList(facilityItems: facilityItems);
      }
    } else if (event is GetOrderStatusEvent) {
      Meta m = await FacilityDetailRepository()
          .getOrderStatus(event.merchantReferenceNo);
      if (m.statusCode == 200) {
        OrderStatus orderStatus =
            OrderStatus.fromJson(jsonDecode(m.statusMsg)['response']);
        yield GetOrderStatusState(orderStatus: orderStatus);
      }
    }
  }
}
