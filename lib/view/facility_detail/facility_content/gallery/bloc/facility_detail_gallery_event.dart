import 'package:equatable/equatable.dart';

abstract class FacilityDetailGalleryEvent extends Equatable {
  const FacilityDetailGalleryEvent();
}

class GetFacilityGalleryDetails extends FacilityDetailGalleryEvent {
  final int facilityId;
  final int facilityMenuId;

  GetFacilityGalleryDetails({this.facilityId, this.facilityMenuId});

  @override
  // TODO: implement props
  List<Object> get props => null;
}
