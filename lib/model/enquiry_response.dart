// import 'dart:convert';

import 'package:slc/model/facility_detail_item_response.dart';
// import 'package:slc/model/facility_item.dart';

class EnquiryDetailResponse {
  String firstName;
  String firstName_Arabic;
  String lastName;
  String lastName_Arabic;
  int genderId;
  String DOB;
  int nationalityId;
  int countryId;
  String enquiryDate;
  int enquiryStatusId;
  int userID;
  bool isActive;
  int enquiryTypeId;
  int facilityId;
  int facilityItemId;
  String facilityItemName;
  String faclitiyItemDescription;
  double price;
  double vatPercentage;
  String facilityImageName;
  String facilityImageUrl;
  int enquiryDetailId;
  String comments;
  List<SupportDocuments> supportDocuments;
  List<EnquiryContacts> contacts;
  String emiratesID;
  String address;
  String languages;
  String preferedTime;
  FacilityItems facilityItem;
  int enquiryProcessId;
  int erpCustomerId;
  double rate;
  int totalClass;
  int consumedClass;
  int balanceClass;
  //bool isDiscountable;

  EnquiryDetailResponse(
      {this.firstName,
      this.firstName_Arabic,
      this.lastName,
      this.lastName_Arabic,
      this.genderId,
      this.DOB,
      this.nationalityId,
      this.countryId,
      this.enquiryDate,
      this.enquiryStatusId,
      this.userID,
      this.isActive,
      this.enquiryTypeId,
      this.facilityId,
      this.facilityItemId,
      this.facilityItemName,
      this.faclitiyItemDescription,
      this.price,
      this.vatPercentage,
      this.facilityImageName,
      this.facilityImageUrl,
      this.enquiryDetailId,
      this.supportDocuments,
      this.comments,
      this.contacts,
      this.emiratesID,
      this.address,
      this.languages,
      this.preferedTime,
      this.facilityItem,
      this.enquiryProcessId,
      this.erpCustomerId,
      this.rate,
      this.totalClass,
      this.consumedClass,
      this.balanceClass});

  EnquiryDetailResponse.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    firstName_Arabic = json['firstName_Arabic'];
    lastName = json['lastName'];
    lastName_Arabic = json['lastName_Arabic'];
    genderId = json['genderId'];
    DOB = json['dob'];
    nationalityId = json['nationalityId'];
    countryId = json['countryId'];
    enquiryDate = json['enquiryDate'];
    enquiryStatusId = json['enquiryStatusId'];
    userID = json['userID'];
    isActive = json['isActive'];
    enquiryTypeId = json['enquiryTypeId'];
    facilityId = json['facilityId'];
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    faclitiyItemDescription = json['faclitiyItemDescription'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
    facilityImageName = json['facilityImageName'];
    facilityImageUrl = json['facilityImageUrl'];
    enquiryDetailId = json['enquiryDetailId'];
    enquiryProcessId = json['enquiryProcessId'];
    erpCustomerId = json['erpCutomerId'];
    totalClass = json['totalClass'];
    consumedClass = json['consumedClass'];
    balanceClass = json['balanceClass'];
    if (json['supportDocuments'] != null) {
      supportDocuments = [];
      json['supportDocuments'].forEach((v) {
        supportDocuments.add(new SupportDocuments.fromJson(v));
      });
    }
    comments = json['Comments'];
    if (json['contacts'] != null) {
      contacts = [];
      json['contacts'].forEach((v) {
        contacts.add(new EnquiryContacts.fromJson(v));
      });
    }
    emiratesID = json['EmiratesID'];
    address = json['Address'];
    languages = json['Languages'];
    preferedTime = json['PreferedTime'];
    if (json['facilityItem'] != null) {
      // debugPrint(json['facilityItem'].toString());
      facilityItem = new FacilityItems.fromJson(json['facilityItem']);
      //facilityItem = json['facilityItem'];
    }
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['firstName_Arabic'] = this.firstName_Arabic;
    data['lastName'] = this.lastName;
    data['lastName_Arabic'] = this.lastName_Arabic;
    data['genderId'] = this.genderId;
    data['DOB'] = this.DOB;
    data['nationalityId'] = this.nationalityId;
    data['countryId'] = this.countryId;
    data['enquiryDate'] = this.enquiryDate;
    data['enquiryStatusId'] = this.enquiryStatusId;
    data['userID'] = this.userID;
    data['isActive'] = this.isActive;
    data['enquiryTypeId'] = this.enquiryTypeId;
    data['facilityId'] = this.facilityId;
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['faclitiyItemDescription'] = this.faclitiyItemDescription;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    data['facilityImageName'] = this.facilityImageName;
    data['facilityImageUrl'] = this.facilityImageUrl;
    data['enquiryDetailId'] = this.enquiryDetailId;
    if (this.supportDocuments != null) {
      data['supportDocuments'] =
          this.supportDocuments.map((v) => v.toJson()).toList();
    }
    data['Comments'] = this.comments;
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    data['emiratesID'] = this.emiratesID;
    data['address'] = this.address;
    data['languages'] = this.languages;
    data['preferedTime'] = this.preferedTime;
    if (this.facilityItem != null) {
      data['facilityItem'] = this.facilityItem.toJson();
    }
    data['enquiryProcessId'] = this.enquiryProcessId;
    data['erpCustomerId'] = this.erpCustomerId;
    data['rate'] = this.rate;
    data['totalClass'] = this.totalClass;
    data['consumedClass'] = this.consumedClass;
    data['balanceClass'] = this.balanceClass;
    return data;
  }
}

class SupportDocuments {
  String documentFileName;
  int supportDocumentId;

  SupportDocuments({
    this.documentFileName,
    this.supportDocumentId,
  });

  SupportDocuments.fromJson(Map<String, dynamic> json) {
    documentFileName = json['documentFileName'];
    supportDocumentId = json['supportDocumentID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentFileName'] = this.documentFileName;
    data['SupportDocumentId'] = this.supportDocumentId;
    return data;
  }
}

class EnquiryContacts {
  int contactId;
  String contactName;
  String relation;
  String mobileNo;
  String emailId;

  EnquiryContacts(
      {this.contactId,
      this.contactName,
      this.relation,
      this.mobileNo,
      this.emailId});

  EnquiryContacts.fromJson(Map<String, dynamic> json) {
    contactId = json['contactId'];
    contactName = json['contactName'];
    relation = json['relation'];
    mobileNo = json['mobileNo'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactId'] = this.contactId;
    data['contactName'] = this.contactName;
    data['relation'] = this.relation;
    data['mobileNo'] = this.mobileNo;
    data['emailId'] = this.emailId;
    return data;
  }
}

class FamilyMember {
  int customerId;
  String memberName;
  String dateOfBirth;
  FamilyMember({
    this.customerId,
    this.memberName,
    this.dateOfBirth,
  });
  FamilyMember.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    memberName = json['memberName'];
    dateOfBirth = json['dateOfBirth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['memberName'] = this.memberName;
    data['dateOfBirth'] = this.dateOfBirth;
    return data;
  }
}

class FamilyMemberList {
  List<FamilyMember> familyDetails;
  FamilyMemberList({this.familyDetails});

  FamilyMemberList.fromJson(Map<String, dynamic> json) {
    if (json['familyDetails'] != null) {
      familyDetails = [];
      json['familyDetails'].forEach((v) {
        familyDetails.add(new FamilyMember.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.familyDetails != null) {
      data['familyDetails'] =
          this.familyDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
