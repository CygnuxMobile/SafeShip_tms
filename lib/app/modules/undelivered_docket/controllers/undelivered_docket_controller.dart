import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/pod_data_model.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';

class UndeliveredDocketController extends GetxController {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final AuthService _authService = Get.find<AuthService>();
  
  final docketNoController = TextEditingController();
  final RxString selectedDate = 'Select Date'.obs;
  final RxList<String> dateOptions = ['Select Date', 'Today', 'Yesterday', 'Last 2 Days', 'Last 3 Days'].obs;
  
  final RxList<PodData> undeliveredList = <PodData>[].obs;
  final RxBool isLoading = false.obs;

  void onSearch() async {
    if (docketNoController.text.isEmpty && selectedDate.value == 'Select Date') {
      Get.snackbar('INFO', 'Please choose criteria for Filter');
      return;
    }

    String fromDate = "";
    String toDate = "";
    DateTime today = DateTime.now();
    DateFormat df = DateFormat('dd MMM yyyy');

    if (selectedDate.value == 'Today') {
      fromDate = df.format(today);
      toDate = df.format(today);
    } else if (selectedDate.value == 'Yesterday') {
      DateTime yesterday = today.subtract(const Duration(days: 1));
      fromDate = df.format(yesterday);
      toDate = df.format(yesterday);
    } else if (selectedDate.value == 'Last 2 Days') {
      DateTime twoDaysAgo = today.subtract(const Duration(days: 2));
      fromDate = df.format(twoDaysAgo);
      toDate = df.format(today);
    } else if (selectedDate.value == 'Last 3 Days') {
      DateTime threeDaysAgo = today.subtract(const Duration(days: 3));
      fromDate = df.format(threeDaysAgo);
      toDate = df.format(today);
    }

    isLoading.value = true;
    try {
      final user = _authService.userData;
      final response = await _apiProvider.getUndeliveredPodList(
        user?.brcd ?? "",
        user?.userId ?? "",
        user?.companyCode ?? "",
        toDate,
        fromDate,
        docketNoController.text,
      );

      if (response != null && response.success == "1") {
        undeliveredList.assignAll(response.response ?? []);
        if (undeliveredList.isEmpty) {
          Get.snackbar('INFO', 'There is no Undelivered Docket.');
        }
      } else {
        Get.snackbar('ERROR', response?.message ?? 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void markAsDelivered(PodData pod, int index) async {
    isLoading.value = true;
    try {
      DateTime now = DateTime.now();
      String delyDate = DateFormat('dd MMM yyyy').format(now);
      String delyTime = DateFormat('HH:mm:ss').format(now);
      final user = _authService.userData;

      final response = await _apiProvider.markDocketDelivered(
        pod.dOCKNO ?? "",
        pod.dRS ?? "",
        pod.dOCKSF ?? "",
        user?.userId ?? "",
        user?.brcd ?? "",
        delyDate,
        delyTime,
      );

      if (response['Success'] == "1") {
        Get.snackbar('Success', 'Delivered..! ${pod.dOCKNO} delivered, Success ...');
        onSearch(); 
      } else {
        String msg = response['Response']?['MESSAGE'] ?? response['Message'] ?? "Failed";
        Get.snackbar('Alert', msg);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    docketNoController.dispose();
    super.onClose();
  }
}
