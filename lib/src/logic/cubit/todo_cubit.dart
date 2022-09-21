import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoInitial());

  final List<Todo> _todos = List.of(
    [
      Todo(
        id: "1",
        title: "收拾屋子",
        description: "顺便打扫下卫生",
        createdAt: DateTime.now(),
      ),
      Todo(
        id: "2",
        title: "看《经济学原理》第三章",
        description: "",
        createdAt: DateTime.now(),
      ),
      Todo(
        id: "3",
        title: "出去买菜",
        description: "萝卜青菜，各有所爱",
        createdAt: DateTime.now(),
      ),
    ],
  );

  void deleteTodo(String id) {
    _todos.removeWhere((todo) => todo.id == id);
    emit(TodoLoaded(_todos));
  }

  void getTodoList() {
    emit(TodoLoaded(_todos));
  }
}
