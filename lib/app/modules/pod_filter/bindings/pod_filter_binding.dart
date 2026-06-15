import 'package:get/get.dart';
import '../controllers/pod_filter_controller.dart';

class PodFilterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodFilterController>(
      () => PodFilterController(),
    );
  }
}
