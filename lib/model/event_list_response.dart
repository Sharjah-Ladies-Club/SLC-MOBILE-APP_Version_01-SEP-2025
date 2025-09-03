class EventListResponse {
  int id;
  String name;
  String description;
  String dateRange;
  String timeRange;
  String status;
  int statusId;
  bool isReviewPending;
  String imageURL;
  String startdate;
  String endDate;
  String startTime;
  String endTime;
  int capacity;
  int availableSeats;
  bool canAdd;
  EventListResponse(
      {this.id,
      this.name,
      this.description,
      this.dateRange,
      this.timeRange,
      this.status,
      this.statusId,
      this.isReviewPending,
      this.imageURL,
      this.startdate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.capacity,
      this.availableSeats,
      this.canAdd});
  EventListResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    dateRange = json['dateRange'];
    timeRange = json['timeRange'];
    status = json['status'];
    statusId = json['statusId'];
    isReviewPending = json['isReviewPending'];
    imageURL = json['imageURL'];
    startdate = json['startdate'];
    endDate = json['endDate'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    capacity = json['capacity'];
    availableSeats = json['availableSeats'];
    canAdd = json['canAdd'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['dateRange'] = this.dateRange;
    data['timeRange'] = this.timeRange;
    data['status'] = this.status;
    data['statusId'] = this.statusId;
    data['isReviewPending'] = this.isReviewPending;
    data['imageURL'] = this.imageURL;
    data['startdate'] = this.startdate;
    data['endDate'] = this.endDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['capacity'] = this.capacity;
    data['availableSeats'] = this.availableSeats;
    data['canAdd'] = this.canAdd;
    return data;
  }
}
