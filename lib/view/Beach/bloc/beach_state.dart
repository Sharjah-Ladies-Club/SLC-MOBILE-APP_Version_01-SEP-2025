import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';
import 'package:slc/model/payment_terms_response.dart';

abstract class BeachState extends Equatable {
  const BeachState();
}

class InitialBeachState extends BeachState {
  List<Object> get props => [];
}

class LoadBeachItemList extends BeachState {
  final List<FacilityItem> facilityItems;

  const LoadBeachItemList({this.facilityItems});

  // TODO: implement props
  List<Object> get props => [facilityItems];
}

class GetOrderStatusState extends BeachState {
  final OrderStatus orderStatus;

  const GetOrderStatusState({this.orderStatus});

  // TODO: implement props
  List<Object> get props => [orderStatus];
}

class GetPaymentTermsResult extends BeachState {
  final PaymentTerms paymentTerms;
  const GetPaymentTermsResult({this.paymentTerms});

  // TODO: implement props
  List<Object> get props => [paymentTerms];
}
