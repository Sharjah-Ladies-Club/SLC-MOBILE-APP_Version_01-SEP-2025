import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityDetailState extends Equatable {
  const FacilityDetailState();
}

class InitialFacilityDetailState extends FacilityDetailState {
  @override
  List<Object> get props => [];
}

class ShowFacilityDetailProgressBarState extends FacilityDetailState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideFacilityDetailProgressBarState extends FacilityDetailState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FacilityDetailsOnFailure extends FacilityDetailState {
  final String error;

  const FacilityDetailsOnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class BeachPageState extends FacilityDetailState {
  final int facilityId;

  const BeachPageState({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class FitnessPageState extends FacilityDetailState {
  final int facilityId;
  const FitnessPageState({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class ErrorDialogState extends FacilityDetailState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class FacilityDetailRefreshState extends FacilityDetailState {
  final FacilityDetailResponse facilityDetailResponse;
  const FacilityDetailRefreshState({this.facilityDetailResponse});
  @override
  // TODO: implement props
  List<Object> get props => [facilityDetailResponse];
}

class FacilityDetailCloseState extends FacilityDetailState {
  final bool isClosed;
  const FacilityDetailCloseState({this.isClosed});
  @override
  // TODO: implement props
  List<Object> get props => [isClosed];
}
