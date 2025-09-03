class EventPriceCategory {
  int eventId;
  int eventPriceCategoryId;
  String name;
  String description;
  double price;

  EventPriceCategory(
      {this.eventId,
      this.eventPriceCategoryId,
      this.name,
      this.description,
      this.price});

  EventPriceCategory.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventPriceCategoryId = json['eventPriceCategoryId'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['eventId'] = this.eventId;
    data['eventPriceCategoryId'] = this.eventPriceCategoryId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    return data;
  }
}
