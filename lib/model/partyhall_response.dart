// ignore_for_file: non_constant_identifier_names

import 'package:slc/model/facility_item.dart';

import 'booking_timetable.dart';

class PartyHallResponse {
  int partyHallBookingId;
  int facilityId;
  int userID;
  int partyEventTypeId;
  String partyEventTypeName;
  String date_Of_Event;
  String startTime;
  String endTime;
  String setup_Date;
  int gurranted_Guest;
  int partyHallStatusId;
  String comments;
  bool isActive;
  String owner;
  String mobileNo;
  List<PartyHallDocuments> documents;
  List<PartyHallContacts> contacts;
  double vatPercentage;
  List<FacilityItem> menuItems;
  List<FacilityBeachRequest> selectedMenuItems;
  List<EventType> eventTypes;
  int facilityItemId;
  String facilityItemName;
  int venueId;
  String venueName;
  double price;
  double total;
  String emiratesId;

  PartyHallResponse(
      {this.partyHallBookingId,
      this.facilityId,
      this.userID,
      this.partyEventTypeId,
      this.partyEventTypeName,
      this.date_Of_Event,
      this.startTime,
      this.endTime,
      this.setup_Date,
      this.gurranted_Guest,
      this.partyHallStatusId,
      this.comments,
      this.isActive,
      this.documents,
      this.contacts,
      this.vatPercentage,
      this.menuItems,
      this.facilityItemId,
      this.facilityItemName,
      this.selectedMenuItems,
      this.venueId,
      this.venueName,
      this.price,
      this.total,
      this.emiratesId,
      this.eventTypes,
      this.owner,
      this.mobileNo});

  PartyHallResponse.fromJson(Map<String, dynamic> json) {
    partyHallBookingId = json['partyHallBookingId'];
    facilityId = json['facilityId'];
    userID = json['userID'];
    partyEventTypeId = json['partyEventTypeId'];
    partyEventTypeName = json['partyEventTypeName'];
    date_Of_Event = json['date_Of_Event'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    setup_Date = json['setup_Date'];
    gurranted_Guest = json['gurranted_Guest'];
    partyHallStatusId = json['partyHallStatusId'];
    comments = json['comments'];
    isActive = json['isActive'];
    vatPercentage = json['vatPercentage'];
    facilityItemId = json['facilityItemId'];
    facilityItemName = json['facilityItemName'];
    venueId = json['venueId'];
    venueName = json['venueName'];
    price = json['price'];
    total = json['total'];
    owner = json['owner'];
    mobileNo = json['mobileNo'];
    emiratesId = json['emiratesId'];
    if (json['documents'] != null) {
      documents = [];
      json['documents'].forEach((v) {
        documents.add(new PartyHallDocuments.fromJson(v));
      });
    }
    comments = json['Comments'];
    if (json['contacts'] != null) {
      contacts = [];
      json['contacts'].forEach((v) {
        contacts.add(new PartyHallContacts.fromJson(v));
      });
    }
    if (json['menuItems'] != null) {
      menuItems = [];
      json['menuItems'].forEach((v) {
        menuItems.add(new FacilityItem.fromJson(v));
      });
    }
    if (json['selectedMenuItems'] != null) {
      selectedMenuItems = [];
      json['selectedMenuItems'].forEach((v) {
        selectedMenuItems.add(new FacilityBeachRequest.fromJson(v));
      });
    }
    if (json['eventTypes'] != null) {
      eventTypes = [];
      json['eventTypes'].forEach((v) {
        eventTypes.add(new EventType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['partyHallBookingId'] = this.partyHallBookingId;
    data['facilityId'] = this.facilityId;
    data['userID'] = this.userID;
    data['partyEventTypeId'] = this.partyEventTypeId;
    data['partyEventTypeName'] = this.partyEventTypeName;
    data['date_Of_Event'] = this.date_Of_Event;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['setup_Date'] = this.setup_Date;
    data['gurranted_Guest'] = this.gurranted_Guest;
    data['partyHallStatusId'] = this.partyHallStatusId;
    data['comments'] = this.comments;
    data['isActive'] = this.isActive;
    data['vatPercentage'] = this.vatPercentage;
    data['facilityItemId'] = this.facilityItemId;
    data['facilityItemName'] = this.facilityItemName;
    data['venueId'] = this.venueId;
    data['venueName'] = this.venueName;
    data['price'] = this.price;
    data['total'] = this.total;
    data['emiratesId'] = this.emiratesId;
    data['owner'] = this.owner;
    data['mobileNo'] = this.mobileNo;
    if (this.documents != null) {
      data['documents'] = this.documents.map((v) => v.toJson()).toList();
    }
    if (this.contacts != null) {
      data['contacts'] = this.contacts.map((v) => v.toJson()).toList();
    }
    if (this.menuItems != null) {
      data['menuItems'] = this.menuItems.map((v) => v.toJson()).toList();
    }
    if (this.selectedMenuItems != null) {
      data['selectedMenuItems'] =
          this.selectedMenuItems.map((v) => v.toJson()).toList();
    }
    if (this.eventTypes != null) {
      data['eventTypes'] = this.eventTypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PartyHallDocuments {
  String documentFileName;
  int partyHallBookingId;
  int supportDocumentId;

  PartyHallDocuments(
      {this.documentFileName, this.partyHallBookingId, this.supportDocumentId});

  PartyHallDocuments.fromJson(Map<String, dynamic> json) {
    documentFileName = json['documentFileName'];
    partyHallBookingId = json['partyHallBookingId'];
    supportDocumentId = json['supportDocumentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DocumentFileName'] = this.documentFileName;
    data['PartyHallBookingId'] = this.partyHallBookingId;
    data['supportDocumentId'] = this.supportDocumentId;
    return data;
  }
}

class PartyHallContacts {
  int contactId;
  String contactName;
  String relation;
  String mobileNo;
  String emailId;

  PartyHallContacts(
      {this.contactId,
      this.contactName,
      this.relation,
      this.mobileNo,
      this.emailId});

  PartyHallContacts.fromJson(Map<String, dynamic> json) {
    contactId = json['contactId'];
    contactName = json['contactName'];
    relation = json['relation'];
    mobileNo = json['mobileNo'];
    emailId = json['emailId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['contactId'] = this.contactId;
    data['contactName'] = this.contactName;
    data['relation'] = this.relation;
    data['mobileNo'] = this.mobileNo;
    data['emailId'] = this.emailId;
    return data;
  }
}
