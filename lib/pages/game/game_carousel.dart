
import 'package:flutter/material.dart';

import '../../game/game_settings.dart';

class CarouselPage extends StatefulWidget{
  final String imageName;
  final String gameName;
  final String numPlayers;
  final String numPaddles;
  final String description;
  final GameSettings settings;

  const CarouselPage({
    super.key,
    required this.imageName,
    required this.gameName,
    required this.numPlayers,
    required this.numPaddles,
    required this.description,
    required this.settings,
  });

  @override
  State<CarouselPage> createState() => _CarouselPage();
}

class _CarouselPage extends State<CarouselPage> {


  @override
  Widget build(BuildContext context) {
    Image gif = Image.asset("assets/images/${widget.imageName}");

    Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        widget.gameName,
        textScaleFactor: 2,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    Widget requirements = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "players: ${widget.numPlayers}",
          textScaleFactor: 1.5,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          "targets: ${widget.numPaddles}",
          textScaleFactor: 1.5,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ],
    );

    Widget describe = Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          widget.description,
          textScaleFactor: 1.1,
        ));

    Widget roundTitle = Text(
      "${widget.settings.numberOfRounds} rounds",
      textScaleFactor: 1.2,
    );

    Widget roundSlider = Slider(
        min: 1,
        max: 20,
        value: widget.settings.numberOfRounds.toDouble(),
        label: widget.settings.numberOfRounds.toString(),
        divisions: 19,
        onChanged: (double value) {
          setState((){widget.settings.numberOfRounds = value.toInt();});
        }
    );

    Widget roundDelayTitle = Text(
      "${widget.settings.maxPreRoundDelaySeconds} s max round delay",
      textScaleFactor: 1.2,
    );

    Widget roundDelaySlider = Slider(
        min: 0,
        max: 5,
        value: widget.settings.maxPreRoundDelaySeconds,
        label: widget.settings.maxPreRoundDelaySeconds.toString(),
        divisions: 25,
        onChanged: (double value) {
          String roundedString = value.toStringAsFixed(2);
          double newVal = double.parse(roundedString);
          setState((){widget.settings.maxPreRoundDelaySeconds = newVal;});
        }
    );

    Widget playButton = ElevatedButton(
      onPressed: () {
        //navigate to page
      },
      child: const Text(
        'Play',
        textScaleFactor: 1.5,
      ),
    );

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            gif,
            title,
            requirements,
            describe,
            const Divider(),
            roundTitle,
            roundSlider,
            const Divider(),
            roundDelayTitle,
            roundDelaySlider,
            const Divider(),
            playButton,
          ],
        ),
      ),
    );
  }
}