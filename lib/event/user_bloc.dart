import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/model/user.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import '../model/User.dart';
import '../services/user_api_service.dart';
import '../state/user_state.dart';
import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GraphQLClient client;

  UserBloc(this.client) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());

    const String query = r'''
      query {
        users(options: {paginate: {page: 1, limit: 10}}) {
          data {
            id
            name
          }
        }
      }
    ''';

    try {
      final result = await client.query(QueryOptions(document: gql(query)));

      if (result.hasException) {
        emit(UserError(result.exception.toString()));
        return;
      }

      final List data = result.data?['users']['data'] ?? [];
      final apiUsers = data.map((e) => User.fromJson(e)).toList();

      // Fake REST users (shared across devices)
      List<User> restUsers = [];
      try {
        restUsers = (await UserApiService.fetchUsers()).cast<User>();
      } catch (_) {
        // ignore rest api errors
      }

      final box = await Hive.openBox('local_users');
      final List stored = box.get('users', defaultValue: []) as List;
      final localUsers = stored
          .whereType<Map>()
          .map(
            (e) => User(
              id: (e['id'] ?? '').toString(),
              name: (e['name'] ?? '').toString(),
              avatar: (e['avatar'] ?? '').toString(),
              fcmToken: '',
            ),
          )
          .toList();

      final combined = <User>[...restUsers, ...localUsers, ...apiUsers];
      emit(UserLoaded(combined.cast<User>()));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _saveLocalUsers(List<User> users) async {
    try {
      final box = await Hive.openBox('local_users');
      final localOnly = users
          .where((u) => int.tryParse(u.id) != null && u.id.length >= 13)
          .map((u) => u.toJson())
          .toList();
      await box.put('users', localOnly);
    } catch (_) {
      // ignore persistence errors silently for now
    }
  }
}
