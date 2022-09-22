import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    emit(TodoLoading());
    _todos.removeWhere((todo) => todo.id == id);
    emit(TodoLoaded(_todos));
  }

  void redoTodo(String id) {
    emit(TodoLoading());
    _todos.firstWhere((todo) => todo.id == id).status = TodoStatus.active;
    emit(TodoLoaded(_todos));
  }

  void finishTodo(String id) {
    emit(TodoLoading());
    _todos.firstWhere((todo) => todo.id == id).status = TodoStatus.completed;
    emit(TodoLoaded(_todos));
  }

  void getTodoList() {
    emit(TodoLoaded(_todos));
  }

  void addTodo(Todo todo) {
    emit(TodoLoading());
    _todos.add(todo);
    emit(TodoLoaded(_todos));
  }
}
