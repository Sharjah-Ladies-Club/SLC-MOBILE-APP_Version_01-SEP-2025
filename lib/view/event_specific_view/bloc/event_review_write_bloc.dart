import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';

import 'event_review_write_event.dart';
import 'event_review_write_state.dart';

class EventReviewWriteBloc
    extends Bloc<EventWriteReviewEvent, EventReviewWriteState> {
  EventReviewWriteBloc(EventReviewWriteState initialState)
      : super(initialState);

  EventReviewWriteState get initialState => InitialEventReviewWriteState();

  Stream<EventReviewWriteState> mapEventToState(
    EventWriteReviewEvent event,
  ) async* {
    if (event is ShowEventWriteReviewProgressBarEvent) {
      yield ShowReviewWriteProgressBarState();
    } else if (event is HideEventWriteReviewProgressBarEvent) {
      yield HideReviewWriteProgressBarState();
    } else if (event is OnFailureEvent) {
      yield OnFailureReviewWriteState(error: event.error);
    } else if (event is OnWriteReviewSuccessEvent) {
      SPUtil.putBool('reviewed', false);
      yield OnWriteReviewSuccessState();
    } else if (event is OnEventListLoadEvent) {
      yield OnEventListLoadState(
          eventReviewQuestion: event.eventReviewQuestion);
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    }
  }
}
