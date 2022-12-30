
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:photo_view/photo_view.dart';

import '../model/add_sticker.dart';
import '../utils/images.dart';

typedef StickerImageRemoveCallback = void Function(AddStricker sticker);
//typedef StickerImageSelectCallback = void Function(AddStricker sticker);

class StickerChild extends StatefulWidget {
  StickerChild(
      this.addStricker,this.onTapRemove);
  
  final AddStricker addStricker;
  final StickerImageRemoveCallback onTapRemove;
 // final StickerImageSelectCallback onTapSelect;

  @override
  _StickerChildState createState() => _StickerChildState();
}

class _StickerChildState extends State<StickerChild> {

  Matrix4? matrix;
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
   // matrix = Matrix4.identity();

  }

 /* @override
  Widget build(BuildContext context) {
    return
      LayoutBuilder(
        builder: (ctx, constraints) {
          var width = 100.0;
          var height = 100.0;
          // var dx = (constraints.biggest.width - width);
          // var dy = (constraints.biggest.height - height);
          // matrix!.leftTranslate(dx, dy);
          return MatrixGestureDetector(
            shouldRotate: true,
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
                      child: Stack(
                        children: <Widget>[
                          GestureDetector(
                            child: Container(
                                width: widget.addStricker.image_width,
                                height: widget.addStricker.image_height,
                                child: Image.network(widget.addStricker.sticker)
                            ),
                            onTap: ()=>setState(() {
                              //startLogoTimer();
                              widget.addStricker.isSelected=!widget.addStricker.isSelected;
                            }),
                          ),
                          Container(
                            child: !widget.addStricker.isSelected?
                            Container():
                            GestureDetector(
                              onTap:()=>this.widget.onTapRemove(widget.addStricker),
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
                animation: notifier,
              ),
            ),
          );
        },
      );

  }*/

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
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
                                      width: widget.addStricker.image_width,
                                      height: widget.addStricker.image_height,
                                      child: Image.network(widget.addStricker.sticker)
                                  ),
                                  onTap: ()=>setState(() {
                                    //startLogoTimer();
                                    widget.addStricker.isSelected=!widget.addStricker.isSelected;
                                  }),
                                ),
                                Container(
                                  child: !widget.addStricker.isSelected?
                                  Container():
                                  GestureDetector(
                                    onTap:()=>this.widget.onTapRemove(widget.addStricker),
                                    child: Container(
                                        child:Image.asset(Images.close,height: 15,width:15,)
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ),
                    ),
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
            child: Container(
              child:  !widget.addStricker.isSelected?
              Container(
                  width: widget.addStricker.image_width,
                  height: widget.addStricker.image_height,
                  child: ClipRect(
                    child: PhotoView(
                      imageProvider: NetworkImage(widget.addStricker.sticker),
                      backgroundDecoration: BoxDecoration(
                          color: Colors.transparent
                      ),
                      minScale: minScale_greeting,
                      maxScale: maxScale_greeting,
                      initialScale: 0.05,
                      enableRotation: true,
                      // heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                    ),
                  )
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
                    child:Container(
                        width: widget.addStricker.image_width,
                        height: widget.addStricker.image_height,
                        child: ClipRect(
                          child: PhotoView(
                            imageProvider: NetworkImage(widget.addStricker.sticker),
                            backgroundDecoration: BoxDecoration(
                                color: Colors.transparent
                            ),
                            //minScale: minScale_greeting,
                            //maxScale: maxScale_greeting,
                            //initialScale: 0.05,
                            enableRotation: true,
                            // heroAttributes: const PhotoViewHeroAttributes(tag: "someTag"),
                          ),
                        )
                    )
                ),
              ),
            ),
            //onTap: ()=> this.widget.onTapSelect(widget.addStricker),
          ),
          Container(
            child: !widget.addStricker.isSelected?
            Container():
            GestureDetector(
              onTap:()=>this.widget.onTapRemove(widget.addStricker),
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

/* @override
  Widget build(BuildContext context) {
    return
      Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            child: Container(
              child:  !widget.addStricker.isSelected?
              Container(
                  width: widget.addStricker.image_width,
                  height: widget.addStricker.image_height,
                  child: Image.network(widget.addStricker.sticker)
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
                  child:Transform.rotate(
                      angle: 0.0,
                      child:Container(
                          width: widget.addStricker.image_width,
                          height: widget.addStricker.image_height,
                          child: Image.network(widget.addStricker.sticker)
                      )
                  ),
                ),
              ),
            ),
            onTap: ()=>setState(() {
              //startLogoTimer();
              widget.addStricker.isSelected=!widget.addStricker.isSelected;
            }),
          ),
          Container(
            child: !widget.addStricker.isSelected?
            Container():
            GestureDetector(
              onTap:()=>this.widget.onTapRemove(widget.addStricker),
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
