import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double width;
  final double height;

  const BrandLogo({
    super.key,
    this.width = 120,
    this.height = 55,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/artbridge_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}