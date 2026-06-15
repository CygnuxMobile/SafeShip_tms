import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/billing_party_model.dart';
import '../../../data/models/billing_type_model.dart';
import '../../../data/models/location_response_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants.dart';

class QuickGcController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final AuthService _authService = Get.find<AuthService>();

  final todayDateController = TextEditingController();
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  final billingTypeController = TextEditingController();
  final billingPartyController = TextEditingController();
  final cNoteNoController = TextEditingController();
  final noOfPackageController = TextEditingController();
  final invoiceNoController = TextEditingController();
  final eWayBillNoController = TextEditingController();

  final billingParties = <BillingParty>[].obs;
  final billingTypes = <BillingType>[].obs;
  final locations = <GetLocationResponse>[].obs;

  final selectedBillingType = Rxn<BillingType>();
  final selectedBillingParty = Rxn<BillingParty>();
  final selectedDestination = Rxn<GetLocationResponse>();

  final isLoading = false.obs;
  final isValidCNote = false.obs;
  final isImageUploaded = false.obs;
  final uploadedImageName = "".obs;
  final isScanning = false.obs;

  // E-Way Bill specific data if not found in master list
  final ewayBillPartyCode = RxnString();
  final ewayBillPartyName = RxnString();
  final ewayBillPaybas = RxnString();
  final ewayBillPaybasName = RxnString();

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    todayDateController.text = DateFormat('dd MMM yyyy').format(DateTime.now());
    originController.text = _authService.userData?.brcd ?? "";
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _apiProvider.getBillingParties(),
        _apiProvider.getBillingTypes(),
        _apiProvider.getLocationList(),
      ]);
      billingParties.assignAll(results[0] as List<BillingParty>);
      billingTypes.assignAll(results[1] as List<BillingType>);
      locations.assignAll(results[2] as List<GetLocationResponse>);
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to load initial data: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkDocket(String docketNo) async {
    if (docketNo.length < 5) return;
    final userData = _authService.userData;
    if (userData == null) return;
    try {
      final result = await _apiProvider.checkDocket(
        docketNo,
        userData.brcd ?? "",
        userData.userId ?? "",
      );
      isValidCNote.value = result['Status'] == "1";
      if (!isValidCNote.value) {
        Fluttertoast.showToast(
          msg: result['Message'] ?? "Invalid CNote",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      isValidCNote.value = false;
      Fluttertoast.showToast(
        msg: "Docket validation failed",
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> fetchEwaybillDetails(String eWayBillNo) async {
    if (eWayBillNo.length < 12) return;
    isLoading.value = true;
    try {
      final details = await _apiProvider.getEwaybillDetails(eWayBillNo);
      if (details?.ewaybillDetails != null) {
        final data = details!.ewaybillDetails!;
        invoiceNoController.text = data.invno ?? "";
        billingPartyController.text = data.partyName ?? "";
        eWayBillNoController.text = eWayBillNo;

        ewayBillPartyCode.value = data.partyCode;
        ewayBillPartyName.value = data.partyName;
        ewayBillPaybas.value = data.paybas;

        if (data.paybas != null) {
          final type = billingTypes.firstWhereOrNull(
            (element) => element.codeId == data.paybas,
          );
          if (type != null) {
            selectedBillingType.value = type;
            billingTypeController.text = type.codeDesc ?? "";
          } else {
            if (data.paybas == "P01")
              ewayBillPaybasName.value = "Paid";
            else if (data.paybas == "P02")
              ewayBillPaybasName.value = "TBB";
            else if (data.paybas == "P03")
              ewayBillPaybasName.value = "To Pay";
            billingTypeController.text =
                ewayBillPaybasName.value ?? data.paybas!;
          }
        }

        // Match Party if possible
        if (data.partyCode != null) {
          final party = billingParties.firstWhereOrNull(
            (element) => element.custcd == data.partyCode,
          );
          if (party != null) {
            selectedBillingParty.value = party;
            billingPartyController.text = party.toString();
          }
        }
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "E-Way Bill fetch failed",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    if (cNoteNoController.text.isEmpty || !isValidCNote.value) {
      Fluttertoast.showToast(
        msg: "Please enter valid CNote Number first",
        backgroundColor: Colors.red,
      );
      return;
    }
    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 50,
    );
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      await uploadInvoiceImage();
    }
  }

  Future<void> uploadInvoiceImage() async {
    if (selectedImage == null) return;
    isLoading.value = true;
    try {
      final userData = _authService.userData;
      if (userData == null) {
        Fluttertoast.showToast(
          msg: "User data not found",
          backgroundColor: Colors.red,
        );
        return;
      }

      // Legacy Android Filename Logic: QGC_{dockno}_{userId}_{brcd}.jpg
      String dockNo = cNoteNoController.text.trim();
      if (dockNo.isEmpty) {
        Fluttertoast.showToast(
          msg: "Please enter Docket No first",
          backgroundColor: Colors.red,
        );
        return;
      }
      final fileName = "QGC_${dockNo}_${userData.userId}_${userData.brcd}.jpg";

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(
          "${AppConstants.serverUrl}${AppConstants.quickGcUploadImage}",
        ),
      );
      request.files.add(
        await http.MultipartFile.fromPath(
          'photo',
          selectedImage!.path,
          filename: fileName,
        ),
      );

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final result = jsonDecode(responseData);
        String uploadMessage = result['QuickGC_UploadImageResult'] ?? "";
        if (uploadMessage.toUpperCase().contains("DONE")) {
          isImageUploaded.value = true;
          uploadedImageName.value = fileName;
          Fluttertoast.showToast(
            msg: "Image Uploaded Successfully",
            backgroundColor: Colors.green,
          );
        } else {
          Fluttertoast.showToast(
            msg: uploadMessage.isNotEmpty
                ? uploadMessage
                : "Image Upload Failed",
            backgroundColor: Colors.red,
          );
        }
      } else {
        Fluttertoast.showToast(
          msg: "Server returned ${response.statusCode}",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Upload Error: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _getFinancialYear() {
    return DateFormat('yyyy').format(DateTime.now());
  }

  Future<void> submitQuickGc() async {
    if (!validate()) return;

    isLoading.value = true;
    try {
      final userData = _authService.userData;
      if (userData == null) {
        Fluttertoast.showToast(
          msg: "User data not found",
          backgroundColor: Colors.red,
        );
        return;
      }
      final body = {
        "DOCKDT": todayDateController.text,
        "DESTCD":
            selectedDestination.value?.locCode ?? destinationController.text,
        "PARTY_CODE":
            selectedBillingParty.value?.custcd ?? ewayBillPartyCode.value ?? "",
        "party_name":
            selectedBillingParty.value?.custnm ??
            ewayBillPartyName.value ??
            billingPartyController.text,
        "ORGNCD": userData.brcd ?? "",
        "PAYBAS":
            selectedBillingType.value?.codeId ?? ewayBillPaybas.value ?? "",
        "CurrFinYear": _getFinancialYear(),
        "BaseCompanyCode": "C003",
        "PKGSNO": noOfPackageController.text,
        "INVNO": invoiceNoController.text,
        "DOCKNO": cNoteNoController.text,
        "INVDOC": uploadedImageName.value,
        "EWayBillNo": eWayBillNoController.text,
        "BaseUserName": userData.userId ?? "",
      };

      final result = await _apiProvider.submitQuickGc(body);
      if (result['Message'] == "Done") {
        Get.defaultDialog(
          title: "Success",
          middleText:
              "Quick GC Generated Successfully. Docket No: ${result['DockNo']}",
          textConfirm: "OK",
          onConfirm: () {
            Get.back(); // close dialog
            Get.back(); // return to home
          },
        );
      } else {
        Fluttertoast.showToast(
          msg: result['Message'] ?? "Submission failed",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Submission Error: $e",
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool validate() {
    if (selectedDestination.value == null) {
      Fluttertoast.showToast(
        msg: "Select Destination from the list",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (selectedBillingType.value == null) {
      Fluttertoast.showToast(
        msg: "Select Billing Type",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (cNoteNoController.text.isEmpty || !isValidCNote.value) {
      Fluttertoast.showToast(
        msg: "Enter valid CNote No",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (noOfPackageController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Enter No of Packages",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (invoiceNoController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Enter Invoice No",
        backgroundColor: Colors.red,
      );
      return false;
    }
    if (!isImageUploaded.value) {
      Fluttertoast.showToast(
        msg: "Please upload invoice image",
        backgroundColor: Colors.red,
      );
      return false;
    }
    return true;
  }
}
