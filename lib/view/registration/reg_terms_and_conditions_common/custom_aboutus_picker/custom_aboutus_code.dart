mixin ToAlias {}

@deprecated
class CElement = HearAboutResponse with ToAlias;

/// nationality element. This is the element that contains all the information
class HearAboutResponse {
  /// the nationality code (IT,AF..)
//  String code;
  int marketingSourceId;

//  String dialCode;

  /// the name of the nationality
//  String name;
  String marketingSourceName;

  /// the flag of the nationality
//  String flagUri;

  /// the dial code (+39,+93..)
  // String dialCode;

  bool isMobileNumberRequired;

//  nationalityCode({this.name, this.flagUri, this.code, this.dialCode});
  HearAboutResponse(
      {this.marketingSourceId,
      this.marketingSourceName,
      this.isMobileNumberRequired});

  HearAboutResponse.fromJson(Map<String, dynamic> json) {
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

  @override
  String toString() => "$marketingSourceId";

  String toLongString() =>
      // "$dialCode" +
      "$marketingSourceId"
      "$marketingSourceName";

  String toNationalityStringOnly() => '$marketingSourceName';
}
