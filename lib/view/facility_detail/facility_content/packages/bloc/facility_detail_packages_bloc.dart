import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_item_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/view/facility_detail/bloc/facility_detail_bloc.dart';
import 'package:slc/view/facility_detail/bloc/facility_detail_event.dart';

import './bloc.dart';

class FacilityDetailPackagesBloc
    extends Bloc<FacilityDetailPackagesEvent, FacilityDetailPackagesState> {
  final FacilityDetailBloc facilityDetailBloc;
  final FacilityDetailRepository facilityDetailRepository;

  FacilityDetailPackagesBloc(
      {this.facilityDetailBloc, this.facilityDetailRepository})
      : super(null);

  FacilityDetailPackagesState get initialState =>
      InitialFacilityDetailServiceState();

  Stream<FacilityDetailPackagesState> mapEventToState(
    FacilityDetailPackagesEvent event,
  ) async* {
    if (event is GetFacilityServiceDetails) {
      yield LoadingFacilityService();
      facilityDetailBloc.add(ShowFacilityDetailProgressBar());

      Meta m = await facilityDetailRepository.getFacilityCategoryDetails(
          event.facilityId, event.facilityMenuId);

      if (m.statusCode == 200) {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        List<FacilityDetailItem> facilityItemList = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => facilityItemList.add(new FacilityDetailItem.fromJson(f)));
        yield LoadedFacilityService(facilityItemList);
      } else {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        facilityDetailBloc.add((FacilityDetailOnFailure(error: m.statusMsg)));
      }
    }
  }
}
