import 'package:get/get.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/pod_filter/bindings/pod_filter_binding.dart';
import '../modules/pod_filter/views/pod_filter_view.dart';
import '../modules/quick_gc/bindings/quick_gc_binding.dart';
import '../modules/quick_gc/views/quick_gc_view.dart';
import '../modules/undelivered_docket/bindings/undelivered_docket_binding.dart';
import '../modules/undelivered_docket/views/undelivered_docket_view.dart';
import '../modules/docket_print/bindings/docket_print_binding.dart';
import '../modules/docket_print/views/docket_print_view.dart';
import '../modules/docket_tracking/bindings/docket_tracking_binding.dart';
import '../modules/docket_tracking/views/docket_tracking_view.dart';
import '../modules/pod_list/bindings/pod_list_binding.dart';
import '../modules/pod_list/views/pod_list_view.dart';
import '../modules/pod_upload/bindings/pod_upload_binding.dart';
import '../modules/pod_upload/views/pod_upload_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';

import '../modules/webview_document/bindings/webview_document_binding.dart';
import '../modules/webview_document/views/webview_document_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.QUICK_GC,
      page: () => const QuickGcView(),
      binding: QuickGcBinding(),
    ),
    GetPage(
      name: _Paths.POD_FILTER,
      page: () => const PodFilterView(),
      binding: PodFilterBinding(),
    ),
    GetPage(
      name: _Paths.DOCKET_TRACKING,
      page: () => const DocketTrackingView(),
      binding: DocketTrackingBinding(),
    ),
    GetPage(
      name: _Paths.POD_LIST,
      page: () => const PodListView(),
      binding: PodListBinding(),
    ),
    GetPage(
      name: _Paths.POD_UPLOAD,
      page: () => const PodUploadView(),
      binding: PodUploadBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW_DOCUMENT,
      page: () => const WebviewDocumentView(),
      binding: WebviewDocumentBinding(),
    ),
    GetPage(
      name: _Paths.UNDELIVERED_DOCKET,
      page: () => const UndeliveredDocketView(),
      binding: UndeliveredDocketBinding(),
    ),
    GetPage(
      name: _Paths.DOCKET_PRINT,
      page: () => const DocketPrintView(),
      binding: DocketPrintBinding(),
    ),
  ];
}
