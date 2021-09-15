

import 'package:flutter/widgets.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:getwidget/components/toast/gf_toast.dart';

import 'UUIDs.dart';

FlutterBlue flutterBlue = FlutterBlue.instance;
late BluetoothDevice bluetoothDevice;
late BluetoothService gameModeService;

class BlueToothUpdater extends ChangeNotifier {

  String currentState = 'Not connected';
  String stateMessage = '';

  changeMessage(){
    stateMessage = 'panic!!';
    notifyListeners();
  }

  showMessage(BuildContext context){
    GFToast.showToast('hi', context, toastDuration: 5,);
    //stateMessage = '';
  }


  Future<bool> _readBluetoothScan(Stream<List<ScanResult>> results) async {
    await for (List<ScanResult> event in results) {
      for (ScanResult r in event) {
        if (r.device.name.contains(UUIDs.device)) {
          //print('${r.device.name} found! rssi: ${r.rssi}');
          debugPrint('_____Found Matching BT device');
          bluetoothDevice = r.device;
          flutterBlue.stopScan();
          return true;
        }
      }
    }
    return false; //Never did find a matching bluetooth device
  }

  Future<void> connectToService() async {
    if (!await flutterBlue.isAvailable) {

    }
    if (await flutterBlue.isOn) {
      debugPrint('______________Bluetooth ON'); //Bluetooth needs turned on
    }
    for (BluetoothDevice connectedDevice in await flutterBlue
        .connectedDevices) {
      debugPrint('_____already connected to ' +
          connectedDevice.name); //Check to see if I have already connected
    }

    flutterBlue.startScan(
        timeout: const Duration(seconds: 4)); // Start scanning
    if (await _readBluetoothScan(flutterBlue.scanResults)) {
      //Found a matching bluetooth Device and assigned it to bluetoothDevice
    }

    await bluetoothDevice.connect();
    List<BluetoothService> services = await bluetoothDevice.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString().contains(
          '1901bce2-151b-11ec-82a8-0242ac130003')) {
        gameModeService = service;
        break;
      }
    }
  }

  Future<void> printValue() async {
    for (BluetoothCharacteristic characteristic in gameModeService.characteristics){
      List<int> val = await characteristic.read();
      debugPrint('______________val' + val.toString());
    }
  }
}
