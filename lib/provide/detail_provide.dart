import 'package:flutter/material.dart';
import 'package:flutter_app/service/http_service.dart';
import 'dart:convert';

class DetailProvide with ChangeNotifier {
  var goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;
  //TabBar切换方法
  changeLR(String changeState){
    if(changeState == "left"){
      isLeft = true;
      isRight = false;
    }else{
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  getGoodsInfo (String id) async{
    var formData = {"id": id};
    await request("detailServer",formData: formData).then((val){
      var responseData = json.decode(val.toString());
      // print(responseData);
      goodsInfo = responseData;
      // goodsInfo = (responseData["data"] as List).cast();
      notifyListeners();
    });
  }
}