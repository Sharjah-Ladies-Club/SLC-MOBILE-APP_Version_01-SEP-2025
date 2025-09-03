import 'package:equatable/equatable.dart';
import 'package:slc/model/review_details.dart';

abstract class EventReviewDetailContentState extends Equatable {
  const EventReviewDetailContentState();
}

class InitialEventReviewWriteState extends EventReviewDetailContentState {
  @override
  List<Object> get props => [];
}

class OnReviewDetailLoadSuccess extends EventReviewDetailContentState {
  final ReviewDetails reviewDetails;

  const OnReviewDetailLoadSuccess({this.reviewDetails});

  @override
  List<Object> get props => [reviewDetails];
}
