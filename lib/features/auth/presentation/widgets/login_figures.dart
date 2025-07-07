import 'package:flutter/material.dart';

final figures = [
  Positioned(
    left: 62,
    top: 97,
    child: Container(
      width: 254,
      height: 257,
      decoration: const ShapeDecoration(
        color: Color(0xFFE8FCFF),
        shape: OvalBorder(),
      ),
    ),
  ),
  Positioned(
    left: 95,
    top: 818.91,
    child: Transform(
      transform: Matrix4.identity()
        ..translate(0.0, 0.0)
        ..rotateZ(-0.69),
      child: Container(
        width: 556.06,
        height: 58,
        decoration: const BoxDecoration(color: Color(0xFFE8FCFF)),
      ),
    ),
  ),
  Positioned(
    left: -118,
    top: 435.19,
    child: Transform(
      transform: Matrix4.identity()
        ..translate(0.0, 0.0)
        ..rotateZ(-0.69),
      child: Container(
        width: 265,
        height: 58,
        decoration: const BoxDecoration(color: Color(0xFFE8FCFF)),
      ),
    ),
  ),
];
