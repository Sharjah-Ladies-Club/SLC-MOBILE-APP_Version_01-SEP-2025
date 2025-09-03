abstract class EventsState {
  const EventsState();
}

class InitialEventsState extends EventsState {
  List<Object> get props => [];
}

class ShowEventProgressBarState extends EventsState {
  List<Object> get props => null;
}

class HideEventProgressBarState extends EventsState {
  List<Object> get props => null;
}

class RefreshState extends EventsState {
  List<Object> get props => null;
}

class SilentRefreshState extends EventsState {
  List<Object> get props => null;
}

class OnFailureEventState extends EventsState {
  final String error;

  const OnFailureEventState({this.error});

  List<Object> get props => [error];
}

class ErrorDialogState extends EventsState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  List<Object> get props => [title, content];
}
