class PaymentTerms {
  int termsId;
  String terms;

  PaymentTerms({this.termsId, this.terms});

  PaymentTerms.fromJson(Map<String, dynamic> json) {
    termsId = json['termsId'];
    terms = json['terms'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['termsId'] = this.termsId;
    data['terms'] = this.terms;
    return data;
  }
}
