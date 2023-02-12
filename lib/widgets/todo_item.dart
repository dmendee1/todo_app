import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/constants/colors.dart';

import '../models/todo.dart';

class TodoItem extends StatelessWidget {
  final ToDo todo;
  final onToDoChanged;
  final onToDoDelete;

  const TodoItem(
      {Key? key,
      required this.todo,
      required this.onToDoChanged,
      required this.onToDoDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      color: Colors.white,
      child: Slidable(
          enabled: true,
          startActionPane: ActionPane(
            extentRatio: 0.5,
            dragDismissible: false,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: ((context) => {onToDoChanged(todo)}),
                backgroundColor: todo.isDone ? Colors.blue : Colors.green,
                icon: todo.isDone ? Icons.undo : Icons.done,
              ),
              SlidableAction(
                onPressed: ((context) => {}),
                backgroundColor: Colors.yellow,
                icon: Icons.done,
              ),
              SlidableAction(
                onPressed: ((context) => {}),
                backgroundColor: Colors.orange,
                icon: Icons.next_plan_rounded,
              ),
            ],
          ),
          // endActionPane: ActionPane(
          //   extentRatio: 0.2,
          //   motion: const ScrollMotion(),
          //   children: [
          //     SlidableAction(
          //       onPressed: ((context) => {onToDoDelete(todo.id)}),
          //       backgroundColor: Colors.red,
          //       icon: Icons.delete,
          //     )
          //   ],
          // ),
          child: ListTile(
            onLongPress: () {
              print("Long press at the ");
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            tileColor: Colors.white,
            leading: Icon(
              todo.isDone ? Icons.check_box : Icons.check_box_outline_blank,
              color: tdBlue,
            ),
            title: Text(
              todo.todoText!,
              style: TextStyle(
                fontSize: 16,
                color: tdBlack,
                decoration: todo.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          )),
    );
  }
}
