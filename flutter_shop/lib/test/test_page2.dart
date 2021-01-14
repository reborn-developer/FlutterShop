import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TestPage2 extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2> {

  TextEditingController typeController = TextEditingController();
  String showText = '欢迎您来到没好人间';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          appBar: AppBar(title: Text('美好人间'),),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  TextField(
                    controller: typeController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(10.0),
                      labelText: '美女类型',
                      helperText: '请输入你喜欢的类型',
                    ),
                    autofocus: false,
                  ),
                  RaisedButton(
                    onPressed: _chooseAction,
                    child: Text(
                        '选择完毕'
                    ),
                  ),
                  Text(
                    showText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  void _chooseAction() {
    print('开始选择你喜欢的类型.........');
    if (typeController.text.toString() == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(title: Text('美女类型不能为空'))
      );
    } else {

      getHttp(typeController.text.toString()).then((value) {
        setState(() {
          showText = value['data']['name'].toString() + '进入房间';
        });
      });

    }

  }

  Future getHttp(String typeText) async {
    try {
      Response response;
      var data = {'name': typeText};
      response = await Dio().get('https://www.fastmock.site/mock/164c4936eff4b6c1250dd7b2c312c3ec/shop/api/beauty',
          queryParameters: data
      );
      return response.data;

    } catch(e) {
      return print(e);
    }

    try {
      Response response;
      var data = {'name': typeText};
      response = await Dio().post('https://www.easy-mock.com/mock/5c60131a4bed3a6342711498/baixing/dabaojian',
          queryParameters: data
      );
      return response.data;

    } catch(e) {
      return print(e);
    }
  }
}