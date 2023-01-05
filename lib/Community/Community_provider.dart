import 'package:flutter/material.dart';

class CommunityProvider with ChangeNotifier{
  bool isLiked = false;

  List<String> selected_categories=[];

  like(){
    isLiked = true;
    notifyListeners();
  }

  unLike(){
    isLiked = false;
    notifyListeners();
  }

}