import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPage();
}

class _GamesPage extends State<GamesPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> carouselPages = [];

    carouselPages.add(CarouselPage(
      imageName: 'FamilyGuy.gif',
      gameName: 'Go / No Go',
      numPlayers: '1',
      numPaddles: '1',
      description: "Shoot on green, don't shoot on red.",
      settings: GameSettings(),
    ));

    carouselPages.add(CarouselPage(
      imageName: 'bender.gif',
      gameName: 'Speed Switcher',
      numPlayers: '1-3',
      numPaddles: '1',
      description:
          "Target switches between red, green, and blue. Shoot your color as fast as possible.",
      settings: GameSettings(),
    ));

    carouselPages.add(CarouselPage(
      imageName: 'Mcgrubber.gif',
      gameName: 'Color Discrimination',
      numPlayers: '1',
      numPaddles: '2+',
      description: "Shoot the target that is more green.",
      settings: GameSettings(),
    ));

    carouselPages.add(CarouselPage(
      imageName: 'Office.gif',
      gameName: 'Sequential Memory',
      numPlayers: '1',
      numPaddles: '2+',
      description: "Shoot the target in the same order as the prompt.",
      settings: GameSettings(),
    ));

    carouselPages.add(CarouselPage(
      imageName: 'Smosh.gif',
      gameName: 'Shoot your color',
      numPlayers: '1-3',
      numPaddles: '2+',
      description: "Pick a color and shoot it.",
      settings: GameSettings(),
    ));

    carouselPages.add(CarouselPage(
      imageName: 'McBride.gif',
      gameName: 'Moving Target',
      numPlayers: '1-3',
      numPaddles: '2+',
      description: "Pick a color and shoot it. But they switch between targets",
      settings: GameSettings(),
    ));

    CarouselOptions options = CarouselOptions(
      height: MediaQuery.of(context).size.height,
      viewportFraction: 0.8,
      enableInfiniteScroll: false,
    );

    Widget carousel = CarouselSlider(
      options: options,
      items: carouselPages,
    );

    return carousel;
  }
}

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

class GameSettings{
  int numberOfRounds;
  double maxPreRoundDelaySeconds;

  GameSettings({
    this.numberOfRounds = 5,
    this.maxPreRoundDelaySeconds = 3.0,

  });
}
