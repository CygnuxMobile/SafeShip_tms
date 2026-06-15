import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/docket_tracking_controller.dart';
import '../../../data/models/docket_tracking_model.dart';

class DocketTrackingView extends GetView<DocketTrackingController> {
  const DocketTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryBlue = Color(0xFF276BB4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("SafeShip", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryBlue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // Search Section
          Padding(
            padding: EdgeInsets.all(10.w),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.docketNoController,
                    decoration: const InputDecoration(
                      hintText: "Enter Docket Number",
                      hintStyle: TextStyle(color: Colors.black54),
                      isDense: true,
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                IconButton(
                  onPressed: controller.getDocketTracking,
                  icon: Icon(Icons.search, color: primaryBlue, size: 30.w),
                ),
              ],
            ),
          ),

          // List Section
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  if (controller.docketList.isEmpty && !controller.isLoading.value) {
                    return const Center(child: Text("No records found"));
                  }
                  return ListView.builder(
                    itemCount: controller.docketList.length,
                    itemBuilder: (context, index) {
                      final item = controller.docketList[index];
                      return _buildDocketCard(item, primaryBlue);
                    },
                  );
                }),
                
                // Loading Overlay
                Obx(() => controller.isLoading.value
                    ? Container(
                        color: Colors.black12,
                        child: const Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocketCard(DocketData item, Color primaryColor) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      elevation: 4,
      color: const Color(0xFFF5F5F5), // card_backg_color common name
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            // Top Row: Docket No & Package No
            Row(
              children: [
                Text(
                  "Docket No : ",
                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                ),
                Expanded(
                  child: Text(
                    item.docNo ?? "",
                    style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Current Pkg No : ",
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
                Text(
                  item.totalPkg ?? "",
                  style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(color: Colors.grey.shade300),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("From", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                    Text(
                      item.fromLoc ?? "",
                      style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    color: Colors.grey.shade300,
                  ),
                ),

                Transform.rotate(
                  angle: 1.5708,
                  child: Icon(Icons.airplanemode_active, color: primaryColor, size: 24.w),
                ),

                Expanded(
                  child: Container(
                    height: 1,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    color: Colors.grey.shade300,
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("To", style: TextStyle(fontSize: 10.sp, color: Colors.grey)),
                    Text(
                      item.toLoc ?? "",
                      style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ],
            ),
            Divider(color: Colors.grey.shade300),

            Row(
              children: [
                Text(
                  "Total no of pkg : ",
                  style: TextStyle(fontSize: 10.sp, color: Colors.black54),
                ),
                Expanded(
                  child: Text(
                    item.totalPkg ?? "",
                    style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Inv No : ",
                  style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                ),
                Text(
                  item.invNo ?? "",
                  style: TextStyle(fontSize: 12.sp, color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            if (item.images != null && item.images!.isNotEmpty) ...[
              SizedBox(height: 10.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: _buildImage(item.images!),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String base64String) {
    try {
      final bytes = base64Decode(base64String.trim());
      return Image.memory(
        bytes,
        height: 150.h,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      );
    } catch (e) {
      return const SizedBox.shrink();
    }
  }
}
