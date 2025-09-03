class TermsCondition {
  int termsId;
  String termsName;
  bool isImportant;
  bool checked = false;
  TermsCondition({
    this.termsId,
    this.termsName,
    this.isImportant,
  });

  TermsCondition.fromJson(Map<String, dynamic> json) {
    termsId = json['termsId'];
    termsName = json['termsName'];
    isImportant = json['isImportant'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termsId'] = this.termsId;
    data['termsName'] = this.termsName;
    data['isImportant'] = this.isImportant;
    return data;
  }
}
