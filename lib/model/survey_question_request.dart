import 'package:equatable/equatable.dart';
import 'package:slc/model/survey_answer.dart';

// ignore: must_be_immutable
class SurveyQuestionRequest extends Equatable {
  int questionId;
  int questionTypeId;
  int questionControlTypeId;
  String question;
  List<SurveyAnswer> answerViews;

  SurveyQuestionRequest(
      {this.questionId,
      this.questionTypeId,
      this.questionControlTypeId,
      this.question,
      this.answerViews});

  SurveyQuestionRequest copyWith(
      {int questionId,
      int questionTypeId,
      int questionControlTypeId,
      String question,
      List<SurveyAnswer> answerViews}) {
    return SurveyQuestionRequest(
        questionId: questionId ?? this.questionId,
        questionTypeId: questionTypeId ?? this.questionTypeId,
        questionControlTypeId:
            questionControlTypeId ?? this.questionControlTypeId,
        question: question ?? this.question,
        answerViews: answerViews ?? this.answerViews);
  }

  SurveyQuestionRequest.fromJson(Map<String, dynamic> json) {
    questionId = json['questionId'];
    questionTypeId = json['questionTypeId'];
    questionControlTypeId = json['questionControlTypeId'];
    question = json['question'];
    if (json['answerViews'] != null) {
      answerViews = [];
      json['answerViews'].forEach((v) {
        answerViews.add(new SurveyAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['questionId'] = this.questionId;
    data['questionTypeId'] = this.questionTypeId;
    data['questionControlTypeId'] = this.questionControlTypeId;
    data['question'] = this.question;
    if (this.answerViews != null) {
      data['answerViews'] = this.answerViews.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  // TODO: implement props
  List<Object> get props => [
        questionId,
        questionControlTypeId,
        questionTypeId,
        question,
        answerViews
      ];
}

class AnswerViews {
  int answerId;
  String answer;
  String imageUrlActive;
  String imageUrlInActive;

  AnswerViews(
      {this.answerId, this.answer, this.imageUrlActive, this.imageUrlInActive});

  AnswerViews.fromJson(Map<String, dynamic> json) {
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
