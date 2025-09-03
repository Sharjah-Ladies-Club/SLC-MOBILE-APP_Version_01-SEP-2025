import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/giftvoucher_request.dart';
import '../../../model/payment_terms_response.dart';

abstract class RetailCartState extends Equatable {
  const RetailCartState();
}

class InitialRetailCartState extends RetailCartState {
  @override
  List<Object> get props => [];
}

class LoadRetailCartItemList extends RetailCartState {
  final RetailOrderItemsCategory retailOrderCategoryItems;
  final List<DeliveryAddress> deliveryAddresses;
  final List<DeliveryCharges> deliveryCharges;

  const LoadRetailCartItemList(
      {this.retailOrderCategoryItems,
      this.deliveryAddresses,
      this.deliveryCharges});

  @override
  // TODO: implement props
  List<Object> get props =>
      [retailOrderCategoryItems, deliveryAddresses, deliveryCharges];
}

class LoadGiftCardCategoryList extends RetailCartState {
  final GiftCardUI giftCardUI;

  const LoadGiftCardCategoryList({this.giftCardUI});

  @override
  // TODO: implement props
  List<Object> get props => [giftCardUI];
}

class LoadGiftCardImageList extends RetailCartState {
  final List<GiftCardImage> giftCardImageList;

  const LoadGiftCardImageList({this.giftCardImageList});

  @override
  // TODO: implement props
  List<Object> get props => [giftCardImageList];
}

class InvalidQRCode extends RetailCartState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NoRecordsFound extends RetailCartState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetPaymentTermsResult extends RetailCartState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
