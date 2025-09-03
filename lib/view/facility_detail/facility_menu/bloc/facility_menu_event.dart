import 'package:equatable/equatable.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityMenuEvent extends Equatable {
  const FacilityMenuEvent();
}

// ignore: must_be_immutable
class LoadFacilityMenu extends FacilityMenuEvent {
  List<RadioModel> tabList;
  FacilityDetailResponse facilityDetailResponse;

  LoadFacilityMenu({this.tabList, this.facilityDetailResponse});

  @override
  List<Object> get props => [facilityDetailResponse, tabList];

}

// ignore: must_be_immutable
class ReLoadFacilityMenu extends FacilityMenuEvent {
  List<RadioModel> tabList;
  FacilityDetailResponse facilityDetailResponse;

  ReLoadFacilityMenu({this.tabList, this.facilityDetailResponse});

  @override
  List<Object> get props => [facilityDetailResponse, tabList];
}
