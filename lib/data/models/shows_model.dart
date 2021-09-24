import 'dart:convert';



class ShowsModel {

  final String title;
  final String imageUrl;
  
  const ShowsModel({
    required this.title,
    required this.imageUrl,
  });

 

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  factory ShowsModel.fromMap(Map<String, dynamic> map) {
    return ShowsModel(
      title: map['title'],
      imageUrl: map['imageUrl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShowsModel.fromJson(String source) => ShowsModel.fromMap(json.decode(source));
}
