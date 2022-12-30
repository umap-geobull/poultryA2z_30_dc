import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/settings/AddSizeChart/AddSizeChart.dart';
import 'package:http/http.dart' as http;
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import '../../PicEditor/GalleryModel.dart';
import '../../PicEditor/GrobizPhotoViewGallery.dart';
import '../../Product_Details/ZoomPhotoViewGallery.dart';
import '../../Utils/AppConfig.dart';
import '../../Utils/App_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Admin_add_Product/constants.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class GalleryImages extends StatefulWidget {
  @override
  State<GalleryImages> createState() => GalleryImagesState();
}

class GalleryImagesState extends State<GalleryImages> {
  String baseUrl = '';
  String user_id = '', user_type = '';
  bool isApiCallProcessing = false;
  List<GetGalleryImages> galleryImagesList = [];
  Color appBarColor = Colors.white,
      appBarIconColor = Colors.black,
      primaryButtonColor = Colors.orange,
      secondaryButtonColor = Colors.orangeAccent;
  late Route routes;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secureScreen();
    getappUi();
    getBaseUrl();
  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  void getimageList() async {
    if (mounted) {
      setState(() {
        isApiCallProcessing = true;
      });
    }

    final body = {
      "user_auto_id": user_id,
    };

    var url = baseUrl + get_banner_images;
    print(url);
    var uri = Uri.parse(url);
    final response = await http.post(uri, body: body);
    if (response.statusCode == 200) {
      isApiCallProcessing = false;

      final resp = jsonDecode(response.body);
      int status = resp['status'];
      if (status == 1) {
        GalleryModel imagesModel =
            GalleryModel.fromJson(json.decode(response.body));
        galleryImagesList = imagesModel.data;
        print(galleryImagesList.toString());
        if (mounted) {
          setState(() {});
        }
      } else {
        galleryImagesList = [];
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text('Grobiz Gallery',
            style: TextStyle(
                color: appBarIconColor,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        leading: IconButton(
            color: appBarIconColor,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
        actions: [],
      ),
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.all(5),
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: galleryImagesList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1 / 1.5,
                                crossAxisCount: 3,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 2.0),
                        itemBuilder: (BuildContext context, int index) {
                          return SizeCard(galleryImagesList[index],index);
                        })),
              ],
            ),
          ),
        ),
        isApiCallProcessing == false && galleryImagesList.isEmpty
            ? Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text('No plans purchased yet'),
              )
            : Container(),
        isApiCallProcessing == true
            ? Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: GFLoader(type: GFLoaderType.circle),
              )
            : Container(),
      ]),
    );
  }

  void getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseurl = prefs.getString('base_url');
    String? userId = prefs.getString('user_id');
    baseUrl = AppConfig.grobizBaseUrl;
    if (userId != null) {
      setState(() {
        user_id = userId;
        print(userId);
        // baseUrl=AppConfig.grobizBaseUrl;
        // print(baseUrl);
        getimageList();
      });
    }
  }

  FutureOr onGoBack(dynamic value) {
    // getSizeCharts();
  }

  void getappUi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? appBarColor = prefs.getString('appbarColor');
    String? appbarIcon = prefs.getString('appbarIconColor');
    String? primaryButtonColor = prefs.getString('primaryButtonColor');
    String? secondaryButtonColor = prefs.getString('secondaryButtonColor');
    String? bottomBarColor = prefs.getString('bottomBarColor');
    String? bottombarIcon = prefs.getString('bottomBarIconColor');
    // if(bottomBarColor!=null){
    //   this.bototmBarColor=Color(int.parse(bottomBarColor));
    //   setState(() {});
    // }
    //
    // if(bottombarIcon!=null){
    //   this.bottomMenuIconColor=Color(int.parse(bottombarIcon));
    //   setState(() {});
    // }

    if (appBarColor != null) {
      this.appBarColor = Color(int.parse(appBarColor));
    }

    if (appbarIcon != null) {
      this.appBarIconColor = Color(int.parse(appbarIcon));
    }

    if (primaryButtonColor != null) {
      this.primaryButtonColor = Color(int.parse(primaryButtonColor));
      print(this.primaryButtonColor.value.toString());
    }

    if (secondaryButtonColor != null) {
      this.secondaryButtonColor = Color(int.parse(secondaryButtonColor));
      print(this.secondaryButtonColor.value.toString());
    }

    if (this.mounted) {
      setState(() {});
    }
  }

  SizeCard(GetGalleryImages galleryimages,int index) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[100],
        child: GestureDetector(
            onTap: () => {
              showImages(galleryImagesList,index)
                },
            child: galleryimages.imageName.isNotEmpty
                ? CachedNetworkImage(
                    fit: BoxFit.contain,
                    imageUrl: gallery_image_base_url + galleryimages.imageName,
                    placeholder: (context, url) => Container(
                        decoration: BoxDecoration(
                      color: Colors.grey[400],
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  )
                : Container(
                    child: const Icon(Icons.error),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                    ))));
  }

  showImages(List<GetGalleryImages> imageList,int index){
    routes = MaterialPageRoute(builder: (context) => GrobizGalleryPhotoViewWrapper(galleryItems: imageList,baseUrl: baseUrl,initialIndex: index,));
    Navigator.push(context, routes).then(onGoBack);
  }
}
