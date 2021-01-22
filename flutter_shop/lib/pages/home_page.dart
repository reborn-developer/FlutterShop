import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/model/category.dart';
import 'package:flutter_shop/provide/child_category.dart';
import 'package:flutter_shop/provide/currentIndex.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provide/provide.dart';
import 'package:url_launcher/url_launcher.dart';
import '../service/service_method.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive =>true;

  int page = 1;
  List<Map> hotGoodsList=[];

  EasyRefreshController _controller = EasyRefreshController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formData = {'lon': '115.02932', 'lat': '35.76189'};
    return Scaffold(
        appBar: AppBar(title: Text('生活家')),
        body:FutureBuilder(
          future:request('homePathContext', formData: formData),
          builder: (context,snapshot){
            if(snapshot.hasData){
              // 数据处理
              var data=json.decode(snapshot.data.toString());

              List<Map> swiperDataList = (data['data']['slides'] as List).cast(); // 顶部轮播组件数
              List<Map> navgatorList =(data['data']['category'] as List).cast(); //类别列表
              String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS']; //广告图片
              String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
              String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话
              List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐
              String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片
              List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片
              List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片

              return EasyRefresh(
                controller: _controller,
                footer: ClassicalFooter(
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  infoColor: Colors.pink,
                  showInfo: true,
                  noMoreText: '',
                  loadedText: '加载中...',
                  loadReadyText: '上拉加载',
                ),
                  child: ListView(
                    children: <Widget>[
                      SwiperDiy(swiperDataList:swiperDataList),   //页面顶部轮播组件
                      TopNavigator(navigatorList: navgatorList),
                      AdBanner(adPicture: adPicture),
                      LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone),
                      Recommend(recommendList: recommendList),
                      FloorTitle(picture_address: floor1Title),
                      FloorContent(floorGoodsList: floor1),
                      FloorTitle(picture_address: floor2Title),
                      FloorContent(floorGoodsList: floor2),
                      FloorTitle(picture_address: floor3Title),
                      FloorContent(floorGoodsList: floor3),
                      _hotGoods(),
                    ],
                  ),
                onLoad: () async {
                    print('开始加载更多.....');

                    var formPage = {'page': page};
                    await request('homePageBelowConten', formData: formPage).then((value) {
                      var data = json.decode(value.toString());
                      List<Map> newGoodsList = (data['data'] as List).cast();

                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    });
                },
              );

            }else{
              return Center(
                child: Text('加载中'),
              );
            }
          },
        )
    );

    _controller.callLoad();
  }

  // 首页火爆商品数据
  void _getHotGoods() {
    var formPage = {'page': page};
    request('homePageBelowConten', formData: formPage).then((value) {
      var data = json.decode(value.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();

      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }

  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList() {
    if(hotGoodsList.length!=0) {
      List<Widget> listWidget = hotGoodsList.map((val) {
        return InkWell(
          onTap: () {
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: [
                Image.network(val['image'], width: ScreenUtil().setWidth(370)),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: [
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget
      );
    } else {
      return Text('');
    }
  }

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: [
          hotTitle,
          _wrapList(),
        ],
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
    // print('设备像素密度:${ScreenUtil().pixelRatio}');
    // print('设备的高:${ScreenUtil().screenHeight}');
    // print('设备的宽:${ScreenUtil().screenWidth}');

    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index){
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

/// 首页分类视图
class TopNavigator extends StatelessWidget {
  final List navigatorList;

  TopNavigator({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item, index) {
    return InkWell(
      onTap: (){
        _goCategory(context,index,item['mallCategoryId']);
      },
      child: Column(
        children: [
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName']),
        ],
      ),
    );
  }


  void _goCategory(context, int index, String categoryId) async {

    await request('getCategory').then((val) {
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);

      List list = category.data;

      Provide.value<ChildCategory>(context).changeCategory(categoryId,index);
      Provide.value<ChildCategory>(context).getChildCategory( list[index].bxMallSubDto,categoryId);
      Provide.value<CurrentIndexProvide>(context).changeIndex(1);
    });
  }

  @override
  Widget build(BuildContext context) {

    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, navigatorList.length);
    }

    var tempIndex = -1;
    return Container(
      height: ScreenUtil().setHeight(320),
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(5.0),
        children: navigatorList.map((item) {
          tempIndex++;
          return _gridViewItemUI(context, item, tempIndex);
        }).toList(),
      ),
    );
  }
}

/// 首页广告部分
class AdBanner extends StatelessWidget {
  final String adPicture;

  AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

/// 店长电话模块
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话

  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {

    String url = 'tel:' + leaderPhone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'url不能进行访问，异常';
    }
  }
}

/// 商品推荐
class Recommend extends StatelessWidget {

  final List recommendList;

  Recommend({Key key, this.recommendList}) : super(key: key);

  // 标题方法
  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width:0.5,color:Colors.black12),
        ),
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  // 商品单独项方法
  Widget _item(context, index) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 1, color: Colors.black12),
          )
        ),
        child: Column(
          children: [
            Image.network(recommendList[index]['image'],
            ),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 横向列表方法
  Widget _recommendList() {
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
          return _item(context, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(390),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: [
          _titleWidget(),
          _recommendList(),
        ],
      ),
    );
  }
}

/// 楼层标题
class FloorTitle extends StatelessWidget {
  final String picture_address;
  FloorTitle({Key key, this.picture_address}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

/// 楼层商品列表
class FloorContent extends StatelessWidget {
  final List floorGoodsList;

  FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(BuildContext context) {
    return Row(
      children: [
        _goodsItem(context,floorGoodsList[0]),
        Column(
          children: [
            _goodsItem(context,floorGoodsList[1]),
            _goodsItem(context,floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  Widget _otherGoods(BuildContext context) {
    return Row(
      children: [
        _goodsItem(context,floorGoodsList[3]),
        _goodsItem(context,floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(context, Map goods) {
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: () {
          print('点击了楼层商品');
          Application.router.navigateTo(context, '/detail?id=${goods['goodsId']}');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}












