///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsDe with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsDe({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.de,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <de>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsDe _root = this; // ignore: unused_field

	@override
	TranslationsDe $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsDe(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$de app = _Translations$app$de._(_root);
	@override late final _Translations$common$de common = _Translations$common$de._(_root);
	@override late final _Translations$languages$de languages = _Translations$languages$de._(_root);
	@override late final _Translations$navigation$de navigation = _Translations$navigation$de._(_root);
	@override late final _Translations$onboarding$de onboarding = _Translations$onboarding$de._(_root);
	@override late final _Translations$settings$de settings = _Translations$settings$de._(_root);
	@override late final _Translations$errors$de errors = _Translations$errors$de._(_root);
	@override late final _Translations$learningHome$de learningHome = _Translations$learningHome$de._(_root);
	@override late final _Translations$exerciseSetup$de exerciseSetup = _Translations$exerciseSetup$de._(_root);
	@override late final _Translations$topics$de topics = _Translations$topics$de._(_root);
	@override late final _Translations$exercise$de exercise = _Translations$exercise$de._(_root);
	@override late final _Translations$loading$de loading = _Translations$loading$de._(_root);
	@override late final _Translations$feedback$de feedback = _Translations$feedback$de._(_root);
}

// Path: app
class _Translations$app$de implements Translations$app$en {
	_Translations$app$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vitalinguu';
}

// Path: common
class _Translations$common$de implements Translations$common$en {
	_Translations$common$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'Weiter';
	@override String get confirm => 'Bestätigen';
	@override String get cancel => 'Abbrechen';
	@override String get back => 'Zurück';
	@override String get retry => 'Erneut versuchen';
	@override String get delete => 'Löschen';
}

// Path: languages
class _Translations$languages$de implements Translations$languages$en {
	_Translations$languages$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get english => 'Englisch';
	@override String get spanish => 'Spanisch (Mexiko)';
	@override String get german => 'Deutsch';
	@override String get portuguese => 'Portugiesisch (Brasilien)';
	@override String get french => 'Französisch';
	@override String get italian => 'Italienisch';
	@override String get select => 'Sprache auswählen';
}

// Path: navigation
class _Translations$navigation$de implements Translations$navigation$en {
	_Translations$navigation$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get home => 'Start';
	@override String get settings => 'Einstellungen';
}

// Path: onboarding
class _Translations$onboarding$de implements Translations$onboarding$en {
	_Translations$onboarding$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get nativeLanguageTitle => 'Muttersprache festlegen';
	@override String get nativeLanguageLabel => 'Muttersprache';
	@override String get learningLanguageTitle => 'Lernsprache festlegen';
	@override String get learningLanguageLabel => 'Lernsprache';
	@override String get apiKeyTitle => 'API-Schlüssel einrichten';
	@override String get apiKeyLabel => 'API-Schlüssel';
	@override String get useSavedApiKey => 'Gespeicherten API-Schlüssel verwenden';
	@override String get getApiKeyLink => 'API-Schlüssel auf nano-gpt.com erhalten';
	@override String get couldNotOpenApiLink => 'Die API-Seite von nano-gpt.com konnte nicht geöffnet werden.';
	@override String get invalidApiKey => 'Der API-Schlüssel ist ungültig.';
	@override String get unavailableApiKey => 'Der API-Schlüssel konnte nicht überprüft werden. Versuche es erneut.';
}

// Path: settings
class _Translations$settings$de implements Translations$settings$en {
	_Translations$settings$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get title => 'Einstellungen';
	@override String get configuration => 'Konfiguration';
	@override String minimumCredit({required Object amount}) => 'Du brauchst mehr als ${amount} USD Guthaben, um die App zu verwenden.';
	@override String get voiceSpeed => 'Sprechgeschwindigkeit';
	@override String get feedbackLookback => 'Berücksichtigtes Feedback';
	@override String days({required Object count}) => '${count} Tage';
	@override late final _Translations$settings$credit$de credit = _Translations$settings$credit$de._(_root);
}

// Path: errors
class _Translations$errors$de implements Translations$errors$en {
	_Translations$errors$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get configureApiKey => 'API-Schlüssel einrichten';
	@override String get authentication => 'Auf den Dienst konnte nicht zugegriffen werden. Überprüfe deinen API-Schlüssel.';
	@override String get usageLimit => 'Du hast das Nutzungslimit erreicht. Überprüfe dein Guthaben oder versuche es später erneut.';
	@override String get temporary => 'Beim Dienst ist ein vorübergehendes Problem aufgetreten.';
	@override String get request => 'Die Anfrage konnte nicht abgeschlossen werden.';
}

// Path: learningHome
class _Translations$learningHome$de implements Translations$learningHome$en {
	_Translations$learningHome$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get priorityHelp => 'Die Priorität bestimmt, welche Optionen häufiger oder seltener erscheinen:';
	@override String get priorityLow => 'Niedrig';
	@override String get priorityMedium => 'Mittel';
	@override String get priorityHigh => 'Hoch';
	@override String get configurationTab => 'Konfiguration';
	@override String get topicsTab => 'Themen';
}

// Path: exerciseSetup
class _Translations$exerciseSetup$de implements Translations$exerciseSetup$en {
	_Translations$exerciseSetup$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get cefrLevel => 'GER-Niveau';
	@override String get exerciseCount => 'Anzahl der Übungen';
	@override String get promptContent => 'Aufgabeninhalt';
	@override String get text => 'Text';
	@override String get audio => 'Audio';
	@override String get exerciseTypes => 'Übungstypen';
	@override String get deselectAll => 'Auswahl aufheben';
	@override String get selectAll => 'Alle auswählen';
	@override String get availableTopics => 'Verfügbare Themen';
	@override String get noAvailableTopics => 'Keine Themen verfügbar';
	@override String minimumCredit({required Object amount}) => 'Du brauchst mehr als ${amount} USD Guthaben, um fortzufahren.';
	@override String get unauthorizedCredit => 'Du kannst nicht fortfahren, weil dein Guthaben nicht autorisiert werden konnte. Überprüfe deinen API-Schlüssel in den Einstellungen.';
	@override late final _Translations$exerciseSetup$types$de types = _Translations$exerciseSetup$types$de._(_root);
}

// Path: topics
class _Translations$topics$de implements Translations$topics$en {
	_Translations$topics$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get single => 'Ein Thema';
	@override String get multiple => 'Mehrere Themen';
	@override String get titleHint => 'Titel';
	@override String get contentHint => 'Inhalt';
	@override String get writingGuide => 'Verwende für hochwertige Übungen einen klaren Titel und beschreibe im Inhalt genau, was du üben möchtest. Nenne ausdrücklich Kontext, Wortschatz, Grammatik, Fertigkeit und wichtige Details. Du kannst auch eine bestimmte Technik, ein Format, eine Situation, das Üben typischer Fehler oder andere Schwerpunkte angeben. Vermeide zu allgemeine Beschreibungen.';
	@override String get multipleInstructions => 'Um mehrere Themen hinzuzufügen, schreibe ~ vor jeden Titel und ^ vor den jeweiligen Inhalt. Das nächste ~ beginnt ein neues Thema. Titel und Inhalte dürfen nicht leer sein.\n\nBeispiel: ~Reisen^Wortschatz für den Flughafen~Essen^Sätze für ein Restaurant';
	@override String get invalidMultiple => 'Der Text ist ungültig. Stelle sicher, dass jedes Thema einen mit ~ markierten Titel und einen mit ^ markierten Inhalt hat und beides nicht leer ist.';
	@override String get deleteConfirmation => 'Möchtest du die ausgewählten Themen löschen?';
}

// Path: exercise
class _Translations$exercise$de implements Translations$exercise$en {
	_Translations$exercise$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get correctAnswer => 'Richtig!';
	@override String get confirmAnswer => 'Antwort bestätigen';
	@override String get confirmAnswers => 'Antworten bestätigen';
	@override String get next => 'Nächste Übung';
	@override String get abruptChatFeedback => 'Chat wurde vorzeitig beendet.';
	@override String get endChatTitle => 'Chat beenden?';
	@override String get endChatMessage => 'Der Chat wird vorzeitig beendet und als falsch bewertet.';
	@override String get newChatTitle => 'Neuen Chat starten?';
	@override String get newChatMessage => 'Die Nachrichten des aktuellen Chats werden gelöscht.';
}

// Path: loading
class _Translations$loading$de implements Translations$loading$en {
	_Translations$loading$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get exercises => 'Übungen werden abgerufen';
	@override String get feedback => 'Feedback wird abgerufen';
}

// Path: feedback
class _Translations$feedback$de implements Translations$feedback$en {
	_Translations$feedback$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get regenerateExercises => 'Übungen neu erstellen';
	@override String get backToMenu => 'Zurück zum Menü';
}

// Path: settings.credit
class _Translations$settings$credit$de implements Translations$settings$credit$en {
	_Translations$settings$credit$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Guthaben aktualisieren';
	@override String get notStarted => 'Guthaben: —';
	@override String get loading => 'Guthaben wird geprüft...';
	@override String available({required Object amount}) => '${amount} USD';
	@override String get unauthorized => 'Guthaben nicht autorisiert';
	@override String get unavailable => 'Guthaben nicht verfügbar';
}

// Path: exerciseSetup.types
class _Translations$exerciseSetup$types$de implements Translations$exerciseSetup$types$en {
	_Translations$exerciseSetup$types$de._(this._root);

	final TranslationsDe _root; // ignore: unused_field

	// Translations
	@override String get dialog => 'Dialog';
	@override String get fillTheBlank => 'Lücken ausfüllen';
	@override String get matchElements => 'Elemente zuordnen';
	@override String get multipleChoice => 'Multiple Choice';
	@override String get multipleChoiceList => 'Multiple-Choice-Liste';
	@override String get selectAllThatApply => 'Alle zutreffenden auswählen';
	@override String get wordOrdering => 'Wörter ordnen';
	@override String get write => 'Schreiben';
	@override String get writeList => 'Liste schreiben';
}

/// The flat map containing all translations for locale <de>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsDe {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Weiter',
			'common.confirm' => 'Bestätigen',
			'common.cancel' => 'Abbrechen',
			'common.back' => 'Zurück',
			'common.retry' => 'Erneut versuchen',
			'common.delete' => 'Löschen',
			'languages.english' => 'Englisch',
			'languages.spanish' => 'Spanisch (Mexiko)',
			'languages.german' => 'Deutsch',
			'languages.portuguese' => 'Portugiesisch (Brasilien)',
			'languages.french' => 'Französisch',
			'languages.italian' => 'Italienisch',
			'languages.select' => 'Sprache auswählen',
			'navigation.home' => 'Start',
			'navigation.settings' => 'Einstellungen',
			'onboarding.nativeLanguageTitle' => 'Muttersprache festlegen',
			'onboarding.nativeLanguageLabel' => 'Muttersprache',
			'onboarding.learningLanguageTitle' => 'Lernsprache festlegen',
			'onboarding.learningLanguageLabel' => 'Lernsprache',
			'onboarding.apiKeyTitle' => 'API-Schlüssel einrichten',
			'onboarding.apiKeyLabel' => 'API-Schlüssel',
			'onboarding.useSavedApiKey' => 'Gespeicherten API-Schlüssel verwenden',
			'onboarding.getApiKeyLink' => 'API-Schlüssel auf nano-gpt.com erhalten',
			'onboarding.couldNotOpenApiLink' => 'Die API-Seite von nano-gpt.com konnte nicht geöffnet werden.',
			'onboarding.invalidApiKey' => 'Der API-Schlüssel ist ungültig.',
			'onboarding.unavailableApiKey' => 'Der API-Schlüssel konnte nicht überprüft werden. Versuche es erneut.',
			'settings.title' => 'Einstellungen',
			'settings.configuration' => 'Konfiguration',
			'settings.minimumCredit' => ({required Object amount}) => 'Du brauchst mehr als ${amount} USD Guthaben, um die App zu verwenden.',
			'settings.voiceSpeed' => 'Sprechgeschwindigkeit',
			'settings.feedbackLookback' => 'Berücksichtigtes Feedback',
			'settings.days' => ({required Object count}) => '${count} Tage',
			'settings.credit.refresh' => 'Guthaben aktualisieren',
			'settings.credit.notStarted' => 'Guthaben: —',
			'settings.credit.loading' => 'Guthaben wird geprüft...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Guthaben nicht autorisiert',
			'settings.credit.unavailable' => 'Guthaben nicht verfügbar',
			'errors.configureApiKey' => 'API-Schlüssel einrichten',
			'errors.authentication' => 'Auf den Dienst konnte nicht zugegriffen werden. Überprüfe deinen API-Schlüssel.',
			'errors.usageLimit' => 'Du hast das Nutzungslimit erreicht. Überprüfe dein Guthaben oder versuche es später erneut.',
			'errors.temporary' => 'Beim Dienst ist ein vorübergehendes Problem aufgetreten.',
			'errors.request' => 'Die Anfrage konnte nicht abgeschlossen werden.',
			'learningHome.priorityHelp' => 'Die Priorität bestimmt, welche Optionen häufiger oder seltener erscheinen:',
			'learningHome.priorityLow' => 'Niedrig',
			'learningHome.priorityMedium' => 'Mittel',
			'learningHome.priorityHigh' => 'Hoch',
			'learningHome.configurationTab' => 'Konfiguration',
			'learningHome.topicsTab' => 'Themen',
			'exerciseSetup.cefrLevel' => 'GER-Niveau',
			'exerciseSetup.exerciseCount' => 'Anzahl der Übungen',
			'exerciseSetup.promptContent' => 'Aufgabeninhalt',
			'exerciseSetup.text' => 'Text',
			'exerciseSetup.audio' => 'Audio',
			'exerciseSetup.exerciseTypes' => 'Übungstypen',
			'exerciseSetup.deselectAll' => 'Auswahl aufheben',
			'exerciseSetup.selectAll' => 'Alle auswählen',
			'exerciseSetup.availableTopics' => 'Verfügbare Themen',
			'exerciseSetup.noAvailableTopics' => 'Keine Themen verfügbar',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'Du brauchst mehr als ${amount} USD Guthaben, um fortzufahren.',
			'exerciseSetup.unauthorizedCredit' => 'Du kannst nicht fortfahren, weil dein Guthaben nicht autorisiert werden konnte. Überprüfe deinen API-Schlüssel in den Einstellungen.',
			'exerciseSetup.types.dialog' => 'Dialog',
			'exerciseSetup.types.fillTheBlank' => 'Lücken ausfüllen',
			'exerciseSetup.types.matchElements' => 'Elemente zuordnen',
			'exerciseSetup.types.multipleChoice' => 'Multiple Choice',
			'exerciseSetup.types.multipleChoiceList' => 'Multiple-Choice-Liste',
			'exerciseSetup.types.selectAllThatApply' => 'Alle zutreffenden auswählen',
			'exerciseSetup.types.wordOrdering' => 'Wörter ordnen',
			'exerciseSetup.types.write' => 'Schreiben',
			'exerciseSetup.types.writeList' => 'Liste schreiben',
			'topics.single' => 'Ein Thema',
			'topics.multiple' => 'Mehrere Themen',
			'topics.titleHint' => 'Titel',
			'topics.contentHint' => 'Inhalt',
			'topics.writingGuide' => 'Verwende für hochwertige Übungen einen klaren Titel und beschreibe im Inhalt genau, was du üben möchtest. Nenne ausdrücklich Kontext, Wortschatz, Grammatik, Fertigkeit und wichtige Details. Du kannst auch eine bestimmte Technik, ein Format, eine Situation, das Üben typischer Fehler oder andere Schwerpunkte angeben. Vermeide zu allgemeine Beschreibungen.',
			'topics.multipleInstructions' => 'Um mehrere Themen hinzuzufügen, schreibe ~ vor jeden Titel und ^ vor den jeweiligen Inhalt. Das nächste ~ beginnt ein neues Thema. Titel und Inhalte dürfen nicht leer sein.\n\nBeispiel: ~Reisen^Wortschatz für den Flughafen~Essen^Sätze für ein Restaurant',
			'topics.invalidMultiple' => 'Der Text ist ungültig. Stelle sicher, dass jedes Thema einen mit ~ markierten Titel und einen mit ^ markierten Inhalt hat und beides nicht leer ist.',
			'topics.deleteConfirmation' => 'Möchtest du die ausgewählten Themen löschen?',
			'exercise.correctAnswer' => 'Richtig!',
			'exercise.confirmAnswer' => 'Antwort bestätigen',
			'exercise.confirmAnswers' => 'Antworten bestätigen',
			'exercise.next' => 'Nächste Übung',
			'exercise.abruptChatFeedback' => 'Chat wurde vorzeitig beendet.',
			'exercise.endChatTitle' => 'Chat beenden?',
			'exercise.endChatMessage' => 'Der Chat wird vorzeitig beendet und als falsch bewertet.',
			'exercise.newChatTitle' => 'Neuen Chat starten?',
			'exercise.newChatMessage' => 'Die Nachrichten des aktuellen Chats werden gelöscht.',
			'loading.exercises' => 'Übungen werden abgerufen',
			'loading.feedback' => 'Feedback wird abgerufen',
			'feedback.regenerateExercises' => 'Übungen neu erstellen',
			'feedback.backToMenu' => 'Zurück zum Menü',
			_ => null,
		};
	}
}
