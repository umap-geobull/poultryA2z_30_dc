
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../model/add_text.dart';
import '../utils/images.dart';

typedef TextRemoveCallback = void Function(AddText sticker);

class TextChild extends StatefulWidget {
  TextChild(
      this.addText,this.onTapRemove);
  
  final AddText addText;
  final TextRemoveCallback onTapRemove;

  @override
  _TextChildState createState() => _TextChildState();
}

class _TextChildState extends State<TextChild> {

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
                                      color: widget.addText.backgroundColor,
                                      margin:EdgeInsets.only(top: 10,left: 10),
                                      child: Text(
                                        widget.addText.text, style: GoogleFonts.getFont(widget.addText.fontFamilyText).copyWith(
                                          fontSize:widget.addText.textSize,
                                          fontWeight: FontWeight.bold,
                                          color: widget.addText.textColor),
                                      ),
                                    ),
                                  ),
                                  onTap: ()=>setState(() {
                                    widget.addText.isSelected=!widget.addText.isSelected;
                                  }),
                                ),
                                Container(
                                  child: !widget.addText.isSelected?
                                  Container():
                                  GestureDetector(
                                    onTap:()=> widget.onTapRemove(widget.addText),
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

 /* @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child:
              Container(
                child:  !widget.addText.isSelected?
                Container(
                  padding: EdgeInsets.all(5),
                  color: widget.addText.backgroundColor,
                  margin:EdgeInsets.only(top: 10,left: 10),
                  child: Text(
                    widget.addText.text, style: GoogleFonts.getFont(widget.addText.fontFamilyText).copyWith(
                      fontSize:widget.addText.textSize,
                      fontWeight: FontWeight.bold,
                      color: widget.addText.textColor),
                  ),
                ):
                Container(
                  padding: EdgeInsets.all(5),
                  color: widget.addText.backgroundColor,
                  margin:EdgeInsets.only(top: 10,left: 10),
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(5),
                    color: Colors.grey,
                    strokeWidth: 1,
                    padding: EdgeInsets.all(5),
                    child: Text(
                      widget.addText.text,
                      style: GoogleFonts.getFont(widget.addText.fontFamilyText).copyWith(fontSize: widget.addText.textSize,
                          fontWeight: FontWeight.bold,
                          color: widget.addText.textColor),
                    ),
                  ),
                ),
              ),
              onTap: ()=>setState(() {
                widget.addText.isSelected=!widget.addText.isSelected;
              }),
            ),
            Container(
              child: !widget.addText.isSelected?
              Container():
              GestureDetector(
                onTap:()=> widget.onTapRemove(widget.addText),
                child: Container(
                    child:Image.asset(Images.close,height: 15,width:15,)
                ),
              ),
            )
          ],
        ),
      );

  }*/
}
