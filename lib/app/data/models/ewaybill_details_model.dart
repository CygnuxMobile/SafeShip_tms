class EwaybillDetailsResponse {
  EwaybillDetails1? ewaybillDetails;

  EwaybillDetailsResponse({this.ewaybillDetails});

  EwaybillDetailsResponse.fromJson(Map<String, dynamic> json) {
    ewaybillDetails = json['GetEwaybillDetailsFromAPIResult'] != null
        ? EwaybillDetails1.fromJson(json['GetEwaybillDetailsFromAPIResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ewaybillDetails != null) {
      data['GetEwaybillDetailsFromAPIResult'] = ewaybillDetails!.toJson();
    }
    return data;
  }
}

class EwaybillDetails1 {
  double? decval;
  String? eWayBillExpiredDate;
  String? eWayBillInvoiceDate;
  double? eWayInvoicevalue;
  String? invdt;
  String? invno;
  String? message;
  String? partyCode;
  String? partyName;
  String? paybas;
  int? status;

  EwaybillDetails1(
      {this.decval,
      this.eWayBillExpiredDate,
      this.eWayBillInvoiceDate,
      this.eWayInvoicevalue,
      this.invdt,
      this.invno,
      this.message,
      this.partyCode,
      this.partyName,
      this.paybas,
      this.status});

  EwaybillDetails1.fromJson(Map<String, dynamic> json) {
    decval = json['DECVAL']?.toDouble();
    eWayBillExpiredDate = json['EWayBillExpiredDate'];
    eWayBillInvoiceDate = json['EWayBillInvoiceDate'];
    eWayInvoicevalue = json['EWayInvoicevalue']?.toDouble();
    invdt = json['INVDT'];
    invno = json['INVNO'];
    message = json['Message'];
    partyCode = json['PartyCode'];
    partyName = json['PartyName'];
    paybas = json['Paybas'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DECVAL'] = decval;
    data['EWayBillExpiredDate'] = eWayBillExpiredDate;
    data['EWayBillInvoiceDate'] = eWayBillInvoiceDate;
    data['EWayInvoicevalue'] = eWayInvoicevalue;
    data['INVDT'] = invdt;
    data['INVNO'] = invno;
    data['Message'] = message;
    data['PartyCode'] = partyCode;
    data['PartyName'] = partyName;
    data['Paybas'] = paybas;
    data['Status'] = status;
    return data;
  }
}
