import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/presentation/language_locale_display_name.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class LanguageLocaleDropdown extends StatelessWidget {
  const LanguageLocaleDropdown({
    required this.value,
    required this.onChanged,
    this.label,
    super.key,
  });

  final LanguageLocale? value;
  final ValueChanged<LanguageLocale> onChanged;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<LanguageLocale>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
      isExpanded: true,
      initialValue: value,
      hint: Text(context.t.languages.select),
      items: [
        for (final language in LanguageLocale.values)
          DropdownMenuItem(
            value: language,
            child: Text(languageLocaleDisplayName(language, context.t)),
          ),
      ],
      onChanged: (language) {
        if (language != null) onChanged(language);
      },
    );
  }
}
