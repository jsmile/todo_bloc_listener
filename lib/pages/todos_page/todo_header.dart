import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/active_todo_count/active_todo_count_bloc.dart';

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
        // BlocBuilder<ActiveTodoCountCubit, ActiveTodoCountState>(
        //   builder: (context, state) {
        //     return Text(
        //       '${state.activeTodoCount} items left',
        //       style: TextStyle(color: Colors.redAccent, fontSize: 20.0),
        //     );
        //   },
        // ),
        Text(
          // Cubit 의 함수를 직접 호출하는 경우가 아니면 Cubit을 Bloc 로 변경하면 됨.
          '${context.watch<ActiveTodoCountBloc>().state.activeTodoCount} items left',
          style: const TextStyle(
            color: Colors.green,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
