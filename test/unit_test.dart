import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_database/firebase_database.dart'
    show DatabaseReference;

import 'package:grablunch/filters.dart' show filterToday;

class MockDatabaseReference extends Mock implements DatabaseReference {}

void main() {
  test('filterToday', () {
    MockDatabaseReference reference = new MockDatabaseReference();
    DateTime now = new DateTime.now();
    DateTime today = new DateTime(now.year, now.month, now.day);
    DateTime tomorrow = new DateTime(now.year, now.month, now.day + 1);
    filterToday(reference);
    verifyInOrder([
      reference.orderByChild('date'),
      reference.startAt(today.millisecondsSinceEpoch),
      reference.endAt(tomorrow.millisecondsSinceEpoch),
    ]);
  });
}
