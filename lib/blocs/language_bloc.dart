import 'package:flutter/material.dart';

class LanguageBloc extends ChangeNotifier{
  bool _isLatvian = true;

  bool get isLatvian => _isLatvian;

  set isLatvian(bool val){
    _isLatvian = val;
    notifyListeners();
  }

  changeLanguage(){
    print(isLatvian);
    isLatvian = !isLatvian;
  }

}