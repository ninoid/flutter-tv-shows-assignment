import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeleton_text/skeleton_text.dart';
import '../bloc/episode_comments_page/episode_comments_page_cubit.dart';
import '../core/app_config.dart';
import '../core/localization/app_localization.dart';
import '../data/models/episode_comment_model.dart';
import '../helpers/app_colors.dart';

class EpisodeCommentsPage extends StatefulWidget {
  EpisodeCommentsPage({Key? key}) : super(key: key);

  @override
  _EpisodeCommentsPageState createState() => _EpisodeCommentsPageState();
}

class _EpisodeCommentsPageState extends State<EpisodeCommentsPage> {

  final _textFieldController = TextEditingController();
  final _textFieldFocusNode = FocusNode();
  final _commentsListScrollController = ScrollController();

  @override
  void dispose() {
    _textFieldController.dispose();
    _textFieldFocusNode.dispose();
    _commentsListScrollController.dispose();
    super.dispose();
  }


  void _dismissKeyboard() {
    _textFieldFocusNode.unfocus();
  }

  void _scrollToBottomOfCommentsListView() {
    if (_commentsListScrollController.hasClients) {
      // _commentsListScrollController.animateTo(
      //   _commentsListScrollController.position.maxScrollExtent, 
      //   duration: const Duration(milliseconds: 300), 
      //   curve: Curves.fastOutSlowIn
      // );
      _commentsListScrollController.jumpTo(
        _commentsListScrollController.position.maxScrollExtent, 
      );
    }
  }


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
            return current is EpisodeCommentsPagePostSuccessfulState;
          },
          listener: (context, state) {
            if (state is EpisodeCommentsPagePostSuccessfulState) {
              _textFieldController.text = "";
            }
          },
          buildWhen: (previous, current) {
            if (current is EpisodeCommentsPagePostSuccessfulState) { 
              return false; 
            }
            if (previous is EpisodeCommentsPagePostSuccessfulState && 
                current is EpisodeCommentsPageLoadedState) { 
              return false; 
            }
            return true;
          },
          builder: (context, state) {

         
            if (state is EpisodeCommentsPageErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                  child: _buildSimpleEmptyDataView(
                    icon: Platform.isIOS 
                      ? CupertinoIcons.exclamationmark_triangle 
                      : Icons.warning_amber_outlined,
                    title: AppLocalizations.of(context).localizedString(state.errorMessage),
                    subtitle: AppLocalizations.of(context).localizedString("tap_to_retry"),
                    onTap: () => context.read<EpisodeCommentsPageCubit>().fetchEpisodeComments()
                  ),
                ),
              );
            } 

            EpisodeCommentsPageLoadedState? loadedState;
            bool showSkeletonLoader = true;
            if (state is EpisodeCommentsPageLoadedState) {
              loadedState = state;
              showSkeletonLoader = false;
            }

            if (showSkeletonLoader) {
              return ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (_,__) {
                  return _buildCommentRowOrSkeletonLoader(comment: null);
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

            return GestureDetector(
              onTap: () => _dismissKeyboard(),
              child: Stack(
                children: [
                  Builder(
                    builder: (context) {
                      if (loadedState?.comments.isEmpty ?? true) {
                        // Show simple empty data view with icon and message
                        return Padding(
                            padding: const EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                            child: _buildSimpleEmptyDataView(
                              icon: Icons.comment_outlined,
                              title: AppLocalizations.of(context).localizedString(
                                "No comments yet.\nBe first to add one :)"
                              ),
                              onTap: () {
                                if (_textFieldFocusNode.hasFocus) {
                                  _textFieldFocusNode.unfocus();
                                } else {
                                  // focus to post new comment
                                  _textFieldFocusNode.requestFocus();
                                }
                              }
                            ),
                          );
                     
                      } else {
                        // safe to access commentsList here
                        final itemCount = loadedState!.postingNewCommentFlag 
                         ?  loadedState.comments.length + 1
                         :  loadedState.comments.length;
                        return ListView.separated(
                          controller: _commentsListScrollController,
                          padding: const EdgeInsets.only(
                            bottom: 100 // ensure comment text field container height
                          ),
                          // reverse: true,
                          itemBuilder: (context, index) {
                            // return posting comment row
                            if (index == loadedState!.comments.length) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  DEFAULT_CONTENT_PADDING, 
                                  24, 
                                  DEFAULT_CONTENT_PADDING, 
                                  0
                                ),
                                child: Text(
                                  AppLocalizations.of(context).localizedString("Sending..."),
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontSize: 13
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              );
                            }
            
                            // return regular comment row
                            return _buildCommentRowOrSkeletonLoader(
                              comment: loadedState.comments[index],
                              onTap: () {
                                _dismissKeyboard();
                              }
                            );
                          },
                          itemCount: itemCount,
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
                        if (loadedState == null) {
                          return Container();
                        }
                        // show post input field only when comments are successfully loaded
                        final postButtonEnabled = loadedState.isCommentTextValid && !loadedState.postingNewCommentFlag;
                        final textFieldEnabled = !loadedState.postingNewCommentFlag;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: DEFAULT_CONTENT_PADDING,
                            vertical: 6
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xfffefefe),
                            border: Border(
                              top: BorderSide(color: AppColors.grey, width: 0),
                              bottom: BorderSide(color: AppColors.grey, width: 0)
                            )
                          ),
                          child: Row(
                            children: [
                              Container(
                                height: 44,
                                width: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.imagePlaceholderColor,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: TextField(
                                    controller: _textFieldController,
                                    focusNode: _textFieldFocusNode,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    enabled: textFieldEnabled,
                                    onChanged: (newValue) {
                                      context.read<EpisodeCommentsPageCubit>().commentTextChanged(newValue);
                                    },
                                    style: TextStyle(
                                      color: textFieldEnabled ? Colors.black : AppColors.grey
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, 
                                        vertical: 2
                                      ),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0, color: AppColors.grey),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0, color: AppColors.grey),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 2, color: AppColors.pink),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0, color: AppColors.grey.withOpacity(0.75)),
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      filled: true,
                                      fillColor: Colors.white70,
                                      hintStyle: TextStyle(color: AppColors.grey),
                                      hintText: AppLocalizations.of(context).localizedString("Add a comment"),
                                      suffixIconConstraints: BoxConstraints(),
                                      suffixIcon: PlatformButton(
                                        materialFlat: (_,__) => MaterialFlatButtonData(
                                          padding: EdgeInsets.only(right: 16),
                                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                           minWidth: 0, //wraps child's width
                                           height: 0, //wraps child's height
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context).localizedString("Post"),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: postButtonEnabled ? AppColors.pink : AppColors.grey
                                          ),
                                        ),
                                        onPressed: postButtonEnabled
                                          ? () {
                                              _dismissKeyboard();
                                              context.read<EpisodeCommentsPageCubit>().postEpisodeComment();
                                              Future.delayed(Duration(milliseconds: 100)).then(
                                                (value) => _scrollToBottomOfCommentsListView()
                                              );
                                            }
                                          : null
                                      )
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
             
                      },
                    ),
                  ),
                ],
              ),
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
      behavior: HitTestBehavior.translucent,
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
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: AppColors.grey,
                fontWeight: FontWeight.w500
              ),
            ),
          ),
          Builder(
            builder: (context) {
              bool hasSubtitleMessage = (subtitle?.trim() ?? "").isNotEmpty;
              if (hasSubtitleMessage) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 40),
                  child: Text(
                    AppLocalizations.of(context).localizedString(subtitle!),
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey,
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

  Widget _buildCommentRowOrSkeletonLoader({EpisodeCommentModel? comment, VoidCallback? onTap}) {
    bool showSkeletonView = comment == null;
    final theme = Theme.of(context);
    return PlatformWidgetBuilder(
      cupertino: (_, child, __) => GestureDetector(child: child, onTap: onTap, behavior: HitTestBehavior.translucent,),
      material: (_, child, __) => GestureDetector(child: child, onTap: onTap, behavior: HitTestBehavior.translucent),
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
                    comment?.userAvatarLocalSvgAssetImagePath ?? "assets/svg/img-placeholder-user1.svg",
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