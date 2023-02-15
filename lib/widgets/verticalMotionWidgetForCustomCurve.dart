import 'package:curves_animation/main.dart';
import 'package:curves_animation/widgets/top_bar.dart';
import 'package:flutter/material.dart';

class VertMotionWidgetCurve extends StatefulWidget {
  final Curve curve;

  final double width;
  final double height;

  const VertMotionWidgetCurve({
    super.key,
    required this.curve,
    this.width = 40,
    this.height = 160,
  });

  @override
  State<VertMotionWidgetCurve> createState() => _VertMotionWidgetCurveState();
}

class _VertMotionWidgetCurveState extends State<VertMotionWidgetCurve>
    with TickerProviderStateMixin {
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
    // controller = AnimationController(
    //     vsync: this, duration:  Duration(milliseconds: timeInMillisec));
    // controller.duration = Duration(milliseconds: timeInMillisec);
    controller.duration = Duration(milliseconds: timeInMillisec);
    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
    controller.reset();
    controller.repeat();
    debugLog(
        "VertMotionWidgetCurve animation  in build ${controller.duration} ");
    double tH = 30;
    double boxH = widget.height;
    double hw = widget.width;
    return StatefulBuilder(builder: (BuildContext context, StateSetter _state) {
      state = _state;
      // debugLog(
      //     "VertMotionWidgetCurve in build ${controller.animationBehavior} /${animation.value} / ${animation.toStringDetails()} ");
      return Container(
        margin: const EdgeInsets.all(8),
        width: hw,
        // height: tH + boxH,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(boxH),
          child: Container(
            height: boxH,
            width: hw,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 193, 206, 234),
                borderRadius: BorderRadius.circular(boxH)),
            child: Stack(fit: StackFit.expand, children: [
              Positioned(
                top: animation.value * (boxH - 35),
                left: 0,
                child: Center(
                  child: CircleAvatar(
                    radius: hw * 0.5,
                    // backgroundColor: Colors.primaries[no % Colors.primaries.length],
                  ),
                ),
              )
            ]),
          ),
        ),
      );
    });
  }
}
