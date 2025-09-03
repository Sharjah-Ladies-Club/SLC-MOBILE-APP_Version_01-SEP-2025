import 'package:slc/model/facility_detail_response.dart';

class RadioModel {
  bool isSelected;
  final int mobileCategoryId;
  final String mobileCategoryName;
  final String menuType;
  final FacilityDetailResponse response;

  RadioModel(
      {this.isSelected,
      this.mobileCategoryId,
      this.mobileCategoryName,
      this.menuType,
      this.response});
}
