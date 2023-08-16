part of 'filtered_todos_bloc.dart';

sealed class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class FilteredTodosCalculatedEvent extends FilteredTodosEvent {
  final List<Todo> fiilteredTodos;

  const FilteredTodosCalculatedEvent({required this.fiilteredTodos});

  @override
  String toString() =>
      'FilteredTodosCalculatedEvent(fiilteredTodos: $fiilteredTodos)';

  @override
  List<Object> get props => [fiilteredTodos];
}
