import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

/// Provide状态管理使用
class TestPage3 extends StatefulWidget {
  @override
  _TestPage3State createState() => _TestPage3State();
}

class _TestPage3State extends State<TestPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Number(),
              MyButton()
            ],
          )
      ),
    );  }
}

class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top:200),
      child: Provide<Counter>(
        builder: (context,child,counter){
          return Text(
            '${counter.value}',
            style: Theme.of(context).textTheme.display1,
          );
        },
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: (){
          Provide.value<Counter>(context).increment();
        },
        child: Text('递增'),
      ),
    );
  }
}

