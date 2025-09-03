import 'package:meta/meta.dart';

abstract class FacilityEvent {
  const FacilityEvent();
}

class FacilityLoading extends FacilityEvent {
  // TODO: implement props
  List<Object> get props => null;
}

class RefreshFacility extends FacilityEvent {
  final int selectedFacilityGroupId;

  const RefreshFacility({@required this.selectedFacilityGroupId});

  List<Object> get props => [selectedFacilityGroupId];
}

class FacilityLoaded extends FacilityEvent {
  final int selectedFacilityId;

  const FacilityLoaded({@required this.selectedFacilityId});

  List<Object> get props => [selectedFacilityId];
}

class FacilitySelected extends FacilityEvent {
  final int selectedFacilityGroupId;

  const FacilitySelected({@required this.selectedFacilityGroupId});

  List<Object> get props => [selectedFacilityGroupId];
}
