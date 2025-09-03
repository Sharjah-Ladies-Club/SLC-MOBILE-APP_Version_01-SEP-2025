import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityFitnessEvent extends Equatable {
  const FacilityFitnessEvent();
}

class FetchFitnessVideoContent extends FacilityFitnessEvent {
  final int facilityId;
  // final int menuId;
  const FetchFitnessVideoContent({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [
        facilityId
        // ,menuId
      ];
}

class FetchFitnessDietContent extends FacilityFitnessEvent {
  final int facilityId;
  final String selectedDate;
  // final int menuId;
  const FetchFitnessDietContent({this.facilityId, this.selectedDate});

  @override
  // TODO: implement props
  List<Object> get props => [
        facilityId, selectedDate
        // ,menuId
      ];
}

class FetchFitnessDietSave extends FacilityFitnessEvent {
  final FitnessUserDietEntry dietEntry;
  // final int menuId;
  const FetchFitnessDietSave({this.dietEntry});

  @override
  // TODO: implement props
  List<Object> get props => [
        dietEntry // ,menuId
      ];
}
