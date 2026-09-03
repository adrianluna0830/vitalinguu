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
class TranslationsFr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsFr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.fr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <fr>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsFr _root = this; // ignore: unused_field

	@override
	TranslationsFr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsFr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$fr app = _Translations$app$fr._(_root);
	@override late final _Translations$common$fr common = _Translations$common$fr._(_root);
	@override late final _Translations$languages$fr languages = _Translations$languages$fr._(_root);
	@override late final _Translations$navigation$fr navigation = _Translations$navigation$fr._(_root);
	@override late final _Translations$onboarding$fr onboarding = _Translations$onboarding$fr._(_root);
	@override late final _Translations$settings$fr settings = _Translations$settings$fr._(_root);
	@override late final _Translations$errors$fr errors = _Translations$errors$fr._(_root);
	@override late final _Translations$learningHome$fr learningHome = _Translations$learningHome$fr._(_root);
	@override late final _Translations$exerciseSetup$fr exerciseSetup = _Translations$exerciseSetup$fr._(_root);
	@override late final _Translations$topics$fr topics = _Translations$topics$fr._(_root);
	@override late final _Translations$exercise$fr exercise = _Translations$exercise$fr._(_root);
	@override late final _Translations$loading$fr loading = _Translations$loading$fr._(_root);
	@override late final _Translations$feedback$fr feedback = _Translations$feedback$fr._(_root);
}

// Path: app
class _Translations$app$fr implements Translations$app$en {
	_Translations$app$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vitalinguu';
}

// Path: common
class _Translations$common$fr implements Translations$common$en {
	_Translations$common$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'Continuer';
	@override String get confirm => 'Confirmer';
	@override String get cancel => 'Annuler';
	@override String get back => 'Retour';
	@override String get retry => 'Réessayer';
	@override String get delete => 'Supprimer';
}

// Path: languages
class _Translations$languages$fr implements Translations$languages$en {
	_Translations$languages$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get english => 'Anglais';
	@override String get spanish => 'Espagnol (Mexique)';
	@override String get german => 'Allemand';
	@override String get portuguese => 'Portugais (Brésil)';
	@override String get french => 'Français';
	@override String get italian => 'Italien';
	@override String get select => 'Sélectionnez une langue';
}

// Path: navigation
class _Translations$navigation$fr implements Translations$navigation$en {
	_Translations$navigation$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get home => 'Accueil';
	@override String get settings => 'Paramètres';
}

// Path: onboarding
class _Translations$onboarding$fr implements Translations$onboarding$en {
	_Translations$onboarding$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get nativeLanguageTitle => 'Configurez votre langue maternelle';
	@override String get nativeLanguageLabel => 'Langue maternelle';
	@override String get learningLanguageTitle => 'Configurez la langue que vous souhaitez apprendre';
	@override String get learningLanguageLabel => 'Langue d’apprentissage';
	@override String get apiKeyTitle => 'Configurez votre clé API';
	@override String get apiKeyLabel => 'Clé API';
	@override String get useSavedApiKey => 'Utiliser la clé API enregistrée';
	@override String get getApiKeyLink => 'Obtenir une clé API sur nano-gpt.com';
	@override String get couldNotOpenApiLink => 'Impossible d’ouvrir la page API de nano-gpt.com.';
	@override String get invalidApiKey => 'La clé API n’est pas valide.';
	@override String get unavailableApiKey => 'Impossible de valider la clé API. Réessayez.';
}

// Path: settings
class _Translations$settings$fr implements Translations$settings$en {
	_Translations$settings$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Paramètres';
	@override String get configuration => 'Configuration';
	@override String minimumCredit({required Object amount}) => 'Vous devez disposer de plus de ${amount} USD de crédit pour utiliser l’application.';
	@override String get voiceSpeed => 'Vitesse de la voix';
	@override String get feedbackLookback => 'Historique pris en compte';
	@override String days({required Object count}) => '${count} jours';
	@override late final _Translations$settings$credit$fr credit = _Translations$settings$credit$fr._(_root);
}

// Path: errors
class _Translations$errors$fr implements Translations$errors$en {
	_Translations$errors$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get configureApiKey => 'Configurer la clé API';
	@override String get authentication => 'Impossible d’accéder au service. Vérifiez votre clé API.';
	@override String get usageLimit => 'Vous avez atteint la limite d’utilisation. Vérifiez votre solde ou réessayez plus tard.';
	@override String get temporary => 'Le service a rencontré un problème temporaire.';
	@override String get request => 'Impossible de terminer la requête.';
}

// Path: learningHome
class _Translations$learningHome$fr implements Translations$learningHome$en {
	_Translations$learningHome$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get priorityHelp => 'La priorité détermine quelles options apparaîtront plus ou moins souvent :';
	@override String get priorityLow => 'Faible';
	@override String get priorityMedium => 'Moyenne';
	@override String get priorityHigh => 'Élevée';
	@override String get configurationTab => 'Configuration';
	@override String get topicsTab => 'Thèmes';
}

// Path: exerciseSetup
class _Translations$exerciseSetup$fr implements Translations$exerciseSetup$en {
	_Translations$exerciseSetup$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get cefrLevel => 'Niveau CECR';
	@override String get exerciseCount => 'Nombre d’exercices';
	@override String get promptContent => 'Contenu de la consigne';
	@override String get text => 'Texte';
	@override String get audio => 'Audio';
	@override String get exerciseTypes => 'Types d’exercice';
	@override String get deselectAll => 'Tout désélectionner';
	@override String get selectAll => 'Tout sélectionner';
	@override String get availableTopics => 'Thèmes disponibles';
	@override String get noAvailableTopics => 'Aucun thème disponible';
	@override String minimumCredit({required Object amount}) => 'Vous devez disposer de plus de ${amount} USD de crédit pour continuer.';
	@override late final _Translations$exerciseSetup$types$fr types = _Translations$exerciseSetup$types$fr._(_root);
}

// Path: topics
class _Translations$topics$fr implements Translations$topics$en {
	_Translations$topics$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get single => 'Un thème';
	@override String get multiple => 'Plusieurs thèmes';
	@override String get titleHint => 'Titre';
	@override String get contentHint => 'Contenu';
	@override String get writingGuide => 'Pour obtenir des exercices de qualité, utilisez un titre clair et décrivez précisément dans le contenu ce que vous souhaitez pratiquer. Indiquez explicitement le contexte, le vocabulaire, la grammaire, la compétence et les détails importants. Vous pouvez aussi demander une technique, un format, un type de situation, la pratique d’erreurs fréquentes ou un aspect à renforcer. Évitez les descriptions trop générales.';
	@override String get multipleInstructions => 'Pour ajouter plusieurs thèmes, écrivez ~ avant chaque titre et ^ avant son contenu. Le prochain ~ commence un autre thème. Ne laissez ni titre ni contenu vide.\n\nExemple : ~Voyages^Vocabulaire pour l’aéroport~Cuisine^Phrases pour un restaurant';
	@override String get invalidMultiple => 'Le texte n’est pas valide. Vérifiez que chaque thème possède un titre marqué par ~ et un contenu marqué par ^, sans les laisser vides.';
	@override String get deleteConfirmation => 'Voulez-vous supprimer les thèmes sélectionnés ?';
}

// Path: exercise
class _Translations$exercise$fr implements Translations$exercise$en {
	_Translations$exercise$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get correctAnswer => 'Bonne réponse !';
	@override String get confirmAnswer => 'Confirmer la réponse';
	@override String get confirmAnswers => 'Confirmer les réponses';
	@override String get next => 'Exercice suivant';
	@override String get abruptChatFeedback => 'La discussion s’est terminée brusquement.';
	@override String get endChatTitle => 'Terminer la discussion ?';
	@override String get endChatMessage => 'La discussion se terminera brusquement et sera considérée comme incorrecte.';
}

// Path: loading
class _Translations$loading$fr implements Translations$loading$en {
	_Translations$loading$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get exercises => 'Récupération des exercices';
	@override String get feedback => 'Récupération du feedback';
}

// Path: feedback
class _Translations$feedback$fr implements Translations$feedback$en {
	_Translations$feedback$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get regenerateExercises => 'Régénérer les exercices';
	@override String get backToMenu => 'Retour au menu';
}

// Path: settings.credit
class _Translations$settings$credit$fr implements Translations$settings$credit$en {
	_Translations$settings$credit$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Actualiser le crédit';
	@override String get notStarted => 'Crédit : —';
	@override String get loading => 'Consultation du crédit...';
	@override String available({required Object amount}) => '${amount} USD';
	@override String get unauthorized => 'Crédit non autorisé';
	@override String get unavailable => 'Crédit indisponible';
}

// Path: exerciseSetup.types
class _Translations$exerciseSetup$types$fr implements Translations$exerciseSetup$types$en {
	_Translations$exerciseSetup$types$fr._(this._root);

	final TranslationsFr _root; // ignore: unused_field

	// Translations
	@override String get dialog => 'Dialogue';
	@override String get fillTheBlank => 'Compléter les blancs';
	@override String get matchElements => 'Associer les éléments';
	@override String get multipleChoice => 'Choix multiple';
	@override String get multipleChoiceList => 'Liste à choix multiple';
	@override String get selectAllThatApply => 'Sélectionner toutes les bonnes réponses';
	@override String get wordOrdering => 'Remettre les mots dans l’ordre';
	@override String get write => 'Écrire';
	@override String get writeList => 'Écrire une liste';
}

/// The flat map containing all translations for locale <fr>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsFr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Continuer',
			'common.confirm' => 'Confirmer',
			'common.cancel' => 'Annuler',
			'common.back' => 'Retour',
			'common.retry' => 'Réessayer',
			'common.delete' => 'Supprimer',
			'languages.english' => 'Anglais',
			'languages.spanish' => 'Espagnol (Mexique)',
			'languages.german' => 'Allemand',
			'languages.portuguese' => 'Portugais (Brésil)',
			'languages.french' => 'Français',
			'languages.italian' => 'Italien',
			'languages.select' => 'Sélectionnez une langue',
			'navigation.home' => 'Accueil',
			'navigation.settings' => 'Paramètres',
			'onboarding.nativeLanguageTitle' => 'Configurez votre langue maternelle',
			'onboarding.nativeLanguageLabel' => 'Langue maternelle',
			'onboarding.learningLanguageTitle' => 'Configurez la langue que vous souhaitez apprendre',
			'onboarding.learningLanguageLabel' => 'Langue d’apprentissage',
			'onboarding.apiKeyTitle' => 'Configurez votre clé API',
			'onboarding.apiKeyLabel' => 'Clé API',
			'onboarding.useSavedApiKey' => 'Utiliser la clé API enregistrée',
			'onboarding.getApiKeyLink' => 'Obtenir une clé API sur nano-gpt.com',
			'onboarding.couldNotOpenApiLink' => 'Impossible d’ouvrir la page API de nano-gpt.com.',
			'onboarding.invalidApiKey' => 'La clé API n’est pas valide.',
			'onboarding.unavailableApiKey' => 'Impossible de valider la clé API. Réessayez.',
			'settings.title' => 'Paramètres',
			'settings.configuration' => 'Configuration',
			'settings.minimumCredit' => ({required Object amount}) => 'Vous devez disposer de plus de ${amount} USD de crédit pour utiliser l’application.',
			'settings.voiceSpeed' => 'Vitesse de la voix',
			'settings.feedbackLookback' => 'Historique pris en compte',
			'settings.days' => ({required Object count}) => '${count} jours',
			'settings.credit.refresh' => 'Actualiser le crédit',
			'settings.credit.notStarted' => 'Crédit : —',
			'settings.credit.loading' => 'Consultation du crédit...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Crédit non autorisé',
			'settings.credit.unavailable' => 'Crédit indisponible',
			'errors.configureApiKey' => 'Configurer la clé API',
			'errors.authentication' => 'Impossible d’accéder au service. Vérifiez votre clé API.',
			'errors.usageLimit' => 'Vous avez atteint la limite d’utilisation. Vérifiez votre solde ou réessayez plus tard.',
			'errors.temporary' => 'Le service a rencontré un problème temporaire.',
			'errors.request' => 'Impossible de terminer la requête.',
			'learningHome.priorityHelp' => 'La priorité détermine quelles options apparaîtront plus ou moins souvent :',
			'learningHome.priorityLow' => 'Faible',
			'learningHome.priorityMedium' => 'Moyenne',
			'learningHome.priorityHigh' => 'Élevée',
			'learningHome.configurationTab' => 'Configuration',
			'learningHome.topicsTab' => 'Thèmes',
			'exerciseSetup.cefrLevel' => 'Niveau CECR',
			'exerciseSetup.exerciseCount' => 'Nombre d’exercices',
			'exerciseSetup.promptContent' => 'Contenu de la consigne',
			'exerciseSetup.text' => 'Texte',
			'exerciseSetup.audio' => 'Audio',
			'exerciseSetup.exerciseTypes' => 'Types d’exercice',
			'exerciseSetup.deselectAll' => 'Tout désélectionner',
			'exerciseSetup.selectAll' => 'Tout sélectionner',
			'exerciseSetup.availableTopics' => 'Thèmes disponibles',
			'exerciseSetup.noAvailableTopics' => 'Aucun thème disponible',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'Vous devez disposer de plus de ${amount} USD de crédit pour continuer.',
			'exerciseSetup.types.dialog' => 'Dialogue',
			'exerciseSetup.types.fillTheBlank' => 'Compléter les blancs',
			'exerciseSetup.types.matchElements' => 'Associer les éléments',
			'exerciseSetup.types.multipleChoice' => 'Choix multiple',
			'exerciseSetup.types.multipleChoiceList' => 'Liste à choix multiple',
			'exerciseSetup.types.selectAllThatApply' => 'Sélectionner toutes les bonnes réponses',
			'exerciseSetup.types.wordOrdering' => 'Remettre les mots dans l’ordre',
			'exerciseSetup.types.write' => 'Écrire',
			'exerciseSetup.types.writeList' => 'Écrire une liste',
			'topics.single' => 'Un thème',
			'topics.multiple' => 'Plusieurs thèmes',
			'topics.titleHint' => 'Titre',
			'topics.contentHint' => 'Contenu',
			'topics.writingGuide' => 'Pour obtenir des exercices de qualité, utilisez un titre clair et décrivez précisément dans le contenu ce que vous souhaitez pratiquer. Indiquez explicitement le contexte, le vocabulaire, la grammaire, la compétence et les détails importants. Vous pouvez aussi demander une technique, un format, un type de situation, la pratique d’erreurs fréquentes ou un aspect à renforcer. Évitez les descriptions trop générales.',
			'topics.multipleInstructions' => 'Pour ajouter plusieurs thèmes, écrivez ~ avant chaque titre et ^ avant son contenu. Le prochain ~ commence un autre thème. Ne laissez ni titre ni contenu vide.\n\nExemple : ~Voyages^Vocabulaire pour l’aéroport~Cuisine^Phrases pour un restaurant',
			'topics.invalidMultiple' => 'Le texte n’est pas valide. Vérifiez que chaque thème possède un titre marqué par ~ et un contenu marqué par ^, sans les laisser vides.',
			'topics.deleteConfirmation' => 'Voulez-vous supprimer les thèmes sélectionnés ?',
			'exercise.correctAnswer' => 'Bonne réponse !',
			'exercise.confirmAnswer' => 'Confirmer la réponse',
			'exercise.confirmAnswers' => 'Confirmer les réponses',
			'exercise.next' => 'Exercice suivant',
			'exercise.abruptChatFeedback' => 'La discussion s’est terminée brusquement.',
			'exercise.endChatTitle' => 'Terminer la discussion ?',
			'exercise.endChatMessage' => 'La discussion se terminera brusquement et sera considérée comme incorrecte.',
			'loading.exercises' => 'Récupération des exercices',
			'loading.feedback' => 'Récupération du feedback',
			'feedback.regenerateExercises' => 'Régénérer les exercices',
			'feedback.backToMenu' => 'Retour au menu',
			_ => null,
		};
	}
}
