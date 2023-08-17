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

    return MultiBlocListener(
      // 각 Listener에서는 State 변경 시마다 fiiteredTodos 를 다시 계산해서 Event 에 전달함.
      listeners: [
        BlocListener<TodoListBloc, TodoListState>(
          listener: (context, state) {
            // filteredTodos 를 구해서
            final filteredTodos = setFilteredTodos(
              state.todos,
              context.read<TodoFilterBloc>().state.filter,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            // 변경된 내용을 FilteredTodosBloc 의 이벤트에 전달함.
            context.read<FilteredTodosBloc>().add(FilteredTodosCalculatedEvent(
                  fiilteredTodos: filteredTodos,
                ));
          },
        ),
        BlocListener<TodoFilterBloc, TodoFilterState>(
          listener: (context, state) {
            // filteredTodos 를 구해서
            final filteredTodos = setFilteredTodos(
              context.read<TodoListBloc>().state.todos,
              state.filter,
              context.read<TodoSearchBloc>().state.searchTerm,
            );
            // 변경된 내용을 FilteredTodosBloc 의 이벤트에 전달함.
            context.read<FilteredTodosBloc>().add(FilteredTodosCalculatedEvent(
                  fiilteredTodos: filteredTodos,
                ));
          },
        ),
        BlocListener<TodoSearchBloc, TodoSearchState>(
          listener: (context, state) {
            // filteredTodos 를 구해서
            final filteredTodos = setFilteredTodos(
              context.read<TodoListBloc>().state.todos,
              context.read<TodoFilterBloc>().state.filter,
              state.searchTerm,
            );
            // 변경된 내용을 FilteredTodosBloc 의 이벤트에 전달함.
            context.read<FilteredTodosBloc>().add(FilteredTodosCalculatedEvent(
                  fiilteredTodos: filteredTodos,
                ));
          },
        ),
      ],
      child: ListView.separated(
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
      ),
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

  // filteredTodos 를 반환하는 함수로 변경( param 에 맞춰서 내부 항목들 변경)
  List<Todo> setFilteredTodos(
      List<Todo> todos, Filter filter, String searchTerm) {
    // 현재 Event 에 필요한 param 을 선언
    List<Todo> filteredTodos;

    // 먼저 현재의 Filter 상태를 반영한 Todo List 를 구하고,
    switch (filter) {
      case Filter.active:
        filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;

      case Filter.completed:
        filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;

      case Filter.all:
      default:
        filteredTodos = todos;
        break;
    }

    // 현재의 Filter 상태에서 검색어를 반영한 Todo List 를 구한 뒤,
    if (searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((Todo todo) =>
              todo.desc.toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
    }

    return filteredTodos;
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
