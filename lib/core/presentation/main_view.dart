import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/domain/main_view_model.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  late final MainViewModel _viewModel;
  final _isInitialized = signal(false);

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<MainViewModel>();
    unawaited(_initialize());
  }

  Future<void> _initialize() async {
    await _viewModel.init();

    if (!mounted) return;
    _isInitialized.value = true;
  }

  @override
  void dispose() {
    _isInitialized.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SignalBuilder(
      builder: (context) {
        if (!_isInitialized.value) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AutoTabsRouter(
          routes: const [LearningHomeRoute(), SettingsRoute()],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);

            return Scaffold(
              body: child,
              bottomNavigationBar: NavigationBar(
                selectedIndex: tabsRouter.activeIndex,
                onDestinationSelected: tabsRouter.setActiveIndex,
                destinations: [
                  NavigationDestination(
                    icon: const Icon(Icons.home),
                    label: context.t.navigation.home,
                  ),
                  NavigationDestination(
                    icon: const Icon(Icons.settings),
                    label: context.t.navigation.settings,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
