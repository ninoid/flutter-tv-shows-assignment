
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';

import '../models/current_user_login_credentials.dart';

class UserRepository {

  Database get _sembastDatabase => GetIt.I.get<Database>();
  final _mainStore = StoreRef.main();
  static const _currentUserLoginCredientalsRecordId = "currentUserLoginCredientals";


  Future<bool> isUserLoggedInAndSessionValid() async {
    await Future.delayed(Duration(milliseconds: 300));
    return Future.value(false);
  }


  Future<CurrentUserCredientalsModel?> restoreCurrentUserLoginCredientals() async {
    final data = await _mainStore.record(_currentUserLoginCredientalsRecordId).get(_sembastDatabase);
    if (data is Map<String, dynamic>) {
      return CurrentUserCredientalsModel.fromMap(data);
    }
    return null;
  }

  Future<void> saveCurrentUserLoginCredientalsModel(CurrentUserCredientalsModel model) async {
    await _mainStore.record(_currentUserLoginCredientalsRecordId).put(_sembastDatabase, model.toMap());
  }

  Future<void> removeCurrentUserLoginCredientalsModel() async {
    await _mainStore.record(_currentUserLoginCredientalsRecordId).delete(_sembastDatabase);
  }


}