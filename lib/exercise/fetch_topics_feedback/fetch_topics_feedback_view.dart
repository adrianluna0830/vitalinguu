import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/core/presentation/ai_error_stream_listener_mixin.dart';
import 'package:vitalinguu/core/presentation/animated_count_progress_bar.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/exercise/fetch_topics_feedback/fetch_topics_feedback_view_model.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class FetchTopicsFeedbackView extends StatefulWidget {
  const FetchTopicsFeedbackView({super.key});

  @override
  State<FetchTopicsFeedbackView> createState() =>
      _FetchTopicsFeedbackViewState();
}

class _FetchTopicsFeedbackViewState extends State<FetchTopicsFeedbackView>
    with AIErrorStreamListenerMixin<FetchTopicsFeedbackView> {
  late final FetchTopicsFeedbackViewModel _viewModel;
  late final StreamSubscription<void> _feedbackFetchedSubscription;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<FetchTopicsFeedbackViewModel>();
    _feedbackFetchedSubscription = _viewModel.feedbackFetched.listen((_) {
      if (mounted) {
        unawaited(context.router.push(const TopicsFeedbackRoute()));
      }
    });
    listenToAIErrorStream(
      errorHandler: _viewModel,
      onLeave: () => context.router.push(const MainRoute()),
    );
    unawaited(_viewModel.fetchFeedback());
  }

  @override
  void dispose() {
    unawaited(_feedbackFetchedSubscription.cancel());
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
                Text(context.t.loading.feedback),
                const SizedBox(height: 12),
                SignalBuilder(
                  builder: (context) => SizedBox(
                    width: double.infinity,
                    child: AnimatedCountProgressBar(
                      totalCount: _viewModel.feedbackCount,
                      currentCount: _viewModel.feedbackFetchCount.value,
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
