import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class RadioWidgetBloc extends Bloc<RadioWidgetEvent, RadioWidgetState> {
  RadioWidgetBloc(RadioWidgetState initialState) : super(initialState);

  RadioWidgetState get initialState => InitialRadioWidgetState();

  Stream<RadioWidgetState> mapEventToState(
    RadioWidgetEvent event,
  ) async* {
    if (event is CreateRadioWidgetEvent) {
      yield CreateRadioWidgetState(
          cardPosition: event.cardPosition,
          answerList: event.answerList,
          selectedPosition: event.selectedPosition,
          feedbackType: event.feedbackType);
      yield CreateNewRadioWidgetState(
          cardPosition: event.cardPosition,
          answerList: event.answerList,
          selectedPosition: event.selectedPosition,
          feedbackType: event.feedbackType);
    }
  }
}
