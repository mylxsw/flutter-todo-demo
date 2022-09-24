import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/todo.dart';
import '../../data/repository/todo.dart';

part 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository todoRepository;
  TodoCubit(this.todoRepository) : super(TodoInitial());

  Future<void> deleteTodo(int id) async {
    await todoRepository.deleteTodoById(id);
    emit(TodoNeedUpdate());
  }

  Future<void> resumeTodo(int id) async {
    await todoRepository.resumeTodoById(id);
    emit(TodoNeedUpdate());
  }

  Future<void> finishTodo(int id) async {
    await todoRepository.finishTodoById(id);
    emit(TodoNeedUpdate());
  }

  Future<void> getTodoList() async {
    emit(TodoLoaded(await todoRepository.getTodoList()));
  }

  Future<int> addTodo(Todo todo) async {
    var id = await todoRepository.insertTodo(todo);
    emit(TodoNeedUpdate());
    return id;
  }
}
