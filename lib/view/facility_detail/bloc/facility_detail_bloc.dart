import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';

import './bloc.dart';

class FacilityDetailBloc
    extends Bloc<FacilityDetailEvent, FacilityDetailState> {
  FacilityDetailBloc(FacilityDetailState initialState) : super(initialState);

  FacilityDetailState get initialState => InitialFacilityDetailState();

  @override
  Stream<FacilityDetailState> mapEventToState(
    FacilityDetailEvent event,
  ) async* {
    if (event is ShowFacilityDetailProgressBar) {
      yield ShowFacilityDetailProgressBarState();
    } else if (event is HideFacilityDetailProgressBar) {
      yield HideFacilityDetailProgressBarState();
    } else if (event is ErrorDialogEvent) {
      yield ErrorDialogState(title: event.title, content: event.content);
    } else if (event is FacilityDetailOnFailure) {
      yield FacilityDetailsOnFailure(error: event.error);
    } else if (event is FacilityDetailsInitialEvent) {
      yield InitialFacilityDetailState();
    } else if (event is BeachPageEvent) {
      yield BeachPageState(facilityId: event.facilityId);
    } else if (event is FitnessPageEvent) {
      yield FitnessPageState(facilityId: event.facilityId);
    } else if (event is FacilityDetailRefreshEvent) {
      FacilityDetailResponse facilityDetailResponse =
          new FacilityDetailResponse();
      Meta m = await (new FacilityDetailRepository())
          .getFacilityDetails(event.facilityId);
      if (m.statusCode == 200) {
        facilityDetailResponse = FacilityDetailResponse.fromJson(
            jsonDecode(m.statusMsg)['response']);
      }
      yield FacilityDetailRefreshState(
          facilityDetailResponse: facilityDetailResponse);
    } else if (event is FacilityDetailCloseEvent) {
      yield FacilityDetailCloseState(isClosed: event.isClosed);
    }
//    else if (event is CommonFailure) {
//      yield OnFailure(event.error);
//    } else if (event is RetryTapped) {
//      yield InitialHomeState();
//      await Future.delayed(Duration(milliseconds: 100));
//      yield ReTryingState();
//    }
  }
}
