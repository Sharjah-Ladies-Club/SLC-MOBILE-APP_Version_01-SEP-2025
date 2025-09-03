class ReviewListDetails {
  int reviewEventId;
  int eventId;
  bool isActive;
  double overAllRating;
  String overAllRatingText;
  EventBasicDetail eventBasicDetail;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  ReviewListDetails(
      {this.reviewEventId,
      this.eventId,
      this.isActive,
      this.overAllRating,
      this.overAllRatingText,
      this.eventBasicDetail,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  ReviewListDetails.fromJson(Map<String, dynamic> json) {
    reviewEventId = json['reviewEventId'];
    eventId = json['eventId'];
    isActive = json['isActive'];
    overAllRating = json['overAllRating'];
    overAllRatingText = json['overAllRatingText'];
    eventBasicDetail = json['eventBasicDetail'] != null
        ? new EventBasicDetail.fromJson(json['eventBasicDetail'])
        : null;
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewEventId'] = this.reviewEventId;
    data['eventId'] = this.eventId;
    data['isActive'] = this.isActive;
    data['overAllRating'] = this.overAllRating;
    data['overAllRatingText'] = this.overAllRatingText;
    if (this.eventBasicDetail != null) {
      data['eventBasicDetail'] = this.eventBasicDetail.toJson();
    }
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}

class EventBasicDetail {
  int userId;
  int eventId;
  String name;
  String shortDescription;
  String contentOverview;
  String startDate;
  String endDate;
  String dateRange;
  String startTime;
  String endTime;
  String timeRange;
  int capacity;
  bool isPaidEvent;
  bool isFreeForMembers;
  double price;
  String venue;
  String webURL;
  String facility;
  bool isRegisterAllowed;
  DefaultImage defaultImage;

  EventBasicDetail(
      {this.userId,
      this.eventId,
      this.name,
      this.shortDescription,
      this.contentOverview,
      this.startDate,
      this.endDate,
      this.dateRange,
      this.startTime,
      this.endTime,
      this.timeRange,
      this.capacity,
      this.isPaidEvent,
      this.isFreeForMembers,
      this.price,
      this.venue,
      this.webURL,
      this.facility,
      this.isRegisterAllowed,
      this.defaultImage});

  EventBasicDetail.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    eventId = json['eventId'];
    name = json['name'];
    shortDescription = json['shortDescription'];
    contentOverview = json['content_Overview'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    dateRange = json['dateRange'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    timeRange = json['timeRange'];
    capacity = json['capacity'];
    isPaidEvent = json['isPaidEvent'];
    isFreeForMembers = json['isFreeForMembers'];
    price = json['price'];
    venue = json['venue'];
    webURL = json['webURL'];
    facility = json['facility'];
    isRegisterAllowed = json['isRegisterAllowed'];
    defaultImage = json['defaultImage'] != null
        ? new DefaultImage.fromJson(json['defaultImage'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['eventId'] = this.eventId;
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['content_Overview'] = this.contentOverview;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['dateRange'] = this.dateRange;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['timeRange'] = this.timeRange;
    data['capacity'] = this.capacity;
    data['isPaidEvent'] = this.isPaidEvent;
    data['isFreeForMembers'] = this.isFreeForMembers;
    data['price'] = this.price;
    data['venue'] = this.venue;
    data['webURL'] = this.webURL;
    data['facility'] = this.facility;
    data['isRegisterAllowed'] = this.isRegisterAllowed;
    if (this.defaultImage != null) {
      data['defaultImage'] = this.defaultImage.toJson();
    }
    return data;
  }
}

class DefaultImage {
  String imageName;
  String imageUrl;
  int recordId;
  int fileCategoryId;
  int displayOrder;
  bool isDefault;
  bool isActive;
  int documentTypeId;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  DefaultImage(
      {this.imageName,
      this.imageUrl,
      this.recordId,
      this.fileCategoryId,
      this.displayOrder,
      this.isDefault,
      this.isActive,
      this.documentTypeId,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  DefaultImage.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    recordId = json['recordId'];
    fileCategoryId = json['fileCategoryId'];
    displayOrder = json['displayOrder'];
    isDefault = json['isDefault'];
    isActive = json['isActive'];
    documentTypeId = json['documentTypeId'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    data['imageUrl'] = this.imageUrl;
    data['recordId'] = this.recordId;
    data['fileCategoryId'] = this.fileCategoryId;
    data['displayOrder'] = this.displayOrder;
    data['isDefault'] = this.isDefault;
    data['isActive'] = this.isActive;
    data['documentTypeId'] = this.documentTypeId;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}
