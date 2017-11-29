import 'package:firebase_database/firebase_database.dart'
    show DatabaseReference, Query;

Query filterToday(DatabaseReference reference) {
  DateTime now = new DateTime.now();
  DateTime today = new DateTime(now.year, now.month, now.day);
  DateTime tomorrow = new DateTime(now.year, now.month, now.day + 1);
  return reference
      .orderByChild('date')
      .startAt(today.millisecondsSinceEpoch)
      .endAt(tomorrow.millisecondsSinceEpoch);
}
