import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:slc/model/facility_response.dart';

abstract class FacilityState extends Equatable {
  const FacilityState();
}

class FacilityLoadingState extends FacilityState {
  @override
  List<Object> get props => [];
}

class FacilityLoadedState extends FacilityState {
  final List<FacilityResponse> facilityResponseList;

  const FacilityLoadedState({@required this.facilityResponseList});

  @override
  // TODO: implement props
  List<Object> get props => [facilityResponseList];
}

class FacilityOnFailure extends FacilityState {
  final String error;

  const FacilityOnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
