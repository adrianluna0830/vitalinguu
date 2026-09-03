///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$app$en app = Translations$app$en._(_root);
	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$languages$en languages = Translations$languages$en._(_root);
	late final Translations$navigation$en navigation = Translations$navigation$en._(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en._(_root);
	late final Translations$settings$en settings = Translations$settings$en._(_root);
	late final Translations$errors$en errors = Translations$errors$en._(_root);
	late final Translations$learningHome$en learningHome = Translations$learningHome$en._(_root);
	late final Translations$exerciseSetup$en exerciseSetup = Translations$exerciseSetup$en._(_root);
	late final Translations$topics$en topics = Translations$topics$en._(_root);
	late final Translations$exercise$en exercise = Translations$exercise$en._(_root);
	late final Translations$loading$en loading = Translations$loading$en._(_root);
	late final Translations$feedback$en feedback = Translations$feedback$en._(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Vitalinguu'
	String get title => 'Vitalinguu';
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Continue'
	String get kContinue => 'Continue';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Back'
	String get back => 'Back';

	/// en: 'Retry'
	String get retry => 'Retry';

	/// en: 'Delete'
	String get delete => 'Delete';
}

// Path: languages
class Translations$languages$en {
	Translations$languages$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'English'
	String get english => 'English';

	/// en: 'Spanish (Mexico)'
	String get spanish => 'Spanish (Mexico)';

	/// en: 'German'
	String get german => 'German';

	/// en: 'Portuguese (Brazil)'
	String get portuguese => 'Portuguese (Brazil)';

	/// en: 'French'
	String get french => 'French';

	/// en: 'Italian'
	String get italian => 'Italian';

	/// en: 'Select a language'
	String get select => 'Select a language';
}

// Path: navigation
class Translations$navigation$en {
	Translations$navigation$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Set up your native language'
	String get nativeLanguageTitle => 'Set up your native language';

	/// en: 'Native language'
	String get nativeLanguageLabel => 'Native language';

	/// en: 'Set up the language you want to learn'
	String get learningLanguageTitle => 'Set up the language you want to learn';

	/// en: 'Learning language'
	String get learningLanguageLabel => 'Learning language';

	/// en: 'Set up your API key'
	String get apiKeyTitle => 'Set up your API key';

	/// en: 'API key'
	String get apiKeyLabel => 'API key';

	/// en: 'Use saved API key'
	String get useSavedApiKey => 'Use saved API key';

	/// en: 'Get an API key from nano-gpt.com'
	String get getApiKeyLink => 'Get an API key from nano-gpt.com';

	/// en: 'The nano-gpt.com API page could not be opened.'
	String get couldNotOpenApiLink => 'The nano-gpt.com API page could not be opened.';

	/// en: 'The API key is invalid.'
	String get invalidApiKey => 'The API key is invalid.';

	/// en: 'The API key could not be validated. Try again.'
	String get unavailableApiKey => 'The API key could not be validated. Try again.';
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Configuration'
	String get configuration => 'Configuration';

	/// en: 'You need more than {amount} USD in credit to use the app.'
	String minimumCredit({required Object amount}) => 'You need more than ${amount} USD in credit to use the app.';

	/// en: 'Voice speed'
	String get voiceSpeed => 'Voice speed';

	/// en: 'Feedback history'
	String get feedbackLookback => 'Feedback history';

	/// en: '{count} days'
	String days({required Object count}) => '${count} days';

	late final Translations$settings$credit$en credit = Translations$settings$credit$en._(_root);
}

// Path: errors
class Translations$errors$en {
	Translations$errors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Set up API key'
	String get configureApiKey => 'Set up API key';

	/// en: 'The service could not be accessed. Check your API key.'
	String get authentication => 'The service could not be accessed. Check your API key.';

	/// en: 'You have reached the usage limit. Check your balance or try again later.'
	String get usageLimit => 'You have reached the usage limit. Check your balance or try again later.';

	/// en: 'The service encountered a temporary problem.'
	String get temporary => 'The service encountered a temporary problem.';

	/// en: 'The request could not be completed.'
	String get request => 'The request could not be completed.';
}

// Path: learningHome
class Translations$learningHome$en {
	Translations$learningHome$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Priority determines which options appear more or less often:'
	String get priorityHelp => 'Priority determines which options appear more or less often:';

	/// en: 'Low'
	String get priorityLow => 'Low';

	/// en: 'Medium'
	String get priorityMedium => 'Medium';

	/// en: 'High'
	String get priorityHigh => 'High';

	/// en: 'Configuration'
	String get configurationTab => 'Configuration';

	/// en: 'Topics'
	String get topicsTab => 'Topics';
}

// Path: exerciseSetup
class Translations$exerciseSetup$en {
	Translations$exerciseSetup$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'CEFR level'
	String get cefrLevel => 'CEFR level';

	/// en: 'Number of exercises'
	String get exerciseCount => 'Number of exercises';

	/// en: 'Prompt content'
	String get promptContent => 'Prompt content';

	/// en: 'Text'
	String get text => 'Text';

	/// en: 'Audio'
	String get audio => 'Audio';

	/// en: 'Exercise types'
	String get exerciseTypes => 'Exercise types';

	/// en: 'Deselect all'
	String get deselectAll => 'Deselect all';

	/// en: 'Select all'
	String get selectAll => 'Select all';

	/// en: 'Available topics'
	String get availableTopics => 'Available topics';

	/// en: 'No topics available'
	String get noAvailableTopics => 'No topics available';

	/// en: 'You need more than {amount} USD in credit to continue.'
	String minimumCredit({required Object amount}) => 'You need more than ${amount} USD in credit to continue.';

	late final Translations$exerciseSetup$types$en types = Translations$exerciseSetup$types$en._(_root);
}

// Path: topics
class Translations$topics$en {
	Translations$topics$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'One topic'
	String get single => 'One topic';

	/// en: 'Multiple topics'
	String get multiple => 'Multiple topics';

	/// en: 'Title'
	String get titleHint => 'Title';

	/// en: 'Content'
	String get contentHint => 'Content';

	/// en: 'For high-quality exercises, use a clear title and describe exactly what you want to practice in the content. Be explicit about the context, vocabulary, grammar, skill, and important details. You can also request a specific technique, format, type of situation, practice for common mistakes, or anything you want reinforced. Avoid descriptions that are too general.'
	String get writingGuide => 'For high-quality exercises, use a clear title and describe exactly what you want to practice in the content. Be explicit about the context, vocabulary, grammar, skill, and important details. You can also request a specific technique, format, type of situation, practice for common mistakes, or anything you want reinforced. Avoid descriptions that are too general.';

	/// en: 'To add multiple topics, type ~ before each title and ^ before its content. The next ~ starts another topic. Do not leave titles or content empty. Example: ~Travel^Airport vocabulary~Food^Phrases for a restaurant'
	String get multipleInstructions => 'To add multiple topics, type ~ before each title and ^ before its content. The next ~ starts another topic. Do not leave titles or content empty.\n\nExample: ~Travel^Airport vocabulary~Food^Phrases for a restaurant';

	/// en: 'The text is invalid. Make sure every topic has a title marked with ~ and content marked with ^, with neither left empty.'
	String get invalidMultiple => 'The text is invalid. Make sure every topic has a title marked with ~ and content marked with ^, with neither left empty.';

	/// en: 'Do you want to delete the selected topics?'
	String get deleteConfirmation => 'Do you want to delete the selected topics?';
}

// Path: exercise
class Translations$exercise$en {
	Translations$exercise$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Correct!'
	String get correctAnswer => 'Correct!';

	/// en: 'Confirm answer'
	String get confirmAnswer => 'Confirm answer';

	/// en: 'Confirm answers'
	String get confirmAnswers => 'Confirm answers';

	/// en: 'Next exercise'
	String get next => 'Next exercise';

	/// en: 'Chat ended abruptly.'
	String get abruptChatFeedback => 'Chat ended abruptly.';

	/// en: 'End the chat?'
	String get endChatTitle => 'End the chat?';

	/// en: 'The chat will end abruptly and be marked as incorrect.'
	String get endChatMessage => 'The chat will end abruptly and be marked as incorrect.';

	/// en: 'Start a new chat?'
	String get newChatTitle => 'Start a new chat?';

	/// en: 'The messages in the current chat will be deleted.'
	String get newChatMessage => 'The messages in the current chat will be deleted.';
}

// Path: loading
class Translations$loading$en {
	Translations$loading$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fetching exercises'
	String get exercises => 'Fetching exercises';

	/// en: 'Fetching feedback'
	String get feedback => 'Fetching feedback';
}

// Path: feedback
class Translations$feedback$en {
	Translations$feedback$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Regenerate exercises'
	String get regenerateExercises => 'Regenerate exercises';

	/// en: 'Back to menu'
	String get backToMenu => 'Back to menu';
}

// Path: settings.credit
class Translations$settings$credit$en {
	Translations$settings$credit$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Refresh credit'
	String get refresh => 'Refresh credit';

	/// en: 'Credit: —'
	String get notStarted => 'Credit: —';

	/// en: 'Checking credit...'
	String get loading => 'Checking credit...';

	/// en: '{amount} USD'
	String available({required Object amount}) => '${amount} USD';

	/// en: 'Credit not authorized'
	String get unauthorized => 'Credit not authorized';

	/// en: 'Credit unavailable'
	String get unavailable => 'Credit unavailable';
}

// Path: exerciseSetup.types
class Translations$exerciseSetup$types$en {
	Translations$exerciseSetup$types$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Dialogue'
	String get dialog => 'Dialogue';

	/// en: 'Fill in the blanks'
	String get fillTheBlank => 'Fill in the blanks';

	/// en: 'Match elements'
	String get matchElements => 'Match elements';

	/// en: 'Multiple choice'
	String get multipleChoice => 'Multiple choice';

	/// en: 'Multiple-choice list'
	String get multipleChoiceList => 'Multiple-choice list';

	/// en: 'Select all that apply'
	String get selectAllThatApply => 'Select all that apply';

	/// en: 'Word ordering'
	String get wordOrdering => 'Word ordering';

	/// en: 'Write'
	String get write => 'Write';

	/// en: 'Write a list'
	String get writeList => 'Write a list';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Continue',
			'common.confirm' => 'Confirm',
			'common.cancel' => 'Cancel',
			'common.back' => 'Back',
			'common.retry' => 'Retry',
			'common.delete' => 'Delete',
			'languages.english' => 'English',
			'languages.spanish' => 'Spanish (Mexico)',
			'languages.german' => 'German',
			'languages.portuguese' => 'Portuguese (Brazil)',
			'languages.french' => 'French',
			'languages.italian' => 'Italian',
			'languages.select' => 'Select a language',
			'navigation.home' => 'Home',
			'navigation.settings' => 'Settings',
			'onboarding.nativeLanguageTitle' => 'Set up your native language',
			'onboarding.nativeLanguageLabel' => 'Native language',
			'onboarding.learningLanguageTitle' => 'Set up the language you want to learn',
			'onboarding.learningLanguageLabel' => 'Learning language',
			'onboarding.apiKeyTitle' => 'Set up your API key',
			'onboarding.apiKeyLabel' => 'API key',
			'onboarding.useSavedApiKey' => 'Use saved API key',
			'onboarding.getApiKeyLink' => 'Get an API key from nano-gpt.com',
			'onboarding.couldNotOpenApiLink' => 'The nano-gpt.com API page could not be opened.',
			'onboarding.invalidApiKey' => 'The API key is invalid.',
			'onboarding.unavailableApiKey' => 'The API key could not be validated. Try again.',
			'settings.title' => 'Settings',
			'settings.configuration' => 'Configuration',
			'settings.minimumCredit' => ({required Object amount}) => 'You need more than ${amount} USD in credit to use the app.',
			'settings.voiceSpeed' => 'Voice speed',
			'settings.feedbackLookback' => 'Feedback history',
			'settings.days' => ({required Object count}) => '${count} days',
			'settings.credit.refresh' => 'Refresh credit',
			'settings.credit.notStarted' => 'Credit: —',
			'settings.credit.loading' => 'Checking credit...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Credit not authorized',
			'settings.credit.unavailable' => 'Credit unavailable',
			'errors.configureApiKey' => 'Set up API key',
			'errors.authentication' => 'The service could not be accessed. Check your API key.',
			'errors.usageLimit' => 'You have reached the usage limit. Check your balance or try again later.',
			'errors.temporary' => 'The service encountered a temporary problem.',
			'errors.request' => 'The request could not be completed.',
			'learningHome.priorityHelp' => 'Priority determines which options appear more or less often:',
			'learningHome.priorityLow' => 'Low',
			'learningHome.priorityMedium' => 'Medium',
			'learningHome.priorityHigh' => 'High',
			'learningHome.configurationTab' => 'Configuration',
			'learningHome.topicsTab' => 'Topics',
			'exerciseSetup.cefrLevel' => 'CEFR level',
			'exerciseSetup.exerciseCount' => 'Number of exercises',
			'exerciseSetup.promptContent' => 'Prompt content',
			'exerciseSetup.text' => 'Text',
			'exerciseSetup.audio' => 'Audio',
			'exerciseSetup.exerciseTypes' => 'Exercise types',
			'exerciseSetup.deselectAll' => 'Deselect all',
			'exerciseSetup.selectAll' => 'Select all',
			'exerciseSetup.availableTopics' => 'Available topics',
			'exerciseSetup.noAvailableTopics' => 'No topics available',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'You need more than ${amount} USD in credit to continue.',
			'exerciseSetup.types.dialog' => 'Dialogue',
			'exerciseSetup.types.fillTheBlank' => 'Fill in the blanks',
			'exerciseSetup.types.matchElements' => 'Match elements',
			'exerciseSetup.types.multipleChoice' => 'Multiple choice',
			'exerciseSetup.types.multipleChoiceList' => 'Multiple-choice list',
			'exerciseSetup.types.selectAllThatApply' => 'Select all that apply',
			'exerciseSetup.types.wordOrdering' => 'Word ordering',
			'exerciseSetup.types.write' => 'Write',
			'exerciseSetup.types.writeList' => 'Write a list',
			'topics.single' => 'One topic',
			'topics.multiple' => 'Multiple topics',
			'topics.titleHint' => 'Title',
			'topics.contentHint' => 'Content',
			'topics.writingGuide' => 'For high-quality exercises, use a clear title and describe exactly what you want to practice in the content. Be explicit about the context, vocabulary, grammar, skill, and important details. You can also request a specific technique, format, type of situation, practice for common mistakes, or anything you want reinforced. Avoid descriptions that are too general.',
			'topics.multipleInstructions' => 'To add multiple topics, type ~ before each title and ^ before its content. The next ~ starts another topic. Do not leave titles or content empty.\n\nExample: ~Travel^Airport vocabulary~Food^Phrases for a restaurant',
			'topics.invalidMultiple' => 'The text is invalid. Make sure every topic has a title marked with ~ and content marked with ^, with neither left empty.',
			'topics.deleteConfirmation' => 'Do you want to delete the selected topics?',
			'exercise.correctAnswer' => 'Correct!',
			'exercise.confirmAnswer' => 'Confirm answer',
			'exercise.confirmAnswers' => 'Confirm answers',
			'exercise.next' => 'Next exercise',
			'exercise.abruptChatFeedback' => 'Chat ended abruptly.',
			'exercise.endChatTitle' => 'End the chat?',
			'exercise.endChatMessage' => 'The chat will end abruptly and be marked as incorrect.',
			'exercise.newChatTitle' => 'Start a new chat?',
			'exercise.newChatMessage' => 'The messages in the current chat will be deleted.',
			'loading.exercises' => 'Fetching exercises',
			'loading.feedback' => 'Fetching feedback',
			'feedback.regenerateExercises' => 'Regenerate exercises',
			'feedback.backToMenu' => 'Back to menu',
			_ => null,
		};
	}
}
