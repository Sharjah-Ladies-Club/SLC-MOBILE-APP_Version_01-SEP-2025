import 'package:equatable/equatable.dart';

abstract class TableBookingEvent extends Equatable {
  const TableBookingEvent();
}

class GetItemDetailsEvent extends TableBookingEvent {
  final int facilityId;
  final int facilityItemGroupId;

  const GetItemDetailsEvent({this.facilityId, this.facilityItemGroupId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId, facilityItemGroupId];
}

class GetOrderStatusEvent extends TableBookingEvent {
  final String merchantReferenceNo;

  const GetOrderStatusEvent({this.merchantReferenceNo});

  @override
  // TODO: implement props
  List<Object> get props => [merchantReferenceNo];
}
