import 'dart:async';
import 'package:flutter/material.dart';

class dataProviderModel extends ChangeNotifier{

  List slideSwitchStates = [
    false,  // switch1
    true,  // switch2
    false, // switch3
    true  // switch4
  ];
  var myData = 'initial';
  int count = 0;

  void toggleSwitch(_switch){
    slideSwitchStates[_switch] = ! slideSwitchStates[_switch];
    notifyListeners();
  }


}