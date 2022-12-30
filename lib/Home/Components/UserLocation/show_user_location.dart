
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Home/Components/UserLocation/select_pincode_bottomsheet.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Get_Pincode_List_Model.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Components/Rest_Apis.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserLocation extends StatefulWidget {
  UserLocation();

  @override
  _UserLocationState createState() => _UserLocationState();
}

class _UserLocationState extends State<UserLocation> {
  bool isApiCallProcessing=false;

  String baseUrl='';
  String user_pincode='', user_city='';
  double latitude=0.0,longitude=0.0;
  String user_id = '',admin_auto_id='';
  List<GetPincodeList> getpincode_List = [];

  bool isPincodeDeliveryAvailable=false;

  TextStyle locationTextstyle=TextStyle(color: Colors.black87,fontSize: 16,
      //fontWeight: FontWeight.bold
  );

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('user_id');
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (userId != null && baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.user_id=userId;
        this.admin_auto_id=adminId;
        getPin_Code_List();
      });
    }
    return null;
  }

  void getPincodeData() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? pincode =prefs.getString('user_pincode');
    double? latitude =prefs.getDouble('user_latitude');
    double? longitude =prefs.getDouble('user_longitude');
    String? user_city =prefs.getString('user_city');

    if(pincode!=null){
      this.user_pincode=pincode;
      print(user_pincode);

      bool isAvailable=false;
      for(int i=0; i<getpincode_List.length ; i++){
        if(getpincode_List[i].pincode == user_pincode){
          isAvailable=true;
        }
      }

      if(isAvailable==true){
        isPincodeDeliveryAvailable=true;
      }
      else{
        isPincodeDeliveryAvailable=false;
      }

      if(this.mounted){
        setState(() {});
      }

    }

    if(longitude!=null){
      this.longitude=longitude;
    }

    if(latitude!=null){
      this.latitude=latitude;
    }

    if(user_city!=null){
      this.user_city=user_city;
    }

    if(this.mounted){
      setState(() {
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>{showAddLocation()},
      child: Container(
          decoration: BoxDecoration(
            border: Border.symmetric(
              horizontal: BorderSide(color: Colors.grey.shade100,width: 1)
            ),
            color: Colors.white,
          ),

          padding: EdgeInsets.only(top: 5,bottom: 5,left: 10,right: 10),
          child:
          user_pincode.isEmpty?
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,color: appBarIconColor,
                        size: 20,
                      ),
                      Container(
                          child: Text('Select delivery location',style: locationTextstyle,)
                      )

                    ],
                  )),
              Expanded(
                  flex: 2,
                  child:Container(
                    alignment: Alignment.centerRight,
                    child:
                    Icon(
                      Icons.arrow_forward_ios_rounded,color: appBarIconColor,
                      size: 18,
                    ),
                  )),
            ],
          ) :
          isPincodeDeliveryAvailable==true?
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child:Row(
                    children: <Widget>[
                      Icon(
                        Icons.location_on_outlined,color: appBarIconColor,
                        size: 20,
                      ),
                      Container(
                          child: Text('  Deliver to: '+user_pincode,style: locationTextstyle,)
                      )

                    ],
                  )),
              Expanded(
                  flex: 2,
                  child:Container(
                    alignment: Alignment.centerRight,
                    child:
                    Icon(
                      Icons.arrow_forward_ios_rounded,color: appBarIconColor,
                      size: 18,
                    ),
                  )),
            ],
          ):
          Row(
            children: [
              Expanded(
                  flex: 6,
                  child:Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.error,color: Colors.red,
                        size: 17,
                      ),
                      SizedBox(width: 10,),
                      Flexible(
                          child:
                          Text('Currently services are unavaialble at pincode '+user_pincode+', will be happy to serve in future',
                            style: TextStyle(
                            color: Colors.black,fontSize: 12,
                          ),)
                      )

                    ],
                  )),
            ],
          ),

      ),
    );
  }

  showAddLocation() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SelectPincode(onAddlistener);
        });
  }

  onAddlistener(){
    Navigator.of(context).pop();
    getPincodeData();
  }

  void getPin_Code_List() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getPin_CodeList(user_id, admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        getpincode_List = value;

        getPincodeData();

        print('pincode length '+getpincode_List.length.toString());
        if(this.mounted){
          setState(() {
          });
        }
      }
    });
  }

}
