import 'package:equatable/equatable.dart';
import 'package:slc/model/carousel_response.dart';
import 'package:slc/model/facility_group_response.dart';
import 'package:slc/model/facility_response.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class InitialHomeState extends HomeState {
  final List<FacilityGroupResponse> facilityGroupResponseList;
  final List<FacilityResponse> facilityResponseList;

  const InitialHomeState(
      {this.facilityGroupResponseList, this.facilityResponseList});

  @override
  // TODO: implement props
  List<Object> get props => [facilityGroupResponseList, facilityResponseList];
}

class ShowProgressBar extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class BindData extends HomeState {
  final List<FacilityGroupResponse> facilityGroupResponseList;
  final List<FacilityResponse> facilityResponseList;

  const BindData({this.facilityGroupResponseList, this.facilityResponseList});

  @override
  List<Object> get props => [facilityGroupResponseList, facilityResponseList];
}

class OnFailure extends HomeState {
  final String error;

  const OnFailure(this.error);

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class BindFacilityData extends HomeState {
  final List<FacilityResponse> facilityResponseList;

  const BindFacilityData({this.facilityResponseList});

  @override
  // TODO: implement props
  List<Object> get props => [facilityResponseList];
}

class ReTryingState extends HomeState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogState extends HomeState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class MarketingQuestionLoadedState extends HomeState {
  final List<MarketingQuestion> marketingQuesitons;

  const MarketingQuestionLoadedState({this.marketingQuesitons});

  @override
  List<Object> get props => [marketingQuesitons];
}
