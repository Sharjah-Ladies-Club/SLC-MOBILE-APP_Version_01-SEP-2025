import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(null);

  EventsState get initialState => InitialEventsState();

  Stream<EventsState> mapEventToState(
    EventsEvent event,
  ) async* {
    if (event is ShowEventProgressBarEvent) {
      yield ShowEventProgressBarState();
    } else if (event is HideEventProgressBarEvent) {
      yield HideEventProgressBarState();
    } else if (event is EventOnFailureEvent) {
      yield OnFailureEventState(error: event.error);
    } else if (event is RefreshEvent) {
      yield RefreshState();
    } else if (event is SilentRefreshEvent) {
      yield SilentRefreshState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    }
  }
}
