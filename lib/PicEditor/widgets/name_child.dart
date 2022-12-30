
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../model/add_name.dart';
import '../utils/images.dart';

typedef NameRemoveCallback = void Function();

class NameChild extends StatefulWidget {
  NameChild(
      this.name,this.onTapRemove);
  
  final AddName name;
  final NameRemoveCallback onTapRemove;

  @override
  _NameChildState createState() => _NameChildState();
}

class _NameChildState extends State<NameChild> {

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

 // Matrix4? matrix;
 // late ValueNotifier<Matrix4?> notifier;


  bool select_name=false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  //  matrix = Matrix4.identity();
   // notifier = ValueNotifier(matrix);

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
                          // height: 150,
                          //width: 150,
                          child: Stack(
                            children: <Widget>[
                              GestureDetector(
                                child:
                                Container(
                                  child: Container(
                                    // height: 100,
                                    // width: 100,
                                    padding: EdgeInsets.all(5),
                                    margin:EdgeInsets.only(top: 10,left: 10),
                                    child: Text(
                                      widget.name.name, style: GoogleFonts.getFont(widget.name.fontFamily).copyWith(
                                        fontSize:widget.name.textSize,
                                        fontWeight: FontWeight.bold,
                                        color: widget.name.textColor),
                                    ),
                                  ),
                                ),
                                onTap: ()=>setState(() {
                                  widget.name.isSelected=!widget.name.isSelected;
                                }),
                              ),
                              Container(
                                child: !widget.name.isSelected?
                                Container():
                                GestureDetector(
                                  onTap:()=> widget.onTapRemove(),
                                  child: Container(
                                      child:Image.asset(Images.close,height: 15,width:15,)
                                  ),
                                ),
                              )
                            ],
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

/*
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
            child:Container(
              child: Stack(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      child:Text(widget.name.name,
                        style: GoogleFonts.getFont(widget.name.fontFamily).
                        copyWith(fontSize: widget.name.textSize,
                            fontWeight: FontWeight.bold,
                            color: widget.name.textColor),
                      ),
                    ),
                    onTap: ()=>setState(() {
                      //startLogoTimer();
                      select_name=!select_name;
                    }),
                  ),
                  Container(
                    child: !select_name?
                    Container():
                    GestureDetector(
                      onTap:()=> widget.onTapRemove(),
                      child: Container(
                          child:Image.asset(Images.close,height: 15,width:15,)
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

/*
 @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                child:  !widget.addImages.isSelected?
                Container(
                    width: widget.addImages.image_width,
                    height: widget.addImages.image_height,
                    child: Image.file(widget.addImages.image_file)
                ) :

                Container(
                  padding: EdgeInsets.all(5),
                  margin:EdgeInsets.only(top: 10,left: 10),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5),
                    color: Colors.grey,
                    strokeWidth: 1,
                    padding: EdgeInsets.all(5),
                    child: Container(
                        width: widget.addImages.image_width,
                        height: widget.addImages.image_height,
                        child: Image.file(widget.addImages.image_file)
                    ),
                  ),
                ),
              ),
              onTap: ()=>setState(() {
                //startLogoTimer();
                widget.addImages.isSelected=!widget.addImages.isSelected;
              }),
            ),
            Container(
              child: !widget.addImages.isSelected?
              Container():
              GestureDetector(
                onTap:()=> widget.onTapRemove(widget.addImages),
                child: Container(
                    child:Image.asset(Images.close,height: 15,width:15,)
                ),
              ),
            )
          ],
        ),
      );
  }
*/

}
