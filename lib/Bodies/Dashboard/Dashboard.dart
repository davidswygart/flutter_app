import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class DashBody extends StatelessWidget {
  const DashBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return CarouselSlider(
      items: [
        Container(
          child: Text('Last Game Results'),
          color: Colors.green,
          constraints: BoxConstraints.tight(Size.infinite),
        ),
        Container(
          child: Text('History of Scores'),
          color: Colors.brown,
          constraints: BoxConstraints.tight(Size.infinite),
        ),
      ],
      options: CarouselOptions(
        enlargeCenterPage: true,
        enlargeStrategy: CenterPageEnlargeStrategy.height,
        height: height,
        viewportFraction: 1,
      ),
    );
  }
}
