class FacilityItemRequest {
  int facilityId;
  int mobileItemCategoryId;

  FacilityItemRequest({this.facilityId, this.mobileItemCategoryId});

  FacilityItemRequest.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    mobileItemCategoryId = json['mobileItemCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['mobileItemCategoryId'] = this.mobileItemCategoryId;
    return data;
  }
}
