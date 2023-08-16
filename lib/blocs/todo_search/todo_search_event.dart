part of 'todo_search_bloc.dart';

sealed class TodoSearchEvent extends Equatable {
  const TodoSearchEvent();

  @override
  List<Object> get props => [];
}

class TodoSearchTermChangedEvent extends TodoSearchEvent {
  final String newSearchTerm;

  const TodoSearchTermChangedEvent({required this.newSearchTerm});

  @override
  String toString() =>
      'TodoSearchTermChangedEvent(newSearchTerm: $newSearchTerm)';

  @override
  List<Object> get props => [];
}
