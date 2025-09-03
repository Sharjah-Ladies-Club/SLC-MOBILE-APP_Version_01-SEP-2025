class FacilityGroupResponse {
  int facilityGroupId;
  String facilityGroupName;
  int facilityGroupDisplayOrder;
  String activeColorCode;
  String inActiveImageURL;
  String activeImageURL;

  FacilityGroupResponse(
      {this.facilityGroupId,
      this.facilityGroupName,
      this.facilityGroupDisplayOrder,
      this.activeColorCode,
      this.inActiveImageURL,
      this.activeImageURL});

  FacilityGroupResponse.fromJson(Map<String, dynamic> json) {
    facilityGroupId = json['facilityGroupId'];
    facilityGroupName = json['facilityGroupName'];
    facilityGroupDisplayOrder = json['facilityGroupDisplayOrder'];
    activeColorCode = json['activeColorCode'];
    inActiveImageURL = json['inActiveImageURL'];
    activeImageURL = json['activeImageURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityGroupId'] = this.facilityGroupId;
    data['facilityGroupName'] = this.facilityGroupName;
    data['facilityGroupDisplayOrder'] = this.facilityGroupDisplayOrder;
    data['activeColorCode'] = this.activeColorCode;
    data['inActiveImageURL'] = this.inActiveImageURL;
    data['activeImageURL'] = this.activeImageURL;
    return data;
  }
}
