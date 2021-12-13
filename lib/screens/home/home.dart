
import 'package:mynotes/models/notes.dart';
import 'package:mynotes/models/user.dart';
import 'package:mynotes/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/mongodb.dart';
import 'package:mynotes/shared/constants.dart';


class Home extends StatefulWidget {

  final String uid;

  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final MongoDb mongoDb = MongoDb();

  getNotes() async {
      final Notes notes = Notes(userId: widget.uid, title: '', body: '', isFavorite: false);
      final notesData = await mongoDb.getNotes(notes);
      //print(notesData.runtimeType);
      return notesData;
  }

  @override
  void initState() {
    super.initState();
    print("User id in home screen = "+widget.uid);
    getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.blueGrey[200],
        appBar: AppBar(
          title: Text('My Notes', style: TextStyle(color: Colors.black),),
          backgroundColor: Colors.blueGrey[400],
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              onPressed: (){
                Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
              },
              icon: Icon(
                  Icons.refresh,
                  color: Colors.black,
              ),
            ),
            FlatButton.icon(
              icon: Icon(Icons.favorite, color: Colors.black,),
              label: Text('Favorites'),
              onPressed: ()  {
                Navigator.pushNamed(context, "/Favorites", arguments: {
                  'userId' : widget.uid,
                });
              },
            ),
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text('logout'),
              onPressed: () async {
                await _auth.signOut();
              },
            ),
          ],
        ),
        body: FutureBuilder(
          future: getNotes(),
          builder: (context, noteData) {
            if (noteData.hasData) {
              switch (noteData.connectionState) {
                case ConnectionState.waiting:
                  {
                    return Center(child: CircularProgressIndicator());
                  }
                case ConnectionState.done:
                  {
                    if (noteData.data == Null) {
                      return Center(child: Text(
                          "You don't have any notes to display, Create one.", style: TextStyle(fontSize: 18),));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: (noteData.data as List<Map<String, dynamic>>).length,
                          itemBuilder: (context, index) {
                            var lists = noteData.data as List<Map<String, dynamic>>;
                            String title = lists[index]['title'];
                            String body = lists[index]['body'];
                            return Card(
                              //elevation: 8.0,
                              color: Colors.blueGrey[400],
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        //color: lists[index]["isFavorite"] == true ? Colors.red : Colors.black,
                                        color: Colors.red,
                                        style: lists[index]["isFavorite"] == true ? BorderStyle.solid : BorderStyle.none,
                                      )
                                    ),
                                    child: ListTile(
                                      onTap: (){
                                        Notes note = new Notes(userId: widget.uid, title: lists[index]['title'], body: lists[index]['body'], isFavorite: lists[index]["isFavorite"]);
                                        Navigator.pushNamed(context, "/ShowNote", arguments: {
                                          'notes' : note,
                                          'objectId' : lists[index]['_id'],
                                        });
                                      },
                                      title: Text("Title : "+title, style: TextStyle(fontWeight: FontWeight.bold,),),
                                      subtitle: Text("Description : "+body, style: TextStyle(color: Colors.black),),
                                    ),
                                  ),
                                ]
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                default : {
                  return Center(child: Text(
                      "You don't have any notes to display, Create one.", style: TextStyle(fontSize: 18),));
                }
              }
            } else {
              return Center(child: Text(
                  "You don't have any notes to display, Create one.", style: TextStyle(fontSize: 18),));
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blueGrey[400],
          onPressed: (){
            Navigator.pushNamed(context, "/AddNote", arguments: {
              'userId' : widget.uid,
            });
          },
          child: Icon(Icons.note_add, color: Colors.black,),
        ),

      ),
    );
  }
}