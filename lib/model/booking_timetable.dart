class Trainers {
  int trainersID;
  String trainer;
  String className;
  Trainers({
    this.trainersID,
    this.trainer,
    this.className,
  });

  Trainers.fromJson(Map<String, dynamic> json) {
    trainersID = json['trainersID'];
    trainer = json['trainer'];
    className = json['className'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trainersID'] = this.trainersID;
    data['trainer'] = this.trainer;
    data['className'] = this.className;
    return data;
  }
}

class TrainersList {
  List<Trainers> trainers;
  TrainersList({this.trainers});

  TrainersList.fromJson(Map<String, dynamic> json) {
    if (json['trainers'] != null) {
      trainers = [];
      json['trainers'].forEach((v) {
        trainers.add(new Trainers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.trainers != null) {
      data['trainers'] = this.trainers.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeTable {
  String reservationDate;
  int reservationId;
  int reservationTemplateId;
  int maxParticipants;
  int noOfGuest;
  int avaialbleSeats;
  int trainersId;
  String trainer;
  String appFromDate;
  String appToDate;
  String appFromTime;
  String appToTime;
  String className;
  int customerId;
  String firstName;
  String lastName;
  int isBookable;
  int bookingId;
  int facilityId;
  String colorCode;
  int enquiryDetailId;
  String booking_Status;
  TimeTable(
      {this.reservationDate,
      this.reservationId,
      this.reservationTemplateId,
      this.maxParticipants,
      this.noOfGuest,
      this.avaialbleSeats,
      this.trainersId,
      this.trainer,
      this.appFromDate,
      this.appToDate,
      this.appFromTime,
      this.appToTime,
      this.className,
      this.customerId,
      this.firstName,
      this.lastName,
      this.isBookable,
      this.bookingId,
      this.facilityId,
      this.colorCode,
      this.enquiryDetailId,
      this.booking_Status});

  TimeTable.fromJson(Map<String, dynamic> json) {
    this.reservationDate = json['reservationDate'];
    this.reservationId = json['reservationId'];
    this.reservationTemplateId = json['reservationTemplateId'];
    this.maxParticipants = json['maxParticipants'];
    this.noOfGuest = json['noOfGuest'];
    this.avaialbleSeats = json['avaialbleSeats'];
    this.trainersId = json['trainersId'];
    this.trainer = json['trainer'];
    this.appFromDate = json['appFromDate'];
    this.appToDate = json['appToDate'];
    this.appFromTime = json['appFromTime'];
    this.appToTime = json['appToTime'];
    this.className = json['className'];
    this.customerId = json['customerId'];
    this.firstName = json['firstName'];
    this.lastName = json['lastName'];
    this.isBookable = json['isBookable'];
    this.bookingId = json['bookingId'];
    this.facilityId = json['facilityId'];
    this.colorCode = json['colorCode'];
    this.enquiryDetailId = json['enquiryDetailId'];
    this.booking_Status = json['booking_Status'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reservationDate'] = this.reservationDate;
    data['reservationId'] = this.reservationId;
    data['reservationTemplateId'] = this.reservationTemplateId;
    data['maxParticipants'] = this.maxParticipants;
    data['noOfGuest'] = this.noOfGuest;
    data['avaialbleSeats'] = this.avaialbleSeats;
    data['trainersId'] = this.trainersId;
    data['trainer'] = this.trainer;
    data['appFromDate'] = this.appFromDate;
    data['appToDate'] = this.appToDate;
    data['appFromTime'] = this.appFromTime;
    data['appToTime'] = this.appToTime;
    data['className'] = this.className;
    data['customerId'] = this.customerId;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['isBookable'] = this.isBookable;
    data['bookingId'] = this.bookingId;
    data['facilityId'] = this.facilityId;
    data['colorCode'] = this.colorCode;
    data['enquiryDetailId'] = this.enquiryDetailId;
    data['booking_Status'] = this.booking_Status;
    return data;
  }
}

class TimeTableList {
  List<TimeTable> timeTables;
  TimeTableList({this.timeTables});

  TimeTableList.fromJson(Map<String, dynamic> json) {
    if (json['timeTables'] != null) {
      timeTables = [];
      json['timeTables'].forEach((v) {
        timeTables.add(new TimeTable.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.timeTables != null) {
      data['timeTables'] = this.timeTables.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EnquiryLanguage {
  String languageName;
  EnquiryLanguage({
    this.languageName,
  });

  EnquiryLanguage.fromJson(Map<String, dynamic> json) {
    languageName = json['languageName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['languageName'] = this.languageName;
    return data;
  }
}

class EnquiryRelation {
  String relationName;
  EnquiryRelation({
    this.relationName,
  });

  EnquiryRelation.fromJson(Map<String, dynamic> json) {
    relationName = json['relationName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['relationName'] = this.relationName;
    return data;
  }
}

class EventType {
  int eventTypeId;
  String eventType;
  EventType({
    this.eventTypeId,
    this.eventType,
  });

  EventType.fromJson(Map<String, dynamic> json) {
    eventTypeId = json['eventTypeId'];
    eventType = json['eventType'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventTypeId'] = this.eventTypeId;
    data['eventType'] = this.eventType;
    return data;
  }
}

class Venue {
  int venueId;
  String venueName;
  Venue({
    this.venueId,
    this.venueName,
  });

  Venue.fromJson(Map<String, dynamic> json) {
    venueId = json['venueId'];
    venueName = json['venueName'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['venueId'] = this.venueId;
    data['venueName'] = this.venueName;
    return data;
  }
}

class HallType {
  int hallId;
  String hallName;

  HallType({this.hallId, this.hallName});

  HallType.fromJson(Map<String, dynamic> json) {
    hallId = json['hallId'];
    hallName = json['genderName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hallId'] = this.hallId;
    data['genderName'] = this.hallName;
    return data;
  }
}

// class CateringType {
//   int cateringTypeId;
//   String cateringTypeName;
//
//   CateringType({this.cateringTypeId, this.cateringTypeName});
//
//   CateringType.fromJson(Map<String, dynamic> json) {
//     cateringTypeId = json['cateringTypeId'];
//     cateringTypeName = json['cateringTypeName'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['cateringTypeId'] = this.cateringTypeId;
//     data['cateringTypeName'] = this.cateringTypeName;
//     return data;
//   }
// }
