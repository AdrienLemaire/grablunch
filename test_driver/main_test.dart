import 'dart:async';

// Imports the Flutter Driver API
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('navigation performance test', () {
    FlutterDriver driver;

    setUpAll(() async {
      // Connects to the app
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        // Closes the connection
        driver.close();
      }
    });

    test('measure', () async {
      Timeline timeline = await driver.traceAction(() async {
        await new Future<Null>.delayed(new Duration(milliseconds: 500));
      });

      TimelineSummary summary = new TimelineSummary.summarize(timeline);
      summary.writeSummaryToFile('navigation_perf', pretty: true);
      summary.writeTimelineToFile('navigation_perf', pretty: true);
    });
  });
}
