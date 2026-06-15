class BillingType {
  String? codeId;
  String? codeDesc;

  BillingType({this.codeId, this.codeDesc});

  BillingType.fromJson(Map<String, dynamic> json) {
    codeId = json['CodeId'];
    codeDesc = json['CodeDesc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CodeId'] = codeId;
    data['CodeDesc'] = codeDesc;
    return data;
  }
}
