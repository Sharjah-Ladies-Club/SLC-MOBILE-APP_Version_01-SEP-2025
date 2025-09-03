import 'event_pricing_category.dart';

class EventRegistrationRequest {
  int userId;
  String firstName;
  String lastName;
  int genderId;
  String dateOfBirth;
  int nationalityId;
  int countryCodeId;
  int eventId;
  String mobileNumber;
  String email;
  bool isAddMe;
  int eventPropItemId;

  List<EventPricingCategory> eventPricingCategoryList;

  EventRegistrationRequest(
      {this.userId,
      this.firstName,
      this.lastName,
      this.genderId,
      this.dateOfBirth,
      this.nationalityId,
      this.eventId,
      this.email,
      this.countryCodeId,
      this.mobileNumber,
      this.eventPricingCategoryList,
      this.isAddMe,
      this.eventPropItemId});

  EventRegistrationRequest.fromJson(Map<String, dynamic> json) {
    userId = json['UserId'];
    firstName = json['FirstName'];
    lastName = json['LastName'];
    genderId = json['GenderId'];
    dateOfBirth = json['DateOfBirth'];
    nationalityId = json['NationalityId'];
    eventId = json['eventId'];
    countryCodeId = json['countryId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    if (json['EventPricingCategoryList'] != null) {
      eventPricingCategoryList = [];
      json['EventPricingCategoryList'].forEach((v) {
        eventPricingCategoryList.add(new EventPricingCategory.fromJson(v));
      });
    }
    isAddMe = json['isAddMe'];
    eventPropItemId = json['eventPropItemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.userId;
    data['FirstName'] = this.firstName;
    data['LastName'] = this.lastName;
    data['GenderId'] = this.genderId;
    data['DateOfBirth'] = this.dateOfBirth;
    data['NationalityId'] = this.nationalityId;
    data['countryId'] = this.countryCodeId;
    data['eventId'] = this.eventId;
    data['email'] = this.email;

    data['mobileNumber'] = this.mobileNumber;
    if (this.eventPricingCategoryList != null) {
      data['EventPricingCategoryList'] =
          this.eventPricingCategoryList.map((v) => v.toJson()).toList();
    }
    data['isAddMe'] = this.isAddMe;
    data['eventPropItemId'] = this.eventPropItemId;
    return data;
  }
}
