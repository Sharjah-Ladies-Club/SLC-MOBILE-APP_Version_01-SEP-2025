import 'package:equatable/equatable.dart';

abstract class MyPageEvent extends Equatable {
  const MyPageEvent();
}

class MyPageTransactionLoadEvent extends MyPageEvent {
  const MyPageTransactionLoadEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class MyPageTransactionDetailLoadEvent extends MyPageEvent {
  final int orderId;
  const MyPageTransactionDetailLoadEvent({this.orderId});

  @override
  // TODO: implement props
  List<Object> get props => [orderId];
}

class MyPageVoucherDetailLoadEvent extends MyPageEvent {
  const MyPageVoucherDetailLoadEvent();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class TransactionFeedbackSaveEvent extends MyPageEvent {
  final int orderId;
  final int feedbackPoints;
  const TransactionFeedbackSaveEvent({this.orderId, this.feedbackPoints});

  @override
  // TODO: implement props
  List<Object> get props => [orderId, feedbackPoints];
}
