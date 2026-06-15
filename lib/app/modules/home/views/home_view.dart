import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const radiantColor = Color(0xFF276BB4);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: radiantColor,
        automaticallyImplyLeading: false,
        title: Text(
          "SafeShip",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to logout?",
                textConfirm: "Yes",
                textCancel: "No",
                confirmTextColor: Colors.white,
                buttonColor: radiantColor,
                onConfirm: () {
                  Get.back(); // close dialog
                  controller.logout();
                },
              );
            },
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 28.w,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Center(
                child: Container(
                  width: 150.w,
                  height: 150.w,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/safe_ship_logo.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Obx(() => GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.w,
                        mainAxisSpacing: 10.h,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: controller.menus.length,
                      itemBuilder: (context, index) {
                        final menu = controller.menus[index];
                        return InkWell(
                          onTap: () => controller.onMenuClick(menu.type),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF276BB4),
                              borderRadius: BorderRadius.circular(15.r),
                              border: Border.all(color: const Color(0xFF276BB4), width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                menu.imagePath != null
                                    ? Image.asset(
                                        menu.imagePath!,
                                        height: 50.h,
                                        width: 50.w,
                                        color: Colors.white,
                                      )
                                    : Icon(
                                        menu.icon,
                                        size: 50.h,
                                        color: Colors.white,
                                      ),
                                SizedBox(height: 10.h),
                                Text(
                                  menu.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
              SizedBox(height: 30.h),
              const Text("Version: ", style: TextStyle(fontSize: 14, color: Colors.black)),
              const Text(
                "8",
                style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
