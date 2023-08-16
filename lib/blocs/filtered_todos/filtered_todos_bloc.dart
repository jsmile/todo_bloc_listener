import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';
import '../todo_filter/todo_filter_bloc.dart';
import '../todo_list/todo_list_bloc.dart';
import '../todo_search/todo_search_bloc.dart';

part 'filtered_todos_event.dart';
part 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodoListBloc todoListBloc;
  final TodoFilterBloc todoFilterBloc;
  final TodoSearchBloc todoSearchBloc;

  final List<Todo> initialFilteredTodos;

  late final StreamSubscription todoListSubscription;
  late final StreamSubscription todoFilterSubscription;
  late final StreamSubscription todoSearchSubscription;

  FilteredTodosBloc({
    required this.initialFilteredTodos,
    required this.todoListBloc,
    required this.todoFilterBloc,
    required this.todoSearchBloc,
  }) : super(FilteredTodosState(filteredTodos: initialFilteredTodos)) {
    todoListSubscription = todoListBloc.stream.listen(
      (TodoListState todoListState) {
        setFilteredTodos();
      },
    );
    todoFilterSubscription = todoFilterBloc.stream.listen(
      (TodoFilterState todoFilterState) {
        setFilteredTodos();
      },
    );
    todoSearchSubscription = todoSearchBloc.stream.listen(
      (TodoSearchState todoSearchState) {
        setFilteredTodos();
      },
    );

    // 현재 이벤트가 발생하면 현재 State를 변경시킴..
    on<FilteredTodosCalculatedEvent>((event, emit) {
      emit(state.copyWith(filteredTodos: event.fiilteredTodos));
    });
  }

  void setFilteredTodos() {
    // 현재 Event 에 필요한 param 을 선언
    List<Todo> filteredTodos;

    // 먼저 현재의 Filter 상태를 반영한 Todo List 를 구하고,
    switch (todoFilterBloc.state.filter) {
      case Filter.active:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => !todo.completed)
            .toList();
        break;

      case Filter.completed:
        filteredTodos = todoListBloc.state.todos
            .where((Todo todo) => todo.completed)
            .toList();
        break;

      case Filter.all:
      default:
        filteredTodos = todoListBloc.state.todos;
        break;
    }

    // 현재의 Filter 상태에서 검색어를 반영한 Todo List 를 구한 뒤,
    if (todoSearchBloc.state.searchTerm.isNotEmpty) {
      filteredTodos = filteredTodos
          .where((Todo todo) => todo.desc
              .toLowerCase()
              .contains(todoSearchBloc.state.searchTerm.toLowerCase()))
          .toList();
    }

    // 대상 state 를 listen 하고 있다가 대상 state가 변경되면 현재 이벤트를 발생시키고
    // 구해진 param( filteredTodos ) 을 전달한다.
    add(FilteredTodosCalculatedEvent(fiilteredTodos: filteredTodos));
  }
}
