import 'package:flutter/material.dart';
import 'package:todoapp/todo.dart';
import 'package:firebase_core/firebase_core.dart';
//ignore_for_file:prefer_const_constructors
void main()
{
  runApp(Myapp());
}
class Myapp extends StatelessWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future:Firebase.initializeApp(),
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text(snapshot.error.toString()),),);
        }
          if(snapshot.connectionState==ConnectionState.waiting)
            {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.indigo
          ),
          home: TodoList(),
        );
      }
    );
  }
}
