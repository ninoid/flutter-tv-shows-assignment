import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavigationBackButton extends StatelessWidget {
  
  final VoidCallback? onPresssed;
  final bool shouldDropShadow;
  final double size;

  const NavigationBackButton({
    required this.onPresssed,
    this.shouldDropShadow = true,
    this.size = 32,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: size,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: shouldDropShadow ? Colors.grey : Colors.transparent,
                blurRadius: 2,
                spreadRadius: 0.2
              ),
            ]
          ),
        ),
        PlatformIconButton(
          icon: SvgPicture.asset(
            "assets/svg/ic-navigate-back.svg",
            height: size,
          ),
          padding: EdgeInsets.zero,
          onPressed: onPresssed,
        )
      ],
    );
  
  }
}