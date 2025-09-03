import 'package:equatable/equatable.dart';
import 'package:slc/model/event_detail_response.dart';

abstract class EventDetailContentEvent extends Equatable {
  const EventDetailContentEvent();
}

class LoadEventDetailContentEvent extends EventDetailContentEvent {
  final EventDetailResponse eventDetailResponse;

  const LoadEventDetailContentEvent({this.eventDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [eventDetailResponse];
}
