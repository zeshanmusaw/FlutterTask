import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import '../Model/blog_model.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/posts")
  Future<List<Blog>> getBlogs();

  @POST("/posts")
  Future<Blog> addBlog(@Body() Blog blog);
}
