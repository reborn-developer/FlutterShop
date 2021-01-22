import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/pages/home_page.dart';
import 'package:flutter_shop/pages/category_page.dart';
import 'package:flutter_shop/pages/cart_page.dart';
import 'package:flutter_shop/pages/member_page.dart';
import 'package:flutter_shop/test/test_page3.dart';
import '../provide/currentIndex.dart';
import 'package:provide/provide.dart';

class IndexPage extends StatelessWidget {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text('首页'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text('分类'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text('购物车'),
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.profile_circled),
      title: Text('会员中心'),
    )
  ];

  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];


  @override
  Widget build(BuildContext context) {
    return Provide<CurrentIndexProvide>(
        builder: (context, child, val) {
          int currentIndex = Provide.value<CurrentIndexProvide>(context).currentIndex;
          return Scaffold(
            backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              items: bottomTabs,
              onTap: (index) {
                Provide.value<CurrentIndexProvide>(context).changeIndex(index);
              },
            ),
            // body: currentPage,
            body: IndexedStack(
              index: currentIndex,
              children: [
                // 注意此处直接用tabBodies数组有问题
                HomePage(),
                CategoryPage(),
                CartPage(),
                MemberPage()
              ],
            ),
          );
        }
    );
  }
}


// class IndexPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _IndexPageState();
// }
//
// class _IndexPageState extends State<IndexPage> {
//   final List<BottomNavigationBarItem> bottomTabs = [
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.home),
//       title: Text('首页'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.search),
//       title: Text('分类'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.shopping_cart),
//       title: Text('购物车'),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(CupertinoIcons.profile_circled),
//       title: Text('会员中心'),
//     )
//   ];
//
//   final List<Widget> tabBodies = [
//     HomePage(),
//     CategoryPage(),
//     CartPage(),
//     MemberPage()
//   ];
//
//   int currentIndex = 0;
//   // var currentPage;
//
//   @override
//   void initState() {
//     // currentPage = tabBodies[0];
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromRGBO(244, 245, 245, 1.0),
//         bottomNavigationBar: BottomNavigationBar(
//           type: BottomNavigationBarType.fixed,
//           currentIndex: currentIndex,
//           items: bottomTabs,
//           onTap: (index) {
//             setState(() {
//               currentIndex = index;
//               // currentPage = tabBodies[index];
//             });
//           },
//         ),
//         // body: currentPage,
//         body: IndexedStack(
//             index: currentIndex,
//             children: [
//               // 注意此处直接用tabBodies数组有问题
//               HomePage(),
//               CategoryPage(),
//               CartPage(),
//               MemberPage()
//             ],
//         ),
//     );
//   }
// }