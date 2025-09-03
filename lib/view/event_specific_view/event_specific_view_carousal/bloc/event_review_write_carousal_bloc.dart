import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/event_review_question_details.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/view/event_specific_view/bloc/event_review_write_bloc.dart';
import 'package:slc/view/event_specific_view/bloc/event_review_write_event.dart';

import 'bloc.dart';

class EventReviewWriteCarousalBloc
    extends Bloc<EventWriteReviewCarousalEvent, EventReviewWriteCarousalState> {
  EventReviewWriteBloc eventReviewWriteBloc;

  EventReviewWriteCarousalBloc({this.eventReviewWriteBloc}) : super(null);

  EventReviewWriteCarousalState get initialState =>
      InitialEventReviewWriteState();

  Stream<EventReviewWriteCarousalState> mapEventToState(
    EventWriteReviewCarousalEvent event,
  ) async* {
    if (event is GetEventWriteReviewQuestions) {
      try {
        eventReviewWriteBloc.add(ShowEventWriteReviewProgressBarEvent());
        Meta m = await EventRepository().getEventReviewWriteList(event.eventId);
        if (m.statusCode == 200) {
          //eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
          EventReviewQuestion eventReviewQuestion =
              EventReviewQuestion.fromJson(jsonDecode(m.statusMsg)['response']);
          eventReviewWriteBloc.add(
              OnEventListLoadEvent(eventReviewQuestion: eventReviewQuestion));
          yield OnQuestionLoadSuccessState(
              eventReviewQuestion: eventReviewQuestion);
        } else {
          eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
          eventReviewWriteBloc.add(OnFailureEvent(error: m.statusMsg));
        }
      } catch (error) {
        eventReviewWriteBloc.add(HideEventWriteReviewProgressBarEvent());
        eventReviewWriteBloc.add(OnFailureEvent(error: error));
      }
    }
  }
}
