import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/quick_gc_controller.dart';
import '../../../data/models/billing_party_model.dart';
import '../../../data/models/billing_type_model.dart';
import '../../../data/models/location_response_model.dart';
import 'qr_scanner_view.dart';

class QuickGcView extends GetView<QuickGcController> {
  const QuickGcView({super.key});

  @override
  Widget build(BuildContext context) {
    const radiantColor = Color(0xFF276BB4);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: radiantColor,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          "Quick GC Generate",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 60.h),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller.eWayBillNoController,
                              "E-Way Bill No",
                              keyboardType: TextInputType.number,
                              onChanged: (val) {
                                if (val.length > 12) {
                                  controller.eWayBillNoController.text = val
                                      .substring(0, 12);
                                  controller.eWayBillNoController.selection =
                                      TextSelection.fromPosition(
                                        TextPosition(
                                          offset: controller
                                              .eWayBillNoController
                                              .text
                                              .length,
                                        ),
                                      );
                                }
                                if (val.length == 12) {
                                  controller.fetchEwaybillDetails(val);
                                }
                              },
                            ),
                          ),
                          SizedBox(width: 8.w),
                          InkWell(
                            onTap: () async {
                              final result = await Get.to(
                                () => const QRScannerView(),
                              );
                              if (result != null) {
                                controller.eWayBillNoController.text = result;
                                controller.fetchEwaybillDetails(result);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Icon(
                                Icons.qr_code_scanner,
                                size: 30.w,
                                color: const Color(0xFF276BB4),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // 2. Docket No
                      _buildTextField(
                        controller.cNoteNoController,
                        "Docket No",
                        onChanged: (val) {
                          if (val.length >= 5) {
                            controller.checkDocket(val);
                          }
                        },
                      ),

                      // 3. Docket Date
                      _buildTextField(
                        controller.todayDateController,
                        "Docket Date",
                        readOnly: true,
                      ),

                      // 4. Origin
                      _buildTextField(
                        controller.originController,
                        "Origin",
                        readOnly: true,
                      ),

                      // 5. Destination (Autocomplete)
                      _buildLocationDropdown(),

                      // 6. Billing Type (Dropdown)
                      Obx(
                        () => controller.ewayBillPaybas.value != null
                            ? _buildTextField(
                                controller.billingTypeController,
                                "Billing Type",
                                readOnly: true,
                              )
                            : _buildBillingTypeDropdown(),
                      ),

                      // 7. Consignor (Autocomplete)
                      Obx(
                        () => controller.ewayBillPartyName.value != null
                            ? _buildTextField(
                                controller.billingPartyController,
                                "Consignor",
                                readOnly: true,
                              )
                            : _buildBillingPartyDropdown(),
                      ),

                      // 8. No Of Package
                      _buildTextField(
                        controller.noOfPackageController,
                        "No Of Package",
                        keyboardType: TextInputType.number,
                      ),

                      // 9. Invoice No
                      _buildTextField(
                        controller.invoiceNoController,
                        "Invoice No",
                      ),

                      SizedBox(height: 10.h),
                      // 10. Invoice Upload Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF276BB4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                          ),
                          onPressed: () => _showImageSourceDialog(),
                          icon: Icon(
                            controller.isImageUploaded.value
                                ? Icons.check_circle
                                : Icons.upload,
                            color: Colors.white,
                          ),
                          label: Text(
                            controller.isImageUploaded.value
                                ? "Invoice Uploaded"
                                : "INVOICE UPLOAD",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20.h),
                      // 11. Back & Submit Buttons
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                onPressed: () => Get.back(),
                                child: const Text(
                                  "BACK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: SizedBox(
                              height: 50.h,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF276BB4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                ),
                                onPressed: () => controller.submitQuickGc(),
                                child: const Text(
                                  "SUBMIT",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label, {
    bool readOnly = false,
    TextInputType? keyboardType,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: TextField(
        controller: ctrl,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
          border: const OutlineInputBorder(),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF276BB4)),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
          fillColor: readOnly ? Colors.grey[100] : Colors.white,
          filled: true,
        ),
      ),
    );
  }

  Widget _buildLocationDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownSearch<GetLocationResponse>(
        items: (filter, loadProps) => controller.locations,
        itemAsString: (item) => item.locCode ?? "",
        compareFn: (i, s) => i.locCode == s.locCode,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Destination",
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF276BB4)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search Destination",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        selectedItem: controller.selectedDestination.value,
        onSelected: (selection) =>
            controller.selectedDestination.value = selection,
      ),
    );
  }

  Widget _buildBillingTypeDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownSearch<BillingType>(
        items: (filter, loadProps) => controller.billingTypes,
        itemAsString: (item) => item.codeDesc ?? "",
        compareFn: (i, s) => i.codeId == s.codeId,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Billing Type",
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF276BB4)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        popupProps: const PopupProps.menu(showSearchBox: true),
        selectedItem: controller.selectedBillingType.value,
        onSelected: (val) => controller.selectedBillingType.value = val,
      ),
    );
  }

  Widget _buildBillingPartyDropdown() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: DropdownSearch<BillingParty>(
        items: (filter, loadProps) => controller.billingParties,
        itemAsString: (item) => item.toString(),
        compareFn: (i, s) => i.custcd == s.custcd,
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: "Consignor",
            labelStyle: TextStyle(color: Colors.grey[700], fontSize: 14.sp),
            border: const OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF276BB4)),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 12.h,
            ),
          ),
        ),
        popupProps: PopupProps.menu(
          showSearchBox: true,
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              hintText: "Search Consignor",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),
        ),
        selectedItem: controller.selectedBillingParty.value,
        onSelected: (selection) =>
            controller.selectedBillingParty.value = selection,
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Row(
      children: [
        Expanded(
          child: Text(
            controller.isImageUploaded.value
                ? "Image Uploaded: ${controller.uploadedImageName.value}"
                : "No Invoice Image Uploaded",
            style: TextStyle(
              color: controller.isImageUploaded.value
                  ? Colors.green
                  : Colors.red,
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _showImageSourceDialog(),
          icon: const Icon(Icons.upload),
          label: const Text("Upload Invoice"),
        ),
      ],
    );
  }

  void _showImageSourceDialog() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text("Camera"),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () {
                  Get.back();
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
