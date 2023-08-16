import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/todo_model.dart';

part 'todo_list_event.dart';
part 'todo_list_state.dart';

class TodoListBloc extends Bloc<TodoListEvent, TodoListState> {
  TodoListBloc() : super(TodoListState.initial()) {
    on<TodoAddedEvent>(_addTodo);
    on<TodoEditedEvent>(_editTodo);
    on<TodoRemovedEvent>(_removeTodo);
    on<TodoToggledEvent>(_toggleTodo);
  }

  void _addTodo(TodoAddedEvent event, Emitter<TodoListState> emit) {
    final newTodo = Todo(desc: event.todoDesc);
    final newTodos = [...state.todos, newTodo];
    emit(state.copyWith(todos: newTodos));
    print('*** TODO State : $state');
  }

  // 수정사항이 있다면 state 전체( state.todos )를 바꾸는 방식.
  void _editTodo(TodoEditedEvent event, Emitter<TodoListState> emit) {
    // 기존 State의 todos를 map으로 순회하면서
    final newTodos = state.todos.map(
      (Todo todo) {
        // 동일한 기존 id 가 존재하면
        if (todo.id == event.id) {
          return Todo(
            id: event.id,
            desc: event.todoDesc, // 새로운 desc로 변경
            completed: todo.completed,
          );
        } else {
          return todo;
        }
      },
    ).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void _removeTodo(TodoRemovedEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos
        .where(
          (Todo old) => old.id != event.todo.id,
        )
        .toList();
    // state.todos.where((Todo old) {
    //   if(old.id != todo.id) {return true;}
    //   else {return false;}
    // }).toList();
    emit(state.copyWith(todos: newTodos));
  }

  void _toggleTodo(TodoToggledEvent event, Emitter<TodoListState> emit) {
    final newTodos = state.todos.map(
      (Todo todo) {
        if (todo.id == event.id) {
          return Todo(
            id: todo.id,
            desc: todo.desc,
            completed: !todo.completed,
          );
        } else {
          return todo;
        }
      },
    ).toList();

    emit(state.copyWith(todos: newTodos));
  }
}
