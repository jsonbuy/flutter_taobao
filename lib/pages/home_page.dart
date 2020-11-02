import 'package:dio/dio.dart';
import "package:flutter/material.dart";
import 'package:flutter_app/service/http_service.dart';
import 'package:provide/provide.dart';
import '../config/index.dart';
import 'dart:convert';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget{
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  
  int page = 1;
  List hotGoodList = [];

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  void initState() {
    _hotGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
      // appBar: AppBar(title: Text('${KeyString.homeTitle}')),
      body: FutureBuilder(
        future: request('homePageServer',formData: null),
        builder: (context, snapshot){
          if(snapshot.hasData){
            var data = json.decode(snapshot.data.toString());
            List<Map> swiperDataList = (data['data']['slides'] as List).cast();
            List<Map> topNavigation = (data['data']['category'] as List).cast();
            List<Map> recommendList = (data['data']['recommend'] as List).cast();
            List<Map> floor1 = (data["data"]["floor1"] as List).cast();
            Map floorPic = data['data']['floor1Pic'];
            return EasyRefresh(
              refreshFooter: ClassicsFooter(
                key: _footerKey,
                bgColor: Colors.white,
                textColor: Colors.blueGrey,
                moreInfoColor: Colors.blueGrey,
                showMore: true,
                noMoreText: 'no more',
                moreInfo: '加载中',
                loadReadyText: '上拉加载',
              ),
              child: ListView(
                children: <Widget>[
                  SwiperDiy(swiperDataList:swiperDataList),
                  TopNavigator(navGavigator: topNavigation),
                  ProductsFeatured(recommendList: recommendList),
                  FloorPic(floorPic: floorPic),
                  FloorOne(floor1: floor1),
                  HotGoods(hotGoods:hotGoodsList())
                ],
              ),
              loadMore: () async {
                this._hotGoods();
              },
            );
          }else{
            return Container(child: Text("加载中"));
          }
        },
      ),
    );
  }
  void _hotGoods(){
    // var formPage = {"page": page};
    request("hotGoodsServer").then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodList = (data["data"] as List).cast();
      setState(() {
        hotGoodList.addAll(newGoodList);
        // page++;
      });
    });
  }
  Widget hotGoodsList(){
    if(hotGoodList.length == 0){
      return Text('');
    }
    List<Widget> listWidget = hotGoodList.map((el){
      return InkWell(
        onTap: (){
          Application.router.navigateTo(context, "detail?id=${el['goodsId']}");
        },
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
          width: ScreenUtil().setWidth(350),
          child: Column(
            children: <Widget>[
              Image.network(el["image"]),
              Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('\$${el["presentPrice"]}'),
                    Text('\$${el["oriPrice"]}',style: TextStyle(decoration: TextDecoration.lineThrough),),
                  ],
                ),
              ),
              Text(el["name"],maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: ScreenUtil().setSp(24)),)
            ],
          ),
        ),
      );
    }).toList();
    return Wrap(
      spacing: 2,
      children: listWidget,
    );
  }
}
//火爆专区
class HotGoods extends StatelessWidget{
  final Widget hotGoods;
  HotGoods({Key key,this.hotGoods}):super(key:key);
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top:10.0),
      padding: EdgeInsets.only(left:10.0),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Text("火爆专区",
              style: TextStyle(color:Colors.blueGrey,fontSize:ScreenUtil().setSp(28)),
            ),
          ),
          hotGoods,
        ],
      ),
    );
  }
}

//首页轮播banner
class SwiperDiy extends StatelessWidget{
  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.white,
      width: ScreenUtil().setWidth(1125),
      height: ScreenUtil().setHeight(320),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context, "detail?id=${swiperDataList[index]['goodsId']}");
            },
            child: Image.network("${swiperDataList[index]['image']}",fit: BoxFit.cover),
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}
//分类导航组件
class TopNavigator extends StatelessWidget{
  final List navGavigator;
  TopNavigator({Key key,this.navGavigator}):super(key:key);

  Widget _gridViewItemUI(BuildContext context,item,index){
    return InkWell(
      onTap: (){
        //跳转到分类页面
      },
      child: Container(
        // margin: EdgeInsets.only(top:10),
        //  transform: Matrix4.translationValues(0, -10, 0),
        child: Column(
          children: <Widget>[
            Image.network(item["image"],width: ScreenUtil().setWidth(140)),
            Text(item["firstCategoryName"],style: TextStyle(fontSize: ScreenUtil().setSp(22)),)
          ],
        )
      )
    );
  }
  @override
  Widget build(BuildContext context){
    if(navGavigator.length > 10){
      navGavigator.removeRange(10, navGavigator.length);
    }
    var temIndex = 1;
    return Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 10),
        // padding: EdgeInsets.only(top: 10),
        height: ScreenUtil().setHeight(320),
        child: GridView.count(
          //禁止滚动
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.only(top: 2.0),
          // childAspectRatio: 10/9,
          children: navGavigator.map((item){
            temIndex++;
            return _gridViewItemUI(context,item, temIndex);
          }).toList(),
        ),
      );
  }
}
//商品推荐
class ProductsFeatured extends StatelessWidget{
  final List recommendList;
  ProductsFeatured({Key key,this.recommendList}):super(key:key);

  Widget _titleWidget(){
    return Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border(
          //   bottom: BorderSide(width: 0.5,color: Colors.grey)
          // )
        ),
        child: Text(
          "商品推荐",
          style:TextStyle(color:Colors.blueGrey,fontSize: ScreenUtil().setSp(28))
        ),
      );
  }

  Widget _productList(BuildContext context){
    return Container(
      height: ScreenUtil().setHeight(430),
      decoration: BoxDecoration(
        border: Border.all(color:Colors.grey,width:1)
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return this._item(index, context);
        },
      ),
    );
  }

  Widget _item(index, context){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, "detail?id=${recommendList[index]['goodsId']}");
      },
      child: Container(
        width: ScreenUtil().setWidth(300),
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color:Colors.grey,width:1))
        ),
        child: Column(
          children: <Widget>[
            //防止溢出
            Expanded(
              child: Image.network(recommendList[index]["image"])
            ),
            Container(
                padding: EdgeInsets.fromLTRB(0, 8.0, 0, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${recommendList[index]['presentPrice']}",
                      style: TextStyle(
                        color: Colors.blueGrey
                      ),
                    ),
                    Text(
                      "\$${recommendList[index]['oriPrice']}",
                      style: KeyFont.oriPriceStyle
                    )
                  ]
                ),
            ),
            Row(
              children:[
                Expanded(
                  child: Text(
                    recommendList[index]["name"],
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: ScreenUtil().setSp(22)),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context){
    return Container(
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        children: <Widget>[
          _titleWidget(),
          _productList(context)
        ],
      ),
    );
  }
}

class FloorPic extends StatelessWidget{
  final Map floorPic;
  FloorPic({Key key,this.floorPic}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
      margin: EdgeInsets.only(top:10),
      child: InkWell(
        child: Image.network(floorPic["picture_address"]),
        onTap: (){},
      ),
    );
  }
}

class FloorOne extends StatelessWidget{
  final List floor1;
  FloorOne({Key key,this.floor1}):super(key:key);
  
  @override
  Widget build(BuildContext context){
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  padding: EdgeInsets.only(right:2),
                  child: InkWell(
                    child: Image.network(floor1[0]["image"],fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.fromLTRB(0, 2, 2, 0),
                  child: InkWell(
                    child: Image.network(floor1[1]["image"],fit: BoxFit.cover),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: InkWell(
                    child: Image.network(floor1[2]["image"],fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.only(top:2),
                  child: InkWell(
                    child: Image.network(floor1[3]["image"],fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 200,
                  padding: EdgeInsets.only(top:2),
                  child: InkWell(
                    child: Image.network(floor1[4]["image"],fit: BoxFit.cover),
                  ),
                ),
              ],
            )
          )
        ],
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

}