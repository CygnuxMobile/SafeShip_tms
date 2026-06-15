class BillingParty {
  String? custcd;
  String? custnm;

  BillingParty({this.custcd, this.custnm});

  BillingParty.fromJson(Map<String, dynamic> json) {
    custcd = json['CUSTCD'];
    custnm = json['CUSTNM'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CUSTCD'] = custcd;
    data['CUSTNM'] = custnm;
    return data;
  }

  @override
  String toString() {
    return '$custcd | $custnm';
  }
}
