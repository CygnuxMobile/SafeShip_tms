import 'package:get/get.dart';
import '../controllers/docket_print_controller.dart';

class DocketPrintBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DocketPrintController>(
      () => DocketPrintController(),
    );
  }
}
