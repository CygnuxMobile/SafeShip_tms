import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/pod_upload_controller.dart';

class PodUploadView extends GetView<PodUploadController> {
  const PodUploadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color radiantColor = Color(0xFF276BB4);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'SafeShip POD VIEW',
          style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: radiantColor,
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        elevation: 0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            child: Column(
              children: [
                // POD Number Input
                TextField(
                  controller: controller.podNoController,
                  onSubmitted: (_) => controller.validateGcNo(),
                  textCapitalization: TextCapitalization.characters,
                  style: TextStyle(color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: "POD No:",
                    hintStyle: TextStyle(color: Colors.grey.shade400,),
                    suffixIcon: Obx(() => (controller.showClearButton.value || controller.isSearchDone.value)
                        ? IconButton(
                            icon: const Icon(Icons.close, color: Colors.black54),
                            onPressed: () {
                              controller.resetData();
                            },
                          )
                        : const SizedBox.shrink()),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: radiantColor, width: 1.5),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),

                SizedBox(height: 25.h),

                // Search/Submit Button - Matches the screenshot (Full width, Blue, Flat, Bold text)
                Obx(() {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.uploadImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: radiantColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          controller.isSubmitVisible.value ? "SUBMIT" : "SEARCH",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                SizedBox(height: 30.h),

                // Search Results and additional view elements
                Obx(() {
                  if (!controller.isSearchDone.value) return const SizedBox.shrink();

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _infoCard("Document No", controller.documentNo)),
                          Expanded(child: _infoCard("Scan Status", controller.scanStatus)),
                        ],
                      ),
                      SizedBox(height: 20.h),
                      
                      // View Section
                      if (controller.isViewVisible.value) ...[
                        Row(
                          children: [
                            Text(
                              "Document View :-",
                              style: TextStyle(fontSize: 16.sp, color: Colors.black),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 150.w,
                              height: 45.h,
                              child: ElevatedButton(
                                onPressed: controller.viewPod,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: radiantColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                                  padding: EdgeInsets.zero,
                                ),
                                child: Text(
                                  "View",
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                      
                      // Select File Section
                      if (controller.isSelectFileVisible.value) ...[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Upload Front Image :-",
                                style: TextStyle(fontSize: 16.sp, color: Colors.black),
                              ),
                            ),
                            SizedBox(
                              width: 150.w,
                              height: 45.h,
                              child: ElevatedButton(
                                onPressed: () => _showImageSourceDialog(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Colors.black54),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
                                ),
                                child: Obx(() => Text(
                                  controller.selectedImagePath.isEmpty ? "SELECT FILE" : "FILE SELECTED",
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                          ],
                        ),
                        if (controller.selectedImagePath.isNotEmpty) 
                          Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: Text(
                              controller.selectedImagePath.value.split('/').last,
                              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        SizedBox(height: 20.h),
                      ],
                        
                      // Image Preview
                      Obx(() {
                        if (controller.selectedImagePath.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 25.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Selected Image Preview:", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87)),
                                SizedBox(height: 12.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Image.file(
                                    File(controller.selectedImagePath.value),
                                    width: double.infinity,
                                    height: 250.h,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
          
          // Loading Overlay
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(radiantColor),
                    strokeWidth: 3,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _infoCard(String title, RxString value) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 6.h),
          Obx(() => Text(
                value.value,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select Image Source", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.h),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF276BB4)),
              title: const Text("Take Photo"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF276BB4)),
              title: const Text("Choose from Library"),
              onTap: () {
                Get.back();
                controller.pickImage(ImageSource.gallery);
              },
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
