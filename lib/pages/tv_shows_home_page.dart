import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import '../bloc/authentication/authentication_cubit.dart';
import '../bloc/tv_show_details_page/tv_show_details_page_cubit.dart';
import '../bloc/tv_shows_home_page/tv_shows_home_page_cubit.dart';
import '../core/app_config.dart';
import '../core/localization/app_localization.dart';
import '../data/models/tv_shows_model.dart';
import '../data/repository/tv_shows_repository.dart';
import '../helpers/app_colors.dart';
import 'tv_show_details_page.dart';
import '../widgets/app_circular_progress_indicator.dart';

class TvShowsHomePage extends StatefulWidget {
  TvShowsHomePage({Key? key}) : super(key: key);

  @override
  _TvShowsHomePageState createState() => _TvShowsHomePageState();
}

class _TvShowsHomePageState extends State<TvShowsHomePage> {
  
  
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              AppLocalizations.of(context).localizedString("tv_shows_home_page_title"),
              style: Theme.of(context).textTheme.headline6?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w400
              ),
            ),
            Expanded(child: Container())
          ],
        ),
        cupertino: (_,__) => CupertinoNavigationBarData(
          border: Border.all(color: Colors.transparent),
        ),
        trailingActions: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 0.3,
                      spreadRadius: 0.15
                    ),
                  ]
                ),
              ),
              PlatformIconButton(
                icon: SvgPicture.asset(
                  "assets/svg/ic-logout.svg",
                  height: 40,
                ),
                padding: EdgeInsets.zero,
                onPressed:  () async {
                  await _askUserToSignOut();
                },
              )
            ],
          )
        ]
      ),
      body: BlocBuilder<TvShowsHomePageCubit, TvShowsHomePageState>(
        builder: (context, state) {
          
          if (state is TvShowsHomePageLoadingState) {

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppCircularProgressIndicator(
                        materialRadius: 14,
                        cupertinoRadius: 14,
                      ),
                      // SizedBox(height: 12,),
                      // Text(
                      //   AppLocalizations.of(context).localizedString("Loading").toUpperCase(),
                      //   style: TextStyle(
                      //     color: AppColors.grey
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            );

          }


          if (state is TvShowsHomePageLoadedState) {

            return SafeArea(
              child: Builder(
                builder: (context) {

                  if (state.showsList.isEmpty) {
                    // show some nice empty data view, 
                    // eg. with image, message and tap to reload option
                    return _buildEmptyDataView();
                    
                  } else {
                    // Tv Shows List
                    return ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: DEFAULT_CONTENT_PADDING),
                      itemBuilder: (context, index) {
                        final tvShow = state.showsList[index];
                        return _buildTvShowListItemWidget(
                          tvShowsModel: tvShow,
                          onPressed: () {
                            Navigator.of(context).push(
                              platformPageRoute(
                                builder: (context) => BlocProvider(
                                  create: (_) => TvShowDetailsPageCubit(
                                    tvShowsRepository: context.read<TvShowsRepository>(),
                                    tvShowModel: tvShow
                                  )..loadShowDetails(),
                                  child: TvShowDetailsPage(),
                                ),
                                context: context
                              )
                            );
                          } 
                        );
                      }, 
                      itemCount: state.showsList.length
                    );
                  }
                },
              )
            );
          }
          
          // Should never reach here
          return Container();
        }
      )
    );
  }


  Widget _buildTvShowListItemWidget({
    required TvShowModel tvShowsModel,
    required VoidCallback? onPressed
  }) {
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => GestureDetector(child: child, onTap: onPressed, behavior: HitTestBehavior.translucent),
      material: (_, child, __) => InkWell(child: child, onTap: onPressed),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DEFAULT_CONTENT_PADDING,
          vertical: 6
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 112,
              width: 112 * 0.675,
              decoration: BoxDecoration(
                color: AppColors.imagePlaceholderColor,
                borderRadius: BorderRadius.circular(4),
              ),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: tvShowsModel.imageUrlAbsolute,
                placeholder: (context, url) => SkeletonAnimation(
                  child: Container(),
                  shimmerColor: AppColors.skeletonAnimationShimmerColor
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(Icons.warning_amber_outlined, size: 32, color: AppColors.grey)
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  tvShowsModel.title,
                  style: platformThemeData(
                    context, 
                    material: (themeData) => themeData.textTheme.headline6?.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.5
                    ),
                    cupertino: (themeData) => themeData.textTheme.textStyle.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.1
                    )
                  )
                ),
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> _askUserToSignOut() async {
    await showPlatformDialog(
      barrierDismissible: true,
      context: context,
      builder: (alertContext) => PlatformAlertDialog(
        title: Text(
          AppLocalizations.of(context).localizedString("sign_out")
        ),
        content: Text(
          AppLocalizations.of(context).localizedString("sign_out_are_you_sure_question"),
        ),
        actions: <Widget>[
          PlatformDialogAction(
            child: PlatformText(AppLocalizations.of(context).localizedString("cancel")),
            onPressed: () => Navigator.pop(alertContext),
            cupertino: (_,__) => CupertinoDialogActionData(
              isDefaultAction: true
            ),
          ),
          PlatformDialogAction(
            child: PlatformText(AppLocalizations.of(context).localizedString("ok")),
            onPressed: () async {
              Navigator.pop(alertContext);
              context.read<AuthenticationCubit>().authenticationSignOut();
            },
            cupertino: (_,__) => CupertinoDialogActionData(
              isDestructiveAction: true
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyDataView() {
    return GestureDetector(
      onTap: () => context.read<TvShowsHomePageCubit>().loadShows(),
      behavior: HitTestBehavior.translucent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber_outlined, // some nice empty data image goes here :)
            size: MediaQuery.of(context).size.width * 0.33,
            color: AppColors.grey
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            child: Text(
              AppLocalizations.of(context).localizedString("No TV Shows :("),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Text(
              AppLocalizations.of(context).localizedString("Tap to reload"),
              style: TextStyle(
                fontSize: 14,
                color: AppColors.grey,
              ),
              textAlign: TextAlign.center
            ),
          )
        ],
      ),
    );
  }

}