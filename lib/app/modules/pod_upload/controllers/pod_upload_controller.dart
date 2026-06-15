import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants.dart';
import '../../../data/models/pod_data_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/utils/logger.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../routes/app_pages.dart';

class PodUploadController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final AuthService _authService = Get.find<AuthService>();

  final TextEditingController podNoController = TextEditingController();
  final RxBool showClearButton = false.obs;
  
  final RxBool isLoading = false.obs;
  final RxBool isSearchDone = false.obs;

  @override
  void onInit() {
    super.onInit();
    podNoController.addListener(() {
      showClearButton.value = podNoController.text.isNotEmpty;
    });
  }
  final RxBool isScanned = false.obs;
  final RxString documentNo = "N/A".obs;
  final RxString scanStatus = "No".obs;
  final RxString urlForImagePath = "".obs;
  final RxString selectedImagePath = "".obs;
  final RxString imagePath = "".obs;
  final RxBool isViewVisible = false.obs;
  final RxBool isSubmitVisible = false.obs;

  final RxBool isSelectFileVisible = false.obs;
  final RxString selectFileText = "SELECT FILE".obs;

  void logout() {
    _authService.logout();
  }

  void validateGcNo() {
    onSearch();
  }

  void resetData() {
    isSearchDone.value = false;
    isScanned.value = false;
    podNoController.clear();
    selectedImagePath.value = "";
    urlForImagePath.value = "";
    documentNo.value = "N/A";
    scanStatus.value = "No";
    imagePath.value = "";
    isViewVisible.value = false;
    isSubmitVisible.value = false;
    isSelectFileVisible.value = false;
    selectFileText.value = "SELECT FILE";
  }

  void onSearch() async {
    final gcNo = podNoController.text.trim().toUpperCase();
    if (gcNo.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter GC Number");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.checkGcValidation(gcNo);
      if (response != null && response.response != null && response.response!.isNotEmpty) {
        final podData = response.response![0];
        isSearchDone.value = true;
        
        if (podData.scanStatus == "1") {
          isScanned.value = true;
          scanStatus.value = "Scanned";
          documentNo.value = podData.documentNo ?? "N/A";
          imagePath.value = podData.imagePath ?? "";
          isViewVisible.value = true;
          isSubmitVisible.value = false;
          isSelectFileVisible.value = false;
        } else {
          isScanned.value = false;
          scanStatus.value = "Not-Scanned";
          documentNo.value = podData.documentNo ?? "N/A";
          isViewVisible.value = false;
          isSubmitVisible.value = true;
          isSelectFileVisible.value = true; 
          Fluttertoast.showToast(msg: "Please, upload pod first");
        }
      } else {
        Fluttertoast.showToast(msg: "There is no pod for this PODNo.");
        resetData();
      }
    } catch (e) {
      logger.e("Search Error: $e");
      Fluttertoast.showToast(msg: "Something went wrong during search.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);

    if (image != null) {
      final userData = _authService.userData;
      final gcNo = podNoController.text.trim().toUpperCase();

      if (gcNo.isEmpty) {
         Fluttertoast.showToast(msg: "Please Enter First POD Number ");
         return;
      }

      // Android file name: P_DOCKNO_USERID_BRCD.jpg
      String fileName = "P_${gcNo}_${userData?.userId}_${userData?.brcd}.jpg";
      
      final directory = await getTemporaryDirectory();
      final String path = "${directory.path}/$fileName";
      await File(image.path).copy(path);
      
      selectedImagePath.value = path;
      selectFileText.value = path;
      
      // Auto-upload image after selection
      uploadImage();
    }
  }

  Future<void> uploadImage() async {
    final gcNo = podNoController.text.trim().toUpperCase();
    
    if (gcNo.isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter GC Number");
      return;
    }

    if (!isSelectFileVisible.value) {
       onSearch();
       return;
    }

    if (selectedImagePath.isEmpty) {
      Fluttertoast.showToast(msg: "Please Select Front Side Image ");
      return;
    }

    final userData = _authService.userData;
    // Android uses "P@dockno@userid@brcd.jpg" for multipart field
    String fileName = "P@$gcNo@${userData?.userId}@${userData?.brcd}.jpg";

    isLoading.value = true;
    try {
      final result = await _apiProvider.uploadPODImage(fileName, selectedImagePath.value);
      if (result != null && result.contains("DONE")) {
        Fluttertoast.showToast(msg: "$gcNo Uploaded Successfully");
        
        if (result.contains("___")) {
          imagePath.value = result.split("___")[1];
        }
        
        onSearch(); // Refresh UI after successful upload
      } else {
        Fluttertoast.showToast(msg: "Image Not Upload , Somthing Wrong ...");
      }
    } catch (e) {
      logger.e("Upload Error: $e");
      Fluttertoast.showToast(msg: "Upload failed: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void viewPod() {
    if (imagePath.isNotEmpty) {
      final String fullImageUrl = imagePath.value.startsWith("http")
          ? imagePath.value
          : "http://103.153.58.129/SafeShipLive/POD_Images/${imagePath.value}";

      Get.toNamed(
        Routes.WEBVIEW_DOCUMENT,
        arguments: {
          'url': fullImageUrl,
          'title': 'POD Image',
        },
      );
    } else {
      Fluttertoast.showToast(msg: "Please try again, unable to find image path");
    }
  }
}
