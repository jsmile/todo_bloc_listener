part of 'todo_list_bloc.dart';

sealed class TodoListEvent extends Equatable {
  const TodoListEvent();

  @override
  List<Object> get props => [];
}
// 각 이벤트에서 필요한 항목들을 event의 생성자 param들로 받아올 수 있게 준비함.

// Todo 추가 이벤트( todoDesc: 할일 )
class TodoAddedEvent extends TodoListEvent {
  final String todoDesc;

  const TodoAddedEvent({required this.todoDesc});

  @override
  String toString() => 'TodoAddedEvent(todoDesc: $todoDesc)';

  @override
  List<Object> get props => [todoDesc];
}

// todo 수정 이벤트( id: 할일의 id, todoDesc: 할일 )
class TodoEditedEvent extends TodoListEvent {
  final String id;
  final String todoDesc;

  const TodoEditedEvent({
    required this.id,
    required this.todoDesc,
  });

  @override
  String toString() => 'TodoEditedEvent(id: $id, todoDesc: $todoDesc)';

  @override
  List<Object> get props => [id, todoDesc];
}

// 완료여부 toggle 이벤트( id: 할일의 id )
class TodoToggledEvent extends TodoListEvent {
  final String id;

  const TodoToggledEvent({required this.id});

  @override
  String toString() => 'TodoToggledEvent(id: $id)';

  @override
  List<Object> get props => [id];
}

// todo 항목 제거( todo: 삭제할 할일 )
class TodoRemovedEvent extends TodoListEvent {
  final Todo todo;

  const TodoRemovedEvent({required this.todo});

  @override
  String toString() => 'TodoRemovedEvent(todo: $todo)';

  @override
  List<Object> get props => [todo];
}
