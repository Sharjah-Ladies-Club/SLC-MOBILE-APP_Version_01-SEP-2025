import 'package:slc/model/event_list_response.dart';
import 'package:slc/model/event_review_list_detail.dart';

abstract class TabContentState {
  const TabContentState();
}

class InitialTabContentState extends TabContentState {
  List<Object> get props => [];
}

class EventListLoaded extends TabContentState {
  final List<EventListResponse> eventListResponse;

  const EventListLoaded({this.eventListResponse});

  List<Object> get props => null;
}

class ReviewListLoaded extends TabContentState {
  final List<ReviewListDetails> reviewListDetails;

  const ReviewListLoaded({this.reviewListDetails});

  List<Object> get props => null;
}

class DataLoading extends TabContentState {
  List<Object> get props => null;
}
