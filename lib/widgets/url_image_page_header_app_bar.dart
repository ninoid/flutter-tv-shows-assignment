
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:tv_shows/helpers/app_colors.dart';

import 'navigation_back_button.dart';

class UrlImagePageHeaderAppBar implements SliverPersistentHeaderDelegate {
  
  UrlImagePageHeaderAppBar({
    required this.urlImage,
    required this.minExtent,
    required this.maxExtent,
  });

  String urlImage;
  final double minExtent;
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Opacity(
          opacity: opacityForShrinkOffset(shrinkOffset),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: urlImage,
            placeholder: (context, url) => SkeletonAnimation(
              child: Container(),
              shimmerColor: AppColors.skeletonAnimationShimmerColor
            ),
            errorWidget: (context, url, error) => Center(
              child: Icon(
                Icons.warning_amber_outlined, 
                size: maxExtent/3, color: 
                AppColors.grey
              )
            ),
          ),
        ),
        Opacity(
          opacity: opacityForShrinkOffset(shrinkOffset),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white],
                stops: [0.2, 1.0],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                tileMode: TileMode.repeated,
              ),
            ),
          ),
        ),
       
      
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                child: IntrinsicWidth(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: NavigationBackButton(
                        onPresssed: () {
                          Navigator.of(context).pop();
                        },
                        shouldDropShadow: opacityForShrinkOffset(shrinkOffset) < 0.1,
                      ),
                    ),
                  ),
                ),
              ),
            )
      ]
        
      
    );
  }

  double opacityForShrinkOffset(double shrinkOffset) {
    // simple formula: fade out text as soon as shrinkOffset > 0
    return 1.0 - max(0.0, shrinkOffset) / maxExtent;
    // more complex formula: starts fading out text when shrinkOffset > minExtent
    //return 1.0 - max(0.0, (shrinkOffset - minExtent)) / (maxExtent - minExtent);
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }

  @override
  PersistentHeaderShowOnScreenConfiguration? get showOnScreenConfiguration => null;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => null;

  @override
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => null;

  @override
  TickerProvider? get vsync => null;

}