import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/models/database.dart';

import 'models/todomodel.dart';
//ignore_for_file:prefer_const_constructors
class TodoList extends StatefulWidget {

   TodoList({Key? key,title,iscomplete,uid}) : super(key: key);

   @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  bool iscomplete =false;



  TextEditingController todoTitleController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:StreamBuilder<List<Todo>>(
          stream: Databaseservice().listTodos(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            List<Todo> todos = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tasks',
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 10,),
                  Expanded(
                    child: ListView.separated(
                      separatorBuilder:(context,index)=>Divider(color: Colors.grey[800],),
                        itemCount:todos.length,
                        shrinkWrap:true,
                        itemBuilder: (context,index){
                     return Dismissible(
                       key: Key(todos[index].title),
                       background: Container(padding: EdgeInsets.only(left: 10),alignment: Alignment.centerLeft,child: Icon(Icons.delete),color: Colors.red,),
                       onDismissed: (direction) async{
                         await Databaseservice().removeTodo(todos[index].uid);
                       },
                       child: ListTile(
                         onTap: (){
                           Databaseservice().completetask(todos[index].uid);
                         },
                         leading: Container(
                           height: 20,
                           width: 20,
                           decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor,
                             shape: BoxShape.circle
                           ),
                           child:iscomplete?Icon(Icons.check,color: Colors.white,):Container(

                           ),
                         ),
                         title: Text(todos[index].title,style: TextStyle(
                           fontSize: 20,
                           color: Colors.grey.shade200,
                           fontWeight: FontWeight.w600
                         ),),
                       ),
                     );
                    }),
                  )
                ],
              ),
            );
          }
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialog(

          context:context, builder: (BuildContext context) => SimpleDialog(
          contentPadding: EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 20
          ),
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          title: Row(
            children: [
              Text('Add todo',style: TextStyle(fontSize: 18,color: Colors.white),),
              Spacer(),
              IconButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.cancel))
            ],
          ),
          children: [
            Divider(),
            TextFormField(
              controller: todoTitleController,
              autofocus: true,
              style: TextStyle(
                height: 1.5,
                fontSize: 13,
                color: Colors.white
              ),
              decoration: InputDecoration(
                hintText: 'eg. assignment',
                hintStyle:TextStyle(fontSize: 13,color: Colors.white),
                border: InputBorder.none,
              ),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: FlatButton(onPressed: () async {
                if(todoTitleController.text.isNotEmpty){
                  await Databaseservice().createNewTodo(todoTitleController.text.trim());
                }
              },
                child: Text('Add'),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,

              ),
            )
          ],
        ),


        );
      },
        child: Icon(Icons.add),

      ),
    );
  }
}
