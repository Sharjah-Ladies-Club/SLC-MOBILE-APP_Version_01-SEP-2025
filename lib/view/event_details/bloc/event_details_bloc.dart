import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class EventDetailsBloc extends Bloc<EventDetailsEvent, EventDetailsState> {
  EventDetailsBloc() : super(null);

  EventDetailsState get initialState => InitialEventDetailsState();

  Stream<EventDetailsState> mapEventToState(
    EventDetailsEvent event,
  ) async* {
    if (event is ShowEventDetailPageProgressBarEvent) {
      yield ShowEventDetailProgressBarState();
    } else if (event is HideEventDetailPageProgressBarEvent) {
      yield HideEventDetailProgressBarState();
    } else if (event is EventDetailOnFailureEvent) {
      yield EventDetailOnFailureState(error: event.error);
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is RetryEventDetailsPageEvent) {
      yield InitialEventDetailsState();
      yield ReTryingEventDetailsPageState();
    }
  }
}
