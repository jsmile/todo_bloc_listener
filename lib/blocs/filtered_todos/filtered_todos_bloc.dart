import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

// 참조하는 Bloc, StreamSubscription 등에 관련된 부분 삭제처리
class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final List<Todo> initialFilteredTodos;

  FilteredTodosBloc({
    required this.initialFilteredTodos,
  }) : super(FilteredTodosState(filteredTodos: initialFilteredTodos)) {
    // 현재 이벤트가 발생하면 현재 State를 변경시킴..
    on<FilteredTodosCalculatedEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.fiilteredTodos));
    });
  }

  void setFilteredTodos() {
    // 현재 Event 에 필요한 param 을 선언
    List<Todo> filteredTodos;

    // // 먼저 현재의 Filter 상태를 반영한 Todo List 를 구하고,
    // switch (todoFilterBloc.state.filter) {
    //   case Filter.active:
    //     filteredTodos = todoListBloc.state.todos
    //         .where((Todo todo) => !todo.completed)
    //         .toList();
    //     break;

    //   case Filter.completed:
    //     filteredTodos = todoListBloc.state.todos
    //         .where((Todo todo) => todo.completed)
    //         .toList();
    //     break;

    //   case Filter.all:
    //   default:
    //     filteredTodos = todoListBloc.state.todos;
    //     break;
    // }

    // // 현재의 Filter 상태에서 검색어를 반영한 Todo List 를 구한 뒤,
    // if (todoSearchBloc.state.searchTerm.isNotEmpty) {
    //   filteredTodos = filteredTodos
    //       .where((Todo todo) => todo.desc
    //           .toLowerCase()
    //           .contains(todoSearchBloc.state.searchTerm.toLowerCase()))
    //       .toList();
    // }

    // // 대상 state 를 listen 하고 있다가 대상 state가 변경되면 현재 이벤트를 발생시키고
    // // 구해진 param( filteredTodos ) 을 전달한다.
    // add(FilteredTodosCalculatedEvent(fiilteredTodos: filteredTodos));
  }
}
