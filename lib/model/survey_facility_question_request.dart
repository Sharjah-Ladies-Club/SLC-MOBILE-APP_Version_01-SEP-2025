class SurveyFacilityQuestionRequest {
  int userId;
  int facilityId;

  SurveyFacilityQuestionRequest({this.userId, this.facilityId});

  SurveyFacilityQuestionRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    facilityId = json['facilityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['facilityId'] = this.facilityId;
    return data;
  }
}
