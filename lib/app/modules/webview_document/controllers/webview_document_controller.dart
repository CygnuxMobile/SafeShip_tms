import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewDocumentController extends GetxController {
  late final WebViewController webViewController;
  final RxBool isLoading = true.obs;
  String? url;
  String? title;

  @override
  void onInit() {
    super.onInit();
    url = Get.arguments['url'];
    title = Get.arguments['title'] ?? "POD Image";

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            isLoading.value = true;
          },
          onPageFinished: (String url) {
            isLoading.value = false;
          },
          onWebResourceError: (WebResourceError error) {
            isLoading.value = false;
          },
        ),
      );

    if (url != null && url!.isNotEmpty) {
      webViewController.loadRequest(Uri.parse(url!));
    }
  }
}
