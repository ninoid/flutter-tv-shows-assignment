import 'dart:convert';

import '../web_api_service.dart';

class TvShowDetailsModel {

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int likesCount;
  final String type;


  TvShowDetailsModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.likesCount,
    required this.type,
  });
  

  String get imageUrlAbsolute => WebApiService.webApiBaseUrl + imageUrl;


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'likesCount': likesCount,
      'type': type,
    };
  }

  factory TvShowDetailsModel.fromMap(Map<String, dynamic> map) {
    return TvShowDetailsModel(
      id: map['_id'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      likesCount: map['likesCount'],
      type: map['type'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TvShowDetailsModel.fromJson(String source) => TvShowDetailsModel.fromMap(json.decode(source));
  
}
