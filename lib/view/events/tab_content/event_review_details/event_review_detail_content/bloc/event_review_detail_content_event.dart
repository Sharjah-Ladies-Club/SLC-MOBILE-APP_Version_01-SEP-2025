import 'package:equatable/equatable.dart';
import 'package:slc/model/review_details.dart';

abstract class EventReviewDetailContentEvent extends Equatable {
  const EventReviewDetailContentEvent();
}

class OnReviewDetailSuccessEvent extends EventReviewDetailContentEvent {
  final ReviewDetails reviewDetails;

  const OnReviewDetailSuccessEvent({this.reviewDetails});

  @override
  // TODO: implement props
  List<Object> get props => [reviewDetails];
}
