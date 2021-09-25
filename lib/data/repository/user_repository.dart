
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tv_shows/core/app_config.dart';
import 'package:tv_shows/data/web_api_service.dart';

import '../models/current_user_login_credentials.dart';

abstract class UserRepository {


  Future<bool> isUserLoggedInAndSessionValid();

  Future<bool> saveWebApiAuthTokenToSharedPrefs(String token);

  Future<String?> webApiUserLoginWithEmailAndPassword({required String email, required String password});

  Future<CurrentUserCredientalsModel?> restoreCurrentUserLoginCredientals();

  Future<void> saveCurrentUserLoginCredientalsModel(CurrentUserCredientalsModel model);

  Future<void> removeCurrentUserLoginCredientalsModel();

}

class UserRepositoryImpl extends UserRepository {

  Database get _sembastDatabase => GetIt.I.get<Database>();
  final _mainStore = StoreRef.main();
  static const _currentUserLoginCredientalsRecordId = "currentUserLoginCredientals";


  @override
  Future<bool> isUserLoggedInAndSessionValid() async {
    final sp = await SharedPreferences.getInstance();
    final token = sp.getString(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY);
    final tokenOk = (token ?? "").isNotEmpty;
    await Future.delayed(Duration(milliseconds: 300));
    return Future.value(false);
  }


  @override
  Future<bool> saveWebApiAuthTokenToSharedPrefs(String token) async {
    final sp = await SharedPreferences.getInstance();
    return await sp.setString(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY, token);
  }


  @override
  Future<CurrentUserCredientalsModel?> restoreCurrentUserLoginCredientals() async {
    final data = await _mainStore.record(_currentUserLoginCredientalsRecordId).get(_sembastDatabase);
    if (data is Map<String, dynamic>) {
      return CurrentUserCredientalsModel.fromMap(data);
    }
    return null;
  }

  @override
  Future<void> saveCurrentUserLoginCredientalsModel(CurrentUserCredientalsModel model) async {
    await _mainStore.record(_currentUserLoginCredientalsRecordId).put(_sembastDatabase, model.toMap());
  }

  @override
  Future<void> removeCurrentUserLoginCredientalsModel() async {
    await _mainStore.record(_currentUserLoginCredientalsRecordId).delete(_sembastDatabase);
  }


  @override
  Future<String?> webApiUserLoginWithEmailAndPassword({required String email, required String password}) async {
    final response = await WebApiService.instance.userLogin(email: email, password: password);
    if (response.statusCode == 200) {
      return response.data["dataa"]?["token"]?.toString();
    }
    return null;
  }


}