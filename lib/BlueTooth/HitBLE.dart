



/*
Future<int> listenForHit({timeout = 6000000}) async {
  //returns -11 if Bluetooth not set, returns -1 if timeout reached
  if (_hitCharacteristic == null) {
    return -11;
  }
  else {
    Future<List<int>> hitFuture = _hitCharacteristic!.value.firstWhere((
        val) => val.isNotEmpty);

    List<int> hitBytes =
    await hitFuture.timeout(Duration(milliseconds: timeout), onTimeout: () {
      return [-1];
    });
    if (hitBytes.first < 0) {
      return -1;
    } else {
      return ByteData.sublistView(Uint8List.fromList(hitBytes))
          .getUint32(0, Endian.little);
    }
  }
}*/
