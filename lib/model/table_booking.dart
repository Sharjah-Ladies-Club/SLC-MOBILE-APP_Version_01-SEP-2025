class TableBookingDetails {
  int bookingId;
  int tableId;
  String guestName;
  int noOfGuests;
  String tableNo;
  String tableArea;
  String start;
  String end;
  bool isBooked;
  TableBookingDetails(
      {this.bookingId,
      this.tableId,
      this.guestName,
      this.noOfGuests,
      this.tableNo,
      this.tableArea,
      this.start,
      this.end,
      this.isBooked});

  TableBookingDetails.fromJson(Map<String, dynamic> json) {
    bookingId = json['bookingId'];
    tableId = json['tableId'];
    guestName = json['guestName'];
    noOfGuests = json['noOfGuests'];
    tableNo = json['tableNo'];
    tableArea = json['tableArea'];
    start = json['start'];
    end = json['end'];
    isBooked = json['isBooked'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookingId'] = this.bookingId;
    data['tableId'] = this.tableId;
    data['guestName'] = this.guestName;
    data['noOfGuests'] = this.noOfGuests;
    data['tableNo'] = this.tableNo;
    data['tableArea'] = this.tableArea;
    data['start'] = this.start;
    data['end'] = this.end;
    data['isBooked'] = this.isBooked;
    return data;
  }
}

class TableBookingResults {
  List<TableBookingDetails> tableBookings;
  TableBookingResults({this.tableBookings});

  TableBookingResults.fromJson(Map<String, dynamic> json) {
    if (json['tableBookings'] != null) {
      tableBookings = [];
      json['tableBookings'].forEach((v) {
        tableBookings.add(new TableBookingDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.tableBookings != null) {
      data['tableBookings'] =
          this.tableBookings.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TimeSlot {
  int id;
  String timeValue;
  TimeSlot({this.id, this.timeValue});
}

class AvailableTables {
  int tableId;
  String tableNo;
  String tableArea;
  int noOfSeats;
  int bookingSeats;
  AvailableTables(
      {this.tableId,
      this.tableNo,
      this.tableArea,
      this.noOfSeats,
      this.bookingSeats});
  AvailableTables.fromJson(Map<String, dynamic> json) {
    tableId = json['tableId'];
    tableNo = json['tableNo'];
    tableArea = json['tableArea'];
    noOfSeats = json['noOfSeats'];
    bookingSeats = json['bookingSeats'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['tableId'] = this.tableId;
    data['tableNo'] = this.tableNo;
    data['tableArea'] = this.tableArea;
    data['noOfSeats'] = this.noOfSeats;
    data['bookingSeats'] = this.bookingSeats;
    return data;
  }
}
