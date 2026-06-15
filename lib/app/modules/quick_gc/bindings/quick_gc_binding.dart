import 'package:get/get.dart';
import '../controllers/quick_gc_controller.dart';

class QuickGcBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuickGcController>(() => QuickGcController());
  }
}
