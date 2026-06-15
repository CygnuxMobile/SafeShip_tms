import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import '../data/local/db_helper.dart';
import '../data/providers/api_provider.dart';
import '../core/utils/logger.dart';
import '../data/models/pod_data_model.dart';

class BackgroundUploadService extends GetxService {
  final ApiProvider _apiProvider = Get.find<ApiProvider>();
  final DbHelper _dbHelper = DbHelper();
  
  bool _isProcessing = false;

  @override
  void onInit() {
    super.onInit();
    _startListening();
  }

  void _startListening() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      if (results.isNotEmpty && results.first != ConnectivityResult.none) {
        processPendingUploads();
      }
    });
  }

  Future<void> processPendingUploads() async {
    if (_isProcessing) return;
    _isProcessing = true;

    try {
      // 1. Process PODList_UploadImage (Direct Uploads)
      List<PodData> pendingDirect = await _dbHelper.selectDocketForBackService('0');
      for (var pod in pendingDirect) {
        await _uploadSinglePOD(pod);
      }
    } catch (e) {
      AppLogger.error("Background Upload Error: $e");
    } finally {
      _isProcessing = false;
    }
  }

  Future<void> _uploadSinglePOD(PodData pod) async {
    if (pod.imagePath == null || pod.imagePath!.isEmpty) return;
    
    File file = File(pod.imagePath!);
    if (!await file.exists()) return;

    String fileName = pod.imagePath!.split('/').last;

    String? response = await _apiProvider.uploadPODImage(
      fileName, 
      pod.imagePath!
    );
    
    if (response != null && response.contains("Success")) {
      await _dbHelper.updatePODNoList(pod.dOCKNO!, pod.imagePath!);
      AppLogger.debug("Background Upload Success: ${pod.dOCKNO}");
    }
  }
}
