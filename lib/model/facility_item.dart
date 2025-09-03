class FacilityItem {
  int facilityItemId;
  int facilityId;
  String facilityName;
  int itemId;
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
  String mobileItemCategoryId;
  String mobileItemCategory;
  int facilityItemGroupId;
  String facilityItemGroupName;
  int itemTypeId;
  String itemTypeName;
  String bridgeItemCode;
  String bridgeCategoryCode;
  int priceLevelId;
  int priceCategoryId;
  double vatPercentage;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;
  String imageUrl;
  int stock;
  double actualPrice;
  bool isDiscountable;
  double rate;
  bool isHoliday;
  bool isBanquet;
  bool isCatering;
  bool isPickup;
  double servicePercentage;
  double inServicePercentage;

  FacilityItem(
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
      this.bridgeCategoryCode,
      this.priceLevelId,
      this.priceCategoryId,
      this.vatPercentage,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus,
      this.imageUrl,
      this.stock,
      this.actualPrice,
      this.isDiscountable,
      this.rate,
      this.isHoliday,
      this.isBanquet,
      this.isCatering,
      this.isPickup,
      this.servicePercentage,
      this.inServicePercentage});

  FacilityItem.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    itemId = json['itemId'];
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
    // mobileItemCategoryId = json['mobileItemCategoryId'];
    mobileItemCategory = json['mobileItemCategory'];
    facilityItemGroupId = json['facilityItemGroupId'];
    facilityItemGroupName = json['facilityItemGroupName'];
    itemTypeId = json['itemTypeId'];
    itemTypeName = json['itemTypeName'];
    bridgeItemCode = json['bridgeItemCode'];
    bridgeCategoryCode = json['bridgeCategoryCode'];
    priceLevelId = json['priceLevelId'];
    priceCategoryId = json['priceCategoryId'];
    vatPercentage = json['vatPercentage'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
    imageUrl = json['imageUrl'];
    stock = json['stock'];
    actualPrice = json['actualPrice'];
    isDiscountable = json['isDiscountable'];
    rate = json['rate'];
    isHoliday = json['isHoliday'];
    isBanquet = json['isBanquet'];
    isCatering = json['isCatering'];
    isPickup = json['isPickup'];
    servicePercentage = json['servicePercentage'];
    inServicePercentage = json['inServicePercentage'];
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
    data['bridgeCategoryCode'] = this.bridgeCategoryCode;
    data['priceCategoryId'] = this.priceCategoryId;
    data['vatPercentage'] = this.vatPercentage;
    data['priceLevelId'] = this.priceLevelId;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    data['imageUrl'] = this.imageUrl;
    data['stock'] = this.stock;
    data['actualPrice'] = this.actualPrice;
    data['isDiscountable'] = this.isDiscountable;
    data['rate'] = this.rate;
    data['isHoliday'] = this.isHoliday;
    data['isBanquet'] = isBanquet;
    data['isCatering'] = isCatering;
    data['isPickup'] = isPickup;
    data['servicePercentage'] = servicePercentage;
    data['inServicePercentage'] = inServicePercentage;
    return data;
  }
}

class FacilityBeachRequest {
  int facilityItemId;
  String facilityItemName;
  int quantity;
  double price;
  double vatPercentage;
  String comments;

  FacilityBeachRequest(
      {this.facilityItemId,
      this.facilityItemName = "",
      this.quantity,
      this.price,
      this.vatPercentage,
      this.comments});

  FacilityBeachRequest.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    quantity = json['quantity'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
    comments = json['comments'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    data['comments'] = this.comments;
    return data;
  }
}

class FacilityRetailRequest {
  int facilityItemId;
  int quantity;
  double price;
  double vatPercentage;
  FacilityRetailRequest({
    this.facilityItemId,
    this.quantity,
    this.price,
    this.vatPercentage,
  });

  FacilityRetailRequest.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    quantity = json['quantity'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    return data;
  }
}

class PartyHallItemRequest {
  int facilityItemId;
  int quantity;
  double price;
  double vatPercentage;
  double servicePercent;
  PartyHallItemRequest({
    this.facilityItemId,
    this.quantity,
    this.price,
    this.vatPercentage,
    this.servicePercent,
  });

  PartyHallItemRequest.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    quantity = json['quantity'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
    servicePercent = json['servicePercent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    data['servicePercent'] = this.servicePercent;
    return data;
  }
}

class RetailOrderItems {
  String menuName;
  String facilityName;
  String description;
  String categoryImageUrl;
  int tableNo;
  int categoryId;
  double tipsAmount;
  List<FacilityItem> facilityItems;
  RetailOrderItems({this.menuName, this.facilityItems});

  RetailOrderItems.fromJson(Map<String, dynamic> json) {
    menuName = json['menuName'];
    facilityName = json['facilityName'];
    tableNo = json['tableNo'];
    description = json['description'];
    categoryImageUrl = json['categoryImageUrl'];
    categoryId = json['categoryId'];
    tipsAmount = json['tipsAmount'];
    if (json['retailItems'] != null) {
      facilityItems = [];
      json['retailItems'].forEach((v) {
        facilityItems.add(new FacilityItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['menuName'] = this.menuName;
    data['facilityName'] = facilityName;
    data['tableNo'] = this.tableNo;
    data['description'] = this.description;
    data['categoryImageUrl'] = this.categoryImageUrl;
    data['categoryId'] = this.categoryId;
    data['tipsAmount'] = this.tipsAmount;
    if (this.facilityItems != null) {
      data['retailItems'] = this.facilityItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RetailOrderItemsCategory {
  List<RetailOrderItems> retailCategoryItems;
  int facilityId;
  String colorCode;
  bool isOpen;
  RetailOrderItemsCategory({this.retailCategoryItems});

  RetailOrderItemsCategory.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    colorCode = json['colorCode'];
    isOpen = json['isOpen'];
    if (json['retailCategoryItems'] != null) {
      retailCategoryItems = [];
      json['retailCategoryItems'].forEach((v) {
        retailCategoryItems.add(new RetailOrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['colorCode'] = this.colorCode;
    data['facilityId'] = this.facilityId;
    data['isOpen'] = this.isOpen;
    if (this.retailCategoryItems != null) {
      data['retailCategoryItems'] =
          this.retailCategoryItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DeliveryAddress {
  int deliveryAddressId;
  int userId;
  String streetName;
  String landmark;
  String city;
  String contactNo;
  String deliveryNotes;

  DeliveryAddress({
    this.deliveryAddressId,
    this.userId,
    this.streetName,
    this.landmark,
    this.city,
    this.contactNo,
    this.deliveryNotes,
  });

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    deliveryAddressId = json['deliveryAddressId'];
    userId = json['userId'];
    streetName = json['streetName'];
    landmark = json['landmark'];
    city = json['city'];
    contactNo = json['contactNo'];
    deliveryNotes = json['deliveryNotes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryAddressId'] = this.deliveryAddressId;
    data['userId'] = this.userId;
    data['streetName'] = this.streetName;
    data['landmark'] = this.landmark;
    data['city'] = this.city;
    data['contactNo'] = this.contactNo;
    data['deliveryNotes'] = this.deliveryNotes;
    return data;
  }
}

class DeliveryCharges {
  String cityName;
  int facilityItemCode;
  double price;
  double vatPercentage;

  DeliveryCharges({
    this.cityName,
    this.facilityItemCode,
    this.price,
    this.vatPercentage,
  });

  DeliveryCharges.fromJson(Map<String, dynamic> json) {
    cityName = json['cityName'];
    facilityItemCode = json['facilityItemCode'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityName'] = this.cityName;
    data['facilityItemCode'] = this.facilityItemCode;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    return data;
  }
}

class BillDiscounts {
  int discountId;
  String discountName;
  int discountType;
  double discountValue;
  double minBillAmount;
  int voucherType;
  int billDiscountId;

  BillDiscounts(
      {this.discountId,
      this.discountName,
      this.discountType,
      this.discountValue,
      this.minBillAmount,
      this.voucherType,
      this.billDiscountId});

  BillDiscounts.fromJson(Map<String, dynamic> json) {
    discountId = json['discountId'];
    discountName = json['discountName'];
    discountType = json['discountType'];
    discountValue = json['discountValue'];
    minBillAmount = json['minBillAmount'];
    voucherType = json['voucherType'];
    billDiscountId = json['billDiscountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['discountId'] = this.discountId;
    data['discountName'] = this.discountName;
    data['discountType'] = this.discountType;
    data['discountValue'] = this.discountValue;
    data['minBillAmount'] = this.minBillAmount;
    data['voucherType'] = this.voucherType;
    data['billDiscountId'] = this.billDiscountId;
    return data;
  }
}

class DocumentType {
  int otherMemberShipId;
  String otherMemberName;

  DocumentType({this.otherMemberShipId, this.otherMemberName});

  DocumentType.fromJson(Map<String, dynamic> json) {
    otherMemberShipId = json['otherMemberShipId'];
    otherMemberName = json['otherMemberName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otherMemberShipId'] = this.otherMemberShipId;
    data['otherMemberName'] = this.otherMemberName;
    return data;
  }
}
