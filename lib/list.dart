import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:developer';

import 'package:grablunch/auth.dart' show ensureLoggedIn, googleSignIn, analytics;


class ListScreen extends StatefulWidget {
  @override
  State createState() => new ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final reference = FirebaseDatabase.instance.reference().child('lunchers');
  bool _isLuncher = false;
  final Icon joinIcon = new Icon(Icons.local_dining);
  final Icon cancelIcon = new Icon(Icons.close);
  DatabaseReference userRef;

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
                itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new ListItem(
                    snapshot: snapshot,
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
        child: _isLuncher ? cancelIcon : joinIcon,
        tooltip: _isLuncher ? 'Cancel' : 'Join',
        onPressed: () => _handleSubmitted(),
      ),
    );
  }

  Future<Null> _handleSubmitted() async {
    await ensureLoggedIn();
    _isLuncher ? _cancelLunch() : _joinLunch();
    setState(() {
      _isLuncher = !_isLuncher;
    });
  }

  void _joinLunch() {
    userRef = reference.push();
    userRef.set({
      'name': googleSignIn.currentUser.displayName,
      'photoUrl': googleSignIn.currentUser.photoUrl,
    });
    analytics.logEvent(name: 'join_lunch');
  }

  void _cancelLunch() {
    userRef.remove();
    analytics.logEvent(name: 'cancel_lunch');
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                  snapshot.value['photoUrl']
                ),
              )
            ),
            new Column(
              children: <Widget>[
                new Text(snapshot.value['name']),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
