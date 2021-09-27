import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'episode_details_page.dart';
import '../widgets/url_image_page_header_app_bar.dart';
import '../bloc/tv_show_details_page/tv_show_details_page_cubit.dart';
import '../core/app_config.dart';
import '../core/localization/app_localization.dart';
import '../data/models/episode_model.dart';
import '../helpers/app_colors.dart';
import '../widgets/app_circular_progress_indicator.dart';
import '../widgets/navigation_back_button.dart';

class TvShowDetailsPage extends StatefulWidget {
  TvShowDetailsPage({Key? key}) : super(key: key);

  @override
  _TvShowDetailsPageState createState() => _TvShowDetailsPageState();
}

class _TvShowDetailsPageState extends State<TvShowDetailsPage> {

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<TvShowDetailsPageCubit, TvShowDetailsPageBaseState>(
      builder: (context, state) {

        if (state is TvShowDetailsPageLoadedState) {

          return PlatformScaffold(
            body: CustomScrollView(
              physics: BouncingScrollPhysics(),
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: UrlImagePageHeaderAppBar(
                    urlImage: state.tvShowDetailsModel.imageUrlAbsolute, 
                    minExtent: 80, 
                    maxExtent: MediaQuery.of(context).size.width
                  )
                ),
                SliverToBoxAdapter(
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
                        SizedBox(height: 16),
                      ]
                    ),
                  )
                ),
                // add list of episodes
                Builder(
                  builder: (context) {

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
                              Navigator.of(context).push(
                              platformPageRoute(
                                builder: (context) => EpisodeDetailsPage(
                                  episodeModel: state.showEpisodes[index]
                                ),
                                context: context
                              )
                            );
                            }
                          );
                        },
                        childCount: state.showEpisodes.length,
                      ),
                    );
                  }

                )
              ],
            ),
          );


      } else {
        // show loader or tap to retry view
        return PlatformScaffold(
          appBar: PlatformAppBar(
            backgroundColor: Colors.transparent,
            leading: NavigationBackButton(
              onPresssed: () => Navigator.of(context).pop(),
              shouldDropShadow: true,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
              child: Center(
                child: Builder(
                  builder: (context) {
                    if (state is TvShowDetailsPageErrorState) {
                      return GestureDetector(
                        onTap: () {
                          context.read<TvShowDetailsPageCubit>().loadShowDetails();
                        },
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
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
                              child: Text(
                                AppLocalizations.of(context).localizedString(state.errorMessage),
                                textAlign: TextAlign.center
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: Text(
                                AppLocalizations.of(context).localizedString("tap_to_retry"),
                                style: TextStyle(
                                  color: AppColors.grey
                                ),
                                textAlign: TextAlign.center
                              ),
                            )
                          ],
                        ),
                      );
                    }

                    // Loading state
                    return AppCircularProgressIndicator();
                  }
                ),
              ),
            ),
          ),
        );
      }
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
