import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'package:grablunch/auth.dart' show ensureLoggedIn, googleSignIn, analytics;


class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}


class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;
  final reference = FirebaseDatabase.instance.reference().child('messages');

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Flexible(
              child: new FirebaseAnimatedList(
                query: reference,
                sort: (a, b) => b.key.compareTo(a.key),
                padding: new EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation) {
                  return new ChatMessage(
                    snapshot: snapshot,
                    animation: animation,
                  );
                },
              ),
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ],
        ),
        decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(border:
              new Border(top: new BorderSide(color: Colors.grey[200])))
          : null,
      ),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(children: <Widget>[
          new Container(
            margin: new EdgeInsets.symmetric(horizontal: 4.0),
            child: new IconButton(
              icon: new Icon(Icons.photo_camera),
              onPressed: () async {
                await ensureLoggedIn();
                File imageFile = await ImagePicker.pickImage();
                int random = new Random().nextInt(100000);
                StorageReference ref = FirebaseStorage.instance.ref().child("image_$random.jpg");
                StorageUploadTask uploadTask = ref.put(imageFile);
                Uri downloadUrl = (await uploadTask.future).downloadUrl;
                _sendMessage(imageUrl: downloadUrl.toString());
              }
            ),
          ),
          new Flexible(
            child: new TextField(
              controller: _textController,
              onChanged: (String text) {
                setState(() {
                  _isComposing = text.length > 0;
                });
              },
              onSubmitted: _handleSubmitted,
              decoration: new InputDecoration.collapsed(
                hintText: "Send a message"),
            ),
          ),
          new Container(
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Theme.of(context).platform == TargetPlatform.iOS ?
              new CupertinoButton(
                child: new Text("Send"),
                onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text) : null,
              ) :
              new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _isComposing ?
                  () => _handleSubmitted(_textController.text) : null,
              ),
          ),
        ])
      )
    );
  }

  Future<Null> _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    await ensureLoggedIn();
    _sendMessage(text: text);
  }

  void _sendMessage({ String text, String imageUrl }) {
    reference.push().set({
      'text': text,
      'imageUrl': imageUrl,
      'senderName': googleSignIn.currentUser.displayName,
      'senderPhotoUrl': googleSignIn.currentUser.photoUrl,
      'date': new DateTime.now().millisecondsSinceEpoch,
    });
    analytics.logEvent(name: 'send_message');
  }
}


class ChatMessage extends StatelessWidget {
  ChatMessage({this.snapshot, this.animation});
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
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: snapshot.value['imageUrl'] != null ?
                    new Image.network(
                      snapshot.value['imageUrl'],
                      width: 250.0,
                    ) :
                    new Text(snapshot.value['text']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


