import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pod_list_controller.dart';

class PodListView extends GetView<PodListController> {
  const PodListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color radiantColor = Color(0xFF276BB4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'OFFLINE POD UPLOAD',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        centerTitle: false,
        backgroundColor: radiantColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 24.w),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.offlineGCNoList.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator(color: radiantColor));
                }

                if (controller.offlineGCNoList.isEmpty) {
                  return Center(
                    child: Text(
                      "There is nothing for pod upload.",
                      style: TextStyle(fontSize: 16.sp, color: Colors.black54),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.offlineGCNoList.length,
                  padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                  itemBuilder: (context, index) {
                    final pod = controller.offlineGCNoList[index];
                    // Done = '0' means Pending, Done = '1' means Uploaded Offline
                    final bool isUploaded = pod.scanStatus == "1";

                    return Container(
                      margin: EdgeInsets.only(bottom: 15.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: radiantColor, width: 2.w),
                      ),
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(fontSize: 18.sp, color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text: "Dock No : ",
                                      style: TextStyle(
                                        color: radiantColor,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: pod.dOCKNO ?? "N/A",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isUploaded)
                                Text(
                                  "Uploaded Offline",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 45.h,
                                  child: ElevatedButton(
                                    onPressed: () => _showImageSourceDialog(context, index),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: radiantColor,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4.r),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Text(
                                      "UPLOAD",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (isUploaded) ...[
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: SizedBox(
                                    height: 45.h,
                                    child: ElevatedButton(
                                      onPressed: () => _showImageDialog(context, pod.imagePath ?? ""),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: radiantColor,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4.r),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        "VIEW",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Photo!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("Take Photo"),
              onTap: () {
                Get.back();
                controller.captureImage(index, ImageSource.camera);
              },
            ),
            ListTile(
              title: const Text("Choose from Library"),
              onTap: () {
                Get.back();
                controller.captureImage(index, ImageSource.gallery);
              },
            ),
            ListTile(
              title: const Text("Cancel"),
              onTap: () => Get.back(),
            ),
          ],
        ),
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imagePath) {
    if (imagePath.isEmpty) return;
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.all(10.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(10.w),
              child: imagePath.startsWith('http') 
                  ? Image.network(imagePath)
                  : Image.file(File(imagePath)),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: const Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}
