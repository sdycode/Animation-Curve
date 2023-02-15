import 'dart:math';

import 'package:flutter/material.dart';

class CustomBezierCurve extends Curve {
  @override
  double transform(double t) {
    double maxX = max(0, 368.1599853515625);
    double x = (0 / maxX) * pow(1 - t, 3) +
        (92.03999633789063 / maxX) * pow(1 - t, 2) * 3 * t +
        (276.1199890136719 / maxX) * pow(1 - t, 1) * 3 * t * t +
        (368.1599853515625 / maxX) * pow(t, 3);

    return x;
  }
}

class Example extends StatefulWidget {
  Example({Key? key}) : super(key: key);

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    controller.repeat();
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animation = CurvedAnimation(
      parent: controller,
      curve: CustomBezierCurve(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Transform.rotate(
          angle: animation.value * pi,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
                color: Colors.orange, borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
    );
  }
}
