// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:curves_animation/main.dart';
import 'package:curves_animation/others/constants.dart';
import 'package:curves_animation/BezeirCurvePage.dart';
import 'package:curves_animation/providers/mainscreenProvider.dart';
import 'package:flutter/material.dart';

import 'dart:html' as html;

import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

List<Color> circleColors = [Colors.red, Colors.green];

class TopBar extends StatefulWidget {
  TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

TextEditingController projectNameTextController = TextEditingController();
int timeInMillisec = 2000;

class _TopBarState extends State<TopBar> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController numberController =
      TextEditingController(text: timeInMillisec.toString());
  @override
  Widget build(BuildContext context) {
    MainProvider mainProvider = Provider.of<MainProvider>(context);
    // debugLog("value c [$numberController] $timeInMillisec");
    return Container(
      // width: double.infinity,
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(8),
      height: topbarHeight,
      decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(topbarHeight * 0.2)),
      // color: Color.fromARGB(255, 167, 168, 205),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              timeInMillisec = 2000;
              numberController =
                  TextEditingController(text: timeInMillisec.toString());
              mainProvider.updateUI();
            },
            child: Text(
              "Time : ",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
            ),
          ),
          Container(
            width: 100,
            height: topbarHeight,
            margin: EdgeInsets.symmetric(horizontal: 8),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.only(left: 10)),
              onChanged: (value) {
                if (int.tryParse(value) != null) {
                  if (int.parse(value) > 0 && int.parse(value) < 1000000) {
                    timeInMillisec = int.parse(value);
                  }
                }
                numberController =
                    TextEditingController(text: timeInMillisec.toString());
                numberController.selection = TextSelection.collapsed(
                    offset: numberController.text.length);
                debugLog("value  [$value] $timeInMillisec");
                mainProvider.updateUI();
              },
              controller: numberController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numb
            ),
          ),
          CircleWithPointValue(
            color: circleColors[0],
            text:
                "${(points[1].dx / boxsize).toStringAsFixed(2)}, ${(points[1].dy / boxsize).toStringAsFixed(2)}",
          ),
          CircleWithPointValue(
            color: circleColors[1],
            text:
                "${(points[2].dx / boxsize).toStringAsFixed(2)}, ${(points[2].dy / boxsize).toStringAsFixed(2)}",
          ),
          TextButton.icon(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide()))),
              onPressed: () async {
                // showCodeInDialog(gradProvider, context);
                showDialog(
                    context: context,
                    builder: (context) {
                      return codeDialog(context);
                    });
              },
              icon: Container(
                  height: topbarHeight * 0.8,
                  child: const Icon(Icons.data_object, color: Colors.black)),
              label: const Text(
                "Get Code",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )),
          IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {
                scaffoldKey.currentState!.openEndDrawer();
              },
              icon: const Icon(Icons.menu)),
        ],
      ),
    );
  }

  Widget codeDialog(BuildContext context) {
    String code = '''
class CustomBezierCurve extends Curve {

  @override
  double transform(double t) {
    double maxX = max(${points[0].dx},${points[3].dx});
    double x = 
        (${points[0].dx}/maxX) * pow(1 - t, 3) +
        (${points[1].dx}/maxX) * pow(1 - t, 2) * 3 * t +
        (${points[2].dx}/maxX) * pow(1 - t, 1) * 3 * t * t +
        (${points[3].dx}/maxX) * pow(t, 3);

    return x;
  }
}

''';
    String implementationCode = '''
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

''';
    String importLines =
        "import 'dart:math';\nimport 'package:flutter/material.dart';";
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: w * 0.2, vertical: 40),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: importLines+"\n"+code+"\n"+implementationCode));
                    },
                    icon: Icon(Icons.copy_all)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.red,
                    ))
              ],
            ),
            ContainerWithBorderAndCopyButton(
                text:
                    importLines),
            ContainerWithBorderAndCopyButton(text: code),
            ContainerWithBorderAndCopyButton(text: implementationCode),
          ],
        ),
      ),
    );
  }
}

class ContainerWithBorderAndCopyButton extends StatelessWidget {
  final String text;
  const ContainerWithBorderAndCopyButton({Key? key, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 9, 3, 32),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Spacer(),
            CopyButton(
              text: text,
            ),
          ],
        ));
  }
}

class CopyButton extends StatelessWidget {
  final String text;
  final Color color;
  const CopyButton({Key? key, required this.text, this.color = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Clipboard.setData(ClipboardData(text: text));
        },
        icon: Icon(
          Icons.copy,
          color: color,
        ));
  }
}

class CircleWithPointValue extends StatelessWidget {
  final Color color;
  final String text;
  const CircleWithPointValue(
      {Key? key, required this.color, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: topbarHeight * 0.22,
          backgroundColor: color,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900),
          ),
        )
      ],
    );
  }
}
