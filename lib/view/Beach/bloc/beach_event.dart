import 'package:equatable/equatable.dart';

abstract class BeachEvent extends Equatable {
  const BeachEvent();
}

class GetItemDetailsEvent extends BeachEvent {
  final int facilityId;
  final int facilityItemGroupId;

  const GetItemDetailsEvent({this.facilityId, this.facilityItemGroupId});

  // TODO: implement props
  List<Object> get props => [facilityId, facilityItemGroupId];
}

class GetPaymentTerms extends BeachEvent {
  final int facilityId;

  const GetPaymentTerms({this.facilityId});

  // TODO: implement props
  List<Object> get props => [facilityId];
}

class GetOrderStatusEvent extends BeachEvent {
  final String merchantReferenceNo;

  const GetOrderStatusEvent({this.merchantReferenceNo});

  // TODO: implement props
  List<Object> get props => [merchantReferenceNo];
}
