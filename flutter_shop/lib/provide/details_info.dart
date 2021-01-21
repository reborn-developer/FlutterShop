import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel  goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;

  // tabbar的切换方法
  changeLeftAndRight(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }
    notifyListeners();
  }

  // 从后台获取商品详情数据
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await request('getGoodDetailById', formData: formData).then((value) {

      // var responseData = json.decode(value.toString());
      // print(responseData);
      // print(value);

      goodsInfo = DetailsModel.fromJson(value);

      notifyListeners();
    });
  }


}