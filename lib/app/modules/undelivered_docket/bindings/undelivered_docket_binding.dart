import 'package:get/get.dart';

import '../controllers/undelivered_docket_controller.dart';

class UndeliveredDocketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UndeliveredDocketController>(
      () => UndeliveredDocketController(),
    );
  }
}
