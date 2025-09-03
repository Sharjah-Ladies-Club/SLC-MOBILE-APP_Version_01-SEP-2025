import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/bloc/bloc.dart';

import './bloc.dart';

class FacilityMenuBloc extends Bloc<FacilityMenuEvent, FacilityMenuState> {
  final FacilityDetailBloc facilityDetailBloc;
  final FacilityDetailRepository facilityDetailRepository;

  FacilityMenuBloc({this.facilityDetailBloc, this.facilityDetailRepository})
      : super(null);

  FacilityMenuState get initialState => InitialFacilityMenuState();

  Stream<FacilityMenuState> mapEventToState(
    FacilityMenuEvent event,
  ) async* {
    if (event is LoadFacilityMenu) {
      yield InitialFacilityMenuState();
      facilityDetailBloc.add(FacilityDetailCloseEvent(
          isClosed: event.facilityDetailResponse.isClosed));
      yield PopulateMenu(
          tabList: event.tabList,
          facilityDetailResponse: event.facilityDetailResponse);
    } else if (event is ReLoadFacilityMenu) {
      yield InitialFacilityMenuState();
      facilityDetailBloc.add(FacilityDetailCloseEvent(
          isClosed: event.facilityDetailResponse.isClosed));
      SPUtil.putBool(Constants.REFRESH_FACILITYDETAILS, true);
      yield RePopulateMenu(
          tabList: event.tabList,
          facilityDetailResponse: event.facilityDetailResponse);
    }
  }
}
