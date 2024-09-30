import '../Model/blog_model.dart';

abstract class ApiState {}

class BlogInitial extends ApiState {}

class BlogLoading extends ApiState {}

class BlogLoaded extends ApiState {
  final List<Blog> blogs;

  BlogLoaded(this.blogs);
}

class BlogError extends ApiState {
  final String message;

  BlogError(this.message);
}
