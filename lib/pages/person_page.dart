import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonPage extends StatefulWidget{
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("会员中心"),
      ),
      body: Container(
        color: Colors.black12,
        child: ListView(
          children: <Widget>[
            _head(),
            _center(),
            _centerList(),
            _listTileBox()
          ],
        ),
      ),
    );
  }
  Widget _head(){
    return Container(
      color: Colors.green,
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(300),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:15),
            child: ClipOval(
              child: Image.network("https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1604329688521&di=ed422d568fde7a3265beff9ce91d0b21&imgtype=0&src=http%3A%2F%2F5b0988e595225.cdn.sohucs.com%2Fimages%2F20180329%2F3ceb8069ac0b497da6e2cb023d78be7f.jpeg",width: 80,height: 80,fit: BoxFit.cover,)
            ),
          ),
          Text("Rowrey",style: TextStyle(color: Colors.white),),
        ],
      ),
    );
  }
  Widget _center(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: Icon(Icons.shopping_cart),
        title: Text("订单中心"),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }
  Widget _centerList(){
    return Container(
      color: Colors.white,
      padding:EdgeInsets.only(top: 15,bottom: 15),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(Icons.payment),
              Text("待付款")
            ],
          ),
          Column(
            children: <Widget>[
              Icon(Icons.collections_bookmark),
              Text("待发货")
            ],
          ),
          Column(
            children: <Widget>[
              Icon(Icons.local_mall),
              Text("待收货")
            ],
          ),
          Column(
            children: <Widget>[
              Icon(Icons.event_note),
              Text("待评价")
            ],
          ),
        ],
      )
    );
  }
  Widget _listTileBox(){
    return Container(
      color: Colors.white,
      margin: EdgeInsets.only(top:15),
      child: Column(
        children: <Widget>[
          _listTile("领取优惠卷",Icon(Icons.favorite_border)),
          _listTile("已领取优惠卷",Icon(Icons.favorite)),
          _listTile("地址管理",Icon(Icons.room)),
          _listTile("客服电话",Icon(Icons.phone)),
          _listTile("关于我们",Icon(Icons.account_box)),
        ],
      ),
    );
  }
  Widget _listTile(text,Widget icons){
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListTile(
        leading: icons,
        title: Text(text),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }
}