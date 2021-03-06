import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage4 extends StatefulWidget {
  @override
  _TestPage4State createState() => _TestPage4State();
}

class _TestPage4State extends State<TestPage4> {
  List<String> testList = [];

  @override
  Widget build(BuildContext context) {
    _show();
    return Container(
      child: Column(
        children: [
          Container(
            height: 500,
            child: ListView.builder(
                itemCount: testList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        testList[index]
                    ),
                  );
                }
            ),
          ),

          RaisedButton(
            onPressed:(){_add();},
            child: Text(
                '增加'
            ),
          ),

          RaisedButton(
            onPressed:(){_clear();},
            child: Text(
                '清空'
            ),
          ),

        ],
      ),
    );
  }

  // 增加方法
  void _add() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temp = '嘻嘻嘻';
    testList.add(temp);
    prefs.setStringList('testInfo', testList);
    _show();
  }

  // 查询
  void _show() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getStringList('testInfo') != null) {
      setState(() {
        testList = prefs.getStringList('testInfo');
      });
    }
  }

  // 删除
  void _clear() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.clear(); // 删除全部
    prefs.remove('testInfo');

    setState(() {
      testList = [];
    });
  }
}
