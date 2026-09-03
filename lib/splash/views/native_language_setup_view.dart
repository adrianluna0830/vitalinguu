import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/models/language_locale.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/splash/view_models/native_language_setup_view_model.dart';
import 'package:vitalinguu/settings/presentation/widgets/language_locale_dropdown.dart';
import 'package:vitalinguu/i18n/app_locale.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class NativeLanguageSetupView extends StatefulWidget {
  const NativeLanguageSetupView({super.key});

  @override
  State<NativeLanguageSetupView> createState() =>
      _NativeLanguageSetupViewState();
}

class _NativeLanguageSetupViewState extends State<NativeLanguageSetupView> {
  late final NativeLanguageSetupViewModel _viewModel;
  LanguageLocale? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<NativeLanguageSetupViewModel>();
    _selectedLanguage = LocaleSettings.currentLocale.languageLocale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.onboarding.nativeLanguageTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    LanguageLocaleDropdown(
                      label: context.t.onboarding.nativeLanguageLabel,
                      value: _selectedLanguage,
                      onChanged: (language) {
                        setState(() => _selectedLanguage = language);
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        onPressed: _selectedLanguage == null
                            ? null
                            : () async {
                                await _viewModel.updateNativeLanguage(
                                  _selectedLanguage!,
                                );
                                if (context.mounted) context.router.pop();
                              },
                        child: Text(context.t.common.kContinue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
