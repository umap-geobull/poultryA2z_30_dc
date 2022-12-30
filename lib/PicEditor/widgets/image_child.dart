

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

import '../model/add_image.dart';
import '../utils/images.dart';

typedef ImageRemoveCallback = void Function(AddImages sticker);

class ImageChild extends StatefulWidget {
  ImageChild(
      this.addImages,this.onTapRemove);
  
  final AddImages addImages;
  final ImageRemoveCallback onTapRemove;

  @override
  _ImageChildState createState() => _ImageChildState();
}

class _ImageChildState extends State<ImageChild> {

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
                         child: Stack(
                           children: <Widget>[
                             GestureDetector(
                               child: Container(
                                   width: widget.addImages.image_width,
                                   height: widget.addImages.image_height,
                                   child: Image.file(widget.addImages.image_file)
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
