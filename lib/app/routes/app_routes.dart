part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const LOGIN = _Paths.LOGIN;
  static const HOME = _Paths.HOME;
  static const QUICK_GC = _Paths.QUICK_GC;
  static const SPLASH = _Paths.SPLASH;
  static const POD_UPLOAD = _Paths.POD_UPLOAD;
  static const POD_FILTER = _Paths.POD_FILTER;
  static const POD_LIST = _Paths.POD_LIST;
  static const UNDELIVERED_DOCKET = _Paths.UNDELIVERED_DOCKET;
  static const DOCKET_TRACKING = _Paths.DOCKET_TRACKING;
  static const WEBVIEW_DOCUMENT = _Paths.WEBVIEW_DOCUMENT;
  static const DOCKET_PRINT = _Paths.DOCKET_PRINT;
}

abstract class _Paths {
  _Paths._();
  static const LOGIN = '/login';
  static const HOME = '/home';
  static const QUICK_GC = '/quick-gc';
  static const SPLASH = '/splash';
  static const POD_UPLOAD = '/pod-upload';
  static const POD_FILTER = '/pod-filter';
  static const POD_LIST = '/pod-list';
  static const UNDELIVERED_DOCKET = '/undelivered-docket';
  static const DOCKET_TRACKING = '/docket-tracking';
  static const WEBVIEW_DOCUMENT = '/webview-document';
  static const DOCKET_PRINT = '/docket-print';
}
