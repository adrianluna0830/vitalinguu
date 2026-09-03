import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:vitalinguu/exercise/tab/topics/domain/exercise_topics_view_model.dart';
import 'package:vitalinguu/core/domain/session_manager.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/add_topics_switcher_widget.dart';
import 'package:vitalinguu/exercise/tab/topics/presentation/topics_list_widget.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class ExerciseTopicsView extends StatefulWidget {
  const ExerciseTopicsView({super.key});

  @override
  State<ExerciseTopicsView> createState() => _ExerciseTopicsViewState();
}

class _ExerciseTopicsViewState extends State<ExerciseTopicsView> {
  late final ExerciseTopicsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = getIt<ExerciseTopicsViewModel>();
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 8),
                    Expanded(child: Text(context.t.topics.writingGuide)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              AddTopicsSwitcherWidget(
                onTopicChanged: (topic) =>
                    unawaited(_viewModel.addTopic(topic)),
                onTopicsChanged: (topics) =>
                    unawaited(_viewModel.addTopics(topics)),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SignalBuilder(
                  builder: (context) => TopicsListWidget(
                    topics: _viewModel.topics.value,
                    onChanged: (topicId, topic) =>
                        unawaited(_viewModel.updateTopic(topicId, topic)),
                    onDelete: (topicIds) =>
                        unawaited(_viewModel.deleteTopics(topicIds)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
