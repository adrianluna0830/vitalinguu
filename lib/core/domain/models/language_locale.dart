enum LanguageLocale {
  en('en-US', 'English', 'en'),
  es('es-MX', 'Spanish', 'es'),
  de('de-DE', 'German', 'de'),
  pt('pt-BR', 'Portuguese', 'pt'),
  fr('fr-FR', 'French', 'fr'),
  it('it-IT', 'Italian', 'it');

  final String bcp47;
  final String languageCode;
  final String fullName;

  const LanguageLocale(this.bcp47, this.fullName, this.languageCode);

  String get display => name.toUpperCase();
}
