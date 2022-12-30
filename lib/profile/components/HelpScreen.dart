
import 'package:flutter/material.dart';




class HelpScreen extends StatefulWidget{

  @override
  _HelpScreenState createState() => _HelpScreenState();

}

class _HelpScreenState extends State<HelpScreen>{

  String email='',mobile='';
  bool isApiProcessing=false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>_onBackPressed(),
      child: Scaffold(
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: <Widget> [
                Expanded(
                  flex:2,
                  child: showHeader(),
                ),
                Expanded(
                  flex:9,
                  child: ShowMain(),
                )
              ],
            ),
          ),
        ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getHelp();
  }

  void getHelp() {
    mobile = '+911111111111';
    email = 'test@gmail.com';
  }




  Widget showHeader() {
    return  Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      child:Container(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    height: 40,
                    width: 40,
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.arrow_back),
                  ),
                  onTap: ()=> _onBackPressed(),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text('help & Support',style: TextStyle(fontSize: 16),)
              ),
            ),
          ],
        ),
      ),
    );

  }

  Widget ShowMain() {
    if(!isApiProcessing) {
      return Container(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  const Text('Contact us if you have any queries or complaints',
                    style: TextStyle(color: Colors.black,
                        fontSize: 16,

                        fontFamily: 'Lato'),),

                  const SizedBox(height: 50,),

                  mobile != '' ?
                  Row(
                    children: <Widget>[
                      const Icon(Icons.call, color: Colors.blue,),
                      const SizedBox(width: 16,),
                      Text(mobile,
                        style: const TextStyle(color: Colors.blue,
                            fontSize: 16,

                            fontFamily: 'Lato'),
                      )
                    ],
                  ) :
                  Container(),
                  const SizedBox(height: 20,),

                  email != '' ?
                  Row(
                    children: <Widget>[
                      const Icon(Icons.email_outlined, color: Colors.blue,),
                      const SizedBox(width: 20,),
                      Text(email,
                        style: const TextStyle(decoration: TextDecoration.underline,
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Lato'),
                      )
                    ],
                  ) :
                  Container()


                ],
              ),
            ),
          )
      );
    }
    else{
      return  Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: const CircularProgressIndicator(),
      );
    }
  }

  _onBackPressed() async{
    Navigator.pop(context);
  }
}