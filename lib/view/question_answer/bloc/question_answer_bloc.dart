import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';

class QuestionAnswerBloc
    extends Bloc<QuestionAnswerEvent, QuestionAnswerState> {
  QuestionAnswerBloc(QuestionAnswerState initialState) : super(initialState);

  QuestionAnswerState get initialState => InitialQuestionAnswerState();

  Stream<QuestionAnswerState> mapEventToState(
    QuestionAnswerEvent event,
  ) async* {
    if (event is PopulateQAListEvent) {
      yield PopulateQAListState(
          surveySaveRequestList: event.surveySaveRequestList, id: event.id);
    }
  }
}
