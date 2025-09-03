import 'event_price_category.dart';
import 'image_detail.dart';

class EventDetailResponse {
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
  bool isViewParticipants;
  List<EventPriceCategory> eventPriceCategoryList;
  List<ImageDetails> imageList;
  double longitude;
  double latitude;
  EventDetailResponse(
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
      this.isViewParticipants,
      this.eventPriceCategoryList,
      this.imageList,
      this.longitude,
      this.latitude});

  EventDetailResponse.fromJson(Map<String, dynamic> json) {
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
    isViewParticipants = json['isViewParticipants'];
    if (json['eventPriceCategoryList'] != null) {
      eventPriceCategoryList = [];
      json['eventPriceCategoryList'].forEach((v) {
        eventPriceCategoryList.add(new EventPriceCategory.fromJson(v));
      });
    }
    if (json['imageList'] != null) {
      imageList = [];
      json['imageList'].forEach((v) {
        imageList.add(new ImageDetails.fromJson(v));
      });
    }
    longitude = json['longitude'];
    latitude = json['latitude'];
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
    data['isViewParticipants'] = this.isViewParticipants;
    if (this.eventPriceCategoryList != null) {
      data['eventPriceCategoryList'] =
          this.eventPriceCategoryList.map((v) => v.toJson()).toList();
    }
    if (this.imageList != null) {
      data['imageList'] = this.imageList.map((v) => v.toJson()).toList();
    }
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    return data;
  }
}
