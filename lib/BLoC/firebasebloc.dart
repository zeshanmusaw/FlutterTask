import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Events/firebase_event.dart';
import '../States/firebase_state.dart';

class FirebaseBloc extends Bloc<FirebaseEvent, FirebaseState> {
  FirebaseBloc() : super(FirebaseInitial()) {
    on<LoadFirebaseData>(_onLoadFirebaseData);
    on<AddFirebaseData>(_onAddFirebaseData);
    // Listen to real-time changes in Firebase and automatically load data
    FirebaseFirestore.instance.collection('categories').snapshots().listen((snapshot) {
      add(LoadFirebaseData());
    });
  }

  Future<void> _onLoadFirebaseData(
      LoadFirebaseData event, Emitter<FirebaseState> emit) async {
    emit(FirebaseLoading());
    try {
      final QuerySnapshot snapshot =
      await FirebaseFirestore.instance.collection('categories').get();
      final data = snapshot.docs.map((doc) => doc.data()).toList();
      emit(FirebaseLoaded(data));
    } catch (e) {
      emit(FirebaseError('Error loading data'));
    }
  }

  Future<void> _onAddFirebaseData(
      AddFirebaseData event, Emitter<FirebaseState> emit) async {
    try {
      await FirebaseFirestore.instance
          .collection('categories')
          .add({'name': event.data});
      // No need to call LoadFirebaseData manually, snapshot listener will handle it
    } catch (e) {
      emit(FirebaseError('Error adding data'));
    }
  }
}
