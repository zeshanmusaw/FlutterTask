import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:task/Model/localdb_model.dart';
import 'package:task/States/localbd_states.dart';

import '../Events/localdb_events.dart';

class LocaldbBloc extends Bloc<LocaldbEvent, LocalbdState> {
  Box<LocaldbModel>? blogBox;

  LocaldbBloc() : super(LocalbdInitial()) {
    on<LoadLocaldbEvent>((event, emit) async {
      try {
        emit(LocalbdLoading());
        blogBox = await Hive.openBox<LocaldbModel>('blogsBox');
        final List<LocaldbModel> blogs = blogBox?.values.toList() ?? [];
        emit(LocalbdLoaded( blogs));
      } catch (e) {
        emit(LocalbdError('Error loading blogs'));
      }
    });

    on<AddLocaldbEvent>((event, emit) async {
      try {
        blogBox?.add(LocaldbModel(title: event.title));
        // After adding the blog, reload the blogs
        add(LoadLocaldbEvent());
      } catch (e) {
        emit(LocalbdError('Error adding blog'));
      }
    });
  }
}

