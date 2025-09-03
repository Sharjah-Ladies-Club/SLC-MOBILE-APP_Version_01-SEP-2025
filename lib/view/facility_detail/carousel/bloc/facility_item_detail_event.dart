import 'package:equatable/equatable.dart';

abstract class FacilityItemDetailEvent extends Equatable {
  const FacilityItemDetailEvent();
}

class GetFacilityItemDetails extends FacilityItemDetailEvent {
  final int facilityId;

  GetFacilityItemDetails({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class ReloadFacilityItemDetails extends FacilityItemDetailEvent {
  final int facilityId;

  ReloadFacilityItemDetails({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
