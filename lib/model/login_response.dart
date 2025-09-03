class LoginResponse {
  String loginToken;
  int userId;
  String roleId;
  int roleTypeId;
  String name;
  String profileName;
  String email;
  bool isUnreadNotificationAvailable;
  String lastName;
  String mobileNumber;
  int genderId;
  String dateOfBirth;
  int nationalityId;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;
  int countryId;
  String countryName;
  String dialCode;
  int bridgeUserTypeId;
  String bridgeUserType;
  int bridgeUserCategoryId;
  String bridgeUserCategoryType;
  int customerId;
  int clubMembershipId;
  int fitnessMembershipId;
  int corporateId;
  int corporateStaffCategoryId;
  bool corporateFirstLogin;

  LoginResponse(
      {this.loginToken,
      this.userId,
      this.roleId,
      this.roleTypeId,
      this.name,
      this.profileName,
      this.email,
      this.isUnreadNotificationAvailable,
      this.lastName,
      this.mobileNumber,
      this.genderId,
      this.dateOfBirth,
      this.nationalityId,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.countryId,
      this.countryName,
      this.dialCode,
      this.bridgeUserType,
      this.bridgeUserTypeId,
      this.bridgeUserCategoryId,
      this.bridgeUserCategoryType,
      this.customerId,
      this.clubMembershipId,
      this.fitnessMembershipId,
      this.corporateId,
      this.corporateStaffCategoryId,
      this.corporateFirstLogin});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    loginToken = json['loginToken'];
    userId = json['userId'];
    roleId = json['roleId'];
    roleTypeId = json['roleTypeId'];
    name = json['name'];
    profileName = json['profileName'];
    email = json['email'];
    isUnreadNotificationAvailable = json['isUnreadNotificationAvailable'];
    lastName = json['lastName'];
    mobileNumber = json['mobileNumber'];
    genderId = json['genderId'];
    dateOfBirth = json['dateOfBirth'];
    nationalityId = json['nationalityId'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    countryId = json['countryId'];
    countryName = json['countryName'];
    dialCode = json['dialCode'];
    bridgeUserTypeId = json['bridgeUserTypeId'];
    bridgeUserType = json['bridgeUserType'];
    bridgeUserCategoryId = json['bridgeUserCategoryId'];
    bridgeUserCategoryType = json['bridgeUserCategoryType'];
    customerId = json['customerId'];
    clubMembershipId = json['clubMembershipId'];
    fitnessMembershipId = json['fitnessMembershipId'];
    corporateFirstLogin = json['corporateFirstLogin'];
    corporateStaffCategoryId = json['corporateStaffCategoryId'];
    corporateId = json['corporateId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loginToken'] = this.loginToken;
    data['userId'] = this.userId;
    data['roleId'] = this.roleId;
    data['roleTypeId'] = this.roleTypeId;
    data['name'] = this.name;
    data['profileName'] = this.profileName;
    data['email'] = this.email;
    data['isUnreadNotificationAvailable'] = this.isUnreadNotificationAvailable;
    data['lastName'] = this.lastName;
    data['mobileNumber'] = this.mobileNumber;
    data['genderId'] = this.genderId;
    data['dateOfBirth'] = this.dateOfBirth;
    data['nationalityId'] = this.nationalityId;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['countryName'] = this.countryName;
    data['countryId'] = this.countryId;
    data['dialCode'] = this.dialCode;
    data['bridgeUserTypeId'] = this.bridgeUserTypeId;
    data['bridgeUserType'] = this.bridgeUserType;
    data['bridgeUserCategoryType'] = this.bridgeUserCategoryType;
    data['bridgeUserCategoryId'] = this.bridgeUserCategoryId;
    data['customerId'] = this.customerId;
    data['clubMembershipId'] = this.clubMembershipId;
    data['fitnessMembershipId'] = this.fitnessMembershipId;
    data['corporateFirstLogin'] = this.corporateFirstLogin;
    data['corporateId'] = this.corporateId;
    data['corporateStaffCategoryId'] = this.corporateStaffCategoryId;
    return data;
  }
}
