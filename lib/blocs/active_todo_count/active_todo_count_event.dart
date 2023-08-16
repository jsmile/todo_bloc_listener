part of 'active_todo_count_bloc.dart';

sealed class ActiveTodoCountEvent extends Equatable {
  const ActiveTodoCountEvent();

  @override
  List<Object> get props => [];
}

class ActiveTodoCountCalculatedEvent extends ActiveTodoCountEvent {
  final int activeTodoCount;

  const ActiveTodoCountCalculatedEvent({required this.activeTodoCount});

  @override
  String toString() =>
      'ActiveTodoCountCalculatedEvent(activeTodoCount: $activeTodoCount)';

  @override
  List<Object> get props => [activeTodoCount];
}
