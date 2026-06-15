class PodData {
  String? dOCKNO;
  String? dRS;
  String? dOCKSF;
  String? iD;
  String? docType;
  String? docketNo;
  String? documentNo;
  String? scanStatus;
  String? documentName;
  String? documentDate;
  bool? docFwd;
  String? imagePath;
  String? status;
  String? message;

  PodData({
    this.dOCKNO,
    this.dRS,
    this.dOCKSF,
    this.iD,
    this.docType,
    this.docketNo,
    this.documentNo,
    this.scanStatus,
    this.documentName,
    this.documentDate,
    this.docFwd,
    this.imagePath,
    this.status,
    this.message,
  });

  PodData.fromJson(Map<String, dynamic> json) {
    dOCKNO = json['DOCKNO']?.toString();
    dRS = json['dRS']?.toString();
    dOCKSF = json['DOCKSF']?.toString();
    iD = json['ID']?.toString();
    docType = json['DocType']?.toString();
    docketNo = json['DocketNo']?.toString();
    documentNo = json['DocumentNo']?.toString();
    scanStatus = json['ScanStatus']?.toString();
    documentName = json['DocumentName']?.toString();
    documentDate = json['DocumentDate']?.toString();
    docFwd = json['Doc_Fwd'] is bool ? json['Doc_Fwd'] : (json['Doc_Fwd']?.toString() == 'true');
    imagePath = json['ImagePath']?.toString();
    status = json['Status']?.toString();
    message = json['Message']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['DOCKNO'] = dOCKNO;
    data['dRS'] = dRS;
    data['DOCKSF'] = dOCKSF;
    data['ID'] = iD;
    data['DocType'] = docType;
    data['DocketNo'] = docketNo;
    data['DocumentNo'] = documentNo;
    data['ScanStatus'] = scanStatus;
    data['DocumentName'] = documentName;
    data['DocumentDate'] = documentDate;
    data['Doc_Fwd'] = docFwd;
    data['ImagePath'] = imagePath;
    data['Status'] = status;
    data['Message'] = message;
    return data;
  }
}

class ServiceResponse {
  String? success;
  String? message;
  List<PodData>? response;

  ServiceResponse({this.success, this.message, this.response});

  ServiceResponse.fromJson(Map<String, dynamic> json) {
    success = json['Success']?.toString();
    message = json['Message']?.toString();
    if (json['Response'] != null) {
      response = <PodData>[];
      json['Response'].forEach((v) {
        response!.add(PodData.fromJson(v));
      });
    }
  }
}
