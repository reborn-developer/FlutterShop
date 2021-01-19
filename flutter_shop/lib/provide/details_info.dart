import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {

  DetailsModel  goodsInfo = null;

  // 从后台获取商品详情数据
  getGoodsInfo(String id) {
    var formData = {'goodId': id};
    request('getGoodDetailById', formData: formData).then((value) {

      // var responseData = json.decode(value.toString());
      // print(responseData);
      print(value);

      goodsInfo = DetailsModel.fromJson(value);

      notifyListeners();
    });
  }
}