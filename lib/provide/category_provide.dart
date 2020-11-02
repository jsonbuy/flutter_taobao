import 'package:flutter/material.dart';

class Sort with ChangeNotifier{
  List sortChildList = [];
  int childIndex = 0;
  changeSortChildList(val){
    Map all = {};
    all["secondCategoryName"] = "全部";
    all["secondCategoryId"] = "0";
    sortChildList = [all];
    sortChildList.addAll(val);
    notifyListeners();
  }
  changeChindIndex(val){
    childIndex = val;
  }
}

class CategoryGoodsList with ChangeNotifier {
  List goodsList = [];
  List goodsListAll = [];
  changeGoodsList(val){
    goodsList = val;
    notifyListeners();
  }
  changeGoodsListAll(val){
    goodsListAll = val;
    notifyListeners();
  }
}