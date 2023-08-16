part of 'todo_filter_bloc.dart';

sealed class TodoFilterEvent extends Equatable {
  const TodoFilterEvent();

  @override
  List<Object> get props => [];
}

class TodoFilterChangedEvent extends TodoFilterEvent {
  final Filter newfilter;

  const TodoFilterChangedEvent({required this.newfilter});

  @override
  String toString() => 'TodoFilterChangedEvent(filter: $newfilter)';

  @override
  List<Object> get props => [newfilter];
}
