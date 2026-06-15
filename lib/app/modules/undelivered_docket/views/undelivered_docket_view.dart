import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/undelivered_docket_controller.dart';

class UndeliveredDocketView extends GetView<UndeliveredDocketController> {
  const UndeliveredDocketView({super.key});

  @override
  Widget build(BuildContext context) {
    const radiantColor = Color(0xFF276BB4);
    const screenBgColor = Color(0xFFF5F5F5);

    return Scaffold(
      backgroundColor: screenBgColor,
      appBar: AppBar(
        backgroundColor: radiantColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'UNDELIVERED DRS FILTER',
          style: TextStyle(color: Colors.white, fontSize: 18.sp),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: Column(
                  children: [
                    // DRS No Input
                    Container(
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.r),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: controller.docketNoController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          hintText: "DRS No.",
                          prefixIcon: const Icon(Icons.edit_note, color: radiantColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5.h),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: radiantColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    // Date Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5.w),
                          child: Text(
                            "Select Date",
                            style: TextStyle(fontSize: 14.sp, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Obx(() => DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: controller.selectedDate.value,
                                  items: controller.dateOptions.map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.black)),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    if (newValue != null) {
                                      controller.selectedDate.value = newValue;
                                    }
                                  },
                                ),
                              )),
                        ),
                      ],
                    ),

                    SizedBox(height: 15.h),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.onSearch,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: radiantColor,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.r),
                          ),
                        ),
                        child: Text(
                          'UNDELIVERED DOCKET LISTING',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // Divider View
                    Container(
                      height: 2.h,
                      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                      color: radiantColor,
                    ),

                    // List View
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.undeliveredList.length,
                        itemBuilder: (context, index) {
                          final item = controller.undeliveredList[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            padding: EdgeInsets.all(5.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.r),
                              border: Border.all(color: radiantColor, width: 1),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "DRS NO",
                                            style: TextStyle(color: radiantColor, fontSize: 14.sp),
                                          ),
                                          Text(
                                            item.dRS ?? "N/A",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(
                                            "DOCK NO",
                                            style: TextStyle(color: radiantColor, fontSize: 14.sp),
                                          ),
                                          Text(
                                            item.dOCKNO ?? "N/A",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => controller.markAsDelivered(item, index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: radiantColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5.r),
                                      ),
                                    ),
                                    child: const Text(
                                      'Delivered',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
