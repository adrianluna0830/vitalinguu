import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

extension LanguageLocaleAppLocale on LanguageLocale {
  AppLocale get appLocale => switch (this) {
    LanguageLocale.en => AppLocale.en,
    LanguageLocale.es => AppLocale.esMx,
    LanguageLocale.de => AppLocale.de,
    LanguageLocale.pt => AppLocale.ptBr,
    LanguageLocale.fr => AppLocale.fr,
    LanguageLocale.it => AppLocale.it,
  };
}

extension AppLocaleLanguageLocale on AppLocale {
  LanguageLocale get languageLocale => switch (this) {
    AppLocale.en => LanguageLocale.en,
    AppLocale.esMx => LanguageLocale.es,
    AppLocale.de => LanguageLocale.de,
    AppLocale.ptBr => LanguageLocale.pt,
    AppLocale.fr => LanguageLocale.fr,
    AppLocale.it => LanguageLocale.it,
  };
}
