import 'package:equatable/equatable.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/event_review_question_details.dart';

abstract class EventReviewWriteCarousalState extends Equatable {
  const EventReviewWriteCarousalState();
}

class InitialEventReviewWriteState extends EventReviewWriteCarousalState {
  @override
  List<Object> get props => [];
}

class LoadReviewWriteState extends EventReviewWriteCarousalState {
  final EventParticipantResponse response;
  final List<EventPriceCategory> eventPricingCategoryList;

  const LoadReviewWriteState({this.response, this.eventPricingCategoryList});

  @override
  List<Object> get props => null;
}

class OnQuestionLoadSuccessState extends EventReviewWriteCarousalState {
  final EventReviewQuestion eventReviewQuestion;

  const OnQuestionLoadSuccessState({this.eventReviewQuestion});

  @override
  List<Object> get props => [eventReviewQuestion];
}
