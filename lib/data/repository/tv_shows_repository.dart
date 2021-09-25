import 'package:tv_shows/data/models/tv_shows_model.dart';
import 'package:tv_shows/data/web_api_service.dart';

abstract class TvShowsRepository {

  Future<List<TvShowsModel>?> getWebApiShows();

}



class TvShowsRepositoryImpl extends TvShowsRepository {
  
  @override
  Future<List<TvShowsModel>?> getWebApiShows() async {
    final response = await WebApiService.instance.getShows();
    final s = response.data["data"];
    if (s is List) {
      return s.map((e) => TvShowsModel.fromMap(e)).toList();
    }
  }
  
}