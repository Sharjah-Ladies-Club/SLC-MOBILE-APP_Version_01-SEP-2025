// Adjust the import according to your project structure

class KunoozBookingDto {
  int bookingId;
  int facilityId;
  int userID;
  String customerName;
  String mobileNo;
  int bookingTypeId;
  String bookingTypeName;
  int bookingEventId = 1;
  String bookingEventName;
  String bookingDate;
  String bookingDateStr;
  String bookingFrom;
  String bookingFromtr;
  String bookingTo;
  String bookingToStr;
  String setupDate;
  String setupDateStr;
  int gurrantedGuest;
  double grossAmount;
  double vatAmount;
  double discountPercent;
  double discountAmount;
  double servicePercent;
  double serviceAmount;
  double payableAmount;
  double advanceAmount;
  double balanceAmount;
  double onlineAadvanceRequestAmount;
  bool isActive;
  String emiratesId;
  String comments;
  bool isPaid = false;
  int enquiryStatusId;
  int amendmentId;
  String streetAddress;
  String city;
  String landmark;
  String deliveryInstruction;
  String contactNo;
  double deliveryCharges;
  double deliveryVat;

  List<KunoozBookingItemDto> kunoozBookingItemDto;
  List<BookingTypeDto> bookingTypeDto;
  List<BookingEventTypeDto> bookingEventTypeDto;
  List<KunoozAmendmentItemDto> kunoozAmendments;
  List<KunoozReceiptDto> kunoozReceipt;
  List<PartyHallDocumentsDto> partyHallDocumentsDto;
  List<Amendment> amendment;
  String creditCustomer;
  int cityId;
  String transportation;
  int transportationId;
  int amendmentStatusId;
  int isNew;
  String amendmentNo;

  KunoozBookingDto(
      {this.bookingId,
      this.facilityId,
      this.userID,
      this.customerName,
      this.mobileNo,
      this.bookingTypeId,
      this.bookingTypeName,
      this.bookingEventId = 1,
      this.bookingEventName,
      this.bookingDate,
      this.bookingDateStr,
      this.bookingFrom,
      this.bookingFromtr,
      this.bookingTo,
      this.bookingToStr,
      this.setupDate,
      this.setupDateStr,
      this.gurrantedGuest,
      this.grossAmount,
      this.vatAmount,
      this.discountPercent,
      this.discountAmount,
      this.servicePercent,
      this.serviceAmount,
      this.payableAmount,
      this.advanceAmount,
      this.balanceAmount,
      this.onlineAadvanceRequestAmount,
      this.isActive,
      this.emiratesId,
      this.comments,
      this.isPaid = false,
      this.enquiryStatusId,
      this.amendmentId,
      this.kunoozBookingItemDto,
      this.bookingTypeDto,
      this.bookingEventTypeDto,
      this.partyHallDocumentsDto,
      this.streetAddress,
      this.city,
      this.landmark,
      this.deliveryInstruction,
      this.contactNo,
      this.deliveryCharges,
      this.deliveryVat,
      this.creditCustomer,
      this.cityId,
      this.amendmentStatusId,
      this.isNew,
      this.amendmentNo});

  KunoozBookingDto.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    facilityId = json['facilityId'];
    userID = json['userID'];
    customerName = json['customerName'];
    mobileNo = json['mobileNo'];
    bookingTypeId = json['bookingTypeId'];
    bookingTypeName = json['bookingTypeName'];
    bookingEventId = json['bookingEventId'];
    bookingEventName = json['bookingEventName'];
    bookingDate = json['bookingDate'];
    bookingDateStr = json['bookingDateStr'];
    bookingFrom = json['bookingFrom'];
    bookingFromtr = json['bookingFromtr'];
    bookingTo = json['bookingTo'];
    bookingToStr = json['bookingToStr'];
    setupDate = json['setupDate'];
    setupDateStr = json['setupDateStr'];
    gurrantedGuest = json['gurrantedGuest'];
    grossAmount = json['grossAmount'];
    vatAmount = json['vatAmount'];
    discountPercent = json['discountPercent'];
    discountAmount = json['discountAmount'];
    servicePercent = json['servicePercent'];
    serviceAmount = json['serviceAmount'];
    payableAmount = json['payableAmount'];
    advanceAmount = json['advanceAmount'];
    balanceAmount = json['balanceAmount'];
    onlineAadvanceRequestAmount = json['onlineAadvanceRequestAmount'];
    isActive = json['isActive'];
    emiratesId = json['emiratesId'];
    comments = json['comments'];
    isPaid = json['isPaid'];
    enquiryStatusId = json['enquiryStatusId'];
    amendmentId = json['amendmentId'];

    streetAddress = json['streetAddress'];
    city = json['city'];
    landmark = json['landmark'];
    deliveryInstruction = json['deliveryInstruction'];
    contactNo = json['contactNo'];
    deliveryCharges = json['deliveryCharges'];
    deliveryVat = json['deliveryVat'];
    creditCustomer = json['creditCustomer'];
    cityId = json['cityId'];
    amendmentStatusId = json['amendmentStatusId'];
    isNew = json['isNew'];
    amendmentNo = json['amendmentNo'];

    if (json['selectedItems'] != null) {
      kunoozBookingItemDto = [];
      json['selectedItems'].forEach((v) {
        kunoozBookingItemDto.add(new KunoozBookingItemDto.fromJson(v));
      });
    }
    if (json['bookingTypes'] != null) {
      bookingTypeDto = [];
      json['bookingTypes'].forEach((v) {
        bookingTypeDto.add(new BookingTypeDto.fromJson(v));
      });
    }
    if (json['bookingEventTypes'] != null) {
      bookingEventTypeDto = [];
      json['bookingEventTypes'].forEach((v) {
        bookingEventTypeDto.add(new BookingEventTypeDto.fromJson(v));
      });
    }
    if (json['documents'] != null) {
      partyHallDocumentsDto = [];
      json['documents'].forEach((v) {
        partyHallDocumentsDto.add(new PartyHallDocumentsDto.fromJson(v));
      });
    }
    if (json['kunoozReceipts'] != null) {
      kunoozReceipt = [];
      json['kunoozReceipts'].forEach((v) {
        kunoozReceipt.add(new KunoozReceiptDto.fromJson(v));
      });
    }
    if (json['kunoozAmendments'] != null) {
      kunoozAmendments = [];
      json['kunoozAmendments'].forEach((v) {
        kunoozAmendments.add(new KunoozAmendmentItemDto.fromJson(v));
      });
    }
    if (json['amendment'] != null) {
      amendment = <Amendment>[];
      json['amendment'].forEach((v) {
        amendment.add(new Amendment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['facilityId'] = this.facilityId;
    data['userID'] = this.userID;
    data['customerName'] = this.customerName;
    data['mobileNo'] = this.mobileNo;
    data['bookingTypeId'] = this.bookingTypeId;
    data['bookingTypeName'] = this.bookingTypeName;
    data['bookingEventId'] = this.bookingEventId;
    data['bookingEventName'] = this.bookingEventName;
    data['bookingDate'] = this.bookingDate;
    data['bookingDateStr'] = this.bookingDateStr;
    data['bookingFrom'] = this.bookingFrom;
    data['bookingFromtr'] = this.bookingFromtr;
    data['bookingTo'] = this.bookingTo;
    data['bookingToStr'] = this.bookingToStr;
    data['setupDate'] = this.setupDate;
    data['setupDateStr'] = this.setupDateStr;
    data['gurrantedGuest'] = this.gurrantedGuest;
    data['grossAmount'] = this.grossAmount;
    data['vatAmount'] = this.vatAmount;
    data['discountPercent'] = this.discountPercent;
    data['discountAmount'] = this.discountAmount;
    data['servicePercent'] = this.servicePercent;
    data['serviceAmount'] = this.serviceAmount;
    data['payableAmount'] = this.payableAmount;
    data['advanceAmount'] = this.advanceAmount;
    data['balanceAmount'] = this.balanceAmount;
    data['onlineAadvanceRequestAmount'] = this.onlineAadvanceRequestAmount;
    data['isActive'] = this.isActive;
    data['emiratesId'] = this.emiratesId;
    data['comments'] = this.comments;
    data['isPaid'] = this.isPaid;
    data['enquiryStatusId'] = this.enquiryStatusId;
    data['amendmentId'] = this.amendmentId;
    data['streetAddress'] = this.streetAddress;
    data['city'] = this.city;
    data['landmark'] = this.landmark;
    data['deliveryInstruction'] = this.deliveryInstruction;
    data['contactNo'] = this.contactNo;
    data['deliveryCharges'] = this.deliveryCharges;
    data['deliveryVat'] = this.deliveryVat;
    data['creditCustomer'] = this.creditCustomer;
    data['cityId'] = this.cityId;
    data['amendmentStatusId'] = this.amendmentStatusId;
    data['isNew'] = this.isNew;
    data['amendmentNo'] = this.amendmentNo;

    if (this.kunoozBookingItemDto != null) {
      data['selectedItems'] =
          this.kunoozBookingItemDto.map((v) => v.toJson()).toList();
    }
    if (this.bookingTypeDto != null) {
      data['bookingTypes'] =
          this.bookingTypeDto.map((v) => v.toJson()).toList();
    }
    if (this.bookingEventTypeDto != null) {
      data['bookingEventTypes'] =
          this.bookingEventTypeDto.map((v) => v.toJson()).toList();
    }
    if (this.partyHallDocumentsDto != null) {
      data['documents'] =
          this.partyHallDocumentsDto.map((v) => v.toJson()).toList();
    }
    if (this.kunoozReceipt != null) {
      data['kunoozReceipts'] =
          this.kunoozReceipt.map((v) => v.toJson()).toList();
    }
    if (this.kunoozAmendments != null) {
      data['kunoozAmendments'] =
          this.kunoozAmendments.map((v) => v.toJson()).toList();
    }
    if (this.amendment != null) {
      data['amendment'] = this.amendment.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class KunoozBookingItemDto {
  int itemId;
  int kunoozBookingId;
  int facilityItemId;
  double price = 0;
  int qty = 1;
  double discountPercent = 0;
  double discount = 0;
  double tax = 0;
  double servicePercent = 0;
  double serviceAmount = 0;
  double amount = 0;
  double netAmount = 0;
  bool isHall;
  bool isAmended;
  bool isActive;
  String facilityCategory;
  String facilityItemname;

  KunoozBookingItemDto({
    this.itemId,
    this.kunoozBookingId,
    this.facilityItemId,
    this.price = 0,
    this.qty = 1,
    this.discountPercent = 0,
    this.discount = 0,
    this.tax = 0,
    this.servicePercent = 0,
    this.serviceAmount = 0,
    this.amount = 0,
    this.netAmount = 0,
    this.isHall,
    this.isAmended,
    this.isActive,
    this.facilityCategory,
    this.facilityItemname,
  });

  KunoozBookingItemDto.fromJson(Map<String, dynamic> json) {
    itemId = json['itemId'];
    kunoozBookingId = json['kunoozBookingId'];
    facilityItemId = json['facilityItemId'];
    price = json['price'];
    qty = json['qty'];
    discountPercent = json['discountPercent'];
    discount = json['discount'];
    tax = json['tax'];
    servicePercent = json['servicePercent'];
    serviceAmount = json['serviceAmount'];
    amount = json['amount'];
    netAmount = json['netAmount'];
    isHall = json['isHall'];
    isAmended = json['isAmended'];
    isActive = json['isActive'];
    facilityCategory = json['facilityCategory'];
    facilityItemname = json['facilityItemname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemId'] = this.itemId;
    data['kunoozBookingId'] = this.kunoozBookingId;
    data['facilityItemId'] = this.facilityItemId;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['discountPercent'] = this.discountPercent;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['servicePercent'] = this.servicePercent;
    data['serviceAmount'] = this.serviceAmount;
    data['amount'] = this.amount;
    data['netAmount'] = this.netAmount;
    data['isHall'] = this.isHall;
    data['isAmended'] = this.isAmended;
    data['isActive'] = this.isActive;
    data['facilityCategory'] = this.facilityCategory;
    data['facilityItemname'] = this.facilityItemname;
    return data;
  }
}

class KunoozAmendmentItemDto {
  int actualBookingDetailId;
  int newBookingDetailId;
  int kunoozAmendTypeId;
  int facilityItemId;
  double price;
  int qty;
  double discountPercent;
  double discount;
  double tax;
  double servicePercent;
  double serviceAmount;
  double amount;
  double netAmount;
  bool isHall;
  String facilityCategory;
  String facilityItemname;
  String amendFacilityItemname;
  String amendFacilityCategory;
  String amendmentDate;
  String kunoozAmendTypeName;

  KunoozAmendmentItemDto(
      {this.actualBookingDetailId,
      this.newBookingDetailId,
      this.kunoozAmendTypeId,
      this.facilityItemId,
      this.price,
      this.qty,
      this.discountPercent,
      this.discount,
      this.tax,
      this.servicePercent,
      this.serviceAmount,
      this.amount,
      this.netAmount,
      this.isHall,
      this.facilityCategory,
      this.facilityItemname,
      this.amendFacilityItemname,
      this.amendFacilityCategory,
      this.amendmentDate,
      this.kunoozAmendTypeName});

  KunoozAmendmentItemDto.fromJson(Map<String, dynamic> json) {
    actualBookingDetailId = json['actualBookingDetailId'];
    newBookingDetailId = json['newBookingDetailId'];
    kunoozAmendTypeId = json['kunoozAmendTypeId'];
    facilityItemId = json['facilityItemId'];
    price = json['price'];
    qty = json['qty'];
    discountPercent = json['discountPercent'];
    discount = json['discount'];
    tax = json['tax'];
    servicePercent = json['ServicePercent'];
    serviceAmount = json['serviceAmount'];
    amount = json['amount'];
    netAmount = json['netAmount'];
    isHall = json['isHall'];
    facilityCategory = json['facilityCategory'];
    facilityItemname = json['facilityItemname'];
    amendFacilityItemname = json['amendFacilityItemname'];
    amendFacilityCategory = json['amendFacilityCategory'];
    amendmentDate = json['amendmentDate'];
    kunoozAmendTypeName = json['kunoozAmendTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['actualBookingDetailId'] = this.actualBookingDetailId;
    data['newBookingDetailId'] = this.newBookingDetailId;
    data['kunoozAmendTypeId'] = this.kunoozAmendTypeId;
    data['facilityItemId'] = this.facilityItemId;
    data['price'] = this.price;
    data['qty'] = this.qty;
    data['discountPercent'] = this.discountPercent;
    data['discount'] = this.discount;
    data['tax'] = this.tax;
    data['servicePercent'] = this.servicePercent;
    data['serviceAmount'] = this.serviceAmount;
    data['amount'] = this.amount;
    data['netAmount'] = this.netAmount;
    data['facilityCategory'] = this.facilityCategory;
    data['facilityItemname'] = this.facilityItemname;
    data['amendFacilityItemname'] = this.amendFacilityItemname;
    data['amendFacilityCategory'] = this.amendFacilityCategory;
    data['amendmentDate'] = this.amendmentDate;
    data['kunoozAmendTypeName'] = this.kunoozAmendTypeName;
    return data;
  }
}

class KunoozReceiptDto {
  int receiptId;
  int kunoozBookingId;
  double amount;
  String tenderType;
  String paymentMode;
  String createdDate;
  double payableAmount;
  String merchantReferenceNo;
  int payType;
  int orderStatusId;

  KunoozReceiptDto(
      {this.receiptId,
      this.kunoozBookingId,
      this.amount,
      this.tenderType,
      this.payableAmount,
      this.createdDate,
      this.paymentMode,
      this.merchantReferenceNo,
      this.payType,
      this.orderStatusId});

  KunoozReceiptDto.fromJson(Map<String, dynamic> json) {
    receiptId = json['receiptId'];
    kunoozBookingId = json['kunoozBookingId'];
    amount = json['amount'];
    tenderType = json['tenderType'];
    paymentMode = json['paymentMode'];
    createdDate = json['createdDate'];
    payableAmount = json['payableAmount'];
    merchantReferenceNo = json['merchantReferenceNo'];
    payType = json['payType'];
    orderStatusId = json['orderStatusId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiptId'] = this.receiptId;
    data['kunoozBookingId'] = this.kunoozBookingId;
    data['amount'] = this.amount;
    data['tenderType'] = this.tenderType;
    data['payableAmount'] = this.payableAmount;
    data['createdDate'] = this.createdDate;
    data['paymentMode'] = this.paymentMode;
    data['merchantReferenceNo'] = this.merchantReferenceNo;
    data['payType'] = this.payType;
    data['orderStatusId'] = this.orderStatusId;
    return data;
  }
}

class BookingTypeDto {
  int bookingTypeId;
  String bookingTypeName;

  BookingTypeDto({this.bookingTypeId, this.bookingTypeName});

  BookingTypeDto.fromJson(Map<String, dynamic> json) {
    bookingTypeId = json['bookingTypeId'];
    bookingTypeName = json['bookingTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingTypeId'] = this.bookingTypeId;
    data['bookingTypeName'] = this.bookingTypeName;
    return data;
  }
}

class BookingEventTypeDto {
  int bookingEventTypeId;
  String bookingEventTypeName;

  BookingEventTypeDto({this.bookingEventTypeId, this.bookingEventTypeName});

  BookingEventTypeDto.fromJson(Map<String, dynamic> json) {
    bookingEventTypeId = json['bookingEventTypeId'];
    bookingEventTypeName = json['bookingEventTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingEventTypeId'] = this.bookingEventTypeId;
    data['bookingEventTypeName'] = this.bookingEventTypeName;
    return data;
  }
}

class PartyHallDocumentsDto {
  int partyHallBookingId;
  int documentTypeId;
  String documentFileName;
  int supportDocumentId;

  PartyHallDocumentsDto(
      {this.partyHallBookingId, this.documentFileName, this.supportDocumentId});

  PartyHallDocumentsDto.fromJson(Map<String, dynamic> json) {
    partyHallBookingId = json['partyHallBookingId'];
    documentFileName = json['documentFileName'];
    supportDocumentId = json['supportDocumentId'];
    documentTypeId = json['documentTypeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partyHallBookingId'] = this.partyHallBookingId;
    data['documentFileName'] = this.documentFileName;
    data['supportDocumentId'] = this.supportDocumentId;
    data['documentTypeId'] = this.documentTypeId;
    return data;
  }
}

class BookingEventsInputDto {
  String eventDate;
  int hallId;

  BookingEventsInputDto({this.eventDate, this.hallId});

  BookingEventsInputDto.fromJson(Map<String, dynamic> json) {
    eventDate = json['eventDate'];
    hallId = json['hallId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventDate'] = this.eventDate;
    data['hallId'] = this.hallId;
    return data;
  }
}

class BookingTypeInputDto {
  int bookingTypeId;
  int languageId;

  BookingTypeInputDto({this.bookingTypeId, this.languageId});

  BookingTypeInputDto.fromJson(Map<String, dynamic> json) {
    bookingTypeId = json['bookingTypeId'];
    languageId = json['languageId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingTypeId'] = this.bookingTypeId;
    data['languageId'] = this.languageId;
    return data;
  }
}

class BookingInputFilterDto {
  int bookingTypeId;
  String firstName;
  String mobileNo;

  BookingInputFilterDto({this.bookingTypeId, this.firstName, this.mobileNo});

  BookingInputFilterDto.fromJson(Map<String, dynamic> json) {
    bookingTypeId = json['bookingTypeId'];
    firstName = json['firstName'];
    mobileNo = json['mobileNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingTypeId'] = this.bookingTypeId;
    data['firstName'] = this.firstName;
    data['mobileNo'] = this.mobileNo;
    return data;
  }
}

class KunoozBookingListDto {
  int bookingId;
  int facilityId;
  int userID;
  String customerName;
  String mobileNo;
  int bookingTypeId;
  String bookingTypeName;
  int bookingEventId;
  String bookingEventName;
  String bookingDate;
  String bookingFrom;
  String bookingTo;
  String setupDate;
  int gurrantedGuest;
  double grossAmount;
  double vatAmount;
  double discountPercent;
  double discountAmount;
  double servicePercent;
  double serviceAmount;
  double payableAmount;
  double advanceAmount;
  double balanceAmount;
  bool isActive;
  String emiratesId;
  bool isPaid;
  int enquiryStatusId;
  int amendmentId;
  int hallId;

  KunoozBookingListDto(
      {this.bookingId,
      this.facilityId,
      this.userID,
      this.customerName,
      this.mobileNo,
      this.bookingTypeId,
      this.bookingTypeName,
      this.bookingEventId,
      this.bookingEventName,
      this.bookingDate,
      this.bookingFrom,
      this.bookingTo,
      this.setupDate,
      this.gurrantedGuest,
      this.grossAmount,
      this.vatAmount,
      this.discountPercent,
      this.discountAmount,
      this.servicePercent,
      this.serviceAmount,
      this.payableAmount,
      this.advanceAmount,
      this.balanceAmount,
      this.isActive,
      this.emiratesId,
      this.isPaid,
      this.enquiryStatusId,
      this.amendmentId,
      this.hallId});

  KunoozBookingListDto.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    facilityId = json['facilityId'];
    userID = json['userID'];
    customerName = json['customerName'];
    mobileNo = json['mobileNo'];
    bookingTypeId = json['bookingTypeId'];
    bookingTypeName = json['bookingTypeName'];
    bookingEventId = json['bookingEventId'];
    bookingEventName = json['bookingEventName'];
    bookingDate = json['bookingDate'];
    bookingFrom = json['bookingFrom'];
    bookingTo = json['bookingTo'];
    setupDate = json['setupDate'];
    gurrantedGuest = json['gurrantedGuest'];
    grossAmount = json['grossAmount'];
    vatAmount = json['vatAmount'];
    discountPercent = json['discountPercent'];
    discountAmount = json['discountAmount'];
    servicePercent = json['servicePercent'];
    serviceAmount = json['serviceAmount'];
    payableAmount = json['payableAmount'];
    advanceAmount = json['advanceAmount'];
    balanceAmount = json[''];
    isActive = json['isActive'];
    emiratesId = json['emiratesId'];
    isPaid = json['isPaid'];
    enquiryStatusId = json['enquiryStatusId'];
    amendmentId = json['amendmentId'];
    hallId = json['hallId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['facilityId'] = this.facilityId;
    data['userID'] = this.userID;
    data['customerName'] = this.customerName;
    data['mobileNo'] = this.mobileNo;
    data['bookingTypeId'] = this.bookingTypeId;
    data['bookingTypeName'] = this.bookingTypeName;
    data['bookingEventId'] = this.bookingEventId;
    data['bookingEventName'] = this.bookingEventName;
    data['bookingDate'] = this.bookingDate;
    data['bookingFrom'] = this.bookingFrom;
    data['bookingTo'] = this.bookingTo;
    data['setupDate'] = this.setupDate;
    data['gurrantedGuest'] = this.gurrantedGuest;
    data['grossAmount'] = this.grossAmount;
    data['vatAmount'] = this.vatAmount;
    data['discountPercent'] = this.discountPercent;
    data['discountAmount'] = this.discountAmount;
    data['servicePercent'] = this.servicePercent;
    data['serviceAmount'] = this.serviceAmount;
    data['payableAmount'] = this.payableAmount;
    data['advanceAmount'] = this.advanceAmount;
    data['balanceAmount'] = this.balanceAmount;
    data['isActive'] = this.isActive;
    data['emiratesId'] = this.emiratesId;
    data['isPaid'] = this.isPaid;
    data['enquiryStatusId'] = this.enquiryStatusId;
    data['amendmentId'] = this.amendmentId;
    data['hallId'] = this.hallId;
    return data;
  }
}

class Amendment {
  int amendmentId;
  int userID;
  String customerName;
  String mobileNo;
  int bookingTypeId;
  String bookingTypeName;
  int bookingEventId;
  String bookingEventName;
  String bookingDate;
  String amendmentDate;
  String bookingDateChange;
  String bookingFrom;
  String bookingFromChange;
  int actualGuest;
  int amendedGuest;
  double grossAmount;
  double actualAmount;
  double amendedAmount;
  int amendmentNo;
  int amendmentStatusId;
  String amendmentNoShow;

  Amendment(
      {this.amendmentId,
      this.userID,
      this.customerName,
      this.mobileNo,
      this.bookingTypeId,
      this.bookingTypeName,
      this.bookingEventId,
      this.bookingEventName,
      this.bookingDate,
      this.amendmentDate,
      this.bookingDateChange,
      this.bookingFrom,
      this.bookingFromChange,
      this.actualGuest,
      this.amendedGuest,
      this.grossAmount,
      this.actualAmount,
      this.amendedAmount,
      this.amendmentNo,
      this.amendmentStatusId,
      this.amendmentNoShow});

  Amendment.fromJson(Map<String, dynamic> json) {
    amendmentId = json['amendmentId'];
    userID = json['userID'];
    customerName = json['customerName'];
    mobileNo = json['mobileNo'];
    bookingTypeId = json['bookingTypeId'];
    bookingTypeName = json['bookingTypeName'];
    bookingEventId = json['bookingEventId'];
    bookingEventName = json['bookingEventName'];
    bookingDate = json['bookingDate'];
    amendmentDate = json['amendmentDate'];
    bookingDateChange = json['bookingDateChange'];
    bookingFrom = json['bookingFrom'];
    amendmentDate = json['amendmentDate'];
    bookingFromChange = json['bookingFromChange'];
    actualGuest = json['actualGuest'];
    amendedGuest = json['amendedGuest'];
    grossAmount = json['grossAmount'];
    actualAmount = json['actualAmount'];
    amendedAmount = json['amendedAmount'];
    amendmentNo = json['amendmentNo'];
    amendmentStatusId = json['amendmentStatusId'];
    amendmentNoShow = json['amendmentNoShow'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amendmentId'] = this.amendmentId;
    data['userID'] = this.userID;
    data['customerName'] = this.customerName;
    data['mobileNo'] = this.mobileNo;
    data['bookingTypeId'] = this.bookingTypeId;
    data['bookingTypeName'] = this.bookingTypeName;
    data['bookingEventId'] = this.bookingEventId;
    data['bookingEventName'] = this.bookingEventName;
    data['bookingDate'] = this.bookingDate;
    data['amendmentDate'] = this.amendmentDate;
    data['bookingDateChange'] = this.bookingDateChange;
    data['bookingFrom'] = this.bookingFrom;
    data['bookingFromChange'] = this.bookingFromChange;
    data['actualGuest'] = this.actualGuest;
    data['amendedGuest'] = this.amendedGuest;
    data['grossAmount'] = this.grossAmount;
    data['actualAmount'] = this.actualAmount;
    data['amendedAmount'] = this.amendedAmount;
    data['amendmentNo'] = this.amendmentNo;
    data['amendmentStatusId'] = this.amendmentStatusId;
    data['amendmentNoShow'] = this.amendmentNoShow;

    return data;
  }
}

// class KunuoozContractDto {
//   String contractDate;
//   String contractNo;
//   String erpId;
//   String fullName;
//   String mobile;
//   String mail;
//   String idType;
//   String idNo;
//   String nationality;
//   String coordinator;
//   String contactno;
//   String eventName;
//   String eventDate;
//   String eventTime;
//   int guestCount;
//   int guestCountAmend;
//   String venue;
//   String emiratesId;
//   double bookingDeposit;
//   String bookingDepositDate;
//   double avanceAmount;
//   String advanceDate;
//   double balanceAmount;
//   String balanceDate;
//   List<AmendItemDtlDto> actaulDetails;
//   List<AmendItemDtlDto> amendedDetails;
//   List<KunoozReceiptDto> receiptDetail;
//   int kunoozBookingId;
//   KunuoozContractDto(
//       this.contractDate,
//       this.contractNo,
//       this.erpId,
//       this.fullName,
//       this.mobile,
//       this.mail,
//       this.idType,
//       this.idNo,
//       this.nationality,
//       this.coordinator,
//       this.contactno,
//       this.eventName,
//       this.eventDate,
//       this.eventTime,
//       this.guestCount,
//       this.guestCountAmend,
//       this.venue,
//       this.emiratesId,
//       this.bookingDeposit,
//       this.bookingDepositDate,
//       this.avanceAmount,
//       this.advanceDate,
//       this.balanceAmount,
//       this.balanceDate,
//       this.actaulDetails,
//       this.amendedDetails,
//       this.receiptDetail,
//       this.kunoozBookingId);
//   KunuoozContractDto.fromJson(Map<String, dynamic> json) {
//     contractDate = json['contractDate'];
//     contractNo = json['contractNo'];
//     erpId = json['erpId'];
//     fullName = json['fullName'];
//     mobile = json['mobile'];
//     mail = json['mail'];
//     idType = json['idType'];
//     idNo = json['idNo'];
//     nationality = json['nationality'];
//     coordinator = json['coordinator'];
//     contactno = json['contactno'];
//     eventName = json['eventName'];
//     eventDate = json['eventDate'];
//     eventTime = json['eventTime'];
//     guestCount = json['guestCount'];
//     guestCountAmend = json['guestCountAmend'];
//     venue = json['venue'];
//     emiratesId = json['emiratesId'];
//     bookingDeposit = json['bookingDeposit'];
//     bookingDepositDate = json['bookingDepositDate'];
//     avanceAmount = json['avanceAmount'];
//     advanceDate = json['advanceDate'];
//     balanceAmount = json['balanceAmount'];
//     balanceDate = json['balanceDate'];
//     kunoozBookingId = json['kunoozBookingId'];
//     if (json['actaulDetails'] != null) {
//       actaulDetails = [];
//       json['actaulDetails'].forEach((v) {
//         actaulDetails.add(new AmendItemDtlDto.fromJson(v));
//       });
//     }
//     if (json['amendedDetails'] != null) {
//       amendedDetails = [];
//       json['amendedDetails'].forEach((v) {
//         amendedDetails.add(new AmendItemDtlDto.fromJson(v));
//       });
//     }
//     if (json['receiptDetail'] != null) {
//       receiptDetail = [];
//       json['receiptDetail'].forEach((v) {
//         receiptDetail.add(new KunoozReceiptDto.fromJson(v));
//       });
//     }
//   }
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['contractDate'] = this.contractDate;
//     data['contractNo'] = this.contractNo;
//     data['erpId'] = this.erpId;
//     data['fullName'] = this.fullName;
//     data['mobile'] = this.mobile;
//     data['mail'] = this.mail;
//     data['idType'] = this.idType;
//     data['idNo'] = this.idNo;
//     data['nationality'] = this.nationality;
//     data['coordinator'] = this.coordinator;
//     data['contactno'] = this.contactno;
//     data['eventName'] = this.eventName;
//     data['eventDate'] = this.eventDate;
//     data['eventTime'] = this.eventTime;
//     data['guestCount'] = this.guestCount;
//     data['guestCountAmend'] = this.guestCountAmend;
//     data['venue'] = this.venue;
//     data['emiratesId'] = this.emiratesId;
//     data['bookingDeposit'] = this.bookingDeposit;
//     data['bookingDepositDate'] = this.bookingDepositDate;
//     data['avanceAmount'] = this.avanceAmount;
//     data['advanceDate'] = this.advanceDate;
//     data['balanceAmount'] = this.balanceAmount;
//     data['balanceDate'] = this.balanceDate;
//     data['kunoozBookingId'] = this.kunoozBookingId;
//     if (this.actaulDetails != null) {
//       data['actaulDetails'] =
//           this.actaulDetails.map((v) => v.toJson()).toList();
//     }
//     if (this.amendedDetails != null) {
//       data['amendedDetails'] =
//           this.amendedDetails.map((v) => v.toJson()).toList();
//     }
//     if (this.receiptDetail != null) {
//       data['receiptDetail'] =
//           this.receiptDetail.map((v) => v.toJson()).toList();
//     }
//   }
// }

class KunuoozContractDataDto {
  KunuoozContractDto response;

  KunuoozContractDataDto({this.response});

  KunuoozContractDataDto.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new KunuoozContractDto.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

class KunuoozContractDto {
  String contractDate;
  String contractNo;
  String erpId;
  String fullName;
  String mobile;
  String email;
  String idType;
  String idNo;
  String nationality;
  String coordinator;
  String contactno;
  String eventName;
  String eventDate;
  String eventTime;
  int guestCount;
  int guestCountAmend;
  String venue;
  String emiratesId;
  double bookingDeposit;
  String bookingDepositDate;
  double avanceAmount;
  String advanceDate;
  double balanceAmount;
  String balanceDate;
  List<AmendedDetails> actaulDetails;
  List<AmendedDetails> amendedDetails;
  List<ReceiptDetail> receiptDetail;
  int kunoozBookingId;

  KunuoozContractDto(
      {this.contractDate,
      this.contractNo,
      this.erpId,
      this.fullName,
      this.mobile,
      this.email,
      this.idType,
      this.idNo,
      this.nationality,
      this.coordinator,
      this.contactno,
      this.eventName,
      this.eventDate,
      this.eventTime,
      this.guestCount,
      this.guestCountAmend,
      this.venue,
      this.emiratesId,
      this.bookingDeposit,
      this.bookingDepositDate,
      this.avanceAmount,
      this.advanceDate,
      this.balanceAmount,
      this.balanceDate,
      this.actaulDetails,
      this.amendedDetails,
      this.receiptDetail,
      this.kunoozBookingId});

  KunuoozContractDto.fromJson(Map<String, dynamic> json) {
    contractDate = json['contractDate'];
    contractNo = json['contractNo'];
    erpId = json['erpId'];
    fullName = json['fullName'];
    mobile = json['mobile'];
    email = json['email'];
    idType = json['idType'];
    idNo = json['idNo'];
    nationality = json['nationality'];
    coordinator = json['coordinator'];
    contactno = json['contactno'];
    eventName = json['eventName'];
    eventDate = json['eventDate'];
    eventTime = json['eventTime'];
    guestCount = json['guestCount'];
    guestCountAmend = json['guestCountAmend'];
    venue = json['venue'];
    emiratesId = json['emiratesId'];
    bookingDeposit = json['bookingDeposit'];
    bookingDepositDate = json['bookingDepositDate'];
    avanceAmount = json['avanceAmount'];
    advanceDate = json['advanceDate'];
    balanceAmount = json['balanceAmount'];
    balanceDate = json['balanceDate'];
    if (json['actaulDetails'] != null) {
      actaulDetails = <AmendedDetails>[];
      json['actaulDetails'].forEach((v) {
        actaulDetails.add(new AmendedDetails.fromJson(v));
      });
    }
    if (json['amendedDetails'] != null) {
      amendedDetails = <AmendedDetails>[];
      json['amendedDetails'].forEach((v) {
        amendedDetails.add(new AmendedDetails.fromJson(v));
      });
    }
    if (json['receiptDetail'] != null) {
      receiptDetail = <ReceiptDetail>[];
      json['receiptDetail'].forEach((v) {
        receiptDetail.add(new ReceiptDetail.fromJson(v));
      });
    }
    kunoozBookingId = json['kunoozBookingId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contractDate'] = this.contractDate;
    data['contractNo'] = this.contractNo;
    data['erpId'] = this.erpId;
    data['fullName'] = this.fullName;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['idType'] = this.idType;
    data['idNo'] = this.idNo;
    data['nationality'] = this.nationality;
    data['coordinator'] = this.coordinator;
    data['contactno'] = this.contactno;
    data['eventName'] = this.eventName;
    data['eventDate'] = this.eventDate;
    data['eventTime'] = this.eventTime;
    data['guestCount'] = this.guestCount;
    data['guestCountAmend'] = this.guestCountAmend;
    data['venue'] = this.venue;
    data['emiratesId'] = this.emiratesId;
    data['bookingDeposit'] = this.bookingDeposit;
    data['bookingDepositDate'] = this.bookingDepositDate;
    data['avanceAmount'] = this.avanceAmount;
    data['advanceDate'] = this.advanceDate;
    data['balanceAmount'] = this.balanceAmount;
    data['balanceDate'] = this.balanceDate;
    if (this.actaulDetails != null) {
      data['actaulDetails'] =
          this.actaulDetails.map((v) => v.toJson()).toList();
    }
    if (this.amendedDetails != null) {
      data['amendedDetails'] =
          this.amendedDetails.map((v) => v.toJson()).toList();
    }
    if (this.receiptDetail != null) {
      data['receiptDetail'] =
          this.receiptDetail.map((v) => v.toJson()).toList();
    }
    data['kunoozBookingId'] = this.kunoozBookingId;
    return data;
  }
}

// class ActaulDetails {
//   String itemDescription;
//   int quantity;
//   double unitPrice;
//   double total;
//   double discountValue;
//   double serviceAmount;
//   double taxPercent;
//   double taxAmount;
//   double totalWithTax;
//
//   ActaulDetails(
//       {this.itemDescription,
//       this.quantity,
//       this.unitPrice,
//       this.total,
//       this.discountValue,
//       this.serviceAmount,
//       this.taxPercent,
//       this.taxAmount,
//       this.totalWithTax});
//
//   ActaulDetails.fromJson(Map<String, dynamic> json) {
//     itemDescription = json['itemDescription'];
//     quantity = json['quantity'];
//     unitPrice = json['unitPrice'];
//     total = json['total'];
//     discountValue = json['discountValue'];
//     serviceAmount = json['serviceAmount'];
//     taxPercent = json['taxPercent'];
//     taxAmount = json['taxAmount'];
//     totalWithTax = json['totalWithTax'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['itemDescription'] = this.itemDescription;
//     data['quantity'] = this.quantity;
//     data['unitPrice'] = this.unitPrice;
//     data['total'] = this.total;
//     data['discountValue'] = this.discountValue;
//     data['serviceAmount'] = this.serviceAmount;
//     data['taxPercent'] = this.taxPercent;
//     data['taxAmount'] = this.taxAmount;
//     data['totalWithTax'] = this.totalWithTax;
//     return data;
//   }
// }

class ReceiptDetail {
  int receiptId;
  int kunoozBookingId;
  double amount;
  String tenderType;
  String paymentMode;
  String createdDate;
  double payableAmount;
  String merchantReferenceNo;
  int payType;
  int orderStatusId;
  String encryptedId;
  String encryptedEmployeeId;
  String postStatusMessage;
  bool postStatus;

  ReceiptDetail(
      {this.receiptId,
      this.kunoozBookingId,
      this.amount,
      this.tenderType,
      this.paymentMode,
      this.createdDate,
      this.payableAmount,
      this.merchantReferenceNo,
      this.payType,
      this.orderStatusId,
      this.encryptedId,
      this.encryptedEmployeeId,
      this.postStatusMessage,
      this.postStatus});

  ReceiptDetail.fromJson(Map<String, dynamic> json) {
    receiptId = json['receiptId'];
    kunoozBookingId = json['kunoozBookingId'];
    amount = json['amount'];
    tenderType = json['tenderType'];
    paymentMode = json['paymentMode'];
    createdDate = json['createdDate'];
    payableAmount = json['payableAmount'];
    merchantReferenceNo = json['merchantReferenceNo'];
    payType = json['payType'];
    orderStatusId = json['orderStatusId'];
    encryptedId = json['encryptedId'];
    encryptedEmployeeId = json['encryptedEmployeeId'];
    postStatusMessage = json['postStatusMessage'];
    postStatus = json['postStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receiptId'] = this.receiptId;
    data['kunoozBookingId'] = this.kunoozBookingId;
    data['amount'] = this.amount;
    data['tenderType'] = this.tenderType;
    data['paymentMode'] = this.paymentMode;
    data['createdDate'] = this.createdDate;
    data['payableAmount'] = this.payableAmount;
    data['merchantReferenceNo'] = this.merchantReferenceNo;
    data['payType'] = this.payType;
    data['orderStatusId'] = this.orderStatusId;
    data['encryptedId'] = this.encryptedId;
    data['encryptedEmployeeId'] = this.encryptedEmployeeId;
    data['postStatusMessage'] = this.postStatusMessage;
    data['postStatus'] = this.postStatus;
    return data;
  }
}

class AmendedDetails {
  String itemDescription;
  int quantity;
  double unitPrice;
  double total;
  double discountValue;
  double serviceAmount;
  double taxPercent;
  double taxAmount;
  double totalWithTax;

  AmendedDetails(
      {this.itemDescription,
      this.quantity,
      this.unitPrice,
      this.total,
      this.discountValue,
      this.serviceAmount,
      this.taxPercent,
      this.taxAmount,
      this.totalWithTax});

  AmendedDetails.fromJson(Map<String, dynamic> json) {
    itemDescription = json['itemDescription'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    total = json['total'];
    discountValue = json['discountValue'];
    serviceAmount = json['serviceAmount'];
    taxPercent = json['taxPercent'];
    taxAmount = json['taxAmount'];
    totalWithTax = json['totalWithTax'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemDescription'] = this.itemDescription;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['total'] = this.total;
    data['discountValue'] = this.discountValue;
    data['serviceAmount'] = this.serviceAmount;
    data['taxPercent'] = this.taxPercent;
    data['taxAmount'] = this.taxAmount;
    data['totalWithTax'] = this.totalWithTax;
    return data;
  }
}

class AmendItemDtlDto {
  String itemDescription;
  int quantity;
  double unitPrice;
  double total;
  double discountValue;
  double serviceAmount;
  double taxPercent;
  double taxAmount;
  double totalWithTax;
  AmendItemDtlDto(
    this.itemDescription,
    this.quantity,
    this.unitPrice,
    this.total,
    this.discountValue,
    this.serviceAmount,
    this.taxPercent,
    this.taxAmount,
    this.totalWithTax,
  );
  AmendItemDtlDto.fromJson(Map<String, dynamic> json) {
    itemDescription = json['itemDescription'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    total = json['total'];
    discountValue = json['discountValue'];
    serviceAmount = json['serviceAmount'];
    taxPercent = json['taxPercent'];
    taxAmount = json['taxAmount'];
    totalWithTax = json['totalWithTax'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['itemDescription'] = this.itemDescription;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['total'] = this.total;
    data['discountValue'] = this.discountValue;
    data['serviceAmount'] = this.serviceAmount;
    data['taxPercent'] = this.taxPercent;
    data['taxAmount'] = this.taxAmount;
    data['totalWithTax'] = this.totalWithTax;
  }
}
