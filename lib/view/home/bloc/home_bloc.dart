import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/carousel_response.dart';
import 'package:slc/repo/home_repository.dart';

import './bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeRepository homeRepository;
  HomeBloc() : super(null);

  HomeState get initialState => InitialHomeState();

  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is ShowCommonProgresser) {
      yield ShowProgressBar();
    } else if (event is HideCommonProgresser) {
      yield HideProgressBar();
    } else if (event is CommonFailure) {
      yield OnFailure(event.error);
    } else if (event is RetryTapped) {
      yield InitialHomeState();
      await Future.delayed(Duration(milliseconds: 100));
      yield ReTryingState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is GetMarketingQuestionList) {
      Meta m1 = await HomeRepository().getMemberQuestionData();
      List<MarketingQuestion> marketingQuestions = [];
      if (m1.statusCode == 200) {
        marketingQuestions = [];
        jsonDecode(m1.statusMsg)['response'].forEach(
            (f) => marketingQuestions.add(new MarketingQuestion.fromJson(f)));
      }

      yield MarketingQuestionLoadedState(
          marketingQuesitons: marketingQuestions);
    }
  }
}
