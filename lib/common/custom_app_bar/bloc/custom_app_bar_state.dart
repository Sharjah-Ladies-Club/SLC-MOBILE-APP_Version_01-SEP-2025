import 'package:equatable/equatable.dart';

abstract class CustomAppBarState extends Equatable {
  const CustomAppBarState();
}

class InitialCustomAppBarState extends CustomAppBarState {
  @override
  List<Object> get props => [];
}

class UpdateNotificationBadge extends CustomAppBarState {
  final bool isShowBadge;

  const UpdateNotificationBadge({this.isShowBadge});

  @override
  // TODO: implement props
  List<Object> get props => [isShowBadge];
}
