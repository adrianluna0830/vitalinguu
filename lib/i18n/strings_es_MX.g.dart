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
class TranslationsEsMx with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEsMx({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.esMx,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <es-MX>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsEsMx _root = this; // ignore: unused_field

	@override
	TranslationsEsMx $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEsMx(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$es_MX app = _Translations$app$es_MX._(_root);
	@override late final _Translations$common$es_MX common = _Translations$common$es_MX._(_root);
	@override late final _Translations$languages$es_MX languages = _Translations$languages$es_MX._(_root);
	@override late final _Translations$navigation$es_MX navigation = _Translations$navigation$es_MX._(_root);
	@override late final _Translations$onboarding$es_MX onboarding = _Translations$onboarding$es_MX._(_root);
	@override late final _Translations$settings$es_MX settings = _Translations$settings$es_MX._(_root);
	@override late final _Translations$errors$es_MX errors = _Translations$errors$es_MX._(_root);
	@override late final _Translations$learningHome$es_MX learningHome = _Translations$learningHome$es_MX._(_root);
	@override late final _Translations$exerciseSetup$es_MX exerciseSetup = _Translations$exerciseSetup$es_MX._(_root);
	@override late final _Translations$topics$es_MX topics = _Translations$topics$es_MX._(_root);
	@override late final _Translations$exercise$es_MX exercise = _Translations$exercise$es_MX._(_root);
	@override late final _Translations$loading$es_MX loading = _Translations$loading$es_MX._(_root);
	@override late final _Translations$feedback$es_MX feedback = _Translations$feedback$es_MX._(_root);
}

// Path: app
class _Translations$app$es_MX implements Translations$app$en {
	_Translations$app$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vitalinguu';
}

// Path: common
class _Translations$common$es_MX implements Translations$common$en {
	_Translations$common$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'Continuar';
	@override String get confirm => 'Confirmar';
	@override String get cancel => 'Cancelar';
	@override String get back => 'Volver';
	@override String get retry => 'Reintentar';
	@override String get delete => 'Eliminar';
}

// Path: languages
class _Translations$languages$es_MX implements Translations$languages$en {
	_Translations$languages$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get english => 'Inglés';
	@override String get spanish => 'Español (México)';
	@override String get german => 'Alemán';
	@override String get portuguese => 'Portugués (Brasil)';
	@override String get french => 'Francés';
	@override String get italian => 'Italiano';
	@override String get select => 'Selecciona un idioma';
}

// Path: navigation
class _Translations$navigation$es_MX implements Translations$navigation$en {
	_Translations$navigation$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get home => 'Inicio';
	@override String get settings => 'Ajustes';
}

// Path: onboarding
class _Translations$onboarding$es_MX implements Translations$onboarding$en {
	_Translations$onboarding$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get nativeLanguageTitle => 'Configura tu idioma nativo';
	@override String get nativeLanguageLabel => 'Idioma nativo';
	@override String get learningLanguageTitle => 'Configura el idioma que quieres aprender';
	@override String get learningLanguageLabel => 'Idioma de aprendizaje';
	@override String get apiKeyTitle => 'Configura tu API key';
	@override String get apiKeyLabel => 'API key';
	@override String get useSavedApiKey => 'Usar API key guardada';
	@override String get getApiKeyLink => 'Obtener una API key en nano-gpt.com';
	@override String get couldNotOpenApiLink => 'No se pudo abrir la página de API de nano-gpt.com.';
	@override String get invalidApiKey => 'La API key no es válida.';
	@override String get unavailableApiKey => 'No se pudo validar la API key. Inténtalo de nuevo.';
}

// Path: settings
class _Translations$settings$es_MX implements Translations$settings$en {
	_Translations$settings$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get title => 'Ajustes';
	@override String get configuration => 'Configuración';
	@override String minimumCredit({required Object amount}) => 'Necesitas más de ${amount} USD de crédito para usar la app.';
	@override String get voiceSpeed => 'Velocidad de voz';
	@override String get feedbackLookback => 'Feedback considerado';
	@override String days({required Object count}) => '${count} días';
	@override late final _Translations$settings$credit$es_MX credit = _Translations$settings$credit$es_MX._(_root);
}

// Path: errors
class _Translations$errors$es_MX implements Translations$errors$en {
	_Translations$errors$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get configureApiKey => 'Configurar API key';
	@override String get authentication => 'No se pudo acceder al servicio. Revisa tu API key.';
	@override String get usageLimit => 'Alcanzaste el límite de uso. Revisa tu saldo o inténtalo más tarde.';
	@override String get temporary => 'El servicio tuvo un problema temporal.';
	@override String get request => 'No se pudo completar la solicitud.';
}

// Path: learningHome
class _Translations$learningHome$es_MX implements Translations$learningHome$en {
	_Translations$learningHome$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get priorityHelp => 'La prioridad indica qué opciones aparecerán con mayor o menor frecuencia:';
	@override String get priorityLow => 'Baja';
	@override String get priorityMedium => 'Media';
	@override String get priorityHigh => 'Alta';
	@override String get configurationTab => 'Configuración';
	@override String get topicsTab => 'Temas';
}

// Path: exerciseSetup
class _Translations$exerciseSetup$es_MX implements Translations$exerciseSetup$en {
	_Translations$exerciseSetup$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get cefrLevel => 'Nivel CEFR';
	@override String get exerciseCount => 'Número de ejercicios';
	@override String get promptContent => 'Contenido del prompt';
	@override String get text => 'Texto';
	@override String get audio => 'Audio';
	@override String get exerciseTypes => 'Tipos de ejercicio';
	@override String get deselectAll => 'Deseleccionar todos';
	@override String get selectAll => 'Seleccionar todos';
	@override String get availableTopics => 'Temas disponibles';
	@override String get noAvailableTopics => 'No hay temas disponibles';
	@override String minimumCredit({required Object amount}) => 'Necesitas más de ${amount} USD de crédito para continuar.';
	@override late final _Translations$exerciseSetup$types$es_MX types = _Translations$exerciseSetup$types$es_MX._(_root);
}

// Path: topics
class _Translations$topics$es_MX implements Translations$topics$en {
	_Translations$topics$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get single => 'Un tema';
	@override String get multiple => 'Varios temas';
	@override String get titleHint => 'Título';
	@override String get contentHint => 'Contenido';
	@override String get writingGuide => 'Para obtener ejercicios de buena calidad, usa un título claro y describe exactamente qué quieres practicar en el contenido. Sé explícito sobre el contexto, vocabulario, gramática, habilidad y detalles importantes. También puedes pedir una técnica, formato o tipo de situación, práctica de errores comunes o cualquier aspecto que quieras reforzar. Evita descripciones demasiado generales.';
	@override String get multipleInstructions => 'Para agregar varios temas, escribe ~ antes de cada título y ^ antes de su contenido. El siguiente ~ comienza otro tema. No dejes títulos ni contenidos vacíos.\n\nEjemplo: ~Viajes^Vocabulario para el aeropuerto~Comida^Frases para un restaurante';
	@override String get invalidMultiple => 'El texto no es válido. Asegúrate de que cada tema tenga un título con ~ y contenido con ^, sin dejarlos vacíos.';
	@override String get deleteConfirmation => '¿Quieres eliminar los temas seleccionados?';
}

// Path: exercise
class _Translations$exercise$es_MX implements Translations$exercise$en {
	_Translations$exercise$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get correctAnswer => '¡Contestaste bien!';
	@override String get confirmAnswer => 'Confirmar respuesta';
	@override String get confirmAnswers => 'Confirmar respuestas';
	@override String get next => 'Siguiente ejercicio';
	@override String get abruptChatFeedback => 'Chat terminado abruptamente.';
	@override String get endChatTitle => '¿Terminar el chat?';
	@override String get endChatMessage => 'El chat terminará abruptamente y se marcará como incorrecto.';
	@override String get newChatTitle => '¿Iniciar un nuevo chat?';
	@override String get newChatMessage => 'Se eliminarán los mensajes del chat actual.';
}

// Path: loading
class _Translations$loading$es_MX implements Translations$loading$en {
	_Translations$loading$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get exercises => 'Obteniendo ejercicios';
	@override String get feedback => 'Obteniendo feedback';
}

// Path: feedback
class _Translations$feedback$es_MX implements Translations$feedback$en {
	_Translations$feedback$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get regenerateExercises => 'Regenerar ejercicios';
	@override String get backToMenu => 'Volver al menú';
}

// Path: settings.credit
class _Translations$settings$credit$es_MX implements Translations$settings$credit$en {
	_Translations$settings$credit$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Actualizar crédito';
	@override String get notStarted => 'Crédito: —';
	@override String get loading => 'Consultando crédito...';
	@override String available({required Object amount}) => '${amount} USD';
	@override String get unauthorized => 'Crédito no autorizado';
	@override String get unavailable => 'Crédito no disponible';
}

// Path: exerciseSetup.types
class _Translations$exerciseSetup$types$es_MX implements Translations$exerciseSetup$types$en {
	_Translations$exerciseSetup$types$es_MX._(this._root);

	final TranslationsEsMx _root; // ignore: unused_field

	// Translations
	@override String get dialog => 'Diálogo';
	@override String get fillTheBlank => 'Completar espacios';
	@override String get matchElements => 'Relacionar elementos';
	@override String get multipleChoice => 'Opción múltiple';
	@override String get multipleChoiceList => 'Lista de opción múltiple';
	@override String get selectAllThatApply => 'Seleccionar todas las correctas';
	@override String get wordOrdering => 'Ordenar palabras';
	@override String get write => 'Escribir';
	@override String get writeList => 'Escribir una lista';
}

/// The flat map containing all translations for locale <es-MX>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEsMx {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Continuar',
			'common.confirm' => 'Confirmar',
			'common.cancel' => 'Cancelar',
			'common.back' => 'Volver',
			'common.retry' => 'Reintentar',
			'common.delete' => 'Eliminar',
			'languages.english' => 'Inglés',
			'languages.spanish' => 'Español (México)',
			'languages.german' => 'Alemán',
			'languages.portuguese' => 'Portugués (Brasil)',
			'languages.french' => 'Francés',
			'languages.italian' => 'Italiano',
			'languages.select' => 'Selecciona un idioma',
			'navigation.home' => 'Inicio',
			'navigation.settings' => 'Ajustes',
			'onboarding.nativeLanguageTitle' => 'Configura tu idioma nativo',
			'onboarding.nativeLanguageLabel' => 'Idioma nativo',
			'onboarding.learningLanguageTitle' => 'Configura el idioma que quieres aprender',
			'onboarding.learningLanguageLabel' => 'Idioma de aprendizaje',
			'onboarding.apiKeyTitle' => 'Configura tu API key',
			'onboarding.apiKeyLabel' => 'API key',
			'onboarding.useSavedApiKey' => 'Usar API key guardada',
			'onboarding.getApiKeyLink' => 'Obtener una API key en nano-gpt.com',
			'onboarding.couldNotOpenApiLink' => 'No se pudo abrir la página de API de nano-gpt.com.',
			'onboarding.invalidApiKey' => 'La API key no es válida.',
			'onboarding.unavailableApiKey' => 'No se pudo validar la API key. Inténtalo de nuevo.',
			'settings.title' => 'Ajustes',
			'settings.configuration' => 'Configuración',
			'settings.minimumCredit' => ({required Object amount}) => 'Necesitas más de ${amount} USD de crédito para usar la app.',
			'settings.voiceSpeed' => 'Velocidad de voz',
			'settings.feedbackLookback' => 'Feedback considerado',
			'settings.days' => ({required Object count}) => '${count} días',
			'settings.credit.refresh' => 'Actualizar crédito',
			'settings.credit.notStarted' => 'Crédito: —',
			'settings.credit.loading' => 'Consultando crédito...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Crédito no autorizado',
			'settings.credit.unavailable' => 'Crédito no disponible',
			'errors.configureApiKey' => 'Configurar API key',
			'errors.authentication' => 'No se pudo acceder al servicio. Revisa tu API key.',
			'errors.usageLimit' => 'Alcanzaste el límite de uso. Revisa tu saldo o inténtalo más tarde.',
			'errors.temporary' => 'El servicio tuvo un problema temporal.',
			'errors.request' => 'No se pudo completar la solicitud.',
			'learningHome.priorityHelp' => 'La prioridad indica qué opciones aparecerán con mayor o menor frecuencia:',
			'learningHome.priorityLow' => 'Baja',
			'learningHome.priorityMedium' => 'Media',
			'learningHome.priorityHigh' => 'Alta',
			'learningHome.configurationTab' => 'Configuración',
			'learningHome.topicsTab' => 'Temas',
			'exerciseSetup.cefrLevel' => 'Nivel CEFR',
			'exerciseSetup.exerciseCount' => 'Número de ejercicios',
			'exerciseSetup.promptContent' => 'Contenido del prompt',
			'exerciseSetup.text' => 'Texto',
			'exerciseSetup.audio' => 'Audio',
			'exerciseSetup.exerciseTypes' => 'Tipos de ejercicio',
			'exerciseSetup.deselectAll' => 'Deseleccionar todos',
			'exerciseSetup.selectAll' => 'Seleccionar todos',
			'exerciseSetup.availableTopics' => 'Temas disponibles',
			'exerciseSetup.noAvailableTopics' => 'No hay temas disponibles',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'Necesitas más de ${amount} USD de crédito para continuar.',
			'exerciseSetup.types.dialog' => 'Diálogo',
			'exerciseSetup.types.fillTheBlank' => 'Completar espacios',
			'exerciseSetup.types.matchElements' => 'Relacionar elementos',
			'exerciseSetup.types.multipleChoice' => 'Opción múltiple',
			'exerciseSetup.types.multipleChoiceList' => 'Lista de opción múltiple',
			'exerciseSetup.types.selectAllThatApply' => 'Seleccionar todas las correctas',
			'exerciseSetup.types.wordOrdering' => 'Ordenar palabras',
			'exerciseSetup.types.write' => 'Escribir',
			'exerciseSetup.types.writeList' => 'Escribir una lista',
			'topics.single' => 'Un tema',
			'topics.multiple' => 'Varios temas',
			'topics.titleHint' => 'Título',
			'topics.contentHint' => 'Contenido',
			'topics.writingGuide' => 'Para obtener ejercicios de buena calidad, usa un título claro y describe exactamente qué quieres practicar en el contenido. Sé explícito sobre el contexto, vocabulario, gramática, habilidad y detalles importantes. También puedes pedir una técnica, formato o tipo de situación, práctica de errores comunes o cualquier aspecto que quieras reforzar. Evita descripciones demasiado generales.',
			'topics.multipleInstructions' => 'Para agregar varios temas, escribe ~ antes de cada título y ^ antes de su contenido. El siguiente ~ comienza otro tema. No dejes títulos ni contenidos vacíos.\n\nEjemplo: ~Viajes^Vocabulario para el aeropuerto~Comida^Frases para un restaurante',
			'topics.invalidMultiple' => 'El texto no es válido. Asegúrate de que cada tema tenga un título con ~ y contenido con ^, sin dejarlos vacíos.',
			'topics.deleteConfirmation' => '¿Quieres eliminar los temas seleccionados?',
			'exercise.correctAnswer' => '¡Contestaste bien!',
			'exercise.confirmAnswer' => 'Confirmar respuesta',
			'exercise.confirmAnswers' => 'Confirmar respuestas',
			'exercise.next' => 'Siguiente ejercicio',
			'exercise.abruptChatFeedback' => 'Chat terminado abruptamente.',
			'exercise.endChatTitle' => '¿Terminar el chat?',
			'exercise.endChatMessage' => 'El chat terminará abruptamente y se marcará como incorrecto.',
			'exercise.newChatTitle' => '¿Iniciar un nuevo chat?',
			'exercise.newChatMessage' => 'Se eliminarán los mensajes del chat actual.',
			'loading.exercises' => 'Obteniendo ejercicios',
			'loading.feedback' => 'Obteniendo feedback',
			'feedback.regenerateExercises' => 'Regenerar ejercicios',
			'feedback.backToMenu' => 'Volver al menú',
			_ => null,
		};
	}
}
