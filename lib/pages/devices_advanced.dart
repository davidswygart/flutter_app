import 'package:flutter/material.dart';

import '../bluetooth/bluetooth_handler.dart';

class DevicesPageAdvanced extends StatefulWidget {
  const DevicesPageAdvanced({Key? key}) : super(key: key);

  @override
  State<DevicesPageAdvanced> createState() => _DevicesPageAdvanced();
}

class _DevicesPageAdvanced extends State<DevicesPageAdvanced> {
  int numHits = 0;
  int lastAcceleration = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Hits: $numHits"),
          Text("Acceleration: $lastAcceleration"),
          functionButton(func:clearHits, label: "clear hits"),

      ],),
    );
  }

  @override
  void initState() {
    watchForHits();
    super.initState();
  }

  clearHits(){
    numHits=0;
    setState((){numHits;});
  }

  watchForHits() async {
    debugPrint("watching");
    await BlueToothHandler().getHit();
    numHits++;
    setState((){numHits;});
    watchForHits();
  }

  ElevatedButton functionButton({required Function func, required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label),
    );
  }
}
