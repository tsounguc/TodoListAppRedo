import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todolistappredo/Login_And_Auth/auth.dart';

class TodoList extends StatefulWidget {
  TodoList(
    this.auth,
    this.onSignedOut,
    this.user,
  );

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final FirebaseUser user;

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {

  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Colors.blue[900],
//            Colors.blue,
            Colors.lightBlue,
            Colors.lightBlueAccent
          ],
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Text('List'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle, size: 35, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            )
          ],
        ),
        drawer: showDrawer(),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .document('${widget.user.email}')
                  .collection('tasks')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return showCircularProgressIndicator();
                }
                return Column(
                  children: <Widget>[
                    showInputTextFieldAndAddButton(),
                    showListOfTasks(snapshot),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget showCircularProgressIndicator() {
    return Center(
      child: Column(
        children: <Widget>[
          CircularProgressIndicator(),
          Divider(
            height: 20,
          ),
          Text(
            'Loading. . .',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }

  showDrawer() {
    return Drawer(
      child: ListView(
        key: UniqueKey(),
        children: <Widget>[
          DrawerHeader(
            child: CircleAvatar(
              backgroundColor: Colors.deepOrangeAccent,
              backgroundImage: null,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.person, size: 50, color: Colors.white),
                  Text(
                    '${widget.user.email.substring(
                      0,
                      widget.user.email.indexOf('@'),
                    )}',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
                Colors.orange,
//                Colors.deepOrange,
                Colors.orangeAccent,
              ]),
            ),
          ),
          Container(
            key: UniqueKey(),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.lock, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  _displayLogOutDialog(context);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  _displayLogOutDialog(context);
                },
              ),
              onTap: () {
                Navigator.pop(context);
                _displayLogOutDialog(context);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(0.0),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  _displayDeleteAccountWarning(context);
                },
              ),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                  _displayDeleteAccountWarning(context);
                },
              ),
              onTap: () {
                Navigator.pop(context);
                _displayDeleteAccountWarning(context);
              },
            ),
          )
        ],
      ),
    );
  }


  showInputTextFieldAndAddButton() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white70,
                hintText: 'Enter task',
                suffixIcon: RaisedButton.icon(
                  color: Colors.white70,
                  onPressed: () {
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => controller.clear());
                    if (controller.text.isNotEmpty) {
                      createTask(controller.text);
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text(''),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showListOfTasks(AsyncSnapshot snapshot) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.white,
          ),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return snapshot.data.documents[0]['name'] == null
                ? deleteTask(snapshot, index)
                : Dismissible(
              key: Key('${snapshot.data.documents[index]['time']}'),
              background: Container(color: Colors.red),
              onDismissed: (direction) => deleteTask(snapshot, index),
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: Colors.white,
                ),
                child: ListTile(
                  dense: true,
                  title: Text(
                    ' ${snapshot.data.documents[index]['name']}  ',
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        decorationStyle: TextDecorationStyle.solid,
                        decorationColor: Colors.white,
                        decoration: snapshot.data.documents[index]
                        ['completed']
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                  trailing: SizedBox(
                    width: 75,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Checkbox(
                            checkColor: Colors.green,
                            activeColor: Colors.transparent,
                            value: snapshot.data.documents[index]
                            ['completed'],
                            onChanged: (bool value) {
                              updateTaskCompletion(
                                  snapshot,
                                  snapshot.data.documents[index]
                                  ['completed'],
                                  index);
                            },
                          ),
                        ),
//                              Container(
//                                width: 25,
//                              ),
                        Expanded(
                          child: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              size: 30,
                              color: Colors.white,
                            ),
                            itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: snapshot.data.documents[index]
                                ['completed']
                                    ? 'Mark as not completed'
                                    : 'Mark as completed',
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: snapshot
                                          .data.documents[index]
                                      ['completed']
                                          ? Text('Mark as not completed')
                                          : Text('Mark as completed'),
                                    ),
                                    Icon(snapshot.data.documents[index]
                                    ['completed']
                                        ? Icons.check_box_outline_blank
                                        : Icons.check),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Edit',
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('Edit'),
                                    ),
                                    Icon(Icons.edit),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'Delete',
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text('Delete'),
                                    ),
                                    Icon(Icons.delete),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (menuValue) {
                              if (menuValue == 'Edit') {
                                _displayNameDialog(
                                    context, snapshot, index);
                              }
                              if (menuValue == 'Delete') {
                                deleteTask(snapshot, index);
                              }
                              if (menuValue == 'Mark as not completed') {
                                updateTaskCompletion(
                                    snapshot, true, index);
                              }
                              if (menuValue == 'Mark as completed')
                                updateTaskCompletion(
                                    snapshot, false, index);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _displayNameDialog(
      BuildContext context, AsyncSnapshot snapshot, int index) async {
    TextEditingController textEditingController = TextEditingController();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit task'),
            content: TextField(
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  hintText: 'Enter new task name'),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('SUBMIT'),
                textColor: Colors.black,
                color: Colors.teal[50],
                onPressed: () {
                  if (textEditingController.text.isNotEmpty) {
                    updateTaskName(snapshot, textEditingController.text, index);
                    Navigator.of(context).pop();
                  }
                },
              )
            ],
          );
        });
  }

  void _displayLogOutDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.yellow[600],
            title: Text(
              'WARNING',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('LOG OUT'),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                  _signOut();
                },
              )
            ],
          );
        });
  }




  void _displayDeleteAccountWarning(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.yellow[600],
            title: Text(
              'WARNING',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'Are you sure you want to delete this account?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('CANCEL'),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('DELETE ACCOUNT'),
                textColor: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                  deleteAccount();
                },
              )
            ],
          );
        });
  }

  void createTask(String name) async {
    Firestore.instance.collection('users/${widget.user.email}/tasks').add({
      'name': name,
      'completed': false,
      'time': FieldValue.serverTimestamp(),
    });
  }

  void updateTaskName(AsyncSnapshot snapshot, String name, int index) async {
    snapshot.data.documents[index].reference.updateData({
      'name': name,
    });
  }

  void updateTaskCompletion(
      AsyncSnapshot snapshot, bool completed, int index) async {
    snapshot.data.documents[index].reference.updateData({
      'completed': !completed,
    });
  }

  deleteTask(AsyncSnapshot snapshot, int index) async {
    Firestore.instance
        .collection('users/${widget.user.email}/tasks')
        .document(snapshot.data.documents[index].documentID)
        .delete();
  }

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {}
  }

  void deleteAccount() async {
    widget.onSignedOut();
    await widget.user.delete();
    Firestore.instance
        .collection('users')
        .document('${widget.user.email}')
        .delete();
  }


}
