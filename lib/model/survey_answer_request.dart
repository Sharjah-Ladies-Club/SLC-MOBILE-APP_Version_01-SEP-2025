class SurveyAnswerRequest {
  List<int> answerId;
  int questionId;

  SurveyAnswerRequest({this.answerId, this.questionId});

  SurveyAnswerRequest.fromJson(Map<String, dynamic> json) {
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
