
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddCurrency/Add_Currency.dart';
import 'package:poultry_a2z/settings/AddDeliveryTime/Add_delivery_time.dart';
import 'package:poultry_a2z/settings/AddSizeChart/SizeChartList.dart';
import 'package:poultry_a2z/settings/Add_Color/Add_Color_Screen.dart';
import 'package:poultry_a2z/settings/Add_Pincode/Add_Pincode_Screen.dart';
import 'package:poultry_a2z/settings/Add_Units/Add_Unit_Screen.dart';
import '../Home/styles/home_style.dart';
import 'AddExpressDelivery/Add_Express_delivery.dart';
import 'Add_Firmness/Add_Firmness_Screen.dart';
import 'Add_Manufacturer/Add_Manufacturer_Screen.dart';
import 'Add_Material/Add_Material_Screen.dart';
import 'Add_Size/Add_Size_Screen.dart';
import 'Select_Filter/Add_Filter_Screen.dart';

class MenuModel{
  String menu;
  Color color;

  MenuModel(this.menu, this.color);
}

class SettingScreen extends StatefulWidget {

  const SettingScreen({Key? key}) : super(key: key);
  static String routeName = "/settings";

  @override
  _SettingScreen createState() => _SettingScreen();
}

class _SettingScreen extends State<SettingScreen> {
  bool isApiCallProcessing=false;
  late Route routes;

  List<MenuModel> menuList=[
    MenuModel('Size', Colors.purple.shade100),
    MenuModel('Pincode', Colors.orangeAccent.shade100),
    MenuModel('Color', Colors.lightBlueAccent.shade100),
    MenuModel('SizeChart', Colors.lightGreenAccent.shade100),
  //  MenuModel('ExpressDelivery', Colors.yellowAccent.shade100),
    MenuModel('Currency', Colors.pinkAccent.shade100),
  //  MenuModel('Delivery Time', Colors.red.shade100),
    MenuModel('Units', Colors.blueAccent.shade100),
    MenuModel('Filter', Colors.green.shade100),
    MenuModel('Manufacturer', Colors.redAccent.shade100),
    MenuModel('Material', Colors.yellowAccent.shade100),
    MenuModel('Firmness', Colors.cyanAccent.shade100),
  ];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: appBarColor,
          title: const Text("Settings" ,style: TextStyle(color: appBarIconColor)),
        leading: IconButton(
          onPressed: ()=>{Navigator.of(context).pop()},
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      // drawer: Maindrawer(),
      body:Container(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
              childAspectRatio: 1/0.3,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5
        ),
          itemCount: menuList.length,
          itemBuilder: (context, index) =>
          GestureDetector(
            onTap: ()=>{
              showNextScreen(index)
            },
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:menuList[index].color ,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  menuList[index].menu,
                  style: const TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
                )
            ),
          )
          ,
        ),
      ), //  bottomNavigationBar: CustomBottomNavBar(selectedMenu: MenuState.home),
    );
  }

  showNextScreen(int i){
    if(i==0){
      routes = MaterialPageRoute(builder: (context) => const Add_Product_Size());
      Navigator.push(context, routes);
    }
    else  if(i==1){
      routes = MaterialPageRoute(builder: (context) => const Add_Pincode_Screen());
      Navigator.push(context, routes);
    }
    else  if(i==2){
      routes = MaterialPageRoute(builder: (context) => const Add_Color_Screen());
      Navigator.push(context, routes);
    }
    else  if(i==3){
      routes = MaterialPageRoute(builder: (context) => SizeChartList());
      Navigator.push(context, routes);
    }
    else  if(i==4){
      routes = MaterialPageRoute(builder: (context) => const Add_Currency());
      Navigator.push(context, routes);
    }
    else  if(i==5){
      routes = MaterialPageRoute(builder: (context) => const Add_Product_Unit());
      Navigator.push(context, routes);
    }
    else  if(i==6){
      routes = MaterialPageRoute(builder: (context) => const SelectFilter());
      Navigator.push(context, routes);
    }
    else  if(i==7){
      routes = MaterialPageRoute(builder: (context) => const Add_Manufacturer_Screen());
      Navigator.push(context, routes);
    }
    else  if(i==8){
      routes = MaterialPageRoute(builder: (context) => const Add_Material_Screen());
      Navigator.push(context, routes);
    }
    else  if(i==9){
      routes = MaterialPageRoute(builder: (context) => const Add_Firmness_Screen());
      Navigator.push(context, routes);
    }

   /* else  if(i==4){
      routes = MaterialPageRoute(builder: (context) => const Add_Express_Delivery());
      Navigator.push(context, routes);
    }*/
   /* else  if(i==6){
      routes = MaterialPageRoute(builder: (context) => const Add_Delivery_Time());
      Navigator.push(context, routes);
    }*/
  }
}
