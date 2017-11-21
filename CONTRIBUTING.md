# Local setup

## Install packages

    $ flutter packages get

## Generate locales

    $ flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart
    $ flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localization.dart lib/l10n/intl_*.arb
    $ cat lib/l10n/intl_messages.arb|jq . > lib/l10n/intl_ja.arb
    $ cat lib/l10n/intl_messages.arb|jq . > lib/l10n/intl_en.arb


## Check code

    $ flutter analyze --watch


## Run

    $ flutter run   # emulator
    $ flutter run --target lib/messaging.dart   # different entrypath
    $ flutter run -d F5AZFG23U167   # device

## Deploy

    $ flutter build apk
