import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/blocs.dart';

import '../../models/todo_model.dart';

class ShowTodos extends StatelessWidget {
  const ShowTodos({super.key});

  @override
  Widget build(BuildContext context) {
    // Cubit 의 함수를 직접 호출하는 경우가 아니면 Cubit을 Bloc 로 변경하면 됨
    // final todos = context.watch<FilteredTodosCubit>().state.filteredTodos;
    final todos = context.watch<FilteredTodosBloc>().state.filteredTodos;

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
        );
      },
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(todos[index].id),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          child: TodoItem(todo: todos[index]),
          onDismissed: (_) {
            // Cubit 의 함수를 직접 호출하는 경우에는 .add( event ) 로 변경.
            // context.read<TodoListCubit>().removeTodo(todos[index]);
            context
                .read<TodoListBloc>()
                .add(TodoRemovedEvent(todo: todos[index]));
          },
          confirmDismiss: (direction) {
            return showDialog(
              context: context,
              // false : modal dialog,  true : modeless dialog
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Are you sure?'),
                  content:
                      const Text('Do you really want to delete this item ?'),
                  actions: [
                    TextButton(
                      child: const Text('No'),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                    TextButton(
                      child: const Text('Yes'),
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget showBackground(int direction) {
    return Container(
      // color: Colors.green,
      color: const Color.fromRGBO(0, 255, 0, 0.2),
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      alignment: direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
      child: const Icon(
        Icons.delete,
        color: Colors.grey,
        size: 30.0,
      ),
    );
  }
}

// 생성자로 Todo 아이템을 전달받아서 보여주는 위젯이므로 StatefulWidget으로 생성
class TodoItem extends StatefulWidget {
  final Todo todo;

  const TodoItem({super.key, required this.todo});

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool bEmpty = false;
            _textController.text = widget.todo.desc;
            // showDialog() 는 TodoItem widget 의 child widget 에 포함되지 않으므로
            // StatefulBuilder() 를 사용
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                title: const Text('Edit Todo'),
                content: TextField(
                  controller: _textController,
                  autofocus: true,
                  decoration: InputDecoration(
                      errorText: bEmpty ? 'Value Can\'t Be Empty' : null),
                ),
                actions: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  TextButton(
                    child: const Text('Edit'),
                    onPressed: () {
                      // State 변경 시 호출됨.
                      setState(
                        () {
                          bEmpty = _textController.text.isEmpty ? true : false;
                          if (!bEmpty) {
                            // Cubit 의 함수를 직접 호출하는 경우에는 .add( event ) 로 변경.
                            // context.read<TodoListCubit>().editTodo(
                            //   widget.todo.id,
                            //   _textController.text,
                            // );
                            context.read<TodoListBloc>().add(TodoEditedEvent(
                                id: widget.todo.id,
                                todoDesc: _textController.text));
                            Navigator.pop(context);
                          }
                        },
                      );
                    },
                  ),
                ],
              );
            });
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          // Cubit 의 함수를 직접 호출하는 경우가 아니면 Cubit을 Bloc 로 변경하면 됨
          // context.read<TodoListCubit>().toggleTodo(widget.todo.id);
          context
              .read<TodoListBloc>()
              .add(TodoToggledEvent(id: widget.todo.id));
        },
      ),
      // widget 자신을 참조할 때, widget. 으로 접근함.
      title: Text(widget.todo.desc),
    );
  }
}
