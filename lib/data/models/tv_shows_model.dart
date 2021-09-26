import 'dart:convert';

import '../web_api_service.dart';

class TvShowModel {

  final String id;
  final String title;
  final String imageUrl;
  final int likesCount;
  
  const TvShowModel({
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

  factory TvShowModel.fromMap(Map<String, dynamic> map) {
    return TvShowModel(
      id: map['_id'],
      title: map['title'],
      imageUrl: map['imageUrl'],
      likesCount: map['likesCount'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowModel.fromJson(String source) => TvShowModel.fromMap(json.decode(source));

}
