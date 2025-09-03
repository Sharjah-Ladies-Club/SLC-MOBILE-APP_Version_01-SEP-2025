import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class InitialHomeEvent extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class CarouselItemTapped extends HomeEvent {
  final Object selectedItem;

  const CarouselItemTapped({@required this.selectedItem});

  @override
  // TODO: implement props
  List<Object> get props => [selectedItem];
}

//class FacilityGroupSelected extends HomeEvent {
//  final int selectedFacilityGroupId;
//
//  const FacilityGroupSelected({@required this.selectedFacilityGroupId});
//
//  @override
//  // TODO: implement props
//  List<Object> get props => [selectedFacilityGroupId];
//}

class FacilityCategoryItemSelected extends HomeEvent {
  final Object selectedCategoryItem;

  const FacilityCategoryItemSelected({@required this.selectedCategoryItem});

  @override
  // TODO: implement props
  List<Object> get props => [selectedCategoryItem];
}

class ShowCommonProgresser extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideCommonProgresser extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class CommonFailure extends HomeEvent {
  final String error;

  const CommonFailure({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}

class RetryTapped extends HomeEvent {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class ErrorDialogEvent extends HomeEvent {
  final String title;
  final String content;

  const ErrorDialogEvent({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}

class GetMarketingQuestionList extends HomeEvent {
  @override
  List<Object> get props => null;
}
