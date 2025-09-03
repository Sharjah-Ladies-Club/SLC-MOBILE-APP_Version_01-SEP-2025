import 'package:equatable/equatable.dart';
import 'package:slc/model/event_detail_response.dart';

abstract class EventCarouselState extends Equatable {
  const EventCarouselState();
}

class InitialEventCarouselState extends EventCarouselState {
  @override
  List<Object> get props => [];
}

class LoadEventDetails extends EventCarouselState {
  final EventDetailResponse eventDetailResponse;

  const LoadEventDetails({this.eventDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [eventDetailResponse];
}
