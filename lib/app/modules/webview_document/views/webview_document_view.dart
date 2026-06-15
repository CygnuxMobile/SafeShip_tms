import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../controllers/webview_document_controller.dart';

class WebviewDocumentView extends GetView<WebviewDocumentController> {
  const WebviewDocumentView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title ?? "POD Image", style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF276BB4),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: controller.webViewController),
          Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator(color: Color(0xFF276BB4)))
              : const SizedBox.shrink()),
        ],
      ),
    );
  }
}
