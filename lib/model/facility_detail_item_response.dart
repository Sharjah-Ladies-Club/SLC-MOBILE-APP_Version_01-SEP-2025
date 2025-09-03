class FacilityDetailItem {
  int facilityItemGroupId;
  String facilityItemGroup;
  List<FacilityItems> facilityItems;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  FacilityDetailItem(
      {this.facilityItemGroupId,
      this.facilityItemGroup,
      this.facilityItems,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  FacilityDetailItem.fromJson(Map<String, dynamic> json) {
    facilityItemGroupId = json['facilityItemGroupId'];
    facilityItemGroup = json['facilityItemGroup'];
    if (json['facilityItems'] != null) {
      facilityItems = [];
      json['facilityItems'].forEach((v) {
        facilityItems.add(new FacilityItems.fromJson(v));
      });
    }
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemGroupId'] = this.facilityItemGroupId;
    data['facilityItemGroup'] = this.facilityItemGroup;
    if (this.facilityItems != null) {
      data['facilityItems'] =
          this.facilityItems.map((v) => v.toJson()).toList();
    }
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}

class FacilityItems {
  int facilityItemId;
  int facilityId;
  String facilityName;
  String itemId;
  String facilityItemName;
  String facilityItemNameArabic;
  String description;
  String descriptionArabic;
  bool isBookable;
  bool isShow;
  bool isPromotional;
  int displayOrder;
  bool isActive;
  double price;
  int mobileItemCategoryId;
  String mobileItemCategory;
  int facilityItemGroupId;
  String facilityItemGroupName;
  int itemTypeId;
  String itemTypeName;
  String bridgeItemCode;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;
  double rate;
  double vatPercentage;
  bool isDiscountable;

  FacilityItems(
      {this.facilityItemId,
      this.facilityId,
      this.facilityName,
      this.itemId,
      this.facilityItemName,
      this.facilityItemNameArabic,
      this.description,
      this.descriptionArabic,
      this.isBookable,
      this.isShow,
      this.isPromotional,
      this.displayOrder,
      this.isActive,
      this.price,
      this.mobileItemCategoryId,
      this.mobileItemCategory,
      this.facilityItemGroupId,
      this.facilityItemGroupName,
      this.itemTypeId,
      this.itemTypeName,
      this.bridgeItemCode,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.rate,
      this.vatPercentage = 0,
      this.isDiscountable = false});

  FacilityItems.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    itemId = json['itemId'] != null ? json['itemId'].toString() : "0";
    facilityItemName = json['facilityItemName'];
    facilityItemNameArabic = json['facilityItemName_Arabic'];
    description = json['description'];
    descriptionArabic = json['description_Arabic'];
    isBookable = json['isBookable'];
    isShow = json['isShow'];
    isPromotional = json['isPromotional'];
    displayOrder = json['displayOrder'];
    isActive = json['isActive'];
    price = json['price'];
    mobileItemCategoryId = json['mobileItemCategoryId'];
    mobileItemCategory = json['mobileItemCategory'];
    facilityItemGroupId = json['facilityItemGroupId'];
    facilityItemGroupName = json['facilityItemGroupName'];
    itemTypeId = json['itemTypeId'];
    itemTypeName = json['itemTypeName'];
    bridgeItemCode = json['bridgeItemCode'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    rate = json['rate'];
    isDiscountable = json['isDiscountable'];
    vatPercentage = 5;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['facilityId'] = this.facilityId;
    data['facilityName'] = this.facilityName;
    data['itemId'] = this.itemId;
    data['facilityItemName'] = this.facilityItemName;
    data['facilityItemName_Arabic'] = this.facilityItemNameArabic;
    data['description'] = this.description;
    data['description_Arabic'] = this.descriptionArabic;
    data['isBookable'] = this.isBookable;
    data['isShow'] = this.isShow;
    data['isPromotional'] = this.isPromotional;
    data['displayOrder'] = this.displayOrder;
    data['isActive'] = this.isActive;
    data['price'] = this.price;
    data['mobileItemCategoryId'] = this.mobileItemCategoryId;
    data['mobileItemCategory'] = this.mobileItemCategory;
    data['facilityItemGroupId'] = this.facilityItemGroupId;
    data['facilityItemGroupName'] = this.facilityItemGroupName;
    data['itemTypeId'] = this.itemTypeId;
    data['itemTypeName'] = this.itemTypeName;
    data['bridgeItemCode'] = this.bridgeItemCode;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['rate'] = this.rate;
    return data;
  }
}
