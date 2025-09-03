import 'package:equatable/equatable.dart';

abstract class EventCarouselEvent extends Equatable {
  const EventCarouselEvent();
}

class GetEventDetailsEvent extends EventCarouselEvent {
  final int eventId;

  const GetEventDetailsEvent({this.eventId});

  @override
  // TODO: implement props
  List<Object> get props => [eventId];
}
