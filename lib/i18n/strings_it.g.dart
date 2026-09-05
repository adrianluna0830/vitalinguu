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
class TranslationsIt with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsIt({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.it,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <it>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsIt _root = this; // ignore: unused_field

	@override
	TranslationsIt $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsIt(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$it app = _Translations$app$it._(_root);
	@override late final _Translations$common$it common = _Translations$common$it._(_root);
	@override late final _Translations$languages$it languages = _Translations$languages$it._(_root);
	@override late final _Translations$navigation$it navigation = _Translations$navigation$it._(_root);
	@override late final _Translations$onboarding$it onboarding = _Translations$onboarding$it._(_root);
	@override late final _Translations$settings$it settings = _Translations$settings$it._(_root);
	@override late final _Translations$errors$it errors = _Translations$errors$it._(_root);
	@override late final _Translations$learningHome$it learningHome = _Translations$learningHome$it._(_root);
	@override late final _Translations$exerciseSetup$it exerciseSetup = _Translations$exerciseSetup$it._(_root);
	@override late final _Translations$topics$it topics = _Translations$topics$it._(_root);
	@override late final _Translations$exercise$it exercise = _Translations$exercise$it._(_root);
	@override late final _Translations$loading$it loading = _Translations$loading$it._(_root);
	@override late final _Translations$feedback$it feedback = _Translations$feedback$it._(_root);
}

// Path: app
class _Translations$app$it implements Translations$app$en {
	_Translations$app$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vitalinguu';
}

// Path: common
class _Translations$common$it implements Translations$common$en {
	_Translations$common$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'Continua';
	@override String get confirm => 'Conferma';
	@override String get cancel => 'Annulla';
	@override String get back => 'Indietro';
	@override String get retry => 'Riprova';
	@override String get delete => 'Elimina';
}

// Path: languages
class _Translations$languages$it implements Translations$languages$en {
	_Translations$languages$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get english => 'Inglese';
	@override String get spanish => 'Spagnolo (Messico)';
	@override String get german => 'Tedesco';
	@override String get portuguese => 'Portoghese (Brasile)';
	@override String get french => 'Francese';
	@override String get italian => 'Italiano';
	@override String get select => 'Seleziona una lingua';
}

// Path: navigation
class _Translations$navigation$it implements Translations$navigation$en {
	_Translations$navigation$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get settings => 'Impostazioni';
}

// Path: onboarding
class _Translations$onboarding$it implements Translations$onboarding$en {
	_Translations$onboarding$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get nativeLanguageTitle => 'Configura la tua lingua madre';
	@override String get nativeLanguageLabel => 'Lingua madre';
	@override String get learningLanguageTitle => 'Configura la lingua che vuoi imparare';
	@override String get learningLanguageLabel => 'Lingua di apprendimento';
	@override String get apiKeyTitle => 'Configura la tua chiave API';
	@override String get apiKeyLabel => 'Chiave API';
	@override String get useSavedApiKey => 'Usa la chiave API salvata';
	@override String get getApiKeyLink => 'Ottieni una chiave API su nano-gpt.com';
	@override String get couldNotOpenApiLink => 'Impossibile aprire la pagina API di nano-gpt.com.';
	@override String get invalidApiKey => 'La chiave API non è valida.';
	@override String get unavailableApiKey => 'Impossibile verificare la chiave API. Riprova.';
}

// Path: settings
class _Translations$settings$it implements Translations$settings$en {
	_Translations$settings$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get title => 'Impostazioni';
	@override String get configuration => 'Configurazione';
	@override String minimumCredit({required Object amount}) => 'Devi avere più di ${amount} USD di credito per usare l’app.';
	@override String get voiceSpeed => 'Velocità della voce';
	@override String get feedbackLookback => 'Feedback considerato';
	@override String days({required Object count}) => '${count} giorni';
	@override late final _Translations$settings$credit$it credit = _Translations$settings$credit$it._(_root);
}

// Path: errors
class _Translations$errors$it implements Translations$errors$en {
	_Translations$errors$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get configureApiKey => 'Configura la chiave API';
	@override String get authentication => 'Impossibile accedere al servizio. Controlla la tua chiave API.';
	@override String get usageLimit => 'Hai raggiunto il limite di utilizzo. Controlla il saldo o riprova più tardi.';
	@override String get temporary => 'Il servizio ha riscontrato un problema temporaneo.';
	@override String get request => 'Impossibile completare la richiesta.';
}

// Path: learningHome
class _Translations$learningHome$it implements Translations$learningHome$en {
	_Translations$learningHome$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get priorityHelp => 'La priorità determina quali opzioni appariranno più o meno spesso:';
	@override String get priorityLow => 'Bassa';
	@override String get priorityMedium => 'Media';
	@override String get priorityHigh => 'Alta';
	@override String get configurationTab => 'Configurazione';
	@override String get topicsTab => 'Argomenti';
}

// Path: exerciseSetup
class _Translations$exerciseSetup$it implements Translations$exerciseSetup$en {
	_Translations$exerciseSetup$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get cefrLevel => 'Livello QCER';
	@override String get exerciseCount => 'Numero di esercizi';
	@override String get promptContent => 'Contenuto della consegna';
	@override String get text => 'Testo';
	@override String get audio => 'Audio';
	@override String get exerciseTypes => 'Tipi di esercizio';
	@override String get deselectAll => 'Deseleziona tutto';
	@override String get selectAll => 'Seleziona tutto';
	@override String get availableTopics => 'Argomenti disponibili';
	@override String get noAvailableTopics => 'Nessun argomento disponibile';
	@override String minimumCredit({required Object amount}) => 'Devi avere più di ${amount} USD di credito per continuare.';
	@override String get unauthorizedCredit => 'Non puoi continuare perché non è stato possibile autorizzare il credito. Controlla la chiave API nelle impostazioni.';
	@override late final _Translations$exerciseSetup$types$it types = _Translations$exerciseSetup$types$it._(_root);
}

// Path: topics
class _Translations$topics$it implements Translations$topics$en {
	_Translations$topics$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get single => 'Un argomento';
	@override String get multiple => 'Più argomenti';
	@override String get titleHint => 'Titolo';
	@override String get contentHint => 'Contenuto';
	@override String get writingGuide => 'Per ottenere esercizi di qualità, usa un titolo chiaro e descrivi con precisione nel contenuto ciò che vuoi praticare. Specifica il contesto, il vocabolario, la grammatica, l’abilità e i dettagli importanti. Puoi anche richiedere una tecnica, un formato, un tipo di situazione, la pratica degli errori comuni o un aspetto da rafforzare. Evita descrizioni troppo generiche.';
	@override String get multipleInstructions => 'Per aggiungere più argomenti, scrivi ~ prima di ogni titolo e ^ prima del relativo contenuto. Il successivo ~ inizia un altro argomento. Non lasciare vuoti titoli o contenuti.\n\nEsempio: ~Viaggi^Vocabolario per l’aeroporto~Cibo^Frasi per un ristorante';
	@override String get invalidMultiple => 'Il testo non è valido. Assicurati che ogni argomento abbia un titolo contrassegnato da ~ e un contenuto contrassegnato da ^, senza lasciarli vuoti.';
	@override String get deleteConfirmation => 'Vuoi eliminare gli argomenti selezionati?';
}

// Path: exercise
class _Translations$exercise$it implements Translations$exercise$en {
	_Translations$exercise$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get correctAnswer => 'Risposta corretta!';
	@override String get confirmAnswer => 'Conferma risposta';
	@override String get confirmAnswers => 'Conferma risposte';
	@override String get next => 'Esercizio successivo';
	@override String get abruptChatFeedback => 'La chat è terminata bruscamente.';
	@override String get endChatTitle => 'Terminare la chat?';
	@override String get endChatMessage => 'La chat terminerà bruscamente e sarà contrassegnata come errata.';
	@override String get newChatTitle => 'Avviare una nuova chat?';
	@override String get newChatMessage => 'I messaggi della chat attuale verranno eliminati.';
}

// Path: loading
class _Translations$loading$it implements Translations$loading$en {
	_Translations$loading$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get exercises => 'Recupero degli esercizi';
	@override String get feedback => 'Recupero del feedback';
}

// Path: feedback
class _Translations$feedback$it implements Translations$feedback$en {
	_Translations$feedback$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get regenerateExercises => 'Rigenera gli esercizi';
	@override String get backToMenu => 'Torna al menu';
}

// Path: settings.credit
class _Translations$settings$credit$it implements Translations$settings$credit$en {
	_Translations$settings$credit$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Aggiorna credito';
	@override String get notStarted => 'Credito: —';
	@override String get loading => 'Verifica del credito...';
	@override String available({required Object amount}) => '${amount} USD';
	@override String get unauthorized => 'Credito non autorizzato';
	@override String get unavailable => 'Credito non disponibile';
}

// Path: exerciseSetup.types
class _Translations$exerciseSetup$types$it implements Translations$exerciseSetup$types$en {
	_Translations$exerciseSetup$types$it._(this._root);

	final TranslationsIt _root; // ignore: unused_field

	// Translations
	@override String get dialog => 'Dialogo';
	@override String get fillTheBlank => 'Completa gli spazi';
	@override String get matchElements => 'Abbina gli elementi';
	@override String get multipleChoice => 'Scelta multipla';
	@override String get multipleChoiceList => 'Lista a scelta multipla';
	@override String get selectAllThatApply => 'Seleziona tutte le risposte corrette';
	@override String get wordOrdering => 'Riordina le parole';
	@override String get write => 'Scrivi';
	@override String get writeList => 'Scrivi un elenco';
}

/// The flat map containing all translations for locale <it>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsIt {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Continua',
			'common.confirm' => 'Conferma',
			'common.cancel' => 'Annulla',
			'common.back' => 'Indietro',
			'common.retry' => 'Riprova',
			'common.delete' => 'Elimina',
			'languages.english' => 'Inglese',
			'languages.spanish' => 'Spagnolo (Messico)',
			'languages.german' => 'Tedesco',
			'languages.portuguese' => 'Portoghese (Brasile)',
			'languages.french' => 'Francese',
			'languages.italian' => 'Italiano',
			'languages.select' => 'Seleziona una lingua',
			'navigation.home' => 'Home',
			'navigation.settings' => 'Impostazioni',
			'onboarding.nativeLanguageTitle' => 'Configura la tua lingua madre',
			'onboarding.nativeLanguageLabel' => 'Lingua madre',
			'onboarding.learningLanguageTitle' => 'Configura la lingua che vuoi imparare',
			'onboarding.learningLanguageLabel' => 'Lingua di apprendimento',
			'onboarding.apiKeyTitle' => 'Configura la tua chiave API',
			'onboarding.apiKeyLabel' => 'Chiave API',
			'onboarding.useSavedApiKey' => 'Usa la chiave API salvata',
			'onboarding.getApiKeyLink' => 'Ottieni una chiave API su nano-gpt.com',
			'onboarding.couldNotOpenApiLink' => 'Impossibile aprire la pagina API di nano-gpt.com.',
			'onboarding.invalidApiKey' => 'La chiave API non è valida.',
			'onboarding.unavailableApiKey' => 'Impossibile verificare la chiave API. Riprova.',
			'settings.title' => 'Impostazioni',
			'settings.configuration' => 'Configurazione',
			'settings.minimumCredit' => ({required Object amount}) => 'Devi avere più di ${amount} USD di credito per usare l’app.',
			'settings.voiceSpeed' => 'Velocità della voce',
			'settings.feedbackLookback' => 'Feedback considerato',
			'settings.days' => ({required Object count}) => '${count} giorni',
			'settings.credit.refresh' => 'Aggiorna credito',
			'settings.credit.notStarted' => 'Credito: —',
			'settings.credit.loading' => 'Verifica del credito...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Credito non autorizzato',
			'settings.credit.unavailable' => 'Credito non disponibile',
			'errors.configureApiKey' => 'Configura la chiave API',
			'errors.authentication' => 'Impossibile accedere al servizio. Controlla la tua chiave API.',
			'errors.usageLimit' => 'Hai raggiunto il limite di utilizzo. Controlla il saldo o riprova più tardi.',
			'errors.temporary' => 'Il servizio ha riscontrato un problema temporaneo.',
			'errors.request' => 'Impossibile completare la richiesta.',
			'learningHome.priorityHelp' => 'La priorità determina quali opzioni appariranno più o meno spesso:',
			'learningHome.priorityLow' => 'Bassa',
			'learningHome.priorityMedium' => 'Media',
			'learningHome.priorityHigh' => 'Alta',
			'learningHome.configurationTab' => 'Configurazione',
			'learningHome.topicsTab' => 'Argomenti',
			'exerciseSetup.cefrLevel' => 'Livello QCER',
			'exerciseSetup.exerciseCount' => 'Numero di esercizi',
			'exerciseSetup.promptContent' => 'Contenuto della consegna',
			'exerciseSetup.text' => 'Testo',
			'exerciseSetup.audio' => 'Audio',
			'exerciseSetup.exerciseTypes' => 'Tipi di esercizio',
			'exerciseSetup.deselectAll' => 'Deseleziona tutto',
			'exerciseSetup.selectAll' => 'Seleziona tutto',
			'exerciseSetup.availableTopics' => 'Argomenti disponibili',
			'exerciseSetup.noAvailableTopics' => 'Nessun argomento disponibile',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'Devi avere più di ${amount} USD di credito per continuare.',
			'exerciseSetup.unauthorizedCredit' => 'Non puoi continuare perché non è stato possibile autorizzare il credito. Controlla la chiave API nelle impostazioni.',
			'exerciseSetup.types.dialog' => 'Dialogo',
			'exerciseSetup.types.fillTheBlank' => 'Completa gli spazi',
			'exerciseSetup.types.matchElements' => 'Abbina gli elementi',
			'exerciseSetup.types.multipleChoice' => 'Scelta multipla',
			'exerciseSetup.types.multipleChoiceList' => 'Lista a scelta multipla',
			'exerciseSetup.types.selectAllThatApply' => 'Seleziona tutte le risposte corrette',
			'exerciseSetup.types.wordOrdering' => 'Riordina le parole',
			'exerciseSetup.types.write' => 'Scrivi',
			'exerciseSetup.types.writeList' => 'Scrivi un elenco',
			'topics.single' => 'Un argomento',
			'topics.multiple' => 'Più argomenti',
			'topics.titleHint' => 'Titolo',
			'topics.contentHint' => 'Contenuto',
			'topics.writingGuide' => 'Per ottenere esercizi di qualità, usa un titolo chiaro e descrivi con precisione nel contenuto ciò che vuoi praticare. Specifica il contesto, il vocabolario, la grammatica, l’abilità e i dettagli importanti. Puoi anche richiedere una tecnica, un formato, un tipo di situazione, la pratica degli errori comuni o un aspetto da rafforzare. Evita descrizioni troppo generiche.',
			'topics.multipleInstructions' => 'Per aggiungere più argomenti, scrivi ~ prima di ogni titolo e ^ prima del relativo contenuto. Il successivo ~ inizia un altro argomento. Non lasciare vuoti titoli o contenuti.\n\nEsempio: ~Viaggi^Vocabolario per l’aeroporto~Cibo^Frasi per un ristorante',
			'topics.invalidMultiple' => 'Il testo non è valido. Assicurati che ogni argomento abbia un titolo contrassegnato da ~ e un contenuto contrassegnato da ^, senza lasciarli vuoti.',
			'topics.deleteConfirmation' => 'Vuoi eliminare gli argomenti selezionati?',
			'exercise.correctAnswer' => 'Risposta corretta!',
			'exercise.confirmAnswer' => 'Conferma risposta',
			'exercise.confirmAnswers' => 'Conferma risposte',
			'exercise.next' => 'Esercizio successivo',
			'exercise.abruptChatFeedback' => 'La chat è terminata bruscamente.',
			'exercise.endChatTitle' => 'Terminare la chat?',
			'exercise.endChatMessage' => 'La chat terminerà bruscamente e sarà contrassegnata come errata.',
			'exercise.newChatTitle' => 'Avviare una nuova chat?',
			'exercise.newChatMessage' => 'I messaggi della chat attuale verranno eliminati.',
			'loading.exercises' => 'Recupero degli esercizi',
			'loading.feedback' => 'Recupero del feedback',
			'feedback.regenerateExercises' => 'Rigenera gli esercizi',
			'feedback.backToMenu' => 'Torna al menu',
			_ => null,
		};
	}
}
