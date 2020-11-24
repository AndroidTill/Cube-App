import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(CubeApp());
}

class CubeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.rubikTextTheme(),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int number;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Würfeln"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CubeButton(
            key: ValueKey('CubeButton'),
            onPressed: (n) {
              setState(() {
                number = n;
              });
            },
          ),
          SizedBox(height: 30),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: Curves.decelerate,
            transitionBuilder: (widget, transform) {
              return ScaleTransition(
                scale: transform,
                child: FadeTransition(
                  opacity: transform,
                  child: widget,
                ),
              );
            },
            child: Text(
              "${number ?? "-"}",
              style: TextStyle(fontSize: 38),
              key: ValueKey(number),
            ),
          )
        ],
      ),
    );
  }
}

class CubeButton extends StatefulWidget {
  const CubeButton({Key key, this.onPressed}) : super(key: key);

  final ValueChanged<int> onPressed;

  @override
  _CubeButtonState createState() => _CubeButtonState();
}

class _CubeButtonState extends State<CubeButton> {
  int lastNumber;
  ShakeDetector detector;

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.2,
      onPhoneShake: () {
        widget.onPressed(getUniqueRandomCubeNumber());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            "Würfeln",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
            ),
          ),
        ),
        onPressed: () {
          widget.onPressed(getUniqueRandomCubeNumber());
        },
      ),
    );
  }

  /// Zufällige Zahl von 1 - 6, aber eine Zufällige Zahl von 1-6 die vorher nicht vorkam
  int getUniqueRandomCubeNumber() {
    int number = getRandomCubeNumber();
    while (number == lastNumber) {
      number = getRandomCubeNumber();
    }
    lastNumber = number;
    return number;
  }

  int getRandomCubeNumber() {
    return Random().nextInt(6) + 1;
  }
}
