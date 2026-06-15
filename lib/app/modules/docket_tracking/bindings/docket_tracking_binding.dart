import 'package:get/get.dart';
import '../controllers/docket_tracking_controller.dart';

class DocketTrackingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocketTrackingController>(
      () => DocketTrackingController(),
    );
  }
}
