import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/event_list_response.dart';
import 'package:slc/model/event_review_list_detail.dart';
import 'package:slc/repo/event_repository.dart';
import 'package:slc/utils/integer.dart';
import 'package:slc/view/events/bloc/bloc.dart';

import './bloc.dart';

class TabContentBloc extends Bloc<TabContentEvent, TabContentState> {
  EventsBloc eventBloc;

  TabContentBloc(this.eventBloc) : super(null);

  TabContentState get initialState => InitialTabContentState();

  Stream<TabContentState> mapEventToState(
    TabContentEvent event,
  ) async* {
    if (event is GetEventList) {
      try {
        yield DataLoading();
        eventBloc.add(ShowEventProgressBarEvent());
        Meta meta = await EventRepository().getEventList();

        if (meta.statusCode == 200) {
          List<EventListResponse> eventListResponse = [];
          jsonDecode(meta.statusMsg)['response'].forEach(
              (f) => eventListResponse.add(new EventListResponse.fromJson(f)));

          List<EventListResponse> tempEventListResponse = [];
          eventListResponse.forEach((eventResponse) {
            if (eventResponse.statusId == Integer.Opened ||
                (eventResponse.statusId == Integer.Review &&
                    eventResponse.isReviewPending)) {
              tempEventListResponse.add(eventResponse);
            }
          });

          eventBloc.add(HideEventProgressBarEvent());
          //yield EventListLoaded(eventListResponse: tempEventListResponse);
          yield EventListLoaded(eventListResponse: eventListResponse);
        } else {
          eventBloc.add(HideEventProgressBarEvent());
          eventBloc.add(EventOnFailureEvent(error: meta.statusMsg));
        }
      } catch (error) {
        eventBloc.add(HideEventProgressBarEvent());
        eventBloc.add(EventOnFailureEvent(error: error));
      }
    } else if (event is GetReviewList) {
      yield DataLoading();
      eventBloc.add(ShowEventProgressBarEvent());
      Meta meta = await EventRepository().getReviewList();
      if (meta.statusCode == 200) {
        List<ReviewListDetails> reviewListDetails = [];
        jsonDecode(meta.statusMsg)['response'].forEach(
            (f) => reviewListDetails.add(new ReviewListDetails.fromJson(f)));
        yield ReviewListLoaded(reviewListDetails: reviewListDetails);
        eventBloc.add(HideEventProgressBarEvent());
      } else {
        eventBloc.add(HideEventProgressBarEvent());
        eventBloc.add(EventOnFailureEvent(error: meta.statusMsg));
      }
    } else if (event is EventRefresh) {
      yield EventListLoaded(eventListResponse: event.eventListResponse);
    } else if (event is RefreshShowProgressBar) {
      yield DataLoading();
      eventBloc.add(ShowEventProgressBarEvent());
    } else if (event is GetRefreshEventList) {
      try {
        yield DataLoading();
        eventBloc.add(ShowEventProgressBarEvent());
        Meta meta = await EventRepository().getEventList();

        if (meta.statusCode == 200) {
          List<EventListResponse> eventListResponse = [];
          jsonDecode(meta.statusMsg)['response'].forEach(
              (f) => eventListResponse.add(new EventListResponse.fromJson(f)));

          List<EventListResponse> tempEventListResponse = [];
          eventListResponse.forEach((eventResponse) {
            if (eventResponse.statusId == Integer.Opened ||
                (eventResponse.statusId == Integer.Review &&
                    eventResponse.isReviewPending)) {
              tempEventListResponse.add(eventResponse);
            }
          });

          eventBloc.add(HideEventProgressBarEvent());
          //yield EventListLoaded(eventListResponse: tempEventListResponse);
          yield EventListLoaded(eventListResponse: eventListResponse);
        } else {
          eventBloc.add(HideEventProgressBarEvent());
          eventBloc.add(EventOnFailureEvent(error: meta.statusMsg));
        }
      } catch (error) {
        eventBloc.add(HideEventProgressBarEvent());
        eventBloc.add(EventOnFailureEvent(error: error));
      }
    } else if (event is GetRefreshReviewList) {
      yield DataLoading();
      eventBloc.add(ShowEventProgressBarEvent());
      Meta meta = await EventRepository().getReviewList();
      if (meta.statusCode == 200) {
        List<ReviewListDetails> reviewListDetails = [];
        jsonDecode(meta.statusMsg)['response'].forEach(
            (f) => reviewListDetails.add(new ReviewListDetails.fromJson(f)));
        yield ReviewListLoaded(reviewListDetails: reviewListDetails);
        eventBloc.add(HideEventProgressBarEvent());
      } else {
        eventBloc.add(HideEventProgressBarEvent());
        eventBloc.add(EventOnFailureEvent(error: meta.statusMsg));
      }
    } else if (event is GetSilentRefreshEventList) {
      Meta meta = await EventRepository().getEventList();

      if (meta.statusCode == 200) {
        List<EventListResponse> eventListResponse = [];
        jsonDecode(meta.statusMsg)['response'].forEach(
            (f) => eventListResponse.add(new EventListResponse.fromJson(f)));

        List<EventListResponse> tempEventListResponse = [];
        eventListResponse.forEach((eventResponse) {
          if (eventResponse.statusId == Integer.Opened ||
              (eventResponse.statusId == Integer.Review &&
                  eventResponse.isReviewPending)) {
            tempEventListResponse.add(eventResponse);
          }
        });

        //yield EventListLoaded(eventListResponse: tempEventListResponse);
        yield EventListLoaded(eventListResponse: eventListResponse);
      }
    } else if (event is GetSilentRefreshReviewList) {
      Meta meta = await EventRepository().getReviewList();
      if (meta.statusCode == 200) {
        List<ReviewListDetails> reviewListDetails = [];
        jsonDecode(meta.statusMsg)['response'].forEach(
            (f) => reviewListDetails.add(new ReviewListDetails.fromJson(f)));
        yield ReviewListLoaded(reviewListDetails: reviewListDetails);
      }
    }
  }
}
