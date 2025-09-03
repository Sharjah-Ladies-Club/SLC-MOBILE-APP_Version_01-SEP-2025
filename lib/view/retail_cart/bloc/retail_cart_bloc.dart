import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';

import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import 'package:slc/model/payment_terms_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class RetailCartBloc extends Bloc<RetailCartEvent, RetailCartState> {
  final RetailCartBloc retailBloc;

  RetailCartBloc({@required this.retailBloc}) : super(null);

  RetailCartState get initialState => InitialRetailCartState();

  Stream<RetailCartState> mapEventToState(
    RetailCartEvent event,
  ) async* {
    if (event is GetCartItemDetailsEvent) {
      Meta m = await FacilityDetailRepository()
          .getOnlineRetailCartItemsPriceList(
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
          Meta m1 =
              await FacilityDetailRepository().getOnlineRetailDeliveryAddress();
          List<DeliveryAddress> deliveryAddresses = [];
          if (m1.statusCode == 200) {
            jsonDecode(m1.statusMsg)["response"].forEach(
                (f) => deliveryAddresses.add(new DeliveryAddress.fromJson(f)));
          }

          Meta m2 = await FacilityDetailRepository()
              .getOnlineRetailDeliveryCharges(event.facilityId);
          List<DeliveryCharges> deliveryCharges = [];
          if (m2.statusCode == 200) {
            jsonDecode(m2.statusMsg)["response"].forEach(
                (f) => deliveryCharges.add(new DeliveryCharges.fromJson(f)));
          }

          yield LoadRetailCartItemList(
              retailOrderCategoryItems: retailCategoryItems,
              deliveryAddresses: deliveryAddresses,
              deliveryCharges: deliveryCharges);
        }
      } else {
        yield InvalidQRCode();
      }
    }
    if (event is GetGiftCardCategoryDetailsEvent) {
      Meta m = await FacilityDetailRepository().getGiftCardUIData();
      if (m.statusCode == 200) {
        GiftCardUI giftCardUI = new GiftCardUI();
        giftCardUI = GiftCardUI.fromJson(jsonDecode(m.statusMsg)['response']);
        yield LoadGiftCardCategoryList(giftCardUI: giftCardUI);
      } else {
        yield NoRecordsFound();
      }
    }
    if (event is GetGiftCardDetailsEvent) {
      Meta m = await FacilityDetailRepository().getGiftCardImagesUrl();
      List<GiftCardImage> giftCardImages = [];
      if (m.statusCode == 200) {
        jsonDecode(m.statusMsg)["response"]
            .forEach((f) => giftCardImages.add(new GiftCardImage.fromJson(f)));
        yield LoadGiftCardImageList(giftCardImageList: giftCardImages);
      } else {
        yield NoRecordsFound();
      }
    }

    if (event is GetPaymentTerms) {
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
