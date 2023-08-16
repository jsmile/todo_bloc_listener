import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'active_todo_count_event.dart';
part 'active_todo_count_state.dart';

// todoListSubscription, todoListBloc 등과 관련된 부분 삭제처리
class ActiveTodoCountBloc
    extends Bloc<ActiveTodoCountEvent, ActiveTodoCountState> {
  // 초기 TODO List count 반영 시 사용
  final int initialActiveTodoCount;

  ActiveTodoCountBloc({
    required this.initialActiveTodoCount,
  }) : super(ActiveTodoCountState(activeTodoCount: initialActiveTodoCount)) {
    // 현재 이벤트가 발생하면 현재 State를 변경시킴.
    on<ActiveTodoCountCalculatedEvent>((event, emit) {
      emit(state.copyWith(activeTodoCount: event.activeTodoCount));
    });
  }
}
