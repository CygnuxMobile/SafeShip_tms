import 'dart:convert';

class DocketTrackingModel {
  dynamic success;
  String? message;
  List<DocketData>? response;

  DocketTrackingModel({this.success, this.message, this.response});

  DocketTrackingModel.fromJson(Map<String, dynamic> json) {
    success = json['Success'];
    message = json['Message'];
    if (json['Response'] != null) {
      if (json['Response'] is String) {
        response = <DocketData>[];
        var decodedResponse = jsonDecode(json['Response']);
        if (decodedResponse is List) {
          for (var v in decodedResponse) {
            response!.add(DocketData.fromJson(v));
          }
        }
      } else if (json['Response'] is List) {
        response = <DocketData>[];
        for (var v in json['Response']) {
          response!.add(DocketData.fromJson(v));
        }
      }
    }
  }
}

class DocketData {
  String? fromLoc;
  String? toLoc;
  String? docNo;
  String? fromDate;
  String? totalPkg;
  String? toDate;
  String? invNo;
  String? images;

  DocketData({
    this.fromLoc,
    this.toLoc,
    this.docNo,
    this.fromDate,
    this.totalPkg,
    this.toDate,
    this.invNo,
    this.images,
  });

  DocketData.fromJson(Map<String, dynamic> json) {
    fromLoc = json['From_loc']?.toString();
    toLoc = json['To_loc']?.toString();
    docNo = json['Docno']?.toString();
    fromDate = json['FromDate']?.toString();
    totalPkg = json['TotalPkg']?.toString();
    toDate = json['ToDate']?.toString();
    invNo = json['invno']?.toString();
    images = json['Images']?.toString();
  }
}
