import 'package:equatable/equatable.dart';

abstract class RetailCartEvent extends Equatable {
  const RetailCartEvent();
}

class GetCartItemDetailsEvent extends RetailCartEvent {
  final int facilityId;
  final int retailItemSetId;

  const GetCartItemDetailsEvent({this.facilityId, this.retailItemSetId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, retailItemSetId];
}

class GetGiftCardCategoryDetailsEvent extends RetailCartEvent {
  final int facilityId;

  const GetGiftCardCategoryDetailsEvent({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class GetGiftCardDetailsEvent extends RetailCartEvent {
  final int facilityId;

  const GetGiftCardDetailsEvent({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class GetPaymentTerms extends RetailCartEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
