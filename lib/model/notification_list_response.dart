class NotificationListResponse {
  int notificationUserId;
  int notificationId;
  String title;
  String message;
  String shortMessage;
  int userId;
  int notificationTypeId;
  int navigationTypeId;
  String notificationType;
  String notificationTypeImageUrl;
  String imageUrl;
  String webNavigationUrl;
  bool isRead;
  String createdDate;
  bool isImageAvailable;
  int applicationModuleId;
  int referenceId;
  String viewMoreButtonName;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  NotificationListResponse(
      {this.notificationUserId,
      this.notificationId,
      this.title,
      this.message,
      this.shortMessage,
      this.userId,
      this.notificationTypeId,
      this.navigationTypeId,
      this.notificationType,
      this.notificationTypeImageUrl,
      this.imageUrl,
      this.webNavigationUrl,
      this.isRead,
      this.createdDate,
      this.isImageAvailable,
      this.applicationModuleId,
      this.referenceId,
      this.viewMoreButtonName,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  NotificationListResponse.fromJson(Map<String, dynamic> json) {
    notificationUserId = json['notificationUserId'];
    notificationId = json['notificationId'];
    title = json['title'];
    message = json['message'];
    shortMessage = json['shortMessage'];
    userId = json['userId'];
    notificationTypeId = json['notificationTypeId'];
    navigationTypeId = json['navigationTypeId'];
    notificationType = json['notificationType'];
    notificationTypeImageUrl = json['notificationTypeImageUrl'];
    imageUrl = json['imageUrl'];
    webNavigationUrl = json['webNavigationUrl'];
    isRead = json['isRead'];
    createdDate = json['createdDate'];
    isImageAvailable = json['isImageAvailable'];
    applicationModuleId = json['applicationModuleId'];
    referenceId = json['referenceId'];
    viewMoreButtonName = json['viewMoreButtonName'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notificationUserId'] = this.notificationUserId;
    data['notificationId'] = this.notificationId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['shortMessage'] = this.shortMessage;
    data['userId'] = this.userId;
    data['notificationTypeId'] = this.notificationTypeId;
    data['navigationTypeId'] = this.navigationTypeId;
    data['notificationType'] = this.notificationType;
    data['notificationTypeImageUrl'] = this.notificationTypeImageUrl;
    data['imageUrl'] = this.imageUrl;
    data['webNavigationUrl'] = this.webNavigationUrl;
    data['isRead'] = this.isRead;
    data['createdDate'] = this.createdDate;
    data['isImageAvailable'] = this.isImageAvailable;
    data['applicationModuleId'] = this.applicationModuleId;
    data['referenceId'] = this.referenceId;
    data['viewMoreButtonName'] = this.viewMoreButtonName;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}
