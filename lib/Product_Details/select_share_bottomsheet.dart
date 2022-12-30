import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/grobiz_start_pages/create_dynamic_link.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_share/social_share.dart';

typedef OnSaveCallback = void Function(String productAutoId,String moq,String size);

class SelectSocialShare extends StatefulWidget {
  String productAutoId;
  File productImage;
  String image_url;
  String admin_auto_id;
  String productName;
  String productPrice;
  String finalPrice;
  String offerPrice;
  String appName;
  String currency;

  SelectSocialShare(this.productAutoId, this.productImage, this.image_url, this.admin_auto_id,
      this.productName, this.productPrice, this.finalPrice, this.offerPrice, this.appName, this.currency);

  @override
  _SelectSocialShare createState() => _SelectSocialShare();
}

class _SelectSocialShare extends State<SelectSocialShare> {

  TextEditingController _captionController = TextEditingController();

  final String FACEBOOK_APP_ID='1094746254578227';

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
        return Material(
            child: SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      /* decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10))
                    ),*/
                      child: Text('Share',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          )),
                    ),

                    SizedBox(
                      height: 100,
                      child: Image.file(widget.productImage),
                    ),

                    Divider(),

                    SizedBox(
                      height: 80,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: ()=>{
                                shareOnInstagram()
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                child: Image.asset('assets/instagram.png'),
                              ),
                            ),
                            SizedBox(width: 10,),
                            InkWell(
                              onTap: ()=>{
                                shareOnFacebook()
                              },
                              child: Container(
                                height: 80,
                                width: 80,
                                child: Image.asset('assets/facebook.png'),
                              ),
                            ),
                          ],
                        ),)
                      ,
                    ),
                    SizedBox(height: 50,),
                  ],
                ),
              ),
            )
        );
      }
      );
  }

  shareOnInstagram() async{
    String message='Check out this product from '+widget.appName+'\n';

    String price='';

    if(widget.offerPrice!=''){
      price='Original Price: '+widget.productPrice+', Get it for '+widget.currency
          +widget.finalPrice.toString()+'\nYou get '+widget.offerPrice+'% OFF\n';
    }
    else{
      price='Price: '+widget.currency+widget.finalPrice.toString()+'\n';
    }

    var dynamicLink = await ShareAppLink.createDynamicLinkProduct(widget.productAutoId, widget.admin_auto_id);

    String share_text= message+widget.productName+price+dynamicLink.toString();

    /*  FlutterSocialContentShare.share(
         type: ShareType.instagramWithImageUrl,
         quote: share_text,
         imageUrl: widget.image_url);*/

    SocialShare.shareInstagramStory(widget.productImage.path, attributionURL: dynamicLink.toString());
  }

  shareOnFacebook() async{

    var dynamicLink = await ShareAppLink.createDynamicLinkProduct(widget.productAutoId, widget.admin_auto_id);

    SocialShare.shareFacebookStory(
        widget.productImage.path,
        "#ffffff",
        "#000000",
        dynamicLink.toString(),
        appId: FACEBOOK_APP_ID);
  }

}

