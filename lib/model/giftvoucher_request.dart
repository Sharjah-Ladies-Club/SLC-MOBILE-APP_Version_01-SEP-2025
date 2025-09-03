class GiftCardCategory {
  int categoryId;
  String categoryName;
  bool selected;

  GiftCardCategory({this.categoryId, this.categoryName, this.selected});

  GiftCardCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}

class GiftCardItemsPrice {
  int facilityItemId;
  double price;
  double vatPercentage;
  bool selected;

  GiftCardItemsPrice(
      {this.facilityItemId, this.price, this.vatPercentage, this.selected});

  GiftCardItemsPrice.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    price = json['price'];
    vatPercentage = json['vatPercentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['price'] = this.price;
    data['vatPercentage'] = this.vatPercentage;
    return data;
  }
}

class GiftCardTerms {
  int id;
  String terms;
  GiftCardTerms({this.id, this.terms});

  GiftCardTerms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    terms = json['terms'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['terms'] = this.terms;

    return data;
  }
}

class GiftCardImage {
  int giftCardImageId;
  String giftCardImageUrl;
  int giftCardCategoryId;
  int validityDays;
  bool selected;

  GiftCardImage(
      {this.giftCardImageId,
      this.giftCardImageUrl,
      this.giftCardCategoryId,
      this.validityDays,
      this.selected});

  GiftCardImage.fromJson(Map<String, dynamic> json) {
    giftCardImageId = json['giftCardImageId'];
    giftCardImageUrl = json['giftCardImageUrl'];
    validityDays = json['validityDays'];
    giftCardCategoryId = json['giftCardCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['giftCardImageId'] = this.giftCardImageId;
    data['giftCardImageUrl'] = this.giftCardImageUrl;
    data['giftCardCategoryId'] = this.giftCardCategoryId;
    data['validityDays'] = this.validityDays;
    return data;
  }
}

class GiftCardUI {
  List<GiftCardCategory> categoryInfo;
  List<GiftCardItemsPrice> priceinfo;
  List<GiftCardTerms> termsInfo;

  GiftCardUI({this.categoryInfo, this.priceinfo, this.termsInfo});

  GiftCardUI.fromJson(Map<String, dynamic> json) {
    if (json['categoryInfo'] != null) {
      categoryInfo = [];
      json['categoryInfo'].forEach((v) {
        categoryInfo.add(new GiftCardCategory.fromJson(v));
      });
    }
    if (json['priceinfo'] != null) {
      priceinfo = [];
      json['priceinfo'].forEach((v) {
        priceinfo.add(new GiftCardItemsPrice.fromJson(v));
      });
    }
    if (json['termsInfo'] != null) {
      termsInfo = [];
      json['termsInfo'].forEach((v) {
        termsInfo.add(new GiftCardTerms.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categoryInfo != null) {
      data['categoryInfo'] = this.categoryInfo.map((v) => v.toJson()).toList();
    }
    if (this.priceinfo != null) {
      data['priceinfo'] = this.priceinfo.map((v) => v.toJson()).toList();
    }
    if (this.termsInfo != null) {
      data['termsInfo'] = this.termsInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GiftVocuher {
  int giftVoucherId;
  String giftCardText;
  double balanceAmount;
  double giftValue;
  String imageUrl;
  String giftCardNo;
  int validityDays;
  String giftCardExpiry;
  bool useButton;

  GiftVocuher(
      {this.giftVoucherId,
      this.giftCardText,
      this.balanceAmount,
      this.giftValue,
      this.imageUrl,
      this.giftCardNo,
      this.validityDays,
      this.giftCardExpiry,
      this.useButton});

  GiftVocuher.fromJson(Map<String, dynamic> json) {
    giftVoucherId = json['giftVoucherId'];
    giftCardText = json['giftCardText'];
    balanceAmount = json['balanceAmount'];
    giftValue = json['giftValue'];
    imageUrl = json['imageUrl'];
    giftCardNo = json['giftCardNo'];
    validityDays = json['validityDays'];
    giftCardExpiry = json['giftCardExpiry'];
    useButton = json['useButton'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['giftVoucherId'] = this.giftVoucherId;
    data['giftCardText'] = this.giftCardText;
    data['balanceAmount'] = this.balanceAmount;
    data['giftValue'] = this.giftValue;
    data['imageUrl'] = this.imageUrl;
    data['giftCardNo'] = this.giftCardNo;
    data['validityDays'] = this.validityDays;
    data['giftCardExpiry'] = this.giftCardExpiry;
    data['useButton'] = this.useButton;
    return data;
  }
}

class ActiveFacilityViewDto {
  int facilityId;
  String facilityName;

  ActiveFacilityViewDto({
    this.facilityId,
    this.facilityName,
  });

  ActiveFacilityViewDto.fromJson(Map<String, dynamic> json) {
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityId'] = this.facilityId;
    data['facilityName'] = this.facilityName;
    return data;
  }
}

class GiftCardDetailsDTO {
  int giftVoucherId;
  String facilityName;
  String orderNo;
  String orderDate;
  double reddemAmount;

  GiftCardDetailsDTO(
      {this.giftVoucherId,
      this.facilityName,
      this.orderNo,
      this.orderDate,
      this.reddemAmount});

  GiftCardDetailsDTO.fromJson(Map<String, dynamic> json) {
    giftVoucherId = json['giftVoucherId'];
    facilityName = json['facilityName'];
    orderNo = json['orderNo'];
    orderDate = json['orderDate'];
    reddemAmount = json['reddemAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['giftVoucherId'] = this.giftVoucherId;
    data['facilityName'] = this.facilityName;
    data['orderNo'] = this.orderNo;
    data['orderDate'] = this.orderDate;
    data['reddemAmount'] = this.reddemAmount;
    return data;
  }
}
