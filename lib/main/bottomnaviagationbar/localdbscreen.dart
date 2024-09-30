import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Make sure this is imported to use Hive in Flutter
import 'package:task/BLoC/localdb_bloc.dart';
import 'package:task/Events/localdb_events.dart';

import '../../Model/localdb_model.dart';
import '../../States/localbd_states.dart';

class LocalDbScreen extends StatefulWidget {
  const LocalDbScreen({super.key});

  @override
  State<LocalDbScreen> createState() => _LocalDbScreenState();
}

class _LocalDbScreenState extends State<LocalDbScreen> {
  final TextEditingController titleController = TextEditingController();
  Box<LocaldbModel>? blogBox;

  @override
  void initState() {
    super.initState();
    openHiveBox(); // Open the Hive box when the widget initializes
  }

  Future<void> openHiveBox() async {
    // Ensure the box is opened before accessing it
    blogBox = await Hive.openBox<LocaldbModel>('blogsBox');
    setState(() {}); // Trigger UI refresh after the box is opened
  }

  void addBlog(String title) {
    final newBlog = LocaldbModel(title: title);
    blogBox?.add(newBlog); // Add blog to Hive box
    setState(() {}); // Refresh UI (This is not enough, you need to reload the blogs in BLoC)

    // Dispatch the event to reload blogs from Hive
    BlocProvider.of<LocaldbBloc>(context).add(LoadLocaldbEvent());
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocaldbBloc()..add(LoadLocaldbEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Hive Persistence with Blogs'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Enter blog title'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  addBlog(titleController.text); // Add the blog to Hive box
                }
                titleController.clear(); // Clear the text field
              },
              child: Text('Done'),
            ),
            Expanded(
              child: BlocBuilder<LocaldbBloc, LocalbdState>(
                builder: (context, state) {
                  if (state is LocalbdLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is LocalbdError) {
                    return Center(child: Text(state.message));
                  } else if (state is LocalbdLoaded) {
                    return ListView.builder(
                      itemCount: state.blogs.length,
                      itemBuilder: (context, index) {
                        final blog = state.blogs[index];
                        return ListTile(
                          title: Text(blog.title,style:TextStyle( fontSize: 25,color: Colors.black,)),
                        );
                      },
                    );
                  }
                  return Center(child: Text('No blogs found.'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    titleController.dispose(); // Dispose the controller
    Hive.close(); // Close Hive when the widget is disposed
  // Dispose the controller
    blogBox?.close();
    super.dispose();
  }
}
