import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tv_shows/bloc/authentication/authentication_cubit.dart';
import 'package:tv_shows/bloc/shows_home_page/shows_home_page_cubit.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/core/localization/app_localization.dart';
import 'package:tv_shows/helpers/app_colors.dart';
import 'package:tv_shows/helpers/flushbar_helper.dart';
import 'package:tv_shows/widgets/app_circular_progress_indicator.dart';

class ShowsHomePage extends StatefulWidget {
  ShowsHomePage({Key? key}) : super(key: key);

  @override
  _ShowsHomePageState createState() => _ShowsHomePageState();
}

class _ShowsHomePageState extends State<ShowsHomePage> {
  
  
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
            onPressed: () {
              _askUserToSignOut();
            },
          )
        ],
      ),
      body: BlocConsumer<ShowsHomePageCubit, ShowsHomePageBaseState>(
        listenWhen: (previous, current) {
          return current is ShowsHomePageShowSnackbarState;
        },
        listener: (context, state) {
          if (state is ShowsHomePageShowSnackbarState) {
            AppFlushbarHelper.showFlushbar(
              context: context, 
              message: AppLocalizations.of(context).localizedString(state.message)
            );
          }
        },
        buildWhen: (previous, current) {
          return  current is ShowsHomePageLoadingState ||
                  current is ShowsHomePageLoadedState;
        },
        builder: (context, state) {
          
          if (state is ShowsHomePageLoadingState) {
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


          if (state is ShowsHomePageLoadedState) {
            return SafeArea(
              child: Builder(
                builder: (context) {
                  if (state.showsList.isEmpty) {
                    return Container();
                  } else {
                    return ListView.separated(
                      padding: EdgeInsets.all(DEFAULT_CONTENT_PADDING),
                      itemBuilder: (context, index) {
                        final show = state.showsList[index];
                        return Container();
                      }, 
                      separatorBuilder: (_,__) => SizedBox(height: 8,), 
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