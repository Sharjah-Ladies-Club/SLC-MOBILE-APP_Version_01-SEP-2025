import 'package:slc/model/enquiry_response.dart';

class UserProfileInfo {
  int userId;
  String mobileNumber;
  String email;
  String firstName;
  String lastName;
  String dateOfBirth;
  int genderId;
  int nationalityId;
  String dialCode;
  String bridgeUserType;
  int bridgeUserTypeId;
  String membershipNumber;
  String membershipContractNumber;
  String membershipStartDate;
  String membershipEndDate;
  bool membershipExpire;
  int facilityItemId;
  String facilityItemName;
  double price;
  double vatPercentage;
  int countryId;
  String membershipNationality;
  String emergencyContactNo;
  String emergencyContactName;
  String city;
  List<AssociatedProfileList> associatedProfileList;
  EnquiryDetailResponse enquiryDetail;
  int customerId;
  String bridgeUserCategoryType;
  int bridgeUserCategoryId;
  String profileImage;
  double rate;
  String profileCategory;
  String membershipTypeName;
  int isStaff;
  UserProfileInfo(
      {this.userId,
      this.mobileNumber,
      this.email,
      this.firstName,
      this.lastName,
      this.dateOfBirth,
      this.genderId,
      this.nationalityId,
      this.dialCode,
      this.bridgeUserType,
      this.bridgeUserTypeId,
      this.membershipNumber,
      this.membershipContractNumber,
      this.membershipStartDate,
      this.membershipEndDate,
      this.countryId,
      this.membershipExpire,
      this.facilityItemId,
      this.associatedProfileList,
      this.enquiryDetail,
      this.facilityItemName,
      this.price,
      this.vatPercentage,
      this.customerId,
      this.membershipNationality,
      this.emergencyContactNo,
      this.emergencyContactName,
      this.city,
      this.bridgeUserCategoryType,
      this.bridgeUserCategoryId,
      this.profileImage,
      this.rate,
      this.profileCategory,
      this.membershipTypeName,
      this.isStaff = 0});

  UserProfileInfo.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    dateOfBirth = json['dateOfBirth'];
    genderId = json['genderId'];
    nationalityId = json['nationalityId'];
    dialCode = json['dialCode'];
    bridgeUserType = json['bridgeUserType'];
    bridgeUserTypeId = json['bridgeUserTypeId'];
    membershipNumber = json['membershipNumber'];
    membershipContractNumber = json['membershipContractNumber'];
    membershipStartDate = json['membershipStartDate'];
    membershipEndDate = json['membershipEndDate'];
    countryId = json['countryId'];
    membershipExpire = json['membershipExpire'];
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
    customerId = json['customerId'];
    membershipNationality = json['membershipNationality'];
    emergencyContactNo = json['emergencyContactNo'];
    emergencyContactName = json['emergencyContactName'];
    bridgeUserCategoryType = json['bridgeUserCategoryType'];
    bridgeUserCategoryId = json['bridgeUserCategoryId'];
    city = json['city'];
    rate = json['rate'];
    profileImage = json['profileImage'];
    profileCategory = json['profileCategory'];
    membershipTypeName = json['membershipTypeName'];
    isStaff = json['isStaff'];
    if (json['associatedProfileList'] != null) {
      associatedProfileList = [];
      json['associatedProfileList'].forEach((v) {
        associatedProfileList.add(new AssociatedProfileList.fromJson(v));
      });
    }
    if (json['enquiryDetail'] != null) {
      enquiryDetail = new EnquiryDetailResponse.fromJson(json['enquiryDetail']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['dateOfBirth'] = this.dateOfBirth;
    data['genderId'] = this.genderId;
    data['nationalityId'] = this.nationalityId;
    data['dialCode'] = this.dialCode;
    data['bridgeUserType'] = this.bridgeUserType;
    data['bridgeUserTypeId'] = this.bridgeUserTypeId;
    data['membershipNumber'] = this.membershipNumber;
    data['membershipContractNumber'] = this.membershipContractNumber;
    data['membershipStartDate'] = this.membershipStartDate;
    data['membershipEndDate'] = this.membershipEndDate;
    data['countryId'] = this.countryId;
    data['membershipExpire'] = this.membershipExpire;
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    data['customerId'] = this.customerId;
    data['membershipNationality'] = this.membershipNationality;
    data['emergencyContactNo'] = this.emergencyContactNo;
    data['emergencyContactName'] = this.emergencyContactName;
    data['city'] = this.city;
    data['bridgeUserCategoryId'] = this.bridgeUserCategoryId;
    data['bridgeUserCategoryType'] = this.bridgeUserCategoryType;
    data['profileImage'] = this.profileImage;
    data['rate'] = this.rate;
    data['profileCategory'] = this.profileCategory;
    data['membershipTypeName'] = this.membershipTypeName;
    data['isStaff'] = this.isStaff;
    if (this.associatedProfileList != null) {
      data['associatedProfileList'] =
          this.associatedProfileList.map((v) => v.toJson()).toList();
    }
    if (this.enquiryDetail != null) {
      data['enquiryDetail'] = this.enquiryDetail.toJson();
    }
    return data;
  }
}

class AssociatedProfileList {
  int customerid;
  int parentContractID;
  int subContractID;
  String subContractTStatus;
  String subContractStartDate;
  String subContractEndDate;
  String subContractCategoryName;
  int facilityItemId;
  String facilityItemName;
  double vatPercentage;
  double price;
  double rate;
  String imageFile;

  AssociatedProfileList(
      {this.customerid,
      this.parentContractID,
      this.subContractID,
      this.subContractTStatus,
      this.subContractStartDate,
      this.subContractEndDate,
      this.subContractCategoryName,
      this.facilityItemId,
      this.facilityItemName,
      this.vatPercentage,
      this.price,
      this.rate,
      this.imageFile});

  AssociatedProfileList.fromJson(Map<String, dynamic> json) {
    customerid = json['customerid'];
    parentContractID = json['parent_ContractID'];
    subContractID = json['subContractID'];
    subContractTStatus = json['subContractTStatus'];
    subContractStartDate = json['subContractStartDate'];
    subContractEndDate = json['subContractEndDate'];
    subContractCategoryName = json['subContractCategoryName'];
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
    rate = json['rate'];
    imageFile = json['imageFile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerid'] = this.customerid;
    data['parent_ContractID'] = this.parentContractID;
    data['subContractID'] = this.subContractID;
    data['subContractTStatus'] = this.subContractTStatus;
    data['subContractStartDate'] = this.subContractStartDate;
    data['subContractEndDate'] = this.subContractEndDate;
    data['subContractCategoryName'] = this.subContractCategoryName;
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    data['rate'] = this.rate;
    data['imageFile'] = this.imageFile;
    return data;
  }
}
