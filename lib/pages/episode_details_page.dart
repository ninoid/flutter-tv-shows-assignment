import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/episode_comments_page/episode_comments_page_cubit.dart';
import '../data/repository/tv_shows_repository.dart';
import 'episode_comments_page.dart';
import '../core/app_config.dart';
import '../core/localization/app_localization.dart';
import '../data/models/episode_model.dart';
import '../helpers/app_colors.dart';
import '../widgets/url_image_page_header_app_bar.dart';

class EpisodeDetailsPage extends StatelessWidget {
  
  final EpisodeModel episodeModel;

  const EpisodeDetailsPage({
    required this.episodeModel,
    Key? key
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
     return PlatformScaffold(
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: UrlImagePageHeaderAppBar(
              urlImage: episodeModel.imageUrlAbsolute, 
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
                    episodeModel.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                  SizedBox(height: 12),
                  // season and episode number
                  Text(
                    episodeModel.sesonEpisode,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.pink
                    ),
                  ),
                  SizedBox(height: 18),
                  // Description
                  Text(
                    episodeModel.description, 
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  SizedBox(height: 50),
                  // Comments button,
                  Row(
                    children: [
                      PlatformButton(
                        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                        materialFlat: (_,__) => MaterialFlatButtonData(),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svg/comments.svg",
                              height: 28,
                              color: Colors.black,
                            ),
                            SizedBox(width: 6),
                            Text(
                              AppLocalizations.of(context).localizedString("Comments"),
                              style: Theme.of(context).textTheme.bodyText2,
                            )
                          ],
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            platformPageRoute(
                              builder: (context) => BlocProvider(
                                create: (_) => EpisodeCommentsPageCubit(
                                  tvShowsRepository: context.read<TvShowsRepository>(), 
                                  episodeModel: this.episodeModel
                                )..fetchEpisodeComments(),
                                child: EpisodeCommentsPage(),
                              ),
                              context: context
                            )
                          );
                        },
                      ),
                      Expanded(child: Container())
                    ], 
                  )
                ]
              ),
            )
          ),
        ],
      ),
    );
  }
}