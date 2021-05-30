import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_todo/models/todo_model.dart';
import 'firestore_path.dart';

Future<void> setTodo(TodoModel todoModel) async {
  await FirebaseFirestore.instance
      .collection(FirestorePath.todos())
      .doc()
      .set(todoModel.toJson());
}

Future<void> deleteTodo(String id) async {
  await FirebaseFirestore.instance
      .collection(FirestorePath.todos())
      .doc(id)
      .delete();
}
