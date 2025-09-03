import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/gmcore/model/Meta.dart';

import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/model/payment_terms_response.dart';

import './bloc.dart';

class RetailBloc extends Bloc<RetailEvent, RetailState> {
  final RetailBloc retailBloc;

  RetailBloc({@required this.retailBloc}) : super(null);

  RetailState get initialState => InitialRetailState();

  Stream<RetailState> mapEventToState(
    RetailEvent event,
  ) async* {
    if (event is GetItemDetailsEvent) {
      Meta m = await FacilityDetailRepository().getOnlineRetailItemsPriceList(
          event.facilityId, event.retailItemSetId);
      if (m.statusCode == 200) {
        RetailOrderItemsCategory retailCategoryItems =
            new RetailOrderItemsCategory();
        retailCategoryItems = RetailOrderItemsCategory.fromJson(
            jsonDecode(m.statusMsg)['response']);
        if (retailCategoryItems == null ||
            retailCategoryItems.retailCategoryItems == null ||
            retailCategoryItems.retailCategoryItems.length == 0) {
          yield InvalidQRCode();
        } else {
          if (!retailCategoryItems.isOpen) {
            debugPrint(
                "Shop Open Status" + retailCategoryItems.isOpen.toString());
            yield ShopClosed();
          } else {
            yield LoadRetailItemList(
                retailOrderCategoryItems: retailCategoryItems);
          }
        }
      } else {
        yield InvalidQRCode();
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
    }
  }
}
