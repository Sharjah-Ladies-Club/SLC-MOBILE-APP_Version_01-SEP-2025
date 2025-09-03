import 'package:equatable/equatable.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/review_details.dart';

abstract class EventReviewDetailCarousalState extends Equatable {
  const EventReviewDetailCarousalState();
}

class InitialEventReviewWriteState extends EventReviewDetailCarousalState {
  @override
  List<Object> get props => [];
}

class LoadReviewWriteState extends EventReviewDetailCarousalState {
  final EventParticipantResponse response;
  final List<EventPriceCategory> eventPricingCategoryList;

  const LoadReviewWriteState({this.response, this.eventPricingCategoryList});

  @override
  List<Object> get props => null;
}

class OnEventReviewListLoadSuccessState extends EventReviewDetailCarousalState {
  final ReviewDetails reviewDetails;

  const OnEventReviewListLoadSuccessState({this.reviewDetails});

  @override
  List<Object> get props => [reviewDetails];
}
