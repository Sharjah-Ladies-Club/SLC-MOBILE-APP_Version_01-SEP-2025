import 'package:slc/customcomponentfields/RadioModel.dart';

abstract class TabChoiceChipEvent {
  const TabChoiceChipEvent();
}

class ShowEventTabHeader extends TabChoiceChipEvent {
  final List<RadioModel> tab;

  const ShowEventTabHeader({this.tab});

  List<Object> get props => [tab];
}

class ShowEventNewTabHeader extends TabChoiceChipEvent {
  final List<RadioModel> tab;

  const ShowEventNewTabHeader({this.tab});

  List<Object> get props => [tab];
}

class ShowRefreshEventTabHeader extends TabChoiceChipEvent {
  final List<RadioModel> tab;

  const ShowRefreshEventTabHeader({this.tab});

  List<Object> get props => [tab];
}

class SilentShowRefreshEventTabHeader extends TabChoiceChipEvent {
  final List<RadioModel> tab;

  const SilentShowRefreshEventTabHeader({this.tab});

  List<Object> get props => [tab];
}
