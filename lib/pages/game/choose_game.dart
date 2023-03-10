import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/pages/game/settings_speed_switcher.dart';

import '../../game_logic/game_settings.dart';
import 'game_carousel.dart';
import 'settings_go_no_go.dart';

class ChooseGamesPage extends StatefulWidget {
  const ChooseGamesPage({Key? key}) : super(key: key);

  @override
  State<ChooseGamesPage> createState() => _ChooseGamesPage();
}

class _ChooseGamesPage extends State<ChooseGamesPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> carouselPages = [];

    carouselPages.add(const SettingsGoNoGo());
    carouselPages.add(const SettingsSpeedSwitcher());

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

class IntroFormat extends StatelessWidget{
  final String gameName;
  final String numPlayers;
  final String numPaddles;
  final String description;

  const IntroFormat({
    super.key,
    required this.gameName,
    required this.numPlayers,
    required this.numPaddles,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        makeTitle(),
        makeRequirements(),
        makeDescription(),
      ],
    );
  }

  Widget makeTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        gameName,
        textScaleFactor: 2,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget makeRequirements() {
    return Row(
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
    }

  Widget makeDescription(){
    return Padding(
        padding: const EdgeInsets.all(5),
        child: Text(
          description,
          textScaleFactor: 1.1,
        ),
    );
  }

}
