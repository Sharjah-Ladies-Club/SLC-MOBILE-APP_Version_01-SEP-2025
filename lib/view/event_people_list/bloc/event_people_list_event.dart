import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:slc/model/EventTempleterequest.dart';
import 'package:slc/model/event_price_category.dart';
import 'package:slc/model/eventresulttemplate.dart';

abstract class EventPeopleListEvent extends Equatable {
  const EventPeopleListEvent();
}

class GetEventParticipantListEvent extends EventPeopleListEvent {
  final int eventId;
  final List<EventPriceCategory> eventPriceCategoryList;

  const GetEventParticipantListEvent(
      {this.eventId, this.eventPriceCategoryList});

  @override
  // TODO: implement props
  List<Object> get props => [eventId, eventPriceCategoryList];
}

class ErrorDialogEvent extends EventPeopleListEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class ShowImageEvent extends EventPeopleListEvent {
  final File file;

  const ShowImageEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class ShowImageCameraEvent extends EventPeopleListEvent {
  final File file;

  const ShowImageCameraEvent({this.file});

  @override
  // TODO: implement props
  List<Object> get props => [file];
}

class SaveEventResult extends EventPeopleListEvent {
  final eventresulttemplate request;

  const SaveEventResult({this.request});

  @override
  List<Object> get props => [request];
}

class SaveEventTemplateEvent extends EventPeopleListEvent {
  final EventTempleteRequest request;

  const SaveEventTemplateEvent({this.request});

  @override
  List<Object> get props => [request];
}
