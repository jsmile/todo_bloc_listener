import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/todo_list/todo_list_bloc.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final TextEditingController newEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newEditingController,
      decoration: const InputDecoration(labelText: 'What to do?'),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.isNotEmpty) {
          // Cubit 의 함수를 직접 호출하는 경우에는 .add( event ) 로 변경.
          // context.read<TodoListCubit>().addTodo(todoDesc);
          context.read<TodoListBloc>().add(TodoAddedEvent(todoDesc: todoDesc));

          // 입력내용 지우기
          print(
              // Cubit 의 함수를 직접 호출하는 경우가 아니면 Cubit을 Bloc 로 변경하면 됨
              // '### new Todo List : ${context.read<TodoListCubit>().state.todos}');
              '### new Todo List : ${context.read<TodoListBloc>().state.todos}');
          newEditingController.clear();
        }
      },
    );
  }

  @override
  void dispose() {
    newEditingController.dispose();
    super.dispose();
  }
}
