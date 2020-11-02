import 'package:flutter/material.dart';
import 'package:flutter_app/provide/cart_provide.dart';
import 'package:flutter_app/provide/current_index_provide.dart';
import './pages/index_page.dart';
import './config/index.dart';
import './provide/current_index_provide.dart';
import 'package:provide/provide.dart';
import './provide/category_provide.dart';
import './provide/detail_provide.dart';
import 'package:fluro/fluro.dart';
import './routers/routers.dart';
import './routers/application.dart';
// import 'package:flutter/services.dart';
// void main() => runApp(MyApp());
void main(){
  var currentIndexProvide = CurrentIndexProvide();
  var sortChildChange = Sort();
  var categoryGoodsChange = CategoryGoodsList();
  var detailProvide = DetailProvide();
  var providers = Providers();
  var cartProvide = CartProvide();

  providers
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategoryGoodsList>.value(categoryGoodsChange))
    ..provide(Provider<DetailProvide>.value(detailProvide))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<Sort>.value(sortChildChange));
    //  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    // .then((_) {
        runApp(ProviderNode(child: MyApp(),providers: providers));
    // });
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    //路由配置
    final router =  Router();
    Routes.configureRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: KeyString.mainTitle,//flutter商城
        onGenerateRoute: Application.router.generator,//配置路由
        debugShowCheckedModeBanner: false,//隐藏右上角debugger
        theme: ThemeData(
          primaryColor: KeyColor.primayColor,//主题颜色
        ),
        home: IndexPage()
      )
    );
  }
}

