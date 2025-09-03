import 'package:equatable/equatable.dart';
import 'package:slc/customcomponentfields/RadioModel.dart';
import 'package:slc/model/facility_detail_response.dart';

abstract class FacilityMenuState extends Equatable {
  const FacilityMenuState();
}

class InitialFacilityMenuState extends FacilityMenuState {
  @override
  List<Object> get props => [];
}

class PopulateMenu extends FacilityMenuState {
  final List<RadioModel> tabList;
  final FacilityDetailResponse facilityDetailResponse;

  const PopulateMenu({this.tabList, this.facilityDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [tabList];
}

class RePopulateMenu extends FacilityMenuState {
  final List<RadioModel> tabList;
  final FacilityDetailResponse facilityDetailResponse;

  const RePopulateMenu({this.tabList, this.facilityDetailResponse});

  @override
  // TODO: implement props
  List<Object> get props => [tabList];
}
