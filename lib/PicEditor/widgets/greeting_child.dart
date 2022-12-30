
import 'dart:io';


import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class GreetingChild extends StatefulWidget {
  GreetingChild(
      this.greeting);
  
  final File greeting;

  @override
  _GreetingChildState createState() => _GreetingChildState();
}

class _GreetingChildState extends State<GreetingChild> {

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  void dispose() {
    super.dispose();
  }

 @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      shouldRotate: false,
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: AnimatedBuilder(
        animation: notifier,
        builder: (ctx, child) {
          return Transform(
            transform: notifier.value,
            //child: Image.network(widget.addStricker.sticker)
            child: Stack(
              children: <Widget>[
                Positioned.fill(
                   child: Container(
                     transform: notifier.value,
                     child: FittedBox(
                       fit: BoxFit.contain,
                       child: Container(
                         height: 100,
                         width: 100,
                           child: Container(
                               child: Image.file(widget.greeting)
                           ),
                       ),
                     ),
                    )
                   ),
              ],
            ),
          );
        },
      ),
    );

  }
}
