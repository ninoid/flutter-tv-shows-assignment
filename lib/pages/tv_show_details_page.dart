import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:tv_shows/bloc/tv_show_details_page/tv_show_details_page_cubit.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/core/localization/app_localization.dart';
import 'package:tv_shows/data/models/episode_model.dart';
import 'package:tv_shows/helpers/app_colors.dart';
import 'package:tv_shows/widgets/app_circular_progress_indicator.dart';
import 'package:tv_shows/widgets/navigation_back_button.dart';

class TvShowDetailsPage extends StatefulWidget {
  TvShowDetailsPage({Key? key}) : super(key: key);

  @override
  _TvShowDetailsPageState createState() => _TvShowDetailsPageState();
}

class _TvShowDetailsPageState extends State<TvShowDetailsPage> {
  @override
  Widget build(BuildContext context) {

    return BlocConsumer<TvShowDetailsPageCubit, TvShowDetailsPageBaseState>(
      listenWhen: (previous, current) {
        return current is TvShowDetailsPageErrorState;
      },
      listener: (context, state) {
        
      },
      builder: (context, state) {
          return PlatformScaffold(
            body: CustomScrollView(
              physics: state is! TvShowDetailsPageLoadedState 
                ? NeverScrollableScrollPhysics() 
                : BouncingScrollPhysics(),
              slivers: [

                // Sliver App Bar
                Builder(
                  builder: (context) {

                    if (state is TvShowDetailsPageLoadedState) {
                      // return SliverAppBar(
                      //   stretch: true,
                      //   expandedHeight: MediaQuery.of(context).size.width,
                        
                      //   flexibleSpace: FlexibleSpaceBar(
                      //     stretchModes: [
                      //       StretchMode.zoomBackground,
                      //       // StretchMode.blurBackground,
                      //       // StretchMode.fadeTitle
                      //     ],
                      //     background: CachedNetworkImage(
                      //       fit: BoxFit.cover,
                      //       imageUrl: state.tvShowDetailsModel.imageUrlAbsolute,
                      //       placeholder: (context, url) => SkeletonAnimation(
                      //         child: Container(),
                      //         shimmerColor: AppColors.skeletonAnimationShimmerColor
                      //       ),
                      //       errorWidget: (context, url, error) => Center(
                      //         child: Icon(Icons.warning_amber_outlined, size: 32, color: AppColors.grey)
                      //       ),
                      //     ),
                      //   ),
                      //   leading: NavigationBackButton(
                      //     onPresssed: () {
                      //       Navigator.of(context).pop();
                      //     },
                      //   ),
                      // );

                      return SliverPersistentHeader(
                        pinned: true,
                        floating: false,
                        delegate: NetworkingPageHeader(
                          imageUrl: state.tvShowDetailsModel.imageUrlAbsolute, 
                          minExtent: 60, 
                          maxExtent: MediaQuery.of(context).size.width
                        )
                      );
                    }

                    return SliverAppBar(
                      floating: false,
                      leading: NavigationBackButton(
                        onPresssed: () {
                          Navigator.of(context).pop();
                        },
                        shouldDropShadow: true,
                      ),
                    );
                  }
                ),

                Builder(
                  builder: (context) {

                    if (state is TvShowDetailsPageLoadingState) {
                      return SliverFillRemaining(
                        child: Center(
                          child: AppCircularProgressIndicator()
                        ),
                      );
                    }

                    if (state is TvShowDetailsPageErrorState) {
                      return SliverFillRemaining(
                        child: GestureDetector(
                          onTap: () {
                            // tap to retry action
                            context.read<TvShowDetailsPageCubit>().loadShowDetails();
                          },
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Platform.isIOS 
                                    ? CupertinoIcons.exclamationmark_triangle 
                                    : Icons.warning_amber_outlined,
                                  size: MediaQuery.of(context).size.width * 0.33,
                                  color: AppColors.grey
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                    AppLocalizations.of(context).localizedString(state.errorMessage),
                                    textAlign: TextAlign.center
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                  child: Text(
                                    AppLocalizations.of(context).localizedString("tap_to_retry"),
                                    style: TextStyle(
                                      color: AppColors.grey
                                    ),
                                    textAlign: TextAlign.center
                                  ),
                                )
                              ],
                            )
                          ),
                        ),
                      );
                    }


                    if (state is TvShowDetailsPageLoadedState) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: DEFAULT_CONTENT_PADDING),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 18),
                                // Title
                              Text(
                                state.tvShowDetailsModel.title,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                              SizedBox(height: 18),
                              // Description
                              Text(
                                    state.tvShowDetailsModel.description, 
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 14
                                    ),
                                  ),

                              SizedBox(height: 24),
                              // Episodes
                              Row(
                                children: [
                                  Text(
                                    AppLocalizations.of(context).localizedString("Episodes"), 
                                      style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w400
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Text(
                                    state.showEpisodes.length.toString(), 
                                      style: TextStyle(
                                      fontSize: 23,
                                      color: AppColors.grey,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 24),
                            ]
                          ),
                        )
                      );
                    }

                    // Should never reach here
                    return SliverToBoxAdapter(child: Container());
                  }
                ),

                // add list of episodes
                Builder(
                  builder: (context) {

                    if (state is TvShowDetailsPageLoadedState) {
                      // Show no episodes message if list is empty...
                      if (state.showEpisodes.isEmpty) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                              DEFAULT_CONTENT_PADDING, 
                              12, 
                              DEFAULT_CONTENT_PADDING, 
                              40
                            ),
                            child: Text(
                              AppLocalizations.of(context).localizedString("Episodes list empty :("),
                              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                color: AppColors.grey
                              ),
                            ),
                          ),
                        );
                      }
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return _buildEpisodeListItemWidget(
                              episode: state.showEpisodes[index], 
                              onPressed: () {

                              }
                            );
                          },
                          childCount: state.showEpisodes.length,
                        ),
                      );
                    }
                    return SliverToBoxAdapter(child: Container());
                  }
                )

              ],
              
              
            ),
          );
      }
    );
   
  }
    



  Widget _buildEpisodeListItemWidget({
    required EpisodeModel episode,
    required VoidCallback? onPressed
  }) {
    final theme = Theme.of(context);
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => GestureDetector(child: child, onTap: onPressed),
      material: (_, child, __) => InkWell(child: child, onTap: onPressed),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DEFAULT_CONTENT_PADDING,
          vertical: 20
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              episode.sesonEpisode,
              style: theme.textTheme.bodyText1?.copyWith(
                fontSize: 18,
                color: AppColors.pink
              )
            ),
            SizedBox(width: 14,),
            Expanded(
              child: Text(
                episode.title,
                style: theme.textTheme.bodyText1?.copyWith(
                  fontSize: 18,
                )
              ),
            ),
            SizedBox(width: 10,),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey,
            )
          ],
        )
      ),
    );
  }

  
}


class NetworkingPageHeader implements SliverPersistentHeaderDelegate {
  
  NetworkingPageHeader({
    required this.imageUrl,
    required this.minExtent,
    required this.maxExtent,
  });

  String imageUrl;
  final double minExtent;
  final double maxExtent;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          fit: BoxFit.cover,
          imageUrl: imageUrl,
          placeholder: (context, url) => SkeletonAnimation(
            child: Container(),
            shimmerColor: AppColors.skeletonAnimationShimmerColor
          ),
          errorWidget: (context, url, error) => Center(
            child: Icon(Icons.warning_amber_outlined, size: 32, color: AppColors.grey)
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black54],
              stops: [0.5, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.repeated,
            ),
          ),
        ),
        Positioned(
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
          child: Text(
            'Lorem ipsum',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white.withOpacity(titleOpacity(shrinkOffset)),
            ),
          ),
        ),
        NavigationBackButton(
                        onPresssed: () {
                          Navigator.of(context).pop();
                        },
                        shouldDropShadow: true,
                      ),
      ],
    );
  }

  double titleOpacity(double shrinkOffset) {
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