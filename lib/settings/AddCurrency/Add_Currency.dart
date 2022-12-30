import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/add_currency_bottomsheet.dart';
import 'package:poultry_a2z/settings/AddCurrency/Component/currency_list_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:getwidget/getwidget.dart';
import 'Component/Rest_Apis.dart';

class Add_Currency extends StatefulWidget {
  const Add_Currency({Key? key}) : super(key: key);

  @override
  _Add_Currency createState() => _Add_Currency();
}

class _Add_Currency extends State<Add_Currency> {
  List<GetCurrencyList> currencyList = [];
  // List<ExpressDelivery>? selectedcharges_List = [];
  bool isApiCallProcessing = false;
  String baseUrl='', admin_auto_id='';

  String country_name='', country_code='',country_currency='', flag_image='';
  List<String> selected_currency_List = [];

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
            title: const Text("Currency List",
                style: TextStyle(color: appBarIconColor, fontSize: 16)),
            leading: IconButton(
              onPressed: ()=>{Navigator.of(context).pop()},
              icon: const Icon(Icons.arrow_back, color: appBarIconColor),
            ),
            actions: [
              IconButton(
                onPressed: ()=> {
                  showAddCurrency()
              },
                icon: Icon(Icons.add_circle_outline, color: appBarIconColor),
              ),
            ]),
        body: Stack(
            children :<Widget>[
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                          itemCount: currencyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            // return item
                            return Currency_List_Layout(
                              currencyList[index].currency,
                              currencyList[index].countryCode,
                              currencyList[index].countryName,
                              currencyList[index].isSelected,
                              index,
                            );
                          }),
                    )
                  ],
                ),
              ),

              Container(
                height: MediaQuery.of(context).size.height,
                alignment: Alignment.bottomCenter,
                child:               selected_currency_List.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height:40,
                        width: 120,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: kPrimaryColor,
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            showAlert(selected_currency_List);
                          },
                          child: Text(
                            "Delete (${selected_currency_List.length})",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                    : Container(),
              ),

              isApiCallProcessing==false&& currencyList.isEmpty?
              Center(child: Text('No currency added'),):
              Container(),

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

  Future<bool> showAlert(List<String> selectedList) async {
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
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
                          'Do you want to delete currency',
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
                                    Delete_Pin_Code(selectedList);
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

  void Delete_Pin_Code(List<String> selectedList) {
    for(int i = 0; i <= selected_currency_List.length;i++)
    {
      if(mounted){
        setState(() {
          isApiCallProcessing=true;
        });
      }

      Rest_Apis restApis = Rest_Apis();

      restApis.Delete_Currency(selected_currency_List[i], admin_auto_id, baseUrl).then((value) {
        if (value != null) {
          int status = value;

          if (status == 1) {
            isApiCallProcessing = false;

            getCurrencyList();
            selected_currency_List = [];
          } else if (status == 0) {
            isApiCallProcessing = false;

            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          } else {
            Fluttertoast.showToast(
              msg: "Something went wrong",
              backgroundColor: Colors.grey,
            );
          }
        }
      });
    }
  }

  Widget Currency_List_Layout(String currency, String country_code,
      String country_name, bool isSelected, int index) {
    return Container(
      decoration:  BoxDecoration(
        border: Border.all(
          color: Colors.grey.shade300, //                   <--- border color
          width: 1.0,
        ),

      ),
      child: ListTile(

          title: Text(
            country_name+': '+country_code,
            style: const TextStyle(
                fontSize: 16,
                color: Colors.black
            ),
          ),
          subtitle: Text("Currency: " +currency,style: const TextStyle(fontSize: 14,
              color: Colors.black),),
          trailing: isAdded(currencyList[index].id as String) == true
              ? Icon(
            Icons.check_circle,
            color: Colors.green[700],
          )
              : const Icon(
            Icons.check_circle_outline,
            color: Colors.grey,
          ),
          onTap: () {
            setState(() {

              setSelected(currencyList[index].id);
            });
          }),
    );
  }

  setSelected(String id) {
    if (isAdded(id) == true) {
      selected_currency_List.remove(id);
    } else {
      if (selected_currency_List.length < 10) {
        selected_currency_List.add(id);
      } else {
        Fluttertoast.showToast(
          msg: "Maximum 10 currencies can be selected",
          backgroundColor: Colors.grey,
        );
      }
    }
    if(mounted)
    {
      setState(() {});
    }

  }

  bool isAdded(String id) {
    for (int i = 0; i < selected_currency_List.length; i++) {
      if (selected_currency_List[i] == id) {
        return true;
      }
    }
    return false;
  }

  showAddCurrency() {
    return showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return AddCurrency(onAddListener);
        });
  }

  onAddListener(){
    Navigator.pop(context);
    getCurrencyList();
  }

  Future<String?> getBaseUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? baseUrl = prefs.getString('base_url');
    String? adminId = prefs.getString('admin_auto_id');

    if (baseUrl!=null && adminId!=null) {
      setState(() {
        this.baseUrl=baseUrl;
        this.admin_auto_id=adminId;
        getCurrencyList();
      });
    }
    return null;
  }

  void getCurrencyList() async {
    if(mounted){
      setState(() {
        isApiCallProcessing=true;
      });
    }

    Rest_Apis restApis = Rest_Apis();

    restApis.getCurrencyList(admin_auto_id, baseUrl).then((value) {

      if (value != null) {
        isApiCallProcessing = false;
        currencyList = value;

        print('currency length '+currencyList.length.toString());
        if(this.mounted){
          setState(() {
          });
        }
      }
    });
  }
}
