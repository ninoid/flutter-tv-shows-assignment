import 'dart:convert';


class AddNewEpisodeWebApiRequestModel {

  final String showId;
  final String mediaId;
  final String title;
  final String description;
  final String episodeNumber;
  final String season;


  AddNewEpisodeWebApiRequestModel({
    required this.showId,
    required this.mediaId,
    required this.title,
    required this.description,
    required this.episodeNumber,
    required this.season,
  });


  @override
  String toString() {
    return toJson();
  }
  

  Map<String, dynamic> toMap() {
    return {
      'showId': showId,
      'mediaId': mediaId,
      'title': title,
      'description': description,
      'episodeNumber': episodeNumber,
      'season': season,
    };
  }

  factory AddNewEpisodeWebApiRequestModel.fromMap(Map<String, dynamic> map) {
    return AddNewEpisodeWebApiRequestModel(
      showId: map['showId'],
      mediaId: map['mediaId'],
      title: map['title'],
      description: map['description'],
      episodeNumber: map['episodeNumber'],
      season: map['season'],
    );
  }

  String toJson() => json.encode(toMap());

  factory AddNewEpisodeWebApiRequestModel.fromJson(String source) => AddNewEpisodeWebApiRequestModel.fromMap(json.decode(source));

}
