import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:tv_shows/bloc/episode_comments_page/episode_comments_page_cubit.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/core/localization/app_localization.dart';
import 'package:tv_shows/data/models/episode_comment_model.dart';
import 'package:tv_shows/helpers/app_colors.dart';
import 'package:tv_shows/helpers/utils.dart';

class EpisodeCommentsPage extends StatefulWidget {
  EpisodeCommentsPage({Key? key}) : super(key: key);

  @override
  _EpisodeCommentsPageState createState() => _EpisodeCommentsPageState();
}

class _EpisodeCommentsPageState extends State<EpisodeCommentsPage> {
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        backgroundColor: Colors.white,
        title: Text(
          AppLocalizations.of(context).localizedString("Comments")
        ),
      ),
      body: SafeArea(
        child: BlocConsumer<EpisodeCommentsPageCubit, EpisodeCommentsPageState>(
          listenWhen: (previous, current) {
            return false;
          },
          listener: (context, state) {
            // nothing for now
          },
          builder: (context, state) {

         
            if (state is EpisodeCommentsPageErrorState) {
              return Padding(
                padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                child: _buildSimpleEmptyDataView(
                  icon: Platform.isIOS 
                    ? CupertinoIcons.exclamationmark_triangle 
                    : Icons.warning_amber_outlined,
                  title: AppLocalizations.of(context).localizedString(state.errorMessage),
                  subtitle: AppLocalizations.of(context).localizedString("tap_to_retry"),
                  onTap: () => context.read<EpisodeCommentsPageCubit>().fetchEpisodeComments()
                ),
              );
            } 

            List<EpisodeCommentModel>? commentsList;
            bool showSkeletonLoader = true;
            if (state is EpisodeCommentsPageLoadedState) {
              commentsList = state.comments;
              showSkeletonLoader = false;
            }

            if (showSkeletonLoader) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_,__) {
                  return _buildCommentRowOrSkeletonLoader(null);
                },
                itemCount: 6, // some value here but it will build only visible rows
                separatorBuilder: (_,__) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: DEFAULT_CONTENT_PADDING),
                    child: Divider( 
                      height: 0,
                      thickness: 0, //hairline,
                      color: AppColors.grey.withOpacity(0.8),
                    ),
                  );
                }
              );
            }

            return Stack(
              children: [
                Builder(
                  builder: (context) {
                    
                    if (commentsList?.isEmpty ?? true) {
                      // Show simple empty data view with icon and message
                      return Padding(
                        padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                        child: _buildSimpleEmptyDataView(
                          icon: Platform.isIOS 
                            ? CupertinoIcons.exclamationmark_triangle 
                            : Icons.warning_amber_outlined,
                          title: AppLocalizations.of(context).localizedString(
                            "No comments yet.\nBe first to add one :)"
                          ),
                        ),
                      );
                    } else {
                      // safe to access commentsList here
                      return ListView.separated(
                        itemBuilder: (context, index) {
                          return _buildCommentRowOrSkeletonLoader(commentsList![index]);
                        },
                        itemCount: commentsList!.length,
                        separatorBuilder: (_,__) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: DEFAULT_CONTENT_PADDING),
                            child: Divider( 
                              height: 0,
                              thickness: 0, //hairline,
                              color: AppColors.grey.withOpacity(0.8),
                            ),
                          );
                        },
                      );

                    }
                  },
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Builder(
                    builder: (context) {
                      if (showSkeletonLoader) {
                        return Container();
                      }
                      return TextFormField(
                            initialValue: "asdasdasdasdasda",
                            // focusNode: _passwordFocusNode,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            // obscureText: !state.showPassword,
                            // enabled: !state.isLoginInProgress,
                            autocorrect: false,
                            autofocus: false,
                            maxLength: 100,
                            maxLines: 1,
                            minLines: 1,
                            cursorColor: AppColors.pink,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context).localizedString("Password"),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey, width: 1),   
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey, width: 1),   
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey, width: 1),   
                              ),
                              disabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: AppColors.grey.withOpacity(0.75), width: 1),   
                              ),
                              // errorBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: AppColors.red, width: 1),   
                              // ),
                              // focusedErrorBorder: UnderlineInputBorder(
                              //   borderSide: BorderSide(color: AppColors.red, width: 2),   
                              // ),
                              counter: SizedBox.shrink(),
                              // suffixIconConstraints: BoxConstraints(),
                              // suffixIcon: PlatformIconButton(
                              //   padding: EdgeInsets.zero,
                              //   material: (_,__)=> MaterialIconButtonData(
                              //     padding: EdgeInsets.zero,
                              //     constraints: BoxConstraints(),
                              //   ),
                              //   icon: SvgPicture.asset(
                              //     state.showPassword ? "assets/svg/ic-characters-hide.svg" : "assets/svg/ic-hide-password.svg",
                              //     height: state.showPassword ? 22 : 24, // tweak height since svg different
                              //     fit: BoxFit.fitHeight,
                              //     color: !state.isLoginInProgress
                              //       ? AppColors.pink
                              //       : AppColors.grey.withOpacity(0.75)
                              //   ),
                              //   onPressed: !state.isLoginInProgress
                              //     ? () {
                              //         context.read<LoginPageCubit>().showOrHidePasswordButtonPressed();
                              //         _unfocusTextFields();
                              //       }
                              //     : null
                              // )
                            ),
                            // onChanged: (value) {
                            //   context.read<LoginPageCubit>().passwordInputTextChanged(value);
                            // },
                          );
                      
                      
                    },
                  ),
                ),
              ],
            );


            
          },
        ),
      ),
    );
  }


  Widget _buildSimpleEmptyDataView({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap
  }) {

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: MediaQuery.of(context).size.width * 0.33,
            color: AppColors.grey
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
            child: Text(
              AppLocalizations.of(context).localizedString(title),
              textAlign: TextAlign.center
            ),
          ),
          Builder(
            builder: (context) {
              bool hasSubtitleMessage = (subtitle?.trim() ?? "").isNotEmpty;
              if (hasSubtitleMessage) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Text(
                    AppLocalizations.of(context).localizedString(subtitle!),
                    style: TextStyle(
                      color: AppColors.grey
                    ),
                    textAlign: TextAlign.center
                  ),
                );
              }
              return Container();
            },
          )
        ],
      ),
    );

  }


  final userSvgAvatarImagesList = [
    "assets/svg/img-placeholder-user1.svg",
    "assets/svg/img-placeholder-user2.svg",
    "assets/svg/img-placeholder-user3.svg",
  ];

  Widget _buildCommentRowOrSkeletonLoader(EpisodeCommentModel? comment) {
    bool showSkeletonView = comment == null;
    final theme = Theme.of(context);
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => GestureDetector(child: child, onTap: null),
      material: (_, child, __) => InkWell(child: child, onTap: null),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: DEFAULT_CONTENT_PADDING,
          vertical: 20
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    userSvgAvatarImagesList[Utils.randomNumber(max: userSvgAvatarImagesList.length)],
                    height: 40,
                  ),
                ),
                showSkeletonView 
                  ? Positioned.fill(child: _skeletonLoader()) 
                  : Container()
              ],
            ),
            SizedBox(width: 12,),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Text(
                        comment?.userEmail ?? "someUser",
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                          color: AppColors.grey
                        )
                      ),
                      showSkeletonView 
                        ? Positioned.fill(child: _skeletonLoader(width: 160)) 
                        : Container()
                    ],
                  ),
                  SizedBox(height: 6,),
                  Stack(
                    children: [
                      Text(
                        comment?.text ?? "comment for skeleton loader",
                        style: theme.textTheme.bodyText1?.copyWith(
                          fontSize: 14,
                          color: AppColors.grey
                        )
                      ),
                      showSkeletonView 
                        ? Positioned.fill(child: _skeletonLoader()) 
                        : Container()
                    ],
                  ),
                ],
              )
            ),
            SizedBox(width: 12,),
            Stack(
              children: [
                Text(
                  "5min",
                  style: theme.textTheme.bodyText1?.copyWith(
                    fontSize: 14,
                    color: AppColors.grey
                  )
                ),
                showSkeletonView 
                  ? Positioned.fill(child: _skeletonLoader()) 
                  : Container()
              ],
            ),
          ],
        )
      ),
    );
  }

  Widget _skeletonLoader({
    double? width,
    double borderRadius = 8.0
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.imagePlaceholderColor,
        borderRadius: BorderRadius.circular(borderRadius)
      ),
      child: SkeletonAnimation(
        child: Container(width: width),
        shimmerColor: AppColors.skeletonAnimationShimmerColor,
      ),
    );
  }


}