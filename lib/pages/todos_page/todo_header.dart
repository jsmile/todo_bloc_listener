import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/active_todo_count/active_todo_count_bloc.dart';
import '../../blocs/todo_list/todo_list_bloc.dart';
import '../../models/todo_model.dart';

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
        BlocListener<TodoListBloc, TodoListState>(
          // TodoListState 가 변경되면 activeTodoCount 를 다시 계산해서
          listener: (context, state) {
            final int activeTodoCount = state.todos
                .where(
                  (Todo todo) => !todo.completed,
                )
                .toList()
                .length;
            // 변경된 내용을 ActiveTodoCountBloc 의 이벤트에 전달함.
            context.read<ActiveTodoCountBloc>().add(
                  ActiveTodoCountCalculatedEvent(
                    activeTodoCount: activeTodoCount,
                  ),
                );
          },
          child: BlocBuilder<ActiveTodoCountBloc, ActiveTodoCountState>(
            builder: (context, state) {
              return Text(
                '${state.activeTodoCount} items left',
                style: const TextStyle(color: Colors.redAccent, fontSize: 20.0),
              );
            },
          ),
        ),
        // Text(
        //   // Cubit 의 함수를 직접 호출하는 경우가 아니면 Cubit을 Bloc 로 변경하면 됨.
        //   '${context.watch<ActiveTodoCountBloc>().state.activeTodoCount} items left',
        //   style: const TextStyle(
        //     color: Colors.green,
        //     fontSize: 20.0,
        //     fontWeight: FontWeight.w500,
        //   ),
        // ),
      ],
    );
  }
}
