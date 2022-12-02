
import 'dart:math';

import '../bluetooth_handler.dart';
import '../single_target.dart';

class LedDisplay {
  late final List<SingleTarget> targetList;


  LedDisplay(){
    BlueToothHandler bth = BlueToothHandler();
    targetList = bth.targetList;
  }

  writeLEDs(List<List<int>> ledColors) {
    for (int i=0; i<targetList.length; i++){
      targetList[i].led.writeLED(ledColors[i]);
    }
  }

  List<List<int>> genUniformColorArray( {int val=0}){
    int numColors = 4;
    List<List<int>> cArray = [];
    for(int i=0; i < targetList.length; i++) {
      cArray.add(List.filled(numColors, val, growable: false));
    }
    return cArray;
  }

  randomColors() async {
    Random rng = Random();
    List<List<int>> colors = genUniformColorArray();

    for (int i=0; i< colors.length ; i++) {
      for (int ii=0; ii < colors[0].length ; ii++) {
        colors[i][ii] = rng.nextInt(256);
      }
    }
    await writeLEDs(colors);
  }

  cycleLeds() async { //ToDo clean this up to write single Paddles instead of writing 0 values to other paddles
    List<List<int>> colors = genUniformColorArray();
    for (int i=0; i< colors.length ; i++) {
      for (int ii=0; ii < colors[0].length ; ii++) {
        colors[i][ii] = 255;
        await writeLEDs(colors);
        await Future.delayed(const Duration(milliseconds: 500));
        colors[i][ii] = 0;
      }
    }
    await writeLEDs(colors);
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

  writeOnePaddle(int paddle, List<int> color) async {
    await targetList[paddle].led.writeLED(color);
  }

  int toggledIntensity = 128;
  toggleIntensity() async {
    await writeLEDs(genUniformColorArray(val: toggledIntensity));
    toggledIntensity += 84; //Adds about 25% brighter each time
    if(toggledIntensity>255){
      toggledIntensity = 0;
    }
  }

  flashAllTargetsOneLed(int ledNumber) async {
    int numBlinks = 3;
    Duration delay = const Duration(milliseconds: 200);

    List<List<int>> offArray = genUniformColorArray(val: 0);
    int numTargets = offArray.length;
    List<int> color = [0,0,0,0];
    color[ledNumber] = 255;
    List<List<int>> onArray = List.filled(numTargets, color, growable: false);

    await Future.delayed(delay);
    for (int i=0; i<numBlinks; i++){
      await writeLEDs(onArray);
      await Future.delayed(delay);
      await writeLEDs(offArray);
      await Future.delayed(delay);
    }
  }
}
