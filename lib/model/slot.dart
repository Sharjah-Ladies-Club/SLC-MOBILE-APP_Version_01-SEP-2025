class Slot {
  int facilityItemId;
  int facilityId;
  String facilityName;
  String facilityItemName;
  String slotTime;
  String firstName;
  String colorCode;
  int availableSeats;
  bool isBookable;
  bool isCompleted;
  bool isCancelled;

  Slot(
      {this.facilityItemId,
      this.facilityId,
      this.facilityName,
      this.facilityItemName,
      this.slotTime,
      this.firstName,
      this.colorCode,
      this.availableSeats,
      this.isBookable,
      this.isCompleted,
      this.isCancelled});

  Slot.fromJson(Map<String, dynamic> json) {
    facilityItemId = json['facilityItemId'];
    facilityId = json['facilityId'];
    facilityName = json['facilityName'];
    facilityItemName = json['facilityItemName'];
    slotTime = json['slotTime'];
    firstName = json['firstName'];
    colorCode = json['colorCode'];
    availableSeats = json['availableSeats'];
    isBookable = json['isBookable'];
    isCompleted = json['isCompleted'];
    isCancelled = json['isCancelled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['facilityItemId'] = this.facilityItemId;
    data['facilityId'] = this.facilityId;
    data['facilityName'] = this.facilityName;
    data['facilityItemName'] = this.facilityItemName;
    data['slotTime'] = this.slotTime;
    data['firstName'] = this.firstName;
    data['colorCode'] = this.colorCode;
    data['availableSeats'] = this.availableSeats;
    data['isBookable'] = this.isBookable;
    data['isCompleted'] = this.isCompleted;
    data['isCancelled'] = this.isCancelled;
    return data;
  }
}
