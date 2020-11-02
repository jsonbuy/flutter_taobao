import "package:flutter/material.dart";
import 'package:flutter_app/provide/current_index_provide.dart';
import '../config/index.dart';
import 'home_page.dart';
import 'category_page.dart';
import 'shopping_cart_page.dart';
import 'person_page.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class IndexPage extends StatefulWidget{
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage>{
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(icon: Icon(Icons.home),title:Text(KeyString.homeTitle)),
    BottomNavigationBarItem(icon: Icon(Icons.category),title:Text(KeyString.category)),
    BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),title:Text(KeyString.shopping_cart)),
    BottomNavigationBarItem(icon: Icon(Icons.person),title:Text(KeyString.person)),
  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    ShoppingCartPage(),
    PersonPage()
  ];
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 755,height: 1334)..init(context);
    return Provide<CurrentIndexProvide>(
      builder: (context,child,val){
        //取到当前索引状态值
        int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
        return Scaffold(
          backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            items: bottomTabs,
            onTap: (index){
              Provide.value<CurrentIndexProvide>(context).changeIndex(index);
            },
          ),
          body: IndexedStack(
            index: currentIndex,
            children: tabBodies,
          ),
        );
      },
    );
  }
}