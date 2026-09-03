import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitalinguu/core/presentation/app_router.gr.dart';

Route<T> _buildRouteWithoutSystemBack<T>(
  BuildContext context,
  Widget child,
  AutoRoutePage<T> page,
) {
  return MaterialPageRoute<T>(
    settings: page,
    fullscreenDialog: page.fullscreenDialog,
    maintainState: page.maintainState,
    allowSnapshotting: page.allowSnapshotting,
    builder: (_) => PopScope<T>(canPop: false, child: child),
  );
}

@AutoRouterConfig(replaceInRouteName: 'View,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType =>
      RouteType.custom(customRouteBuilder: _buildRouteWithoutSystemBack);

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: ApiKeyRegistrationRoute.page),
    AutoRoute(page: NativeLanguageSetupRoute.page),
    AutoRoute(page: LearningLanguageSetupRoute.page),
    AutoRoute(
      page: MainRoute.page,
      children: [
        AutoRoute(
          page: LearningHomeRoute.page,
          initial: true,
          children: [
            AutoRoute(page: ExerciseSetupRoute.page, initial: true),
            AutoRoute(page: ExerciseTopicsRoute.page),
          ],
        ),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: FetchExercisesRoute.page),
    AutoRoute(page: FetchTopicsFeedbackRoute.page),
    AutoRoute(page: ExerciseRoute.page),
    AutoRoute(page: TopicsFeedbackRoute.page),
  ];
}

final appRouter = AppRouter();
