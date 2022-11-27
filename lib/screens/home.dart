import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import '../models/todo.dart';
import '../widgets/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // const Home({Key? key}) : super(key: key);

  late FocusNode _nodeSearchBox, _nodeAddBox;

  List<ToDo> todoList = [];
  String localText = "";
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    getData();
    _foundToDo = todoList;
    super.initState();

    _nodeSearchBox = FocusNode();
    _nodeAddBox = FocusNode();
  }

  @override
  void dispose() {
    FocusScope.of(context).unfocus();
    _nodeSearchBox.dispose();
    _nodeAddBox.dispose();
    // Clean up the focus node when the Form is disposed.
    super.dispose();
  }

  getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      // pref.setString("todolist", todoList[0].todoText);
      localText = pref.get("todolist") != null && !pref.get("todolist").isEmpty
          ? pref.get("todolist")
          : "4455";
      print("localText: " + localText);
      var map = jsonDecode(localText) as List;
      // String cachedToDo = jsonDecode(localText);
      List<ToDo> tempToDoList = map.map((e) => ToDo.fromJson(e)).toList();
      todoList = tempToDoList;
      _foundToDo = tempToDoList;
      // ToDo dd = ToDo.fromJson(map);
      // todoList.add(dd);
      // print("aaaa: " + dd.todoText);
      // print("cachedToDo: " + dd.todoText);
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onDoubleTap: () {},
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 50),
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              child: Column(
                children: [
                  searchBox(),
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 20),
                          child: Text(
                            'App todo',
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                        for (ToDo todo in _foundToDo)
                          TodoItem(
                            todo: todo,
                            onToDoChanged: _handleToDoChange,
                            onToDoDelete: _handleToDoDelete,
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                        right: 20,
                        left: 20,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 0.0,
                          ),
                        ],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _todoController,
                        focusNode: _nodeAddBox,
                        decoration: InputDecoration(
                          hintText: 'Add new todo item',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        '+',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      onPressed: () {
                        _addTodoItem(_todoController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                    ),
                    child: ElevatedButton(
                      child: Text(
                        '>',
                        style: TextStyle(
                          fontSize: 40,
                        ),
                      ),
                      onPressed: () {
                        if (_todoController.text != null &&
                            _todoController.text.length > 0) {
                          _addTodoItem(_todoController.text);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: tdBlue,
                        minimumSize: Size(60, 60),
                        elevation: 10,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
    syncToLocalStorage();
  }

  void _handleToDoDelete(String id) {
    setState(() {
      todoList.removeWhere((element) => element.id == id);
    });
    syncToLocalStorage();
  }

  void syncToLocalStorage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("todolist", jsonEncode(todoList));
  }

  void _addTodoItem(String todoText) {
    if (todoText.isNotEmpty) {
      ToDo todo = ToDo(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        todoText: todoText,
      );
      setState(() {
        todoList.add(todo);
      });
      syncToLocalStorage();
      _todoController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _runFilter(String keyword) {
    List<ToDo> result = [];
    if (keyword.isEmpty) {
      result = todoList;
    } else {
      result = todoList
          .where((element) =>
              element.todoText!.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = result;
    });
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
        focusNode: _nodeSearchBox,
        onChanged: (value) {
          _runFilter(value);
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: tdBlack, size: 20),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(color: tdGrey)),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      elevation: 0,
      title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        Container(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/images/avatar.jpeg'),
          ),
        )
      ]),
    );
  }
}
