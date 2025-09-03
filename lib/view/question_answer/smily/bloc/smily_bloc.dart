import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

import './bloc.dart';

class SmilyBloc extends Bloc<SmilyEvent, SmilyState> {
  SmilyBloc() : super(null);

  SmilyState get initialState => InitialSmilyState();

  Stream<SmilyState> mapEventToState(
    SmilyEvent event,
  ) async* {
    if (event is SmilyCardCreateEvent) {
      debugPrint("bloccccccccccccccccccccccccc" +
          event.cardListValue.toString() +
          " " +
          event.cardPosition.toString());
      yield SmilyCardCreateState(
          cardListValue: event.cardListValue, cardPosition: event.cardPosition);
      yield SmilyCardCreateNewState(
          cardListValue: event.cardListValue, cardPosition: event.cardPosition);
    } else if (event is CardAnimationEvent) {
      yield CardAnimationState(isAnimate: event.isAnimate);
    } else if (event is RefreshSmilyEvent) {
      print('called RefreshSmilyEvent');
      yield RefreshSmilyState(isAnimate: event.isAnimate);
//      yield InitialSmilyState();
    }
  }
}
