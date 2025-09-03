import 'dart:core';

import 'package:slc/model/knooz_response_dto.dart';
import 'package:slc/model/transaction_response.dart';

class FacilityDetailResponse {
  int facilityId;
  String facilityName;
  String facilityNameArabic;
  int facilityDisplayOrder;
  int facilityGroupId;
  String facilityGroupName;
  int displayOrder;
  String facilityImageURL;
  String facilityOrderImageURL;
  bool isActive;
  bool isView;
  bool isDefault;
  String contentOverview;
  String contentOverviewArabic;
  String contentContactUs;
  String contentContactUsArabic;
  List<TabList> tabList;
  List<ContactList> contactList;
  String encryptedUserId;
  LoginUserIdDto loginUserIdDto;
  List<ImageList> imageList;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;
  String colorCode;
  bool isClosed;
  List<ImageVRDto> imageVR;
  List<CateringType> cateringTypeList;
  List<KunoozBookingListDto> partyHallEnquiryList;

  List<ReviewsResponse> reviews;
  List<FitnessUIDto> fitnessUI;
  List<FacilityMembership> memberShipDetail;
  MembershipClassAvailDto classAvailDetail;
  SLCMemberships slcMembership;
  bool showViewConsultation;
  FacilityDetailResponse(
      {this.facilityId,
      this.facilityName,
      this.facilityNameArabic,
      this.facilityDisplayOrder,
      this.facilityGroupId,
      this.facilityGroupName,
      this.displayOrder,
      this.facilityImageURL,
      this.facilityOrderImageURL,
      this.isActive,
      this.isView,
      this.isDefault,
      this.contentOverview,
      this.contentOverviewArabic,
      this.contentContactUs,
      this.contentContactUsArabic,
      this.tabList,
      this.contactList,
      this.encryptedUserId,
      this.loginUserIdDto,
      this.imageList,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.colorCode,
      this.isClosed,
      this.imageVR,
      this.cateringTypeList,
      this.partyHallEnquiryList,
      this.reviews,
      this.fitnessUI,
      this.slcMembership,
      this.memberShipDetail,
      this.classAvailDetail,
      this.showViewConsultation = false});

  FacilityDetailResponse.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    facilityNameArabic = json['facilityName_Arabic'];
    facilityDisplayOrder = json['facilityDisplayOrder'];
    facilityGroupId = json['facilityGroupId'];
    facilityGroupName = json['facilityGroupName'];
    displayOrder = json['displayOrder'];
    facilityImageURL = json['facilityImageURL'];
    facilityOrderImageURL = json['facilityOrderImageURL'];
    isActive = json['isActive'];
    isView = json['isView'];
    isDefault = json['isDefault'];
    contentOverview = json['content_Overview'];
    contentOverviewArabic = json['content_Overview_Arabic'];
    contentContactUs = json['content_ContactUs'];
    contentContactUsArabic = json['content_ContactUs_Arabic'];
    colorCode = json['colorCode'];
    isClosed = json['isClosed'];
    if (json['tabList'] != null) {
      tabList = [];
      json['tabList'].forEach((v) {
        tabList.add(new TabList.fromJson(v));
      });
    }
    if (json['contactList'] != null) {
      contactList = [];
      json['contactList'].forEach((v) {
        contactList.add(new ContactList.fromJson(v));
      });
    }
    if (json['cateringTypeList'] != null) {
      cateringTypeList = [];
      json['cateringTypeList'].forEach((v) {
        cateringTypeList.add(new CateringType.fromJson(v));
      });
    }

    if (json['partyHallEnquiryList'] != null) {
      partyHallEnquiryList = [];
      json['partyHallEnquiryList'].forEach((v) {
        partyHallEnquiryList.add(new KunoozBookingListDto.fromJson(v));
      });
    }

    encryptedUserId = json['encryptedUserId'];
    loginUserIdDto = json['loginUserIdDto'] != null
        ? new LoginUserIdDto.fromJson(json['loginUserIdDto'])
        : null;
    if (json['imageList'] != null) {
      imageList = [];
      json['imageList'].forEach((v) {
        if (!v['isDefault']) {
          imageList.add(new ImageList.fromJson(v));
        }
      });
    }
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    if (json['imageVR'] != null) {
      imageVR = [];
      json['imageVR'].forEach((v) {
        imageVR.add(new ImageVRDto.fromJson(v));
      });
    }
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews.add(new ReviewsResponse.fromJson(v));
      });
    }
    if (json['fitnessUI'] != null) {
      fitnessUI = [];
      json['fitnessUI'].forEach((v) {
        fitnessUI.add(new FitnessUIDto.fromJson(v));
      });
    }

    slcMembership = json['fitnessMemberShipDetail'] != null
        ? new SLCMemberships.fromJson(json['slcMembership'])
        : null;
    classAvailDetail = json['classAvailDetail'] != null
        ? new MembershipClassAvailDto.fromJson(json['classAvailDetail'])
        : null;
    if (json['memberShipDetail'] != null) {
      memberShipDetail = [];
      json['memberShipDetail'].forEach((v) {
        memberShipDetail.add(new FacilityMembership.fromJson(v));
      });
    }
    showViewConsultation = json['showViewConsultation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['facilityName'] = this.facilityName;
    data['facilityName_Arabic'] = this.facilityNameArabic;
    data['facilityDisplayOrder'] = this.facilityDisplayOrder;
    data['facilityGroupId'] = this.facilityGroupId;
    data['facilityGroupName'] = this.facilityGroupName;
    data['displayOrder'] = this.displayOrder;
    data['facilityImageURL'] = this.facilityImageURL;
    data['facilityOrderImageURL'] = this.facilityOrderImageURL;
    data['isActive'] = this.isActive;
    data['isView'] = this.isView;
    data['isDefault'] = this.isDefault;
    data['content_Overview'] = this.contentOverview;
    data['content_Overview_Arabic'] = this.contentOverviewArabic;
    data['content_ContactUs'] = this.contentContactUs;
    data['content_ContactUs_Arabic'] = this.contentContactUsArabic;
    data['colorCode'] = this.colorCode;
    data['isClosed'] = this.isClosed;
    data['showViewConsultation'] = this.showViewConsultation;
    if (this.tabList != null) {
      data['tabList'] = this.tabList.map((v) => v.toJson()).toList();
    }
    if (this.contactList != null) {
      data['contactList'] = this.contactList.map((v) => v.toJson()).toList();
    }
    data['encryptedUserId'] = this.encryptedUserId;
    if (this.loginUserIdDto != null) {
      data['loginUserIdDto'] = this.loginUserIdDto.toJson();
    }
    if (this.imageList != null) {
      data['imageList'] = this.imageList.map((v) => v.toJson()).toList();
    }
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    if (this.imageVR != null) {
      data['imageVR'] = this.imageVR.map((v) => v.toJson()).toList();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    if (this.fitnessUI != null) {
      data['fitnessUI'] = this.fitnessUI.map((v) => v.toJson()).toList();
    }

    if (this.cateringTypeList != null) {
      data['cateringTypeList'] =
          this.cateringTypeList.map((v) => v.toJson()).toList();
    }
    if (this.partyHallEnquiryList != null) {
      data['partyHallEnquiryList'] =
          this.partyHallEnquiryList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TabList {
  int mobileCategoryId;
  String mobileCategoryName;
  bool isGallery;
  bool isHall;
  bool isReview;
  bool isFitness;
  bool isProfile;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  TabList(
      {this.mobileCategoryId,
      this.mobileCategoryName,
      this.isGallery,
      this.isHall,
      this.isReview,
      this.isFitness,
      this.isProfile,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  TabList.fromJson(Map<String, dynamic> json) {
    mobileCategoryId = json['mobileCategoryId'];
    mobileCategoryName = json['mobileCategoryName'];
    isGallery = json['isGallery'];
    isHall = json['isHall'];
    isReview = json['isReview'];
    isFitness = json['isFitness'];
    isProfile = json['isProfile'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mobileCategoryId'] = this.mobileCategoryId;
    data['mobileCategoryName'] = this.mobileCategoryName;
    data['isGallery'] = this.isGallery;
    data['isHall'] = this.isHall;
    data['isReview'] = this.isReview;
    data['isFitness'] = this.isFitness;
    data['isProfile'] = this.isProfile;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}

class PartyHallEnquiryList {
  int partyHallEnquiryId;
  int eventTypeId;
  String eventName;
  int vneueTypeId;
  String vneueTypeName;
  String eventDate;
  String eventTime;
  int statusId;
  String statusName;

  PartyHallEnquiryList(
      {this.partyHallEnquiryId,
      this.eventTypeId,
      this.eventName,
      this.vneueTypeId,
      this.vneueTypeName,
      this.eventDate,
      this.eventTime,
      this.statusId,
      this.statusName});

  PartyHallEnquiryList.fromJson(Map<String, dynamic> json) {
    partyHallEnquiryId = json['partyHallEnquiryId'];
    eventTypeId = json['eventTypeId'];
    eventName = json['eventName'];
    vneueTypeId = json['vneueTypeId'];
    vneueTypeName = json['vneueTypeName'];
    eventDate = json['eventDate'];
    eventTime = json['eventTime'];
    statusId = json['statusId'];
    statusName = json['statusName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partyHallEnquiryId'] = this.partyHallEnquiryId;
    data['eventTypeId'] = this.eventTypeId;
    data['eventName'] = this.eventName;
    data['vneueTypeId'] = this.vneueTypeId;
    data['vneueTypeName'] = this.vneueTypeName;
    data['eventDate'] = this.eventDate;
    data['eventTime'] = this.eventTime;
    data['statusId'] = this.statusId;
    data['statusName'] = this.statusName;
    return data;
  }
}

class CateringType {
  int id;
  String cateringName;

  CateringType({
    this.id,
    this.cateringName,
  });

  CateringType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cateringName = json['cateringName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cateringName'] = this.cateringName;
    return data;
  }
}

class ContactList {
  int facilityId;
  int contactTypeId;
  String contactType;
  String contactValue;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;
  String defaultText;

  ContactList(
      {this.facilityId,
      this.contactTypeId,
      this.contactType,
      this.contactValue,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.defaultText});

  ContactList.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    contactTypeId = json['contactTypeId'];
    contactType = json['contactType'];
    contactValue = json['contactValue'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    defaultText = json['defaultText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['contactTypeId'] = this.contactTypeId;
    data['contactType'] = this.contactType;
    data['contactValue'] = this.contactValue;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['defaultText'] = this.defaultText;
    return data;
  }
}

class LoginUserIdDto {
  int userId;

  LoginUserIdDto({this.userId});

  LoginUserIdDto.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    return data;
  }
}

class ImageList {
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
  bool isLogo;

  ImageList(
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
      this.postStatus,
      this.isLogo});

  ImageList.fromJson(Map<String, dynamic> json) {
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
    isLogo = json['isLogo'];
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
    data['isLogo'] = this.isLogo;
    return data;
  }
}

class ImageVRDto {
  String imageName;
  String imageUrl;
  int displayOrder;
  int facilityItemId;
  bool ischecked;
  ImageVRDto(
      {this.imageName,
      this.imageUrl,
      this.displayOrder,
      this.ischecked,
      this.facilityItemId});

  ImageVRDto.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    displayOrder = json['displayOrder'];
    ischecked = json['ischecked'];
    facilityItemId = json['facilityItemId'];

    // if (json["checked"] != null) {
    //   checked = json['checked'];
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    data['imageUrl'] = this.imageUrl;
    data['displayOrder'] = this.displayOrder;
    data['ischecked'] = this.ischecked;
    data['facilityItemId'] = this.facilityItemId;
    return data;
  }
}

class ReviewsResponse {
  String comments;
  String rating;
  String ratingLogoUrl;
  String userName;
  String reviewDate;

  ReviewsResponse(
      {this.comments,
      this.rating,
      this.ratingLogoUrl,
      this.userName,
      this.reviewDate});

  ReviewsResponse.fromJson(Map<String, dynamic> json) {
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

class FitnessUIDto {
  String imageName;
  String imageUrl;
  int displayOrder;
  int totalCal;
  String mealPlan;

  FitnessUIDto(
      {this.imageName,
      this.imageUrl,
      this.displayOrder,
      this.totalCal,
      this.mealPlan});

  FitnessUIDto.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    imageUrl = json['imageUrl'];
    displayOrder = json['displayOrder'];
    totalCal = json['totalCal'];
    mealPlan = json['mealPlan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    data['imageUrl'] = this.imageUrl;
    data['displayOrder'] = this.displayOrder;
    data['totalCal'] = this.totalCal;
    data['mealPlan'] = this.mealPlan;
    return data;
  }
}

class FitnessUserVideos {
  int id;
  int fitnessScheduleId;
  int fitnessVideoId;
  String fitnessVideoName;
  String fitnessVideoDuration;
  String fitnessVideoDescription;
  String videoUrl;
  bool isActive;

  FitnessUserVideos(
      {this.id,
      this.fitnessScheduleId,
      this.fitnessVideoId,
      this.fitnessVideoName,
      this.fitnessVideoDuration,
      this.fitnessVideoDescription,
      this.videoUrl,
      this.isActive});

  FitnessUserVideos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fitnessScheduleId = json['fitnessScheduleId'];
    fitnessVideoId = json['fitnessVideoId'];
    fitnessVideoName = json['fitnessVideoName'];
    fitnessVideoDuration = json['fitnessVideoDuration'];
    fitnessVideoDescription = json['fitnessVideoDescription'];
    videoUrl = json['videoUrl'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fitnessScheduleId'] = this.fitnessScheduleId;
    data['fitnessVideoId'] = this.fitnessVideoId;
    data['fitnessVideoName'] = this.fitnessVideoName;
    data['fitnessVideoDuration'] = this.fitnessVideoDuration;
    data['fitnessVideoDescription'] = this.fitnessVideoDescription;
    data['videoUrl'] = this.videoUrl;
    data['isActive'] = this.isActive;
    return data;
  }
}

class FitnessUserDiet {
  int id;
  int fitnessScheduleId;
  int fitnessFoodId;
  String fitnessFoodName;
  String mealTime;
  int qty;
  String unit;
  String calorie;
  String proteien;
  String carb;
  String fat;
  int takenQty = 0;
  String takenCalorie = "0";
  bool isActive;

  FitnessUserDiet(
      {this.id,
      this.fitnessScheduleId,
      this.fitnessFoodId,
      this.fitnessFoodName,
      this.mealTime,
      this.qty,
      this.unit,
      this.calorie,
      this.proteien,
      this.carb,
      this.fat,
      this.isActive,
      this.takenQty = 0,
      this.takenCalorie = "0"});

  FitnessUserDiet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fitnessScheduleId = json['fitnessScheduleId'];
    fitnessFoodId = json['fitnessFoodId'];
    fitnessFoodName = json['fitnessFoodName'];
    mealTime = json['mealTime'];
    qty = json['qty'];
    unit = json['unit'];
    calorie = json['calorie'];
    proteien = json['proteien'];
    carb = json['carb'];
    fat = json['fat'];
    isActive = json['isActive'];
    takenQty = json['takenQty'] == null ? 0 : json['takenQty'];
    takenCalorie = json['takenCalorie'] == null ? "0" : json['takenCalorie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fitnessScheduleId'] = this.fitnessScheduleId;
    data['fitnessFoodId'] = this.fitnessFoodId;
    data['fitnessFoodName'] = this.fitnessFoodName;
    data['mealTime'] = this.mealTime;
    data['qty'] = this.qty;
    data['unit'] = this.unit;
    data['calorie'] = this.calorie;
    data['proteien'] = this.proteien;
    data['carb'] = this.carb;
    data['fat'] = this.fat;
    data['isActive'] = this.isActive;
    data['takenQty'] = this.takenQty;
    data['takenCalorie'] = this.takenCalorie;
    return data;
  }
}

class DietFollowUp {
  int id;
  int fitnessScheduleId;
  int fitnessFoodId;
  String mealTime;
  int qty;
  String calorie;
  String transDate;
  String comments;
  int fitnessUserDietId;

  DietFollowUp(
      {this.id,
      this.fitnessScheduleId,
      this.fitnessFoodId,
      this.mealTime,
      this.qty,
      this.calorie,
      this.transDate,
      this.comments,
      this.fitnessUserDietId});

  DietFollowUp.fromJson(Map<String, dynamic> json) {
    fitnessScheduleId = json['fitnessScheduleId'];
    fitnessFoodId = json['fitnessFoodId'];
    mealTime = json['mealTime'];
    qty = json['qty'];
    calorie = json['calorie'];
    transDate = json['transDate'];
    comments = json['comments'];
    fitnessUserDietId = json['fitnessUserDietId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fitnessScheduleId'] = this.fitnessScheduleId;
    data['fitnessFoodId'] = this.fitnessFoodId;
    data['mealTime'] = this.mealTime;
    data['qty'] = this.qty;
    data['calorie'] = this.calorie;
    data['transDate'] = this.transDate;
    data['comments'] = this.comments;
    data['fitnessUserDietId'] = this.fitnessUserDietId;
    return data;
  }
}

class FitnessUserDietEntry {
  List<DietFollowUp> dietFollowUp;
  FitnessUserDietEntry({this.dietFollowUp});

  FitnessUserDietEntry.fromJson(Map<String, dynamic> json) {
    if (json['dietFollowUp'] != null) {
      dietFollowUp = [];
      json['dietFollowUp'].forEach((v) {
        dietFollowUp.add(new DietFollowUp.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.dietFollowUp != null) {
      data['dietFollowUp'] = this.dietFollowUp.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FacilityMembership {
  int customerId;
  String customerName;
  int membershipId;
  String membershipCategory;
  String startDate;
  String endDate;
  String imageFile;
  String membershipStatus;
  String membershipType;
  int facilityItemId;
  String membershipName;
  String profileImage;
  int gym;
  int suna;
  int joinClass;
  int isCustomerBlocked = 0;
  String eN_MSG = "";
  String aR_MSG = "";

  FacilityMembership(
      {this.customerId,
      this.customerName,
      this.membershipId,
      this.membershipCategory,
      this.startDate,
      this.endDate,
      this.imageFile,
      this.membershipStatus,
      this.membershipType,
      this.facilityItemId,
      this.membershipName,
      this.profileImage,
      this.gym,
      this.suna,
      this.joinClass,
      this.isCustomerBlocked,
      this.eN_MSG,
      this.aR_MSG});

  FacilityMembership.fromJson(Map<String, dynamic> json) {
    customerId = json['customerId'];
    customerName = json['customerName'];
    membershipId = json['membershipId'];
    membershipCategory = json['membershipCategory'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    imageFile = json['imageFile'];
    membershipStatus = json['membershipStatus'];
    membershipType = json['membershipType'];
    facilityItemId = json['facilityItemId'];
    membershipName = json['membershipName'];
    profileImage = json['profileImage'];
    gym = json['gym'];
    suna = json['suna'];
    joinClass = json['joinClass'];
    isCustomerBlocked = json['isCustomerBlocked'];
    eN_MSG = json['eN_MSG'];
    aR_MSG = json['aR_MSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customerId'] = this.customerId;
    data['customerName'] = this.customerName;
    data['membershipId'] = this.membershipId;
    data['membershipCategory'] = this.membershipCategory;
    data['startDate'] = this.startDate;
    data['endDate'] = this.endDate;
    data['imageFile'] = this.imageFile;
    data['membershipStatus'] = this.membershipStatus;
    data['membershipType'] = this.membershipType;
    data['facilityItemId'] = this.facilityItemId;
    data['membershipName'] = this.membershipName;
    data['profileImage'] = this.profileImage;
    data['gym'] = this.gym;
    data['suna'] = this.suna;
    data['joinClass'] = this.joinClass;
    data['isCustomerBlocked'] = this.isCustomerBlocked;
    data['eN_MSG'] = this.eN_MSG;
    data['aR_MSG'] = this.aR_MSG;
    return data;
  }
}

class ClassTimeTable {
  List<ClassSlots> classSlots;
  List<TrainerProfile> trainersProfile;
  ClassTimeTable({this.classSlots, this.trainersProfile});

  ClassTimeTable.fromJson(Map<String, dynamic> json) {
    if (json['classSlots'] != null) {
      classSlots = [];
      json['classSlots'].forEach((v) {
        classSlots.add(new ClassSlots.fromJson(v));
      });
    }
    if (json['trainersProfile'] != null) {
      trainersProfile = [];
      json['trainersProfile'].forEach((v) {
        trainersProfile.add(new TrainerProfile.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.classSlots != null) {
      data['classSlots'] = this.classSlots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassBookingViewDto {
  List<ClassSlots> spaceSlots;
  List<ClassSlots> bookingSlots;

  ClassBookingViewDto({this.spaceSlots, this.bookingSlots});

  ClassBookingViewDto.fromJson(Map<String, dynamic> json) {
    if (json['spaceSlots'] != null) {
      spaceSlots = [];
      json['spaceSlots'].forEach((v) {
        spaceSlots.add(new ClassSlots.fromJson(v));
      });
    }
    if (json['bookingSlots'] != null) {
      bookingSlots = [];
      json['bookingSlots'].forEach((v) {
        bookingSlots.add(new ClassSlots.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bookingSlots != null) {
      data['bookingSlots'] = this.bookingSlots.map((v) => v.toJson()).toList();
    }
    if (this.spaceSlots != null) {
      data['spaceSlots'] = this.spaceSlots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ClassSlots {
  int classMasterId;
  int classId;
  String className;
  String classNameArabic;
  String classDetailsEnglish;
  String classDetailsArabic;
  String classDate;
  String classStartTime;
  String classEndTime;
  int classMaxParticipants;
  int classTrainerID;
  String classTrainerName;
  String classTrainerNameArabic;
  int noOfGuestBooked;
  int customerId;
  String status;
  int bookingId;
  String erpId;
  int facilityItemId;

  ClassSlots(
      {this.classMasterId,
      this.classId,
      this.className,
      this.classNameArabic,
      this.classDetailsEnglish,
      this.classDetailsArabic,
      this.classDate,
      this.classStartTime,
      this.classEndTime,
      this.classMaxParticipants,
      this.classTrainerID,
      this.classTrainerName,
      this.classTrainerNameArabic,
      this.noOfGuestBooked,
      this.customerId,
      this.status,
      this.bookingId,
      this.erpId,
      this.facilityItemId});

  ClassSlots.fromJson(Map<String, dynamic> json) {
    classMasterId = json['classMasterId'];
    classId = json['classId'];
    className = json['className'];
    classNameArabic = json['classNameArabic'];
    classDetailsEnglish = json['classDetailsEnglish'];
    classDetailsArabic = json['classDetailsArabic'];
    classDate = json['classDate'];
    classStartTime = json['classStartTime'];
    classEndTime = json['classEndTime'];
    classMaxParticipants = json['classMaxParticipants'];
    classTrainerID = json['classTrainerID'];
    classTrainerName = json['classTrainerName'];
    classTrainerNameArabic = json['classTrainerNameArabic'];
    noOfGuestBooked = json['noOfGuestBooked'];
    customerId = json['customerId'];
    status = json['status'];
    bookingId = json['bookingId'];
    erpId = json['erpId'];
    facilityItemId = json['facilityItemId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['classMasterId'] = this.classMasterId;
    data['classId'] = this.classId;
    data['className'] = this.className;
    data['classNameArabic'] = this.classNameArabic;
    data['classDetailsEnglish'] = this.classDetailsEnglish;
    data['classDetailsArabic'] = this.classDetailsArabic;
    data['classDate'] = this.classDate;
    data['classStartTime'] = this.classStartTime;
    data['classEndTime'] = this.classEndTime;
    data['classMaxParticipants'] = this.classMaxParticipants;
    data['classTrainerID'] = this.classTrainerID;
    data['classTrainerName'] = this.classTrainerName;
    data['classTrainerNameArabic'] = this.classTrainerNameArabic;
    data['noOfGuestBooked'] = this.noOfGuestBooked;
    data['customerId'] = this.customerId;
    data['status'] = this.status;
    data['bookingId'] = this.bookingId;
    data['erpId'] = this.erpId;
    data['facilityItemId'] = this.facilityItemId;
    return data;
  }
}

class FitnessTrainer {
  int trainersID;
  String trainer;
  String trainerImage;
  String trainerProfile;

  FitnessTrainer({
    this.trainersID,
    this.trainer,
    this.trainerImage,
    this.trainerProfile,
  });

  FitnessTrainer.fromJson(Map<String, dynamic> json) {
    trainersID = json['trainersID'];
    trainer = json['trainer'];
    trainerImage = json['trainerImage'];
    trainerProfile = json['trainerProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainersID'] = this.trainersID;
    data['trainer'] = this.trainer;
    data['trainerImage'] = this.trainerImage;
    data['trainerProfile'] = this.trainerProfile;
    return data;
  }
}

class QRResult {
  int isCheckedIn;
  String checkInDate;
  String checkOutDate;

  QRResult({this.isCheckedIn, this.checkInDate, this.checkOutDate});

  QRResult.fromJson(Map<String, dynamic> json) {
    isCheckedIn = json['isCheckedIn'];
    checkInDate = json['checkInDate'];
    checkOutDate = json['checkOutDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isCheckedIn'] = this.isCheckedIn;
    data['checkInDate'] = this.checkInDate;
    data['checkOutDate'] = this.checkOutDate;
    return data;
  }
}

class PackageDetails {
  int packageId;
  String packageName;
  int kassa_articleId;
  String startsFrom;
  String expires;
  int totalPackageCount = 0;
  int consumed = 0;
  PackageDetails(
      {this.packageId,
      this.packageName,
      this.kassa_articleId,
      this.startsFrom,
      this.expires,
      this.totalPackageCount,
      this.consumed});

  PackageDetails.fromJson(Map<String, dynamic> json) {
    packageId = json['packageId'];
    packageName = json['packageName'];
    kassa_articleId = json['kassa_articleId'];
    startsFrom = json['startsFrom'];
    expires = json['expires'];
    totalPackageCount = json['totalPackageCount'];
    consumed = json['consumed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['packageId'] = this.packageId;
    data['packageName'] = this.packageName;
    data['kassa_articleId'] = this.kassa_articleId;
    data['startsFrom'] = this.startsFrom;
    data['expires'] = this.expires;
    data['totalPackageCount'] = this.totalPackageCount;
    data['consumed'] = this.consumed;
    return data;
  }
}

class MyPackageBookingViewDto {
  List<ClassSlots> spaceSlots;
  List<PackageDetails> packageDetails;

  MyPackageBookingViewDto({this.spaceSlots, this.packageDetails});

  MyPackageBookingViewDto.fromJson(Map<String, dynamic> json) {
    if (json['spaceSlots'] != null) {
      spaceSlots = [];
      json['spaceSlots'].forEach((v) {
        spaceSlots.add(new ClassSlots.fromJson(v));
      });
    }
    if (json['packageDetails'] != null) {
      packageDetails = [];
      json['packageDetails'].forEach((v) {
        packageDetails.add(new PackageDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.packageDetails != null) {
      data['packageDetails'] =
          this.packageDetails.map((v) => v.toJson()).toList();
    }
    if (this.spaceSlots != null) {
      data['spaceSlots'] = this.spaceSlots.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MembershipClassAvailDto {
  int haveFitnessMemberShip;
  String memberShipContractId;
  String fitnessContractId;
  String fitnessStartDate;
  String fitnessEndDate;
  int availableVoucher;
  int totalVouchers;
  bool showBuyButton;
  int voucherRedemptionId;
  int gym;
  int steamSauna;
  int joinAClass;
  int isCustomerBlocked = 0;
  String eN_MSG = "";
  String aR_MSG = "";

  MembershipClassAvailDto(
      {this.haveFitnessMemberShip,
      this.memberShipContractId,
      this.fitnessContractId,
      this.fitnessStartDate,
      this.fitnessEndDate,
      this.availableVoucher,
      this.totalVouchers,
      this.showBuyButton,
      this.voucherRedemptionId,
      this.gym,
      this.steamSauna,
      this.joinAClass,
      this.isCustomerBlocked,
      this.eN_MSG,
      this.aR_MSG});

  MembershipClassAvailDto.fromJson(Map<String, dynamic> json) {
    haveFitnessMemberShip = json['haveFitnessMemberShip'];
    memberShipContractId = json['memberShipContractId'];
    fitnessContractId = json['fitnessContractId'];
    fitnessStartDate = json['fitnessStartDate'];
    fitnessEndDate = json['fitnessEndDate'];
    availableVoucher = json['availableVoucher'];
    totalVouchers = json['totalVouchers'];
    showBuyButton = json['showBuyButton'];
    voucherRedemptionId = json['voucherRedemptionId'];
    gym = json['gym'];
    steamSauna = json['steamSauna'];
    joinAClass = json['joinAClass'];
    isCustomerBlocked = json['isCustomerBlocked'];
    eN_MSG = json['eN_MSG'];
    aR_MSG = json['aR_MSG'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['haveFitnessMemberShip'] = this.haveFitnessMemberShip;
    data['memberShipContractId'] = this.memberShipContractId;
    data['fitnessContractId'] = this.fitnessContractId;
    data['fitnessStartDate'] = this.fitnessStartDate;
    data['fitnessEndDate'] = this.fitnessEndDate;
    data['availableVoucher'] = this.availableVoucher;
    data['totalVouchers'] = this.totalVouchers;
    data['showBuyButton'] = this.showBuyButton;
    data['voucherRedemptionId'] = this.voucherRedemptionId;
    data['gym'] = this.gym;
    data['steamSauna'] = this.steamSauna;
    data['joinAClass'] = this.joinAClass;
    data['isCustomerBlocked'] = this.isCustomerBlocked;
    data['eN_MSG'] = this.eN_MSG;
    data['aR_MSG'] = this.aR_MSG;
    return data;
  }
}

class SLCMemberships {
  MembershipClassAvailDto classAvailDetail;
  List<FacilityMembership> memberShipDetail;
  SLCMemberships({this.classAvailDetail, this.memberShipDetail});

  SLCMemberships.fromJson(Map<String, dynamic> json) {
    classAvailDetail = json['classAvailDetail'] != null
        ? MembershipClassAvailDto.fromJson(json['classAvailDetail'])
        : null;

    if (json['memberShipDetail'] != null) {
      memberShipDetail = [];
      json['memberShipDetail'].forEach((v) {
        memberShipDetail.add(FacilityMembership.fromJson(v));
      });
    }
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data["classAvailDetail"] = this.classAvailDetail;
  //   if (this.memberShipDetail != null) {
  //     data['memberShipDetail'] =
  //         this.memberShipDetail.map((v) => v.toJson()).toList();
  //   }
  //   return data;
  // }
}

class BookingIdResult {
  int bookingId;
  int loyaltyVoucherSlabId;
  int memberShipType;
  int transId;

  BookingIdResult(
      {this.bookingId,
      this.loyaltyVoucherSlabId,
      this.memberShipType,
      this.transId});

  BookingIdResult.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    loyaltyVoucherSlabId = json['loyaltyVoucherSlbaId'];
    memberShipType = json['memberShipType'];
    transId = json['transId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['loyaltyVoucherSlabId'] = this.loyaltyVoucherSlabId;
    data['memberShipType'] = this.memberShipType;
    data['transId'] = this.transId;
    return data;
  }
}

class ModuleDescription {
  int id;
  String descEn;
  String descAr;

  ModuleDescription({this.id, this.descEn, this.descAr});

  ModuleDescription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    descEn = json['descEn'];
    descAr = json['descAr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['descEn'] = this.descEn;
    data['descAr'] = this.descAr;
    return data;
  }
}
