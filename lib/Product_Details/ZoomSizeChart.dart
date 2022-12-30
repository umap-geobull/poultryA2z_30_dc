import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../Admin_add_Product/Components/Model/size_model.dart';
import '../Utils/App_Apis.dart';

class ZoomSizeChart extends StatefulWidget {
  ZoomSizeChart({
    this.loadingBuilder,
    this.backgroundDecoration,
    this.initialIndex = 0,
    required this.image,
    required this.baseUrl,
    this.scrollDirection = Axis.horizontal,
  }) : pageController = PageController(initialPage: initialIndex);

  String image;
  String baseUrl;
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final int initialIndex;
  final PageController pageController;
  final Axis scrollDirection;


  @override
  State<StatefulWidget> createState() {
    return _ZoomSizeChart();
  }
}

class _ZoomSizeChart extends State<ZoomSizeChart> {
  late int currentIndex = widget.initialIndex;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,color: appBarIconColor,),
          onPressed: ()=>{Navigator.pop(context)},
        ),
        title: Text('Size Chart',style: TextStyle(color: appBarIconColor,fontSize: 17),),
        backgroundColor: appBarColor,
      ),
      body: Container(
        decoration: widget.backgroundDecoration,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: PhotoView(
          backgroundDecoration: BoxDecoration(
            color: Colors.white
          ),
          imageProvider: NetworkImage(widget.baseUrl+sizechart_image_base_url+widget.image),
        ),
      ),
    );
  }
}
