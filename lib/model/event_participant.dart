import 'EventTempleteResponse.dart';

class EventParticipant {
  int eventId;
  int eventParticipantId;
  String firstName;
  String lastName;
  String qrCode;
  String gender;
  String email;
  String mobileNumber;
  String dateOfBirth;
  int genderId;
  bool hasAttendedEvent;
  bool isPaid;
  double amount;
  double paidAmount;
  String nationality;
  int eventPricingCategoryId;
  String eventPricingCategoryName;
  int nationalityId;
  int userId;
  int eventPropItemId;
  String eventPropItemName;
  List<EventTempleteResponse> eventTemplates;
  List<EventProdCategory> eventProducts;

  EventParticipant(
      {this.eventId,
      this.eventParticipantId,
      this.firstName,
      this.lastName,
      this.qrCode,
      this.gender,
      this.email,
      this.mobileNumber,
      this.dateOfBirth,
      this.genderId,
      this.hasAttendedEvent,
      this.isPaid,
      this.amount,
      this.paidAmount,
      this.nationality,
      this.eventPricingCategoryId,
      this.eventPricingCategoryName,
      this.nationalityId,
      this.userId,
      this.eventPropItemId,
      this.eventPropItemName});

  EventParticipant.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventParticipantId = json['eventParticipantId'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    qrCode = json['qrCode'];
    gender = json['gender'];
    email = json['email'];
    mobileNumber = json['mobileNumber'];
    dateOfBirth = json['dateOfBirth'];
    genderId = json['genderId'];
    hasAttendedEvent = json['hasAttendedEvent'];
    isPaid = json['isPaid'];
    amount = json['amount'];
    paidAmount = json['paidAmount'];
    nationality = json['nationality'];
    nationalityId = json['nationalityId'];
    eventPricingCategoryId = json['eventPricingCategoryId'];
    eventPricingCategoryName = json['eventPricingCategoryName'];
    userId = json['userId'];
    eventPropItemId = json['eventPropItemId'];
    eventPropItemName = json['eventPropItemName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['eventParticipantId'] = this.eventParticipantId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['qrCode'] = this.qrCode;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['mobileNumber'] = this.mobileNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['genderId'] = this.genderId;
    data['hasAttendedEvent'] = this.hasAttendedEvent;
    data['isPaid'] = this.isPaid;
    data['amount'] = this.amount;
    data['paidAmount'] = this.paidAmount;
    data['nationality'] = this.nationality;
    data['nationalityId'] = this.nationalityId;
    data['nationalityId'] = this.nationalityId;
    data['eventPricingCategoryId'] = this.eventPricingCategoryId;
    data['eventPricingCategoryName'] = this.eventPricingCategoryName;
    data['userId'] = this.userId;
    data['eventPropItemId'] = this.eventPropItemId;
    data['eventPropItemName'] = this.eventPropItemName;
    return data;
  }
}

class EventProdCategory {
  int id;
  String categoryName;

  EventProdCategory({
    this.id,
    this.categoryName,
  });

  EventProdCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
