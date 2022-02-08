import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatefulWidget {
  final String uri;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? color;

  final Function()? onClick;

  const SvgIcon({Key? key,
    required this.uri,
    this.width,
    this.height,
    this.backgroundColor,
    this.color,
    this.onClick})
      : super(key: key);

  @override
  _SvgIconState createState() => _SvgIconState();
}

class _SvgIconState extends State<SvgIcon> {
  @override
  Widget build(BuildContext context) {
    return _outer();
  }

  Widget _outer() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backgroundColor,
      child: SvgPicture.asset(widget.uri, color: widget.color),
    );
  }

}
