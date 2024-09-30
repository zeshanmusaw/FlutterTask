abstract class FirebaseState {}

class FirebaseInitial extends FirebaseState {}

class FirebaseLoaded extends FirebaseState {
  final List<dynamic> data;
  FirebaseLoaded(this.data);
}

class FirebaseLoading extends FirebaseState {}

class FirebaseError extends FirebaseState {
  final String message;
  FirebaseError(this.message);
}
