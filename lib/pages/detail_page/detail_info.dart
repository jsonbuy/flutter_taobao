import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/detail_provide.dart';

class DetalInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailProvide>(
      builder: (context,child,val){
        return Container(
          margin: EdgeInsets.only(top: 15),
          child: Row(
            children: <Widget>[
              Expanded(child: _myTabBar(context,"left"),flex: 1,),
              Expanded(child: _myTabBar(context,"right"),flex: 1,),
            ],
          ),
        );
      },
    );
  }
  Widget _myTabBar(BuildContext context,String fx){
    var isLeft = Provide.value<DetailProvide>(context).isLeft;
    var isRight = Provide.value<DetailProvide>(context).isRight;
    var isBool =  fx == "left" ? isLeft : isRight;
    var title =  fx == "left" ? "详情" : "评论";
    return InkWell(
      onTap: (){
        Provide.value<DetailProvide>(context).changeLR(fx);
      },
      child: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        // width: ScreenUtil().setWidth(370),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color:isBool?Colors.pink:Colors.white
            )
          )
        ),
        child: Text(title,style: TextStyle(color: isBool?Colors.pink:Colors.grey),),
      ),
    );
  }
}