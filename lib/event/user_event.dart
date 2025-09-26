abstract class UserEvent {}

class FetchUsers extends UserEvent {}

class AddUserByName extends UserEvent {
  final String name;
  AddUserByName(this.name);
}
