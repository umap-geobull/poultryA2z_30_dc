import 'package:flutter/material.dart';

class ConsultantProvider with ChangeNotifier{
  bool isLiked = false;

  List<String> selected_categories=[];
  // List<String> Category_list = [];
  // List<String> speciality_list = [];
  List<String> selected_speciality=[];
  categoryadd(String category){
    selected_categories.add(category);
    notifyListeners();
  }
  categoryremove(String category){
    selected_categories.remove(category);
    notifyListeners();
  }
  bool isAdded(String id) {
    for (int i = 0; i < selected_categories.length; i++) {
      if (selected_categories[i] == id) {
        return true;
      }
    }
    notifyListeners();
    return false;
  }

  // setData(){
  //   this.selected_categories=selectedJobs.split(',');
  //   notifyListeners();
  //   // if(this.mounted){
  //   //   setState(() {
  //   //   });
  //   // }
  // }

}