import 'dart:convert';

import 'package:equatable/equatable.dart';

class UploadMediaWebApiResponseModel extends Equatable {
  
  final String id;
  final String path;

  UploadMediaWebApiResponseModel({
    required this.id,
    required this.path,
  });


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'path': path,
    };
  }

  factory UploadMediaWebApiResponseModel.fromMap(Map<String, dynamic> map) {
    return UploadMediaWebApiResponseModel(
      id: map['_id'],
      path: map['path'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UploadMediaWebApiResponseModel.fromJson(String source) => UploadMediaWebApiResponseModel.fromMap(json.decode(source));

  @override
  String toString() => 'UploadMediaWebApiResponseModel(id: $id, path: $path)';

  @override
  List<Object?> get props => [id];
  
}
