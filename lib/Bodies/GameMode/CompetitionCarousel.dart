import 'package:flutter/material.dart';
import 'package:flutter_app/Pages/Pages.dart';

import 'package:getwidget/components/carousel/gf_carousel.dart';

import 'CompetitionSettings.dart';

class CompetitionCarousel extends StatelessWidget {
  const CompetitionCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    List<String> images = [
      'assets/Office.gif',
      'assets/Mcgrubber.gif',
      'assets/FamilyGuy.gif',
      'assets/Smosh.gif',
    ];

    List<Card> cardList = [];
    for (Preset p in compPresets) {
      cardList.add(Card(
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              GameSettingsPage.routeName,
              arguments: p,
            );
          },
          child: Column(
            children: [
              Flexible(
                child: Container(
                  child: Image.asset(
                    images[p.key],
                  ),
                  padding: EdgeInsets.all(2),
                ),
              ),
              Text(
                p.title,
                textScaleFactor: 1.8,
              ),
              Container(
                child: Text(
                  p.description,
                  textAlign: TextAlign.center,
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(left: 5, right: 5, bottom: 20),
              ),
            ],
          ),
        ),
      ));
    }

    return GFCarousel(
      items: cardList,
      pagination: true,
      //enlargeMainPage: true,
      //viewportFraction: 1,
      height: height / 3,
    );
  }
}
