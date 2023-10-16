import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/widget/widget.dart';

abstract class PageName {
  static const String slaughterhouse = 'slaughterhouse';
  static const String orders = 'orders';
}

abstract class PagePath {
  static const String slaughterhouse = '/slaughtergouse';
  static const String orders = '/orders';
}

class AppRouter {
  AppRouter() {
    goRouter = GoRouter(
      initialLocation: PageName.slaughterhouse,
      debugLogDiagnostics: true,
      routes: _routes,
    );
  }

  late GoRouter goRouter;

  final List<RouteBase> _routes = [
    ShellRoute(
      builder: (context, state, child) =>
          SharedScaffold(selectedIndex: 0, body: child),
      routes: [
        GoRoute(
          name: PageName.slaughterhouse,
          path: PagePath.slaughterhouse,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SlaughterhousePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
        GoRoute(
          name: PageName.orders,
          path: PagePath.orders,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const OrdersPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
        ),
      ],
    ),
  ];
}
