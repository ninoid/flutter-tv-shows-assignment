import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';


class AppCircularProgressIndicator extends StatelessWidget {

  final Color? materialColor;
  final double? materialStrokeWidth;
  final double? materialRadius;
  final double? cupertinoRadius;

  static const double materialDefaultStrokeWidth = 2;

  const AppCircularProgressIndicator({
    Key? key, 
    this.materialColor,
    this.materialStrokeWidth = materialDefaultStrokeWidth,
    this.materialRadius,
    this.cupertinoRadius
  })  : assert(materialRadius != null ? materialRadius > 0 : true), 
        super(key: key);


  AlwaysStoppedAnimation<Color>? get _materialValueColor => 
      materialColor != null ? AlwaysStoppedAnimation<Color>(materialColor!) : null;


  @override
  Widget build(BuildContext context) {
    final circularProgressIndicatorWidget = PlatformCircularProgressIndicator(
      material: (_, __)  => MaterialProgressIndicatorData(
        strokeWidth: materialStrokeWidth,
        valueColor: _materialValueColor,
      ),
      cupertino: (_, __) => CupertinoProgressIndicatorData(
        radius: cupertinoRadius,
      ),
    );
    if (Platform.isAndroid && materialRadius != null) {
      final size = materialRadius! * 2;
      return SizedBox(
        height: size,
        width: size,
        child: circularProgressIndicatorWidget
      );
    }
    return circularProgressIndicatorWidget;
  }
}

