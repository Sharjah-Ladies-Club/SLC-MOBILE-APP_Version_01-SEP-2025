import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/base_response.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/view/event_people_list/image_picker_provider.dart';

import 'bloc.dart';

class EventPeopleListBloc
    extends Bloc<EventPeopleListEvent, EventPeopleListState> {
  EventPeopleListBloc(EventPeopleListState initialState) : super(initialState);

  EventPeopleListState get initialState => InitialEventPeopleListState();

  Stream<EventPeopleListState> mapEventToState(
    EventPeopleListEvent event,
  ) async* {
    if (event is GetEventParticipantListEvent) {
      yield ShowEventPeopleListProgressBarState();
      Meta m = await EventRepository().getEventParticipantList(event.eventId);
      if (m.statusCode == 200) {
        yield HideEventPeopleListProgressBarState();
        BaseResponse baseResponse =
            BaseResponse.fromJson(jsonDecode(m.statusMsg));
        EventParticipantResponse response =
            EventParticipantResponse.fromJson(baseResponse.response);
        yield LoadPeopleList(
            response: response,
            eventPricingCategoryList: event.eventPriceCategoryList);
      } else {
        yield HideEventPeopleListProgressBarState();
        yield OnFailureEventPeopleListState(error: m.statusMsg);
      }
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is ShowImageEvent) {
      try {
        ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().getImage();
        yield ShowImageState(file: f);
        yield ShowNewImageState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is ShowImageCameraEvent) {
      try {
        ImagePickerProvider p = new ImagePickerProvider();
        File f = await EventRepository().takeImage();
        yield ShowImageCameraState(file: f);
        yield ShowNewImageCameraState(file: f);
      } catch (e) {
        print(e);
      }
    } else if (event is SaveEventTemplateEvent) {
      Meta m = await EventRepository().saveEventTemplateResults(event.request);
      if (m.statusCode == 200) {
      } else {}
    }
  }
}
