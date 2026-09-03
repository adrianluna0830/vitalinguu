abstract final class TranslationKeys {
  static const task = 'task';
  static const content = 'content';

  static String option(int index) => 'option:$index';

  static String listPrompt(int index) => 'prompt:$index';

  static String listOption(int itemIndex, int optionIndex) =>
      'item:$itemIndex:option:$optionIndex';

  static String matchLeft(int index) => 'match:$index:left';

  static String matchRight(int index) => 'match:$index:right';

  static String fragment(int index) => 'fragment:$index';

  static String dialogMessage(int index) => 'dialog:$index';
}
