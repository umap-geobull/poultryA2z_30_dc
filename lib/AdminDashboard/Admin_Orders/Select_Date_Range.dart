import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'Vendor_Orders_Reports_Screen.dart';

typedef OnSaveCallback = void Function(String start, String end, String sdate1, String sdate2);

class Select_Date_Range extends StatefulWidget {
   Select_Date_Range({Key? key,  required this.type, required this.onSaveCallback}) : super(key: key);
  String type;
  OnSaveCallback onSaveCallback;

  @override
  _Select_Date_RangeState createState() => _Select_Date_RangeState();
}

class _Select_Date_RangeState extends State<Select_Date_Range> {
   final DateRangePickerController _datePickerController = DateRangePickerController();
  List<String> Range_List = [
    'Last 90 Days',
    'Last Month',
    'Last Week',
    'Last Year',
    '1st Quarter',
    '2nd Quarter',
    '3rd Quarter',
    '4th Quarter'
  ];

 String?  selected_range;
 String start_date = "", end_date = "", start_date1 = "", end_date1 = "";

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrent_Date();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text("Reports",
            style: TextStyle(color: appBarIconColor, fontSize: 18)),
        leading: IconButton(
          onPressed: () => {Navigator.pop(context)},
          icon: const Icon(Icons.arrow_back, color: appBarIconColor),
        ),
      ),
      bottomSheet: Checkout_Section(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const Text("Select Range",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    isExpanded: true,
                    hint: Row(
                      children: const [
                        Expanded(
                          child: Text(
                            'Select Range',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    items: Range_List.map((item) => DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )).toList(),
                    value: selected_range,
                    onChanged: (value) {
                      setState(() {
                        selected_range = value as String;
                        selectDate_Range(selected_range);
                      });
                    },
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                    ),
                    iconEnabledColor: Colors.black,
                    iconDisabledColor: Colors.grey,
                    buttonHeight: 45,
                    buttonWidth: MediaQuery.of(context).size.width,
                    buttonPadding:
                    const EdgeInsets.only(left: 14, right: 14),
                    buttonDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.black26,
                      ),
                    ),
                    itemHeight: 30,
                    itemPadding: const EdgeInsets.only(left: 14, right: 14),
                    dropdownMaxHeight: 150,
                    dropdownWidth: MediaQuery.of(context).size.width,
                    dropdownPadding: const EdgeInsets.only(left: 10, right: 10),
                    dropdownDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    dropdownElevation: 8,
                    scrollbarRadius: const Radius.circular(40),
                    scrollbarThickness: 1,
                    scrollbarAlwaysShow: true,
                  ),
                ),
              ),
              Divider(color: Colors.grey.shade300),
              const Text("Starting Date",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,

                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(
                      children: [
                        const Icon(Icons.calendar_today, size: 18,),
                        const SizedBox(width: 5,),
                        Text(start_date,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                      ],

                    ),
                  ),
                ),
                onTap: ()=>{
                  show_DatePicker("start_date")
                }
              ),
              Divider(color: Colors.grey.shade300),
              const Text("End Date",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                    Border.all(color: Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,

                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Wrap(
                      children: [
                        const Icon(Icons.calendar_today, size: 18,),
                        const SizedBox(width: 5,),
                        Text(end_date,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            )),
                      ],

                    ),
                  ),
                ),
                onTap: ()=>{
                  show_DatePicker("end_date")
                },
              ),
              Divider(color: Colors.grey.shade300),
            Container(
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                monthViewSettings: const DateRangePickerMonthViewSettings(firstDayOfWeek: 7),
                selectionMode: DateRangePickerSelectionMode.range,
                onSelectionChanged: _onSelectionChanged,
                showActionButtons: true,
                controller: _datePickerController,
                onSubmit: (Object? val){
                 if(mounted){
                   setState(() {


                   });
                 }
                },
                onCancel: () {
                  _datePickerController.selectedRanges = null;
                },
              ),
            )
            ],
          ),
        ),
      ),
    );

  }

   Widget Checkout_Section(BuildContext context) {
     return Container(
       height: 60,
       color: Colors.grey.shade50,
       child: Padding(
           padding: const EdgeInsets.all(10.0),
           child:  SizedBox(
             height: 40,
             child: ElevatedButton(
               style: ElevatedButton.styleFrom(
                   primary: kPrimaryColor,
                   textStyle: const TextStyle(fontSize: 20)),
               onPressed: () {

                 widget.onSaveCallback(start_date, end_date, start_date1, end_date1);
                 Navigator.of(context).pop();

                 /* if(widget.type == "reports")
                 {
                   Navigator.of(context).pop();
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                       Vendor_Orders_Reports( s_date: start_date,e_date: end_date, s_date1: start_date1,e_date1: end_date1,)));


                 }*/
                 /* else if(widget.type == "sales")
                   {
                    Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Sales()));

                   }
                 else if(widget.type == "finance")
                 {
                   Navigator.of(context).pop();
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Finanace_home_screen()));

                 }*/

               },
                 child: const Center(
                   child: Text(
                     'Save Changes',
                     style: TextStyle(
                       fontSize: 16,
                       color: Colors.white,
                     ),
                   ),
                 ),
             ),
/*             child: RaisedButton(
               child: const Center(
                 child: Text(
                   'Save Changes',
                   style: TextStyle(
                     fontSize: 16,
                     color: Colors.white,
                   ),
                 ),
               ),
               textColor: Colors.white,
               color: kPrimaryColor,
               shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(5)),
               onPressed: () {

                 if(widget.type == "reports")
                   {
                     Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Orders_Reports( s_date: start_date,e_date: end_date, s_date1: start_date1,e_date1: end_date1,)));


                   }
                  *//* else if(widget.type == "sales")
                   {
                    Navigator.of(context).pop();
                     Navigator.of(context).push(MaterialPageRoute(builder: (context) => Venders_Sales()));

                   }
                 else if(widget.type == "finance")
                 {
                   Navigator.of(context).pop();
                   Navigator.of(context).push(MaterialPageRoute(builder: (context) => Vendor_Finanace_home_screen()));

                 }*//*

               },
             )*/
           )),
     );
   }

  void selectDate_Range(String? selectedRange) {
    switch (selectedRange) {
      case "Last 90 Days":
        {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          DateTime prevDate = DateTime(date.year, date.month, date.day - 90);
          if(mounted){
            setState(() {
              start_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
              end_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

              start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
              end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();

            });
          }

        }
        break;

      case "Last Month":
        {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.month);
          DateTime prevDate = DateTime(date.year, date.month - 1, date.day );
          if(mounted){
            setState(() {
              start_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
              end_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

              start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
              end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
            });
          }

        }
        break;

      case "Last Week":
        {
          DateTime now = DateTime.now();
          DateTime date = DateTime(now.year, now.month, now.day);
          DateTime prevDate = DateTime(date.year, date.month, date.day - 7);
          if(mounted){
            setState(() {
              _datePickerController.selectedRange = PickerDateRange(now, now.add(const Duration(days: 7)));
             /* start_date = prevDate.day.toString()+"/"+prevDate.month.toString()+"/"+prevDate.year.toString();
              end_date = date.day.toString()+"/"+date.month.toString()+"/"+date.year.toString();*/
              end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
              start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

              start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
              end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
            });
          }

        }
        break;

      case "Last Year":
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, now.month, now.day);
        DateTime prevDate = DateTime(date.year-1, date.month, date.day);
        if(mounted){
          setState(() {
            end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
            start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

            start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
            end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
          });
        }


        break;

      case "1st Quarter":
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, 01, 01);
        DateTime prevDate = DateTime(date.year, 03, 31);
        if(mounted){
          setState(() {
            end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
            start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

            start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
            end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
          });
        }


        break;

      case "2nd Quarter":
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, 04, 01);
        DateTime prevDate = DateTime(date.year, 06, 30);
        if(mounted){
          setState(() {
            end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
            start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

            start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
            end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
          });
        }


        break;

      case "3rd Quarter":
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, 07, 01);
        DateTime prevDate = DateTime(date.year, 09, 30);
        if(mounted){
          setState(() {
            end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
            start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

            start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
            end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();
          });
        }


        break;

      case "4th Quarter":
        DateTime now = DateTime.now();
        DateTime date = DateTime(now.year, 10, 01);
        DateTime prevDate = DateTime(date.year, 12, 31);
        if(mounted){
          setState(() {
            end_date = DateFormat('dd, MMMM yyyy').format(prevDate).toString();
            start_date =  DateFormat('dd, MMMM yyyy').format(date).toString();

            start_date1 = DateFormat('yyyy-MM-dd').format(prevDate).toString();
            end_date1 = DateFormat('yyyy-MM-dd').format(date).toString();

          });
        }


        break;

      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  void getCurrent_Date() {
    if(mounted)
    {
      setState(() {
        final DateTime today = DateTime.now();
        start_date = DateFormat('dd, MMMM yyyy').format(today).toString();
        end_date = DateFormat('dd, MMMM yyyy').format(today.add(const Duration(days: 30))).toString();

        start_date1 = DateFormat('yyyy-MM-dd').format(today).toString();
        end_date1 = DateFormat('yyyy-MM-dd').format(today.add(const Duration(days: 30))).toString();
        _datePickerController.selectedRange = PickerDateRange(today, today.add(const Duration(days: 30)));

      });
    }
 }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      print("args=>"+args.toString());
      start_date = DateFormat('dd, MMMM yyyy').format(args.value.startDate).toString();
      end_date = DateFormat('dd, MMMM yyyy').format(args.value.endDate ?? args.value.startDate).toString();

      start_date1 = DateFormat('yyyy-MM-dd').format(args.value.startDate).toString();
      end_date1 = DateFormat('yyyy-MM-dd').format(args.value.endDate ?? args.value.startDate).toString();
    });
  }

  show_DatePicker(String date) {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2010, 1),
        lastDate: DateTime(2030,12),
        builder: (context,picker){
          return Theme(

            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: kPrimaryColor,
                onPrimary: Colors.white,
                surface: kPrimaryColor,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor:Colors.white,
            ),
            child: picker!,);
        })
        .then((selectedDate) {
        if(mounted)
          {
            setState(() {
              if(selectedDate!=null){
                print(selectedDate.toString());
                if(date== "start_date")
                  {
                    start_date = DateFormat('dd, MMMM yyyy').format(selectedDate).toString();
                    start_date1 = DateFormat('yyyy-MM-dd').format(selectedDate).toString();

                  }
                else if(date== "end_date"){
                  end_date = DateFormat('dd, MMMM yyyy').format(selectedDate).toString();
                  end_date1 = DateFormat('yyyy-MM-dd').format(selectedDate).toString();

                }


              }
            });
          }

    });
  }
}
