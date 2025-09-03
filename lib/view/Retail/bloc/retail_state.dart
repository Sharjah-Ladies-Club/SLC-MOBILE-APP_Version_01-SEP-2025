import 'package:equatable/equatable.dart';
// import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';

import '../../../model/payment_terms_response.dart';

abstract class RetailState extends Equatable {
  const RetailState();
}

class InitialRetailState extends RetailState {
  @override
  List<Object> get props => [];
}

class LoadRetailItemList extends RetailState {
  final RetailOrderItemsCategory retailOrderCategoryItems;

  const LoadRetailItemList({this.retailOrderCategoryItems});

  @override
  // TODO: implement props
  List<Object> get props => [retailOrderCategoryItems];
}

class InvalidQRCode extends RetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ShopClosed extends RetailState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDiscountList extends RetailState {
  final List<BillDiscounts> billDiscounts;

  const LoadDiscountList({this.billDiscounts});

  @override
  // TODO: implement props
  List<Object> get props => [billDiscounts];
}

class GetOrderStatusState extends RetailState {
  final OrderStatus orderStatus;
  const GetOrderStatusState({this.orderStatus});

  @override
  // TODO: implement props
  List<Object> get props => [orderStatus];
}

class GetPaymentTermsResult extends RetailState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
