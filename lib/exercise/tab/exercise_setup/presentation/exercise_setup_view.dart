import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/domain/exercise_setup_view_model.dart';
import 'package:vitalinguu/exercise/tab/exercise_setup/presentation/exercise_configuration_widget.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class ExerciseSetupView extends StatefulWidget {
  const ExerciseSetupView({super.key});

  @override
  State<ExerciseSetupView> createState() => _ExerciseSetupViewState();
}

class _ExerciseSetupViewState extends State<ExerciseSetupView> {
  late final ExerciseSetupViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ExerciseSetupViewModel>();
  }

  @override
  void dispose() {
    unawaited(_viewModel.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SignalBuilder(
            builder: (context) => SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.t.learningHome.priorityHelp,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.arrow_downward, size: 16),
                        Text(' ${context.t.learningHome.priorityLow}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.remove, size: 16),
                        Text(' ${context.t.learningHome.priorityMedium}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.arrow_upward, size: 16),
                        Text(' ${context.t.learningHome.priorityHigh}'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ExerciseConfigurationWidget(
                      topics: _viewModel.topics.value,
                      creditBalanceState: _viewModel.creditBalanceState.value,
                      onChanged: (configuration) async {
                        await _viewModel.registerFetchExercisesViewModel(
                          configuration,
                        );

                        if (context.mounted) {
                          await context.router.root.push(
                            const FetchExercisesRoute(),
                          );
                        }

                        // await _viewModel.registerHardcodedExerciseViewModel(
                        //   configuration,
                        // );

                        // if (context.mounted) {
                        //   await context.router.root.push(
                        //     const ExerciseRoute(),
                        //   );
                        // }
                      },
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
