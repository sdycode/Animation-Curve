
import 'dart:math';

import 'package:curves_animation/main.dart';
import 'package:curves_animation/others/constants.dart';
import 'package:curves_animation/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class ScalingWidget extends StatefulWidget {
  final bw;
  final Curve curve;
  const ScalingWidget( {super.key, required this.curve, required this.bw});

  @override
  State<ScalingWidget> createState() => _ScalingWidgetState();
}

class _ScalingWidgetState extends State<ScalingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  @override
  void dispose() {
    // TODO: implement dispose
    controller.reset();

    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeInMillisec));
    controller.repeat();
    controller.addListener(() {
      state(() {});
    });
    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
  }

  StateSetter state = (fn) {};

  @override
  Widget build(BuildContext context) {
    controller.duration = Duration(milliseconds: timeInMillisec);
    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
    controller.reset();
    controller.repeat();
    double bh = h - topbarHeight - 200 - 100;
    return StatefulBuilder(builder: (BuildContext context, StateSetter _state) {
      state = _state;
      return Transform.scale(
        scale: animation.value,
        child: Container(
          height: bh,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: widget.bw,
                height: min(bh, widget.bw),
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(18)),
              ),
            ],
          ),
        ),
      );
    });
  }
}
