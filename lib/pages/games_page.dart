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

    carouselPages.add(const CarouselPage(
      imageName: 'FamilyGuy.gif',
      gameName: 'Go / No Go',
      numPlayers: '1',
      numPaddles: '1',
      description: "Shoot on green, don't shoot on red.",
    ));

    carouselPages.add(const CarouselPage(
      imageName: 'bender.gif',
      gameName: 'Speed Switcher',
      numPlayers: '1-3',
      numPaddles: '1',
      description:
          "Target switches between red, green, and blue. Shoot your color as fast as possible.",
    ));

    carouselPages.add(const CarouselPage(
      imageName: 'Mcgrubber.gif',
      gameName: 'Color Discrimination',
      numPlayers: '1',
      numPaddles: '2+',
      description: "Shoot the target that is more green.",
    ));

    carouselPages.add(const CarouselPage(
      imageName: 'Office.gif',
      gameName: 'Sequential Memory',
      numPlayers: '1',
      numPaddles: '2+',
      description: "Shoot the target in the same order as the prompt.",
    ));

    carouselPages.add(const CarouselPage(
      imageName: 'Smosh.gif',
      gameName: 'Shoot your color',
      numPlayers: '1-3',
      numPaddles: '2+',
      description: "Pick a color and shoot it.",
    ));

    carouselPages.add(const CarouselPage(
      imageName: 'McBride.gif',
      gameName: 'Moving Target',
      numPlayers: '1-3',
      numPaddles: '2+',
      description: "Pick a color and shoot it. But they switch between targets",
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

class CarouselPage extends StatelessWidget {
  final String imageName;
  final String gameName;
  final String numPlayers;
  final String numPaddles;
  final String description;

  const CarouselPage({
    super.key,
    required this.imageName,
    required this.gameName,
    required this.numPlayers,
    required this.numPaddles,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Image gif = Image.asset("assets/images/$imageName");

    Widget title = Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        gameName,
        textScaleFactor: 2,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    Widget requirements = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "players: $numPlayers",
          textScaleFactor: 1.5,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        Text(
          "targets: $numPaddles",
          textScaleFactor: 1.5,
          style: const TextStyle(fontStyle: FontStyle.italic),
        )
      ],
    );

    Widget describe = Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          description,
          textScaleFactor: 1.1,
        ));

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
            playButton,
          ],
        ),
      ),
    );
  }
}

class GameSettings{
  final int numberOfRounds;
  final double maxPreRoundDelaySeconds;

  const GameSettings({
    this.numberOfRounds = 5,
    this.maxPreRoundDelaySeconds = 3.0,

  });
}
