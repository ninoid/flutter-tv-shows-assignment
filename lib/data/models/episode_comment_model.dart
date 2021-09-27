
import 'package:equatable/equatable.dart';

class EpisodeCommentModel extends Equatable {

  final String id;

  EpisodeCommentModel({
    required this.id,
  });

  @override
  List<Object?> get props => [id];

}
