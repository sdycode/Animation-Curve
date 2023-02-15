import 'package:curves_animation/BezeirCurvePage.dart';
import 'package:curves_animation/others/debugLog.dart';
import 'package:curves_animation/providers/mainscreenProvider.dart';
import 'package:curves_animation/widgets/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HorzMotionWidgetForInBuitCurve extends StatefulWidget {
  final Curve curve;
  final String name;
  final showCurveName;
  final double width;
  final double height;
  final int i;
  final showBG;

  HorzMotionWidgetForInBuitCurve(
      {super.key,
      required this.curve,
      required this.name,
      this.showCurveName = true,
      this.width = 160,
      this.height = 40,
      required this.i,
      this.showBG = true});

  @override
  State<HorzMotionWidgetForInBuitCurve> createState() =>
      _HorzMotionWidgetForInBuitCurveState();
}

class _HorzMotionWidgetForInBuitCurveState
    extends State<HorzMotionWidgetForInBuitCurve>
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
    if (!widget.showBG) {
      debugLog(
          "curve name init is ${widget.i} ${widget.curve} :  ${selecedCurveType} :  ${widget.showBG}");
    }

    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeInMillisec));
    controller.repeat();
    controller.addListener(() {
      // if (mounted) {
      //   setState(() {});
      // }
      state(
        () {},
      );
    });

    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
    // animation.addListener(() {
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
  }

  StateSetter state = (fn) {};
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    // debugLog("horzbuild calle ${selecedCurveType} d ${widget.curve} ");

    // controller = AnimationController(
    //     vsync: this, duration:  Duration(milliseconds: timeInMillisec));
    
   controller.duration = Duration(milliseconds: timeInMillisec);
    animation = CurvedAnimation(
      parent: controller,
      curve: widget.curve,
      reverseCurve: widget.curve,
    );
    controller.reset();
    controller.repeat();
    double tH = 30;
    double boxH = widget.height;
    double hw = widget.width;
    return StatefulBuilder(builder: (BuildContext context, StateSetter _state) {
      state = _state;
      return Container(
        constraints: BoxConstraints(minWidth: boxH * 1.4),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(8),
        width: hw + 16,
        // height: tH + boxH,
        decoration: BoxDecoration(
            border: widget.showBG
                ? (selecedCurveType == SelecedCurveType.inbuilt &&
                        selecedInbuiltCurveIndex == widget.i
                    ? Border.all()
                    : null)
                : null,
            color: widget.showBG
                ? selecedCurveType == SelecedCurveType.inbuilt &&
                        selecedInbuiltCurveIndex == widget.i
                    ? Colors.grey.shade400
                    : Colors.white
                : Colors.transparent,
            // : Colors.white,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(boxH),
              child: Container(
                height: boxH,
                width: hw,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 193, 206, 234),
                    borderRadius: BorderRadius.circular(boxH)),
                child: Stack(fit: StackFit.expand, children: [
                  Positioned(
                    top: 0,
                    left: animation.value * (hw - 35),
                    child: Center(
                      child: CircleAvatar(
                        radius: boxH * 0.5,
                        // backgroundColor: Colors.primaries[no % Colors.primaries.length],
                      ),
                    ),
                  )
                ]),
              ),
            ),
            if (widget.showCurveName)
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(tH)),
                  height: tH,
                  width: hw,
                  padding: EdgeInsets.symmetric(horizontal: tH),
                  child: Center(
                    child: Text(
                      widget.name.toString(),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
          ],
        ),
      );
    });
  }
}
