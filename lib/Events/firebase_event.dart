abstract class FirebaseEvent {}

class LoadFirebaseData extends FirebaseEvent {}
class AddFirebaseData extends FirebaseEvent {
  final String data;

  AddFirebaseData(this.data);
}
