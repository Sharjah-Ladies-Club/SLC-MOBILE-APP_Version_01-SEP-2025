import 'package:equatable/equatable.dart';

abstract class RetailEvent extends Equatable {
  const RetailEvent();
}

class GetItemDetailsEvent extends RetailEvent {
  final int facilityId;
  final String retailItemSetId;

  const GetItemDetailsEvent({this.facilityId, this.retailItemSetId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, retailItemSetId];
}

class GetDiscountEvent extends RetailEvent {
  final int facilityId;
  final double billAmount;

  const GetDiscountEvent({this.facilityId, this.billAmount});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, billAmount];
}

class GetOrderStatusEvent extends RetailEvent {
  final String merchantReferenceNo;

  const GetOrderStatusEvent({this.merchantReferenceNo});

  @override
  // TODO: implement props
  List<Object> get props => [merchantReferenceNo];
}

class GetPaymentTerms extends RetailEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
