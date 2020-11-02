import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_provide.dart';

class SwiperProduct extends StatelessWidget {
  final List swiperList;
  SwiperProduct({Key key,this.swiperList}):super(key:key);
  @override
  Widget build(BuildContext context) {
    return Provide<DetailProvide>(
      builder: (context,child,val){
          var goodsInfo = Provide.value<DetailProvide>(context).goodsInfo;
          if(goodsInfo != null){
            var data = goodsInfo['data'];
            return Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _getSwiperProduct(data),
                  _getTitle(data),
                  _getDescription(data)
                ],
              ),
            );
          }else{
            return Text("加载中");
          }
      }
    );
  }
}
//头部商品展示
Widget _getSwiperProduct(data){
  List swiperList = data['images'];
  return Container(
    width: ScreenUtil().setWidth(1125),
    height: ScreenUtil().setHeight(720),
    child: Swiper(
      itemCount: swiperList.length,
      pagination: SwiperPagination(),
      autoplay: false,
      itemBuilder: (BuildContext context, int index){
        return InkWell(
          onTap: (){},
          child: Image.network("${swiperList[index]['src']}",fit:BoxFit.cover,),
        );
      },
    ),
  );
}

Widget _getTitle(data){
  return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text('${data["title"]}',style: TextStyle(fontSize: ScreenUtil().setSp(40.0))),
    );
}

Widget _getDescription(data){
  return Padding(
      padding: EdgeInsets.all(5.0),
      child: Text(
        '${data["description"]}',
        textAlign: TextAlign.left,
        style: TextStyle(color: Colors.grey,fontSize: ScreenUtil().setSp(30.0))
      ),
    );
}