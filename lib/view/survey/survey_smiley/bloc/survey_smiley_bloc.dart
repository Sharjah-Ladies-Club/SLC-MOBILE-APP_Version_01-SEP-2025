import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/view/survey/bloc/bloc.dart';

import './bloc.dart';

class SurveySmileyBloc extends Bloc<SurveySmileyEvent, SurveySmileyState> {
  NSurveyBloc surveyBloc;

  SurveySmileyBloc({this.surveyBloc}) : super(null);

  SurveySmileyState get initialState => InitialSurveySmileyState();

  @override
  Stream<SurveySmileyState> mapEventToState(
    SurveySmileyEvent event,
  ) async* {
    if (event is RefreshSurveySmileyEvent) {
      yield RefreshSurveySmileyListState();
    }
  }
}
