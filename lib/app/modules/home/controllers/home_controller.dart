import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../core/utils/logger.dart';

enum MenuType {
  podUpload,
  podView,
  quickGcGenerate,
  undeliveredDocket,
  docketPrint
}

class HomeMenu {
  final MenuType type;
  final String? imagePath;
  final IconData? icon;
  final String title;

  HomeMenu({required this.type, this.imagePath, this.icon, required this.title});
}

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  
  final menus = <HomeMenu>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMenus();
  }

  void _loadMenus() {
    final userData = _authService.userData;
    
    // Labels matching legacy Android Home.java logic
    String menu1Label = (userData?.menu1 == null || userData?.menu1 == "" || userData?.menu1?.toLowerCase() == "null") 
        ? "POD Upload" 
        : userData!.menu1!;
        
    String menu2Label = (userData?.menu2 == null || userData?.menu2 == "" || userData?.menu2?.toLowerCase() == "null") 
        ? "POD View" 
        : userData!.menu2!;

    menus.clear();
    menus.addAll([
      HomeMenu(type: MenuType.podUpload, imagePath: "assets/images/upload.png", title: menu1Label),
      HomeMenu(type: MenuType.podView, imagePath: "assets/images/view.png", title: menu2Label),
      HomeMenu(type: MenuType.quickGcGenerate, imagePath: "assets/images/view_pod.png", title: "Quick GC Generate"),
      HomeMenu(type: MenuType.undeliveredDocket, imagePath: "assets/images/undelivered.png", title: "Undelivered Docket"),
      HomeMenu(type: MenuType.docketPrint, icon: Icons.print, title: "Docket Print"),
    ]);
  }

  void logout() {
    _authService.logout();
  }

  void onMenuClick(MenuType type) {
    switch (type) {
      case MenuType.podUpload:
        Get.toNamed(Routes.POD_FILTER);
        break;
      case MenuType.podView:
        Get.toNamed(Routes.POD_UPLOAD); 
        break;
      case MenuType.quickGcGenerate:
        Get.toNamed(Routes.QUICK_GC);
        break;
      case MenuType.undeliveredDocket:
        Get.toNamed(Routes.UNDELIVERED_DOCKET);
        break;
      case MenuType.docketPrint:
        Get.toNamed(Routes.DOCKET_PRINT);
        break;
    }
  }
}
