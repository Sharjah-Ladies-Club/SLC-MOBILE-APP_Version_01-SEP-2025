import 'package:equatable/equatable.dart';
import 'package:slc/model/event_review_question_details.dart';
import 'package:slc/model/review_feed_back_request.dart';

abstract class EventWriteReviewContentEvent extends Equatable {
  const EventWriteReviewContentEvent();
}

class OnQuestionSuccessEvent extends EventWriteReviewContentEvent {
  final EventReviewQuestion eventReviewQuestion;

  const OnQuestionSuccessEvent({this.eventReviewQuestion});

  @override
  // TODO: implement props
  List<Object> get props => [eventReviewQuestion];
}

class EventSaveWriteReview extends EventWriteReviewContentEvent {
  final ReviewFeedBackRequest reviewFeedBackRequest;

  const EventSaveWriteReview({this.reviewFeedBackRequest});

  @override
  // TODO: implement props
  List<Object> get props => [reviewFeedBackRequest];
}

class SelectedReviewDetailsQuestionEvent extends EventWriteReviewContentEvent {
  final int smilyPosition;
  final int cardPosition;

  const SelectedReviewDetailsQuestionEvent(
      {this.smilyPosition, this.cardPosition});

  @override
  // TODO: implement props
  List<Object> get props => [smilyPosition];
}
