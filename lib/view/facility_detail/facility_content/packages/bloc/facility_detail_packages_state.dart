import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_item_response.dart';

abstract class FacilityDetailPackagesState extends Equatable {
  const FacilityDetailPackagesState();
}

class InitialFacilityDetailServiceState extends FacilityDetailPackagesState {
  @override
  List<Object> get props => [];
}

class LoadingFacilityService extends FacilityDetailPackagesState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadedFacilityService extends FacilityDetailPackagesState {
  final List<FacilityDetailItem> facilityItemList;

  const LoadedFacilityService(this.facilityItemList);

  @override
  List<Object> get props => [facilityItemList];
}
