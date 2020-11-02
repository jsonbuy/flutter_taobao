import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List cartList = [];
  bool checkAll = true;//是否全选
  double totalPrice = 0;//总价
  int cartNum = 0;//总数量
  //添加购物车
  save(goodsId,goodsName,count,price,images) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    cartString = preferences.getString("cartInfo");
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int iVal = 0;
        totalPrice = 0;//总价
        cartNum = 0;//总数量
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        tempList[iVal]['count'] = item['count'] + 1;
        isHave = true;
      }
      if(item['isCheck']){
        totalPrice += (item['count'] * double.parse(item['price']));//总价
        cartNum += item['count'];//总数量
      }
      iVal++;
    });
    if(!isHave){
      tempList.add({
        'goodsId': goodsId,
        'goodsName': goodsName,
        'count': count,
        'price': price,
        'images': images,
        'isCheck': true
      });
      totalPrice += double.parse(price);//总价
      cartNum += count;//总数量
    }
    cartString = json.encode(tempList).toString();
    // print(cartString);
    preferences.setString('cartInfo', cartString);
    notifyListeners();
  }
  //清空所有商品
  remove() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("cartInfo");
    print("remove-------------------");
    notifyListeners();
  }
  //改变cart列表
  getCartInfo() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cartString = preferences.getString("cartInfo");
    // var data = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> info = [];
    if(cartString == null){
      info = [];
    }else{
      var data = json.decode(cartString.toString());
      info = (data as List).cast();
      checkAll = true;
      totalPrice = 0;
      cartNum = 0;
      info.forEach((item){
        //如果有一个未选中 全选就为false
        if(item["isCheck"] == false){
          checkAll = false;
        }else{
          totalPrice += (double.parse(item["price"]) * item["count"]);
          cartNum += item["count"];
        }
      });
    }
    cartList = info;
    notifyListeners();
  }
  //商品删除
  delCart(goodsId) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cartString = preferences.getString("cartInfo");
    var data = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> info = (data as List).cast();
    int iVal = 0;
    int isGoods = 0;
    info.forEach((item){
      if(item["goodsId"] == goodsId){
        isGoods = iVal;
      }
      iVal++;
    });
    info.removeAt(isGoods);
    cartString = json.encode(info).toString();
    preferences.setString("cartInfo", cartString);
    await getCartInfo();
  }
  //checkbox选择
  isCheck(item) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cartString = preferences.getString("cartInfo");
    var data = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> info = (data as List).cast();
    int iVal = 0;
    int isGoods = 0;
    info.forEach((el){
      if(el["goodsId"] == item["goodsId"]){
        isGoods = iVal;
      }
      iVal++;
    });
    info[isGoods] = item;
    cartString = json.encode(info).toString();
    preferences.setString("cartInfo", cartString);
    await getCartInfo();
  }
  //全选
  allCheck(isCheck) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cartString = preferences.getString("cartInfo");
    var data = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> info = (data as List).cast();
    List<Map> newData = [];
    for(var item in info){
      var newItem = item;
      newItem["isCheck"] = isCheck;
      newData.add(newItem);
    }
    cartString = json.encode(newData).toString();
    preferences.setString("cartInfo", cartString);
    await getCartInfo();
  }
  //点击加号减
  plus(dataItem, todo) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String cartString = preferences.getString("cartInfo");
    var data = cartString == null ? [] : json.decode(cartString.toString());
    List<Map> info = (data as List).cast();
    int index = 0;
    int thisIndex = 0;
    for(var item in info){
      if(item["goodsId"] == dataItem["goodsId"]){
        index = thisIndex;
      }
      thisIndex++;
    }
    if(todo == "add"){
      dataItem["count"]++;
    }else if(dataItem["count"] > 1){
      dataItem["count"]--;
    }
    info[index] = dataItem;
    cartString = json.encode(info).toString();
    preferences.setString("cartInfo", cartString);
    await getCartInfo();
  }
}