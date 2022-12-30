
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../utils/images.dart';

typedef LogoRemoveCallback = void Function();

class LogoChild extends StatefulWidget {
  LogoChild(
      this.logo,this.onTapRemove);
  
  final String logo;
  final LogoRemoveCallback onTapRemove;

  @override
  _LogoChildState createState() => _LogoChildState();
}

class _LogoChildState extends State<LogoChild> {

  Matrix4? matrix;
  late ValueNotifier<Matrix4?> notifier;

  bool select_logo=false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    matrix = Matrix4.identity();
    notifier = ValueNotifier(matrix);

  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (ctx, constraints) {
          var width = constraints.biggest.width / 4;
          var height = constraints.biggest.height / 4;
         // var dx = (constraints.biggest.width - width);
         // var dy = (constraints.biggest.height - height);
         // matrix!.leftTranslate(dx, dy);
          return MatrixGestureDetector(
            shouldRotate: false,
            onMatrixUpdate: (m, tm, sm, rm) {
              matrix = MatrixGestureDetector.compose(matrix!, tm, sm, null);
              notifier.value = matrix!;
            },
            child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.topLeft,
              child: AnimatedBuilder(
                builder: (ctx, child) {
                  return Transform(
                    transform: matrix!,
                    child: Container(
                      width: width,
                      height: height,
                      child:Container(
                        child: Stack(
                          children: <Widget>[
                            GestureDetector(
                              child:Container(
                                padding: EdgeInsets.only(top: 10,bottom: 10),
                                child: CachedNetworkImage(
                                    placeholder: (context, url) => Container(),
                                    imageUrl:widget.logo),
                              ),
                              onTap: ()=>setState(() {
                                //startLogoTimer();
                                select_logo=!select_logo;
                              }),
                            ),
                            Container(
                              child: !select_logo?
                              Container():
                              GestureDetector(
                                onTap:()=> widget.onTapRemove(),
                                child: Container(
                                    child:Image.asset(Images.close,height: 30,width:30,)
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                animation: notifier,
              ),
            ),
          );
        },
      );

  }

/*@override
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
            child:Container(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    child:Container(
                      padding: EdgeInsets.only(top: 10,bottom: 10),
                      child: CachedNetworkImage(
                          placeholder: (context, url) => Container(),
                          imageUrl:widget.logo),
                    ),
                    onTap: ()=>setState(() {
                      //startLogoTimer();
                      select_logo=!select_logo;
                    }),
                  ),
                  Container(
                    child: !select_logo?
                    Container():
                    GestureDetector(
                      onTap:()=> widget.onTapRemove(),
                      child: Container(
                          child:Image.asset(Images.close,height: 30,width:30,)
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );

  }
*/

}
