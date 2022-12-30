import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:poultry_a2z/InAppReview/app_review.dart';
import 'package:poultry_a2z/Utils/AppConfig.dart';
import 'package:http/http.dart' as http;
import 'package:linkify/linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../Utils/App_Apis.dart';
import '../InAppVideoPlayer.dart';
import 'FAQModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';

class FAQs extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  FAQs(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);


  @override
  State<FAQs> createState() => FAQsState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);
}

class FAQsState extends State<FAQs> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  FAQsState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  late String faqdata='', faq_id='';
  late FAQModel faqModel;
  bool isloading=false;
  String user_id='';
  String user_type='';
  String baseUrl='';

  late YoutubePlayerController _controller;
  late TextEditingController _idController;
  late TextEditingController _seekToController;

  bool _isPlayerReady = false;
  String videolink='https://www.youtube.com/watch?v=Sq5Fo9gm90A';
  late PlayerState _playerState;
  late YoutubeMetaData _videoMetaData;

  @override
  void initState() {
    super.initState();
    getFaq();
    final videoId=YoutubePlayer.convertUrlToId(videolink);
    print(videoId);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        showLiveFullscreenButton: false,
          hideControls: true

      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
  }

  getFaq() async {
    if(mounted){
      setState(() {
        isloading=true;
      });
    }

    var url =AppConfig.grobizBaseUrl + showFaqs;

    Uri uri=Uri.parse(url);

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      isloading=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      //print("response=>"+resp.toString());
      if (status == 1) {
        faqModel = FAQModel.fromJson(json.decode(response.body));
        var mainList = faqModel.allfaqs;
        if(mounted){
          setState(() {
            faq_id=mainList[0].id;
            faqdata = mainList[0].faq;
            //linkify(faqdata);
            isloading=false;
          });
        }
      }
      else {
        if(mounted){
          setState(() {
            faq_id='';
            faqdata = 'No Data Available';
            isloading=false;
          });
        }
      }

      if(mounted){
        setState(() {});
      }
    }
    else if(response.statusCode==500){
      if(mounted){
        setState(() {
          isloading=false;
          Fluttertoast.showToast(
            msg: 'Server error',
            backgroundColor: Colors.grey,
          );
        });
      }
    }
  }


Future<void> showAlert(BuildContext context) async{
  return await showDialog(
    context: context,
    builder: (context) => new AlertDialog(
        content:
            GestureDetector(
              onTap: openUrl,
              child:
              Wrap(
                children: <Widget>[
                  // Row(
                  //   //height: 30,
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children:[
                  //     IconButton(
                  //       onPressed: (){
                  //         Navigator.pop(context);
                  //       },
                  //       icon: Icon(Icons.cancel_outlined, color: appBarIconColor),
                  //     )],),
                  Container(
                    height: 400,
                    child:  YoutubePlayerBuilder(
                      onExitFullScreen: () {
                        // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
                      },
                      player: YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: Colors.blueAccent,
                        topActions: <Widget>[
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              _controller.metadata.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              //log('Settings Tapped!');
                            },
                          ),
                        ],
                        onReady: () {
                          _isPlayerReady = true;
                        },
                        onEnded: (data) {
                          _controller.pause();
                        },
                      ),
                      builder: (context, player) =>
                          Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child:
                            player,
                          ),

                    ),
                  )
                ],
              )
            )
        ),
    );
}

  openUrl() async {
    final url = videolink;
    if (await canLaunch(url)) {
      await launch(
        url,
      );
    }
  }

  void listener() {
    if (_isPlayerReady && mounted) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    _idController.dispose();
    _seekToController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: appBarColor,
          title: Text("FAQ", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: Icon(Icons.arrow_back, color: appBarIconColor),
          ),
          actions: [

          ],
        ),
        body:Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      margin:
                      const EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 5),
                      child:
                      Html(
                          data:faqdata,
                        onLinkTap:(String? url, RenderContext context, Map<String, String> attributes, element){
                          _onOpen(url!);
                        } ,
                      )
                      // HtmlWidget(faqdata),
                    // Center(
                    //   child: SelectableLinkify(
                    //     onOpen: _onOpen,
                    //    // textScaleFactor: 5,
                    //     text: faqdata,
                    //
                    //   ),
                    // ),
                    //   Linkify(
                    //     onOpen: _onOpen,
                    //     text: faqdata,
                    //     strutStyle: StrutStyle(debugLabel: faqdata),
                    //     style:
                    //   TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                    //   )
                  )
                ],
              ),
            ),

            isloading==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()
          ],
        ));
  }
  Future<void> _onOpen(String link) async {
    print(videolink);

    if(mounted) {
      setState(() {
        videolink=link;
      });
    }
    final videoId=YoutubePlayer.convertUrlToId(videolink);
    //print(videoId);
    _controller = YoutubePlayerController(
      initialVideoId: videoId!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
          showLiveFullscreenButton: false,
        hideControls: true
      ),
    )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    _videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    showAlert(context);
  }

}
