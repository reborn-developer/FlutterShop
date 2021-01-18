import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_shop/pages/index_page.dart';
import 'package:provide/provide.dart';
import './provide/counter.dart';
import './provide/child_category.dart';

void main() {
  var counter = Counter();
  var childCategory = ChildCategory();
  var provides = Providers();
  provides
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory));
  runApp(ProviderNode(child: MyApp(), providers: provides));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      allowFontScaling: false,
      child: Container(
        child: MaterialApp(
          title: "电商",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.pink,
          ),
          home: IndexPage(),
        ),
      ),
    );
  }
}

