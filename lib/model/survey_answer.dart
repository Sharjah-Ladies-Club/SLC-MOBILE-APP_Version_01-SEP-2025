class SurveyAnswer {
  int answerId;
  String answer;
  String imageUrlActive;
  String imageUrlInActive;

  SurveyAnswer(
      {this.answerId, this.answer, this.imageUrlActive, this.imageUrlInActive});

  SurveyAnswer.fromJson(Map<String, dynamic> json) {
    answerId = json['answerId'];
    answer = json['answer'];
    imageUrlActive = json['imageUrlActive'];
    imageUrlInActive = json['imageUrlInActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['answerId'] = this.answerId;
    data['answer'] = this.answer;
    data['imageUrlActive'] = this.imageUrlActive;
    data['imageUrlInActive'] = this.imageUrlInActive;
    return data;
  }
}
