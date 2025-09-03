import 'survey_answer_request.dart';

class ReviewFeedBackRequest {
  int eventId;
  String comments;
  int userId;
  List<SurveyAnswerRequest> answerList;

  ReviewFeedBackRequest(
      {this.eventId, this.comments, this.userId, this.answerList});

  ReviewFeedBackRequest.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
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
    data['eventId'] = this.eventId;
    data['comments'] = this.comments;
    data['userId'] = this.userId;
    if (this.answerList != null) {
      data['answerList'] = this.answerList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AnswerList {
  List<int> answerId;
  int questionId;

  AnswerList({this.answerId, this.questionId});

  AnswerList.fromJson(Map<String, dynamic> json) {
    answerId = json['answerId'].cast<int>();
    questionId = json['questionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answerId'] = this.answerId;
    data['questionId'] = this.questionId;
    return data;
  }
}
