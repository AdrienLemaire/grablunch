import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:grablunch/l10n/messages_all.dart' show initializeMessages;


class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((Null _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message(
      'GrabLunch',
      name: 'title',
      desc: 'Title for the Grablunch application',
    );
  }
  String get titleList {
    return Intl.message(
      "Let's eat together!",
      name: 'titleList',
      desc: 'Title for the List view',
    );
  }
  String get titleChat {
    return Intl.message(
      'Where should we eat?',
      name: 'titleChat',
      desc: 'Title for the chat view',
    );
  }


}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  bool isSupported(Locale locale) => ['en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
