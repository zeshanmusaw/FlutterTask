import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../APIService/api_service.dart';
import '../../BLoC/apibloc.dart';
import '../../Events/apievents.dart';
import '../../Model/blog_model.dart';
import '../../States/apistates.dart';

class Apiscreen extends StatefulWidget {
  const Apiscreen({super.key});

  @override
  State<Apiscreen> createState() => _ApiscreenState();
}

class _ApiscreenState extends State<Apiscreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blogs')),
      body: BlocProvider(
        create: (context) => ApiBloc(ApiService(Dio()))..add(FetchBlogs()),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bodyController,
                decoration: InputDecoration(labelText: 'Body'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Create a Blog object using the input data
                final blog = Blog(title: titleController.text, body: bodyController.text);

                // Dispatch an AddBlog event instead of trying to add ApiBloc
                context.read<ApiBloc>().add(AddBlog(blog));

                // Clear the input fields
                titleController.clear();
                bodyController.clear();
              },
              child: Text('Add Blog'),
            ),
            Expanded(
              child: BlocBuilder<ApiBloc, ApiState>(
                builder: (context, state) {
                  if (state is BlogLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is BlogError) {
                    return Center(child: Text(state.message));
                  } else if (state is BlogLoaded) {
                    return ListView.builder(
                      itemCount: state.blogs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.blogs[index].title,style:TextStyle( fontSize: 25,color: Colors.black,)),
                          subtitle: Text(state.blogs[index].body,style:TextStyle( fontSize: 20,color: Colors.black,)),
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
}
