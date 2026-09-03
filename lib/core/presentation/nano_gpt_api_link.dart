import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

class NanoGptApiLink extends StatelessWidget {
  const NanoGptApiLink({super.key});

  static final Uri _apiUri = Uri.parse('https://nano-gpt.com/api');

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _openApiPage(context),
      icon: const Icon(Icons.open_in_new, size: 18),
      label: Text(context.t.onboarding.getApiKeyLink),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        textStyle: const TextStyle(decoration: TextDecoration.underline),
      ),
    );
  }

  Future<void> _openApiPage(BuildContext context) async {
    try {
      if (await launchUrl(_apiUri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } catch (_) {
      // The same user-facing message covers platform launch failures.
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t.onboarding.couldNotOpenApiLink)),
      );
    }
  }
}
