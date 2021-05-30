import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'functions/firestore_database.dart';
import 'models/todo_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

final _formKey = GlobalKey<FormState>();
final myController = TextEditingController();

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: myController,
                    decoration: InputDecoration(
                        hintText: "write todo here...",
                        suffixIcon: InkWell(
                          child: Icon(Icons.add),
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              TodoModel todoModel =
                                  TodoModel(title: myController.text);
                              setTodo(todoModel);
                              myController.clear();
                            }
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('todos')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text("Not found todos"));
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(child: CircularProgressIndicator());
                      case ConnectionState.none:
                        return Center(child: Text("Not found todos"));
                      default:
                        return ListView(
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            return ListTile(
                              title: Text(document['title']),
                              trailing: IconButton(
                                  onPressed: () {
                                    deleteTodo(document.id);
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  )),
                            );
                          }).toList(),
                        );
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
