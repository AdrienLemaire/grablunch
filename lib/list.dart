import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';


class ListScreen extends StatefulWidget {
  @override
  State createState() => new ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final reference = FirebaseDatabase.instance.reference().child('lunchers');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Column(
          children: <Widget>[
            // List of Lunchers
            new Flexible(
              child: new FirebaseAnimatedList(
                query: reference,
                sort: (a, b) => b.key.compareTo(a.key),
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new ListItem(
                    animation: animation,
                  );
                },
              ),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(border:
              new Border(top: new BorderSide(color: Colors.grey[200])))
          : null,
      ),
      // Grab lunch button
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.fastfood),
        tooltip: 'Join',
        onPressed: () {},
      ),

    );
  }
}


class ListItem extends StatelessWidget {
  ListItem({this.snapshot, this.animation});
  final DataSnapshot snapshot;
  final Animation animation;

  //@override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut
      ),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                  snapshot.value['senderPhotoUrl']
                ),
              )
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(snapshot.value['senderName'],
                         style: Theme.of(context).textTheme.subhead),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
