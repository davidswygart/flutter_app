
import 'dart:math';

import '../bluetooth_handler.dart';
import '../single_target.dart';

class LedDisplay {
  late final List<SingleTarget> targetList;
  LedDisplay(){
    BlueToothHandler bth = BlueToothHandler();
    targetList = bth.targetList;
  }

  writeLEDs(List<List<int>> ledColors){
    for (int i=0; i<targetList.length; i++){
      targetList[i].led.writeLED(ledColors[i]);
    }
  }

  List<List<int>> genUniformColorArray( {int val=0}){
    int numColors = 4;
    List<int> singleTargetArray = List.filled(numColors, val, growable: false); // fill with zeros
    List<List<int>> fullArray = List.filled(targetList.length, singleTargetArray, growable: false);
    return fullArray;
  }

  randomColors() async {
    Random rng = Random();
    List<List<int>> colors = genUniformColorArray();

    for (int i=0; i< colors.length ; i++) {
      for (int ii=0; ii < colors[0].length ; ii++) {
        colors[i][ii] = rng.nextInt(256);
      }
    }
    writeLEDs(colors);
  }

  Future<void> showPaddleNumber() async {
    List<List<int>> offArray = genUniformColorArray(val:0);
    await writeLEDs(offArray);
    await Future.delayed(const Duration(seconds: 1));
    int numColors = 4;

    for (int i=0; i< offArray.length ; i++) {
      offArray[i] = List.filled(numColors, 255, growable: false); // turn on a single target
      await writeLEDs(offArray);
      offArray[i] = List.filled(numColors, 0, growable: false);
      await Future.delayed(const Duration(seconds: 1));
      await writeLEDs(offArray);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  writeSingleColorPerPaddle(List<int> colors) async {
    int numLeds = 4;
    int numTargets =targetList.length;
    for (int i=0; i<numTargets; i++){
      List<int> tmp = List.filled(numLeds, 0, growable: false); // fill with zeros
      tmp[colors[i]] = 255;
      await targetList[i].led.writeLED(tmp);
    }


  }
}
