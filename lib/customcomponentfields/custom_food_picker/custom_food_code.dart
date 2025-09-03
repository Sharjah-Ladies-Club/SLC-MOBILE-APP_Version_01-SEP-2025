mixin ToAlias {}

@deprecated
class CElement = FoodCode with ToAlias;

/// Country element. This is the element that contains all the information
class FoodCode {
  int id;
  String mealName;
  String calorie;

//  CountryCode({this.name, this.flagUri, this.code, this.dialCode});
  FoodCode({this.id, this.mealName, this.calorie});

  FoodCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mealName = json['mealName'];
    calorie = json['calorie'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['mealName'] = this.mealName;
    data['calorie'] = this.calorie;
    return data;
  }
}
