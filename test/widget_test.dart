import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:grablunch/list.dart' show ListScreen;
import 'package:grablunch/localization.dart' show AppLocalizations;

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  var localizations = new MockAppLocalizations();
  when(localizations.titleList).thenReturn("titleList");
  //var testListScreen = new ListScreen();
  //testListScreen.context = new Mock();

//  testWidgets('my first widget test', (WidgetTester tester) async {
//    await tester.pumpWidget(
//      new StatefulBuilder(
//        builder: (BuildContext context, StateSetter setState) {
//          return;
//        },
//      ),
//    );
//  });
}
