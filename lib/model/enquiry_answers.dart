class MemberAnswerRequest {
  int userId;
  int enquiryDetailsId;
  List<MemberAnswer> memberAnswersDto;
  MemberAnswerRequest(
      {this.userId, this.enquiryDetailsId, this.memberAnswersDto});
  MemberAnswerRequest.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    enquiryDetailsId = json['enquiryDetailsId'];
    if (json['memberQuestions'] != null) {
      memberAnswersDto = [];
      json['memberQuestions'].forEach((v) {
        memberAnswersDto.add(new MemberAnswer.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['enquiryDetailsId'] = this.enquiryDetailsId;
    if (this.memberAnswersDto != null) {
      data['memberAnswersDto'] =
          this.memberAnswersDto.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberAnswer {
  int memberQuestionsId;
  String answers;

  MemberAnswer({this.memberQuestionsId, this.answers});

  MemberAnswer.fromJson(Map<String, dynamic> json) {
    memberQuestionsId = json['memberQuestionsId'];
    answers = json['answers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberQuestionsId'] = this.memberQuestionsId;
    data['answers'] = this.answers;
    return data;
  }
}

class MemberAnswerResult {
  String validationResult;
  bool proceedToPay;
  MemberAnswerResult({this.validationResult, this.proceedToPay});

  MemberAnswerResult.fromJson(Map<String, dynamic> json) {
    validationResult = json['validationResult'];
    proceedToPay = json['proceedToPay'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['validationResult'] = this.validationResult;
    data['proceedToPay'] = this.proceedToPay;
    return data;
  }
}
