import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolistappredo/Login_And_Auth/auth.dart';
import 'package:todolistappredo/Login_And_Auth/loginPage.dart';
import 'package:todolistappredo/Login_And_Auth/signUpPage.dart';
import 'package:todolistappredo/todoList.dart';

class RoutingPage extends StatefulWidget {
  RoutingPage(this.auth);
  final BaseAuth auth;
  @override
  _RoutingPageState createState() => _RoutingPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

enum FormType {
  login,
  register,
}

class _RoutingPageState extends State<RoutingPage> {
  AuthStatus _authStatus = AuthStatus.notSignedIn;
  FormType _formType = FormType.login;
  FirebaseUser currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentUser();

  }
  @override
  Widget build(BuildContext context) {
    switch(_authStatus){
      case AuthStatus.notSignedIn:
        if(_formType == FormType.login){
          return new LoginPage(widget.auth, _signedIn, signUpForm);
        }else if(_formType == FormType.register) {
          return new SignUpPage(widget.auth, _signOut, logInForm);
        }
        break;
      case AuthStatus.signedIn:
        return TodoList(widget.auth, _signOut, currentUser);
    }
  }
  _getCurrentUser() async {
    currentUser = await widget.auth.currentUser();
    setState(() {
      _authStatus = currentUser != null? AuthStatus.signedIn : AuthStatus.notSignedIn;
    });
  }

  void logInForm() {
    setState(() {
      _formType = FormType.login;
    });
  }

  void signUpForm() {
    setState(() {
      _formType = FormType.register;
    });
  }

  void _signedIn(){
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });

    _getCurrentUser();

  }

  void _signOut(){
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

}
