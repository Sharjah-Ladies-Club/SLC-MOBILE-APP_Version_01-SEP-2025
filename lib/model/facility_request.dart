class FacilityRequest {
  int facilityGroupId;

  FacilityRequest({this.facilityGroupId});

  FacilityRequest.fromJson(Map<String, dynamic> json) {
    facilityGroupId = json['facilityGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityGroupId'] = this.facilityGroupId;
    return data;
  }
}
