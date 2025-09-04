import 'package:flutter/material.dart';

class authProvider with ChangeNotifier {
   String _message="";
   String getMessage(){
     return _message;
   }
   //events
   void upgradeMessage(String msg){
     _message=msg;
     notifyListeners();
   }
}
