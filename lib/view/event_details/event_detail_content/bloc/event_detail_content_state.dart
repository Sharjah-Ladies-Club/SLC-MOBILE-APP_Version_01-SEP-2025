import 'package:equatable/equatable.dart';
import 'package:slc/model/event_detail_response.dart';

abstract class EventDetailContentState extends Equatable {
  const EventDetailContentState();
}

class InitialEventDetailContentState extends EventDetailContentState {
  @override
  List<Object> get props => [];
}

class LoadEventDetailContentState extends EventDetailContentState {
  final EventDetailResponse eventDetailResponse;

  const LoadEventDetailContentState({this.eventDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [eventDetailResponse];
}
