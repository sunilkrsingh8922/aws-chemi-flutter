import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hipsterassignment/services/UserApiService.dart';
import '../model/User.dart';
import '../state/user_state.dart';
import 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GraphQLClient client;

  UserBloc(this.client) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<AddUserByName>(_onAddUserByName);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final restUsers = await UserApiService.fetchUsers();
      emit(UserLoaded(restUsers));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onAddUserByName(
    AddUserByName event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;
    if (currentState is! UserLoaded) return;

    try {
      final created = await UserApiService.addUser(event.name);
      final updated = List<User>.from(currentState.users)..insert(0, created);
      emit(UserLoaded(updated));
    } catch (_) {
      emit(UserError('Failed to add user. Please try again.'));
    }
  }
}
