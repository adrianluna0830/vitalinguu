import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/splash/view_models/splash_view_model.dart';

@RoutePage()
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  late final SplashViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<SplashViewModel>();
    unawaited(_openNextView());
  }

  Future<void> _openNextView() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;

    if (_viewModel.isNativeLanguageNull()) {
      await context.router.push(NativeLanguageSetupRoute());
      if (!mounted) return;
    }

    if (_viewModel.isLearningLanguageNull()) {
      await context.router.push(LearningLanguageSetupRoute());
      if (!mounted) return;
    }

    if (_viewModel.isApiKeyNull()) {
      await context.router.push(const ApiKeyRegistrationRoute());
      if (!mounted) return;
    }

    await context.router.replaceAll([const MainRoute()]);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: Center(child: Icon(Icons.language))),
    );
  }
}
