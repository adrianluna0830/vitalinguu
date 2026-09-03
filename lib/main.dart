import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:signals/signals.dart';
import 'package:vitalinguu/core/domain/reset_persisted_app_data.dart';
import 'package:vitalinguu/core/presentation/app_router.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/i18n/app_locale.dart';
import 'package:vitalinguu/i18n/strings.g.dart';
import 'package:vitalinguu/settings/domain/settings_service.dart';

Future<void> main() async {
  SignalsObserver.instance = null;

  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.initialize();

  // resetPersistedAppData();

  final nativeLanguage = getIt<SettingsService>().nativeLanguage.value;
  if (nativeLanguage == null) {
    await LocaleSettings.useDeviceLocale();
  } else {
    await LocaleSettings.setLocale(nativeLanguage.appLocale);
  }

  runApp(TranslationProvider(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: context.t.app.title,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      routerConfig: appRouter.config(),
    );
  }
}
