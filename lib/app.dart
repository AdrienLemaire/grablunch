import 'package:flutter/material.dart';
import 'package:grablunch/chat.dart' show ChatScreen;
import 'package:grablunch/list.dart' show ListScreen;


class AppScreen extends StatefulWidget {
  @override
  State createState() => new AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  bool _isListScreen = true;
  final ChatScreen chat = new ChatScreen();
  final ListScreen list = new ListScreen();
  final Icon chatIcon = new Icon(Icons.chat);
  final Icon listIcon = new Icon(Icons.fastfood);

  void _toggleScreen() {
    setState(() {
      _isListScreen = !_isListScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('GrabLunch ${_isListScreen ? 'List' : 'Chat'}'),
        elevation:
          Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
        actions: <Widget>[
          new IconButton(
            icon: _isListScreen ? chatIcon : listIcon,
            tooltip: 'Chat',
            onPressed: _toggleScreen,
          ),
        ],
      ),
      body: _isListScreen ? list : chat,
    );
  }
}

