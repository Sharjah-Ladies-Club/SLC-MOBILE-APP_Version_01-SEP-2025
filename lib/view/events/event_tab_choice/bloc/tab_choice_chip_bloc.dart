import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/view/events/bloc/events_bloc.dart';

import './bloc.dart';

class TabChoiceChipBloc extends Bloc<TabChoiceChipEvent, TabChoiceChipState> {
  EventsBloc eventBloc;

  TabChoiceChipBloc(this.eventBloc) : super(null);

  TabChoiceChipState get initialState => InitialTabChoiceChipState();

  Stream<TabChoiceChipState> mapEventToState(
    TabChoiceChipEvent event,
  ) async* {
    if (event is ShowEventTabHeader) {
      yield ShowEventTabState(tab: event.tab);
      yield ShowEventNewTabState(tab: event.tab);
    } else if (event is ShowRefreshEventTabHeader) {
      yield ShowRefreshEventTabState(tab: event.tab);
    } else if (event is SilentShowRefreshEventTabHeader) {
      yield ShowSilentRefreshEventTabState(tab: event.tab);
    }
  }
}
