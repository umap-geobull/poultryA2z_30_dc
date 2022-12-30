import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/settings/AddDeliveryTime/Component/delivery_time_model.dart';
import 'package:poultry_a2z/settings/AddDeliveryTime/Component/update_deliverytime_bottomsheet.dart';
import 'package:poultry_a2z/settings/AddExpressDelivery/Component/ExpressDelivery_Model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import '../../Admin_add_Product/constants.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/Rest_Apis.dart';

class Add_Delivery_Time extends StatefulWidget {
  const Add_Delivery_Time({Key? key}) : super(key: key);

  @override
  _Add_Delivery_Time createState() => _Add_Delivery_Time();
}

class _Add_Delivery_Time extends State<Add_Delivery_Time> {
  bool isApiCallProcessing = false;
  String baseUrl='';

  String user_id = '';
  String time = "-",id="",unit="Days";
  List<String> selected_charges_List = [];

  List<String> items = [
    'Minute',
    'Days',
    'Week',
    'Month'
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: kPrimaryColor,
            title: const Text("Delivery Time",
                style: TextStyle(color: Colors.white, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: const [
            ]),
        body: Stack(
            children :<Widget>[
              Container(
                margin: const EdgeInsets.all(10),
            height: 230,
            decoration: BoxDecoration(
            border: Border.all(color: Colors.orange)
                ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        height: 60,
                        child:const Text('Delivery Time',
                            style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            )),
                      ),
                      SizedBox(
                        height: 50,
                        child:Text(time+' '+unit,
                            style: const TextStyle(
                                color: Colors.black45,
                                fontSize: 15,
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                              height:40,
                              width: 120,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColor,
                                    textStyle: const TextStyle(fontSize: 20)),
                                onPressed: () {
                                  showAddDeliveryTime();
                                  //Update_Express_delivery_Layout();
                                },
                                child: const Center(
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )),

              isApiCallProcessing==true?
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: const GFLoader(
                    type:GFLoaderType.circle
                ),
              ):
              Container()
            ]
        ));
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');

    if (userId != null && baseUrl!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        getDeliveryTime();
      });
    }
    return null;
  }

  showAddDeliveryTime() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return AddDeliveryTime(onAddListener,time,id,unit);
        });
  }

  onAddListener(){
    Navigator.pop(context);
    getDeliveryTime();
  }

  void getDeliveryTime() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getDeliveryTime(baseUrl).then((value) {
      if (value != null) {
        DeliveryTimeModel deliveryTimeModel=value;

        if (deliveryTimeModel.status == 1) {
          if(this.mounted){
            setState(() {
              isApiCallProcessing = false;
              this.time=deliveryTimeModel.deliveryTimeDetails[0].time;
              this.unit=deliveryTimeModel.deliveryTimeDetails[0].unit;
              this.id=deliveryTimeModel.deliveryTimeDetails[0].id;
            });
          }
        }

      }
    });
  }

}
