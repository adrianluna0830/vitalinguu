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
class TranslationsPtBr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsPtBr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ptBr,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <pt-BR>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsPtBr _root = this; // ignore: unused_field

	@override
	TranslationsPtBr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsPtBr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$pt_BR app = _Translations$app$pt_BR._(_root);
	@override late final _Translations$common$pt_BR common = _Translations$common$pt_BR._(_root);
	@override late final _Translations$languages$pt_BR languages = _Translations$languages$pt_BR._(_root);
	@override late final _Translations$navigation$pt_BR navigation = _Translations$navigation$pt_BR._(_root);
	@override late final _Translations$onboarding$pt_BR onboarding = _Translations$onboarding$pt_BR._(_root);
	@override late final _Translations$settings$pt_BR settings = _Translations$settings$pt_BR._(_root);
	@override late final _Translations$errors$pt_BR errors = _Translations$errors$pt_BR._(_root);
	@override late final _Translations$learningHome$pt_BR learningHome = _Translations$learningHome$pt_BR._(_root);
	@override late final _Translations$exerciseSetup$pt_BR exerciseSetup = _Translations$exerciseSetup$pt_BR._(_root);
	@override late final _Translations$topics$pt_BR topics = _Translations$topics$pt_BR._(_root);
	@override late final _Translations$exercise$pt_BR exercise = _Translations$exercise$pt_BR._(_root);
	@override late final _Translations$loading$pt_BR loading = _Translations$loading$pt_BR._(_root);
	@override late final _Translations$feedback$pt_BR feedback = _Translations$feedback$pt_BR._(_root);
}

// Path: app
class _Translations$app$pt_BR implements Translations$app$en {
	_Translations$app$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Vitalinguu';
}

// Path: common
class _Translations$common$pt_BR implements Translations$common$en {
	_Translations$common$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get kContinue => 'Continuar';
	@override String get confirm => 'Confirmar';
	@override String get cancel => 'Cancelar';
	@override String get back => 'Voltar';
	@override String get retry => 'Tentar novamente';
	@override String get delete => 'Excluir';
}

// Path: languages
class _Translations$languages$pt_BR implements Translations$languages$en {
	_Translations$languages$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get english => 'Inglês';
	@override String get spanish => 'Espanhol (México)';
	@override String get german => 'Alemão';
	@override String get portuguese => 'Português (Brasil)';
	@override String get french => 'Francês';
	@override String get italian => 'Italiano';
	@override String get select => 'Selecione um idioma';
}

// Path: navigation
class _Translations$navigation$pt_BR implements Translations$navigation$en {
	_Translations$navigation$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get home => 'Início';
	@override String get settings => 'Configurações';
}

// Path: onboarding
class _Translations$onboarding$pt_BR implements Translations$onboarding$en {
	_Translations$onboarding$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get nativeLanguageTitle => 'Configure seu idioma nativo';
	@override String get nativeLanguageLabel => 'Idioma nativo';
	@override String get learningLanguageTitle => 'Configure o idioma que deseja aprender';
	@override String get learningLanguageLabel => 'Idioma de aprendizagem';
	@override String get apiKeyTitle => 'Configure sua chave de API';
	@override String get apiKeyLabel => 'Chave de API';
	@override String get useSavedApiKey => 'Usar chave de API salva';
	@override String get getApiKeyLink => 'Obter uma chave de API em nano-gpt.com';
	@override String get couldNotOpenApiLink => 'Não foi possível abrir a página da API do nano-gpt.com.';
	@override String get invalidApiKey => 'A chave de API não é válida.';
	@override String get unavailableApiKey => 'Não foi possível validar a chave de API. Tente novamente.';
}

// Path: settings
class _Translations$settings$pt_BR implements Translations$settings$en {
	_Translations$settings$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get title => 'Configurações';
	@override String get configuration => 'Configuração';
	@override String minimumCredit({required Object amount}) => 'Você precisa ter mais de ${amount} USD em créditos para usar o aplicativo.';
	@override String get voiceSpeed => 'Velocidade da voz';
	@override String get feedbackLookback => 'Feedback considerado';
	@override String days({required Object count}) => '${count} dias';
	@override late final _Translations$settings$credit$pt_BR credit = _Translations$settings$credit$pt_BR._(_root);
}

// Path: errors
class _Translations$errors$pt_BR implements Translations$errors$en {
	_Translations$errors$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get configureApiKey => 'Configurar chave de API';
	@override String get authentication => 'Não foi possível acessar o serviço. Verifique sua chave de API.';
	@override String get usageLimit => 'Você atingiu o limite de uso. Verifique seu saldo ou tente novamente mais tarde.';
	@override String get temporary => 'O serviço apresentou um problema temporário.';
	@override String get request => 'Não foi possível concluir a solicitação.';
}

// Path: learningHome
class _Translations$learningHome$pt_BR implements Translations$learningHome$en {
	_Translations$learningHome$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get priorityHelp => 'A prioridade determina quais opções aparecerão com maior ou menor frequência:';
	@override String get priorityLow => 'Baixa';
	@override String get priorityMedium => 'Média';
	@override String get priorityHigh => 'Alta';
	@override String get configurationTab => 'Configuração';
	@override String get topicsTab => 'Tópicos';
}

// Path: exerciseSetup
class _Translations$exerciseSetup$pt_BR implements Translations$exerciseSetup$en {
	_Translations$exerciseSetup$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get cefrLevel => 'Nível CEFR';
	@override String get exerciseCount => 'Número de exercícios';
	@override String get promptContent => 'Conteúdo do enunciado';
	@override String get text => 'Texto';
	@override String get audio => 'Áudio';
	@override String get exerciseTypes => 'Tipos de exercício';
	@override String get deselectAll => 'Desmarcar todos';
	@override String get selectAll => 'Selecionar todos';
	@override String get availableTopics => 'Tópicos disponíveis';
	@override String get noAvailableTopics => 'Não há tópicos disponíveis';
	@override String minimumCredit({required Object amount}) => 'Você precisa ter mais de ${amount} USD em créditos para continuar.';
	@override String get unauthorizedCredit => 'Não é possível continuar porque não foi possível autorizar seu crédito. Verifique sua chave de API nas configurações.';
	@override late final _Translations$exerciseSetup$types$pt_BR types = _Translations$exerciseSetup$types$pt_BR._(_root);
}

// Path: topics
class _Translations$topics$pt_BR implements Translations$topics$en {
	_Translations$topics$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get single => 'Um tópico';
	@override String get multiple => 'Vários tópicos';
	@override String get titleHint => 'Título';
	@override String get contentHint => 'Conteúdo';
	@override String get writingGuide => 'Para obter exercícios de qualidade, use um título claro e descreva exatamente no conteúdo o que deseja praticar. Seja explícito sobre o contexto, vocabulário, gramática, habilidade e detalhes importantes. Você também pode pedir uma técnica, formato, tipo de situação, prática de erros comuns ou qualquer aspecto que queira reforçar. Evite descrições muito genéricas.';
	@override String get multipleInstructions => 'Para adicionar vários tópicos, escreva ~ antes de cada título e ^ antes do conteúdo. O próximo ~ inicia outro tópico. Não deixe títulos nem conteúdos vazios.\n\nExemplo: ~Viagens^Vocabulário para o aeroporto~Comida^Frases para um restaurante';
	@override String get invalidMultiple => 'O texto não é válido. Verifique se cada tópico tem um título marcado com ~ e um conteúdo marcado com ^, sem deixá-los vazios.';
	@override String get deleteConfirmation => 'Deseja excluir os tópicos selecionados?';
}

// Path: exercise
class _Translations$exercise$pt_BR implements Translations$exercise$en {
	_Translations$exercise$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get correctAnswer => 'Resposta correta!';
	@override String get confirmAnswer => 'Confirmar resposta';
	@override String get confirmAnswers => 'Confirmar respostas';
	@override String get next => 'Próximo exercício';
	@override String get abruptChatFeedback => 'O chat foi encerrado abruptamente.';
	@override String get endChatTitle => 'Encerrar o chat?';
	@override String get endChatMessage => 'O chat será encerrado abruptamente e marcado como incorreto.';
	@override String get newChatTitle => 'Iniciar um novo chat?';
	@override String get newChatMessage => 'As mensagens do chat atual serão excluídas.';
}

// Path: loading
class _Translations$loading$pt_BR implements Translations$loading$en {
	_Translations$loading$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get exercises => 'Obtendo exercícios';
	@override String get feedback => 'Obtendo feedback';
}

// Path: feedback
class _Translations$feedback$pt_BR implements Translations$feedback$en {
	_Translations$feedback$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get regenerateExercises => 'Gerar exercícios novamente';
	@override String get backToMenu => 'Voltar ao menu';
}

// Path: settings.credit
class _Translations$settings$credit$pt_BR implements Translations$settings$credit$en {
	_Translations$settings$credit$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get refresh => 'Atualizar crédito';
	@override String get notStarted => 'Crédito: —';
	@override String get loading => 'Consultando crédito...';
	@override String available({required Object amount}) => '${amount} USD';
	@override String get unauthorized => 'Crédito não autorizado';
	@override String get unavailable => 'Crédito indisponível';
}

// Path: exerciseSetup.types
class _Translations$exerciseSetup$types$pt_BR implements Translations$exerciseSetup$types$en {
	_Translations$exerciseSetup$types$pt_BR._(this._root);

	final TranslationsPtBr _root; // ignore: unused_field

	// Translations
	@override String get dialog => 'Diálogo';
	@override String get fillTheBlank => 'Preencher lacunas';
	@override String get matchElements => 'Relacionar elementos';
	@override String get multipleChoice => 'Múltipla escolha';
	@override String get multipleChoiceList => 'Lista de múltipla escolha';
	@override String get selectAllThatApply => 'Selecionar todas as opções corretas';
	@override String get wordOrdering => 'Ordenar palavras';
	@override String get write => 'Escrever';
	@override String get writeList => 'Escrever uma lista';
}

/// The flat map containing all translations for locale <pt-BR>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsPtBr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.title' => 'Vitalinguu',
			'common.kContinue' => 'Continuar',
			'common.confirm' => 'Confirmar',
			'common.cancel' => 'Cancelar',
			'common.back' => 'Voltar',
			'common.retry' => 'Tentar novamente',
			'common.delete' => 'Excluir',
			'languages.english' => 'Inglês',
			'languages.spanish' => 'Espanhol (México)',
			'languages.german' => 'Alemão',
			'languages.portuguese' => 'Português (Brasil)',
			'languages.french' => 'Francês',
			'languages.italian' => 'Italiano',
			'languages.select' => 'Selecione um idioma',
			'navigation.home' => 'Início',
			'navigation.settings' => 'Configurações',
			'onboarding.nativeLanguageTitle' => 'Configure seu idioma nativo',
			'onboarding.nativeLanguageLabel' => 'Idioma nativo',
			'onboarding.learningLanguageTitle' => 'Configure o idioma que deseja aprender',
			'onboarding.learningLanguageLabel' => 'Idioma de aprendizagem',
			'onboarding.apiKeyTitle' => 'Configure sua chave de API',
			'onboarding.apiKeyLabel' => 'Chave de API',
			'onboarding.useSavedApiKey' => 'Usar chave de API salva',
			'onboarding.getApiKeyLink' => 'Obter uma chave de API em nano-gpt.com',
			'onboarding.couldNotOpenApiLink' => 'Não foi possível abrir a página da API do nano-gpt.com.',
			'onboarding.invalidApiKey' => 'A chave de API não é válida.',
			'onboarding.unavailableApiKey' => 'Não foi possível validar a chave de API. Tente novamente.',
			'settings.title' => 'Configurações',
			'settings.configuration' => 'Configuração',
			'settings.minimumCredit' => ({required Object amount}) => 'Você precisa ter mais de ${amount} USD em créditos para usar o aplicativo.',
			'settings.voiceSpeed' => 'Velocidade da voz',
			'settings.feedbackLookback' => 'Feedback considerado',
			'settings.days' => ({required Object count}) => '${count} dias',
			'settings.credit.refresh' => 'Atualizar crédito',
			'settings.credit.notStarted' => 'Crédito: —',
			'settings.credit.loading' => 'Consultando crédito...',
			'settings.credit.available' => ({required Object amount}) => '${amount} USD',
			'settings.credit.unauthorized' => 'Crédito não autorizado',
			'settings.credit.unavailable' => 'Crédito indisponível',
			'errors.configureApiKey' => 'Configurar chave de API',
			'errors.authentication' => 'Não foi possível acessar o serviço. Verifique sua chave de API.',
			'errors.usageLimit' => 'Você atingiu o limite de uso. Verifique seu saldo ou tente novamente mais tarde.',
			'errors.temporary' => 'O serviço apresentou um problema temporário.',
			'errors.request' => 'Não foi possível concluir a solicitação.',
			'learningHome.priorityHelp' => 'A prioridade determina quais opções aparecerão com maior ou menor frequência:',
			'learningHome.priorityLow' => 'Baixa',
			'learningHome.priorityMedium' => 'Média',
			'learningHome.priorityHigh' => 'Alta',
			'learningHome.configurationTab' => 'Configuração',
			'learningHome.topicsTab' => 'Tópicos',
			'exerciseSetup.cefrLevel' => 'Nível CEFR',
			'exerciseSetup.exerciseCount' => 'Número de exercícios',
			'exerciseSetup.promptContent' => 'Conteúdo do enunciado',
			'exerciseSetup.text' => 'Texto',
			'exerciseSetup.audio' => 'Áudio',
			'exerciseSetup.exerciseTypes' => 'Tipos de exercício',
			'exerciseSetup.deselectAll' => 'Desmarcar todos',
			'exerciseSetup.selectAll' => 'Selecionar todos',
			'exerciseSetup.availableTopics' => 'Tópicos disponíveis',
			'exerciseSetup.noAvailableTopics' => 'Não há tópicos disponíveis',
			'exerciseSetup.minimumCredit' => ({required Object amount}) => 'Você precisa ter mais de ${amount} USD em créditos para continuar.',
			'exerciseSetup.unauthorizedCredit' => 'Não é possível continuar porque não foi possível autorizar seu crédito. Verifique sua chave de API nas configurações.',
			'exerciseSetup.types.dialog' => 'Diálogo',
			'exerciseSetup.types.fillTheBlank' => 'Preencher lacunas',
			'exerciseSetup.types.matchElements' => 'Relacionar elementos',
			'exerciseSetup.types.multipleChoice' => 'Múltipla escolha',
			'exerciseSetup.types.multipleChoiceList' => 'Lista de múltipla escolha',
			'exerciseSetup.types.selectAllThatApply' => 'Selecionar todas as opções corretas',
			'exerciseSetup.types.wordOrdering' => 'Ordenar palavras',
			'exerciseSetup.types.write' => 'Escrever',
			'exerciseSetup.types.writeList' => 'Escrever uma lista',
			'topics.single' => 'Um tópico',
			'topics.multiple' => 'Vários tópicos',
			'topics.titleHint' => 'Título',
			'topics.contentHint' => 'Conteúdo',
			'topics.writingGuide' => 'Para obter exercícios de qualidade, use um título claro e descreva exatamente no conteúdo o que deseja praticar. Seja explícito sobre o contexto, vocabulário, gramática, habilidade e detalhes importantes. Você também pode pedir uma técnica, formato, tipo de situação, prática de erros comuns ou qualquer aspecto que queira reforçar. Evite descrições muito genéricas.',
			'topics.multipleInstructions' => 'Para adicionar vários tópicos, escreva ~ antes de cada título e ^ antes do conteúdo. O próximo ~ inicia outro tópico. Não deixe títulos nem conteúdos vazios.\n\nExemplo: ~Viagens^Vocabulário para o aeroporto~Comida^Frases para um restaurante',
			'topics.invalidMultiple' => 'O texto não é válido. Verifique se cada tópico tem um título marcado com ~ e um conteúdo marcado com ^, sem deixá-los vazios.',
			'topics.deleteConfirmation' => 'Deseja excluir os tópicos selecionados?',
			'exercise.correctAnswer' => 'Resposta correta!',
			'exercise.confirmAnswer' => 'Confirmar resposta',
			'exercise.confirmAnswers' => 'Confirmar respostas',
			'exercise.next' => 'Próximo exercício',
			'exercise.abruptChatFeedback' => 'O chat foi encerrado abruptamente.',
			'exercise.endChatTitle' => 'Encerrar o chat?',
			'exercise.endChatMessage' => 'O chat será encerrado abruptamente e marcado como incorreto.',
			'exercise.newChatTitle' => 'Iniciar um novo chat?',
			'exercise.newChatMessage' => 'As mensagens do chat atual serão excluídas.',
			'loading.exercises' => 'Obtendo exercícios',
			'loading.feedback' => 'Obtendo feedback',
			'feedback.regenerateExercises' => 'Gerar exercícios novamente',
			'feedback.backToMenu' => 'Voltar ao menu',
			_ => null,
		};
	}
}
