import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_group_response.dart';
import 'package:slc/repo/home_repository.dart';
import 'package:slc/view/home/bloc/bloc.dart';

import './bloc.dart';

class FacilityGroupBloc extends Bloc<FacilityGroupEvent, FacilityGroupState> {
  final HomeBloc homeBloc;

  FacilityGroupBloc({this.homeBloc}) : super(null);

  FacilityGroupState get initialState => FacilityGroupLoadingState();

  Stream<FacilityGroupState> mapEventToState(
    FacilityGroupEvent event,
  ) async* {
    if (event is GetFacilityGroupList) {
      yield FacilityGroupLoadingState();
      Meta m = await HomeRepository().getFacilityGroup();

      if (m.statusCode == 200) {
        List<FacilityGroupResponse> facilityGroupResponse = [];
        jsonDecode(m.statusMsg)['response'].forEach((f) =>
            facilityGroupResponse.add(new FacilityGroupResponse.fromJson(f)));
        facilityGroupResponse.sort((a, b) =>
            a.facilityGroupDisplayOrder.compareTo(b.facilityGroupDisplayOrder));
        yield FacilityGroupLoaded(result: facilityGroupResponse);
      } else {
        homeBloc..add(CommonFailure(error: m.statusMsg));
      }
    } else if (event is RefreshGetFacilityGroupList) {
      yield FacilityGroupLoadingState();
      Meta m = await HomeRepository().getFacilityGroup();

      if (m.statusCode == 200) {
        List<FacilityGroupResponse> facilityGroupResponse = [];
        jsonDecode(m.statusMsg)['response'].forEach((f) =>
            facilityGroupResponse.add(new FacilityGroupResponse.fromJson(f)));
        facilityGroupResponse.sort((a, b) =>
            a.facilityGroupDisplayOrder.compareTo(b.facilityGroupDisplayOrder));
        yield RefreshFacilityGroupLoaded(result: facilityGroupResponse);
      } else {
        homeBloc..add(CommonFailure(error: m.statusMsg));
      }
    }
  }
}
