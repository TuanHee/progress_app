import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplicationLogo extends StatelessWidget {

  final double height;
  final double width;

  const ApplicationLogo({
    Key? key,
    this.height = 75,
    this.width = 75,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: SvgPicture.asset(
        'assets/images/icon.svg',
        semanticsLabel: 'App Logo',
        height: double.infinity,
      ),
    );
  }
}