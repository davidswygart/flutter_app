import 'dart:async';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/BlueTooth/BlueToothHandler.dart';

import 'package:flutter_blue/flutter_blue.dart';

import 'dataStructures/RoundResults.dart';

class Games {
  final StreamController<List> _resultsBroadcaster = StreamController();
  getStream() {
    return _resultsBroadcaster.stream;
  }

  void dispose(filename) {
    _resultsBroadcaster.close();
  }

  Random _rng = Random();
  //late BluetoothCharacteristic? _hitBLE;
  late BluetoothCharacteristic? _ledBLE;
  late BlueToothHandler bth;

  Games() {
    //Todo: import settings and determine game mode from settings.  Make global settings for common things (rounds, delay, ect.)
    bth = BlueToothHandler();
    _ledBLE = bth.ledCharacteristic;
    //_hitBLE = bth.hitCharacteristic;
    _playGoNoGo();
    //_playBeatBrain();
  }

 /* Future<int> readBLE({timeout = 6000000}) async {
    //returns -11 if Bluetooth not set, returns -1 if timeout reached
    if (_hitBLE == null) {
      return -11;
    }
    Future<List<int>> hitFuture = _hitBLE!.value.firstWhere((val) => val.isNotEmpty);
    List<int> hitBytes =
        await hitFuture.timeout(Duration(milliseconds: timeout), onTimeout: () {
      return [-1];
    });
    debugPrint(hitBytes.toString());
    if (hitBytes.first < 0) {
      return -1;
    } else {
      return ByteData.sublistView(Uint8List.fromList(hitBytes))
          .getUint32(0, Endian.little);
    }
  }
*/
  bool _playingGame = false;
  bool _stopCurrentGame = false;

  Future<void> quitGame() async{
    if(_playingGame){
      debugPrint('Game is playing.  I am going to try to make it stop');
      _stopCurrentGame = true;
      while (_playingGame){
        debugPrint('Game still seems to be playing.  I will continue to wait');
        await Future.delayed(Duration(seconds: 1));
      }
      _stopCurrentGame = false;
    }
  }
  Future<void> restartGame() async {
    await quitGame();
    _playGoNoGo();
  }

  Future<void> _playBeatBrain() async {
    const List<int> goColor = [0, 255, 0];
    const List<int> prepColor = [255, 0, 0];
    const int prepColorDuration = 1000;
    const int minDelay = 1000;
    const int maxDelay = 10000;
    const int blinkPeriod = 100;
    for (int rnd = 0; rnd < 10; rnd++){
      await _ledBLE!.write(prepColor);
      await Future.delayed(Duration(milliseconds: prepColorDuration));
      await _blankLEDs();
      int randDelay = _rng.nextInt(maxDelay);
      int waitDelay = randDelay + minDelay;
      await Future.delayed(Duration(milliseconds: waitDelay));
      await _ledBLE!.write(goColor);
      await Future.delayed(Duration(milliseconds: blinkPeriod));
      await _blankLEDs();
      await Future.delayed(Duration(milliseconds: minDelay));

      await _ledBLE!.write(prepColor);
      await Future.delayed(Duration(milliseconds: prepColorDuration));
      await _blankLEDs();
      DateTime waitStart = DateTime.now();
      int r = await bth.listenForHit(timeout: (maxDelay+minDelay)*1000);
      int reactionTime = DateTime.now().compareTo(waitStart);
      debugPrint('made it here');
      int error = reactionTime - waitDelay;
/*      if (error.abs() > 500){
        await _blink(goColor);
      }
      else {
        await _blink(prepColor);
      }*/
      debugPrint('You were off by '+ error.toString());
    }
  }

  Future<void> _playGoNoGo() async {
    //Todo: load these variable from settings /////
    const List<int> goColor = [0, 255, 0];
    const List<int> noGoColor = [255, 0, 0];
    const int rndDelayMax = 2000; // ms
    const int timeout = 500; //ms
    //////////////////////////////////////////

    _playingGame = true;
    _resultsBroadcaster.add(['preGame']);
    List<num> reactionTimes = [];
    List<num> roundScores = [];
    double scoreMultiplier = 1;
    List<bool> wasCorrect = [];

    for (int rnd = 0; rnd < 10; rnd++) {
      if(_stopCurrentGame){
        debugPrint('Looks like I am suppossed to stop playing the game.  Oh well...');
        _playingGame = false;
        return;
      }
      await Future.delayed(Duration(
          milliseconds: _rng.nextInt(rndDelayMax) + 100)); //Round Delay
      // create the epoch
      bool go = _rng.nextBool();

      List<int> rgb;
      if (go) {
        rgb = goColor;
      } else {
        rgb = noGoColor;
      }
      await _ledBLE!.write(rgb);
      _resultsBroadcaster.add(['targetColor', rgb]);


      int rTime = await bth.listenForHit(timeout: timeout);
      reactionTimes.add(rTime);
      await _blankLEDs();

      bool isCorrect = true;
      String message;

      if (reactionTimes.last == -1) {
        //timed out
        if (go) {
          //wrong no-go
          isCorrect = false;
          message = 'Too slow';
          roundScores.add(timeout * -1);
          scoreMultiplier = 1;
        } else {
          message = 'Correct No-Go';
          roundScores.add((timeout - 250) *
              scoreMultiplier); //based on average human reaction time
        }
      } else {
        //did not time out - did shoot target
        if (go) {
          //correct go
          message = 'Good Hit!';
          roundScores.add((timeout - reactionTimes.last) * scoreMultiplier);
        } else {
          isCorrect = false;
          message = 'Incorrect Go';
          roundScores.add(reactionTimes.last * -1);
          scoreMultiplier = 1;
        }
      }

      if (isCorrect) {
        await _blink(goColor);
      } else {
        await _blink(noGoColor);
      }

      num totalScore =
          roundScores.fold(0, (previous, current) => previous + current);
      _resultsBroadcaster.add(
        ['roundResults',
          RoundResults(
          roundNum: (rnd + 1),
          isCorrect: isCorrect,
          correctnessFeedback: message,
          reactionTime: reactionTimes.last.round().toString(),
          scoreMultiplier: scoreMultiplier.toStringAsFixed(1),
          roundScore: roundScores.last.round().toString(),
          cumScore: totalScore.round().toString(),
        )],
      );

      if (isCorrect) {
        scoreMultiplier *= 1.1;
      } else {
        scoreMultiplier = 1;
      }

      wasCorrect.add(isCorrect);
    }

    num finalScore = roundScores.fold(0, (previous, current) => previous + current);
    _resultsBroadcaster.add(['endGame',wasCorrect, reactionTimes, finalScore]);
    _playingGame = false;
  }

  Future<void> _blink(List<int> color) async {
    for (int rnd = 0; rnd < 3; rnd++) {
      await _ledBLE!.write(color);
      await Future.delayed(Duration(milliseconds: 10));
      await _blankLEDs();
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Future<void> _blankLEDs() async {
    await _ledBLE!.write([0, 0, 0]);
  }
}

/*for (int rnd = 0; rnd < 10; rnd++){
      await new Future.delayed(const Duration(seconds : 1));
      // create the epoch
      List<List<int>> pColors = [[200, 200, 200], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
      List<int> playerNum = [0,1,2,3];
      playerNum.shuffle();


      List<int> epoch = [];
      for (int i = 0; i<4; i++){
        epoch = epoch + pColors[playerNum[i]];
      }

      //send the epoch;
      await padColChar!.write(epoch);
      targetState.add(PaddleDisplay(lstCols: [Colors.red.shade500, Colors.green.shade500, Colors.blue.shade500]));

      //Wait for a response
      await hitPadChar!.setNotifyValue(true);

      List<int> h = await hitPadChar!.value.firstWhere((val) => val.isNotEmpty);

      targetState.add(Text("Get Ready", textScaleFactor: 3,));
      int hitTarget = h[0];
      playerNum[hitTarget] == 0

      List<int> reactionTimeLst = Uint32List.fromList(h.sublist(1));
      int reactionTime = reactionTimeLst[0];



      List displayInfo = ["hitInfo", "player 1", ];
      targetState.add("hit target! Reaction Time = " + reactionTime.toString());

      await new Future.delayed(const Duration(seconds : 1));
    }*/
