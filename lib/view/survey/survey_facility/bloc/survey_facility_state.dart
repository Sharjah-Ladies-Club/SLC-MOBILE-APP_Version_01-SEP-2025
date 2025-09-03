import 'package:slc/model/facility_response.dart';

abstract class SurveyFacilityState {
  const SurveyFacilityState();
}

class InitialSurveyFacilityState extends SurveyFacilityState {
  List<Object> get props => [];
}

class UpdateSurveyFacilityState extends SurveyFacilityState {
  final List<FacilityResponse> facilityResponseList;

  const UpdateSurveyFacilityState({this.facilityResponseList});

  List<Object> get props => [facilityResponseList];
}
