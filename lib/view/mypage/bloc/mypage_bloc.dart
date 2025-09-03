import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/transaction_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class MyPageBloc extends Bloc<MyPageEvent, MyPageState> {
  final MyPageBloc myPageBloc;

  MyPageBloc({@required this.myPageBloc}) : super(null);

  MyPageState get initialState => InitialMyPageState();

  Stream<MyPageState> mapEventToState(
    MyPageEvent event,
  ) async* {
    if (event is MyPageTransactionLoadEvent) {
      try {
        yield ShowProgressBar();
        List<TransactionResponse> transactionResponse = [];
        Meta m = await (new FacilityDetailRepository()).getTransactionList();
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"].forEach((f) =>
              transactionResponse.add(new TransactionResponse.fromJson(f)));
        }
        yield MyPageTransactionLoadState(
            transactionResponse: transactionResponse);
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is MyPageTransactionDetailLoadEvent) {
      try {
        yield ShowProgressBar();
        List<TransactionDetailResponse> transactionDetailResponse = [];
        Meta m = await (new FacilityDetailRepository())
            .getTransactionDetailList(event.orderId);
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"].forEach((f) =>
              transactionDetailResponse
                  .add(new TransactionDetailResponse.fromJson(f)));
        }
        yield MyPageTransactionDetailLoadState(
            transactionDetailResponse: transactionDetailResponse);
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    } else if (event is MyPageVoucherDetailLoadEvent) {
      try {
        yield ShowProgressBar();
        List<LoyaltyVoucherResponse> loyaltyVoucherResponse = [];
        Meta m = await (new FacilityDetailRepository()).getVoucherList(1, 0);
        if (m.statusCode == 200) {
          jsonDecode(m.statusMsg)["response"].forEach((f) =>
              loyaltyVoucherResponse
                  .add(new LoyaltyVoucherResponse.fromJson(f)));
        }
        yield MyPageVoucherDetailLoadState(
            loyaltyVoucherResponse: loyaltyVoucherResponse);
        yield HideProgressBar();
      } catch (e) {
        print(e);
        yield HideProgressBar();
      }
    }
  }
}
