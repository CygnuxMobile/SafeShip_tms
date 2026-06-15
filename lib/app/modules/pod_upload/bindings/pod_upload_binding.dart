import 'package:get/get.dart';
import '../controllers/pod_upload_controller.dart';

class PodUploadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PodUploadController>(
      () => PodUploadController(),
    );
  }
}
