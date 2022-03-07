import 'package:flutter/material.dart';

class BannerAds extends StatefulWidget {
  const BannerAds({Key? key}) : super(key: key);

  @override
  _BannerAdsState createState() => _BannerAdsState();
}

class _BannerAdsState extends State<BannerAds> {
  @override
  Widget build(BuildContext context) {
    return _widget();
  }

  Widget _widget(){
    return Container(color: Colors.red.withAlpha(5));
  }
}
