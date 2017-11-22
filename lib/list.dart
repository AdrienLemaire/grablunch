import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
//import 'dart:developer';

import 'package:grablunch/auth.dart' show ensureLoggedIn, googleSignIn, analytics;
import 'package:grablunch/filters.dart' show filterToday;
import 'package:grablunch/localization.dart' show AppLocalizations;


class ListScreen extends StatefulWidget {
  @override
  State createState() => new ListScreenState();
}

class ListScreenState extends State<ListScreen> {
  final reference = FirebaseDatabase.instance.reference().child('lunchers');
  String _luncherKey;
  final Icon joinIcon = new Icon(Icons.local_dining);
  final Icon cancelIcon = new Icon(Icons.close);
  ListScreenState() {
    reference.keepSynced(true);
    _checkIfLuncher();
    reference.onChildChanged.listen(
      (Event event) => _checkIfLuncher()
    );
  }

  Future<Null> _checkIfLuncher() async {
    await ensureLoggedIn();
    DataSnapshot snapshot = await filterToday(reference).once();
    String _newKey;
    snapshot.value?.forEach((key, value) {
      if (value['name'] == googleSignIn.currentUser.displayName) {
        _newKey = key;
      }
    });
    if (_luncherKey != _newKey) {
      setState(() { _luncherKey = _newKey; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(AppLocalizations.of(context).titleList),
        elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.chat),
            tooltip: AppLocalizations.of(context).chat,
            onPressed: Navigator.of(context).push(chatRoute),
          ),
        ],
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            // List of Lunchers
            new Flexible(
              child: new FirebaseAnimatedList(
                query: filterToday(reference),
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
        child: (_luncherKey != null) ? cancelIcon : joinIcon,
        tooltip: (_luncherKey != null) ? 'Cancel' : 'Join',
        onPressed: () => _handleSubmitted(),
      ),
    );
  }

  Future<Null> _handleSubmitted() async {
    await ensureLoggedIn();
    (_luncherKey != null) ? _cancelLunch() : _joinLunch();
  }

  void _joinLunch () {
    reference.push().set({
      'name': googleSignIn.currentUser.displayName,
      'photoUrl': googleSignIn.currentUser.photoUrl,
      'date': new DateTime.now().millisecondsSinceEpoch,
    });
    _checkIfLuncher();
    analytics.logEvent(name: 'join_lunch');
  }

  void _cancelLunch() {
    reference.child(_luncherKey).remove();
    _checkIfLuncher();
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
