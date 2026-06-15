import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/docket_tracking_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../core/utils/logger.dart';

class DocketTrackingController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  
  final docketNoController = TextEditingController();
  final docketList = <DocketData>[].obs;
  final isLoading = false.obs;

  Future<void> getDocketTracking() async {
    final docketNo = docketNoController.text.trim();
    if (docketNo.isEmpty) {
      Get.snackbar("Alert..!!", "Please Enter Docket Number");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiProvider.getDocketTracking(docketNo);
      if (response != null && (response.success == 1 || response.success == "1")) {
        if (response.response != null && response.response!.isNotEmpty) {
          docketList.assignAll(response.response!);
        } else {
          docketList.clear();
          Get.snackbar("Aadhar", "Item Not Found");
        }
      } else {
        docketList.clear();
        Get.snackbar("Aadhar", response?.message ?? "Item Not Found");
      }
    } catch (e) {
      logger.e("Error fetching docket tracking: $e");
      Get.snackbar("Aadhar", "Server Not Responding");
    } finally {
      isLoading.value = false;
    }
  }
}
