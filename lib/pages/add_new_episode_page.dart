import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tv_shows/bloc/add_new_episode_page/add_new_episode_page_cubit.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/core/localization/app_localization.dart';
import 'package:tv_shows/helpers/app_colors.dart';
import 'package:tv_shows/widgets/app_circular_progress_indicator.dart';
import 'package:flutter_picker/flutter_picker.dart';

class AddNewEpisodePage extends StatefulWidget {
  AddNewEpisodePage({Key? key}) : super(key: key);

  @override
  _AddNewEpisodePageState createState() => _AddNewEpisodePageState();
}

class _AddNewEpisodePageState extends State<AddNewEpisodePage> {

  final _episodeTitleFocusNode = FocusNode();
  final _episodeDescriptionFocusNode = FocusNode();


  @override
  void dispose() {
    _episodeTitleFocusNode.dispose();
    _episodeDescriptionFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddNewEpisodePageCubit, AddNewEpisodePageBaseState>(
      listenWhen: (prevuois, current) {
        return current is AddNewEpisodeSuccessState;
      },
      listener: (context, state) {
        if (state is AddNewEpisodeSuccessState) {
          Navigator.of(context).pop();
        }
      },
      buildWhen: (prevuois, current) {
        return current is AddNewEpisodePageState;
      },
      builder: (context, state) {
        if (state is AddNewEpisodePageState) {
          final bool uiDisabled = state.postingNewEpisodeToApiFlag;
          return WillPopScope(
            onWillPop:  () async {
              // disable back button on android phones
              // only when posting new epsiode to api
              return !uiDisabled;
            },
            child: GestureDetector(
              onTap: () => _dismissKeyboard(),
              child: PlatformScaffold(
                appBar: PlatformAppBar(
                  title: Text(
                    AppLocalizations.of(context).localizedString("Add episode")
                  ),
                  leading: Platform.isIOS 
                    ? CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context).localizedString("Cancel"),
                          style: TextStyle(
                            color: uiDisabled ? AppColors.grey : AppColors.pink
                          ),
                        ),
                        onPressed: uiDisabled 
                          ? null 
                          : () => Navigator.of(context).pop(),
                    )
                    : IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: uiDisabled ? AppColors.grey : AppColors.pink,
                        ),
                        onPressed: uiDisabled 
                          ? null 
                          : () => Navigator.of(context).pop(),
                    ), // For material is default back button arrow
                  trailingActions: [
                    uiDisabled // show spinner if saving to api
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: AppCircularProgressIndicator(
                              materialRadius: 9,
                              materialStrokeWidth: 2,
                              cupertinoRadius: 10,
                            ),
                          )
                        )
                        // show regular add platform button
                      : PlatformButton(
                          child: Text(
                            AppLocalizations.of(context).localizedString("Add"),
                            style: TextStyle(
                              color: (state.addButtonEnabled && !uiDisabled) 
                                ? AppColors.pink 
                                : AppColors.grey,
                              fontSize: 15
                            ),
                          ),
                          onPressed: (state.addButtonEnabled && !uiDisabled)
                            ? () {
                                _dismissKeyboard();
                                context.read<AddNewEpisodePageCubit>().addNewEpisodeAction();
                              }
                            : null,
                          materialFlat: (_,__) => MaterialFlatButtonData(),
                      )
                  ],
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PlatformButton(
                          onPressed: uiDisabled ? null : _showImagePicker,
                          materialFlat: (_,__) => MaterialFlatButtonData(),
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: (state.coverImageFilePath??"").isEmpty
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      "assets/svg/ic-camera.svg",
                                      height: 50,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      AppLocalizations.of(context).localizedString("Upload photo"),
                                      style: platformThemeData(
                                        context, 
                                        material: (themeData) => themeData.textTheme.bodyText1?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.pink
                                        ),
                                        cupertino: (themeData) => themeData.textTheme.textStyle.copyWith(
                                          fontSize: 16,
                                          color: AppColors.pink
                                        )
                                      ),
                                    ),
                                  ]
                                )
                              : Image.file(
                                  File(state.coverImageFilePath!),
                                  fit: BoxFit.cover
                                )
                          ),
                        ),
                        SizedBox(height: 8,),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: DEFAULT_CONTENT_PADDING),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Material(
                              // Material ancestor is required for Material Widgets in Cupertino App
                                type: MaterialType.transparency,
                                child: TextField(
                                  focusNode: _episodeTitleFocusNode,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  enabled: !uiDisabled,
                                  autocorrect: false,
                                  autofocus: false,
                                  maxLength: 100,
                                  maxLines: 1,
                                  minLines: 1,
                                  cursorColor: AppColors.pink,
                                  style: TextStyle(
                                    color: uiDisabled ? Colors.grey : null
                                  ),
                                  decoration: _textFieldInputDecoration(
                                    labelTitle: AppLocalizations.of(context).localizedString("Title"),
                                    hintText: AppLocalizations.of(context).localizedString("Episode title")
                                  ),
                                  onChanged: (value) {
                                    context.read<AddNewEpisodePageCubit>().titleTextChanged(value);
                                  },
                                ),
                              ),
                              SizedBox(height: 12),
                              Stack(
                                children: [
                                  Material(
                                    // Material ancestor is required for Material Widgets in Cupertino App
                                    type: MaterialType.transparency,
                                    child: TextField(
                                      focusNode: null,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      enabled: !uiDisabled,
                                      autocorrect: false,
                                      autofocus: false,
                                      maxLength: 100,
                                      maxLines: 1,
                                      minLines: 1,
                                      cursorColor: AppColors.pink,
                                      style: TextStyle(
                                        color: state.postingNewEpisodeToApiFlag ? Colors.grey : null
                                      ),
                                      decoration: _textFieldInputDecoration(
                                        labelTitle: " ",
                                        hintText: AppLocalizations.of(context).localizedString("Season & Episode") 
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          state.pickedSeasonAndEpisodeCombinedString,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: uiDisabled ? AppColors.grey : AppColors.pink,
                                            fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: PlatformWidgetBuilder(
                                      cupertino: (_, child, __) => GestureDetector(
                                        child: child, 
                                        onTap: uiDisabled ? null : _showSeasonEpisodePicker, 
                                        behavior: HitTestBehavior.translucent
                                      ),
                                      material: (_, child, __) => InkWell( // show tap ripple for material
                                        child: child, 
                                        onTap: uiDisabled ? null : _showSeasonEpisodePicker
                                      ),
                                    )
                                  )
                                ],
                              ),
          
                              SizedBox(height: 12),
                              Material(
                              // Material ancestor is required for Material Widgets in Cupertino App
                                type: MaterialType.transparency,
                                child: TextField(
                                  focusNode: _episodeDescriptionFocusNode,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  enabled: !uiDisabled,
                                  autocorrect: false,
                                  autofocus: false,
                                  maxLength: 1000,
                                  maxLines: 10,
                                  minLines: 1,
                                  cursorColor: AppColors.pink,
                                  style: TextStyle(
                                    color: uiDisabled ? Colors.grey : null
                                  ),
                                  decoration: _textFieldInputDecoration(
                                    labelTitle: AppLocalizations.of(context).localizedString("Description"),
                                    hintText: AppLocalizations.of(context).localizedString("Episode description")
                                  ),
                                  onChanged: (value) {
                                    context.read<AddNewEpisodePageCubit>().descriptionTextChanged(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 50),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        } 

        // should never reach here
        return Container();
      },
    );
  }


  bool _dismissKeyboard() {
    if (_episodeTitleFocusNode.hasFocus) {
      _episodeTitleFocusNode.unfocus();
      return true;
    } else if (_episodeDescriptionFocusNode.hasFocus) {
      _episodeDescriptionFocusNode.unfocus();
      return true;
    }
    return false;
  }

  InputDecoration _textFieldInputDecoration({
    required String labelTitle,
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      // labelText: labelTitle,
      labelStyle: TextStyle(
        color: AppColors.grey
      ),
      hintStyle: TextStyle(
        color: AppColors.grey
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 1),   
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.grey, width: 1),   
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppColors.pink, width: 1),   
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
    );
  }

  void _showSeasonEpisodePicker() {
    _dismissKeyboard();
    final seasoneNumberOptions = List.generate(30, (index) => index + 1);
    final episodesNumberOptions = List.generate(100, (index) => index + 1);
    final pickerData = [
      seasoneNumberOptions.map((e) => "S$e").toList(),
      episodesNumberOptions.map((e) => "Ep$e").toList()
    ];

    final picker = Picker(
      adapter: PickerDataAdapter<String>(
        pickerdata: pickerData,
        isArray: true
      ),
      onConfirm: (picker, value) {
        // debugPrint(value.toString());
        final seasonNumIndex = value.first;
        final episodeNumIndex = value.last;
        context.read<AddNewEpisodePageCubit>().setSeasonAndEpisodeValues(
          season: seasoneNumberOptions[seasonNumIndex].toString(), 
          episode: episodesNumberOptions[episodeNumIndex].toString()
        );
      },
      hideHeader: Platform.isAndroid,
      // height: 250,
      // containerColor: Colors.white,
      // headerColor: Colors.white,
      title: Text(
        AppLocalizations.of(context).localizedString("Season & Episode")
      ),
      cancelText: AppLocalizations.of(context).localizedString("Cancel"),
      cancelTextStyle: TextStyle(color: AppColors.pink),
      confirmText: AppLocalizations.of(context).localizedString("Confirm"),
      confirmTextStyle: TextStyle(color: AppColors.pink, fontWeight: FontWeight.w500),
    );

    // show picker: modal on iOS
    picker.showDialog(context);
    
  }

  Future<void> _showImagePicker() async {
    if (_dismissKeyboard()) { return; }
    final _picker = ImagePicker();
    final imageFile = await _picker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      context.read<AddNewEpisodePageCubit>().setCoverImagePath(imageFile.path);
    }
  }
}