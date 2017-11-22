import 'package:flutter/material.dart';
import 'package:grablunch/chat.dart' show ChatScreen;
import 'package:grablunch/list.dart' show ListScreen;
import 'package:grablunch/localization.dart' show AppLocalizations;


class AppScreen extends StatefulWidget {
  @override
  State createState() => new AppScreenState();
}

class AppScreenState extends State<AppScreen> {
  bool _isListScreen = true;
  final ChatScreen chat = new ChatScreen();
  final ListScreen list = new ListScreen();
  final Icon chatIcon = new Icon(Icons.chat);
  final Icon listIcon = new Icon(Icons.group);

  void _toggleScreen() {
    setState(() {
      _isListScreen = !_isListScreen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_isListScreen
          ? AppLocalizations.of(context).titleList
          : AppLocalizations.of(context).titleChat
		),
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

