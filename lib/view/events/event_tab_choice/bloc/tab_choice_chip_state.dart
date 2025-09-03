import 'package:slc/customcomponentfields/RadioModel.dart';

abstract class TabChoiceChipState {
  const TabChoiceChipState();
}

class InitialTabChoiceChipState extends TabChoiceChipState {
  List<Object> get props => [];
}

class ShowEventTabState extends TabChoiceChipState {
  final List<RadioModel> tab;

  const ShowEventTabState({this.tab});

  List<Object> get props => [tab];
}

class ShowEventNewTabState extends TabChoiceChipState {
  final List<RadioModel> tab;

  const ShowEventNewTabState({this.tab});

  List<Object> get props => [tab];
}

class ShowRefreshEventTabState extends TabChoiceChipState {
  final List<RadioModel> tab;

  const ShowRefreshEventTabState({this.tab});

  List<Object> get props => [tab];
}

class ShowSilentRefreshEventTabState extends TabChoiceChipState {
  final List<RadioModel> tab;

  const ShowSilentRefreshEventTabState({this.tab});

  List<Object> get props => [tab];
}
