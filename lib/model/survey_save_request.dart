import 'package:slc/model/survey_answer_request.dart';

class SurveySaveRequest {
  int facilityId;
  String comments;
  int userId;
  List<SurveyAnswerRequest> answerList;

  SurveySaveRequest(
      {this.facilityId, this.comments, this.userId, this.answerList});

  SurveySaveRequest.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    comments = json['comments'];
    userId = json['userId'];
    if (json['answerList'] != null) {
      answerList = [];
      json['answerList'].forEach((v) {
        answerList.add(new SurveyAnswerRequest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['comments'] = this.comments;
    data['userId'] = this.userId;
    if (this.answerList != null) {
      data['answerList'] = this.answerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
