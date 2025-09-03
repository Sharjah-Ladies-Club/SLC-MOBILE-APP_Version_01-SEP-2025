import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/gmcore/storage/SPUtils.dart';
import 'package:slc/model/facility_detail_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/utils/constant.dart';
import 'package:slc/view/facility_detail/bloc/bloc.dart';

import './bloc.dart';

class FacilityItemDetailBloc
    extends Bloc<FacilityItemDetailEvent, FacilityItemDetailState> {
  final FacilityDetailBloc facilityDetailBloc;
  final FacilityDetailRepository facilityDetailRepository;

  FacilityItemDetailBloc(
      {this.facilityDetailBloc, this.facilityDetailRepository})
      : super(null);

  FacilityItemDetailState get initialState => InitialFacilityItemDetailState();

  Stream<FacilityItemDetailState> mapEventToState(
    FacilityItemDetailEvent event,
  ) async* {
    if (event is GetFacilityItemDetails) {
      yield LoadingFacilityItemDetails();
      facilityDetailBloc.add(ShowFacilityDetailProgressBar());
      Meta m =
          await facilityDetailRepository.getFacilityDetails(event.facilityId);
      if (m.statusCode == 200) {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        SPUtil.putBool(Constants.IS_MENU_TAB_FULL, false);
        FacilityDetailResponse facilityDetail = FacilityDetailResponse.fromJson(
            jsonDecode(m.statusMsg)['response']);
        // debugPrint("Siva Raja" + facilityDetail.isClosed.toString());
        facilityDetailBloc
            .add(FacilityDetailCloseEvent(isClosed: facilityDetail.isClosed));
        yield LoadedFacilityItemDetails(facilityDetailResponse: facilityDetail);
      } else {
        facilityDetailBloc.add((FacilityDetailOnFailure(error: m.statusMsg)));
      }
    } else if (event is ReloadFacilityItemDetails) {
      yield LoadingFacilityItemDetails();
      facilityDetailBloc.add(ShowFacilityDetailProgressBar());
      Meta m =
          await facilityDetailRepository.getFacilityDetails(event.facilityId);
      if (m.statusCode == 200) {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        SPUtil.putBool(Constants.IS_MENU_TAB_FULL, false);
        FacilityDetailResponse facilityDetail = FacilityDetailResponse.fromJson(
            jsonDecode(m.statusMsg)['response']);
        // debugPrint("Raja Kumar" + facilityDetail.isClosed.toString());
        facilityDetailBloc
            .add(FacilityDetailCloseEvent(isClosed: facilityDetail.isClosed));
        yield ReLoadedFacilityItemDetails(
            facilityDetailResponse: facilityDetail);
      } else {
        facilityDetailBloc.add((FacilityDetailOnFailure(error: m.statusMsg)));
      }
    }
  }
}
