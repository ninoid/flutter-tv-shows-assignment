import 'dart:convert';

import '../web_api_service.dart';

class EpisodeModel {

  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final String episodeNumber;
  final String season;

  EpisodeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.episodeNumber,
    required this.season,
  });

  String get sesonEpisode => "s$season Ep$episodeNumber";
  String get imageUrlAbsolute => WebApiService.webApiBaseUrl + (imageUrl ?? "");

  
  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'episodeNumber': episodeNumber,
      'season': season,
    };
  }

  factory EpisodeModel.fromMap(Map<String, dynamic> map) {
    return EpisodeModel(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      episodeNumber: map['episodeNumber'],
      season: map['season'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EpisodeModel.fromJson(String source) => EpisodeModel.fromMap(json.decode(source));

}
