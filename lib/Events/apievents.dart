import '../Model/blog_model.dart';

abstract class ApiEvent {}

class FetchBlogs extends ApiEvent {}

class AddBlog extends ApiEvent {
  final Blog blog;

  AddBlog(this.blog);
}
