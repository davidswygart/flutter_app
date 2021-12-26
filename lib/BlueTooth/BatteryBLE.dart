/*
Future<int> _readBattery() async {
  List<int> batteryBytes = await _batteryCharacteristic!.read();
  _batteryLevel = ByteData.sublistView(Uint8List.fromList(batteryBytes))
      .getUint32(0, Endian.little);
  return _batteryLevel;
}



int _batteryLevel = 0;
int get batteryLevel => _batteryLevel;*/
