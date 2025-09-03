class HearAboutUsDetail {
  int marketingSourceId;
  String marketingSourceName;
  bool isMobileNumberRequired;

  HearAboutUsDetail(
      {this.marketingSourceId,
      this.marketingSourceName,
      this.isMobileNumberRequired});

  HearAboutUsDetail.fromJson(Map<String, dynamic> json) {
    marketingSourceId = json['marketingSourceId'];
    marketingSourceName = json['marketingSourceName'];
    isMobileNumberRequired = json['isMobileNumberRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['marketingSourceId'] = this.marketingSourceId;
    data['marketingSourceName'] = this.marketingSourceName;
    data['isMobileNumberRequired'] = this.isMobileNumberRequired;
    return data;
  }
}
