import 'dart:convert';

import 'package:tv_shows/data/web_api_service.dart';

class TvShowsModel {

  final String id;
  final String title;
  final String imageUrl;
  final int likesCount;
  
  const TvShowsModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.likesCount
  });

  String get imageUrlAbsolute => WebApiService.webApiBaseUrl + imageUrl;

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
    };
  }

  factory TvShowsModel.fromMap(Map<String, dynamic> map) {
    return TvShowsModel(
      id: map['_id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      likesCount: map['likesCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowsModel.fromJson(String source) => TvShowsModel.fromMap(json.decode(source));

}
