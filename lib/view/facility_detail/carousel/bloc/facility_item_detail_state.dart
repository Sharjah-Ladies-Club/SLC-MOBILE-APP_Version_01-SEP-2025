import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityItemDetailState extends Equatable {
  const FacilityItemDetailState();
}

class InitialFacilityItemDetailState extends FacilityItemDetailState {
  @override
  List<Object> get props => [];
}

class LoadingFacilityItemDetails extends FacilityItemDetailState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadedFacilityItemDetails extends FacilityItemDetailState {
  final FacilityDetailResponse facilityDetailResponse;

  const LoadedFacilityItemDetails({this.facilityDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [facilityDetailResponse];
}

class ReLoadedFacilityItemDetails extends FacilityItemDetailState {
  final FacilityDetailResponse facilityDetailResponse;

  const ReLoadedFacilityItemDetails({this.facilityDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [facilityDetailResponse];
}
