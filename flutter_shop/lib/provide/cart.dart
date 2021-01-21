import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = "[]";
  List<CartInfoModel> cartList = [];

  double allPrice =0 ;   //总价格
  int allGoodsCount =0;  //商品总数量

  bool isAllCheck = true; // 是否全选

  // 增加到购物车
  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    var temp = (cartString == null ? [] : json.decode(cartString.toString()));

    List<Map> tempList = (temp as List).cast();
    
    bool isHave = false;
    
    int ival = 0;
    
    tempList.forEach((item) {
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      ival++;
    });

    if(!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId' : goodsId,
        'goodsName' : goodsName,
        'count' : count,
        'price' : price,
        'images' : images,
        'isCheck' : true,
      };

      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));
    }

    cartString = json.encode(tempList).toString();
    // print('字符串${cartString}');
    // print('数据模型${cartList}');

    prefs.setString('cartInfo', cartString);

    notifyListeners();
  }

  // 清空购物车
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    cartList=[];
    print('清空完成--------');
    notifyListeners();
  }

  // 查询
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    cartList = [];

    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> temp = (json.decode(cartString.toString()) as List).cast();

      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;

      temp.forEach((item) {

        if (item['isCheck']) {
          allPrice+=(item['count']*item['price']);
          allGoodsCount+=item['count'];
        } else {
          isAllCheck = false;
        }

        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }

  // 删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    
     List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

     int tempIndex = 0;
     int deleteIndex = 0;

     tempList.forEach((item) {
       if(item['goodsId'] == goodsId) {
         deleteIndex = tempIndex;
       }
       tempIndex++;
     });

     tempList.removeAt(deleteIndex);
     cartString = json.encode(tempList).toString();

     prefs.setString('cartInfo', cartString);

     await getCartInfo();
  }


  // 单个商品选中状态改变
  changeCheckState(CartInfoModel cartInfoModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0;

    tempList.forEach((item) {
      if(item['goodsId'] == cartInfoModel.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList[changeIndex] = cartInfoModel.toJson();
    cartString = json.encode(tempList).toString();

    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }

  // 点击底部全选按钮操作
  changeAllCheckBtnState(bool isCheck) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    List<Map> newList = [];

    for(var item in tempList) {
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString();

    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }

  // 商品数量加减
  addOrReduceAction(var cartItem, String todo) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int changeIndex = 0;

    tempList.forEach((item) {

      if(item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }
      tempIndex ++;
    });

    if(todo == 'add') {
      cartItem.count++;
    } else if(cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson();

    cartString = json.encode(tempList).toString();

    prefs.setString('cartInfo', cartString);

    await getCartInfo();
  }



}