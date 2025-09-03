import 'package:slc/model/event_list_response.dart';

abstract class TabContentEvent {
  const TabContentEvent();
}

class RefreshShowProgressBar extends TabContentEvent {
  List<Object> get props => null;
}

class GetEventList extends TabContentEvent {
  List<Object> get props => null;
}

class GetSilentEventList extends TabContentEvent {
  List<Object> get props => null;
}

class GetReviewList extends TabContentEvent {
  List<Object> get props => null;
}

class EventRefresh extends TabContentEvent {
  final List<EventListResponse> eventListResponse;

  const EventRefresh({this.eventListResponse});

  List<Object> get props => [eventListResponse];
}

class GetRefreshEventList extends TabContentEvent {
  List<Object> get props => null;
}

class GetSilentRefreshEventList extends TabContentEvent {
  List<Object> get props => null;
}

class GetRefreshReviewList extends TabContentEvent {
  List<Object> get props => null;
}

class GetSilentRefreshReviewList extends TabContentEvent {
  List<Object> get props => null;
}
