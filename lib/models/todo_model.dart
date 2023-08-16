import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

// TODO 아이템들의 상태를 위한 enum
enum Filter {
  all,
  active,
  completed,
}

// 신규 TODO 아이템 생성시 사용할 uuid
Uuid uuid = const Uuid();

class Todo extends Equatable {
  final String id;
  final String desc;
  final bool completed;

  Todo({
    String? id, // Type 만 선언하면 초기화 필요
    required this.desc,
    this.completed = false, // 기본값 설정
  }) : id = id ?? uuid.v4(); // Type id 초기화

  @override
  List<Object> get props => [id, desc, completed];

  @override
  String toString() => 'Todo(id: $id, desc: $desc, completed: $completed)';
}
