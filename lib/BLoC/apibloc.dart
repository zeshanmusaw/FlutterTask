import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';

import '../APIService/api_service.dart';
import '../Events/apievents.dart';
import '../States/apistates.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  final ApiService apiService;

  ApiBloc(this.apiService) : super(BlogInitial()) {
    on<FetchBlogs>((event, emit) async {
      emit(BlogLoading());
      try {
        final blogs = await apiService.getBlogs();
        emit(BlogLoaded(blogs));
      } catch (e) {
        emit(BlogError("Failed to fetch blogs"));
      }
    });

    on<AddBlog>((event, emit) async {
      emit(BlogLoading());
      try {
        await apiService.addBlog(event.blog);
        final blogs = await apiService.getBlogs();
        emit(BlogLoaded(blogs));
      } catch (e) {
        emit(BlogError("Failed to add blog"));
      }
    });
  }
}
