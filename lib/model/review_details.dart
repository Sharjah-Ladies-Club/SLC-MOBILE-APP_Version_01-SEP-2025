class ReviewDetails {
  int reviewEventId;
  int eventId;
  bool isActive;
  double overAllRating;
  String overAllRatingText;
  EventBasicDetail eventBasicDetail;
  List<ReviewEventDetailsViewDtos> reviewEventDetailsViewDtos;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  ReviewDetails(
      {this.reviewEventId,
      this.eventId,
      this.isActive,
      this.overAllRating,
      this.overAllRatingText,
      this.eventBasicDetail,
      this.reviewEventDetailsViewDtos,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  ReviewDetails.fromJson(Map<String, dynamic> json) {
    reviewEventId = json['reviewEventId'];
    eventId = json['eventId'];
    isActive = json['isActive'];
    overAllRating = json['overAllRating'];
    overAllRatingText = json['overAllRatingText'];
    eventBasicDetail = json['eventBasicDetail'] != null
        ? new EventBasicDetail.fromJson(json['eventBasicDetail'])
        : null;
    if (json['reviewEventDetailsViewDtos'] != null) {
      reviewEventDetailsViewDtos = [];
      json['reviewEventDetailsViewDtos'].forEach((v) {
        reviewEventDetailsViewDtos
            .add(new ReviewEventDetailsViewDtos.fromJson(v));
      });
    }
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
    if (this.reviewEventDetailsViewDtos != null) {
      data['reviewEventDetailsViewDtos'] =
          this.reviewEventDetailsViewDtos.map((v) => v.toJson()).toList();
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
  List<ReviewDetailImageList> imageList;
  ReviewDetailImageList defaultImage;

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
      this.imageList,
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
    if (json['imageList'] != null) {
      imageList = [];
      json['imageList'].forEach((v) {
        imageList.add(new ReviewDetailImageList.fromJson(v));
      });
    }
    defaultImage = json['defaultImage'] != null
        ? new ReviewDetailImageList.fromJson(json['defaultImage'])
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
    if (this.imageList != null) {
      data['imageList'] = this.imageList.map((v) => v.toJson()).toList();
    }
    if (this.defaultImage != null) {
      data['defaultImage'] = this.defaultImage.toJson();
    }
    return data;
  }
}

class ReviewDetailImageList {
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

  ReviewDetailImageList(
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

  ReviewDetailImageList.fromJson(Map<String, dynamic> json) {
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

class ReviewEventDetailsViewDtos {
  String comments;
  String rating;
  String ratingLogoUrl;
  String userName;
  String reviewDate;

  ReviewEventDetailsViewDtos(
      {this.comments,
      this.rating,
      this.ratingLogoUrl,
      this.userName,
      this.reviewDate});

  ReviewEventDetailsViewDtos.fromJson(Map<String, dynamic> json) {
    comments = json['comments'];
    rating = json['rating'];
    ratingLogoUrl = json['ratingLogoUrl'];
    userName = json['userName'];
    reviewDate = json['reviewDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['comments'] = this.comments;
    data['rating'] = this.rating;
    data['ratingLogoUrl'] = this.ratingLogoUrl;
    data['userName'] = this.userName;
    data['reviewDate'] = this.reviewDate;
    return data;
  }
}
