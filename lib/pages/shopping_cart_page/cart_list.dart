import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';

class CartList extends StatelessWidget {
  final Map item;
  CartList(this.item);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2.0),
      margin: EdgeInsets.only(bottom:2.0),
      height: ScreenUtil().setHeight(180),
      width: ScreenUtil().setWidth(755),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          _checkBox(context),
          _images(),
          _title(context),
        ],
      )
    );
  }
  Widget _checkBox(context){
    return Checkbox(
      onChanged: (val){
        item["isCheck"] = val;
        Provide.value<CartProvide>(context).isCheck(item);
      },
      activeColor: Colors.red,
      value: item["isCheck"],
    );
  }
  Widget _images(){
    return Container(
      width: ScreenUtil().setWidth(150),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.black12,
        )
      ),
      child: Image.network(item["images"]),
    );
  }
  Widget _title(context){
    return Container(
      width: ScreenUtil().setWidth(470),
      padding: EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(item["goodsName"],maxLines: 1,style: TextStyle(fontSize: ScreenUtil().setSp(30)),),
          _price(context),
          _number(context)
        ],
      ),
    );
  }
  Widget _number(context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          height: ScreenUtil().setHeight(60),
          width: ScreenUtil().setWidth(225),
          margin: EdgeInsets.only(top:5),
          decoration: BoxDecoration(
            border: Border.all(
              width:1,
              color: Colors.black12
            )
          ),
          child: Row(
            children: <Widget>[
              InkWell(
                onTap: (){
                  Provide.value<CartProvide>(context).plus(item,"plus");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setHeight(60),
                  decoration: BoxDecoration(
                    color: item["count"] > 1 ? Colors.white : Colors.black12,
                    border: Border(
                      right: BorderSide(
                        width: 1,
                        color: Colors.black12
                      )
                    )
                  ),
                  child: Text("-",style: TextStyle(fontSize: ScreenUtil().setSp(40))),
                ),
              ),
              Container(
                width: ScreenUtil().setWidth(100),
                height: ScreenUtil().setHeight(60),
                alignment: Alignment.center,
                child: Text("${item["count"]}"),
              ),
              InkWell(
                onTap: (){
                  Provide.value<CartProvide>(context).plus(item, "add");
                },
                child: Container(
                  alignment: Alignment.center,
                  width: ScreenUtil().setWidth(60),
                  height: ScreenUtil().setHeight(60),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 1,
                        color: Colors.black12
                      )
                    )
                  ),
                  child: Text("+",style: TextStyle(fontSize: ScreenUtil().setSp(30))),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top:5.0,right: 10),
          child: InkWell(
            onTap: (){
              // print(item["goodsId"]);
              Provide.value<CartProvide>(context).delCart(item["goodsId"]);
            },
            child: Icon(Icons.delete),
          )
        )
      ],
    );
  }
  Widget _price(context){
    return Container(
      // width: ScreenUtil().setWidth(350),
      padding: EdgeInsets.only(top:3),
      child: Text("￥${item['price']}",style: TextStyle(color: Colors.red)),
    );
  }
}