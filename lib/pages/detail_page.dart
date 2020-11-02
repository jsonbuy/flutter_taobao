import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/detail_provide.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import './detail_page/detail_top.dart';
import './detail_page/detail_info.dart';
import './detail_page/detail_info_l.dart';
import './detail_page/detail_bottom.dart';

class DetailPage extends StatelessWidget {
  final String goodsId;
  DetailPage(this.goodsId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text("商品详情"),
      ),
      body:FutureBuilder(
          future: _getDetail(context),
          builder: (context,snapshot){
            if(snapshot.hasData){
              return Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(bottom:50),
                    child: ListView(
                      children: <Widget>[
                        SwiperProduct(),
                        DetalInfo(),
                        DetailInfoL()
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: DetailBottom()
                  )
                ],
              );
            }else{
              return Text("加载中");
            }
          },
        )
    );
  }
  Future _getDetail(BuildContext context) async{
    await Provide.value<DetailProvide>(context).getGoodsInfo(goodsId);
    return "加载完成";
  }
}