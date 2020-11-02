import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_provide.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailInfoL extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo = Provide.value<DetailProvide>(context).goodsInfo;
    return Provide<DetailProvide>(
      builder: (context,child,val){
        if(goodsInfo != null){
          var data = goodsInfo['data']['detail'];
          var isLeft = Provide.value<DetailProvide>(context).isLeft;
          if(isLeft){
            return Container(
              child: Html(
                data: data,
              ),
            );
          }else{
            return Text("评论");
          }
        }
      },
    );
  }
}