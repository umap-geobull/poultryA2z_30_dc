import 'package:flutter/material.dart';

typedef OnSaveCallback = void Function(String min_height,String max_height,String min_width,String max_width,String min_depth,String max_depth);

class Dimension_Filter_Screen extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  String min_height;
  String max_height;
  String min_width;
  String max_width;
  String min_depth;
  String max_depth;


  Dimension_Filter_Screen(this.onSaveCallback, this.min_height, this.max_height,this.min_width,this.max_width,this.min_depth,this.max_depth);

  @override
  _Dimension_Filter_ScreenState createState() => _Dimension_Filter_ScreenState(min_height,max_height,min_width,max_width,min_depth,max_depth);
}

class _Dimension_Filter_ScreenState extends State<Dimension_Filter_Screen> {

  String min_height;
  String max_height;
  String min_width;
  String max_width;
  String min_depth;
  String max_depth;
  double _starValue = 5,_starValue1 = 5,_starValue2 = 5;
  double _endValue = 80,_endValue1 = 80,_endValue2 = 80;
  double minValue = 0,minValue1 = 0,minValue2 = 0;
  double maxValue = 500,maxValue1 = 500,maxValue2 = 500;

  final startController = TextEditingController();
  final endController = TextEditingController();
  final startController1 = TextEditingController();
  final endController1 = TextEditingController();
  final startController2 = TextEditingController();
  final endController2 = TextEditingController();


  _Dimension_Filter_ScreenState(this.min_height, this.max_height,this.min_width,this.max_width,this.min_depth,this.max_depth);


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
                  child: const Text("Select Dimension Range",
                      style: TextStyle(fontSize: 15, color: Colors.black))),
              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(10),
                  child: const Text("Height Range",
                      style: TextStyle(fontSize: 12, color: Colors.black))),
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

                    widget.onSaveCallback(startController.text,endController.text,startController1.text,endController1.text,startController2.text,endController2.text);
                    print(startController.text+'  '+endController.text); });
                },
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

              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(10),
                  child: const Text("Width Range",
                      style: TextStyle(fontSize: 12, color: Colors.black))),
              RangeSlider(
                values: RangeValues(_starValue1, _endValue1),
                min: minValue1,
                max: maxValue1,
                onChanged: (values) {
                  setState(() {
                    _starValue1 = values.start.roundToDouble();
                    _endValue1 = values.end.roundToDouble();
                    startController1.text = values.start.round().toString();
                    endController1.text = values.end.round().toString();

                    widget.onSaveCallback(startController.text,endController.text,startController1.text,endController1.text,startController2.text,endController2.text);
                    print(startController1.text+'  '+endController1.text); });
                },
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
                                        controller: startController1,
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
                                        controller: endController1,
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

              Container(
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.all(10),
                  child: const Text("Depth Range",
                      style: TextStyle(fontSize: 12, color: Colors.black))),
              RangeSlider(
                values: RangeValues(_starValue2, _endValue2),
                min: minValue2,
                max: maxValue2,
                onChanged: (values) {
                  setState(() {
                    _starValue2 = values.start.roundToDouble();
                    _endValue2 = values.end.roundToDouble();
                    startController2.text = values.start.round().toString();
                    endController2.text = values.end.round().toString();

                    widget.onSaveCallback(startController.text,endController.text,startController1.text,endController1.text,startController2.text,endController2.text);
                    print(startController2.text+'  '+endController2.text); });
                },
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
                                        controller: startController2,
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
                                        controller: endController2,
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

        ],
      ),
    ),);

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

   /* if(min_discount.isNotEmpty){
      _controller_min_value.text=min_discount;
    }

    if(max_discount.isNotEmpty){
      _controller_max_value.text=max_discount;
    }*/

    if(min_height.isNotEmpty){
      _starValue=double.parse(min_height);
    }

    if(max_height.isNotEmpty){
      _endValue=double.parse(max_height);
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
    print("First text field: ${startController.text}");
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
    print("Second text field: ${endController.text}");
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