// blog_states.dart


import '../Model/localdb_model.dart';

abstract class LocalbdState {}

class LocalbdInitial extends LocalbdState {}

class LocalbdLoading extends LocalbdState {}

class LocalbdLoaded extends LocalbdState {
  final List<LocaldbModel> blogs;

  LocalbdLoaded(this.blogs);
}

class LocalbdError extends LocalbdState {
  final String message;

  LocalbdError(this.message);
}
