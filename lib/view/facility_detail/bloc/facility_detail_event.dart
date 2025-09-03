import 'package:equatable/equatable.dart';

abstract class FacilityDetailEvent extends Equatable {
  const FacilityDetailEvent();
}

class FetchFacilityDetailsEvent extends FacilityDetailEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowFacilityDetailProgressBar extends FacilityDetailEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideFacilityDetailProgressBar extends FacilityDetailEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FacilityDetailOnFailure extends FacilityDetailEvent {
  final String error;

  const FacilityDetailOnFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class BeachPageEvent extends FacilityDetailEvent {
  final int facilityId;

  const BeachPageEvent({this.facilityId});

  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class ErrorDialogEvent extends FacilityDetailEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class FacilityDetailsInitialEvent extends FacilityDetailEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class FacilityDetailRefreshEvent extends FacilityDetailEvent {
  final int facilityId;
  const FacilityDetailRefreshEvent({this.facilityId});
  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}

class FacilityDetailCloseEvent extends FacilityDetailEvent {
  final bool isClosed;
  const FacilityDetailCloseEvent({this.isClosed});
  @override
  // TODO: implement props
  List<Object> get props => [isClosed];
}

class FitnessPageEvent extends FacilityDetailEvent {
  final int facilityId;
  const FitnessPageEvent({this.facilityId});
  @override
  // TODO: implement props
  List<Object> get props => [facilityId];
}
