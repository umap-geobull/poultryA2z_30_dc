import 'package:flutter/material.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Components/product_unit_model.dart';
import 'Components/Rest_Apis.dart';
import 'package:getwidget/getwidget.dart';


class Add_Product_Unit extends StatefulWidget {
  const Add_Product_Unit({Key? key}) : super(key: key);

  @override
  _Add_Product_Unit createState() => _Add_Product_Unit();
}

class _Add_Product_Unit extends State<Add_Product_Unit> {
  List<GetUnitList> unitList = [];
  String user_id = "", size_name = "";
  bool isApiCallProcessing = false;
  String baseUrl='', admin_auto_id='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getBaseUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("Unit List",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  show_addUnit_Layout();
                },
                icon: const Icon(Icons.add_circle_outline, color:appBarIconColor),
              ),
            ]
        ),
        body:Stack(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child:
              GridView.builder(
                  physics: const ScrollPhysics(),
                  padding: const EdgeInsets.all(0),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    crossAxisCount: 5,
                  ),
                  itemCount: unitList.length,

                  itemBuilder: (context, index) =>

                      CategoryCard_( unitList[index].id, unitList[index].unit)
              ),
            ),

            isApiCallProcessing==false&& unitList.isEmpty?
            Center(child: Text('No units added'),):
            Container(),

            isApiCallProcessing==true?
            Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width,
              child: const GFLoader(
                  type:GFLoaderType.circle
              ),
            ):
            Container()],
        ));
  }

  Widget CategoryCard_( String sId, String unit) {
    return Padding(
        padding:  const EdgeInsets.all( 5.0),
        child: Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Colors.grey,
                width: 1.5),
          ),
          alignment: Alignment.center,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Text(
                        unit,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),

                ],
              ),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: const Icon(
                    Icons.close,
                    color: Colors.red,
                    size: 20,
                  ),
                  onTap: ()=>{
                    if(mounted)
                      {
                  setState(() =>{
                  showAlert(sId)

                  })
                      }

                  },
                ),
              ),
            ],
          ),
        )
    );
  }

  showAlert(String sId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          backgroundColor: Colors.yellow[50],
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: Colors.black87),
          ),
          content: Wrap(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    const Text(
                      'Do you want to delete unit',
                      style: TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Delete_Unit(sId);
                              },
                              child: const Text("Yes",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green[200],
                                onPrimary: Colors.green,
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: ElevatedButton(
                              onPressed: () => {Navigator.pop(context)},
                              child: const Text("No",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue[200],
                                onPrimary: Colors.blue,
                                minimumSize: const Size(70, 30),
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(2.0)),
                                ),
                              ),
                            )),
                      ],
                    )
                  ],
                ),
              )
            ],
          )),
    );
  }

  void Delete_Unit(String sId) {

    setState(() {
      isApiCallProcessing = true;
    });

    Rest_Apis restApis=Rest_Apis();

    restApis.Delete_Unit(sId, admin_auto_id, baseUrl).then((value){

      if(value!=null){


        int status =value;

        if(status == 1){
          isApiCallProcessing = false;
          Fluttertoast.showToast(msg: "Unit deleted successfully", backgroundColor: Colors.grey,);
          getUnitList();
        }
      }
    });

  }

  void getUnitList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getUnitList(admin_auto_id, baseUrl).then((value) {
      if (value != null) {
        isApiCallProcessing = false;
        unitList = value;

        print('size length '+unitList.length.toString());
        if(this.mounted){
          setState(() {
          });
        }
      }
    });
  }

  void show_addUnit_Layout() {
    showModalBottomSheet<void>(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: const EdgeInsets.all(10),
    child: Padding(
    padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Center(
                  child: Text('Add Unit',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold))),
              Divider(color: Colors.grey.shade300),
              const SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.top),
                child: TextField(
                  decoration: const InputDecoration(hintText: 'Enter unit'),
                  autofocus: true,
                  onChanged: (value) => {
                    setState(() {
                      size_name = value;
                    })
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          textStyle: const TextStyle(fontSize: 20)),
                      onPressed: () {
                        if(mounted)
                        {
                          setState(() {
                            if(size_name == "")
                            {
                              Fluttertoast.showToast(
                                msg: "Please enter the unit",
                                backgroundColor: Colors.grey,
                              );
                            }
                            else{
                              Navigator.pop(context);
                              add_Unit_List(size_name);
                              size_name = "";
                            }

                          } );
                        }
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
                  ))
            ],
          ),),
        ));
  }

  void add_Unit_List(String unitName) {
    setState(() {
      isApiCallProcessing = true;
    });

    Rest_Apis restApis=Rest_Apis();

    restApis.Add_Unit(unitName, admin_auto_id, baseUrl).then((value){

      if(value!=null){

        String status =value;

        if(status == "1"){
          Fluttertoast.showToast(msg: "Unit added successfully", backgroundColor: Colors.grey,);
          getUnitList();
        }

        isApiCallProcessing = false;
      }
    });
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        getUnitList();
      });
    }
    return null;
  }
}
