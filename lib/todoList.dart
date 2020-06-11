import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolistappredo/Login_And_Auth/auth.dart';
class TodoList extends StatefulWidget {
  TodoList(this.auth, this.onSignedOut, this.user,);
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final FirebaseUser user;
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
