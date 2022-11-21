// class Battery {
//
//   final Guid _batteryUUID = Guid('00000003-151b-11ec-82a8-0242ac130003');
//
//   int _batteryLevel = 0;
//   int get batteryLevel => _batteryLevel;
//   Future<int> _readBattery() async {
//     List<int> batteryBytes = await _batteryCharacteristic!.read();
//     _batteryLevel = ByteData.sublistView(Uint8List.fromList(batteryBytes))
//         .getUint32(0, Endian.little);
//     return _batteryLevel;
//   }
//
//
//
// }