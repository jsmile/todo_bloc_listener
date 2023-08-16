import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../todo_list/todo_list_bloc.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  // 연결(감시) 대상 State의 Cubit 선언
  final TodoListBloc todoListBloc;
  // 생성자의 body 에서 초기화가 가능하도록 late 키워드를 사용.
  late final StreamSubscription todoListSubscription;
  // 초기 TODO List count 반영 시 사용
  final int initialActiveTodoCount;

  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
    required this.todoListBloc,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    todoListSubscription =
        todoListBloc.stream.listen((TodoListState todoListState) {
      final activeTodoCount = todoListState.todos
          .where((Todo todo) => !todo.completed)
          .toList()
          .length;
      // 대상 state 를 listen 하고 있다가 대상 state가 변경되면 현재 이벤트를 발생시키고
      add(ActiveTodoCountCalculatedEvent(activeTodoCount: activeTodoCount));
    });

    // 현재 이벤트가 발생하면 현재 State를 변경시킴.
    on<ActiveTodoCountCalculatedEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }

  @override
  Future<void> close() {
    todoListSubscription.cancel();
    return super.close();
  }
}
