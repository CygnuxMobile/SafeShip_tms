import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as dio;
import 'package:path_provider/path_provider.dart';
import '../../core/utils/logger.dart';
import '../../core/constants.dart';
import '../models/login_response_model.dart';
import '../models/billing_party_model.dart';
import '../models/billing_type_model.dart';
import '../models/location_response_model.dart';
import '../models/ewaybill_details_model.dart';
import '../models/pod_data_model.dart';
import '../models/version_response_model.dart';
import '../models/docket_tracking_model.dart';

class ApiProvider {
  final String _baseUrl = AppConstants.serverUrl;
  final dio.Dio _dio = dio.Dio();

  void _log(String message) {
    logger.i(message);
  }

  Future<LoginResponseModel> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl${AppConstants.loginUrl}');
    final body = {
      "UserName": username,
      "Password": password,
      "RememberMe": "false",
      "IMEINumber": DateTime.now().millisecondsSinceEpoch, 
      "APKVersion": AppConstants.version,
    };

    _log("Login Request: $url");
    _log("Login Body: $body");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'multipart/form-data'},
        body: jsonEncode(body),
      );
      _log("Login Response Status: ${response.statusCode}");
      _log("Login Response Body: ${response.body}");

      if (response.statusCode == 200) {
        String responseBody = response.body;
        if (responseBody.startsWith("error:")) {
          return LoginResponseModel(success: "0", message: responseBody);
        }
        try {
          return LoginResponseModel.fromJson(jsonDecode(responseBody));
        } catch (e) {
          _log("JSON Decode Error: $e");
          return LoginResponseModel(success: "0", message: "Invalid Server Response");
        }
      }
    } catch (e) {
      _log("Login Error: $e");
    }
    return LoginResponseModel(success: "0", message: "Connection Error");
  }

  Future<String?> uploadPODImage(String fileName, String imagePath) async {
    final url = Uri.parse('$_baseUrl${AppConstants.podUploadImage}');

    _log("--- POD UPLOAD START ---");
    _log("Target URL: $url");
    _log("Original Path: $imagePath");
    _log("Target FileName: $fileName");

    final file = File(imagePath);
    String finalPath = imagePath;

    if (await file.exists()) {
      int sizeInBytes = await file.length();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      _log("Initial Size: ${sizeInMb.toStringAsFixed(2)} MB");

      if (sizeInMb > 1) {
        _log("Compressing Image...");

        final tempDir = await getTemporaryDirectory();
        final targetPath =
            "${tempDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg";

        int quality = 85;

        while (sizeInMb > 1 && quality >= 30) {
          XFile? result = await FlutterImageCompress.compressAndGetFile(
            finalPath,
            targetPath,
            quality: quality,
            minWidth: 1280,
            minHeight: 720,
          );

          if (result != null) {
            finalPath = result.path;

            int newSize = await File(finalPath).length();
            sizeInMb = newSize / (1024 * 1024);

            _log(
              "Compressed Size at $quality%: ${sizeInMb.toStringAsFixed(2)} MB",
            );
          }

          quality -= 15;
        }
      }

      _log("Final Upload Path: $finalPath");
    } else {
      _log("File not found");
      return null;
    }

    try {
      final fileBytes = await File(finalPath).readAsBytes();

      const boundary = "*****";

      final headers = {
        'Content-Type': 'multipart/form-data;boundary=$boundary',
        'Accept': '*/*',
        'Connection': 'Keep-Alive',
        'uploaded_file': fileName,
      };

      final List<int> body = [];

      // Boundary start
      body.addAll(utf8.encode('--$boundary\r\n'));

      body.addAll(utf8.encode('Content-Disposition: form-data; name="photo"; filename="$fileName"\r\n'));

      body.addAll(utf8.encode('Content-Type: image/jpeg\r\n\r\n'));

      body.addAll(fileBytes);

      body.addAll(utf8.encode('\r\n--$boundary--\r\n'));

      _log("Sending Manual Multipart Request (Android Match)...");
      _log("Total Body Length: ${body.length}");

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      _log("Status Code: ${response.statusCode}");
      _log("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(response.body);
          return data['POD_UploadImageResult'];
        } catch (e) {
          return response.body;
        }
      }
    } catch (e) {
      _log("Upload Error: $e");
    }

    return null;
  }

  Future<List<BillingParty>> getBillingParties() async {
    final url = Uri.parse('$_baseUrl${AppConstants.getCustList}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Success'].toString() == "1")
          return (data['Response'] as List)
              .map((e) => BillingParty.fromJson(e))
              .toList();
      }
    } catch (e) {}
    return [];
  }

  Future<List<BillingType>> getBillingTypes() async {
    final url = Uri.parse('$_baseUrl${AppConstants.getPayBaseList}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Success'].toString() == "1")
          return (data['Response'] as List)
              .map((e) => BillingType.fromJson(e))
              .toList();
      }
    } catch (e) {}
    return [];
  }

  Future<List<GetLocationResponse>> getLocationList() async {
    final url = Uri.parse('$_baseUrl${AppConstants.getLocationList}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Success'].toString() == "1")
          return (data['Response'] as List)
              .map((e) => GetLocationResponse.fromJson(e))
              .toList();
      }
    } catch (e) {}
    return [];
  }

  Future<Map<String, dynamic>> checkDocket(
    String docketNo,
    String locCode,
    String userId,
  ) async {
    final url = Uri.parse(
      '$_baseUrl${AppConstants.getDocket}?DocketNo=$docketNo&LocCode=$locCode&UserId=$userId',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {}
    return {"Status": "0", "Message": "Error"};
  }

  Future<EwaybillDetailsResponse?> getEwaybillDetails(String eWayBillNo) async {
    final url = Uri.parse(
      '$_baseUrl${AppConstants.getEwayBillDetails}?EWayBillNo=$eWayBillNo&Paybas=',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200)
        return EwaybillDetailsResponse.fromJson(jsonDecode(response.body));
    } catch (e) {}
    return null;
  }

  Future<Map<String, dynamic>> submitQuickGc(Map<String, dynamic> body) async {
    final url = Uri.parse('$_baseUrl${AppConstants.submitQuickGc}');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'multipart/form-data'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) {}
    return {"Message": "Error"};
  }

  Future<ServiceResponse?> checkGcValidation(String gcNo) async {
    final url = Uri.parse('$_baseUrl${AppConstants.checkGcValidation}$gcNo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200)
        return ServiceResponse.fromJson(jsonDecode(response.body));
    } catch (e) {}
    return null;
  }

  Future<ServiceResponse?> getPodList(
    String brcd,
    String userName,
    String companyCode,
    String fromDate,
    String toDate,
    String gcNo,
  ) async {
    final url = Uri.parse(
      '$_baseUrl${AppConstants.getPodList}?BRCD=$brcd&UserName=$userName&CompanyCode=$companyCode&FromDate=$fromDate&ToDate=$toDate&GCNo=$gcNo',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200)
        return ServiceResponse.fromJson(jsonDecode(response.body));
    } catch (e) {}
    return null;
  }

  Future<ServiceResponse?> getUndeliveredPodList(
    String brcd,
    String userName,
    String companyCode,
    String fromDate,
    String toDate,
    String gcNo,
  ) async {
    final url = Uri.parse('$_baseUrl${AppConstants.getUndeliveredPodList}');
    final body = {
      "DRSJson": [
        {
          "DRSNO": gcNo,
          "BRCD": brcd,
          "UserName": userName,
          "CompanyCode": companyCode,
          "FromDate": fromDate,
          "ToDate": toDate,
          "IMEINo": "0", // Android uses ConstantData.imei
        },
      ],
    };
    try {
      _log("Get Undelivered List Request: $url");
      _log("Get Undelivered List Body: ${jsonEncode(body)}");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'text/plain'},
        body: jsonEncode(body),
      );
      _log("Get Undelivered List Response: ${response.body}");
      if (response.statusCode == 200) {
        String responseBody = response.body;
        if (responseBody.startsWith("error:")) {
          _log("Server Error String: $responseBody");
          return null;
        }
        try {
          return ServiceResponse.fromJson(jsonDecode(responseBody));
        } catch (e) {
          _log("JSON Decode Error in Undelivered List: $e");
          return null;
        }
      }
    } catch (e) {
      _log("Get Undelivered List Error: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>> markDocketDelivered(
    String dockNo,
    String drsNo,
    String dockSf,
    String userName,
    String brcd,
    String deliveryDate,
    String deliveryTime,
  ) async {
    final url = Uri.parse('$_baseUrl${AppConstants.markDocketDelivered}');
    final body = {
      "DRS_Delivered_Json": [
        {
          "DOCKNO": dockNo,
          "DRS": drsNo,
          "DELYDATE": deliveryDate,
          "DELYTIME": deliveryTime,
          "DELYPERSON": userName,
          "IMEINo": "0", // Android uses ConstantData.imei
          "BRCD": brcd,
          "DOCKSF": dockSf,
        },
      ],
    };
    try {
      _log("Mark Delivered Request: $url");
      _log("Mark Delivered Body: ${jsonEncode(body)}");
      final response = await http.post(
        url,
        headers: {'Content-Type': 'text/plain'},
        body: jsonEncode(body),
      );
      _log("Mark Delivered Response: ${response.body}");
      if (response.statusCode == 200) {
        // Android checks for result.startsWith("error:") but here we expect JSON
        if (response.body.startsWith("error:")) {
           return {"Success": "0", "Message": response.body};
        }
        return jsonDecode(response.body);
      }
    } catch (e) {
      _log("Mark Delivered Error: $e");
    }
    return {"Success": "0"};
  }

  Future<VersionResponse?> getApkVersion() async {
    final url = Uri.parse('$_baseUrl${AppConstants.getApkVersion}');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200)
        return VersionResponse.fromJson(jsonDecode(response.body));
    } catch (e) {}
    return null;
  }

  Future<DocketTrackingModel?> getDocketTracking(String docketNo) async {
    final url = Uri.parse('$_baseUrl${AppConstants.docketTracking}$docketNo');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return DocketTrackingModel.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      _log("Docket Tracking Error: $e");
    }
    return null;
  }
}
