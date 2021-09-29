
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_config.dart';
import '../models/web_api_result.dart';
import '../web_api_service.dart';

import '../models/current_user_login_credentials.dart';

abstract class UserRepository {


  Future<bool> isUserLoggedInAndSessionValid();

  Future<bool> saveWebApiAuthTokenToSharedPrefs(String token);

  Future<WebApiResult<String?>> webApiUserLoginWithEmailAndPassword({required String email, required String password});

  Future<CurrentUserCredientalsModel?> restoreCurrentUserLoginCredientals();

  Future<void> saveCurrentUserLoginCredientalsModel(CurrentUserCredientalsModel model);

  Future<void> removeCurrentUserLoginCredientalsModel();

  Future<void> clearAllAuthenticationCache();

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
  Future<WebApiResult<String?>> webApiUserLoginWithEmailAndPassword({
    required String email, 
    required String password
  }) async {

    try {
      final dioResponse = await WebApiService.instance.userLogin(email: email, password: password);
      final WebApiResult<String> apiResult = WebApiResult.fromDioResponse(dioResponse);
      apiResult.result = dioResponse.data["data"]?["token"]?.toString();
      return apiResult;
    } catch (e) {
      return WebApiResult.fromError(e);
    }

  }


  // On UnAuthenticate/SignOut
  @override
  Future<void> clearAllAuthenticationCache() async {
    final sp = await SharedPreferences.getInstance();
    await Future.wait([
      sp.remove(WEB_API_AUTH_TOKEN_SHARED_PREFS_KEY),
      removeCurrentUserLoginCredientalsModel()
    ]);
  }


}