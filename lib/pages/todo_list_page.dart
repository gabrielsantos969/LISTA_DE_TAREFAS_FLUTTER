import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/models/todo.dart';
import '../widgets/todo_listen_item.dart';

class ToDoListPage extends StatefulWidget {
  ToDoListPage({Key? key}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Todo> todos = [];

  Todo? deletedTodo;
  int? deletedPositionPos;

  final TextEditingController todosController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todosController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Adicione uma tarefa',
                            hintText: 'Estudar Flutter'),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        String text = todosController.text;
                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                        });
                        todosController.clear();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00D7F3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Flexible(
                  child: ListView(shrinkWrap: true, children: [
                    for (Todo todo in todos)
                      TodoListenItem(
                        todo: todo,
                        onDelete: onDelete,
                      ),
                  ]),
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Você possui ${todos.length} tarefas pendentes',
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    ElevatedButton(
                      onPressed: showDeleteTodosConfirmationDialog,
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff00D7F3),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Text(
                        'Limpar tudo',
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedPositionPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Tafera ${todo.title} foi removida com sucesso!',
        style: TextStyle(color: Color(0xff060708)),
      ),
      backgroundColor: Colors.white,
      duration: const Duration(seconds: 5),
      action: SnackBarAction(
        label: 'Desfazer',
        textColor: const Color(0xff00D7F3),
        onPressed: () {
          setState(() {
            todos.insert(deletedPositionPos!, deletedTodo!);
          });
        },
      ),
    ));
  }

  void showDeleteTodosConfirmationDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Limpar tudo?'),
              content:
                  Text('Você tem certeza que deseja apagar todas as tarefas?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                      primary: Color(0xff00D7F3)
                  ),
                  child: Text(
                    'Cancelar',

                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    deleteAllTodos();
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.red
                  ),
                  child: Text('Limpar Tudo'),
                ),
              ],
            ));
  }

  void deleteAllTodos(){
    setState((){
      todos.clear();
    });
  }
}
