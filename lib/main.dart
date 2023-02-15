import 'dart:developer';

import 'package:curves_animation/BezeirCurvePage.dart';
import 'package:curves_animation/a.dart';
import 'package:curves_animation/providers/mainscreenProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

double w = 200;
double h = 300;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MainProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Animation Curves',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Builder(
          builder: (context) {
            w = MediaQuery.of(context).size.width;
            h = MediaQuery.of(context).size.height;
            return 
            // Example();
            BezeirCurvePage();
          },
        ),
      ),
    );
  }
}

void debugLog(String s) {
  if (kDebugMode) {
    log(s);
  }
}
