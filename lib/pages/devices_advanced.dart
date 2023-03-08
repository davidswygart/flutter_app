import 'package:flutter/material.dart';
import 'package:flutter_app/bluetooth/led_display.dart';
import 'package:flutter_app/bluetooth/single_target.dart';
import 'package:just_audio/just_audio.dart';

import '../bluetooth/bluetooth_handler.dart';

class DevicesPageAdvanced extends StatefulWidget {
  const DevicesPageAdvanced({Key? key}) : super(key: key);

  @override
  State<DevicesPageAdvanced> createState() => _DevicesPageAdvanced();
}

class _DevicesPageAdvanced extends State<DevicesPageAdvanced> {
  int numHits = 0;
  double lastAcceleration = 0;
  AudioPlayer player = AudioPlayer();
  double threshold = 2;



  @override
  Widget build(BuildContext context) {
    Widget thresholdSlider = Slider(
        min: 0.5,
        max: 16,
        value: threshold,
        label: threshold.toString(),
        divisions: 31,
        onChanged: (double value) {
          setState((){threshold = value;});
        },
        onChangeEnd: (double value){
          BlueToothHandler().setHitThreshold(threshold);
          },
    );


    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Hits: $numHits"),
          Text("Acceleration: ${lastAcceleration.toStringAsFixed(1)}"),
          functionButton(func:clearHits, label: "clear hits"),
          Text("threshold: $threshold gs"),
          thresholdSlider,

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
    HitResults res = await BlueToothHandler().getHit();
    watchForHits();
    numHits++;
    LedDisplay().flashOnePaddle(targetIndex: res.targetNum);
    lastAcceleration = await BlueToothHandler().targetList[res.targetNum].readHitAcceleration();
    await player.setAsset('assets/audio/clash.mp3');
    player.play();
    setState((){numHits;});
  }

  ElevatedButton functionButton({required Function func, required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label),
    );
  }


}
