class MemberQuestionGroup {
  String questionGroup;
  List<MemberQuestionsResponse> memberQuestions;
  MemberQuestionGroup({this.questionGroup, this.memberQuestions});
  MemberQuestionGroup.fromJson(Map<String, dynamic> json) {
    questionGroup = json['questionGroup'];
    if (json['memberQuestions'] != null) {
      memberQuestions = [];
      json['memberQuestions'].forEach((v) {
        memberQuestions.add(new MemberQuestionsResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionGroup'] = this.questionGroup;
    if (this.memberQuestions != null) {
      data['memberQuestions'] =
          this.memberQuestions.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberQuestionsResponse {
  int memberQuestionId;
  String questionName;
  int questionDisplayType;
  String questionOptions;
  String answerOptions;
  bool isActive;
  String questionAnswer;

  MemberQuestionsResponse(
      {this.memberQuestionId,
      this.questionName,
      this.questionDisplayType,
      this.questionOptions,
      this.answerOptions,
      this.isActive,
      this.questionAnswer});

  MemberQuestionsResponse.fromJson(Map<String, dynamic> json) {
    memberQuestionId = json['memberQuestionId'];
    questionName = json['questionName'];
    questionDisplayType = json['questionDisplayType'];
    questionOptions = json['questionOptions'];
    answerOptions = json['answerOptions'];
    isActive = json['isActive'];
    questionAnswer = json['questionAnswer'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberQuestionId'] = this.memberQuestionId;
    data['questionName'] = this.questionName;
    data['questionDisplayType'] = this.questionDisplayType;
    data['questionOptions'] = this.questionOptions;
    data['answerOptions'] = this.answerOptions;
    data['isActive'] = this.isActive;
    data['questionAnswer'] = this.questionAnswer;
    return data;
  }
}
