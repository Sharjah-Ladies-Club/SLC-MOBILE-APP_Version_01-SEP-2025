import 'package:equatable/equatable.dart';

abstract class FacilityDetailPackagesEvent extends Equatable {
  const FacilityDetailPackagesEvent();
}

class GetFacilityServiceDetails extends FacilityDetailPackagesEvent {
  final int facilityId;
  final int facilityMenuId;

  GetFacilityServiceDetails({this.facilityId, this.facilityMenuId});

  @override
  // TODO: implement props
  List<Object> get props => null;
}
