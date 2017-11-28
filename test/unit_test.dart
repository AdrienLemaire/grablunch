import 'package:test/test.dart';

import 'package:grablunch/localization.dart'
    show supportedLanguages, AppLocalizations;

void main() {
  test('supported languages', () {
    expect(supportedLanguages, isList);
    expect(supportedLanguages, contains('en'));
    expect(supportedLanguages, contains('ja'));
  });

  test('translations available', () {
    AppLocalizations translations = new AppLocalizations();

    expect(translations.title, anything);
    expect(translations.titleList, anything);
    expect(translations.titleChat, anything);
    expect(translations.send, anything);
    expect(translations.sendMessage, anything);
    expect(translations.chat, anything);
    expect(translations.list, anything);
  });
}
