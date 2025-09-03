import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:slc/gmcore/model/Meta.dart';
import 'package:slc/model/facility_detail_item_gallery_response.dart';
import 'package:slc/repo/facility_detail_repository.dart';
import 'package:slc/view/facility_detail/bloc/bloc.dart';

import './bloc.dart';

class FacilityDetailGalleryBloc
    extends Bloc<FacilityDetailGalleryEvent, FacilityDetailGalleryState> {
  FacilityDetailBloc facilityDetailBloc;
  FacilityDetailRepository facilityDetailRepository;

  FacilityDetailGalleryBloc(
      {this.facilityDetailBloc, this.facilityDetailRepository})
      : super(null);

  FacilityDetailGalleryState get initialState =>
      InitialFacilityDetailGalleryState();

  Stream<FacilityDetailGalleryState> mapEventToState(
    FacilityDetailGalleryEvent event,
  ) async* {
    if (event is GetFacilityGalleryDetails) {
      yield LoadingFacilityGallery();
      facilityDetailBloc.add(ShowFacilityDetailProgressBar());
      Meta m = await FacilityDetailRepository()
          .getFacilityGalleryDetail(event.facilityId, event.facilityMenuId);

      if (m.statusCode == 200) {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        List<FacilityGalleryDetail> facilityItemList = [];
        jsonDecode(m.statusMsg)['response'].forEach(
            (f) => facilityItemList.add(new FacilityGalleryDetail.fromJson(f)));

        yield LoadedFacilityGallery(facilityItemList);
      } else {
        facilityDetailBloc.add(HideFacilityDetailProgressBar());
        yield FacilityGalleryError(error: m.statusMsg);
      }
    }
  }
}
