class ToDo {
  String? id;
  String? todoText;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoText,
    this.isDone = false,
  });

  static List<ToDo> todoList() {
    return [
      ToDo(id: '01', todoText: 'Morning excercise', isDone: true),
      ToDo(id: '02', todoText: 'Going to running square'),
      ToDo(id: '03', todoText: 'Brush tooths', isDone: true),
      ToDo(id: '04', todoText: 'Working 2H'),
      ToDo(id: '05', todoText: 'Breaking 2H'),
      ToDo(id: '06', todoText: 'Eating'),
      ToDo(id: '07', todoText: 'Sleeping 8H'),
      ToDo(id: '08', todoText: 'Study 4H'),
    ];
  }
}
