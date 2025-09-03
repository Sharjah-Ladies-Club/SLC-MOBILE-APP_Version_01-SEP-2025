import 'package:meta/meta.dart';
import 'package:slc/model/facility_group_response.dart';

abstract class FacilityGroupState {
  const FacilityGroupState();
}

class FacilityGroupLoadingState extends FacilityGroupState {
  List<Object> get props => [];
}

class FacilityGroupLoaded extends FacilityGroupState {
  final List<FacilityGroupResponse> result;

  const FacilityGroupLoaded({@required this.result});

  List<Object> get props => [result];
}

class RefreshFacilityGroupLoaded extends FacilityGroupState {
  final List<FacilityGroupResponse> result;

  const RefreshFacilityGroupLoaded({@required this.result});

  List<Object> get props => [result];
}

class FacilityGroupChanged extends FacilityGroupState {
  final int selectedId;

  const FacilityGroupChanged({this.selectedId});

  // TODO: implement props
  List<Object> get props => [];
}

class FacilityGroupOnFailure extends FacilityGroupState {
  final String error;

  const FacilityGroupOnFailure({this.error});

  // TODO: implement props
  List<Object> get props => [error];
}
