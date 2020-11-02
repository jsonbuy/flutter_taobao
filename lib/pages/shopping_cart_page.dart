import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/cart_provide.dart';
import './shopping_cart_page/cart_list.dart';
import './shopping_cart_page/cart_bottom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("购物车"),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot){
          if(snapshot.hasData){
            List cartList = Provide.value<CartProvide>(context).cartList;
            return Provide<CartProvide>(
              builder: (context,child,val){
                cartList = Provide.value<CartProvide>(context).cartList;
                return Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(bottom:ScreenUtil().setHeight(130)),
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context,index){
                          // print(cartList[index]["goodsName"]);
                          return CartList(cartList[index]);
                        }
                      ),
                    ),
                    Positioned(
                      left: 0,
                      bottom: 0,
                      child: CartBottom(),
                    ),
                  ],
                );
              },
            );
          }else{
            return Text("加载中");
          }
        },
      ),
    );
  }
  Future<String> _getCartInfo(context) async{
    await Provide.value<CartProvide>(context).getCartInfo();
    return "ok";
  }
}