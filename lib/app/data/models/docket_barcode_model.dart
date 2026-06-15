class DocketBarcodeModel {
  GetBarCodePrintByGCNResult? getBarCodePrintByGCNResult;

  DocketBarcodeModel({this.getBarCodePrintByGCNResult});

  DocketBarcodeModel.fromJson(Map<String, dynamic> json) {
    getBarCodePrintByGCNResult = json['GetBarCodePrintByGCNResult'] != null
        ? GetBarCodePrintByGCNResult.fromJson(
            json['GetBarCodePrintByGCNResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getBarCodePrintByGCNResult != null) {
      data['GetBarCodePrintByGCNResult'] =
          getBarCodePrintByGCNResult!.toJson();
    }
    return data;
  }
}

class GetBarCodePrintByGCNResult {
  List<DocketBarcodeData>? data;
  String? message;

  GetBarCodePrintByGCNResult({this.data, this.message});

  GetBarCodePrintByGCNResult.fromJson(Map<String, dynamic> json) {
    if (json['Data'] != null) {
      data = <DocketBarcodeData>[];
      json['Data'].forEach((v) {
        data!.add(DocketBarcodeData.fromJson(v));
      });
    }
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['Data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['Message'] = message;
    return data;
  }
}

class DocketBarcodeData {
  dynamic aCTUWT;
  String? cSGENM;
  String? cSGNNM;
  String? dOCKDT;
  String? dOCKNO;
  String? eDD;
  String? oRGNCD;
  dynamic pKGSNO;
  String? rEASSIGN_DESTCD;
  String? manualDockno;
  String? toLoc;

  DocketBarcodeData(
      {this.aCTUWT,
      this.cSGENM,
      this.cSGNNM,
      this.dOCKDT,
      this.dOCKNO,
      this.eDD,
      this.oRGNCD,
      this.pKGSNO,
      this.rEASSIGN_DESTCD,
      this.manualDockno,
      this.toLoc});

  DocketBarcodeData.fromJson(Map<String, dynamic> json) {
    aCTUWT = json['ACTUWT'];
    cSGENM = json['CSGENM'];
    cSGNNM = json['CSGNNM'];
    dOCKDT = json['DOCKDT'];
    dOCKNO = json['DOCKNO'];
    eDD = json['EDD'];
    oRGNCD = json['ORGNCD'];
    pKGSNO = json['PKGSNO'];
    rEASSIGN_DESTCD = json['REASSIGN_DESTCD'];
    manualDockno = json['manual_dockno'];
    toLoc = json['to_loc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ACTUWT'] = aCTUWT;
    data['CSGENM'] = cSGENM;
    data['CSGNNM'] = cSGNNM;
    data['DOCKDT'] = dOCKDT;
    data['DOCKNO'] = dOCKNO;
    data['EDD'] = eDD;
    data['ORGNCD'] = oRGNCD;
    data['PKGSNO'] = pKGSNO;
    data['REASSIGN_DESTCD'] = rEASSIGN_DESTCD;
    data['manual_dockno'] = manualDockno;
    data['to_loc'] = toLoc;
    return data;
  }
}
