import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/docket_print_controller.dart';

class DocketPrintView extends GetView<DocketPrintController> {
  const DocketPrintView({super.key});

  @override
  Widget build(BuildContext context) {
    const radiantColor = Color(0xFF276BB4);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: radiantColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "Docket Print",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isConnected.value ? Icons.bluetooth_connected : Icons.bluetooth,
                  color: controller.isConnected.value ? Colors.greenAccent : Colors.white,
                ),
                onPressed: () async {
                  bool granted = await controller.requestPermissions();
                  if (granted) {
                    _showBluetoothBottomSheet(context);
                  } else {
                    Fluttertoast.showToast(msg: "Bluetooth permissions are required");
                  }
                },
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            // Search Section
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.docketController,
                      decoration: InputDecoration(
                        labelText: "Enter Docket Number",
                        hintText: "e.g. 1000180488",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => controller.resetSearch(),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSubmitted: (_) => controller.fetchDocketData(),
                    ),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: Obx(() => ElevatedButton(
                            onPressed: controller.isApiLoading.value
                                ? null
                                : () => controller.fetchDocketData(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: radiantColor,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                            ),
                            child: controller.isApiLoading.value
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    "Fetch Docket Details",
                                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                                  ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),

            Obx(() => Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: controller.isConnected.value ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: controller.isConnected.value ? Colors.green : Colors.red),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        controller.isConnected.value ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
                        color: controller.isConnected.value ? Colors.green : Colors.red,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          controller.isConnected.value
                              ? "Connected: ${controller.connectedDevice.value?.name ?? controller.connectedDevice.value?.address}"
                              : "Printer not connected",
                          style: TextStyle(
                            color: controller.isConnected.value ? Colors.green.shade900 : Colors.red.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (controller.isConnected.value)
                        TextButton(
                          onPressed: () => controller.disconnect(),
                          child: const Text("Disconnect", style: TextStyle(color: Colors.red)),
                        ),
                    ],
                  ),
                )),
            SizedBox(height: 20.h),

            // Docket Data Detail Section
            Obx(() {
              if (controller.docketData.value == null) {
                return const SizedBox.shrink();
              }
              final data = controller.docketData.value!;
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Docket Details",
                          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: radiantColor),
                        ),
                      ),
                      const Divider(),
                      _buildDetailRow("Docket No:", data.dOCKNO ?? ""),
                      _buildDetailRow("Date:", data.dOCKDT ?? ""),
                      _buildDetailRow("EDD:", data.eDD ?? ""),
                      _buildDetailRow("From:", data.oRGNCD ?? ""),
                      _buildDetailRow("To:", data.toLoc ?? ""),
                      _buildDetailRow("Consignor:", data.cSGENM ?? ""),
                      _buildDetailRow("Consignee:", data.cSGNNM ?? ""),
                      _buildDetailRow("Packages:", "${data.pKGSNO ?? 0}"),
                      _buildDetailRow("Weight:", "${data.aCTUWT ?? 0} Kg"),
                      SizedBox(height: 20.h),
                      
                      // Print All Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: Obx(() => ElevatedButton.icon(
                              onPressed: controller.boxNumbers.isNotEmpty
                                  ? (controller.isPrinting.value
                                      ? () => controller.cancelPrinting()
                                      : () {
                                          if (!controller.isConnected.value) {
                                            Fluttertoast.showToast(msg: "Please connect to a printer first");
                                            return;
                                          }
                                          controller.printAllBoxes();
                                        })
                                  : null,
                              icon: Icon(
                                controller.isPrinting.value ? Icons.stop : Icons.print,
                                color: Colors.white,
                              ),
                              label: Text(
                                controller.isPrinting.value
                                    ? "STOP PRINTING (${controller.printProgress.value}/${controller.totalToPrint.value})"
                                    : "PRINT ALL BOXES",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isPrinting.value ? Colors.red : Colors.orange.shade700,
                                disabledBackgroundColor: Colors.grey.shade400,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              ),
                            )),
                      ),
                      
                      Obx(() => controller.isPrinting.value
                          ? Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: LinearProgressIndicator(
                                value: controller.totalToPrint.value > 0
                                    ? controller.printProgress.value / controller.totalToPrint.value
                                    : 0,
                                backgroundColor: Colors.grey.shade200,
                                valueColor: AlwaysStoppedAnimation<Color>(radiantColor),
                              ),
                            )
                          : const SizedBox.shrink()),

                      SizedBox(height: 15.h),
                      
                      // Individual Box Print Button
                      SizedBox(
                        width: double.infinity,
                        height: 45.h,
                        child: Obx(() => OutlinedButton.icon(
                              onPressed: controller.boxNumbers.isEmpty
                                  ? null
                                  : () {
                                      if (!controller.isConnected.value) {
                                        Fluttertoast.showToast(msg: "Please connect to a printer first");
                                      }
                                      _showBoxListBottomSheet(context);
                                    },
                              icon: Icon(
                                Icons.list_alt,
                                color: controller.boxNumbers.isEmpty ? Colors.grey : radiantColor,
                              ),
                              label: Text(
                                "INDIVIDUAL BOX PRINT",
                                style: TextStyle(
                                  color: controller.boxNumbers.isEmpty ? Colors.grey : radiantColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: controller.boxNumbers.isEmpty ? Colors.grey.shade300 : radiantColor,
                                ),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                              ),
                            )),
                      ),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.grey.shade700),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _showBoxListBottomSheet(BuildContext context) {
    controller.boxSearchController.clear();
    controller.filterBoxes("");
    
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
        ),
        child: Column(
          children: [
            // Handle for BottomSheet
            Container(
              margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Select Box to Print",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF276BB4),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey.shade600),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),

            // Search Bar UI Upgrade
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: TextField(
                controller: controller.boxSearchController,
                onChanged: (value) => controller.filterBoxes(value),
                decoration: InputDecoration(
                  hintText: "Search box number...",
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF276BB4)),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                ),
              ),
            ),
            
            SizedBox(height: 15.h),
            
            Expanded(
              child: Obx(() {
                if (controller.filteredBoxNumbers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64.sp, color: Colors.grey.shade300),
                        SizedBox(height: 16.h),
                        const Text("No boxes found", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  itemCount: controller.filteredBoxNumbers.length,
                  itemBuilder: (context, index) {
                    final box = controller.filteredBoxNumbers[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                        onTap: controller.isConnected.value 
                            ? () => controller.printBox(box)
                            : () => Fluttertoast.showToast(msg: "Connect printer first"),
                        title: Text(
                          box,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: controller.isConnected.value 
                                ? const Color(0xFF276BB4).withOpacity(0.1) 
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.print,
                            color: controller.isConnected.value 
                                ? const Color(0xFF276BB4) 
                                : Colors.grey,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      enableDrag: true,
    );
  }

  void _showBluetoothBottomSheet(BuildContext context) {
    controller.getDevices();
    Get.bottomSheet(
      Container(
        height: 450.h,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Select Printer",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF276BB4),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => controller.getDevices(),
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: Obx(() {
                if (controller.isScanning.value && controller.devices.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (controller.devices.isEmpty) {
                  return const Center(
                    child: Text("No devices found"),
                  );
                }
                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    BluetoothDevice device = controller.devices[index];
                    bool isThisConnected = controller.connectedDevice.value?.address == device.address && controller.isConnected.value;
                    
                    return ListTile(
                      leading: const Icon(Icons.print),
                      title: Text(device.name ?? "Unknown Device"),
                      subtitle: Text(device.address),
                      trailing: isThisConnected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : Obx(() {
                              bool isCurrentlyConnecting = controller.isConnecting.value &&
                                  controller.connectingAddress.value == device.address;

                              return ElevatedButton(
                                onPressed: controller.isConnecting.value
                                    ? null
                                    : () => controller.connect(device),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF276BB4),
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                child: isCurrentlyConnecting
                                    ? SizedBox(
                                        width: 15.w,
                                        height: 15.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text("Connect",
                                        style: TextStyle(color: Colors.white)),
                              );
                            }),
                    );
                  },
                );
              }),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
