import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> handAnimation;
  AnimationController handController;

  @override
  void initState() {
    super.initState();

    handController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    handAnimation = Tween(begin: pi * 0.6, end: pi * 0.65).animate(
      CurvedAnimation(
        parent: handController,
        curve: Curves.easeInOut,
      ),
    );

    handAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        handController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        handController.forward();
      }
    });
    handController.forward();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    catAnimation = Tween(begin: -20.0, end: -137.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      catController.reverse();
      handController.reverse();
    } else if (catController.status == AnimationStatus.dismissed) {
      catController.forward();
      handController.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cat Animation'),
      ),
      body: GestureDetector(
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap()
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      builder: (context, child) {
        return Positioned(
          child: child,
          top: catAnimation.value,
          right: 0.0,
          left: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200.0,
      width: 200.0,
      color: Colors.brown[800],
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 8.0,
      top: 4,
      child: AnimatedBuilder(
        animation: handAnimation,
        child: Container(
          height: 10.0,
          width: 135.0,
          color: Colors.brown[800],
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topLeft,
            angle: handAnimation.value,
          );
        },
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 8.0,
      top: 4,
      child: AnimatedBuilder(
        animation: handAnimation,
        child: Container(
          height: 10.0,
          width: 135.0,
          color: Colors.brown[800],
        ),
        builder: (context, child) {
          return Transform.rotate(
            child: child,
            alignment: Alignment.topRight,
            angle: -handAnimation.value,
          );
        },
      ),
    );
  }
}
