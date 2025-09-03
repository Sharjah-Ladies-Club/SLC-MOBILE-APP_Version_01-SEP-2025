import 'package:equatable/equatable.dart';
import 'package:slc/model/event_price_category.dart';

abstract class EventWriteReviewCarousalEvent extends Equatable {
  const EventWriteReviewCarousalEvent();
}

class GetEventWriteReviewQuestions extends EventWriteReviewCarousalEvent {
  final int eventId;
  final List<EventPriceCategory> eventPriceCategoryList;

  const GetEventWriteReviewQuestions(
      {this.eventId, this.eventPriceCategoryList});

  @override
  List<Object> get props => [eventId, eventPriceCategoryList];
}
