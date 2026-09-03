import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';
import 'package:vitalinguu/i18n/strings.g.dart';

@RoutePage()
class LearningHomeView extends StatelessWidget {
  const LearningHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter.tabBar(
      routes: const [ExerciseSetupRoute(), ExerciseTopicsRoute()],
      builder: (context, child, tabController) => Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: context.t.learningHome.configurationTab),
              Tab(text: context.t.learningHome.topicsTab),
            ],
          ),
        ),
        body: child,
      ),
    );
  }
}
