import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/model/payment_terms_response.dart';

abstract class FacilityBuyState extends Equatable {
  const FacilityBuyState();
}

class InitialFitnessBuyState extends FacilityBuyState {
  @override
  List<Object> get props => [];
}

class LoadFitnessItemList extends FacilityBuyState {
  final List<FacilityDetailItem> fitnessItems;

  const LoadFitnessItemList({this.fitnessItems});

  @override
  // TODO: implement props
  List<Object> get props => [LoadFitnessItemList];
}

class InvalidQRCode extends FacilityBuyState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ShopClosed extends FacilityBuyState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDiscountList extends FacilityBuyState {
  final List<BillDiscounts> billDiscounts;

  const LoadDiscountList({this.billDiscounts});

  @override
  // TODO: implement props
  List<Object> get props => [billDiscounts];
}

class GetOrderStatusState extends FacilityBuyState {
  final OrderStatus orderStatus;
  const GetOrderStatusState({this.orderStatus});

  @override
  // TODO: implement props
  List<Object> get props => [orderStatus];
}

class GetPaymentTermsResult extends FacilityBuyState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}

class FitnessBuyEnquirySaveState extends FacilityBuyState {
  final String error;
  final String message;
  final bool proceedToPay;
  final FacilityItems facilityItem;

  const FitnessBuyEnquirySaveState(
      {this.error, this.message, this.proceedToPay, this.facilityItem});

  @override
  // TODO: implement props
  List<Object> get props => [error, message, proceedToPay];
}
