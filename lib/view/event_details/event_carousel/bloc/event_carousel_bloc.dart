import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/base_response.dart';
import 'package:slc/model/event_detail_response.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/view/event_details/bloc/bloc.dart';

import './bloc.dart';

class EventCarouselBloc extends Bloc<EventCarouselEvent, EventCarouselState> {
  final EventDetailsBloc eventDetailsBloc;

  EventCarouselBloc({@required this.eventDetailsBloc}) : super(null);

  EventCarouselState get initialState => InitialEventCarouselState();

  Stream<EventCarouselState> mapEventToState(
    EventCarouselEvent event,
  ) async* {
    if (event is GetEventDetailsEvent) {
      eventDetailsBloc.add(ShowEventDetailPageProgressBarEvent());
      Meta m = await EventRepository().getOnlineEventDetails(event.eventId);
      if (m.statusCode == 200) {
        BaseResponse baseResponse =
            BaseResponse.fromJson(jsonDecode(m.statusMsg));
        EventDetailResponse eventDetailResponse =
            EventDetailResponse.fromJson(baseResponse.response);
        yield LoadEventDetails(eventDetailResponse: eventDetailResponse);
        eventDetailsBloc.add(HideEventDetailPageProgressBarEvent());
      } else {
        eventDetailsBloc.add(EventDetailOnFailureEvent(error: m.statusMsg));
      }
    }
  }
}
