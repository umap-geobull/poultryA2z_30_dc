import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(String min_thickness,String max_thickness);

class Thickness_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String min_thickness;
  String max_thickness;


  Thickness_Filter_Screen(this.onSaveCallback, this.min_thickness, this.max_thickness);

  @override
  _Thickness_Filter_ScreenState createState() => _Thickness_Filter_ScreenState(min_thickness,max_thickness);
}

class _Thickness_Filter_ScreenState extends State<Thickness_Filter_Screen> {
 // RangeValues _currentRangeValues = RangeValues(1000, 20000);
//  final _controller_min_value = TextEditingController();
//  final _controller_max_value = TextEditingController();

  String min_thickness;
  String max_thickness;

  double _starValue = 10;
  double _endValue = 80;
  double minValue = 0;
  double maxValue = 200;

  final startController = TextEditingController();
  final endController = TextEditingController();


  _Thickness_Filter_ScreenState(this.min_thickness, this.max_thickness);


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
      child: Column(
        children: [
          Column(
            children: [
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(10),
                  child: const Text("Select Thickness Range",
                      style: TextStyle(fontSize: 15, color: Colors.black))),
            /*  RangeSlider(
                values: _currentRangeValues,
                max: 100000000,
                min: 0,
                divisions: 100000000,
                labels: RangeLabels(
                  _currentRangeValues.start.round().toString(),
                  _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    //  _currentRangeValues = values;
                    if (values.end - values.start >= 20) {
                      _currentRangeValues = values;
                      _controller_min_value.text = (values.start.round()).toString();
                      _controller_max_value.text = (values.end.round()).toString();
                    }
                    else {
                      if (_currentRangeValues.start == values.start) {
                        _currentRangeValues = RangeValues(_currentRangeValues.start, _currentRangeValues.start + 20);
                      } else {
                        _currentRangeValues = RangeValues(_currentRangeValues.end - 20, _currentRangeValues.end);
                      }
                    }

                    widget.onSaveCallback(_controller_min_value.text,_controller_max_value.text);
                    print(_controller_min_value.text+'  '+_controller_max_value.text);
                  });
                },
              ),*/

              RangeSlider(
                values: RangeValues(_starValue, _endValue),
                min: minValue,
                max: maxValue,
                onChanged: (values) {
                  setState(() {
                    _starValue = values.start.roundToDouble();
                    _endValue = values.end.roundToDouble();
                    startController.text = values.start.round().toString();
                    endController.text = values.end.round().toString();

                    widget.onSaveCallback(startController.text,endController.text);
                    print(startController.text+'  '+endController.text); });
                },
              ),

            ],
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              margin: const EdgeInsets.only(left: 10,right: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(10),
                              child: const Text("Min Value",
                                  style: TextStyle(fontSize: 15, color: Colors.blue))),
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                              borderRadius: BorderRadius.circular(10),

                            ),
                            child: Row(
                              children: [

                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(

                                        "RS.", style: TextStyle(fontSize: 14, color: Colors.blue,
                                          fontWeight: FontWeight.w300),),
                                    )),

                                Expanded(
                                  flex: 8,
                                  child: TextField(
                                    controller: startController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: "",
                                      hintStyle: TextStyle(
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                              alignment: Alignment.topLeft,
                              margin: const EdgeInsets.all(10),
                              child: const Text("Max Value",
                                  style: TextStyle(fontSize: 15, color: Colors.blue))),
                          Container(
                            height: 45,
                            margin: const EdgeInsets.only(right: 5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(

                                        "RS.", style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.w300),),
                                    )),

                                Expanded(
                                  flex: 8,
                                  child: TextField(
                                    controller: endController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      hintText: "",
                                      hintStyle: TextStyle(

                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ),
          ),
        ],
      ),
    ),);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(min_thickness.isNotEmpty){
      _starValue=double.parse(min_thickness);
    }

    if(max_thickness.isNotEmpty){
      _endValue=double.parse(max_thickness);
    }

    startController.addListener(_setStartValue);
    endController.addListener(_setEndValue);
    if(this.mounted){
      setState(() {
      });
    }

  }

  _setStartValue() {
    if (double.parse(startController.text).roundToDouble() <=
        double.parse(endController.text).roundToDouble() &&
        double.parse(startController.text).roundToDouble() >= minValue &&
        double.parse(endController.text).roundToDouble() >= minValue &&
        double.parse(startController.text).roundToDouble() <= maxValue &&
        double.parse(endController.text).roundToDouble() <= maxValue) {
      setState(() {
        _starValue = double.parse(startController.text).roundToDouble();
      });
    }
    //print("First text field: ${startController.text}");
  }

  _setEndValue() {
    if (double.parse(startController.text).roundToDouble() <=
        double.parse(endController.text).roundToDouble() &&
        double.parse(startController.text).roundToDouble() >= minValue &&
        double.parse(endController.text).roundToDouble() >= minValue &&
        double.parse(startController.text).roundToDouble() <= maxValue &&
        double.parse(endController.text).roundToDouble() <= maxValue) {
      setState(() {
        _endValue = double.parse(endController.text).roundToDouble();
      });
    }
    //print("Second text field: ${endController.text}");
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

 /* @override
  void dispose() {
    // other dispose methods
    _controller_min_value.dispose();
    _controller_max_value.dispose();
    super.dispose();
  }*/
}