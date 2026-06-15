import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../data/local/db_helper.dart';
import '../../../data/models/pod_data_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/utils/logger.dart';

class PodListController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final DbHelper _dbHelper = DbHelper();
  final AuthService _authService = Get.find<AuthService>();

  final RxList<PodData> offlineGCNoList = <PodData>[].obs;
  final RxBool isLoading = false.obs;

  String fromDate = "";
  String toDate = "";
  String gcNo = "";

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      fromDate = args['fromDate'] ?? "";
      toDate = args['toDate'] ?? "";
      gcNo = args['gcNo'] ?? "";
    }
    fetchPodList();
  }

  Future<void> fetchPodList() async {
    isLoading.value = true;
    try {
      final userData = _authService.userData;
      if (userData == null) return;

      final response = await _apiProvider.getPodList(
        userData.brcd ?? "",
        userData.userId ?? "",
        userData.companyCode ?? "",
        fromDate,
        toDate,
        gcNo,
      );

      if (response != null && response.success == "1") {
        final onlineList = response.response ?? [];
        
        for (var item in onlineList) {
          await _dbHelper.insertPODNoList(item.dOCKNO ?? "", "");
        }
      }
      
      await loadOfflineList();
    } catch (e) {
      logger.e("Error fetching POD list: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOfflineList() async {
    final list = await _dbHelper.selectDocketnoList();
    offlineGCNoList.assignAll(list);
    if (offlineGCNoList.isEmpty) {
      Fluttertoast.showToast(msg: "There is nothing for pod upload.");
    }
  }

  Future<void> captureImage(int index, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);

    if (image != null) {
      final pod = offlineGCNoList[index];
      final userData = _authService.userData;
      
      String fileName = "P@${pod.dOCKNO}@${userData?.userId}@${userData?.brcd}.jpg";
      
      final directory = await getApplicationDocumentsDirectory();
      final String path = "${directory.path}/$fileName";
      await File(image.path).copy(path);

      await _dbHelper.updatePODNoList(pod.dOCKNO ?? "", path);
      
      // Update local list immediately to show "Uploaded Offline"
      await loadOfflineList();
      
      // Try immediate upload
      uploadImage(index, path, fileName);
    }
  }

  Future<void> uploadImage(int index, String imagePath, String fileName) async {
    // We don't set global isLoading to true here to avoid blocking UI
    try {
      final result = await _apiProvider.uploadPODImage(fileName, imagePath);
      if (result != null && result.contains("DONE")) {
        Fluttertoast.showToast(msg: "${fileName.split('@')[1]} Uploaded Successfully");
        await _dbHelper.deletePODNo(fileName.split('@')[1]);
        await loadOfflineList();
      }
    } catch (e) {
      logger.e("Upload Error: $e");
    }
  }

  void logout() {
    _authService.logout();
  }
}
