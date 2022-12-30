import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';

class Add_Delivery_Token extends StatefulWidget
{
  @override
  _Add_Delivery_Token createState() => _Add_Delivery_Token();
}

class _Add_Delivery_Token extends State<Add_Delivery_Token>{
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
       title: const Text("Verify", style: TextStyle(color: appBarIconColor, fontSize: 18, fontWeight: FontWeight.bold)),
       leading: IconButton(
         onPressed: Navigator.of(context).pop,
         icon: const Icon(Icons.arrow_back, color: appBarIconColor),
       ),
     ),
       body: SingleChildScrollView(
           scrollDirection: Axis.vertical,
           child: Padding(
             padding: const EdgeInsets.all(20.0),
             child: Column(
               children: [
                 SizedBox(
                   height: 115,
                   width: 135,
                   child: Stack(
                     clipBehavior: Clip.none,
                     fit: StackFit.expand,
                     children: [
                       Image.asset("assets/shiprocket1.jpg"),
                     ],
                   ),
                 ),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [

                     const Text("Merchant Name",
                         style: TextStyle(color: Colors.black, fontSize: 16)),
                     const SizedBox(
                       height: 8,
                     ),
                     SizedBox(
                       height: 45,
                       child: SizedBox(
                         height: MediaQuery.of(context).size.height,
                         child: TextFormField(
                           decoration: InputDecoration(
                               filled: true,
                               hintText: "Enter the merchant name",
                               fillColor: Colors.white,
                               contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                               focusedBorder: OutlineInputBorder(
                                 borderSide:
                                 const BorderSide(color: Colors.blue, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderSide:
                                 const BorderSide(color: Colors.grey, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               )),
                           // style: AppTheme.form_field_text,

                           textInputAction: TextInputAction.newline,
                           keyboardType: TextInputType.text,
                           onChanged: (value) => {
                             setState(() {})
                           },
                         ),
                       ),
                     ),
                     const SizedBox(
                       height: 15,
                     ),
                     const Text("Token",
                         style: TextStyle(color: Colors.black, fontSize: 16)),
                     const SizedBox(
                       height: 8,
                     ),
                     SizedBox(
                       height: 45,
                       child: SizedBox(
                         height: MediaQuery.of(context).size.height,
                         child: TextFormField(
                           decoration: InputDecoration(
                               filled: true,
                               hintText: "Enter Token Key",
                               fillColor: Colors.white,
                               contentPadding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                               focusedBorder: OutlineInputBorder(
                                 borderSide:
                                 const BorderSide(color: Colors.blue, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderSide:
                                 const BorderSide(color: Colors.grey, width: 1),
                                 borderRadius: BorderRadius.circular(10),
                               )),
                           // style: AppTheme.form_field_text,
                           keyboardType: TextInputType.number,
                           onChanged: (value) => {

                             setState(() {})
                           },
                           minLines: null,
                           textAlignVertical: TextAlignVertical.top,
                           maxLines: null,
                           expands: true,
                         ),
                       ),
                     ),
                     const SizedBox(
                       height: 15,
                     ),
                     Container(
                         child: Padding(
                           padding: const EdgeInsets.all(30.0),
                           child: SizedBox(
                             height: 40,
                             child: ElevatedButton(
                               style: ElevatedButton.styleFrom(
                                   primary: kPrimaryColor,
                                   textStyle: const TextStyle(fontSize: 20)),
                               onPressed: () {
                               },
                               child: const Center(
                                 child: Text(
                                   'Save',
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: Colors.white,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         )
                     )
                   ],
                 ),
               ],
             ),
           ))
     );
  }
}
