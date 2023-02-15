import 'package:curves_animation/2D%20Geometris/curve1.dart';
import 'package:curves_animation/main.dart';
import 'package:curves_animation/others/constants.dart';
import 'package:curves_animation/paints/bezeirPaint.dart';
import 'package:curves_animation/providers/mainscreenProvider.dart';
import 'package:curves_animation/widgets/drawer.dart';
import 'package:curves_animation/widgets/horzMotionWidgetForInBuitCurve.dart';
import 'package:curves_animation/widgets/rotatingWidget.dart';
import 'package:curves_animation/widgets/scalingWidget.dart';
import 'package:curves_animation/widgets/top_bar.dart';
import 'package:curves_animation/widgets/verticalMotionWidgetForCustomCurve.dart';
import 'package:flutter/material.dart';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();

enum SelecedCurveType { bezier, inbuilt }

SelecedCurveType selecedCurveType = SelecedCurveType.bezier;
int selecedInbuiltCurveIndex = 0;

class BezeirCurvePage extends StatefulWidget {
  BezeirCurvePage({Key? key}) : super(key: key);

  @override
  State<BezeirCurvePage> createState() => _BezeirCurvePageState();
}

// List<Offset> points = [
//   Offset.zero,
//   Offset(h * 0.2, h * 0.2),
//   Offset(h * 0.2, h * 0.2),
//   Offset(h * 0.4, h * 0.4)
// ];
double boxsize = (h - 100 - topbarHeight).abs() * 0.6;
List<Offset> points = [
  Offset.zero,
  Offset(boxsize * cubics[0], boxsize * cubics[1]),
  Offset(boxsize * cubics[2], boxsize * cubics[3]),
  Offset(boxsize, boxsize),
];
// 0.215, 0.61, 0.355, 1.0
List<double> cubics = [
  // 0.25, 0.46, 0.45, 0.94
  0.25, 0.75, 0.75, 0.25,
  // 0.18, 1.0, 0.04, 1.0
];

List<double> pointsToCubicDecimalValues(
    List<Offset> points, Offset origin, Offset oppositeCorner) {
  double maxY = (origin.dy - oppositeCorner.dy).abs();
  return points.map((e) {
    return e.dy / maxY;
  }).toList();
}

List<String> inbuiltCurvesNames = [
  "bounceIn",
  "bounceInOut",
  "bounceOut",
  "decelerate",
  "linear",
  "ease",
  "easeIn",
  "easeInBack",
  "easeInCirc",
  "easeInCubic",
  "easeInExpo",
  "easeInOut",
  "easeInOutBack",
  "easeInOutCirc",
  "easeInOutCubic",
  "easeInOutCubicEmphasized",
  "easeInOutExpo",
  "easeInOutQuad",
  "easeInOutQuart",
  "easeInOutQuint",
  "easeInSine",
  "easeInToLinear",
  "easeOut",
  "easeOutBack",
  "easeOutCirc",
  "easeOutCubic",
  "easeOutExpo",
  "easeOutQuad",
  "easeOutQuart",
  "easeOutQuint",
  "easeOutSine",
  "elasticIn",
  "elasticInOut",
  "elasticOut",
  "fastLinearToSlowEaseIn",
  "fastOutSlowIn",
  "linear",
  "linearToEaseOut",
  "slowMiddle",
];
List<Curve> inbuiltCurves = [
  Curves.bounceIn,
  Curves.bounceInOut,
  Curves.bounceOut,
  Curves.decelerate,
  Curves.linear,
  Curves.ease,
  Curves.easeIn,
  Curves.easeInBack,
  Curves.easeInCirc,
  Curves.easeInCubic,
  Curves.easeInExpo,
  Curves.easeInOut,
  Curves.easeInOutBack,
  Curves.easeInOutCirc,
  Curves.easeInOutCubic,
  Curves.easeInOutCubicEmphasized,
  Curves.easeInOutExpo,
  Curves.easeInOutQuad,
  Curves.easeInOutQuart,
  Curves.easeInOutQuint,
  Curves.easeInSine,
  Curves.easeInToLinear,
  Curves.easeOut,
  Curves.easeOutBack,
  Curves.easeOutCirc,
  Curves.easeOutCubic,
  Curves.easeOutExpo,
  Curves.easeOutQuad,
  Curves.easeOutQuart,
  Curves.easeOutQuint,
  Curves.easeOutSine,
  Curves.elasticIn,
  Curves.elasticInOut,
  Curves.elasticOut,
  Curves.fastLinearToSlowEaseIn,
  Curves.fastOutSlowIn,
  Curves.linear,
  Curves.linearToEaseOut,
  Curves.slowMiddle,
];

class _BezeirCurvePageState extends State<BezeirCurvePage>
    with TickerProviderStateMixin {
  ScrollController inbuildCurvsController = ScrollController();
  double vertBallWidth = 80;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: timeInMillisec));
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(points),
      reverseCurve: Curves.easeOut,
    );
    animation.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  late AnimationController controller;
  late Animation<double> animation;
  setAnimation() {
    animation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(points),
      reverseCurve: Curves.easeOut,
    );
  }

  List<List<Offset>> listOfPointsList = [];
  List<CurvedAnimation> animations = [];
  addNewPointsSet() {
    listOfPointsList.add(List.from(points));
    CurvedAnimation tempAnimation = CurvedAnimation(
      parent: controller,
      curve: BezierCurve(listOfPointsList.last),
      reverseCurve: Curves.easeOut,
    );

    animations.add(tempAnimation);
    animations.last.addListener(() {
      setState(() {});
    });
  }

  late MainProvider mainProvider;
  Offset curveEditorBoxPosition = Offset(boxsize * 0.2, boxsize * 0.2);
  @override
  Widget build(BuildContext context) {
    mainProvider = Provider.of<MainProvider>(context);
    debugLog(
        "selecedInbuiltCurveIndex $selecedInbuiltCurveIndex : selecedCurveType $selecedCurveType  ");
    // MainP
    //  cubics= pointsToCubicDecimalValues(points, points.first, points.last);
    return Scaffold(
        endDrawer: AppDrawer(),
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Container(
              width: w,
              height: h,
              child: Container(
                child: Stack(
                    fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(right: 0, top: 0, child: TopBar()),
                      Positioned(
                        left: curveEditorBoxPosition.dx,
                        top: curveEditorBoxPosition.dy,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: w,
                              height: h,
                              color: Colors.transparent,
                            ),
                            GestureDetector(
                              // onPanUpdate: (d) {
                              //   setState(() {
                              //     curveEditorBoxPosition = Offset(
                              //         curveEditorBoxPosition.dx + d.delta.dx,
                              //         curveEditorBoxPosition.dy + d.delta.dy);
                              //   });
                              // },
                              child: Container(
                                width: boxsize + 20,
                                height: boxsize + 20,
                                color: Colors.amber.shade100,
                                child: Transform.translate(
                                  offset: Offset(5, 5),
                                  // origin: Offset(10,10),
                                  // // Offset(boxsize*0.5, boxsize*0.5),
                                  // angle: pi * 0.5 * 0,
                                  child: CustomPaint(
                                    size: Size(boxsize, boxsize),
                                    painter: BezeirPaint(points: points),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      inbuildCurvesListWidget(),
                      Positioned(
                          top: topbarHeight + 10,
                          right: 20 + vertBallWidth + 20,
                          child: Builder(builder: (context) {
                            debugLog(
                                "horzbuild single special $selecedCurveType ");
                            return HorzMotionWidgetForInBuitCurve(
                              showBG: false,
                              i: selecedInbuiltCurveIndex,
                              curve: selecedCurveType == SelecedCurveType.bezier
                                  ? BezierCurve(points)
                                  : inbuiltCurves[selecedInbuiltCurveIndex %
                                      inbuiltCurves.length],
                              showCurveName: false,
                              name: "name",
                              width: (w -
                                      (boxsize +
                                          20 +
                                          vertBallWidth +
                                          20 +
                                          curveEditorBoxPosition.dx +
                                          20 +
                                          80))
                                  .abs(),
                              height: 80,
                            );
                          })
                          // Consumer<MainProvider>(
                          //   builder: (context, value, child) {
                          //     return H
                          //   },
                          // )
                          ),
                      Positioned(
                          top: topbarHeight + 10,
                          right: 20,
                          child: VertMotionWidgetCurve(
                            curve: selecedCurveType == SelecedCurveType.bezier
                                ? BezierCurve(points)
                                : inbuiltCurves[selecedInbuiltCurveIndex %
                                    inbuiltCurves.length],
                            width: vertBallWidth,
                            height: h - topbarHeight - 200,
                          )),

                      scalingWidget((w -
                                  (boxsize +
                                      20 +
                                      vertBallWidth +
                                      20 +
                                      curveEditorBoxPosition.dx +
                                      20 +
                                      80))
                              .abs() *
                          0.3),

                      rotatingWidget((w -
                                  (boxsize +
                                      20 +
                                      vertBallWidth +
                                      20 +
                                      curveEditorBoxPosition.dx +
                                      20 +
                                      80))
                              .abs() *
                          0.3),title(),
                      resetButton(),
                      ...List.generate(points.length, (i) {
                        return Positioned(
                          left: points[i].dx + curveEditorBoxPosition.dx,
                          top: points[i].dy + curveEditorBoxPosition.dy,
                          child: GestureDetector(
                            onPanUpdate: (d) {
                              if (!(i == 0 || i == points.length - 1)) {
                                //  debugLog("pos is ${d.globalPosition} /  $topbarHeight");

                                setState(() {
                                  points[i] = Offset(points[i].dx + d.delta.dx,
                                      points[i].dy + d.delta.dy);
                                });
                              }
                            },
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor:
                                  (i == 0 || i == points.length - 1)
                                      ? Colors.deepPurple
                                      : circleColors[
                                          (i - 1).abs() % circleColors.length],
                            ),
                          ),
                        );
                      }),

                      //
/*
                  Positioned(
                    left: boxsize * 0.3,
                    top: boxsize + 100,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              addNewPointsSet();
                              setState(() {});
                            },
                            icon: Icon(Icons.add_circle_rounded)),
                      ),
                    ),
                  ),
                  Positioned(
                    left: boxsize * 0.3 + 60,
                    top: boxsize + 100,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.red,
                      child: Center(
                        child: IconButton(
                            onPressed: () {
                              controller.reset();
                              controller.forward();
                            },
                            icon: Icon(Icons.start)),
                      ),
                    ),
                  ),
                  Positioned(
                      top: h * 0.6,
                      child: Listener(
                        onPointerDown: (event) {
                          d.log("onpointerdown parent $event");
                        },
                        child: Stack(
                          children: [
                            Listener(
                                onPointerDown: (event) {
                                  d.log("onpointerdown 2  $event");
                                },
                                child: Container(
                                  color: Colors.red,
                                  width: 100,
                                  height: 100,
                                )),
                            Listener(
                                onPointerDown: (event) {
                                  d.log("onpointerdown 1  $event");
                                },
                                child: Container(
                                  color: Colors.amber.withAlpha(150),
                                  width: 50,
                                  height: 50,
                                )),
                            IconButton(
                                onPressed: () {
                                  // points.clear();
                                  // setState(() {});
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      )),
                  Positioned(
                    left: boxsize + 50,
                    top: 0,
                    child: IgnorePointer(
                      ignoring: false,
                      child: Container(
                        width: w - boxsize * 1.2 + 40,
                        height: h,
                        child: ListView.builder(
                            itemCount: animations.length,
                            itemBuilder: (c, i) {
                              return Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        // controller.reset();
                                        // points.removeAt(i);
                                        // animations.removeAt(i);

                                        debugLog(
                                            " points ${points.length} / ${animations.length}");
                                        animations.removeAt(i);
                                        debugLog(
                                            "af points ${points.length} / ${animations.length}");
                                        setState(() {});
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  _AnimCurveBoard(
                                    animValue: animations[i].value,
                                    no: i,
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
               
               */
                    ]),
              ),
            )
          ],
        ));
  }

  inbuildCurvesListWidget() {
    double boxH = 70 + 12 + 16 + 8 + 16;
    return Positioned(
        bottom: 12,
        child: Container(
          color: Colors.grey.shade50,
          width: w,
          height: boxH,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  selecedCurveType = SelecedCurveType.bezier;

                  mainProvider.updateUI();
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  width: boxH,
                  height: boxH - 16,
                  decoration: BoxDecoration(
                      border: selecedCurveType == SelecedCurveType.bezier
                          ? Border.all()
                          : null,
                      color: selecedCurveType == SelecedCurveType.bezier
                          ? Colors.grey.shade400
                          :
                          // Colors.transparent,
                          Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                    child: Text(
                      "Bezier",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: ScrollbarTheme(
                data: ScrollbarThemeData(
                    trackColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white)),
                child: Scrollbar(
                  trackVisibility: true,
                  controller: inbuildCurvsController,
                  child: ListView.builder(
                    controller: inbuildCurvsController,
                    itemCount: inbuiltCurves.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, i) {
                      return InkWell(
                        onTap: () {
                          selecedCurveType = SelecedCurveType.inbuilt;
                          selecedInbuiltCurveIndex = i;

                          debugLog(
                              "selecedInbuiltCurveIndex $selecedInbuiltCurveIndex : ");

                          // mainProvider.updateUI();

                          setState(() {});
                        },
                        child: HorzMotionWidgetForInBuitCurve(
                          i: i,
                          curve: inbuiltCurves[i],
                          name:
                              inbuiltCurvesNames[i % inbuiltCurvesNames.length],
                        ),
                      );
                    },
                  ),
                ),
              ))
            ],
          ),
        ));
  }

  resetButton() {
    return Positioned(
        left: curveEditorBoxPosition.dx,
        top: curveEditorBoxPosition.dy + 20 + boxsize + 20,
        child: Container(
            width: boxsize + 20,
            child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      points = [
                        Offset.zero,
                        Offset(boxsize * cubics[0], boxsize * cubics[1]),
                        Offset(boxsize * cubics[2], boxsize * cubics[3]),
                        Offset(boxsize, boxsize),
                      ];
                      setState(() {});
                    },
                    child: Text("Reset")))));
  }

  title() {
    return Positioned(
left: curveEditorBoxPosition.dx,
top: 10,
child: Container(width: boxsize+20,
padding: EdgeInsets.all(8),
height: (curveEditorBoxPosition.dy-20).abs(),
// color: Colors.deepOrange,
child: FittedBox(child: Text("Bezier Curve",
style: TextStyle(
  color: Colors.white,
  // fontSize: 
),
)),
),

    );
  }

  rotatingWidget(double bw) {
    return Positioned(
        left: boxsize + curveEditorBoxPosition.dx + 100 + bw + 100,
        top: topbarHeight + 120,
        child: RotatingWidget(
          bw: bw,
          curve: selecedCurveType == SelecedCurveType.bezier
              ? BezierCurve(points)
              : inbuiltCurves[selecedInbuiltCurveIndex % inbuiltCurves.length],
        ));
  }

  scalingWidget(double bw) {
    return Positioned(
        left: boxsize + curveEditorBoxPosition.dx + 100,
        top: topbarHeight + 120,
        child: ScalingWidget(
          bw: bw,
          curve: selecedCurveType == SelecedCurveType.bezier
              ? BezierCurve(points)
              : inbuiltCurves[selecedInbuiltCurveIndex % inbuiltCurves.length],
        ));
  }
}

class _AnimCurveBoard extends StatelessWidget {
  final int no;
  final double animValue;
  const _AnimCurveBoard({Key? key, required this.no, required this.animValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // d.log("boxsize $animValue");
    return Container(
      width: w - boxsize * 1.2,
      height: 50,
      color: Colors.primaries[no % Colors.primaries.length].shade100,
      child: Stack(fit: StackFit.expand, children: [
        Positioned(
          top: 0,
          left: animValue * (w - boxsize * 1.2 - 50),
          child: Center(
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.primaries[no % Colors.primaries.length],
            ),
          ),
        )
      ]),
    );
  }
}

class BezeirCubicModel {
  List<Offset> points = [
    Offset.zero,
    Offset.zero,
    Offset.zero,
    Offset.zero,
  ];
  BezeirCubicModel(this.points);
  Offset getPointAt(double t) {
    double x = points[0].dx * pow(1 - t, 3) +
        points[1].dx * pow(1 - t, 2) * 3 * t +
        points[2].dx * pow(1 - t, 1) * 3 * t * t +
        points[3].dx * pow(t, 3);

    double y = points[0].dy * pow(1 - t, 3) +
        points[1].dy * pow(1 - t, 2) * 3 * t +
        points[2].dy * pow(1 - t, 1) * 3 * t * t +
        points[3].dy * pow(t, 3);
    return Offset(x, y);
  }

  double getYValueFor_t(double t) {
    double y = points[0].dy * pow(1 - t, 3) +
        points[1].dy * pow(1 - t, 2) * 3 * t +
        points[2].dy * pow(1 - t, 1) * 3 * t * t +
        points[3].dy * pow(t, 3);
    return y;
  }
}
