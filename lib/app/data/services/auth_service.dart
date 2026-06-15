import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/login_response_model.dart';

class AuthService extends GetxService {
  final _storage = GetStorage();
  final _isLoggedIn = false.obs;
  final Rxn<UserData> _userData = Rxn<UserData>();

  bool get isLoggedIn => _isLoggedIn.value;
  UserData? get userData => _userData.value;

  static const String _userKey = 'user_data';

  Future<AuthService> init() async {
    try {
      final data = _storage.read(_userKey);
      if (data != null) {
        _userData.value = UserData.fromJson(data);
        _isLoggedIn.value = true;
      }
    } catch (e) {
      print("AuthService Init Error: $e");
    }
    return this;
  }

  void saveLoginData(UserData data) {
    _userData.value = data;
    _isLoggedIn.value = true;
    _storage.write(_userKey, data.toJson());
  }

  void logout() {
    _storage.remove(_userKey);
    _userData.value = null;
    _isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}
