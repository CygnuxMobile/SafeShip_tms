import 'package:get/get.dart';
import '../controllers/pod_list_controller.dart';

class PodListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodListController>(
      () => PodListController(),
    );
  }
}
