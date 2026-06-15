class AppConstants {
  static const String serverUrl = "http://103.153.58.129/SafeShipLiveDataService/AndroidServices.svc/";
  static const String version = "8";
  static const String getApkVersion = "GetAPKVersion";
  
  // API Endpoints
  static const String loginUrl = "RCPL_Login";
  static const String checkGcValidation = "CheckGCValidationForPODUpdate?GCNO=";
  static const String docketTracking = "DocketTracking?DocketNo=";
  static const String getDocket = "GetDocket";
  static const String getLocationList = "GetLocationList";
  static const String quickGcUploadImage = "QuickGC_UploadImage";
  static const String submitQuickGc = "QuickGCGeneration_API";
  static const String getPayBaseList = "GetPayBaseList";
  static const String getCustList = "GetCustList";
  static const String podUploadImage = "POD_UploadImage";
  static const String getPodList = "GC_POD_List";
  static const String getEwayBillDetails = "GetEwaybillDetailsFromAPI";
  static const String getUndeliveredPodList = "DRS_DOCKET_List_API";
  static const String markDocketDelivered = "DRS_DOCKET_Delivered_API";
}
