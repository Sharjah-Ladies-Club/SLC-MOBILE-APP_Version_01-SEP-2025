import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/view/events/tab_content/event_review_details/bloc/event_review_details_bloc.dart';
import 'package:slc/view/events/tab_content/event_review_details/bloc/event_review_details_event.dart';

import 'bloc.dart';

class EventReviewDetailContentBloc
    extends Bloc<EventReviewDetailContentEvent, EventReviewDetailContentState> {
  ReviewDetailBloc reviewDetailBloc;

  EventReviewDetailContentBloc({this.reviewDetailBloc}) : super(null);

  EventReviewDetailContentState get initialState =>
      InitialEventReviewWriteState();

  Stream<EventReviewDetailContentState> mapEventToState(
    EventReviewDetailContentEvent event,
  ) async* {
    if (event is OnReviewDetailSuccessEvent) {
      yield OnReviewDetailLoadSuccess(reviewDetails: event.reviewDetails);
      reviewDetailBloc.add(HideProgressBarEvent());
    }
  }
}
