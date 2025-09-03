import 'package:equatable/equatable.dart';

abstract class EventReviewDetailCarousalEvent extends Equatable {
  const EventReviewDetailCarousalEvent();
}

class GeneralList extends EventReviewDetailCarousalEvent {
  final int eventId;

  const GeneralList({this.eventId});

  @override
  List<Object> get props => [eventId];
}
