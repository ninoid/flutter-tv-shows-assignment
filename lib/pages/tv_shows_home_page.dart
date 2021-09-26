import 'dart:io';

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
import '../data/web_api_service.dart';
import '../helpers/app_colors.dart';
import '../helpers/flushbar_helper.dart';
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
        title: Text(
          AppLocalizations.of(context).localizedString("Shows"),
          style: TextStyle(
            fontSize: 24
          ),
        ),
        trailingActions: [
          PlatformIconButton(
            icon: SvgPicture.asset(
              "assets/svg/ic-logout.svg",
              height: 32,
            ),
            onPressed: () async {
              await _askUserToSignOut();
            },
          )
        ],
      ),
      body: BlocConsumer<TvShowsHomePageCubit, TvShowsHomePageBaseState>(
        listenWhen: (previous, current) {
          return current is TvShowsHomePageShowSnackbarState;
        },
        listener: (context, state) {
          if (state is TvShowsHomePageShowSnackbarState) {
            AppFlushbarHelper.showFlushbar(
              context: context, 
              message: AppLocalizations.of(context).localizedString(state.message)
            );
          }
        },
        buildWhen: (previous, current) {
          return  current is TvShowsHomePageLoadingState ||
                  current is TvShowsHomePageLoadedState;
        },
        builder: (context, state) {
          

          if (state is TvShowsHomePageLoadingState) {

            return Padding(
              padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppCircularProgressIndicator(
                      materialRadius: 12,
                      cupertinoRadius: 12,
                    ),
                    SizedBox(height: 12,),
                    Text(
                      AppLocalizations.of(context).localizedString("Loading").toUpperCase(),
                      style: TextStyle(
                        color: AppColors.grey
                      ),
                    )
                  ],
                ),
              ),
            );

          }


          if (state is TvShowsHomePageLoadedState) {

            return SafeArea(
              child: Builder(
                builder: (context) {

                  if (state.showsList.isEmpty) {
                    return Container();

                  } else {

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
                                    tvShowId: tvShow.id
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
      cupertino: (_, child, __) => GestureDetector(child: child, onTap: onPressed),
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
              height: 120,
              width: 120 * 0.675,
              decoration: BoxDecoration(
                color: AppColors.imagePlaceholderColor
              ),
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
              child: Text(
                tvShowsModel.title
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> _askUserToSignOut() async {
    bool? shouldSignOut;
    if (Platform.isIOS) {
      // showPlatformModalSheet(context: context, builder: builder)
    } else {
      shouldSignOut = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            AppLocalizations.of(context).localizedString("Sign out")
          ),
          content: Text(
            AppLocalizations.of(context).localizedString("Are you sure you want to sign out?")
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                AppLocalizations.of(context).localizedString("Cancel").toUpperCase()
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(
                AppLocalizations.of(context).localizedString("Sign out").toUpperCase()
              ),
            ),
          ],
        ),
      );
    }

    if (shouldSignOut ?? false) {
      context.read<AuthenticationCubit>().authenticationSignOut();
    }
  }
}