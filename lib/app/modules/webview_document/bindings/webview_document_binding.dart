import 'package:get/get.dart';
import '../controllers/webview_document_controller.dart';

class WebviewDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WebviewDocumentController>(
      () => WebviewDocumentController(),
    );
  }
}
