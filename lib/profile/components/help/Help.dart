import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'about_us/Aboutus.dart';
import 'contact_us/ContactUs.dart';
import 'faq/FAQs.dart';
import 'privacy_policy/PrivacyPolicy.dart';
import 'terms_conditions/TermsAndConditions.dart';

class Help extends StatefulWidget {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;

  Help(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  @override
  State<Help> createState() => HelpState(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor);
}

class HelpState extends State<Help> {
  Color appBarColor=Colors.white,appBarIconColor=Colors.black,primaryButtonColor=Colors.orange,
      secondaryButtonColor=Colors.orangeAccent;


  HelpState(this.appBarColor, this.appBarIconColor, this.primaryButtonColor,
      this.secondaryButtonColor);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getappUi();
  }

  void getappUi() async {
    SharedPreferences prefs= await SharedPreferences.getInstance();
    String? appBarColor =prefs.getString('appbarColor');
    String? appbarIcon =prefs.getString('appbarIconColor');
    String? primaryButtonColor =prefs.getString('primaryButtonColor');
    String? secondaryButtonColor =prefs.getString('secondaryButtonColor');

    if(appBarColor!=null){
      this.appBarColor=Color(int.parse(appBarColor));
    }

    if(appbarIcon!=null){
      this.appBarIconColor=Color(int.parse(appbarIcon));
    }

    if(primaryButtonColor!=null){
      this.primaryButtonColor=Color(int.parse(primaryButtonColor));
    }

    if(secondaryButtonColor!=null){
      this.secondaryButtonColor=Color(int.parse(secondaryButtonColor));
    }

    if(this.mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text("Help", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(
          onPressed: Navigator.of(context).pop,
          icon: Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
            Container(
                height: 80,
                margin: const EdgeInsets.only(top: 20, left: 2, right: 2, bottom: 2),
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aboutus(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "   About Us",
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black45,
                          )
                        ],
                      )),
                )),
            Container(
                height: 80,
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FAQs(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "   FAQs",
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black45,
                          )
                        ],
                      )),
                )),
                Container(
                    height: 80,
                    margin: const EdgeInsets.all(2),
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TermsAndConditions(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)),
                        );
                      },
                      child: Card(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                              Text(
                                "   Terms And Conditions",
                                softWrap: true,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black45,
                              )
                            ],
                          )),
                    )),
            Container(
                height: 80,
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PrivacyPolicy(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "   Privacy Policy",
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black45,
                          )
                        ],
                      )),
                )),
            Container(
                height: 80,
                margin: const EdgeInsets.all(2),
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Contactus(appBarColor,appBarIconColor,primaryButtonColor,secondaryButtonColor)),
                    );
                  },
                  child: Card(
                      margin: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: const [
                          Text(
                            "   Contact Us",
                            softWrap: true,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black45,
                          )
                        ],
                      )),
                ))
          ])),
    );
  }
}
