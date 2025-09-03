import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_item.dart';
import 'package:slc/model/order_status_response.dart';

abstract class TableBookingState extends Equatable {
  const TableBookingState();
}

class InitialTableBookingState extends TableBookingState {
  @override
  List<Object> get props => [];
}

class LoadTableBookingItemList extends TableBookingState {
  final List<FacilityItem> facilityItems;

  const LoadTableBookingItemList({this.facilityItems});

  @override
  // TODO: implement props
  List<Object> get props => [facilityItems];
}

class GetOrderStatusState extends TableBookingState {
  final OrderStatus orderStatus;

  const GetOrderStatusState({this.orderStatus});

  @override
  // TODO: implement props
  List<Object> get props => [orderStatus];
}
