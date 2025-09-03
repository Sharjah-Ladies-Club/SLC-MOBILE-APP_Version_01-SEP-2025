import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:slc/model/review_details.dart';

abstract class ReviewDetailsState extends Equatable {
  const ReviewDetailsState();
}

class InitialReviewDetailsState extends ReviewDetailsState {
  @override
  List<Object> get props => [];
}

class ShowProgressBar extends ReviewDetailsState {
  @override
  List<Object> get props => null;
}

class HideProgressBar extends ReviewDetailsState {
  @override
  List<Object> get props => null;
}

class OnReviewDetailsSuccess extends ReviewDetailsState {
  final ReviewDetails reviewDetails;

  const OnReviewDetailsSuccess({this.reviewDetails});

  @override
  List<Object> get props => [reviewDetails];
}

class SuccessState extends ReviewDetailsState {
  @override
  List<Object> get props => [];
}

class FailureState extends ReviewDetailsState {
  final String error;

  const FailureState({@required this.error});

  @override
  List<Object> get props => [error];
}


class ErrorDialogState extends ReviewDetailsState {
  final String title;
  final String content;

  const ErrorDialogState({this.title, this.content});

  @override
  // TODO: implement props
  List<Object> get props => [title, content];
}
