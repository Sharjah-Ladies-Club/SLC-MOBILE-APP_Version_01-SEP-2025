import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_request.dart';
import 'package:slc/model/facility_response.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/view/home/bloc/bloc.dart';

import './bloc.dart';

class FacilityBloc extends Bloc<FacilityEvent, FacilityState> {
  final HomeRepository homeRepository;
  final HomeBloc homeBloc;

  FacilityBloc({this.homeRepository, this.homeBloc}) : super(null);

  FacilityState get initialState => FacilityLoadingState();

  Stream<FacilityState> mapEventToState(
    FacilityEvent event,
  ) async* {
    if (event is RefreshFacility) {
      FacilityRequest request =
          FacilityRequest(facilityGroupId: event.selectedFacilityGroupId);
      Meta m1 = await HomeRepository().getFacilityById(request);
      if (m1.statusCode == 200) {
        List<FacilityResponse> facilityResponseList = [];

        jsonDecode(m1.statusMsg)['response'].forEach(
            (f) => facilityResponseList.add(new FacilityResponse.fromJson(f)));

        facilityResponseList.sort(
            (a, b) => a.facilityDisplayOrder.compareTo(b.facilityDisplayOrder));

        homeBloc..add(HideCommonProgresser());

        yield FacilityLoadedState(facilityResponseList: facilityResponseList);
      } else {
        homeBloc..add(HideCommonProgresser());
        yield FacilityOnFailure(error: m1.statusMsg);
      }
    } else if (event is FacilitySelected) {
      FacilityRequest request =
          FacilityRequest(facilityGroupId: event.selectedFacilityGroupId);
      Meta m1 = await HomeRepository().getFacilityById(request);
      if (m1.statusCode == 200) {
        List<FacilityResponse> facilityResponseList = [];

        jsonDecode(m1.statusMsg)['response'].forEach(
            (f) => facilityResponseList.add(new FacilityResponse.fromJson(f)));
        facilityResponseList.sort(
            (a, b) => a.facilityDisplayOrder.compareTo(b.facilityDisplayOrder));
        homeBloc..add(HideCommonProgresser());

        yield FacilityLoadedState(facilityResponseList: facilityResponseList);
      } else {
        homeBloc..add(HideCommonProgresser());
        yield FacilityOnFailure(error: m1.statusMsg);
      }
    }
  }
}
