
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/PicEditor/utils/colors.dart';
import 'package:poultry_a2z/PicEditor/utils/images.dart';
import 'package:poultry_a2z/PicEditor/utils/styling.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import 'EditGreetingsScreen.dart';
import 'GreetingDetailsModel.dart';
import 'api/all_urls.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class SelectImageScreen extends StatefulWidget{

  String id='';
  String name='';
  String type='';


  SelectImageScreen(this.type,this.id, this.name);


  @override
  _SelectImageScreenState createState() => _SelectImageScreenState(type,id,name);

}

class _SelectImageScreenState extends State<SelectImageScreen>{
  String id='';
  String name='';
  String type='';

  List<GeneralGreetingImages> greetingImagesList=[];

 // List<Uint8List> thumbnailList=[];

  _SelectImageScreenState(this.type,this.id, this.name);

  bool isApiCallProcess=false;

  bool isPostAvailable=false;

 // List<FestivalDetails> _selectedImage=[];

  List<String> _selectedImage=[];

  String base_url='';
  int selectedGreetingPosition=0;

  bool isVideoAvailable=false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    secureScreen();
    if(type=='Greetings'){
      base_url=GREETING_IMAGES_BASE_URL;
      getGreetingDetails();
    }

  }
  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()=>_onBackPressed(),
      child: new Scaffold(
          body:SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/home_bg.png"),
                      fit: BoxFit.fill
                  )
              ),
              child: Column(
                children: <Widget> [
                  Expanded(
                    flex: 1,
                    child: showHeader(),
                  ),
                  Expanded(
                    flex: 10,
                    child:ShowMain(),
                  ),
                ],
              ),
            ),
          )
      ),
    );

  }

  Widget showHeader() {
    return  Container(
      height: 70,
      padding: EdgeInsets.all(10),
      child:Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 20,
                      width: 20,
                      child: Image.asset('assets/backpress.png'),
                    )
                ),
                onTap: ()=> _onBackPressed(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(name,style: AppTheme.appbar_title,)
              ),
            ),
            Expanded(
              flex: 1,
              child: isPostAvailable?
              GestureDetector(
                child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      alignment: Alignment.center,
                      height: 33,
                      width: 90,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight:Radius.circular(20.0),bottomRight: Radius.circular(20.0),bottomLeft: Radius.circular(20.0)),
                      ),
                      child: Text("Next",style: AppTheme.small_button_text_style,),
                    )
                ),
                onTap: ()=> {
                  onNextPressed()
                },
              ):
              Container(),
            )
          ],
        ),
      ),
    );

  }

  Widget ShowMain() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      child: Column(
        children: <Widget>[

          showSelectedImage(),

          SizedBox(height: 10,),

          Expanded(
            flex:1,
              child:
              // child: type=='Festival'?
              // showFestivalImages():
              // type=='Category'?
              // showCategoryImages():
              type=='Greetings'?
              showGreetingImages():
              // type=='Video'?
              // showVideoImages():
              // type=='UpcomingVideo'?
              // showFestivalVideoImages():
              Container())
        ],
      ),

    );
  }

  // Widget showVideo(){
  //   return Container(
  //       height: MediaQuery.of(context).size.width,
  //       width: MediaQuery.of(context).size.width,
  //       color: Colors.grey[300],
  //       child:
  //       isVideoAvailable?
  //       VideoPlayer(_video_controller):
  //           Center(
  //             child: CircularProgressIndicator(),
  //           )
  //   );
  // }
  //
  // void setVideo(){
  //
  // print('video: '+_selectedVideo[0]);
  //
  //  if( _selectedVideo!=null && _selectedVideo.isNotEmpty){
  //    if(isVideoAvailable==true){
  //      _video_controller.dispose();
  //      isVideoAvailable=false;
  //    }
  //
  //    _video_controller = VideoPlayerController.network(base_url+_selectedVideo[0])
  //      ..initialize().then((_) {
  //        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //        setState(() {
  //          isVideoAvailable=true;
  //        });
  //      });
  //
  //    _video_controller.play();
  //  }
  // }

  Widget showSelectedImage() {
    return  Container(
      child: Container(
          height: MediaQuery.of(context).size.width,
          width: MediaQuery.of(context).size.width,
          child: _selectedImage!=null && _selectedImage.isNotEmpty?
          CachedNetworkImage(fit:BoxFit.fill,imageUrl: base_url + _selectedImage[0]):
          //Image.network(base_url + _selectedImage[0], fit: BoxFit.fill,):
          Container()
      ),
    );

  }

  // Widget showFestivalImages() {
  //   if(isApiCallProcess){
  //     return Container(
  //       alignment: Alignment.center,
  //       width: MediaQuery.of(context).size.width,
  //       height: 100,
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  //   else {
  //     if(festivalImagesList!=null && festivalImagesList.length>0){
  //       return GridView.builder(
  //           itemCount: festivalImagesList.length,
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               childAspectRatio: (1 / 1),
  //               crossAxisCount: 4),
  //           itemBuilder: (context, position) {
  //             return Container(
  //               child: GestureDetector(
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: _selectedImage[0]==festivalImagesList[position].festivalImg ? Colors.green: Colors.transparent,
  //                       width: _selectedImage[0]==festivalImagesList[position].festivalImg ? 2: 0,
  //                     ),
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   margin: EdgeInsets.all(3),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.circular(10.0),
  //                     child: CachedNetworkImage(
  //                       //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
  //                       placeholder: (context, url) =>
  //                           Container(decoration: BoxDecoration(
  //                             color: Colors.grey[400],
  //                           )
  //                           ),
  //                       imageUrl:base_url +
  //                           festivalImagesList[position].festivalImg,
  //                       fit: BoxFit.fill,),
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   _selectedImage.clear();
  //
  //                   setState(() {
  //                     _selectedImage.add(festivalImagesList[position].festivalImg);
  //                   });
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //     }
  //     else{
  //       return Container(
  //         alignment: Alignment.center,
  //         width: MediaQuery.of(context).size.width,
  //         height: 200,
  //         child: Text('No posts available',style:AppTheme.no_data_text_style,),
  //       );
  //     }
  //   }
  // }

  // Widget showCategoryImages() {
  //   if(isApiCallProcess){
  //     return Container(
  //       alignment: Alignment.center,
  //       width: MediaQuery.of(context).size.width,
  //       height: 100,
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  //   else {
  //     if(categoryImagesList!=null && categoryImagesList.length>0){
  //       return GridView.builder(
  //           itemCount: categoryImagesList.length,
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //               childAspectRatio: (1 / 1),
  //               crossAxisCount: 4),
  //           itemBuilder: (context, position) {
  //             return Container(
  //               child: GestureDetector(
  //                 child: Container(
  //                   decoration: BoxDecoration(
  //                     border: Border.all(
  //                       color: _selectedImage[0]==categoryImagesList[position].categoryImg ? Colors.green: Colors.transparent,
  //                       width: _selectedImage[0]==categoryImagesList[position].categoryImg ? 2: 0,
  //                     ),
  //                     borderRadius: BorderRadius.circular(12.0),
  //                   ),
  //                   margin: EdgeInsets.all(3),
  //                   child: ClipRRect(
  //                     borderRadius: BorderRadius.all(Radius.circular(10.0)),
  //                     child: CachedNetworkImage(
  //                       //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
  //                       placeholder: (context, url) =>
  //                           Container(decoration: BoxDecoration(
  //                             color: Colors.grey[400],
  //                           )),
  //                       imageUrl:SPECIAL_CATEGORIES_IMAGES_BASE_URL+categoryImagesList[position].categoryImg,
  //                       fit: BoxFit.fill,),
  //                   ),
  //                 ),
  //                 onTap: () {
  //                   _selectedImage.clear();
  //
  //                   setState(() {
  //                     _selectedImage.add(categoryImagesList[position].categoryImg);
  //                   });
  //                 },
  //               ),
  //             );
  //           },
  //         );
  //     }
  //     else{
  //       return Container(
  //         alignment: Alignment.center,
  //         width: MediaQuery.of(context).size.width,
  //         height: 200,
  //         child: Text('No posts available',style:AppTheme.no_data_text_style,),
  //       );
  //     }
  //   }
  // }

  Widget showGreetingImages() {
    if(isApiCallProcess){
      return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: CircularProgressIndicator(),
      );
    }
    else {
      if(greetingImagesList!=null && greetingImagesList.length>0){
        return GridView.builder(
            itemCount: greetingImagesList.length,
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (1 / 1),
                crossAxisCount: 4),
            itemBuilder: (context, position) {
              return Container(
                child: GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedImage[0]==greetingImagesList[position].greetingImg ? Colors.green: Colors.transparent,
                        width: _selectedImage[0]==greetingImagesList[position].greetingImg ? 2: 0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    margin: EdgeInsets.all(3),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      child: CachedNetworkImage(
                        //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                        placeholder: (context, url) =>
                            Container(decoration: BoxDecoration(
                              color: Colors.grey[400],
                            )),
                        imageUrl:GREETING_IMAGES_BASE_URL+greetingImagesList[position].greetingImg,
                        fit: BoxFit.fill,),
                    ),
                  ),
                  onTap: () {
                    _selectedImage.clear();

                    setState(() {
                      _selectedImage.add(greetingImagesList[position].greetingImg);
                      selectedGreetingPosition=position;
                    });
                  },
                ),
              );
            },
          );
      }
      else{
        return Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: Text('No posts available',style:AppTheme.no_data_text_style,),
        );
      }
    }
  }

//   Widget showVideoImages() {
//     if(isApiCallProcess){
//       return Container(
//         alignment: Alignment.center,
//         width: MediaQuery.of(context).size.width,
//         height: 100,
//         child: CircularProgressIndicator(),
//       );
//     }
//     else {
//       if(videoList!=null && videoList.length>0){
//         return GridView.builder(
//             itemCount: videoList.length,
//             shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: (1 / 1),
//                 crossAxisCount: 4),
//             itemBuilder: (context, position) {
//               return Container(
//                 child: GestureDetector(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: selected_video_position==position ? Colors.green: Colors.transparent,
//                         width: selected_video_position==position ? 2: 0,
//                         //color: _selectedVideo[0]==videoList[position].videofile ? Colors.green: Colors.transparent,
//                         //width: _selectedVideo[0]==videoList[position].videofile ? 2: 0,
//                       ),
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     margin: EdgeInsets.all(3),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         child: CachedNetworkImage(
//                           //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
//                           placeholder: (context, url) =>
//                               Container(decoration: BoxDecoration(
//                                 color: Colors.grey[400],
//                               )),
//                           imageUrl:VIDEO_THUMBNAIL_BASE_URL+videoList[position].thumbnailImg,
//                           fit: BoxFit.fill,),
//                       )
//                    /* child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         child: thumbnailList.isNotEmpty && thumbnailList.length>=position+1 && thumbnailList[position]!=null?
//                         Image.memory(thumbnailList[position]):
//                         Container(
//                           color: Colors.grey[300],
//                         )
//
//
// *//*
//                         Container(
//                           child: Shimmer.fromColors(
//                             enabled: true,
//                             baseColor: Colors.black38,
//                             highlightColor: Colors.black12,
//                             child: Container(),
//                           ),
//                           //color: Colors.grey[300],
//                         )
// *//*
// *//*
//                             CachedNetworkImage(
//                               //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
//                               placeholder: (context, url) =>
//                                   Container(decoration: BoxDecoration(
//                                     color: Colors.grey[400],
//                                   )),
//                               imageUrl:VIDEO_FILE_BASE_URL+videoList[position].videofile,
//                               fit: BoxFit.fill,),
// *//*
//                     ),*/
//                   ),
//                   onTap: ()=> {
//                     changeVideo(position)
//                   },
//                 ),
//               );
//             },
//           );
//       }
//       else{
//         return Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           height: 200,
//           child: Text('No posts available',style:AppTheme.no_data_text_style,),
//         );
//       }
//     }
//   }
//
//   Widget showFestivalVideoImages() {
//     if(isApiCallProcess){
//       return Container(
//         alignment: Alignment.center,
//         width: MediaQuery.of(context).size.width,
//         height: 100,
//         child: CircularProgressIndicator(),
//       );
//     }
//     else {
//       if(festivalVideoList!=null && festivalVideoList.length>0){
//         return GridView.builder(
//             itemCount: festivalVideoList.length,
//             shrinkWrap: true,
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 childAspectRatio: (1 / 1),
//                 crossAxisCount: 4),
//             itemBuilder: (context, position) {
//               return Container(
//                 child: GestureDetector(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: selected_video_position==position ? Colors.green: Colors.transparent,
//                         width: selected_video_position==position? 2: 0,
//                       /*  color: _selectedVideo[0]==videoList[position].videofile ? Colors.green: Colors.transparent,
//                         width: _selectedVideo[0]==videoList[position].videofile ? 2: 0,*/
//                       ),
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     margin: EdgeInsets.all(3),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       child: CachedNetworkImage(
//                         //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
//                         placeholder: (context, url) =>
//                             Container(decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                             )),
//                         imageUrl:FESTIVAL_VIDEO_THUMBNAI_BASE_URL+festivalVideoList[position].thumbnailImg,
//                         fit: BoxFit.fill,),
//                     ),
//
//                     /* child: ClipRRect(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                         child: thumbnailList.isNotEmpty && thumbnailList.length>=position+1 && thumbnailList[position]!=null?
//                         Image.memory(thumbnailList[position]):
//                       *//*  SizedBox(
//                           height: MediaQuery.of(context).size.height,
//                           width: MediaQuery.of(context).size.width,
//                           child: Shimmer.fromColors(
//                             baseColor: Colors.black38,
//                             highlightColor: Colors.black12,
//                             child: Container(),
//                           ),
//                           //color: Colors.grey[300],
//                         )*//*
//                         Container(
//                           color: Colors.grey[300],
//                         )
// *//*
//                             CachedNetworkImage(
//                               //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
//                               placeholder: (context, url) =>
//                                   Container(decoration: BoxDecoration(
//                                     color: Colors.grey[400],
//                                   )),
//                               imageUrl:VIDEO_FILE_BASE_URL+videoList[position].videofile,
//                               fit: BoxFit.fill,),
// *//*
//                     ),*/
//                   ),
//                   onTap: () =>{
//
//                    /* if(_selectedVideo.isEmpty){
//                       setState(() {
//                         _selectedVideo.add(videoList[position].videofile);
//                       })
//                     }*/
//                     changeVideo(position)
//                   },
//                 ),
//               );
//             },
//           );
//       }
//       else{
//         return Container(
//           alignment: Alignment.center,
//           width: MediaQuery.of(context).size.width,
//           height: 200,
//           child: Text('No posts available',style:AppTheme.no_data_text_style,),
//         );
//       }
//     }
//   }
//
//   void changeVideo(int position){
//   if(type=='Video'){
//     _selectedVideo.clear();
//
//     setState(() {
//       _selectedVideo.add(videoList[position].videofile);
//       selected_video_position=position;
//       setVideo();
//
//     });
//   }
//   else if(type=='UpcomingVideo'){
//     _selectedVideo.clear();
//
//     setState(() {
//       _selectedVideo.add(festivalVideoList[position].videofile);
//       selected_video_position=position;
//       setVideo();
//     });
//   }
//
//   }
//
  _onBackPressed() async{
    // if(isVideoAvailable==true){
    //   _video_controller.dispose();
    // }
    Navigator.pop(context);

  }

  //get festival images

  // Future getFestivalDetails() async{
  //   setState(() {
  //     isApiCallProcess=true;
  //   });
  //
  //   final body = {
  //     "festival_id": id,
  //   };
  //
  //   var url=BASE_URL+GET_FESTIVAL_DETAILS;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.post(uri,body:body);
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isApiCallProcess=false;
  //     });
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //     int status=resp['status'];
  //     if(status==1){
  //       setState(() {
  //         FestivalImagesModel festivalImagesModel=FestivalImagesModel.fromJson(json.decode(response.body));
  //
  //         festivalImagesList=festivalImagesModel.festivalDetails;
  //
  //         if(festivalImagesList!=null && festivalImagesList.isNotEmpty){
  //           setState(() {
  //             isPostAvailable=true;
  //           });
  //
  //           if(_selectedImage.isEmpty){
  //             setState(() {
  //               _selectedImage.add(festivalImagesList[0].festivalImg);
  //             });
  //           }
  //         }
  //         print(name);
  //       });
  //     }
  //   }
  // }

  //get category images
  // Future getCategoryDetails() async{
  //   setState(() {
  //     isApiCallProcess=true;
  //   });
  //
  //   final body = {
  //     "category_id": id,
  //   };
  //
  //   var url=BASE_URL+GET_CATEGORY_DETAILS;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.post(uri,body:body);
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isApiCallProcess=false;
  //     });
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //     int status=resp['status'];
  //     if(status==1){
  //       setState(() {
  //         CategoriesImageModel categoriesImageModel=CategoriesImageModel.fromJson(json.decode(response.body));
  //
  //         categoryImagesList=categoriesImageModel.categoryDetails;
  //
  //         if(categoryImagesList!=null && categoryImagesList.isNotEmpty){
  //           setState(() {
  //             isPostAvailable=true;
  //           });
  //
  //           if(_selectedImage.isEmpty){
  //             setState(() {
  //               _selectedImage.add(categoryImagesList[0].categoryImg);
  //             });
  //           }
  //         }
  //         print(name);
  //       });
  //     }
  //   }
  // }

  //get greeting images
  Future getGreetingDetails() async{
    setState(() {
      isApiCallProcess=true;
    });

    final body = {
      "greeting_id": id,
    };

    var url=BASE_URL+GET_GREETING_IMAGES;

    var uri = Uri.parse(url);

    final response = await http.post(uri,body:body);

    if (response.statusCode == 200) {
      setState(() {
        isApiCallProcess=false;
      });

      final resp=jsonDecode(response.body);
      // String message=resp['msg'];
      int status=resp['status'];
      if(status==1){
        setState(() {
          GreetingsDetailsModel greetingsDetailsModel=GreetingsDetailsModel.fromJson(json.decode(response.body));

          greetingImagesList=greetingsDetailsModel.genetalGreetingImages;

          if(greetingImagesList!=null && greetingImagesList.isNotEmpty){
            setState(() {
              isPostAvailable=true;
            });

            if(_selectedImage.isEmpty){
              setState(() {
                _selectedImage.add(greetingImagesList[0].greetingImg);
                selectedGreetingPosition=0;
              });
            }
          }
          print(name);
        });
      }
    }
  }

  //get videos
  // Future getVideoDetails() async{
  //   setState(() {
  //     isApiCallProcess=true;
  //   });
  //
  //   final body = {
  //     "video_id": id,
  //   };
  //
  //   var url=BASE_URL+GET_VIDEO_CATEGORY_DETAILS;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.post(uri,body:body);
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isApiCallProcess=false;
  //     });
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //
  //     print('video response : '+response.toString());
  //
  //     int status=resp['status'];
  //     if(status==1){
  //       setState(() {
  //         VideoDetailsModel videoDetailsModel=VideoDetailsModel.fromJson(json.decode(response.body));
  //
  //         videoList=videoDetailsModel.videoDetails;
  //
  //         if(videoList!=null && videoList.isNotEmpty){
  //           setState(() {
  //             isPostAvailable=true;
  //           });
  //
  //           if(_selectedVideo.isEmpty){
  //             setState(() {
  //               _selectedVideo.add(videoList[0].videofile);
  //               selected_video_position=0;
  //               setVideo();
  //             });
  //           }
  //         }
  //         print(name);
  //       });
  //     }
  //   }
  // }

  //get upcoming festival videos
  // Future getFestivalVideoDetails() async{
  //   setState(() {
  //     isApiCallProcess=true;
  //   });
  //
  //   final body = {
  //     "video_id": id,
  //   };
  //
  //   var url=BASE_URL+GET_UPCOMING_FESTIVALS_VIDEO_IMAGES;
  //
  //   var uri = Uri.parse(url);
  //
  //   final response = await http.post(uri,body:body);
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       isApiCallProcess=false;
  //     });
  //
  //     final resp=jsonDecode(response.body);
  //     // String message=resp['msg'];
  //     int status=resp['status'];
  //     if(status==1){
  //       setState(() {
  //         UpcomingFestivalVideoDetails upcomingFestivalVideoDetails=UpcomingFestivalVideoDetails.fromJson(json.decode(response.body));
  //
  //         festivalVideoList=upcomingFestivalVideoDetails.multipleVideoDetails;
  //
  //         if(festivalVideoList!=null && festivalVideoList.isNotEmpty){
  //
  //           setState(() {
  //             isPostAvailable=true;
  //           });
  //
  //           if(_selectedVideo.isEmpty){
  //             setState(() {
  //               _selectedVideo.add(festivalVideoList[0].videofile);
  //               selected_video_position=0;
  //               setVideo();
  //             });
  //           }
  //
  //         }
  //         print(name);
  //       });
  //     }
  //   }
  // }

  onNextPressed() {

    // if(type=='Video' || type=='UpcomingVideo'){
    //   if(isVideoAvailable){
    //     _video_controller.dispose();
    //   }
    //   Navigator.push(context,  MaterialPageRoute(builder: (context) => EditVideoScreen(base_url+_selectedVideo[0])));
    // }
     if(type=='Greetings'){
      Navigator.push(context,  MaterialPageRoute(builder: (context) => EditGreetingsScreen(double.parse(greetingImagesList[selectedGreetingPosition].xCordinate),double.parse(greetingImagesList[selectedGreetingPosition].yCordinate),base_url+_selectedImage[0])));
    }

  }

}