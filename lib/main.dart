import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:task/Splash/splashscreen.dart';
import 'APIService/api_service.dart';
import 'BLoC/firebasebloc.dart';
import 'BLoC/localdb_bloc.dart';
import 'Events/localdb_events.dart';
import 'Model/localdb_model.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Add this import

void main() async{
  WidgetsFlutterBinding.ensureInitialized();  // Ensures all bindings are initialized before using Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,  // Passes platform-specific Firebase options
  );
  final dio = Dio();
  final apiService = ApiService(dio);
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter bindings are initialized
  await Hive.initFlutter(); // Initialize Hive
  //await Hive.initFlutter(); // Correctly initialize Hive
  Hive.registerAdapter(LocaldbModelAdapter());// Register your Blog model adapter
  await Hive.openBox<LocaldbModel>('blogsBox'); // Open your Hive box
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<FirebaseBloc>(
          create: (_) => FirebaseBloc(),
        ),
        BlocProvider<LocaldbBloc>(
          create: (_) => LocaldbBloc()..add(LoadLocaldbEvent()), // Provide LocaldbBloc
        ),
      ],
 // Provide Bloc here


    child: MyApp(),
  ),);
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

