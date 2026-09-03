import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

String languageLocaleDisplayName(
  LanguageLocale language,
  Translations translations,
) {
  return switch (language) {
    LanguageLocale.en => translations.languages.english,
    LanguageLocale.es => translations.languages.spanish,
    LanguageLocale.de => translations.languages.german,
    LanguageLocale.pt => translations.languages.portuguese,
    LanguageLocale.fr => translations.languages.french,
    LanguageLocale.it => translations.languages.italian,
  };
}
