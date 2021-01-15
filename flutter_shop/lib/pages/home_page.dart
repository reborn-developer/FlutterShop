import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String homePageContent = '正在获取数据';

  // @override
  // void initState() {
  //   getHomePageContent().then((val){
  //     setState(() {
  //       homePageContent=val.toString();
  //     });
  //
  //   });
  //   super.initState();
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('百姓生活+'),),
        body:FutureBuilder(
          future:getHomePageContent(),
          builder: (context,snapshot){
            print('snapshot====${snapshot.data}==========');
            if(snapshot.hasData){
              // 数据处理
              // var data=json.decode(snapshot.data.toString());
              // List<Map> swiperDataList = (data['data']['slides'] as List).cast();
              List<Map> swiperDataList = (snapshot.data['data']['slides'] as List).cast(); // 顶部轮播组件数
              List<Map> navgatorList = (snapshot.data['data']['category'] as List).cast(); // 顶部轮播组件数

              return Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList:swiperDataList),   //页面顶部轮播组件
                  TopNavigator(navigatorList: navgatorList),
                ],
              );
            }else{
              return Center(
                child: Text('加载中'),
              );
            }
          },
        )
    );
  }
}

/// 首页轮播组件
class SwiperDiy extends StatelessWidget {

  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('设备像素密度:${ScreenUtil().pixelRatio}');
    print('设备的高:${ScreenUtil().screenHeight}');
    print('设备的宽:${ScreenUtil().screenWidth}');

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill);
          // return Image.network("https://images.baixingliangfan.cn/advertesPicture/20210107/20210107183730_1422.jpg",fit:BoxFit.fill);
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

///
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: [
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}
