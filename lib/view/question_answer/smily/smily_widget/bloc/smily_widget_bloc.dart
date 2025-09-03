import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class SmilyWidgetBloc extends Bloc<SmilyWidgetEvent, SmilyWidgetState> {
  SmilyWidgetBloc() : super(null);

  SmilyWidgetState get initialState => InitialSmilyWidgetState();

  Stream<SmilyWidgetState> mapEventToState(
    SmilyWidgetEvent event,
  ) async* {
    if (event is CreateSmilyWidgetEvent) {
      yield CreateSmilyWidgetState(
          cardPosition: event.cardPosition,
          answerList: event.answerList,
          selectedPosition: event.selectedPosition,
          feedbackType: event.feedbackType);
      yield CreateNewSmilyWidgetState(
          cardPosition: event.cardPosition,
          answerList: event.answerList,
          selectedPosition: event.selectedPosition,
          feedbackType: event.feedbackType);
    }
  }
}
