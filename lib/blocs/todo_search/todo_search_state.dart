part of 'todo_search_bloc.dart';

class TodoSearchState extends Equatable {
  final String searchTerm;

  const TodoSearchState({required this.searchTerm});

  factory TodoSearchState.initial() => const TodoSearchState(searchTerm: '');

  TodoSearchState copyWith({
    String? searchTerm,
  }) {
    return TodoSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }

  @override
  List<Object> get props => [searchTerm];

  @override
  String toString() => 'TodoSerarchState(searchTerm: $searchTerm)';
}
