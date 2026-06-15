import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../../data/providers/api_provider.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  final ApiProvider _apiProvider = ApiProvider();
  final AuthService _authService = Get.find<AuthService>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkAutoLogin();
  }

  void _checkAutoLogin() {
    if (_authService.isLoggedIn) {
      Future.delayed(Duration.zero, () {
        Get.offAllNamed('/home');
      });
    }
  }

  Future<void> login() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
          msg: "Please enter username and password",
          backgroundColor: Colors.red,
          textColor: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final result = await _apiProvider.login(username, password);
      
      
      debugPrint("result ====${result.toJson()}");


      
      if (result.success == "1" && result.response != null) {
        if (result.response!.message?.toUpperCase() == "DONE") {
          _authService.saveLoginData(result.response!);
          Get.offAllNamed('/home');
        } else {
          Fluttertoast.showToast(
              msg: result.response!.message ?? "Login Failed",
              backgroundColor: Colors.orange,
              textColor: Colors.white);
        }
      } else {
        Fluttertoast.showToast(
            msg: result.message ?? "Something went wrong",
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
