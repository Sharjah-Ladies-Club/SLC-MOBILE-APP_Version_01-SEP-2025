import 'package:equatable/equatable.dart';
import 'package:slc/model/facility_detail_item_gallery_response.dart';

abstract class FacilityDetailGalleryState extends Equatable {
  const FacilityDetailGalleryState();
}

class InitialFacilityDetailGalleryState extends FacilityDetailGalleryState {
  @override
  List<Object> get props => [];
}

class LoadingFacilityGallery extends FacilityDetailGalleryState {
  @override
  // TODO: implement props
  List<Object> get props => null;
}

class LoadedFacilityGallery extends FacilityDetailGalleryState {
  final List<FacilityGalleryDetail> facilityGalleryDetail;

  const LoadedFacilityGallery(this.facilityGalleryDetail);

  @override
  List<Object> get props => [facilityGalleryDetail];
}

class FacilityGalleryError extends FacilityDetailGalleryState {
  final String error;

  const FacilityGalleryError({this.error});

  @override
  // TODO: implement props
  List<Object> get props => [error];
}
