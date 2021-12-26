import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/todomodel.dart';
import 'package:todoapp/todo.dart';


class Databaseservice{
  CollectionReference todoCollection=FirebaseFirestore.instance.collection("Todos");

  Future createNewTodo(String title) async {
    return await todoCollection.add({
      "title": title,
      "iscomplete": false,
    });
  }
Future completetask(uid) async{
    await todoCollection.doc(uid).update({"isComplete":true});
}

Future removeTodo(uid) async {
    await todoCollection.doc(uid).delete();
  }
List<Todo> todoFromFirestore(QuerySnapshot snapshot){
    if(snapshot!=null)
      {
        return snapshot.docs.map((e){
          return Todo(
              iscomplete:e["iscomplete"],
              title: e["title"],
              uid: e.id,


          );
        }).toList();
      }
    else{
      return [];
    }

  }
Stream<List<Todo>> listTodos(){
 return todoCollection.snapshots().map(todoFromFirestore);
}
}