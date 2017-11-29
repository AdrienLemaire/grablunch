# Local setup

## Install packages

    $ flutter packages get

## Set your coding env

Check [Dart tools](https://www.dartlang.org/tools).

My vim config:

    Plug 'dart-lang/dart-vim-plugin'
    Plug 'w0rp/ale'  " Asynchronous Lint Engine
    let dart_style_guide = 2
    autocmd BufWritePre *.dart :DartFmt
    let g:ale_linters = {
    \   'dart': ['language_server'],
    \}


## Generate locales

    $ flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/l10n lib/localization.dart
    $ cat lib/l10n/intl_messages.arb|jq . > lib/l10n/intl_ja.arb
    $ cat lib/l10n/intl_messages.arb|jq . > lib/l10n/intl_en.arb
    $ flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n --no-use-deferred-loading lib/localization.dart lib/l10n/intl_*.arb


## Check code

    $ flutter analyze --watch
    $ flutter test
    $ flutter drive

Verify the coverage:

    $ flutter test --coverage
    $ genhtml coverage/lcov.info -o coverage
    $ xdg-open coverage/index.html


## Run

    $ flutter run   # emulator
    $ flutter run --target lib/messaging.dart   # different entrypath
    $ flutter run -d F5AZFG23U167   # device

## Build Android

    $ flutter build apk

Install on device (example ASUS phone):

    $ flutter install -d $(flutter devices | grep ASUS | awk '{print $4}')
