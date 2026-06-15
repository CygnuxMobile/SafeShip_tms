import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/utils/logger.dart';
import '../../../data/models/docket_barcode_model.dart';

class DocketPrintController extends GetxController {
  final FlutterBlueClassic _flutterBlueClassic = FlutterBlueClassic();

  var devices = <BluetoothDevice>[].obs;
  var connectedConnection = Rxn<BluetoothConnection>();
  var connectedDevice = Rxn<BluetoothDevice>();
  var isConnected = false.obs;
  var isScanning = false.obs;
  var isConnecting = false.obs;
  var connectingAddress = "".obs;
  var isBluetoothEnabled = true.obs;

  // Docket API fields
  final docketController = TextEditingController();
  final boxSearchController = TextEditingController();
  var isApiLoading = false.obs;
  var docketData = Rxn<DocketBarcodeData>();
  var boxNumbers = <String>[].obs;
  var filteredBoxNumbers = <String>[].obs;
  var isPrinting = false.obs;
  var printProgress = 0.obs;
  var totalToPrint = 0.obs;
  bool _cancelPrinting = false;

  StreamSubscription? _scanSubscription;
  StreamSubscription? _adapterStateSubscription;

  @override
  void onInit() {
    super.onInit();
    _initBluetooth();
    _listenToAdapterState();
  }

  void _initBluetooth() async {
    isBluetoothEnabled.value = await _flutterBlueClassic.isEnabled;
  }

  void _listenToAdapterState() {
    _adapterStateSubscription = _flutterBlueClassic.adapterState.listen((
      state,
    ) {
      isBluetoothEnabled.value = state == BluetoothAdapterState.on;
      if (isBluetoothEnabled.value) {
        getDevices();
      }
    });
  }

  Future<bool> requestPermissions() async {
    if (GetPlatform.isAndroid) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (statuses[Permission.bluetoothScan]?.isGranted == true &&
          statuses[Permission.bluetoothConnect]?.isGranted == true) {
        return true;
      }
      return false;
    }
    return true;
  }

  Future<void> getDevices() async {
    bool hasPermission = await requestPermissions();
    if (!hasPermission) {
      Fluttertoast.showToast(
        msg: "Bluetooth permissions are required to scan for printers",
      );
      return;
    }

    bool isEnabled = await _flutterBlueClassic.isEnabled;
    isBluetoothEnabled.value = isEnabled;

    if (!isEnabled) {
      // Automatically try to turn it on instead of showing a snackbar
      await _flutterBlueClassic.turnOn();
      return;
    }

    isScanning.value = true;
    devices.clear();
    try {
      List<BluetoothDevice> bondedDevices =
          await _flutterBlueClassic.bondedDevices ?? [];
      devices.addAll(bondedDevices);

      _scanSubscription?.cancel();
      _scanSubscription = _flutterBlueClassic.scanResults.listen((device) {
        if (!devices.any((element) => element.address == device.address)) {
          devices.add(device);
        }
      });

      _flutterBlueClassic.startScan();

      Future.delayed(const Duration(seconds: 10), () => stopScan());
    } catch (e) {
      logger.e("Error getting devices: $e");
    } finally {
      isScanning.value = false;
    }
  }

  void stopScan() {
    _flutterBlueClassic.stopScan();
    isScanning.value = false;
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      isConnecting.value = true;
      connectingAddress.value = device.address;
      stopScan();

      BluetoothConnection? connection = await _flutterBlueClassic
          .connect(device.address)
          .timeout(const Duration(seconds: 15));

      if (connection != null && connection.isConnected) {
        connectedConnection.value = connection;
        connectedDevice.value = device;
        isConnected.value = true;

        // Listen for disconnection
        connection.input?.listen(
          null,
          onDone: () {
            isConnected.value = false;
            connectedConnection.value = null;
            connectedDevice.value = null;
            logger.i("Disconnected from device");
          },
        );

        Get.back(); // Close bottom sheet
        Fluttertoast.showToast(
          msg: "Connected to ${device.name ?? device.address}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Could not connect to ${device.name ?? "device"}",
        );
      }
    } catch (e) {
      isConnected.value = false;
      connectedDevice.value = null;
      logger.e("Connection Error: $e");
      Fluttertoast.showToast(
        msg: "Connection failed. Make sure the printer is ON.",
      );
    } finally {
      isConnecting.value = false;
      connectingAddress.value = "";
    }
  }

  Future<void> disconnect() async {
    await connectedConnection.value?.close();
    isConnected.value = false;
    connectedConnection.value = null;
    connectedDevice.value = null;
    Fluttertoast.showToast(msg: "Disconnected");
  }

  void _generateBoxNumbers() {
    boxNumbers.clear();
    if (docketData.value == null) return;

    String? dockNo = docketData.value!.dOCKNO;
    if (dockNo == null) return;

    int pkgs = 0;
    if (docketData.value!.pKGSNO != null) {
      pkgs = double.tryParse(docketData.value!.pKGSNO.toString())?.toInt() ?? 0;
    }

    for (int i = 1; i <= pkgs; i++) {
      String paddedIndex = i.toString().padLeft(3, '0');
      boxNumbers.add("P$dockNo$paddedIndex");
    }
    filteredBoxNumbers.assignAll(boxNumbers);
  }

  void filterBoxes(String query) {
    if (query.isEmpty) {
      filteredBoxNumbers.assignAll(boxNumbers);
    } else {
      filteredBoxNumbers.assignAll(
        boxNumbers
            .where((box) => box.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  Future<bool> printBox(String boxNumber, {bool showToast = true}) async {
    if (!isConnected.value ||
        connectedConnection.value == null ||
        !connectedConnection.value!.isConnected) {
      isConnected.value = false;
      if (showToast) {
        Fluttertoast.showToast(msg: "Printer disconnected. Please reconnect.");
      }
      return false;
    }

    try {
      final data = docketData.value;
      if (data == null) return false;

      int totalPkgs = double.tryParse(data.pKGSNO.toString())?.toInt() ?? 0;
      String indexStr = boxNumber.substring(boxNumber.length - 3);
      int currentIndex = int.tryParse(indexStr) ?? 0;

      String prn =
          "SIZE 75 mm, 50 mm\n"
          "GAP 3 mm, 0 mm\n"
          "DIRECTION 1,0\n"
          "REFERENCE 0,0\n"
          "OFFSET 0 mm\n"
          "SET PEEL OFF\n"
          "SET CUTTER OFF\n"
          "SET TEAR ON\n"
          "CLS\n"
          "CODEPAGE 1252\n";
      prn +=
          "TEXT 40,30,\"ROMAN.TTF\",0,10,10,\"SafeShip Logistic Solutions Private Limited\"\n";

      prn += "BARCODE 40,75,\"128\",80,0,0,3,3,\"$boxNumber\"\n";

      prn +=
          "TEXT 160,165,\"ROMAN.TTF\",0,8,8,\"$boxNumber | ${data.dOCKDT}\"\n";

      prn += "TEXT 40,205,\"ROMAN.TTF\",0,10,10,\"DKT\"\n";
      prn += "TEXT 125,205,\"ROMAN.TTF\",0,14,14,\"|${data.dOCKNO}\"\n";

      prn +=
      "TEXT 450,205,\"ROMAN.TTF\",0,10,10,\"$currentIndex / $totalPkgs\"\n";

      prn += "TEXT 40,255,\"ROMAN.TTF\",0,10,10,\"ORG\"\n";
      prn += "TEXT 130,255,\"ROMAN.TTF\",0,10,10,\"| ${data.oRGNCD}\"\n";

      prn += "TEXT 40,300,\"ROMAN.TTF\",0,10,10,\"DEST\"\n";
      prn += "TEXT 130,300,\"ROMAN.TTF\",0,10,10,\"| ${data.toLoc}\"\n";

      prn += "TEXT 40,345,\"ROMAN.TTF\",0,10,10,\"CSGENM\"\n";
      prn +=
          "TEXT 130,345,\"ROMAN.TTF\",0,10,10,\"| ${data.cSGENM}\"\n";


      prn += "PRINT 1,1\n";

      connectedConnection.value!.writeString(prn);

      AppLogger.info("Sent to printer: $boxNumber");
      if (showToast) Fluttertoast.showToast(msg: "Printing $boxNumber...");
      return true;
    } catch (e) {
      AppLogger.error("Print Error: $e");
      if (showToast) Fluttertoast.showToast(msg: "Failed to print $boxNumber");
      return false;
    }
  }

  Future<void> printAllBoxes() async {
    if (!isConnected.value || connectedConnection.value == null) {
      Fluttertoast.showToast(msg: "Please connect to a printer first");
      return;
    }

    if (isPrinting.value) return;

    try {
      isPrinting.value = true;
      _cancelPrinting = false;
      printProgress.value = 0;
      totalToPrint.value = boxNumbers.length;

      for (var box in boxNumbers) {
        if (_cancelPrinting) break;

        bool success = await printBox(box, showToast: false);
        if (!success) {
          Fluttertoast.showToast(
            msg: "Printing stopped: Connection lost or printer error",
          );
          break;
        }

        printProgress.value++;

        await Future.delayed(const Duration(milliseconds: 1000));
      }

      if (_cancelPrinting) {
        Fluttertoast.showToast(
          msg:
              "Printing cancelled at ${printProgress.value}/${totalToPrint.value}",
        );
      } else {
        Fluttertoast.showToast(
          msg: "Batch complete: ${totalToPrint.value} labels sent",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      AppLogger.error("Batch Print Error: $e");
      Fluttertoast.showToast(msg: "Error during batch printing");
    } finally {
      isPrinting.value = false;
      printProgress.value = 0;
    }
  }

  void cancelPrinting() {
    _cancelPrinting = true;
  }

  Future<void> fetchDocketData() async {
    if (docketController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter docket number");
      return;
    }

    isApiLoading.value = true;
    final url =
        "http://103.153.58.129/SafeShipLiveDataService/AndroidServices.svc/GetBarCodePrintByGCN?dockno=${docketController.text}";
    AppLogger.info("Fetching Docket Data from: $url");

    try {
      final response = await http.get(Uri.parse(url));

      AppLogger.info("API Response Status: ${response.statusCode}");
      AppLogger.debug("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final model = DocketBarcodeModel.fromJson(data);

        if (model.getBarCodePrintByGCNResult?.data != null &&
            model.getBarCodePrintByGCNResult!.data!.isNotEmpty) {
          docketData.value = model.getBarCodePrintByGCNResult!.data![0];
          _generateBoxNumbers();
          FocusManager.instance.primaryFocus?.unfocus();
          AppLogger.info(
            "Docket data loaded successfully for: ${docketData.value?.dOCKNO}",
          );
        } else {
          docketData.value = null;
          AppLogger.error(
            "No data found in response for docket: ${docketController.text}",
          );
          Fluttertoast.showToast(msg: "No data found for this docket");
        }
      } else {
        AppLogger.error("Failed to fetch data. Status: ${response.statusCode}");
        Fluttertoast.showToast(
          msg: "Failed to fetch data: ${response.statusCode}",
        );
      }
    } catch (e) {
      AppLogger.error("API Error: $e");
      Fluttertoast.showToast(msg: "Error fetching docket data");
    } finally {
      isApiLoading.value = false;
    }
  }

  void resetSearch() {
    docketController.clear();
    boxSearchController.clear();
    docketData.value = null;
    boxNumbers.clear();
    filteredBoxNumbers.clear();
  }

  @override
  void onClose() {
    docketController.dispose();
    boxSearchController.dispose();
    _scanSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _flutterBlueClassic.stopScan();
    connectedConnection.value?.close();
    super.onClose();
  }
}
