
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:tv_shows/helpers/utils.dart';

class EpisodeCommentModel extends Equatable {

  final String id;
  final String episodeId;
  final String text;
  final String userEmail;

  EpisodeCommentModel({
    required this.id,
    required this.episodeId,
    required this.text,
    required this.userEmail,
  });


  @override
  List<Object?> get props => [id];

  
  int? _userAvatarImageNumber;
  
  String get userAvatarLocalSvgAssetImagePath {
    _userAvatarImageNumber ??= Utils.randomNumber(min: 1, max: 3+1);
    // possible images: 
    //img-placeholder-user1.svg", 
    //img-placeholder-user2.svg, 
    //img-placeholder-user3.svg
    return "assets/svg/img-placeholder-user${_userAvatarImageNumber!}.svg";
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'episodeId': episodeId,
      'text': text,
      'userEmail': userEmail,
    };
  }

  factory EpisodeCommentModel.fromMap(Map<String, dynamic> map) {
    return EpisodeCommentModel(
      id: map['_id'],
      episodeId: map['episodeId'],
      text: map['text'],
      userEmail: map['userEmail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodeCommentModel.fromJson(String source) => EpisodeCommentModel.fromMap(json.decode(source));


}
