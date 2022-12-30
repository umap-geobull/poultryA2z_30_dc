import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poultry_a2z/Product_Details/Filters/Brand_Filter_Screen.dart';
import 'package:poultry_a2z/Product_Details/Filters/Color_Filter_Screen.dart';
import 'package:poultry_a2z/Product_Details/Filters/Price_Range_Screen.dart';
import 'package:poultry_a2z/Product_Details/Filters/Product_Moq_Screen.dart';
import 'package:poultry_a2z/Product_Details/Filters/Size_Filter_Screen.dart';
import 'package:poultry_a2z/Product_Details/Filters/Sort_By_Filter_Screen.dart';
import 'package:poultry_a2z/Utils/constants.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../settings/Select_Filter/Add_Filter_Screen.dart';
import 'Dimension_Filter_Screen.dart';
import 'Discount_Range_Screen.dart';
import 'Filter_Out_of_Stock_Screen.dart';
import 'Firmness_Filter_Screen.dart';
import 'Manufacturer_Filter_Screen.dart';
import 'Material_Filter_Screen.dart';
import 'Thickness_Filter_Screen.dart';
import 'Trial_period_Filter_Screen.dart';

typedef OnSaveCallback = void Function(String colors,String size,String moq,
    String brand, String min_price,String max_price,String sort_by,String manufacturer,String material,String firmness,String min_height,String max_height,String min_width,String max_width,String min_depth,String max_depth,String min_thickness,String max_thickness,
    String min_discount,String max_discount,String stock,String min_trial_priod,String max_trial_period);

typedef OnClearCallback = void Function();

class FilterBottomsheet extends StatefulWidget {
  OnSaveCallback onSaveCallback;
  OnClearCallback onClearCallback;
  List<String> categories;

  String colors, size, moq,  brand,  min_price, max_price, sort_by,manufacturer,
      material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period;

  FilterBottomsheet(
      this.onSaveCallback,
      this.onClearCallback,
      this.categories,
      this.colors,
      this.size,
      this.moq,
      this.brand,
      this.min_price,
      this.max_price,
      this.sort_by,
      this.manufacturer,
      this.material,
      this.min_thickness,
      this.max_thickness,
      this.firmness,
      this.min_height,
      this.max_height,
      this.min_width,
      this.max_width,
      this.min_depth,
      this.max_depth,
      this.min_discount,
      this.max_discount,
      this.stock,
      this.min_trial_priod,
      this.max_trial_period);

  @override
  _FilterBottomsheet createState() => _FilterBottomsheet(categories,colors, size, moq,  brand,  min_price, max_price, sort_by,manufacturer,
      material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period);
}

class _FilterBottomsheet extends State<FilterBottomsheet> {

  List<String> categories;
  String colors, size, moq,  brand,  min_price, max_price, sort_by,manufacturer,
      material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period;

  _FilterBottomsheet(this.categories, this.colors, this.size, this.moq,
      this.brand, this.min_price, this.max_price, this.sort_by,this.manufacturer,
      this.material,this.min_thickness,this.max_thickness,this.firmness,this.min_height,this.max_height,
      this.min_width,this.max_width,this.min_depth,this.max_depth,this.min_discount,this.max_discount,this.stock,this.min_trial_priod,this.max_trial_period);

  int initPosition = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: StatefulBuilder(builder: (context, setState) {
      return Material(
          child: SingleChildScrollView(
            controller: ModalScrollController.of(context),
            child: AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: Duration(milliseconds: 100),
              child:
              Container(
                width: MediaQuery.of(context).size.width,
                height: 350,
                decoration: const BoxDecoration(
                  color: appBarIconColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                ),
                child:
                CustomTabView(
                  categories: categories,
                  initPosition: initPosition,
                  itemCount: categories.length,
                  tabBuilder: (context, index) => Tab(
                    text: categories[index],
                  ),
                  pageBuilder: (context, index) =>
                      Center(child: Text(categories[index])),
                  onPositionChange: (index) {
                    print('current position: $index');
                    initPosition = index;
                  },
                  colors: this.colors,
                  size: this.size,
                    moq: this.moq,
                    brand: this.brand,
                  sort_by: this.sort_by,
                    min_price: this.min_price,
                    max_price: this.max_price,
                  manufacturer: this.manufacturer,
                  material: this.material,
                  firmness: this.firmness,
                  min_thickness: this.min_thickness,
                  max_thickness: this.max_thickness,
                  min_height: this.min_height,
                  max_height: this.max_height,
                  min_width: this.min_width,
                  max_width: this.max_width,
                  min_depth: this.min_depth,
                  max_depth: this.min_depth,
                  min_discount: this.min_discount,
                  max_discount: this.max_discount,
                  stock:this.stock,
                  min_trial_priod:this.min_trial_priod,
                  max_trial_period:max_trial_period,
                  onApplyCallback: onFilterApplyListener,
                  onRemoveCallback: onFilterClearListener,
                ),
              ),
            ),
          )
      );
    }
    ),
        onWillPop: ()=>onBackPressed()
    );

  }

  onBackPressed() {
    return Navigator.of(context).pop();
  }

  onFilterApplyListener(List<String> colors,List<String> size, List<String> moq,
      List<String> brand, String min_price,String max_price,String sort_by,List<String> manufacturer, List<String> material,List<String> firmness,String min_height,String max_height,String min_width,String max_width,String min_depth,String max_depth,String min_thickness,String max_thickness,
      String min_discount,String max_discount,String stock,String min_trial_priod,String max_trial_period){
    String colorString='', brandString='',moqStirng='',sizeString='', manufacturerstring='', materialstring='', frimnessString='';


    for(int index=0;index<brand.length;index++){
      if(index==0 || index==1){
        if(brandString!='') {
          brandString += '|'+brand[index];
        }else{
          brandString+=brand[index];
        }
      }
      else{
        brandString+= '|'+brand[index];
      }
    }

    for(int index=0;index<size.length;index++){
      if(index==0 || index==1){
        if(sizeString!='') {
          sizeString += '|'+size[index];
        }else{
          sizeString+=size[index];
        }
      }
      else{
        sizeString+= '|'+size[index];
      }
    }

    for(int index=0;index<moq.length;index++){
      if(index==0 || index==1){
        if(moqStirng!='') {
          moqStirng += '|'+moq[index];
        }else{
          moqStirng+=moq[index];
        }
      }
      else{
        moqStirng+= '|'+moq[index];
      }
    }

    for(int index=0;index<colors.length;index++){
      if(index==0 || index==1){
        if(colorString!='') {
          colorString += '|'+colors[index];
        }else{
          colorString+=colors[index];
        }
      }
      else{
        colorString+= '|'+colors[index];
      }
    }

    for(int index=0;index<manufacturer.length;index++){
    if(index==0 || index==1){
      if(manufacturerstring!='') {
        manufacturerstring += '|'+manufacturer[index];
      }else{
        manufacturerstring+=manufacturer[index];
      }
    }
    else{
    manufacturerstring+= '|'+manufacturer[index];
    }
    }

    for(int index=0;index<material.length;index++){
    if(index==0 || index==1){
      if(materialstring!='') {
        materialstring += '|'+material[index];
      }else{
        materialstring+=material[index];
      }
    }
    else{
    materialstring+= '|'+material[index];
    }
    }

    for(int index=0;index<firmness.length;index++){
      if(index==0 || index==1){
        if(frimnessString!='') {
          frimnessString += '|'+firmness[index];
        }else{
          frimnessString+=firmness[index];
        }
      }
      else{
        frimnessString+= '|'+firmness[index];
      }
    }

    print(colorString);
    print(sizeString);
    print(moqStirng);
    print(brandString);
    print(min_price);
    print(max_price);
    print(sort_by);
    print(manufacturerstring);
    print(materialstring);
    print(frimnessString);

    widget.onSaveCallback(colorString,sizeString,moqStirng,brandString,min_price,max_price,sort_by,manufacturerstring,materialstring,frimnessString,
        min_height, max_height, min_width, max_width, min_depth, max_depth, min_thickness, max_thickness, min_discount, max_discount,stock,min_trial_priod,max_trial_period);
    Navigator.pop(context);

  }

  onFilterClearListener(){
    widget.onClearCallback();
    Navigator.pop(context);

  }

}

typedef OnApplyCallback = void Function(List<String> colors, List<String> size, List<String> moq, List<String> brand,
    String min_price,String max_price, String sort_by,List<String> manufacturer,List<String> material,List<String> firmness,String min_height,String max_height,String min_width,String max_width,String min_depth,String max_depth,String min_thickness,String max_thickness,String min_discount,String max_discount,String stock,String min_trial_priod,String max_trial_period);

typedef OnRemoveCallback = void Function();

class CustomTabView extends StatefulWidget {
  final OnApplyCallback onApplyCallback;
  final OnRemoveCallback onRemoveCallback;

  final int itemCount;
  final IndexedWidgetBuilder tabBuilder;
  final IndexedWidgetBuilder pageBuilder;

  // final Widget stub;
  final ValueChanged<int> onPositionChange;
  //final ValueChanged<double> onScroll;
  final int initPosition;
  final List<String> categories;
  final String colors, size, moq,  brand,  min_price, max_price, sort_by,manufacturer,
      material,min_thickness,max_thickness,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_discount,max_discount,stock,min_trial_priod,max_trial_period;

  const CustomTabView({
    required this.itemCount,
    required this.tabBuilder,
    required this.pageBuilder,
    required this.categories,
    // this.stub,
    required this.onPositionChange,
    // required this.onScroll,
    required this.initPosition,

    required this.colors,
    required this.size,
    required this.moq,
    required this.brand,
    required this.min_price,
    required this.max_price,
    required this.sort_by,
    required this.manufacturer,
    required this.material,
    required this.min_thickness,
    required this.max_thickness,
    required this.firmness,
    required this.min_height,
    required this.max_height,
    required this.min_width,
    required this.max_width,
    required this.min_depth,
    required this.max_depth,
    required this.min_discount,
    required this.max_discount,
    required this.stock,
    required this.min_trial_priod,
    required this.max_trial_period,
    required this.onApplyCallback,
    required this.onRemoveCallback,

  });

  @override
  _CustomTabsState createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabView> with TickerProviderStateMixin {
  late TabController controller;
  late int _currentCount;
  late int _currentPosition;

  List<String> colors=[];
  List<String> size=[];
  List<String> moq=[];
  List<String> brand=[];
  List<String> manufacturer=[];
  List<String> material=[];
  List<String> firmness=[];
  String min_price='',max_price='',sort_by='',min_thickness='',max_thickness=''
  ,max_height='', min_height='',min_width='',max_width='',min_depth='',max_depth='',min_discount='',max_discount='',stock='',min_trial_priod='',max_trial_period='';


  @override
  void initState() {
    _currentPosition = widget.initPosition;
    controller = TabController(length: widget.itemCount, vsync: this, initialIndex: _currentPosition,);
    controller.addListener(onPositionChange);
    // controller.animation!.addListener(onScroll);
    _currentCount = widget.itemCount;

    print('itemcount'+widget.itemCount.toString());
    print('itemcount'+widget.categories.toString());
    print('categories length'+widget.categories.length.toString());

    setData();

    super.initState();
  }

  setData(){
    this.colors=widget.colors.split('|');
    this.size=widget.size.split('|');
    this.moq=widget.moq.split('|');
    this.brand=widget.brand.split('|');
    this.min_price=widget.min_price;
    this.max_price=widget.max_price;
    this.sort_by=widget.sort_by;
    this.manufacturer=widget.manufacturer.split('|');
    this.material=widget.material.split('|');
    this.firmness=widget.firmness.split('|');
    this.min_height=widget.min_height;
    this.max_height=widget.max_height;
    this.min_width=widget.min_width;
    this.max_width=widget.max_width;
    this.min_depth=widget.min_depth;
    this.max_depth=widget.max_depth;
    this.min_thickness=widget.min_thickness;
    this.max_thickness=widget.max_thickness;
    this.min_discount=widget.min_discount;
    this.max_discount=widget.max_discount;
    this.stock=widget.stock;

    if(this.mounted){
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(CustomTabView oldWidget) {
    if (_currentCount != widget.itemCount) {
      controller.removeListener(onPositionChange);
      controller.dispose();

      _currentPosition = widget.initPosition;
      if (_currentPosition > widget.itemCount - 1) {
        _currentPosition = widget.itemCount - 1;
        _currentPosition = _currentPosition < 0 ? 0 : _currentPosition;
        if (widget.onPositionChange is ValueChanged<int>) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onPositionChange(_currentPosition);
            }
          });
        }
      }

      _currentCount = widget.itemCount;
      setState(() {
        controller = TabController(
          length: widget.itemCount,
          vsync: this,
          initialIndex: _currentPosition,
        );
        controller.addListener(onPositionChange);
        //  controller.animation!.addListener(onScroll);
      });
    } else {
      controller.animateTo(widget.initPosition);
    }


    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // controller.animation!.removeListener(onScroll);
    controller.removeListener(onPositionChange);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        widget.categories.length==1 && widget.categories[0]=='' ?
        Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: 280,
            color: Colors.white,
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('No Filters Selected'),
                Container(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[100],
                    ),
                    child: const Text('Select Filter',style: TextStyle(color: Colors.black87,fontSize: 12),),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SelectFilter()));
                    },
                  ),
                  margin: const EdgeInsets.all(5),
                )
              ],
            )
        ):
        Container(
          height: 300,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10.0)),),
                alignment: Alignment.center,
                child: TabBar(
                  isScrollable: true,
                  controller: controller,
                  labelColor: kPrimaryColor,
                  unselectedLabelColor: kPrimaryColor,
                  indicator: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: kPrimaryColor,
                        width: 2,
                      ),
                    ),
                  ),
                  tabs: List.generate(
                    widget.itemCount,
                        (index) => widget.tabBuilder(context, index),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children:tabViewList(),
                ),
              ),
            ],
          ),
        ),

        Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0, right: 10),
          color: Colors.white,
          alignment: Alignment.bottomRight,
          child:Container(
            height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap:()
                    {
                      widget.onRemoveCallback();
                    },
                    child: Text(
                      "CLEAR FILTER", style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  )
                  ,
                  const SizedBox(width: 10,),
                  GestureDetector(
                    onTap:()
                    {
                      widget.onApplyCallback(colors,size,moq,brand,min_price,max_price,sort_by,manufacturer,material,firmness,min_height,max_height,min_width,max_width,min_depth,max_depth,min_thickness,max_thickness,min_discount,max_discount,stock,min_trial_priod,max_trial_period);
                    },
                    child: const Text(
                      "APPLY FILTER", style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  )
                ],
              )
          ),
        )

      ],
    );
  }

  List<Widget> tabViewList(){
    List<Widget> tabList=[];

    for(int index=0;index<widget.categories.length;index++){
      print('categories'+widget.categories.length.toString());
      if(widget.categories[index]=='Size'){
        tabList.add(Size_Filter_Screen(onFilterSizeListener,widget.size));
      }
      else if(widget.categories[index]=='Price'){
        tabList.add(Price_Range_Screen(onFilterPriceListener,widget.min_price,widget.max_price),);
      }
      else if(widget.categories[index]=='Color'){
        tabList.add( Color_Filter_Screen(onFilterColorListener,widget.colors));
      }
      else if(widget.categories[index]=='Sort By'){
        tabList.add(Sort_By_Filter_Screen(onFilterSortByListener,widget.sort_by));
      }
      else if(widget.categories[index]=='Brand'){
        tabList.add(Brand_Filter_Screen(onFilterBrandListener,widget.brand));
      }
      else if(widget.categories[index]=='Moq'){
        tabList.add(Product_Moq_Screen(onFilterMoqListener,widget.moq));
      }
      else if(widget.categories[index]=='Manufacturers'){
        tabList.add(Manufacturer_Filter_Screen(onFilterManufacturerListener,widget.manufacturer));
      }
      else if(widget.categories[index]=='Material'){
        tabList.add(Material_Filter_Screen(onFilterMaterialListener,widget.material));
      }
      else if(widget.categories[index]=='Discount'){
        tabList.add(Discount_Range_Screen(onFilterDiscountListener,widget.min_discount,widget.max_discount));
      }
      else if(widget.categories[index]=='Out of stock'){
        tabList.add(Filter_Out_of_Stock_Screen(onFilterStockListener,widget.stock));
      }
      else if(widget.categories[index]=='Dimension'){
        tabList.add(Dimension_Filter_Screen(onFilterDimensionListener,widget.min_height,widget.max_height,widget.min_width,widget.max_width,widget.min_depth,widget.min_depth));
      }
      else if(widget.categories[index]=='Thickness'){
        tabList.add(Thickness_Filter_Screen(onFilterThicknessListener,widget.min_thickness,widget.max_thickness));
      }
      else if(widget.categories[index]=='Firmness'){
        tabList.add(Firmness_Filter_Screen(onFilterFirmnessListener,widget.firmness));
      }
      else if(widget.categories[index]=='Trial Period'){
        tabList.add(Trial_Period_Screen(onFilterThicknessListener,widget.min_trial_priod, widget.max_trial_period));
      }
    }
    return tabList;
  }

  onPositionChange() {
    if (!controller.indexIsChanging) {
      _currentPosition = controller.index;
      if (widget.onPositionChange is ValueChanged<int>) {
        widget.onPositionChange(_currentPosition);
      }
    }
  }

  onFilterColorListener(List<String> color){
    this.colors=color;
    print(colors.toString());
    print(colors.length);
  }

  onFilterManufacturerListener(List<String> manufacturers){
    this.manufacturer=manufacturers;
    print(manufacturer.toString());
    print(manufacturer.length);
  }

  onFilterMaterialListener(List<String> materials){
    this.material=materials;
    print(material.toString());
    print(material.length);
  }

  onFilterFirmnessListener(List<String> firmnesstype){
    this.firmness=firmnesstype;
    print(firmness.toString());
    print(firmness.length);
  }

  onFilterSizeListener(List<String> size){
    this.size=size;
    print(size.toString());
    print(size.length);
  }

  onFilterMoqListener(List<String> moq){
    this.moq=moq;
    print(moq.toString());
    print(moq.length); }

  onFilterDimensionListener(String min_height, String max_height,String min_width, String max_width,String min_depth, String max_depth){
    this.min_height=min_height;
    this.max_height=max_height;
    this.min_width=min_width;
    this.max_width=max_width;
    this.min_depth=min_depth;
    this.max_depth=max_depth;
    print(min_height);
    print(max_height);
    print(min_width);
    print(max_width);
    print(min_depth);
    print(max_depth);

  }

  onFilterStockListener(String stock_type){
    this.stock=stock_type;
    print(stock.toString());
    print(stock.length); }

  onFilterDiscountListener(String min, String max){
    this.min_discount=min;
    this.max_discount=max;
    print(min_discount+' to '+max_discount);
  }

  onFilterThicknessListener(String min, String max){
    this.min_thickness=min;
    this.max_thickness=max;

    print(min_thickness+' to '+max_thickness);
  }

  onFilterPriceListener(String min, String max){
    this.min_price=min;
    this.max_price=max;

    print(min_price+' to '+max_price);
  }

  onFilterBrandListener(List<String> brands){
    this.brand=brands;
    print(brand.toString());
    print(brand.length);
  }

  onFilterSortByListener(String sortBy){
    this.sort_by=sortBy;
    print(sort_by);
  }
}


