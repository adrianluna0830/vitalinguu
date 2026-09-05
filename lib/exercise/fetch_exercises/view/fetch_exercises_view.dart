import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/presentation/ai_error_stream_listener_mixin.dart';
import 'package:vitalinguu/core/presentation/animated_count_progress_bar.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/exercise/fetch_exercises/domain/fetch_exercises_view_model.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class FetchExercisesView extends StatefulWidget {
  const FetchExercisesView({super.key});

  @override
  State<FetchExercisesView> createState() => _FetchExercisesViewState();
}

class _FetchExercisesViewState extends State<FetchExercisesView>
    with AIErrorStreamListenerMixin<FetchExercisesView> {
  late final FetchExercisesViewModel _viewModel;
  late final StreamSubscription<void> _exercisesFetchedSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FetchExercisesViewModel>();
    _exercisesFetchedSubscription = _viewModel.exercisesFetched.listen((_) {
      if (mounted) unawaited(context.router.replace(const ExerciseRoute()));
    });
    listenToAIErrorStream(
      errorHandler: _viewModel,
      onLeave: () => context.router.push(const MainRoute()),
    );
    unawaited(_viewModel.fetchExercises());
  }

  @override
  void dispose() {
    unawaited(_exercisesFetchedSubscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.t.loading.exercises),
                const SizedBox(height: 12),
                SignalBuilder(
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: AnimatedCountProgressBar(
                      totalCount: _viewModel.exerciseCount,
                      currentCount: _viewModel.exerciseFetchCount.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
