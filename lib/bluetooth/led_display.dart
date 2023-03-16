import 'dart:math';
import 'bluetooth_handler.dart';
import 'single_target.dart';

class LedDisplay {
  late final List<SingleTarget> targetList;

  LedDisplay(){
    BlueToothHandler bth = BlueToothHandler();
    targetList = bth.targetList;
  }

  writeLEDs(List<List<int>> ledColors) {
    for (int i=0; i<targetList.length; i++){
      targetList[i].writeLED(ledColors[i]);
    }
  }

  List<List<int>> genUniformColorArray( {int val=0}){
    int numColors = 3;
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

  cycleLeds() async {
    for (int t=0; t<targetList.length ; t++) {
      await writeOnePaddle(t, [255,0,0]);
      await Future.delayed(const Duration(seconds:1));
      await writeOnePaddle(t, [0,255,0]);
      await Future.delayed(const Duration(seconds:1));
      await writeOnePaddle(t, [0,0,255]);
      await Future.delayed(const Duration(seconds:1));
      await writeOnePaddle(t, [0,0,0]);
    }
  }

  writeSingleColorPerPaddle(List<int> colors) async {
    int numLeds = 3;
    int numTargets =targetList.length;
    for (int i=0; i<numTargets; i++){
      List<int> tmp = List.filled(numLeds, 0, growable: false); // fill with zeros
      tmp[colors[i]] = 255;
      await targetList[i].writeLED(tmp);
    }
  }

  writeOnePaddle(int paddle, List<int> color) async {
    await targetList[paddle].writeLED(color);
  }

  writeOnePaddleOneColor(int targetIndex, int ledIndex) async {
    List<int> colorArray = [0,0,0];
    colorArray[ledIndex] = 255;
    await targetList[targetIndex].writeLED(colorArray);
  }

  int toggledIntensity = 128;
  toggleIntensity() async {
    await writeLEDs(genUniformColorArray(val: toggledIntensity));
    toggledIntensity += 84; //Adds about 25% brighter each time
    if(toggledIntensity>255){
      toggledIntensity = 0;
    }
  }

  allOff() async {
    List<List<int>> offArray = genUniformColorArray(val:0);
    await writeLEDs(offArray);
  }

  flashOnePaddle({required int targetIndex}) async {
    await targetList[targetIndex].writeLED([0,255,0]);
    await Future.delayed(const Duration(milliseconds: 50));
    await targetList[targetIndex].writeLED([0,0,0]);
  }

  flashAllTargetsOneLed(int ledNumber, {int numBlinks = 3}) async {
    Duration delay = const Duration(milliseconds: 200);

    List<List<int>> offArray = genUniformColorArray(val: 0);
    int numTargets = offArray.length;
    List<int> color = [0,0,0];
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
