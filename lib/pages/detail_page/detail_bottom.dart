import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/cart_provide.dart';
import '../../provide/detail_provide.dart';
import '../../provide/current_index_provide.dart';

class DetailBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var goodsInfo = Provide.value<DetailProvide>(context).goodsInfo['data'];
    String goodsId = goodsInfo['goodsId'];
    String goodsName = goodsInfo['title'];
    int count = 1;
    String price = goodsInfo['price'];
    String images = goodsInfo['images'][0]["src"];
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: (){
                // await Provide.value<CartProvide>(context).remove();
                Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                Navigator.pop(context);
              },
              child: Container(
                alignment: Alignment.center,
                child: Stack(
                  children: <Widget>[
                    Icon(Icons.shopping_cart,color: Colors.pink,size: 36,),
                    Positioned(
                      top: 0,
                      left: 9,
                      child: Container(
                        width: 18,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.white,
                            width: 1
                          ),
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(18)
                        ),
                        child: Provide<CartProvide>(
                          builder: (context,child,val){
                            String nums = Provide.value<CartProvide>(context).cartNum.toString();
                            return Text(nums,maxLines: 1,style: TextStyle(color: Colors.white,fontSize: 8));
                          },
                        ),
                        // Text("108",maxLines: 1,style: TextStyle(color: Colors.white,fontSize: 8)),
                      ),
                    )
                  ],
                ),
              )
            )
          ),
          Expanded(
            flex: 5, 
            child: InkWell(
              onTap: () async{
                await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                color: Colors.pink,
                child:Text("加入购物",style: TextStyle(color: Colors.white))
              )
            )
          ),
          Expanded(
            flex: 5, 
            child: Container(
              alignment: Alignment.center,
              height: 50,
              color: Colors.green,
              child: Text("立即购买",style: TextStyle(color:Colors.white)),
            )
          ),
        ],
      ),
    );
  }
}