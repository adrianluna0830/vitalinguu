import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/exercise/fetch_exercises/domain/fetch_exercises_view_model.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class TopicsFeedbackView extends StatelessWidget {
  const TopicsFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {
                            context.router.popUntilRouteWithName(
                              FetchExercisesRoute.name,
                            );
                            unawaited(
                              getIt<FetchExercisesViewModel>().fetchExercises(),
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text(context.t.feedback.regenerateExercises),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.router.replaceAll([const MainRoute()]),
                          icon: const Icon(Icons.home_outlined),
                          label: Text(context.t.feedback.backToMenu),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
