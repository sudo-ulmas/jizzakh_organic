import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uboyniy_cex/model/model.dart';
import 'package:uboyniy_cex/presentation/presentation.dart';
import 'package:uboyniy_cex/widget/widget.dart';

abstract class PagePath {
  static const String animals = '/animals';
  static const String orders = '/orders';
  static const String animalDetails = 'animal-details';
  static const String addNomenclature = 'add-nomenclature';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter() {
    goRouter = GoRouter(
      initialLocation: PagePath.animals,
      debugLogDiagnostics: true,
      navigatorKey: _rootNavigatorKey,
      routes: _routes,
    );
  }

  late GoRouter goRouter;

  final List<RouteBase> _routes = [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => SharedScaffold(body: child),
      routes: [
        GoRoute(
          path: PagePath.animals,
          pageBuilder: (context, state) => CustomTransitionPage<void>(
            key: state.pageKey,
            child: const AnimalsPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(opacity: animation, child: child),
          ),
          routes: [
            GoRoute(
              path: PagePath.animalDetails,
              builder: (context, state) =>
                  AnimalDetailsPage(animal: state.extra! as AnimalModel),
            ),
            GoRoute(
              path: PagePath.addNomenclature,
              builder: (context, state) => const AddNomenclaturePage(),
            )
          ],
        ),
        GoRoute(
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
