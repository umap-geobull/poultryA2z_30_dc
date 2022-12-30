
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../api/all_urls.dart';
import '../model/StickerModel.dart';
import 'package:http/http.dart' as http;

typedef AddStickerCallBack = void Function(String sticker);

class AddStickerBottomsheet extends StatefulWidget {
  AddStickerCallBack addStickerCallBack;


  AddStickerBottomsheet(this.addStickerCallBack);

  @override
  _AddStickerState createState() => _AddStickerState();
}

class _AddStickerState extends State<AddStickerBottomsheet> {

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  List<AllStickerImages> stickerCategories=[];

  bool isApiCallProcessing=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getStickers();

  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getStickers() async{
    if(this.mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }


    var url=BASE_URL+GET_STICKERS;

    var uri = Uri.parse(url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      if(this.mounted){
        setState(() {
          isApiCallProcessing=false;
        });
      }

      final resp=jsonDecode(response.body);
      // String message=resp['msg'];
      int status=resp['status'];
      if(status==1){
        StickerModel stickerModel=StickerModel.fromJson(json.decode(response.body));

        setState(() {
          stickerCategories=stickerModel.allStickerImages;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              child: Column(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).canvasColor,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(10),
                          topRight: const Radius.circular(10),
                        ),
                      ),
                      height: 350,
                      child:isApiCallProcessing==true?
                      Center(
                          child:  CircularProgressIndicator()
                      ):
                      stickerCategories!=null && stickerCategories.isNotEmpty?
                      DefaultTabController(
                          length: stickerCategories.length,
                          child:  Column(
                            children: <Widget>[
                              Container(
                                  height: 50,
                                  child: TabBar(
                                    tabs:stickerTabs(),
                                    isScrollable: true,
                                    indicatorColor: Colors.blue,
                                    indicatorWeight: 5,
                                  )
                              ),
                              Expanded(
                                child: Container(
                                    height: 300,
                                    child:  TabBarView(
                                        children: stickers()
                                    )
                                ),
                              )
                            ],
                          )
                      ):
                      Container(
                        height: 100,
                        child: Center(
                          child: Text('No stickers avaialble'),
                        ),
                      )
                  )

                ],
              )
              ,
            ),)
      );
    }
    );
  }

  List<Widget> stickerTabs(){
    List<Widget> tabs=[];

    for(int i=0;i<stickerCategories.length;i++){
      tabs.add(
          Container(
            height: 20,
            child: Text(stickerCategories[i].stickerCatName,style: TextStyle(color: Colors.black),),
          )
      ) ;
    }

    return tabs;
  }

  List<Widget> stickers(){
    double cellWidth = ((MediaQuery.of(context).size.width - 10) / 2);
    double desiredCellHeight = 70;
    double childAspectRatio = cellWidth / desiredCellHeight;

    double noticellWidth = ((MediaQuery.of(context).size.width - 10) / 3);
    double notidesiredCellHeight = 50;
    double notichildAspectRatio = noticellWidth / notidesiredCellHeight;

    bool reminderVisibility=false;
    bool timepickerVisibility=true;
    bool datepickerVisibility=false;

    int selectedPosition=0;
    String selected_image="";

    List<Widget> tabs=[];

    for(int i=0;i<stickerCategories.length;i++){
      List<Allimages> stickersList=stickerCategories[i].allimages;
      tabs.add(
          Container(
              height: 300,
              margin: EdgeInsets.all(10),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: stickersList.length,
// shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1/1),
                    crossAxisCount: 6,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2
                ),
                itemBuilder: (context,position){
                  return GestureDetector(
                    child:Container(
                      alignment: Alignment.center,
                      child:stickersList[position].stickerImg!=null && stickersList[position].stickerImg.isNotEmpty?
                      CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        errorWidget: (context, url, error ) => Icon(Icons.error),
                        //placeholder: (context, url) => Center(child:Container(height:30,width:30,child: CircularProgressIndicator(),)),
                       /* placeholder: (context, url) =>
                            Container(decoration: BoxDecoration(
                              color: Colors.grey[400],
                            )),*/
                        imageUrl:STICKER_IMAGE_BASE_URL+stickersList[position].stickerImg,
                        fit: BoxFit.fill,):
                      Container(),
                    ),
                    onTap: ()=> {
                      widget.addStickerCallBack(STICKER_IMAGE_BASE_URL+stickersList[position].stickerImg)
                    },
                  );
                },
              )
          )
      ) ;
    }

    return tabs;
  }

}
