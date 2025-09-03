abstract class FacilityGroupEvent {
  const FacilityGroupEvent();
}

class GetFacilityGroupList extends FacilityGroupEvent {
  List<Object> get props => null;
}

class RefreshGetFacilityGroupList extends FacilityGroupEvent {
  List<Object> get props => null;
}

class FacilityGroupLoad extends FacilityGroupEvent {
  List<Object> get props => null;
}

class FacilityGroupSelected extends FacilityGroupEvent {
  final int selectedFacilityGroupId;

  const FacilityGroupSelected({this.selectedFacilityGroupId});

  List<Object> get props => [selectedFacilityGroupId];
}
