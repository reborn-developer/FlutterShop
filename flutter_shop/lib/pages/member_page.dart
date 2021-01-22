import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MemberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('会员中心')
      ),
      body: ListView(
        children: [
          _topHeadr(),
          _orderTitle(),
          _orderType(),
          _actionList(),
        ],
      ),
    );
  }

  Widget _topHeadr() {
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.all(20),
      color: Colors.pinkAccent,
      child: Column(
        children: [
          Container(
            width: ScreenUtil().setWidth(100),
            margin: EdgeInsets.only(top: 30.0),
            child: ClipOval(
              child: Image.network('https://pics5.baidu.com/feed/42a98226cffc1e17ea273e1a00e82605728de984.jpeg?token=4cbdbe3238d0761dcc71727d73aae348'),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: Text(
              'reborn',
              style: TextStyle(
                color: Colors.black54,
                fontSize: ScreenUtil().setSp(36),
              ),
            ),
          ),
        ],
      )
    );
  }

  // 我的订单标题
  Widget _orderTitle() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        )
      ),
      child: ListTile(
        leading: Icon(Icons.list),
        title: Text(
          '我的订单',
        ),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  //
  Widget _orderType() {
    return Container(
      margin: EdgeInsets.only(top: 5),
      width: ScreenUtil().setWidth(750),
      height: ScreenUtil().setHeight(150),
      padding: EdgeInsets.only(top: 20),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: [
                Icon(Icons.query_builder,
                size: 30,
                ),
                Text('待付款'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: [
                Icon(Icons.party_mode,
                  size: 30,
                ),
                Text('待发货'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: [
                Icon(Icons.directions_car,
                  size: 30,
                ),
                Text('待收货'),
              ],
            ),
          ),

          Container(
            width: ScreenUtil().setWidth(187),
            child: Column(
              children: [
                Icon(Icons.content_paste,
                  size: 30,
                ),
                Text('待评价'),
              ],
            ),
          ),

        ],
      ),
    );
  }

  // 通用ListTile
  Widget _myListTile(String title) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.black12),
        )
      ),
      child: ListTile(
        leading: Icon(Icons.blur_circular),
        title: Text(title),
        trailing: Icon(Icons.arrow_right),
      ),
    );
  }

  Widget _actionList() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _myListTile('领取优惠券'),
          _myListTile('已领取优惠券'),
          _myListTile('地址管理'),
          _myListTile('客服电话'),
          _myListTile('关于我们'),
        ],
      ),
    );
  }
}

