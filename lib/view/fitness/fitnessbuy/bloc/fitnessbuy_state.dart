import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/model/payment_terms_response.dart';

abstract class FitnessBuyState extends Equatable {
  const FitnessBuyState();
}

class InitialFitnessBuyState extends FitnessBuyState {
  @override
  List<Object> get props => [];
}

class LoadFitnessItemList extends FitnessBuyState {
  final List<FacilityDetailItem> fitnessItems;

  const LoadFitnessItemList({this.fitnessItems});

  @override
  // TODO: implement props
  List<Object> get props => [LoadFitnessItemList];
}

class InvalidQRCode extends FitnessBuyState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ShopClosed extends FitnessBuyState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadDiscountList extends FitnessBuyState {
  final List<BillDiscounts> billDiscounts;

  const LoadDiscountList({this.billDiscounts});

  @override
  // TODO: implement props
  List<Object> get props => [billDiscounts];
}

class GetOrderStatusState extends FitnessBuyState {
  final OrderStatus orderStatus;
  const GetOrderStatusState({this.orderStatus});

  @override
  // TODO: implement props
  List<Object> get props => [orderStatus];
}

class GetPaymentTermsResult extends FitnessBuyState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  @override
  // TODO: implement props
  List<Object> get props => [paymentTerms];
}

class FitnessBuyEnquirySaveState extends FitnessBuyState {
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
