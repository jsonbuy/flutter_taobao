import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';

class CartBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var totalPrice = Provide.value<CartProvide>(context).totalPrice;
    var cartNum = Provide.value<CartProvide>(context).cartNum;
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(width: 1,color: Colors.black12),
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Row(
              children: <Widget>[
                Checkbox(
                  onChanged: (val){
                    Provide.value<CartProvide>(context).allCheck(val);
                  },
                  activeColor: Colors.red,
                  value: Provide.value<CartProvide>(context).checkAll,
                ),
                Text("全选")
              ],
            )
          ),
          Expanded(
            flex: 4,
            child: Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(5.0),
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text("合计：",style: TextStyle(fontSize: 14)),
                      Text("￥${totalPrice}",style: TextStyle(fontSize: 16,color:Colors.red)),
                    ],
                  ),
                  Text("满300元免配送费，预定免配送费，配送到家",
                    maxLines: 2,
                    style: TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            )
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 60,
              alignment: Alignment.center,
              color: Colors.green,
              child: Text("结算(${cartNum})",style: TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}