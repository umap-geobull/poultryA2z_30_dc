import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/App_Apis.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:getwidget/getwidget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


typedef OnSaveCallback = void Function();

class CancelOrderBottomsheet extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String order_auto_id,product_order_auto_id,customer_auto_id, admin_auto_id, baseUrl;


  CancelOrderBottomsheet(this.onSaveCallback, this.order_auto_id,
      this.product_order_auto_id, this.customer_auto_id, this.admin_auto_id,this.baseUrl);

  @override
  _CancelOrderBottomsheet createState() => _CancelOrderBottomsheet(order_auto_id,
      product_order_auto_id, customer_auto_id, admin_auto_id, baseUrl);
}

class _CancelOrderBottomsheet extends State<CancelOrderBottomsheet> {

  String order_auto_id,product_order_auto_id,customer_auto_id, admin_auto_id, baseUrl;
  bool isApiCallProcessing=false;


  _CancelOrderBottomsheet(this.order_auto_id, this.product_order_auto_id,
      this.customer_auto_id, this.admin_auto_id, this.baseUrl);


  TextEditingController reasonController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                child:Container(
                  child: Stack(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: IconButton(
                                  onPressed: ()=>{
                                    onBackPressed()
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                              const Text(
                                'Cancel Order',style: TextStyle(color: Colors.black87,fontSize: 14),
                              ),
                            ],
                          ),

                          const Divider(
                            color: Colors.black54,
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.only(left: 20,right: 20,top: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text("Reason for cancel",
                                    style: TextStyle(color: Colors.black, fontSize: 14,fontWeight: FontWeight.bold)),
                                const SizedBox(height: 10,),
                                Container(
                                  child: Container(
                                    child: TextFormField(
                                      minLines: 8,
                                      maxLines: null,
                                      controller: reasonController,
                                      decoration: InputDecoration(
                                        //  filled: true,
                                        // fillColor: Colors.white,
                                          contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                          hintText: "Please enter reason",
                                          helperStyle: const TextStyle(color: Colors.grey,fontSize: 13),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                            const BorderSide(color: Colors.blue, width: 1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                            const BorderSide(color: Colors.grey, width: 1),
                                            borderRadius: BorderRadius.circular(8),
                                          )),
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            // margin: EdgeInsets.only(bottom: 100),
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: () {
                                canceOrderApi();
                               // Navigator.of(context).pop();
                              },
                              child: const Text("Confirm Cancel Order",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.orange[200],
                                onPrimary: Colors.orange,
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),

                      isApiCallProcessing==true?
                      Container(
                        height: 400,
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        child: const GFLoader(
                            type:GFLoaderType.circle
                        ),
                      ):
                      Container()

                    ],
                  ),
                )),
          )
      );
    }
    ),
        onWillPop: ()=>onBackPressed()
    );

  }

  onBackPressed() {
    Navigator.of(context).pop();
  }

  canceOrderApi() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }
    final body = {
      "customer_auto_id": customer_auto_id,
      "order_auto_id": order_auto_id,
      "product_order_auto_id": product_order_auto_id,
      "reason": reasonController.text,
      "admin_auto_id" : admin_auto_id,
    };

    print("user_id=>"+customer_auto_id);
    print("order_id=>"+order_auto_id);
    print("prod_order_id=>"+product_order_auto_id);
    print("reason=>"+reasonController.text);

    var url = baseUrl+'api/' + cancel_order;

    Uri uri=Uri.parse(url);

    final response = await http.post(uri, body: body);
    print(response.toString());
    if (response.statusCode == 200) {
      isApiCallProcessing=false;
      final resp = jsonDecode(response.body);
      int  status = resp['status'];
      print("status=>"+status.toString());
      if (status == 1) {
        widget.onSaveCallback();
        Fluttertoast.showToast(
          msg: 'Order has been cancelled successfully',
          backgroundColor: Colors.grey,
        );
      }
      else{
        String  msg = resp['msg'];
        Fluttertoast.showToast(
          msg: msg,
          backgroundColor: Colors.grey,
        );
      }

      if(mounted){
        setState(() {});
      }
    }
    else if (response.statusCode == 500) {
      isApiCallProcessing=false;
      Fluttertoast.showToast(
        msg: "Server error",
        backgroundColor: Colors.grey,
      );

      if(mounted){
        setState(() {});
      }
    }
  }

}

