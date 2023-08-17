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
}
