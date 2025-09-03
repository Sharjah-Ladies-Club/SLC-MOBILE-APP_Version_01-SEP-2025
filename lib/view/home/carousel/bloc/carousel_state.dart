import 'package:meta/meta.dart';
import 'package:slc/model/carousel_response.dart';

abstract class CarouselState {
  const CarouselState();
}

class CarouselLoadingState extends CarouselState {
  List<Object> get props => [];
}

class CarouselLoadedState extends CarouselState {
  final List<CarouselResponse> result;

  const CarouselLoadedState({this.result});

  List<Object> get props => [result];
}

class RefreshCarouselLoadedState extends CarouselState {
  final List<CarouselResponse> result;

  const RefreshCarouselLoadedState({@required this.result});

  List<Object> get props => [result];
}

class CarouselOnFailure extends CarouselState {
  final String error;

  const CarouselOnFailure({@required this.error});

  List<Object> get props => [error];
}
