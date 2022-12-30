import 'package:flutter/material.dart';

class CommunityProvider with ChangeNotifier{
  bool isLiked = false;

  like(){
    isLiked = true;
    notifyListeners();
  }

  unLike(){
    isLiked = false;
    notifyListeners();
  }

}