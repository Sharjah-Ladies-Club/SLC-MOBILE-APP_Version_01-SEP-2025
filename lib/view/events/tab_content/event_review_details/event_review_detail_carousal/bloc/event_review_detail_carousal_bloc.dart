import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/review_details.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/view/events/tab_content/event_review_details/bloc/event_review_details_bloc.dart';
import 'package:slc/view/events/tab_content/event_review_details/bloc/event_review_details_event.dart';

import 'bloc.dart';

class EventReviewDetailsCarousalBloc extends Bloc<
    EventReviewDetailCarousalEvent, EventReviewDetailCarousalState> {
  ReviewDetailBloc reviewDetailBloc;

  EventReviewDetailsCarousalBloc({this.reviewDetailBloc}) : super(null);

  EventReviewDetailCarousalState get initialState =>
      InitialEventReviewWriteState();

  Stream<EventReviewDetailCarousalState> mapEventToState(
    EventReviewDetailCarousalEvent event,
  ) async* {
    if (event is GeneralList) {
      try {
        reviewDetailBloc.add(ShowProgressBarEvent());
        Meta m = await EventRepository().getTopReviewDetails(event.eventId);
        if (m.statusCode == 200) {
          reviewDetailBloc.add(HideProgressBarEvent());
          ReviewDetails reviewDetails = new ReviewDetails();
          reviewDetails =
              ReviewDetails.fromJson(jsonDecode(m.statusMsg)['response']);
          yield OnEventReviewListLoadSuccessState(reviewDetails: reviewDetails);
        } else {
          reviewDetailBloc.add(HideProgressBarEvent());
          reviewDetailBloc.add(OnFailedEvent(error: m.statusMsg));
        }
      } catch (error) {
        reviewDetailBloc.add(HideProgressBarEvent());
        reviewDetailBloc.add(OnFailedEvent(error: error));
      }
    }
  }
}
