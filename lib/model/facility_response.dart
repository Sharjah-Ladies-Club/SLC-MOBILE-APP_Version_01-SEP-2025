class FacilityResponse {
  int facilityId;
  String facilityName;
  int facilityDisplayOrder;
  int facilityGroupId;
  String facilityGroupName;
  String facilityImageURL;
  String facilityOrderImageURL;
  bool isClosed;
  String colorCode;

  FacilityResponse(
      {this.facilityId,
      this.facilityName,
      this.facilityDisplayOrder,
      this.facilityGroupId,
      this.facilityGroupName,
      this.facilityImageURL,
      this.facilityOrderImageURL,
      this.isClosed,
      this.colorCode});

  FacilityResponse.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    facilityDisplayOrder = json['facilityDisplayOrder'];
    facilityGroupId = json['facilityGroupId'];
    facilityGroupName = json['facilityGroupName'];
    facilityImageURL = json['facilityImageURL'];
    facilityOrderImageURL = json['facilityOrderImageURL'];
    isClosed = json['isClosed'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['facilityName'] = this.facilityName;
    data['facilityDisplayOrder'] = this.facilityDisplayOrder;
    data['facilityGroupId'] = this.facilityGroupId;
    data['facilityGroupName'] = this.facilityGroupName;
    data['facilityImageURL'] = this.facilityImageURL;
    data['facilityOrderImageURL'] = this.facilityOrderImageURL;
    data['isClosed'] = this.isClosed;
    data['colorCode'] = this.colorCode;
    return data;
  }
}

class FitnessActivity {
  int facilityId;
  int fitnessActivityId;
  String fitnessActivityName;
  String fitnessActivityImageURL;
  String colorCode;

  FitnessActivity(
      {this.facilityId,
      this.fitnessActivityId,
      this.fitnessActivityName,
      this.fitnessActivityImageURL,
      this.colorCode});

  FitnessActivity.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    fitnessActivityId = json['fitnessActivityId'];
    fitnessActivityName = json['fitnessActivityName'];
    fitnessActivityImageURL = json['fitnessActivityImageURL'];
    colorCode = json['colorCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['fitnessActivityId'] = this.fitnessActivityId;
    data['fitnessActivityName'] = this.fitnessActivityName;
    data['fitnessActivityImageURL'] = this.fitnessActivityImageURL;
    data['colorCode'] = this.colorCode;
    return data;
  }
}
