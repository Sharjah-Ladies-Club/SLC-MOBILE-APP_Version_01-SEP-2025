class TransactionResponse {
  int orderId;
  String orderNo;
  String orderDate;
  double grossAmount;
  double vatAmount;
  double payableAmount;
  String facilityName;
  int facilityId;
  String facilityIcon;
  String qrCode;
  String colorCode;
  int points;
  bool showQRCode;
  String invoiceNo;
  double deliveryCharges;
  double deliveryVat;
  double offerAmount;
  String offerCode;
  double tipsAmount;
  String orderStatus;
  double giftCardAmount;
  TransactionResponse(
      {this.orderId,
      this.orderNo,
      this.orderDate,
      this.grossAmount,
      this.vatAmount,
      this.payableAmount,
      this.facilityName,
      this.facilityId,
      this.facilityIcon,
      this.qrCode,
      this.colorCode,
      this.points,
      this.showQRCode,
      this.invoiceNo,
      this.deliveryCharges,
      this.deliveryVat,
      this.offerAmount,
      this.offerCode,
      this.tipsAmount,
      this.orderStatus,
      this.giftCardAmount});

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    orderNo = json['orderNo'];
    orderDate = json['orderDate'];
    grossAmount = json['grossAmount'];
    vatAmount = json['vatAmount'];
    payableAmount = json['payableAmount'];
    facilityName = json['facilityName'];
    facilityId = json['facilityId'];
    facilityIcon = json['facilityIcon'];
    qrCode = json['qrCode'];
    colorCode = json['colorCode'];
    points = json['points'];
    showQRCode = json['showQRCode'];
    invoiceNo = json['invoiceNo'];
    deliveryCharges = json['deliveryCharges'];
    deliveryVat = json['deliveryVat'];
    offerAmount = json['offerAmount'];
    offerCode = json['offerCode'];
    tipsAmount = json['tipsAmount'];
    orderStatus = json['orderStatus'];
    giftCardAmount = json['giftCardAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['orderNo'] = this.orderNo;
    data['orderDate'] = this.orderDate;
    data['grossAmount'] = this.grossAmount;
    data['vatAmount'] = this.vatAmount;
    data['payableAmount'] = this.payableAmount;
    data['facilityName'] = this.facilityName;
    data['facilityId'] = this.facilityId;
    data['facilityIcon'] = this.facilityIcon;
    data['colorCode'] = this.colorCode;
    data['qrCode'] = this.qrCode;
    data['points'] = this.points;
    data['showQRCode'] = this.showQRCode;
    data['invoiceNo'] = this.invoiceNo;
    data['deliveryCharges'] = this.deliveryCharges;
    data['deliveryVat'] = this.deliveryVat;
    data['offerAmount'] = this.offerAmount;
    data['offerCode'] = this.offerCode;
    data['tipsAmount'] = this.tipsAmount;
    data['orderStatus'] = this.orderStatus;
    data['giftCardAmount'] = this.giftCardAmount;
    return data;
  }
}

class TransactionDetailResponse {
  int facilityItemId;
  String facilityItemName;
  double price;
  int quantity;
  double grossAmount;
  double vatAmount;
  double totalAmount;
  TransactionDetailResponse(
      {this.facilityItemId,
      this.facilityItemName,
      this.price,
      this.quantity,
      this.grossAmount,
      this.vatAmount,
      this.totalAmount});

  TransactionDetailResponse.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    price = json['price'];
    quantity = json['quantity'];
    grossAmount = json['grossAmount'];
    vatAmount = json['vatAmount'];
    totalAmount = json['totalAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['grossAmount'] = this.grossAmount;
    data['vatAmount'] = this.vatAmount;
    data['totalAmount'] = this.totalAmount;
    return data;
  }
}

class LoyaltyVoucherResponse {
  int loyaltyVoucherId;
  String voucherName;
  String voucherImageUrl;
  int pointsRequired;
  int qtyAllowed;
  String colorCode;
  int pointsAvail;
  String facilityName;
  String facilityItemName;
  double price;
  int facilityId;
  String qrCode;
  int redemptionId;
  bool isRedeemed;
  bool showQrCode;
  bool isRedeemEnabled;
  bool isUseEnabled;
  int voucherType;
  bool isShared;
  int userId;
  bool isSharable;
  bool isUsabel;
  int membershipType;
  String validMonth;
  String validDays;
  String sharedStaffId;

  LoyaltyVoucherResponse(
      {this.loyaltyVoucherId,
      this.voucherName,
      this.voucherImageUrl,
      this.pointsRequired,
      this.qtyAllowed,
      this.colorCode,
      this.pointsAvail,
      this.facilityName,
      this.facilityItemName,
      this.price,
      this.facilityId,
      this.qrCode,
      this.redemptionId,
      this.isRedeemed,
      this.showQrCode,
      this.isRedeemEnabled,
      this.isUseEnabled,
      this.voucherType,
      this.isShared,
      this.userId,
      this.isSharable,
      this.isUsabel,
      this.membershipType,
      this.validMonth,
      this.validDays,
      this.sharedStaffId});

  LoyaltyVoucherResponse.fromJson(Map<String, dynamic> json) {
    loyaltyVoucherId = json['loyaltyVoucherId'];
    voucherName = json['voucherName'];
    voucherImageUrl = json['voucherImageUrl'];
    pointsRequired = json['pointsRequired'];
    qtyAllowed = json['qtyAllowed'];
    colorCode = json['colorCode'];
    pointsAvail = json['pointsAvail'];
    facilityName = json['facilityName'];
    facilityItemName = json['facilityItemName'];
    price = json['price'];
    facilityId = json['facilityId'];
    qrCode = json['qrCode'];
    redemptionId = json['redemptionId'];
    isRedeemed = json['isRedeemed'];
    showQrCode = json['showQrCode'];
    isRedeemEnabled = json['isRedeemEnabled'];
    isUseEnabled = json['isUseEnabled'];
    voucherType = json['voucherType'];
    isShared = json['isShared'];
    userId = json['userId'];
    isSharable = json['isSharable'];
    isUsabel = json['isUsabel'];
    membershipType = json['membershipType'];
    validMonth = json['validMonth'];
    validDays = json['validDays'];
    sharedStaffId = json['sharedStaffId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['loyaltyVoucherId'] = this.loyaltyVoucherId;
    data['voucherName'] = this.voucherName;
    data['voucherImageUrl'] = this.voucherImageUrl;
    data['pointsRequired'] = this.pointsRequired;
    data['qtyAllowed'] = this.qtyAllowed;
    data['colorCode'] = this.colorCode;
    data['pointsAvail'] = this.pointsAvail;
    data['facilityName'] = this.facilityName;
    data['facilityItemName'] = this.facilityItemName;
    data['price'] = this.price;
    data['facilityId'] = this.facilityId;
    data['qrCode'] = this.qrCode;
    data['redemptionId'] = this.redemptionId;
    data['isRedeemed'] = this.isRedeemed;
    data['showQrCode'] = this.showQrCode;
    data['isRedeemEnabled'] = this.isRedeemEnabled;
    data['isUseEnabled'] = this.isUseEnabled;
    data['voucherType'] = this.voucherType;
    data['isShared'] = this.isShared;
    data['userId'] = this.userId;
    data['isSharable'] = this.isSharable;
    data['isUsabel'] = this.isUsabel;
    data['membershipType'] = this.membershipType;
    data['validMonth'] = this.validMonth;
    data['validDays'] = this.validDays;
    data['sharedStaffId'] = this.sharedStaffId;
    return data;
  }
}

class PointResponse {
  int points;
  String redemptionMaintenaceFrom;
  String useMaintenaceFrom;

  PointResponse(
      {this.points, this.redemptionMaintenaceFrom, this.useMaintenaceFrom});

  PointResponse.fromJson(Map<String, dynamic> json) {
    points = json['points'];
    redemptionMaintenaceFrom = json['redemptionMaintenaceFrom'];
    useMaintenaceFrom = json['useMaintenaceFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['points'] = this.points;
    data['redemptionMaintenaceFrom'] = this.redemptionMaintenaceFrom;
    data['useMaintenaceFrom'] = this.useMaintenaceFrom;
    return data;
  }
}

class TrainerProfile {
  int trainerID;
  String trainerName;
  String trainerType;
  String trainerPhone;
  String trainerEmail;
  String trainerImageFile;
  String trainerEnglishProfile;
  String trainerArabicProfile;

  TrainerProfile(
      {this.trainerID,
      this.trainerName,
      this.trainerType,
      this.trainerPhone,
      this.trainerEmail,
      this.trainerImageFile,
      this.trainerEnglishProfile,
      this.trainerArabicProfile});

  TrainerProfile.fromJson(Map<String, dynamic> json) {
    trainerID = json['trainerID'];
    trainerName = json['trainerName'];
    trainerType = json['trainerType'];
    trainerPhone = json['trainerPhone'];
    trainerEmail = json['trainerEmail'];
    trainerImageFile = json['trainerImageFile'];
    trainerEnglishProfile = json['trainerEnglishProfile'];
    trainerArabicProfile = json['trainerArabicProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainerID'] = this.trainerID;
    data['trainerName'] = this.trainerName;
    data['trainerType'] = this.trainerType;
    data['trainerPhone'] = this.trainerPhone;
    data['trainerEmail'] = this.trainerEmail;
    data['trainerImageFile'] = this.trainerImageFile;
    data['trainerEnglishProfile'] = this.trainerEnglishProfile;
    data['trainerArabicProfile'] = this.trainerArabicProfile;
    return data;
  }
}
