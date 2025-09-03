import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/event_review_question_details.dart';

abstract class EventReviewWriteContentState {
  const EventReviewWriteContentState();
}

class InitialEventReviewWriteState extends EventReviewWriteContentState {
  List<Object> get props => [];
}

class ShowReviewWriteProgressBarState extends EventReviewWriteContentState {
  // TODO: implement props
  List<Object> get props => null;
}

class HideReviewWriteProgressBarState extends EventReviewWriteContentState {
  // TODO: implement props
  List<Object> get props => null;
}

class LoadReviewWrite extends EventReviewWriteContentState {
  final EventParticipantResponse response;
  final List<EventPriceCategory> eventPricingCategoryList;

  const LoadReviewWrite({this.response, this.eventPricingCategoryList});

  // TODO: implement props
  List<Object> get props => null;
}

class OnFailureReviewWriteState extends EventReviewWriteContentState {
  final String error;

  const OnFailureReviewWriteState({this.error});

  // TODO: implement props
  List<Object> get props => [error];
}

class OnQuestionLoadSuccess extends EventReviewWriteContentState {
  final EventReviewQuestion eventReviewQuestion;

  const OnQuestionLoadSuccess({this.eventReviewQuestion});

  // TODO: implement props
  List<Object> get props => [eventReviewQuestion];
}

class OnWriteReviewSuccess extends EventReviewWriteContentState {
  // TODO: implement props
  List<Object> get props => null;
}

class SelectedReviewDetailsQuestionState extends EventReviewWriteContentState {
  final int smilyPosition;
  final int cardPosition;

  const SelectedReviewDetailsQuestionState(
      {this.smilyPosition, this.cardPosition});

  // TODO: implement props
  List<Object> get props => [smilyPosition];
}
