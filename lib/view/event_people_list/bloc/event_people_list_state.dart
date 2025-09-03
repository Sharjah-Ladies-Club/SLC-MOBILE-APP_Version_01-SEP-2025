import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/EventTempleterequest.dart';
import 'package:slc/model/event_participant_response.dart';
import 'package:slc/model/event_price_category.dart';

abstract class EventPeopleListState extends Equatable {
  const EventPeopleListState();
}

class InitialEventPeopleListState extends EventPeopleListState {
  @override
  List<Object> get props => [];
}

class ShowEventPeopleListProgressBarState extends EventPeopleListState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideEventPeopleListProgressBarState extends EventPeopleListState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadPeopleList extends EventPeopleListState {
  final EventParticipantResponse response;
  final List<EventPriceCategory> eventPricingCategoryList;

  const LoadPeopleList({this.response, this.eventPricingCategoryList});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class OnFailureEventPeopleListState extends EventPeopleListState {
  final String error;

  const OnFailureEventPeopleListState({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class ErrorDialogState extends EventPeopleListState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class ShowImageState extends EventPeopleListState {
  final File file;
  const ShowImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowNewImageState extends EventPeopleListState {
  final File file;
  const ShowNewImageState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowImageCameraState extends EventPeopleListState {
  final File file;
  const ShowImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ShowNewImageCameraState extends EventPeopleListState {
  final File file;
  const ShowNewImageCameraState({this.file});

  @override
  // TODO: implement props
  List<Object> get props => null;
}

class SaveTemplateState extends EventPeopleListState {
  final EventTempleteRequest request;
  const SaveTemplateState({this.request});

  @override
  // TODO: implement props
  List<Object> get props => null;
}
