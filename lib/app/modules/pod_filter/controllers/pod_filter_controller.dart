import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../routes/app_pages.dart';

class PodFilterController extends GetxController {
  final fromDateController = TextEditingController();
  final toDateController = TextEditingController();
  final gcNoController = TextEditingController();
  
  final fromDateDisplay = "".obs;
  final toDateDisplay = "".obs;
  
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    fromDateDisplay.value = DateFormat('dd MMM yyyy').format(selectedFromDate);
    toDateDisplay.value = DateFormat('dd MMM yyyy').format(selectedToDate);
    fromDateController.text = fromDateDisplay.value;
    toDateController.text = toDateDisplay.value;
  }

  Future<void> selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isFromDate ? selectedFromDate : selectedToDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      if (isFromDate) {
        selectedFromDate = picked;
        fromDateDisplay.value = DateFormat('dd MMM yyyy').format(selectedFromDate);
        fromDateController.text = fromDateDisplay.value;
      } else {
        selectedToDate = picked;
        toDateDisplay.value = DateFormat('dd MMM yyyy').format(selectedToDate);
        toDateController.text = toDateDisplay.value;
      }
    }
  }

  void onShowList() {
    Get.toNamed(Routes.POD_LIST, arguments: {
      'fromDate': DateFormat('dd-MMM-yyyy').format(selectedFromDate),
      'toDate': DateFormat('dd-MMM-yyyy').format(selectedToDate),
      'gcNo': gcNoController.text.trim(),
    });
  }
}
