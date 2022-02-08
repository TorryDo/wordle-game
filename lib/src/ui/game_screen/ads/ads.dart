import 'package:flutter/material.dart';

class Ads extends StatefulWidget {
  const Ads({Key? key}) : super(key: key);

  @override
  _AdsState createState() => _AdsState();
}

class _AdsState extends State<Ads> {
  @override
  Widget build(BuildContext context) {
    return _widget();
  }

  Widget _widget(){
    return Container(color: Colors.red);
  }
}
