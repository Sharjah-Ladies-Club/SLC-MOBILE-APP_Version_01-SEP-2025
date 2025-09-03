class CarouselResponse {
  String imageURL;
  int displayOrder;
  bool hasNavigation;
  int facilityId;
  int mobileCategoryId;

  int navigationTypeId;
  String webUrl;
  bool hasEventNavigation;
  int eventId;
  int mobileItemGroupId;

  CarouselResponse({
    this.imageURL,
    this.displayOrder,
    this.facilityId,
    this.hasNavigation,
    this.mobileCategoryId,
    this.navigationTypeId,
    this.webUrl,
    this.hasEventNavigation,
    this.eventId,
    this.mobileItemGroupId,
  });

  CarouselResponse.fromJson(Map<String, dynamic> json) {
    imageURL = json['imageURL'];
    displayOrder = json['displayOrder'];
    facilityId = json['facilityId'];
    hasNavigation = json['hasNavigation'];
    mobileCategoryId = json['mobileCategoryId'];

    navigationTypeId = json['navigationTypeId'];
    webUrl = json['webUrl'];
    hasEventNavigation = json['hasEventNavigation'];
    eventId = json['eventId'];
    mobileItemGroupId = json['mobileItemGroupId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageURL'] = this.imageURL;
    data['displayOrder'] = this.displayOrder;
    data['mobileCategoryId'] = this.mobileCategoryId;
    data['hasNavigation'] = this.hasNavigation;
    data['facilityId'] = this.facilityId;

    data['navigationTypeId'] = this.navigationTypeId;
    data['webUrl'] = this.webUrl;
    data['hasEventNavigation'] = this.hasEventNavigation;
    data['eventId'] = this.eventId;
    data['mobileItemGroupId'] = this.mobileItemGroupId;

    return data;
  }
}

class MarketingQuestion {
  String question;
  String questionAr;
  int userId;
  int answer;
  int questionId;

  MarketingQuestion(
      {this.question,
      this.questionAr,
      this.userId,
      this.answer,
      this.questionId});

  MarketingQuestion.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    questionAr = json['questionAr'];
    userId = json['userId'];
    answer = json['answer'];
    questionId = json['questionId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question'] = this.question;
    data['questionAr'] = this.questionAr;
    data['userId'] = this.userId;
    data['answer'] = this.answer;
    data['questionId'] = this.questionId;
    return data;
  }
}
