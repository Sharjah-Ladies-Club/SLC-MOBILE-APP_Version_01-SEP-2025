import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class EventDetailContentBloc
    extends Bloc<EventDetailContentEvent, EventDetailContentState> {
  EventDetailContentBloc(EventDetailContentState initialState)
      : super(initialState);

  EventDetailContentState get initialState => InitialEventDetailContentState();

  Stream<EventDetailContentState> mapEventToState(
    EventDetailContentEvent event,
  ) async* {
    if (event is LoadEventDetailContentEvent) {
      yield LoadEventDetailContentState(
          eventDetailResponse: event.eventDetailResponse);
    }
  }
}
