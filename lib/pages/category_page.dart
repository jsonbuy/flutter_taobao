import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_app/service/http_service.dart';
import 'dart:convert';
import '../config/index.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/category_provide.dart';

class CategoryPage extends StatefulWidget{
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>{
  List sortList = [];
  int listIndex = 0;

  @override
  void initState() {
    super.initState();
    _getSort();
    _getGoodsList("1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("分类列表"),),
      body: Container(
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(180),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color:Colors.grey,width: 0.5),
                ),
              ),
              child:ListView.builder(
                itemCount: sortList.length,
                itemBuilder: (context, index){
                  return _listGrid(index);
                },
              )
            ),
            Column(
              children: <Widget>[
                CategoryChild(),//子导航
                GoodsChildList(),//商品列表
              ],
            ),
          ],
        ),
      )
    );
  }
  void _getSort() async{
    request("sortServer").then((val){
      var data = json.decode(val.toString());
      List sortData = (data["data"] as List).cast();
      //初始化第一个子导航
      Provide.value<Sort>(context).changeSortChildList(sortData[0]["secondCategoryVO"]);
      setState(() {
        sortList = sortData;
      });
    });
  }
  Widget _listGrid(int index){
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
      return InkWell(
        onTap: (){
          setState(() {
            listIndex = index;
          });
          List childList = sortList[index]["secondCategoryVO"];
          String goodsId = sortList[index]["firstCategoryId"];
          Provide.value<Sort>(context).changeSortChildList(childList);
          Provide.value<Sort>(context).changeChindIndex(0);
          _getGoodsList(goodsId);
        },
        child: Container(
          height: ScreenUtil().setHeight(100),
          padding: EdgeInsets.only(left:10,right:10),
          decoration: BoxDecoration(
            color: isClick ? Color.fromRGBO(244, 244, 244, 1.0) :Colors.white,
            border: Border(
              bottom: BorderSide(width: 0.5,color: Colors.grey),
            ),
          ),
          child: Text(
            sortList[index]["firstCategoryName"],
            style: TextStyle(fontSize: ScreenUtil().setSp(28),height: 2.5),
          ),
        ),
      );
  }
  
  //获取商品列表
  void _getGoodsList(goodsId) async{
    var formData = {
      "id": goodsId
    };
    request("CategoryGoodsServer",formData:formData).then((val){
      var data = json.decode(val.toString());
      List goodsList = (data["data"]["secondCategoryVO"] as List).cast();
      Provide.value<CategoryGoodsList>(context).changeGoodsList(goodsList);
      Provide.value<CategoryGoodsList>(context).changeGoodsListAll(goodsList);
    });
  }
}
//子类
class CategoryChild extends StatefulWidget {
  @override
  _CategoryChildState createState() => _CategoryChildState();
}

class _CategoryChildState extends State<CategoryChild> {
  // int childIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Provide<Sort>(
      builder: (context,child,value){
        return Container(
          height: ScreenUtil().setHeight(80.0),
          width: ScreenUtil().setWidth(575.0),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey,width: 0.5)
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: value.sortChildList.length,
            itemBuilder: (context,index){
              return _listVierItem(value.sortChildList[index],index);
            },
          ),
        );
      },
    );
  }
  Widget _listVierItem(Map item,index){
    bool chlidSelect = Provide.value<Sort>(context).childIndex == index ? true : false;
    return InkWell(
      onTap: (){
        setState(() {
          Provide.value<Sort>(context).childIndex = index;
        });
        List goodsListAll = Provide.value<CategoryGoodsList>(context).goodsListAll;
        String secondId = item["secondCategoryId"];
        //如果为0则为全部类型
        if(secondId == "0"){
          Provide.value<CategoryGoodsList>(context).changeGoodsList(goodsListAll);
          return;
        }
        //看大类是否有数据 没有数据返回空数组
        if(goodsListAll.length > 0){
          //看小类是否有数据
          bool hasId = false;
          goodsListAll.map((val){
            if(val["secondCategoryId"] == secondId ){
              hasId = true;
              Provide.value<CategoryGoodsList>(context).changeGoodsList([val]);
            }
          }).toList();
          if(!hasId){
              Provide.value<CategoryGoodsList>(context).changeGoodsList([]);
          }
        }else{
          Provide.value<CategoryGoodsList>(context).changeGoodsList([]);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left:10,right:10),
        color: chlidSelect ? KeyColor.primayColor : Colors.white,
        child: Text(
          item["secondCategoryName"],
          style: TextStyle(height: 2.3,fontSize: ScreenUtil().setSp(24)),
        ),
      ),
    );
  }
}

//子商品列表
class GoodsChildList extends StatefulWidget {
  @override
  _GoodsChildListState createState() => _GoodsChildListState();
}

class _GoodsChildListState extends State<GoodsChildList> {
  var controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsList>(
      builder:(context,child,val){
        //如果有分页 让page为1的时候返回顶部
        //这里好像有bug 需要捕获 
        try{
          controller.jumpTo(0.0);
        }catch(e){}
        List goodsList = [];
        if(val.goodsList.length == 0){
          return Text("没有数据");
        }
        val.goodsList.map((val){
          goodsList.addAll(val["goods"]);
        }).toList();
        return Expanded(
          child: Container(
            width: ScreenUtil().setWidth(575.0),
            // height: ScreenUtil().setHeight(1050.0),
            child: ListView.builder(
              controller: this.controller,
              scrollDirection: Axis.vertical, 
              itemCount: goodsList.length,
              itemBuilder:(context,index){
                return _goodsItem(goodsList[index]);
              }
            ),
          ),
        );
      },
    );
  }
  Widget _goodsItem(Map item){
    return InkWell(
      onTap: (){

      },
      child: Container(
        width: ScreenUtil().setWidth(575.0),
        height: ScreenUtil().setHeight(230.0),
        padding: EdgeInsets.only(top:5,left:5,right:5),
        // margin: EdgeInsets.only(top:10.0),
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(200),
              child:Stack(
                // overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    left: 0,
                    top: 0,
                    child:Container(
                      width: ScreenUtil().setWidth(200),
                      child:Image.network(item["image"]),
                    )
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child:Offstage(
                      //如果lable为空就不显示
                      offstage: item["label"] == "" ? true : false,
                      child: Container(
                        color: KeyColor.primayColor,
                        padding: EdgeInsets.all(8.0),
                        child: Text(item["label"],style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(22))),
                      ),
                    )
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(330.0),
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        item["name"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: ScreenUtil().setSp(22)),
                      ),
                    ),
                    Text(item["brand"],style: TextStyle(color: KeyColor.primayColor,fontSize: ScreenUtil().setSp(22))),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("\$${item["price"].toString()}"),
                          Text("\$${item["oriPrice"].toString()}",style: TextStyle(decoration: TextDecoration.lineThrough),),
                        ],
                      ),
                    )
                  ],
                ),
            )
          ],
        ),
      )
    );
  }
}