import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../game/game_settings.dart';
import 'game_carousel.dart';

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


