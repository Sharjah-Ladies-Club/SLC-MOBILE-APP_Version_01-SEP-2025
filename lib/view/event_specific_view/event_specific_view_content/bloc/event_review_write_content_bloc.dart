import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/view/event_specific_view/bloc/event_review_write_bloc.dart';
import 'package:slc/view/event_specific_view/bloc/event_review_write_event.dart';

import 'bloc.dart';

class EventReviewWriteContentBloc
    extends Bloc<EventWriteReviewContentEvent, EventReviewWriteContentState> {
  EventReviewWriteBloc eventReviewWriteBloc;

  EventReviewWriteContentBloc({this.eventReviewWriteBloc}) : super(null);

  EventReviewWriteContentState get initialState =>
      InitialEventReviewWriteState();

  Stream<EventReviewWriteContentState> mapEventToState(
    EventWriteReviewContentEvent event,
  ) async* {
    if (event is OnQuestionSuccessEvent) {
      yield OnQuestionLoadSuccess(
          eventReviewQuestion: event.eventReviewQuestion);
      eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
    } else if (event is EventSaveWriteReview) {
      eventReviewWriteBloc.add(ShowEventWriteReviewProgressBarEvent());
      Meta m = await EventRepository()
          .saveEventReviewForm(event.reviewFeedBackRequest);
      if (m.statusCode == 200) {
        eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
        eventReviewWriteBloc.add(OnWriteReviewSuccessEvent());
      } else {
        eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
        eventReviewWriteBloc.add(OnFailureEvent(error: m.statusMsg));
      }
    } else if (event is SelectedReviewDetailsQuestionEvent) {
      yield SelectedReviewDetailsQuestionState(
          smilyPosition: event.smilyPosition, cardPosition: event.cardPosition);
    }
  }
}
