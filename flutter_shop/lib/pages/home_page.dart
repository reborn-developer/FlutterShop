import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../service/service_method.dart';

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
              // var data=json.decode(snapshot.data.toString());
              // List<Map> swiperDataList = (data['data']['slides'] as List).cast();
              List<Map> swiperDataList = (snapshot.data['data']['slides'] as List).cast(); // 顶部轮播组件数
              return Column(
                children: <Widget>[
                  SwiperDiy(swiperDataList:swiperDataList),   //页面顶部轮播组件
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
    return Container(
      height: 333,
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