
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BLoC/firebasebloc.dart';
import '../../Events/firebase_event.dart';
import '../../States/firebase_state.dart';

class FirebaseScreen extends StatefulWidget {
  const FirebaseScreen({super.key});

  @override
  State<FirebaseScreen> createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (_) => FirebaseBloc()..add(LoadFirebaseData()),
      child: Scaffold(

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter data',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        context
                            .read<FirebaseBloc>()
                            .add(AddFirebaseData(_controller.text));
                        _controller.clear();
                      }
                      setState(() {

                      });
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<FirebaseBloc, FirebaseState>(
                builder: (context, state) {
                  if (state is FirebaseLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is FirebaseLoaded) {
                    return ListView.builder(
                      itemCount: state.data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.data[index]['name'] ?? 'No Name',style:TextStyle( fontSize: 25,color: Colors.black,)),
                        );
                      },
                    );
                  } else if (state is FirebaseError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text('No data available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
