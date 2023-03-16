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
  double refractoryPeriod = 100;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(children: [
            Text("Hits:   $numHits",textScaleFactor: 1.5,textAlign: TextAlign.center,),
            Text("Acceleration:   ${lastAcceleration.toStringAsFixed(1)} gs", textScaleFactor: 1.5, textAlign: TextAlign.center,),
            functionButton(func: clearHits, label: "clear hits"),
          ],),

          Column(children:[
            Text("Threshold: ${threshold.toStringAsFixed(1)} gs", textScaleFactor: 1.5,textAlign: TextAlign.center,),
            getThresholdSlider(),
          ]),

          Column(children:[
            Text("Refractory period: ${refractoryPeriod.toStringAsFixed(0)} ms", textScaleFactor: 1.5,textAlign: TextAlign.center,),
            getRefractorySlider(),
          ]),

          functionButton(func:LedDisplay().cycleLeds, label:"Flash Lights"),
        ],
      ),
    );
  }

  bool shouldWatchForHits = true;
  @override
  void initState() {
    readInitialValues();
    shouldWatchForHits = true;
    watchForHits();
    super.initState();
  }

  @override
  void dispose(){
    shouldWatchForHits = false;
    super.dispose();
  }
  Future<void> readInitialValues()async {
    if(BlueToothHandler().targetList.isNotEmpty){
      threshold = await BlueToothHandler().targetList[0].readHitThreshold();
      int r = await BlueToothHandler().targetList[0].readHitRefractoryPeriod();
      refractoryPeriod = r.toDouble();
      setState(() {threshold;});
    }
  }

  clearHits() {
    numHits = 0;
    setState(() {numHits;});
  }

  watchForHits() async {
    while(shouldWatchForHits) {
      debugPrint("watching");
      HitResults res = await BlueToothHandler().getHit();
      if (mounted) { //check if mounted in case user has moved from page since listening
        numHits++;
        LedDisplay().flashOnePaddle(targetIndex: res.targetNum);
        lastAcceleration = await BlueToothHandler().targetList[res.targetNum].readHitAcceleration();
        await player.setAsset('assets/audio/clash.mp3');
        player.play();
        setState(() {numHits;});
      }
    }
  }

  ElevatedButton functionButton({required Function func,required String label}){
    return ElevatedButton(
      onPressed: () {func();},
      child: Text(label, textScaleFactor: 1.5,),
    );
  }

  Widget getThresholdSlider() {
    return Slider(
        min: 0.5,
        max: 16,
        value: threshold,
        label: null,//threshold.toStringAsFixed(1),
        divisions: 155,
        onChanged: (double value) {
          setState(() {threshold = value;});
          },
        onChangeEnd: (double value) {
          BlueToothHandler().setHitThreshold(threshold);
        });
  }

  Widget getRefractorySlider(){
    return Slider(
        min: 0,
        max: 1000,
        value: refractoryPeriod,
        label: null,//refractoryPeriod.toStringAsFixed(0),
        divisions: 1000,
        onChanged: (double value) {
          setState(() {refractoryPeriod = value;});
          },
        onChangeEnd: (double value) {
          BlueToothHandler().setHitRefractoryPeriod(refractoryPeriod);
        });
  }
}
