class EventPricingCategory {
  int eventPricingCategoryId;

  EventPricingCategory({this.eventPricingCategoryId});

  EventPricingCategory.fromJson(Map<String, dynamic> json) {
    eventPricingCategoryId = json['EventPricingCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['EventPricingCategoryId'] = this.eventPricingCategoryId;
    return data;
  }
}
