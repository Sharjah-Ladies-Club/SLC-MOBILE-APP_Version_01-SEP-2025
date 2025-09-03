import 'package:equatable/equatable.dart';
import 'package:slc/model/transaction_response.dart';

abstract class MyPageState extends Equatable {
  const MyPageState();
}

class InitialMyPageState extends MyPageState {
  @override
  List<Object> get props => [];
}

class MyPageTransactionLoadState extends MyPageState {
  final List<TransactionResponse> transactionResponse;

  const MyPageTransactionLoadState({this.transactionResponse});

  @override
  // TODO: implement props
  List<Object> get props => [transactionResponse];
}

class MyPageTransactionDetailLoadState extends MyPageState {
  final List<TransactionDetailResponse> transactionDetailResponse;

  const MyPageTransactionDetailLoadState({this.transactionDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [transactionDetailResponse];
}

class MyPageVoucherDetailLoadState extends MyPageState {
  final List<LoyaltyVoucherResponse> loyaltyVoucherResponse;

  const MyPageVoucherDetailLoadState({this.loyaltyVoucherResponse});

  @override
  // TODO: implement props
  List<Object> get props => [loyaltyVoucherResponse];
}

class ShowProgressBar extends MyPageState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class HideProgressBar extends MyPageState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}
