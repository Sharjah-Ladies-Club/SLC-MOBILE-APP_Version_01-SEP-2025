import 'package:equatable/equatable.dart';

abstract class SurveySmileyState extends Equatable {
  const SurveySmileyState();
}

class InitialSurveySmileyState extends SurveySmileyState {
  @override
  List<Object> get props => [];
}

class RefreshSurveySmileyListState extends SurveySmileyState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
