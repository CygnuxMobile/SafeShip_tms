import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/pod_filter_controller.dart';

class PodFilterView extends GetView<PodFilterController> {
  const PodFilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color radiantColor = Color(0xFF276BB4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'SafeShip POD FILTER',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: radiantColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // POD Number Input (Matches ET_POD_Scan_Filter_Doket_No)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.assignment, color: radiantColor),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: controller.gcNoController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: const InputDecoration(
                          hintText: "POD No:",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 10.h),

              const Text(
                "OR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: radiantColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 15.h),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "From Date : ",
                      style: TextStyle(color: radiantColor, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () => controller.selectDate(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: radiantColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          controller.fromDateDisplay.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),

              // To Date Row
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text(
                      "To Date : ",
                      style: TextStyle(color: radiantColor, fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () => controller.selectDate(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: radiantColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          controller.toDateDisplay.value,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 30.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: controller.onShowList,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: radiantColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                  ),
                  child: const Text(
                    'POD LISTING',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
